import Foundation
import SwiftUI
class CommentViewModel: ObservableObject {
    @Published var comments: [CommentModel] = []
    @Published var comment: CommentModel = CommentModel()
    @Published var authersCommentImages: [Int: UIImage] = [:]
    @Published var autherCommentImage: UIImage? = nil
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var newCommentText : String = ""
    
    
    // MARK: - Fetch Comments
    func fetchComments(idArtical : Int) {
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/article/\(idArtical)/comments", method: .get) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                    case .success(let data):
                    print("get comment artical \(idArtical) successfully!")
                    guard let decodeData = try? JSONDecoder().decode([CommentModel].self, from: data) else {
                        print("error to decode comment")
                        return
                    }
                        self?.alertMessage = "\(decodeData)"
                        self?.comments = decodeData
                    print("added comment artical \(idArtical) successfully in array")
                    case .failure(let error):
                        print("error to get comment artical:\(idArtical)")
                        print("error: get comment:\(error)")
                        self?.alertMessage = "\(error)"
                }
            }
        }
    }
    
    
    // MARK: - Add Comment
    func addComment(idArtical: Int, comment: String) {
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/article/\(idArtical)/comment/store" , method: .post, parameters: ["comment": comment]) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let data):
                    print("add comment artical \(idArtical) successfully!")
                    self?.comment.comment = ""
                    guard let decodeData = try? JSONDecoder().decode(DataComment.self, from: data) else {
                    print("error to decode comment")
                    return
                }
                    self?.alertMessage = "\(decodeData)"
                    self?.comments.append(decodeData.data)
//                    self?.loadImage(from: decodeData.data.user.img ?? "")
                case .failure(let error):
                    print("error to get comment artical:\(idArtical)")
                    print("error: get comment:\(error)")
                    self?.alertMessage = "\(error)"
                }
            }
        }
    }
    
    
    // MARK: - Delete Comment
    func deleteComment(idComment: Int) {
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/comment/\(idComment)/destroy", method: .delete) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(_):
                    print("delete comment artical \(idComment) successfully!")
                    self?.comments.removeAll(where: { $0.id == idComment })
                case.failure(let error):
                    print("error to delete comment artical:\(error)")
                }
            }
        }
    }
    // MARK: - Load image
//    func loadImage(from path: String) {
//        ImageManager.shared.fetchImage(imagePath: path){[weak self] image in
//            DispatchQueue.main.async {
//                self?.autherCommentImage = image
//                print("image auther Comment : \(path)")
//            }
//        }
//    }
    // MARK: - Load images
    func loadImages(from path: String, for commentId: Int) {
        ImageManager.shared.fetchImage(imagePath: path) { image in
            DispatchQueue.main.async { [weak self] in
                self?.authersCommentImages[commentId] = image
            }
        }
    }
}


