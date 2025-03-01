import SwiftUI

struct DoctorHomeScreen: View {
    
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق
    
    var currentUser:String =  ""
    
    @ObservedObject var adviceViewModel: AdviceViewModel
    @ObservedObject var articlesViewModel: ArticalsViewModel
    @ObservedObject var doctorProfileViewModel: DoctorProfileViewModel
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false
    @State private var selectedArticle: ArticleModel? = nil
    @State private var showEditArticleSheet = false
    @State private var showEditAdviceView: Bool = false

    
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    
    var body: some View {
        
        NavigationStack {
            VStack {
                // MARK: - Header Section
                HeaderHomeSectionView(
                    doctorProfileViewModel: doctorProfileViewModel,
                    onProfileTap:{
                        appState.selectedTabDoctors = .profile
                        print("تم النقر على صورة المستخدم (الدكتور)")
                    },
                    onAddTap:{
                        showAddArticleView.toggle()
                        print("تم النقر على زر الإضافة (الدكتور)")
                    }
                )
                
                // MARK: - Advice Section
                adviceSection
                
                // MARK: - Articles Section
                articlesSection
                
//                Spacer()
                           
                HStack {
                    FloatingChatButton()
                        .padding(.bottom,10)
                    Spacer()
                }.zIndex(0)
            
            }
        
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .preferredColorScheme(doctorProfileViewModel.isDarkModeDoctor ? .dark : .light)
        .onAppear{
            adviceViewModel.fetchAdvices()
            articlesViewModel.fetchArticalsDoctors()
            doctorProfileViewModel.getInfoData()
        }

    }
    
    // MARK: - Advice Section
    private var adviceSection: some View {
        VStack(alignment: .leading) {
            // العنوان وزر الإضافة
            HStack {
                Text("daily_advices".localized())
                    .font(.headline)
                    .fontWeight(.regular)
                
                Spacer()
                
                Button {
                    showAddAdviceView.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.accent)
                }
                .sheet(isPresented: $showAddAdviceView) {
                    AddAdviceSheetView(adviceViewModel: adviceViewModel)
                        .presentationDetents([.fraction(0.45)]) // نسبة العرض
                        .presentationCornerRadius(30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // عرض النصائح
            if adviceViewModel.doctorAdvices.isEmpty {
                // في حال عدم وجود نصائح
                HStack {
                    Text("no_advices".localized())
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(20)
            } else {
                // في حال وجود نصائح
                List{
                    ForEach(adviceViewModel.doctorAdvices) { advice in
                        AdviceView(advice: advice)
                            .swipeActions(edge:.leading) {
                                Button(role: .destructive)
                                {
                                adviceViewModel.deleteAdvice(
                                    at: IndexSet(integer:
                                                    adviceViewModel.doctorAdvices.firstIndex(where: {$0.id == advice.id}) ?? 0)
                                    )
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .tint(.red)
                                }
                                Button {
                                    showEditAdviceView = true
                                    adviceViewModel.selectedAdvice = advice
                                    print("Selected advice")
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        
                    }
                }
//                .listStyle()
                .frame(maxHeight: 100)

            }
        }
        .sheet(isPresented: $showEditAdviceView) {
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

    }

    // MARK: - Articles Section
    private var articlesSection: some View {
        VStack {
            HStack {
                Text("new_articles")
                    .font(.headline)
                    .fontWeight(.regular)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .padding(.top, 15)
            .sheet(isPresented: $showAddArticleView) {
                AddArticleSheetView(articalsViewModel: articlesViewModel)
                    .presentationCornerRadius(30)
            }
            
            if articlesViewModel.doctorsArticals.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    Image("noArtical")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .foregroundColor(.gray.opacity(0.7))
                    Text("no_articles".localized())
                        .font(.title2)
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    Spacer()
                    
                }
            }else {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 12) {
                        ForEach(articlesViewModel.doctorsArticals) { article in
                            ArticleView(
                                articleModel: article,
                                articalViewModel: articlesViewModel,
                                usersType: .patient, pathImgArtical: article.img ?? "",pathImgDoctor: article.doctor.img ?? ""
                            )
                        }
                    }
                }
            }
        }    }
    
    
}
#Preview {
    DoctorHomeScreen(adviceViewModel: AdviceViewModel(), articlesViewModel: ArticalsViewModel(), doctorProfileViewModel: DoctorProfileViewModel())
}
