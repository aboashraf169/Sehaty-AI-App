import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    @ObservedObject var adviceViewModel : AdviceViewModel
    @ObservedObject var articalViewModel : ArticalsViewModel
    @State private var isEditingBio = false
    @State private var editedBio: String = ""
    @State private var showImagePicker = false
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showAllAdvices = false
    @State private var showAllArticles = false
    @State private var showAlert = false
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Header Section
                    ProfileHeaderView(viewModel: viewModel)
                    
                    // Doctor Statistics
                    DoctorStatisticsView(viewModel: viewModel)
                    
                    // Bio Section
                    BioSectionView(
                        isEditingBio: $isEditingBio,
                        editedBio: $editedBio,
                        biography: viewModel.doctor.bio,
                        onSave: {
                            viewModel.doctor.bio = editedBio
                            viewModel.updateData(UpdateData: viewModel.doctor) { result in
                                if result {
                                    showAlert = true
                                    print("updated successfly")
                                }else{
                                    print("not update data")
                                }
                            }
                            viewModel.doctor.bio = editedBio
                            isEditingBio = false
                        }
                    )
                    .alert(viewModel.successMessage, isPresented: $showAlert) {
                        Button("الغاء",role: .cancel){
                        }
                    }
                    
                    Divider()
                    // Advice Section
                    AdviceSectionView(adviceViewModel: adviceViewModel, showAllAdvices: $showAllAdvices)
                    
                    Divider()
                    // Articles Section
                    ArticlesSectionView(viewModel: viewModel, articalViewModel: articalViewModel, showAllArticles: $showAllArticles)
                    
                    
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("الملف الشخصي")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedImageItem) { _, newValue in
            }
            // Navigate to All Advices
            .sheet(isPresented: $showAllAdvices) {
                AllAdvicesView(adviceViewModel: AdviceViewModel())
                
            }
            // Navigate to All Articles
            .sheet(isPresented: $showAllArticles) {
                AllArticlesView(articalViewModel: articalViewModel)
            }
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .preferredColorScheme(viewModel.isDarkModeDoctor ? .dark : .light)
        .onAppear{
            articalViewModel.fetchArtical(isDoctor: true)
        }
      
    }
    

}


// MARK: - AdviceSectionView
struct AdviceSectionView: View {
    @ObservedObject var adviceViewModel = AdviceViewModel()
    @Binding var showAllAdvices: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Advices".localized())
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAllAdvices.toggle()
                }) {
                    Text("Show All")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
     
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(adviceViewModel.userAdvices) { advice in
                        AdviceView(advice: advice)
                            .frame(width: 300, height: 80)
                    }
                }
            }
        }
        .onAppear{
            adviceViewModel.fetchAdvices()
        }
    }
}

// MARK: - AllArticlesView
struct AllArticlesView: View {
    @ObservedObject var articalViewModel : ArticalsViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(articalViewModel.articals) { article in
                        ArticleView(articleModel: article, articalViewModel: articalViewModel, usersType: .doctor,pathImgArtical: article.img ?? "",pathImgDoctor: article.doctor.img ?? "")
                    }
                }
            }
            .navigationTitle("all_artical".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
       
    }
}

// MARK: - ArticlesSectionView
struct ArticlesSectionView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    @ObservedObject var articalViewModel : ArticalsViewModel
    @Binding var showAllArticles: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Articles".localized())
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAllArticles.toggle()
                }) {
                    Text("Show All".localized())
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
        
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(articalViewModel.articals) { article in
                        ArticleView(
                            articleModel: article,
                            articalViewModel: articalViewModel,
                            usersType: .doctor, pathImgArtical: article.img ?? "",pathImgDoctor: article.doctor.img ?? ""
                        )
                    }
                }
            }
        }
    }
}

// MARK: - AllAdvicesView
struct AllAdvicesView: View {
    @ObservedObject var adviceViewModel : AdviceViewModel
    @State private var showAddAdviceSheet = false // عرض شاشة الإضافة/التعديل
    @State private var showEditAdviceSheet = false // عرض شاشة الإضافة/التعديل
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    var body: some View {
        NavigationStack {
            List{
                ForEach(adviceViewModel.doctorAdvices) { advice in
                    AdviceView(advice: advice)
                        .swipeActions(edge:.leading) {
                            Button(role: .destructive)
                            {
                                adviceViewModel.deleteAdvice(at: IndexSet(integer: adviceViewModel.doctorAdvices.firstIndex(where: {$0.id == advice.id})!)
                                )
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button(){
                                adviceViewModel.selectedAdvice = advice
                                self.showEditAdviceSheet = true
                            }label:{
                                Label("Edit",systemImage: "pencil")
                            }
                            .tint(Color.blue)
                        }
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
                .navigationTitle("all_advice".localized())
                .navigationBarTitleDisplayMode(.inline)

        }
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة

        .sheet(isPresented: $showEditAdviceSheet) {
            if let selectedAdvice =  adviceViewModel.selectedAdvice {
                EditAdviceSheetView(advice: selectedAdvice,onSave: { advice in
                adviceViewModel.updateAdvice(advice: advice) { success in
                                print("advice successfully update : \(advice)")
                                if success {
                                    adviceViewModel.fetchAdvices() // تحديث القائمة
                                }else{
                                    print("advice error update")
                                }
                            }
                        })
                        .presentationDetents([.fraction(0.45)])
                        .presentationCornerRadius(30)
                    
            }
            }
        .onAppear{
            adviceViewModel.fetchAdvices()
        }
    }
}


// MARK: - ProfileHeaderView
struct ProfileHeaderView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    @State var showImagePicker: Bool = false
    
    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                if let selectedImage = viewModel.doctorProfileImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.accentColor)
                        .shadow(radius: 5)
                }
               
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(Color.white)
                            .padding(8)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                    .offset(x:  -40, y: 40)
                
            }
            Text(viewModel.doctor.name)
                .font(.headline)
                .fontWeight(.medium)


        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $viewModel.doctorProfileImage, onImagePicked: { image in
                        viewModel.updateProfileImage(newImage: image)
                    })
        }
    }
       
}


// MARK: - DoctorStatisticsView
struct DoctorStatisticsView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    var body: some View {
            HStack(spacing: 20) {
                StatisticView(title: "Followers".localized(), value: "\(viewModel.doctorInfo.number_of_followers)")
                StatisticView(title: "Articles".localized(), value: "\(viewModel.doctorInfo.number_of_articles)")
                StatisticView(title: "Advices".localized(), value: "\(viewModel.doctorInfo.number_of_advice)")
            }
        .onAppear {
            viewModel.getInfoData()
        }
    }
}


// MARK: - StatisticView
struct StatisticView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}


// MARK: - BioSectionView
struct BioSectionView: View {
    @Binding var isEditingBio: Bool
    @Binding var editedBio: String
    var biography: String?
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                
                Text("Bio".localized())
                    .font(.headline)
                Spacer()
                if !isEditingBio {
                    Button(action: {
                        editedBio = biography ?? ""
                        isEditingBio.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            if isEditingBio {
                TextEditor(text: $editedBio)
                    .frame(height: 80)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
                
                HStack {
                    Button("Save".localized()) {
                        
                    onSave()

                    }
                    .foregroundColor(.accentColor)

                    Button("Cancel".localized()) {
                        isEditingBio = false
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                Text(biography ?? "noBio".localized())
                    .font(.body)
                    .foregroundColor(.secondary)
            }

        }
        .padding(.horizontal)
        .padding(.top,10)
    }
}



#Preview {
    ProfileView(viewModel: DoctorProfileViewModel(), adviceViewModel: AdviceViewModel(), articalViewModel: ArticalsViewModel())
}

