import SwiftUI
import RealityKit
import Combine
import ARKit

struct ModelAnchor {
    var model: Model
    var anchor: ARAnchor?
}

enum CustomType {
    case scan
    case place
    case model
}

class PlacementSettings: ObservableObject {
    @Published var arView: ARView?
    
    @Published var selectedModel: Model? = nil {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name)).")
        }
    }
    
    @Published var recentlyPlaced: [Model] = []
    @Published var isTextField: Bool = true
    
    @Published var isPresented: Bool = false
    
    @Published var access_token: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var customModel: CustomModel?
    
    @Published var customType: CustomType = .scan
    
    @Published var isTap: Bool = false
    
    @Published var path: String = ""
    
    @Published var isModelAdded: Bool = false

    var modelsConfirmedForPlacement: [ModelAnchor] = []
    var sceneObserver: Cancellable?
    
    @Published var model: Model = Model(name: "1", category: ModelCategory.chair, scaleCompensation: 0.1)
    
    func fetchData(path: String) {
            self.model.path = path
            self.model.asyncLoadModelEntity { completed, error in
                if completed {
                    let modelAnchor = ModelAnchor(model: self.model, anchor: nil)
                    self.modelsConfirmedForPlacement.append(modelAnchor)
                    print("Adding modelAnchor with name: \(self.model.name)")
                }
        }
    }
    
    func makeRequest<Model: Codable>(
        id: String,
        completion: @escaping (Result<Model, Error>) -> Void
    ) {
        let url = URL(string: id.count == 4
                      ? "https://ili-art.space/api/2.0/model/code=\(id)"
                      : "https://ili-art.space/api/2.0/model/id=\(id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            "Bearer \(access_token)",
            forHTTPHeaderField: "Authorization"
        )
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            print("Response url: \(url.absoluteString):")
            print("status code: \(httpResponse?.statusCode)")
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.dataNotAllowed)))
                return
            }
            
            let string = String(data: data, encoding: .utf8)
            print(string)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
