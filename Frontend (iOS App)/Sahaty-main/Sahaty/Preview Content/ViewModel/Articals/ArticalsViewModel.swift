import Foundation
import SwiftUI
import Combine

class ArticalsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var articals: [ArticleModel] = []
    @Published var doctorsArticals : [ArticleModel] = []
    @Published var filteredArticals: [ArticleModel] = []
    @Published var savedArticals : [ArticleModel] = []
    @Published var article : ArticleModel = ArticleModel()
    @Published var loadedImages: [Int: UIImage] = [:]
    @Published var doctorImages: [Int: UIImage] = [:]
    @Published var actionLike: [Int: Bool] = [0 : false]
    @Published var actionSaved: [Int: Bool] = [0:false]
    @Published var showAlert: Bool = false
    @Published var isLodeing: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var searchText: String = ""
    @Published var addImage: UIImage? = nil
    @Published var articleUpdateImage : UIImage? = nil
    private var cancellables = Set<AnyCancellable>()
    private let imageManager = ImageManager.shared

    var isSearching: Bool {
        !searchText.isEmpty
    }

    init() {
        addSubscribers()
    }
    
    // MARK: - Manage Search
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterRestaurants(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    private func filterRestaurants(searchText: String) {
        guard !searchText.isEmpty else {
            filteredArticals = []
            return
        }
        
        // Filter on search text
        let search = searchText.lowercased()
        filteredArticals = articals.filter({ articals in
            let titleContainsSearch = articals.title.lowercased().contains(search)
            let subjectContainsSearch = articals.subject.lowercased().contains(search)
            let doctorNameContainsSearch = articals.doctor.name.lowercased().contains(search)

            return titleContainsSearch || subjectContainsSearch || doctorNameContainsSearch
        })
    }

    // MARK: - Fetch Article
    func fetchArtical(isDoctor: Bool){
        isLodeing = true
        APIManager.shared.sendRequest(endpoint:  isDoctor ? "/doctor/articles" : "/articles", method: .get) {result in
            switch result {
            case .success(let data) :
               print("get data success")
                guard let decodeData = try? JSONDecoder().decode(responseArticals.self, from: data) else {
                    print("error to decode data!!!!")
                    return
                }
                print("success to decode data \(decodeData.data)")
                DispatchQueue.main.async { [weak self] in
                    self?.isLodeing = false
                    self?.articals = decodeData.data
                    print("var Articals\(decodeData.data)")
                }
                print("fetch Articals successfully")

                
            case .failure(let error) :
                print("error to get data:\(error)")
            }
        }
    }
    
    func fetchArticalsDoctors(){
        isLodeing = true
        APIManager.shared.sendRequest(endpoint:"/doctors-articles", method: .get) {result in
            switch result {
            case .success(let data) :
               print("get data success")
                guard let decodeData = try? JSONDecoder().decode(responseArticals.self, from: data) else {
                    print("error to decode data!!!!")
                    return
                }
                print("success to decode data \(decodeData.data)")
                DispatchQueue.main.async { [weak self] in
                    self?.isLodeing = false
                    self?.doctorsArticals = decodeData.data
                    print("var Articals\(decodeData.data)")
                }
                print("fetch Articals successfully")

                
            case .failure(let error) :
                print("error to get data:\(error)")
            }
        }
    }
    
    // MARK: - fetch Artical Saved
    func fetchArticalSaved(){
        isLodeing = true
        APIManager.shared.sendRequest(endpoint: "/articles/saved", method: .get) {result in
            switch result {
            case .success(let data) :
               print("get data success")
                guard let decodeData = try? JSONDecoder().decode(responseArticals.self, from: data) else {
                    print("error to decode data!!!!")
                    return
                }
                print("success to decode data \(decodeData.data)")
                DispatchQueue.main.async { [weak self] in
                    self?.isLodeing = false
                    self?.savedArticals = decodeData.data
                    print("var Articals\(decodeData.data)")
                }
                print("fetch Articals successfully")

                
            case .failure(let error) :
                print("error to get data:\(error)")
            }
        }
    }
    
    // MARK: - Add Article
    func addArtical(artical : ArticleModel , completion : @escaping (Bool)-> Void){
        isLodeing = true
        guard let  url = URL(string: "http://127.0.0.1:8000/api/doctor/article/store") else {
            print("url error!")
            completion(false)
            return
        }
        let method = "POST"
        
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method
            let boundary = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        if let token = APIManager.shared.bearerToken {
            print("Bearer Token being sent: \(token)")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }else{
            print("error Bearer Token")
        }
        
        if let image = self.addImage {
            let httpBody = APIManager.shared.createMultipartBody(
                parameters: ["title": artical.title, "subject": artical.subject],
                image: image,
                boundary: boundary
            )
            urlRequest.httpBody = httpBody
        }else{
           print("not found image!!!")
        }
        
     
        let task = URLSession.shared.dataTask(with: urlRequest){data, response, error in
            
            DispatchQueue.main.async {
//                [weak self] in
                if let error  = error {
                    print("error in request URLSession : \(error)")
                    completion(false)
                    return
                }
                guard let data = data else {
                    print("error in request data")
                    completion(false)
                 
                    return
                }
                self.article.subject = ""
                self.article.title = ""
                self.addImage = nil
                
                completion(true)
//                guard let decodeData = try? JSONDecoder().decode(ArticleModel.self, from: data) else {
//                    print("error to decode data!!!")
//                    return
//                }
                print("successfully added artical  in server :\(data)")
//                self?.articals.append(decodeData)

            }
        }
        task.resume()
        
        

    }
    
    // MARK: - update Article
    func updateArtical(artical : ArticleModel , completion : @escaping (Bool) -> Void) {
        self.isLodeing = true
        APIManager.shared.sendRequest(
            endpoint: "/doctor/article/\(artical.id)/update",
            method: .post,
            parameters:["title":artical.title,
                        "subject" : artical.subject
                       ]
        ) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLodeing = false
                switch result{
                    case .success(let data):
                    completion(true)
                    self?.alertMessage = "update artical successfully"
                   if let index = self?.articals.firstIndex(where: {$0.id == artical.id}){
                        self?.articals[index] = artical
                   }else{
                       print("eror to set artical in array !!")
                   }
                    print("update artical successfully:\(data)")
                    case .failure(let error) :
                    completion(false)
                    self?.alertMessage = "update artical successfully"
                    print("eror update artical : \(error)")
                }
                }
        }
        
    }
    
    // MARK: - Delete Article
    func deleteAdvice(id : Int) {
        self.isLodeing = true
        APIManager.shared.sendRequest(endpoint: "/doctor/article/delete/\(id)", method: .delete) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLodeing = false
                switch result {
                case .success(_):
                    print("Delete Successfully")
                    self?.alertMessage = "Deleted Successfully"
                    self?.articals.removeAll { $0.id == id }
                case .failure(let error):
                    print("error to delete:\(error)")
                }
                
            }
        }
    }
    
    
    // MARK: - Save Article
    func savedArtical(id : Int) {
        self.isLodeing = true
        APIManager.shared.sendRequest(endpoint: "/article/\(id)/save", method: .post) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLodeing = false
                switch result {
                case .success(let data):
                    print("artical is saved")
                    guard let  decodedData = try? JSONDecoder().decode(ResopnseSavedAction.self, from: data)else {
                         print("error to decode like Artical")
                        return
                    }
                    print("success saved article data \(id):\(decodedData.message)")
                    self?.actionSaved[id] = decodedData.saved
                case .failure(let error) :
                    print("error to save artical:\(error)")
                }
            }
        }
    }
    
    
    // MARK: - like Article
    func likeArtical(id : Int){
        self.isLodeing = true
        APIManager.shared.sendRequest(endpoint: "/article/\(id)/like", method: .post) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLodeing = false
                switch result {
                case .success(let data):
                    print("artical is liked")
                    guard let  decodedData = try? JSONDecoder().decode(ResopnseLikeAction.self, from: data)else {
                         print("error to decode like Artical")
                        return
                    }
                    print("success liked article data \(id):\(decodedData.message)")
                    self?.actionLike[id] = decodedData.like
                                    
                case .failure(let error) :
                    print("error to like artical:\(error)")
                }
            }
        }
    }

    
    // MARK: - Manage Image
    func updateArticalImage(newImage: UIImage,articleId : Int) {
        let uploadURL = "http://127.0.0.1:8000/api/doctor/article/\(articleId)/update-img"
        isLoading = true
        imageManager.uploadImage(image: newImage, url: uploadURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    self?.loadedImages[articleId] = self?.articleUpdateImage
                    self?.articleUpdateImage = nil
                    print("susses update image  in loadImage")
                case .failure(let error):
                    print("error update image  in loadImage :\(error)")
                }
            }
        }
    }

    func loadImages(from path: String, for articleId: Int) {
        ImageManager.shared.fetchImage(imagePath: path) { image in
            DispatchQueue.main.async { [weak self] in
                self?.loadedImages[articleId] = image
            }
        }
    }
    
    func doctorImage(from path: String,for doctorId: Int) {
        ImageManager.shared.fetchImage(imagePath: path) { image in
            DispatchQueue.main.async {[weak self] in
                self?.doctorImages[doctorId] = image
            }
        }
    }
}





struct ResopnseLikeAction : Codable {
    var message : String
    var like : Bool
}

struct ResopnseSavedAction : Codable {
    var message : String
    var saved : Bool
}



