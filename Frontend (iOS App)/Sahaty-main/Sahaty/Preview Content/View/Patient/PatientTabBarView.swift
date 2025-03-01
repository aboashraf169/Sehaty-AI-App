//
//  PatientDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct PatientTabBarView: View {
    @StateObject var appState = AppState()
    @StateObject var adviceViewModel = AdviceViewModel()
    @StateObject var articlesViewModel = ArticalsViewModel()
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar"

    var body: some View {
        TabView(selection: $appState.selectedTabPatients) {
            // MARK: - Home Tab
            PatientHomeScreen(adviceViewModel: adviceViewModel, articlesViewModel: articlesViewModel, patientViewModel: patientViewModel)
                .tabItem {
                    HStack {
                        Text("home".localized())
                        Image(systemName: "house.fill")
                    }
                }
                .tag(TabPatient.home)

            // MARK: - Doctors Tab
            SpecializationsDoctorsView(patientViewModel: patientViewModel)
                .tabItem {
                    HStack {
                        Text("doctors".localized())
                        Image(systemName: "person.2")
                    }
                }
                .tag(TabPatient.Doctors)

            // MARK: - Notifications Tab
            patientNotificationsView()
                .tabItem {
                    HStack {
                        Text("notifications".localized())
                        Image(systemName: "heart.fill")
                    }
                }
                .tag(TabPatient.Notificatons)
                .badge(5) // عدد الإشعارات

            
            // MARK: - Settings Tab
            PatientSettingView(patientViewModel: patientViewModel)
                .padding()
                .tabItem {
                    HStack {
                        Text("settings".localized())
                        Image(systemName: "gear")
                    }
                }
                .tag(TabPatient.settings)
        }
        .direction(appLanguage)
        .environmentObject(appState)
        .environment(\.locale, .init(identifier: appLanguage))
    
    }
}

// MARK: - Preview
#Preview {
    PatientTabBarView(patientViewModel: PatientSettingViewModel())
}


