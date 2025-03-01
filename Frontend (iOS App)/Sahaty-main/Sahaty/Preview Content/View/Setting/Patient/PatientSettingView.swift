import SwiftUI
struct PatientSettingView: View {
    
    @AppStorage("isDarkModePatient") private var isDarkModePatient = false // حفظ الاختيار
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @State private var showImagePicker = false
    @State private var showNotificationView = false
    @State private var showNotificationToggle = false
    @State private var showSavedView = false
    @State private var showRestPasswordView = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Profile Header
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                            .frame(width: 120, height: 120)

                        if let selectedImage = patientViewModel.patientProfileImage {
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
                        .offset(x: -40, y: 40)
                    }
                    
                    Text(patientViewModel.patient.name)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text(patientViewModel.patient.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                // Navigation Links
                NavigationLink("edit_profile".localized(), destination:
                                EditPationtDataProfileView(patientViewModel: patientViewModel))
                .padding(.horizontal)
                .foregroundStyle(.white)
                .padding(10)
                .background(Color.accentColor)
                .cornerRadius(15)
                .padding(.vertical)
                
                Divider()
                
                // Settings Options
                ScrollView(){
                    VStack(spacing: 20) {
                        MenuOption(title: "languageـchange".localized(), icon: "globe", action: {toggleLanguage()})
                        
                        MenuOption(title: "saved_items".localized(), icon: "bookmark", action: { showSavedView.toggle() })
                            .sheet(isPresented: $showSavedView) {
                                patientSavedArticalvView(patientViewModel: patientViewModel)
                            }
                        
                        MenuOption(title: "change_password".localized(), icon: "key", action: { showRestPasswordView.toggle() })
                            .sheet(isPresented: $showRestPasswordView) {
                                changePasswordView(usersType: .patient)
                                    .presentationDetents([.fraction(0.65)])
                                    .presentationCornerRadius(30)
                            }
                        
                        MenuOption(title: "logout".localized(), icon: "arrowshape.turn.up.left", action:
                                    {
                            showLogoutAlert.toggle()                            
                        })
                            .alert("confirm_logout".localized(), isPresented: $showLogoutAlert) {
                                Button("confirm".localized(), role: .destructive) {
                                    logout()
                                }
                                Button("cancel".localized(), role: .cancel) {}
                            }
                        
                        Toggle(isOn: $isDarkModePatient) {
                            HStack {
                                Image(systemName: isDarkModePatient ? "moon.fill" : "sun.max.fill")
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
                }
                .scrollIndicators(.hidden, axes: .vertical)
                Spacer()
            }
            .padding()
            .navigationBarTitle("profile".localized())
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkModePatient ? .dark : .light)
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
            .sheet(isPresented: $showImagePicker){
                ImagePicker(selectedImage: $patientViewModel.patientProfileImage, onImagePicked: { image in
                    patientViewModel.updateProfileImage(newImage: image)
                })
            }
        }
    }
    private func toggleLanguage() {
        appLanguage = (appLanguage == "ar") ? "en" : "ar"
        UserDefaults.standard.set(appLanguage, forKey: "appLanguage")
    }
}

#Preview {
    PatientSettingView(patientViewModel: PatientSettingViewModel())
}















//
//MenuOption(title: "manage_notifications".localized(), icon: "bell", action: { showNotificationView.toggle() })
//                            .sheet(isPresented: $showNotificationView) {
//                                Toggle(isOn: $showNotificationToggle) {
//                                    Text("enable_notifications".localized())
//                                        .font(.headline)
//                                        .foregroundStyle(.accent)
//                                }
//                                .tint(.accent)
//                                .padding()
//                                .presentationDetents([.fraction(0.1)])
//                                .presentationCornerRadius(30)
//                            }
