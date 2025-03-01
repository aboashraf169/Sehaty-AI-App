import SwiftUI

struct FotterArtical: View {
    @State private var showCommentView = false
    @State private var showShereSheet = false
    var type : UsersType
    @State var showSavedButton = false
    @State var articleViewModel : ArticalsViewModel
    @State var id : Int
    @StateObject var commentsViewModel = CommentViewModel()
    var articleModel: ArticleModel
    @AppStorage("appLanguage") private var appLanguage = "ar"

    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                
                // زر الإعجاب
                Button {
                articleViewModel.likeArtical(id: self.id)
                    articleViewModel.fetchArtical(isDoctor:  type == .doctor ? true : false)
                } label: {
                    HStack {
                        Image(systemName: articleViewModel.actionLike[self.id] ?? false ? "heart.fill" : "heart")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(articleViewModel.actionLike[self.id]  ?? false ? .accent : .primary)
                        Text("\(articleModel.num_likes)")
                            .font(.callout)
                            .fontWeight(.ultraLight)
                    }
                }
                .foregroundStyle(.primary)

                
                // زر عرض التعليقات
                Button {
                    showCommentView.toggle()
                    commentsViewModel.fetchComments(idArtical: id)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "message")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.primary)
                        Text("\(articleModel.num_comments)") // عرض عدد التعليقات
                            .font(.callout)
                            .fontWeight(.ultraLight)
                    }
                }
                .foregroundStyle(.primary)

                
                Spacer()
                // زر المشاركة
                Button {
                    showShereSheet.toggle()
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                }
                .foregroundStyle(.primary)
                
                if type == .patient {
                    // زر الحفظ
                    Button {
                        articleViewModel.savedArtical(id: self.id)
                    } label: {
                        Image(systemName:   articleViewModel.actionSaved[self.id] ?? false ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle( articleViewModel.actionSaved[self.id] ?? false ? .accent : .primary)
                    }
                }
           
                
            }
            
            .padding(.horizontal)
            .actionSheet(isPresented: $showShereSheet) {
                getActionSheet()
            }
            .sheet(isPresented: $showCommentView) {
                AddCommentView(viewModel: commentsViewModel, articalViewModel: articleViewModel, id: id, type: type)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.7)])
            }

            Divider()
            .padding(.top, 5)
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }

    private func getActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("share_action_sheet_title".localized()),
            buttons: [
                .default(Text("share".localized())) {},
                .cancel(Text("cancel".localized()))
            ]
        )
    }
}

#Preview {
    FotterArtical(type: .patient, articleViewModel: ArticalsViewModel(), id: 0, articleModel: ArticleModel())
}
