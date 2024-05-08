import Foundation

class ModelsViewModel: ObservableObject {
    @Published var model: Model = Model(name: "1", category: ModelCategory.chair, scaleCompensation: 0.1)
    
    func fetchData(path: String) {
        self.model.path = path
        self.model.asyncLoadModelEntity { completed, error in
        }
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
}
