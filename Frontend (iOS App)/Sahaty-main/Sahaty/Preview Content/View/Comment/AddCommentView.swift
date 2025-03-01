import SwiftUI

struct AddCommentView: View {
    @ObservedObject  var viewModel : CommentViewModel
    @ObservedObject var articalViewModel : ArticalsViewModel
    @State var id : Int
    var type : UsersType
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @State var showAlert = false
    let currentUserID = UserDefaults.standard.integer(forKey: "currentUserID")

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment, viewModel: viewModel, pathImgComment: comment.user.img ?? "")
                            .swipeActions(edge: .leading) {
                                if comment.user.id == currentUserID{
                                    Button("delete", role: .destructive) {
                                        viewModel.deleteComment(idComment: comment.id)
                                    }
                                }
                            }
                    }
                }
                
                HStack {
                    TextField("add_comment_placeholder".localized(), text: $viewModel.comment.comment)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        viewModel.addComment(idArtical: id, comment: viewModel.comment.comment)
                        articalViewModel.fetchArtical(isDoctor:  type == .doctor ? true : false)

                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.accentColor)
                            .background(
                                Rectangle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color(.systemGray6))
                                    .cornerRadius(10)
                            )
                            .padding(.horizontal)
                    }


               
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
            }
            .navigationTitle("comments".localized())
            .navigationBarTitleDisplayMode(.inline)
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
        }
    }
}



#Preview {
    AddCommentView(viewModel: CommentViewModel(), articalViewModel: ArticalsViewModel(), id: 0, type: .doctor)
}
