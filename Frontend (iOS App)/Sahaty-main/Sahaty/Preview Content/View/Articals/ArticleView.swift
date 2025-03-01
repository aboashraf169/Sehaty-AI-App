//
//  SwiftUIView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI


struct ArticleView: View {
    var articleModel: ArticleModel
    @ObservedObject var articalViewModel : ArticalsViewModel
    var usersType: UsersType
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @AppStorage("appLanguage") private var appLanguage = "ar"
    var pathImgArtical : String
    var pathImgDoctor : String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // صورة صاحب المنشور
                if let image = articalViewModel.doctorImages[articleModel.doctor.id]{
                    Image(uiImage:image)
                        .resizable()
                        .scaledToFill()
                        .shadow(radius: 2)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 2)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .foregroundStyle(.accent)
                        .clipShape(Circle())
                }
                
                // بيانات صاحب المنشور
                VStack(alignment: .leading) {
                    HStack {
                        Text(articleModel.doctor.name)
                            .font(.headline)
                            .fontWeight(.regular)
                        Text(articleModel.created_at)
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    Text(articleModel.doctor.email)
                        .font(.subheadline)
                        .fontWeight(.light)
                    .opacity(0.6)
                }
                .padding(.horizontal, 5)
                Spacer()
                if usersType == .doctor {
                    // زر الحذف
                    Button(role: .destructive) {
                        showDeleteAlert.toggle() // عرض التنبيه عند الحذف
                    } label: {
                            Label("", systemImage: "trash")
                    }
                .fontWeight(.ultraLight)
                .foregroundStyle(.primary)
                .alert("delete_article".localized(), isPresented: $showDeleteAlert) {
                    Button("confirm".localized(), role: .destructive) {
                        articalViewModel.deleteAdvice(id: articleModel.id)
                    }
                    Button("cancel".localized(), role: .cancel) {}
                }message:{
                    Text("delete_article_confirmation".localized())
                       }
                   
                    // زر التعديل
                        Button {
                            showEditSheet.toggle() // عرض شاشة التعديل
                        } label: {
                            Label("", systemImage: "pencil.line")
                        }
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.primary)
                        .padding(.leading)
                }
            }

            // وصف المنشور
            HStack {
                Text(articleModel.title)
                    .font(.title3)
                    .fontWeight(.light)
                Spacer()
            }
            
            Text(articleModel.subject)
                .font(.callout)
                .fontWeight(.light)
        
            if let image = articalViewModel.loadedImages[articleModel.id] {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .foregroundStyle(Color(.systemGray6)).opacity(0.4)
                    .cornerRadius(10)
                    .overlay {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
            }
        
            FotterArtical(type: usersType, articleViewModel: articalViewModel, id: articleModel.id, articleModel: articleModel)

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .sheet(isPresented: $showEditSheet) {
            EditArticleSheetView(articalsViewModel: articalViewModel, article: articleModel)
        }
        .onAppear{
            articalViewModel.loadImages(from: pathImgArtical, for: articleModel.id)
            articalViewModel.doctorImage(from: pathImgDoctor, for: articleModel.doctor.id)
        }
    }
}

#Preview {
    ArticleView(articleModel: ArticleModel(id: 0, title: "كيفية الوقاية من أمراض القلب", subject: "تتعدد طرق الوقاية من أمراض القلب مثل تقليل التوتر، تناول غذاء صحي غني بالألياف، ممارسة الرياضة بانتظام، والحفاظ على وزن صحي. يجب على الأشخاص الذين لديهم تاريخ عائلي لأمراض القلب أن يتابعوا فحوصاتهم الطبية بشكل دوري.", img: nil, doctor: ArticleDoctor(id: 1, name: "احمد ماهر معين الحناوي", email: "mido@gmail.com", img: "post2")), articalViewModel: ArticalsViewModel(), usersType: .doctor, pathImgArtical: "", pathImgDoctor: "")
}

