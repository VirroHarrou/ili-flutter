import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    var path: String
    @EnvironmentObject var placementSettings: PlacementSettings
        
    func makeUIView(context: Context) -> ARView {
        
        self.placementSettings.arView = ARView(frame: .zero)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
    
        // Enable sceneReconstruction if the device has a LiDAR Scanner
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        context.coordinator.arView = self.placementSettings.arView!
        self.placementSettings.arView!.session.delegate = context.coordinator
        
        self.placementSettings.arView!.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        self.placementSettings.arView!.addGestureRecognizer(tapGesture)
        
        return self.placementSettings.arView!
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
//        if isModelAdded {
//                    let screenCenter = CGPoint(x: uiView.frame.midX, y: uiView.frame.midY)
//                    let raycastResult = uiView.raycast(
//                        from: screenCenter,
//                        allowing: .estimatedPlane,
//                        alignment: .horizontal
//                    )
//                    
//                    if let firstResult = raycastResult.first {
//                        let newPosition = SIMD3<Float>(
//                            firstResult.worldTransform.columns.3.x,
//                            firstResult.worldTransform.columns.3.y,
//                            firstResult.worldTransform.columns.3.z
//                        )
////                        uiView.scene.anchors.first?.transform.translation = firstResult.worldTransform.translation
//                        
//                        uiView.scene.anchors.first?.position = newPosition
//                    }
//
//                    // Reset the flag to prevent adding the model multiple times
//                    isModelAdded = false
//                }
    }
}

extension ARViewContainer {
    class Coordinator: NSObject, ARSessionDelegate {
        var arView: ARView?
        
        var parent: ARViewContainer

        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            if !self.parent.placementSettings.isTap {
                guard let arView = arView else { return }
                
                if let result = arView.raycast(
                    from: gestureRecognizer.location(in: arView),
                    allowing: .existingPlaneGeometry,
                    alignment: .horizontal
                )
                    .first {
                        let newPosition = SIMD3<Float>(
                            result.worldTransform.columns.3.x,
                            result.worldTransform.columns.3.y,
                            result.worldTransform.columns.3.z
                        )
                                
                    arView.scene.anchors.first?.position = newPosition
                    arView.scene.anchors.first?.scale.x = 5
                    arView.scene.anchors.first?.scale.y = 5
                    arView.scene.anchors.first?.scale.z = 5
                }
            }
        }

        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            
            guard let arView = arView else { return }
            
            if arView.scene.anchors.isEmpty {
                for anchor in anchors {
                    if anchor is ARPlaneAnchor {
                        let modelEntity = try! ModelEntity.loadModel(contentsOf: URL(fileURLWithPath: self.parent.path))
                        
                        modelEntity.generateCollisionShapes(recursive: true)
                        
                        modelEntity.scale *= 0.5
                        
                        print(modelEntity.availableAnimations)
                        
                        if !modelEntity.availableAnimations.isEmpty {
                            modelEntity.playAnimation(
                                modelEntity.availableAnimations.first!.repeat(duration: .infinity),
                                transitionDuration: 1.25,
                                startsPaused: false
                            )
                        }
                        
                        let anchorEntity = AnchorEntity(world: [0, 0, -1])
                        anchorEntity.addChild(modelEntity)
                        
                        print(anchorEntity.availableAnimations)
                        
                        arView.installGestures([.all], for: modelEntity)

                        arView.scene.addAnchor(anchorEntity)

                        break
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
