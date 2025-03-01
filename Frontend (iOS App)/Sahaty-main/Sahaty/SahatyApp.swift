//
//  SahatyApp.swift
//  Sahaty
//
//  Created by mido mj on 12/5/24.
//

import SwiftUI
import Foundation

@main
struct SahatyApp: App {
    @State private var sessionManager = SessionManager.shared
    
    @StateObject private var doctorProfileViewModel = DoctorProfileViewModel()
    @StateObject private var patientViewModel = PatientSettingViewModel()
    private let tokensaved = UserDefaults.standard.string(forKey: "userToken")
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
               if let token = sessionManager.getToken(), let userType = sessionManager.getUserType() {
                   // تحقق من نوع المستخدم
                   if userType == "doctor" {
                       DoctorTabBarView(doctorProfileViewModel: doctorProfileViewModel)
                           .onAppear{
                               APIManager.shared.setBearerToken(token)
                                doctorProfileViewModel.setDoctor(sessionManager.getDoctorData())
                           }
                   } else {
                       PatientTabBarView(patientViewModel: patientViewModel)
                           .onAppear{
                               APIManager.shared.setBearerToken(token)
                                patientViewModel.SetPateintData(sessionManager.getPatientData())
                           }
                   }
               } else {
                   LoginView()
               }
           }
    }
}

extension View {
    // تحويل اتجاه النص حسب اتجاة اللغة
    func direction(_ language: String) -> some View {
        self.environment(\.layoutDirection, language == "ar" ? .rightToLeft : .leftToRight)
    }
}

extension String {
    func localized() -> String {
        
        // في حال لا توجد قيمه يتم اعطائه اللغة العربية اللغة الافتراضية
        if  UserDefaults.standard.string(forKey: "appLanguage") == nil {
            UserDefaults.standard.set("ar", forKey: "appLanguage")
        }
        guard let appLanguage = UserDefaults.standard.string(forKey: "appLanguage") else {
            return NSLocalizedString(self, comment: "")
        }
        
        guard let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
}
