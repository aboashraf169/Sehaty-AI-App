import SwiftUI

struct NewPasswordView: View {
    
    @StateObject private var newPasswordViewModel : NewPasswordViewModel
    
    @State private var showLoginView = false
    @State private var isErrorAlertPresented = false
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var isLoggedIn = false


    // Initializer لاستقبال التوكن
    init(token: String) {
        _newPasswordViewModel = StateObject(wrappedValue: NewPasswordViewModel(token: token))
    }
    var body: some View {
        NavigationStack {
            VStack {
                headerView()

                passwordField()

                if !newPasswordViewModel.passwordErrorMessage.isEmpty {
                    errorMessageView(message: newPasswordViewModel.passwordErrorMessage)
                }

                confirmPasswordField()

                if !newPasswordViewModel.confirmPasswordErrorMessage.isEmpty {
                    errorMessageView(message: newPasswordViewModel.confirmPasswordErrorMessage)
                }

                submitButton()

                Spacer()
            }
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
            .overlay {
                if newPasswordViewModel.isLoading {
                    ProgressView("loading".localized())
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                }
            }
            .alert(newPasswordViewModel.successMessage, isPresented: Binding(
                get: { !newPasswordViewModel.successMessage.isEmpty },
                set: { _ in }
            )) {
                Button("ok".localized(), role: .cancel) {
                    showLoginView = true
                }
            }
            .alert("error".localized(), isPresented: $isErrorAlertPresented) {
                Button("ok".localized(), role: .cancel) {}
            } message: {
                Text(newPasswordViewModel.apiErrorMessage.localized())
            }
            .navigationDestination(isPresented: $showLoginView) {
                LoginView()
            }
        }
    }

    // MARK: - Header View
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("enter_new_password".localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 100)
    }

    // MARK: - Password Field
    private func passwordField() -> some View {
        PasswordField(
            password: $newPasswordViewModel.model.password,
            placeholder: "enter_password".localized(),
            label: "password".localized()
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    // MARK: - Confirm Password Field
    private func confirmPasswordField() -> some View {
        PasswordField(
            password: $newPasswordViewModel.model.confirmPassword,
            placeholder: "confirm_password".localized(),
            label: "confirm_password".localized()
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    // MARK: - Error Message View
    private func errorMessageView(message: String) -> some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.red)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Submit Button
    private func submitButton() -> some View {
        Button(action: {
            newPasswordViewModel.validateAndChangePassword { success in
                if success {
                    showLoginView = true
                } else {
                    isErrorAlertPresented = true
                }
            }
        }) {
            Text("submit".localized())
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
}

// MARK: - Preview
#Preview {
    NewPasswordView(token: "")
}
