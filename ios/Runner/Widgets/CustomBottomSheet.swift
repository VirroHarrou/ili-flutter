import SwiftUI

struct CustomBottomSheet: View {
    
    @State private var progress: Double = 0
      private let total: Double = 1

      @State private var dataTask: URLSessionDataTask?
      @State private var observation: NSKeyValueObservation?
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    
    @State private var isExists: Bool = false
    
    private func downloadModel() {
        guard let url = URL(string: self.placementSettings.customModel!.valueUrlUSDZ) else { return }
        
        var request = URLRequest(url: url)
        //request.httpMethod = method.rawValue
//        request.setValue(
//            "application/json",
//            forHTTPHeaderField: "Content-Type"
//        )
//
//        request.setValue(
//            "Bearer \(access_token)",
//            forHTTPHeaderField: "Authorization"
//        )

        dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
          guard let data = data else { return }
            guard let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                    print("Error finding documents directory")
                    return
                }
                
            let fileURL = documentsDirectory.appendingPathComponent("\(self.placementSettings.customModel!.id).usdz")
                
                do {
                    try data.write(to: fileURL)
                    DispatchQueue.main.async {
                        self.placementSettings.customType = .place
                        self.placementSettings.isPresented = false
                        self.placementSettings.path = fileURL.path
                    }
                } catch {
                    print("Error saving file: \(error.localizedDescription)")
                }
        }
        observation = dataTask?.progress.observe(\.fractionCompleted) { observationProgress, _ in
          DispatchQueue.main.async {
            progress = observationProgress.fractionCompleted
          }
        }
        dataTask?.resume()
      }

      private func reset() {
        observation?.invalidate()
        dataTask?.cancel()
        progress = 0
      }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 8)
            HStack {
                Spacer()
                ZStack {}
                    .frame(
                        width: 56,
                        height: 6
                    )
                    .background(Color(
                        red: 0.863,
                        green: 0.886,
                        blue: 0.937
                    ))
                    .cornerRadius(3)
                Spacer()
            }
            Spacer()
                .frame(height: 18)
            Text(
                self.placementSettings.customModel?.title ?? ""
            )
            .font(.system(
                size: 20,
                weight: .semibold
            ))
            .foregroundStyle(Color(
                red: 0.149,
                green: 0.153,
                blue: 0.196
            ))
            Spacer()
                .frame(height: 16)
            Text(
                self.placementSettings.customModel?.description ?? ""
            )
            .font(.system(
                size: 18,
                weight: .regular
            ))
            .foregroundStyle(Color(
                red: 0.149,
                green: 0.153,
                blue: 0.196
            ))
            if !self.placementSettings.customModel!.valueUrlUSDZ.isEmpty {
                ZStack {
                    ProgressView("Downloading image...", value: progress, total: total)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(
                            red: 0.863,
                            green: 0.886,
                            blue: 0.937
                        )))
                      .padding()
                }
                HStack {
                  Spacer()
                    Button(action: {
                        if isExists {
                            guard let documentsDirectory = FileManager.default.urls(
                                for: .documentDirectory,
                                in: .userDomainMask
                            ).first else {
                                    print("Error finding documents directory")
                                    return
                                }
                                
                            let fileURL = documentsDirectory.appendingPathComponent("\(self.placementSettings.customModel!.id).usdz")
                            self.placementSettings.customType = .place
                            self.placementSettings.isPresented = false
                            self.placementSettings.path = fileURL.path
                        }
                        else {
                            downloadModel()
                        }
                            }) {
                                HStack {
                                    Image(
                                        systemName: isExists ? "plus" : "arrow.down.square.fill"
                                    )
                                    .foregroundStyle(.white)
                                    Spacer()
                                        .frame(width: 8)
                                    Text(
                                        isExists ? "Добавить" : "Скачать"
                                    )
                                    .font(.system(
                                        size: 16,
                                        weight: .medium
                                    ))
                                    .foregroundStyle(.white)
                                }
                            }
                            .padding(
                                [.vertical],
                                13
                            )
                            .padding(
                                [.horizontal],
                                23
                            )
                            .frame(
                              width: 160,
                              height: 48
                            )
                            .background(Color(
                              red: 0.149,
                              green: 0.153,
                              blue: 0.196
                          ))
                            .cornerRadius(24)
                }
            }
            Spacer()
            }
        .padding(
          [.horizontal],
          20
        )
        .background(.white)
        .onAppear {
            guard let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                    print("Error finding documents directory")
                    return
                }
                
            let fileURL = documentsDirectory.appendingPathComponent("\(self.placementSettings.customModel!.id).usdz")
            
            let filePath = fileURL.path
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: filePath) {
                        isExists = true
                    } else {
                        isExists = false
                    }
        }
    }
}
