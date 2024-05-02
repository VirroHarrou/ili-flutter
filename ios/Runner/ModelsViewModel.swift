import Foundation

class ModelsViewModel: ObservableObject {
    @Published var models: [Model] = [Model(name: "frame (1)", category: ModelCategory.chair, scaleCompensation: 1.0)]
    
    func fetchData(path: String) {
        self.models.first?.path = path
    }
    
//    private let db = Firestore.firestore()
//    
//    func fetchData() {
//        db.collection("models").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("Firestore: No documents.")
//                return
//            }
//            
//            self.models = documents.map { (queryDocumentSnapshot) -> Model in
//                let data = queryDocumentSnapshot.data()
//                
//                let name = data["name"] as? String ?? ""
//                let categoryText = data["category"] as? String ?? ""
//                let category = ModelCategory(rawValue: categoryText) ?? .decor
//                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0
//                
//                return Model(name: name, category: category, scaleCompensation: Float(scaleCompensation))
//            }
//        }
//    }
    
    func clearModelEntitiesFromMemory() {
        for model in models {
            model.modelEntity = nil
        }
    }
}
