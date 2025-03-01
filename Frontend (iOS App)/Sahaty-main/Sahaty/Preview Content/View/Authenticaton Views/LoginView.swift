import SwiftUI

struct LoginView: View {
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject var doctorProfileViewModel = DoctorProfileViewModel()
    @StateObject var patientViewModel = PatientSettingViewModel()
    @State private var navigateToDoctorView = false
    @State private var navigateToPatientView = false
    @State private var isErrorAlertPresented = false

    
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        
    }

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
//
                    Image("logo-img")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .cornerRadius(55)
                        .padding(.vertical,35)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 70)
                        .animation(.easeIn(duration: 1.1), value: isAnimating)
                        .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("login_now".localized())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.accentColor)
                        Spacer()
                        Button {
                            toggleLanguage()
                        } label: {
                            Image(systemName: "globe")
                                .font(.title)
                                .foregroundStyle(.accent)
                            Text("".localized())
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // اختيار نوع المستخدم
                Picker("", selection: $loginViewModel.model.usersType) {
                    Text("patient".localized()).tag(UsersType.patient)
                    Text("doctor".localized()).tag(UsersType.doctor)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)

                // MARK: - Center
                VStack {
                    // البريد الإلكتروني
                    fieldView(
                        label: "email".localized(),
                        placeholder: "enter_email".localized(),
                        text: $loginViewModel.model.email,
                        errorMessage: loginViewModel.emailErrorMessage
                    )

                    // كلمة المرور
                    fieldView(
                        label: "password".localized(),
                        placeholder: "enter_password".localized(),
                        text: $loginViewModel.model.password,
                        errorMessage: loginViewModel.passwordErrorMessage,
                        isSecure: true
                    )
                }

                // رابط "نسيت كلمة المرور؟"
                HStack {
                    NavigationLink("forgot_password".localized(), destination: ForgotPasswordView(userType: loginViewModel.model.usersType))
                        .font(.callout)
                        .foregroundColor(.secondary.opacity(0.7))
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)

                // زر تسجيل الدخول
                Button(action: {
                    if !loginViewModel.isLoading { // منع الضغط أثناء التحميل
                        loginViewModel.validateAndLogin { success in
                            if success {
                                if loginViewModel.model.usersType == .doctor {
                                    navigateToDoctorView = true
                                    doctorProfileViewModel.setDoctor(loginViewModel.doctorModel)
                                    
                                } else {
                                    navigateToPatientView = true
                                    patientViewModel.SetPateintData(loginViewModel.patientModel)
                                }
                            } else {
                                isErrorAlertPresented = true
                            }
                        }
                    }
                }) {
                    if loginViewModel.isLoading {
                        ProgressView() // عرض عنصر التحميل
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("login".localized()) // نص الزر عند عدم التحميل
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.accentColor) // تغيير لون الخلفية أثناء التحميل
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 20)
//                .disabled(loginViewModel.isLoading) // تعطيل الزر أثناء التحميل
                .opacity(loginViewModel.isLoading ? 0.7 : 1.0) // تغيير الشفافية فقط
                .alert("error".localized(), isPresented: $isErrorAlertPresented) {
                    Button("ok".localized(), role: .cancel) {}
                } message: {
                    Text(loginViewModel.apiErrorMessage.localized())
                }
                              // الانتقال بناءً على نوع المستخدم
                .navigationDestination(isPresented: $navigateToDoctorView) {
                    DoctorTabBarView(doctorProfileViewModel: doctorProfileViewModel)
                        .navigationBarBackButtonHidden(true)
                }
                .navigationDestination(isPresented: $navigateToPatientView) {
                    PatientTabBarView(patientViewModel: patientViewModel)
                        .navigationBarBackButtonHidden(true)
                }

                // MARK: - Footer
//                footerView()

                // الانتقال لشاشة إنشاء حساب
                NavigationLink("sign_up".localized(), destination: SignUpView())
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
            }
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
            .alert("error".localized(), isPresented: $isErrorAlertPresented) {
                Button("ok".localized(), role: .cancel) {}
            } message: {
                Text(loginViewModel.apiErrorMessage.localized())
            }
            Spacer()
        }
        .onAppear{
          isAnimating = true
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 70)
        .animation(.easeIn(duration: 1.1), value: isAnimating)
    
    }

    // MARK: - Helper Views
    private func fieldView(label: String, placeholder: String, text: Binding<String>, errorMessage: String, isSecure: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundColor(.secondary).opacity(0.7)

            if isSecure {
                SecureField(placeholder, text: text)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
            } else {
                TextField(placeholder, text: text)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    private func toggleLanguage() {
        appLanguage = (appLanguage == "ar") ? "en" : "ar"
        UserDefaults.standard.set(appLanguage, forKey: "appLanguage")
    }
}

// MARK: - Preview
#Preview {
    return LoginView()
}
