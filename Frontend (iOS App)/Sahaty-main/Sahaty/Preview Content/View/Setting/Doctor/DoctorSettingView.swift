//
//  PatientSettingView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//


import SwiftUI
import PhotosUI

struct DoctorSettingView: View {
    
    @ObservedObject var viewModel : DoctorProfileViewModel

    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
    @State private var showNotificationView = false
    @State private var showNotificationToggle = false
    @State private var showSavedView = false
    @State private var showRestPasswordView = false
    @State private var showLogoutAleart = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة


    var body: some View {
        // Header Section
        NavigationStack {
            VStack{
                
                // Header Section
                ProfileHeaderView(viewModel: viewModel)
                    .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
                    .onChange(of: selectedImageItem) { _, newValue in
                    }
                
                NavigationLink("edit_profile".localized(), destination: EditDoctorDataProfileView(imagePath: viewModel.doctor.img ?? "", viewModel: viewModel))
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.accentColor)
                    .cornerRadius(15)
                    .padding(.vertical)
                               
                Divider()
                
                VStack(spacing:20){

                    MenuOption(title: "languageـchange".localized(), icon: "globe", action: {toggleLanguage()})
                        
                    MenuOption(title: "change_password".localized(), icon: "key", action: { showRestPasswordView.toggle() })
                        .sheet(isPresented: $showRestPasswordView) {
                            changePasswordView(usersType: .doctor)
                                .presentationDetents([.fraction(0.65)])
                                .presentationCornerRadius(30)
                        }
                    
                    MenuOption(title: "logout".localized(), icon:    "arrowshape.turn.up.left", action: { showLogoutAleart.toggle() })
                        .alert("confirm_logout".localized(), isPresented: $showLogoutAleart) {
                            Button("confirm".localized(), role: .destructive) {
                                logout()
                            }
                            Button("cancel".localized(), role: .cancel) {}
                        }
                    Toggle(isOn: $viewModel.isDarkModeDoctor) {
                                HStack {
                                    Image(systemName: viewModel.isDarkModeDoctor ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 50, height: 50)
                                        .background(Color.accentColor.opacity(0.2)).cornerRadius(10)

                                    Text("dark_mode".localized())
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)

                           }
                    .toggleStyle(SwitchToggleStyle(tint: .accent))
                    .frame(maxWidth: .infinity)
                    .padding(0)
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle("profile".localized())
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(viewModel.isDarkModeDoctor ? .dark : .light) // تطبيق المظهر
        }
        .direction(appLanguage) // ضبط اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
    }
    
    private func toggleLanguage() {
        appLanguage = (appLanguage == "ar") ? "en" : "ar"
        UserDefaults.standard.set(appLanguage, forKey: "appLanguage")
    }
}

func logout() {
    // إزالة التوكن
    let _ = KeychainManager.shared.deleteToken()
    // ازالة الجلسة
    SessionManager.shared.clearSession()
    // إعادة التوجيه إلى شاشة تسجيل الدخول
    if let window = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow }) {
        window.rootViewController = UIHostingController(rootView: LoginView())
        window.makeKeyAndVisible()
    }
}


#Preview {
    DoctorSettingView(viewModel: DoctorProfileViewModel())
}

