//
//  SplashScreenView.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.
//

import SwiftUI
import Foundation

struct SplashScreenView: View {
    @State private var navigateToDoctor = false
    @State private var navigateToPatient = false
    @State private var navigateToLogin = false
    @StateObject private var loginViewModel = LoginViewModel()
    @ObservedObject var doctorProfileViewModel: DoctorProfileViewModel
    @ObservedObject var PatientViewModel: PatientSettingViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar"

    
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    
    var body: some View {
        VStack{
            Image("logo-img")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 120,height: 120)
                      .cornerRadius(60)
                      .opacity(isAnimating ? 1 : 0)
                      .offset(y: isAnimating ? 0 : -100)
                      .animation(.easeIn(duration: 1.1), value: isAnimating)
            
            Text("sahaty".localized())
                     .font(.largeTitle)
                     .fontWeight(.bold)
                         .foregroundColor(.accent)
                         .transition(.opacity)
                         .opacity(isAnimating ? 1 : 0)
                         .offset(y: isAnimating ? 0 : -100)
                         .animation(.easeIn(duration: 1.1), value: isAnimating)
                

            
        }
        .onAppear{
          isAnimating = true
        }
//                .onAppear {
                    
//                    if SessionManager.shared.isUserLoggedIn() {
//                        if let userType = SessionManager.shared.getUserType() {
//                            if userType == .doctor {
//                                navigateToDoctor = true
//                            } else {
//                                navigateToPatient = true
//                            }
//                        }
//                    } else {
//                        navigateToLogin = true
//                    }
//                }
        
        .navigationDestination(isPresented: $navigateToDoctor) {
            DoctorTabBarView(doctorProfileViewModel: doctorProfileViewModel)
        }
        .navigationDestination(isPresented: $navigateToPatient) {
            PatientTabBarView(patientViewModel: PatientViewModel)
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }
}

#Preview {
    SplashScreenView(doctorProfileViewModel: DoctorProfileViewModel(), PatientViewModel: PatientSettingViewModel())
}
