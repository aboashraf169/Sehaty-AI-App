//
//  AddArticleSheetView 2.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//


import SwiftUI
import PhotosUI


struct EditArticleSheetView: View {
    @ObservedObject var articalsViewModel: ArticalsViewModel
    @State var article: ArticleModel
    @Environment(\.dismiss) private var dismiss
    @State var ShowImagePicker: Bool = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack {
            // MARK: - Header Section
            VStack(spacing: 10) {
                Text("edit_article".localized())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("fill_EditFields_for_article".localized())
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)

            // MARK: - Article Text Section
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Image(systemName: "character.book.closed")
                    Text("title".localized())
                    Spacer()
                }

                TextEditor(text: $article.title)
                    .frame(height: 40)
                    .padding(10)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
                
                HStack {
                    Image(systemName: "text.book.closed")
                    Text("topic".localized())
                    Spacer()
                }

                TextEditor(text: $article.subject)
                    .frame(height: 120)
                    .padding(10)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            .padding(.vertical,10)
            
            // MARK: - Upload Image Section
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Image(systemName: "icloud.and.arrow.up")
                        .font(.title2)
                        .tint(.secondary)
                    Text("upload_image".localized())
                        .tint(.black)
                    Spacer()
                  
                }

                HStack {
                    Button(action: {
                        ShowImagePicker.toggle()
                    }) {
                        HStack {
                            Text("choose_image".localized())
                                  .font(.headline)
                            Image(systemName: "icloud.and.arrow.up")
                                  .font(.title3)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                }

                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.secondary)
                        .frame(height: 170)
                        .overlay {
                            VStack {
                                if let imageSelected = articalsViewModel.articleUpdateImage {
                                    Image(uiImage: imageSelected)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                        .cornerRadius(10)
                                        .padding()
                                }else {
                                    Image(systemName: "photo.on.rectangle")
                                         .font(.largeTitle)
                                         .foregroundColor(.secondary)
                                    Text("no_image_selected".localized())
                                         .font(.subheadline)
                                         .foregroundColor(.secondary)
                                }
                            }
                        }
                
            }
            .padding(.horizontal)
            .padding(.vertical,10)


            Spacer()

            // MARK: - Publish Button
            Button(action: {
                articalsViewModel.updateArtical(artical: article){ result in
                    print(result)
                    print("article successfully added")
                }
                articalsViewModel.updateArticalImage(newImage: articalsViewModel.articleUpdateImage ?? UIImage.onboarding2, articleId: article.id)
                dismiss()
            }){
                Text("save_changes".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .alert(isPresented: $articalsViewModel.showAlert) {
            Alert(
                title: Text(articalsViewModel.alertTitle),
                message: Text(articalsViewModel.alertMessage),
                dismissButton: .default(Text("ok".localized()))
            )
        }
        .padding(.top)
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .sheet(isPresented: $ShowImagePicker) {
            ImagePicker(selectedImage: $articalsViewModel.articleUpdateImage, onImagePicked: {_ in})
        }
    }
}

#Preview {
    EditArticleSheetView(articalsViewModel: ArticalsViewModel(), article: ArticleModel())
}
