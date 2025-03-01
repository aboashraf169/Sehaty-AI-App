import SwiftUI

struct PatientHomeScreen: View {
    @ObservedObject  var adviceViewModel: AdviceViewModel
    @ObservedObject  var articlesViewModel: ArticalsViewModel
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @StateObject var specializationViewModel  = SpecializationViewModel()
    @EnvironmentObject var appState: AppState
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @State private var searchText = ""
    @State private var showAllSpecializations = false

    
    var body: some View {
        NavigationStack{
                ZStack(alignment: .bottom){
                    VStack{
                        ScrollView {
                            // MARK: - Daily Advice Section
                            titleCategory(title: "daily_advices".localized())
                            DailyAdviceSection(adviceViewModel: adviceViewModel)
                            
                            
                            // MARK: - Articles Section
                            titleCategory(title: "new_articles".localized())
                            
                     
                                if articlesViewModel.articals.isEmpty {
                                    VStack(spacing: 20) {
                                        Image("noArtical")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 150)
                                            .foregroundColor(.gray.opacity(0.7))
                                        
                                        Text("no_articles".localized())
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 30)
                                        
                                    }
                                } else {
                                    VStack(spacing: 10) {
                                        ForEach(articlesViewModel.isSearching ?  articlesViewModel.filteredArticals : articlesViewModel.articals) {article in
                                            ArticleView(articleModel: article, articalViewModel: articlesViewModel, usersType: .patient,pathImgArtical: article.img ?? "",pathImgDoctor: article.doctor.img ?? "")
                                        }
                                    }
                                
                                
                            
                            }
                    
                       
                            //  .padding(.horizontal,10)
                            //  .background(Color.red)
                            
                        }

                    }
                    HStack {
                        FloatingChatButton()
                            .padding(.bottom,10)
                            .padding(.horizontal,10)
                        Spacer()
                    }
                    .zIndex(0)
//                    FloatingChatButton()
//                        .padding(.bottom,10)
//                        .zIndex(1)
//                        .padding()
//                    Spacer()
             
                }
            }
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
            .preferredColorScheme(patientViewModel.isDarkModePatient ? .dark : .light)
            .searchable(text: $articlesViewModel.searchText, placement: .automatic, prompt: Text("search_placeholder".localized()))
            .onAppear{
                articlesViewModel.fetchArtical(isDoctor: false)
                specializationViewModel.getSpacialties()
                adviceViewModel.getUserAdvice()
            }
            
            

    }
    
    
    // MARK: - Title Category
    private func titleCategory(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
            Spacer()
        }
        .multilineTextAlignment(.leading)
        .padding(.vertical, 10)
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
}



// MARK: - All AllSpecializations
struct AllSpecializationsView : View {
    @ObservedObject var specializationViewModel  : SpecializationViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    var body : some View {
        NavigationStack{
            List{
                ForEach(specializationViewModel.specializations){ specialist in
                    Button{
                        
                    }label: {
                        HStack {
                            Text(".\(specialist.id)")
                                .font(.footnote)
                            Text(specialist.name)
                            Spacer()
                            Image(systemName: "square")
                                .foregroundColor(.accent)
                                .font(.title2)

                        }
                        .padding()
                        .frame(height: 50)
                        
                        }
                    .tint(.primary)
                    
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
            .navigationTitle("all_specialty".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
        .direction(appLanguage) // اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage))
    }

}

    // MARK: - Category Specializaton
struct CategorySpecializaton: View {
    var specialization  : spectialties
    var action : (Bool) -> Void
    var body: some View {
        Button{
        }label: {
            HStack {
                Text(specialization.name)
                Spacer()
                Image(systemName: "square")
                    .foregroundColor(.accent)
                    .font(.title2)
            }
            .padding()
            .frame(width: 220, height: 50)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            }
        .tint(.primary)
        }
    }



// MARK: - Preview
#Preview {
    PatientHomeScreen(adviceViewModel: AdviceViewModel(), articlesViewModel: ArticalsViewModel(), patientViewModel: PatientSettingViewModel())
}



