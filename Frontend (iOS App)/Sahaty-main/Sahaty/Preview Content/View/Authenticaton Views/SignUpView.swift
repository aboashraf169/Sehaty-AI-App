import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @State private var showLoginView = false
    @State private var isErrorAlertPresented = false
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var specializationViewModel = SpecializationViewModel()


    @AppStorage("appLanguage") private var appLanguage = "ar"

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                headerView()
                
                // MARK: - User Type Picker
                userTypePicker()
                
                ScrollView {
                    VStack {
                        sharedFields()
                        if signUpViewModel.model.usersType == .doctor {
                            doctorFields()
                            Text("specialty".localized())
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            Picker("Select Specialty", selection: $specializationViewModel.selectedSpecialty) {
                                ForEach(specializationViewModel.specializations) { specialty in
                                    Text(specialty.name)
                                        .tag(specialty as spectialties?)
                                }
                            }
                            .pickerStyle(.inline) // اختيار شكل القائمة
                            .onChange(of: specializationViewModel.selectedSpecialty) { old ,selected in
                                if let selected = selected {
                                    signUpViewModel.model.specialty_id = String(selected.id)
                                }
                            }
                            .frame(height : 100)
                            .padding(.horizontal, 15)
//                            Spacer()
                        }
                        
                    }
                }
                
                // MARK: - Footer
                footerView()
            }
            .padding(.vertical, 20)
            .overlay {
                if signUpViewModel.isLoading {
                    ProgressView("loading".localized())
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                }
            }
            .alert(signUpViewModel.successMessage.localized(), isPresented: Binding(
                get: { !signUpViewModel.successMessage.isEmpty },
                set: { _ in }
            )) {
                Button("ok".localized()) {
                    showLoginView = true
                }
            }
            .alert("error".localized(), isPresented: $isErrorAlertPresented) {
                Button("ok".localized(), role: .cancel) {}
            } message: {
                Text(signUpViewModel.errorMessage.localized())
            }
            
            .navigationDestination(isPresented: $showLoginView) {
                LoginView()
            }
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
        }
        .onAppear{
            specializationViewModel.getSpacialties()
        }
    }
    
    // MARK: - Header
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("signup_subtitle".localized())
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("signup_title".localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    
    // MARK: - User Type Picker
    private func userTypePicker() -> some View {
        Picker("user_type".localized(), selection: $signUpViewModel.model.usersType) {
            Text("patient".localized()).tag(UsersType.patient)
            Text("doctor".localized()).tag(UsersType.doctor)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 20)
    }
    
    // MARK: - Shared Fields
    private func sharedFields() -> some View {
        Group {
            fieldView(label: "name".localized(), placeholder: "enter_full_name".localized(), text: $signUpViewModel.model.name)
                .padding(.top, 20)
            
            errorMessageView(signUpViewModel.fullNameErrorMessage)
            
            fieldView(label: "email".localized(), placeholder: "enter_email".localized(), text: $signUpViewModel.model.email)
                .padding(.top, 10)
            
            errorMessageView(signUpViewModel.emailErrorMessage)
            
            PasswordField(password: $signUpViewModel.model.password, placeholder: "enter_password".localized(), label: "password".localized())
            
            errorMessageView(signUpViewModel.passwordErrorMessage)
            
            
            PasswordField(password: $signUpViewModel.model.password_confirmation, placeholder: "confirm_password".localized(), label: "confirm_password".localized())
            errorMessageView(signUpViewModel.confirmPasswordErrorMessage)

            }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Doctor Fields
    private func doctorFields() -> some View {
        Group {
            fieldView(
                label: "license_number".localized(),
                placeholder: "enter_license_number".localized(),
                text: Binding(
                    get: { signUpViewModel.model.jop_specialty_number ?? "" },
                    set: { signUpViewModel.model.jop_specialty_number = $0.isEmpty ? nil : $0 }
                )
            )
            .padding(.top, 10)
            errorMessageView(signUpViewModel.licenseNumberErrorMessage)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Footer
    private func footerView() -> some View {
        VStack {
            Button(action: {
                signUpViewModel.validateAndSignUp(userType : signUpViewModel.model.usersType) { success in
                    if success {
                        showLoginView = true
                    } else {
                        isErrorAlertPresented = true
                    }
                }
            }) {
                Text("signup_button".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Field View
    private func fieldView(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: text)
                .font(.callout)
                .padding()
                .background(Color(.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: - Error Message View
    @ViewBuilder
    private func errorMessageView(_ message: String) -> some View {
        if message.isEmpty {
            EmptyView()
        } else {
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}

// MARK: - Preview
#Preview {
    SignUpView()
}
