//
//  DoctorDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/10/24.
//


import SwiftUI
// واجهة قيد الانشاء
struct DoctorTabBarView: View {
    @StateObject var appState = AppState()
    @StateObject private var adviceViewModel = AdviceViewModel()
    @StateObject private var articalsViewModel = ArticalsViewModel()
    @ObservedObject var doctorProfileViewModel: DoctorProfileViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar" 


    var body: some View {
            TabView(selection: $appState.selectedTabDoctors){
                DoctorHomeScreen(adviceViewModel: adviceViewModel, articlesViewModel: articalsViewModel, doctorProfileViewModel: doctorProfileViewModel)
                        .tabItem{
                            HStack{
                                Text(("Home").localized())
                                Image(systemName: "house.fill")
                            }
                        }
                        .tag(TabDoctor.home)
                ProfileView(viewModel: doctorProfileViewModel, adviceViewModel: adviceViewModel, articalViewModel: articalsViewModel)
                     .tabItem{
                         HStack{
                             Text("Profile".localized())
                             Image(systemName: "person.fill")
                         }
                     }
                     .tag(TabDoctor.profile)

                doctorNotificationsView()
                .tabItem{
                    HStack{
                        Text("Notifications".localized())
                        Image(systemName: "heart.fill")
                    }
                }
                .tag(TabDoctor.Notificatons)
                .badge(10)
        
        
                DoctorSettingView(viewModel: doctorProfileViewModel)
                    .padding()
                .tabItem{
                    HStack{
                        Text("Settings".localized())
                        Image(systemName: "gear")
                    }
                }
                .tag(TabDoctor.settings)
      
                }
            .environmentObject(appState)
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
    }
    
}

#Preview{
    let appState = AppState()
    DoctorTabBarView(doctorProfileViewModel:  DoctorProfileViewModel())
        .environmentObject(appState)
}


