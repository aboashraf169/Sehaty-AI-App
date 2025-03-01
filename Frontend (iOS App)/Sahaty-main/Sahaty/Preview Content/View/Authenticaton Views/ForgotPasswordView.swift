import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var resetPasswordViewModel = ResetPasswordViewModel()
    @State private var isSuccessAlertPresented = false
    @State private var showOtpVerificationScreen = false
    @State private var isErrorAlertPresented = false
    @AppStorage("appLanguage") private var appLanguage = "ar"

    var userType: UsersType

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("forgot_password_title".localized())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)

                    Text("forgot_password_description".localized())
                        .font(.body)
                        .foregroundColor(Color.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 140)

                // MARK: - Email Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("email".localized())
                        .font(.callout)
                        .foregroundColor(.secondary)

                    TextField("enter_email".localized(), text: $resetPasswordViewModel.model.email)
                        .padding()
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .multilineTextAlignment(.leading)

                    if !resetPasswordViewModel.emailErrorMessage.isEmpty {
                        Text(resetPasswordViewModel.emailErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // MARK: - Send Button
                Button(action: {
                    resetPasswordViewModel.validateAndSendEmail { success in
                        if success {
                            isSuccessAlertPresented = true
                        } else {
                            isErrorAlertPresented = true
                        }
                    }
                }) {
                    Text("send".localized())
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                Spacer()
            }
            .direction(appLanguage)
            .environment(\.locale, .init(identifier: appLanguage))
            .overlay {
                if resetPasswordViewModel.isLoading {
                    ProgressView("loading".localized())
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                }
            }
            .alert(resetPasswordViewModel.successMessage.localized(), isPresented: $isSuccessAlertPresented) {
                Button("ok".localized(), role: .cancel) {
                    showOtpVerificationScreen = true
                }
            }
            .alert("error".localized(), isPresented: $isErrorAlertPresented) {
                Button("ok".localized(), role: .cancel) {}
            } message: {
                Text(resetPasswordViewModel.apiErrorMessage.localized())
            }
            .navigationDestination(isPresented: $showOtpVerificationScreen) {
                OtpVerificationView(email: resetPasswordViewModel.model.email)
            }
        }
    }
}
// MARK: - Preview
#Preview {
    ForgotPasswordView(userType: .patient)
}
