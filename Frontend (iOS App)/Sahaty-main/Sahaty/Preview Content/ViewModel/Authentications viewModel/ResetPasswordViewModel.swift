
import Foundation

class ResetPasswordViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = ResetPasswordModel(email: "", newPassword: "", confirmPassword: "")

    // MARK: - Error Messages
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var apiErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false

    
    // MARK: - Validate and Send Email
    func validateAndSendEmail(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateEmail() else {
            completion(false)
            return
        }
        isLoading = true
        APIManager.shared.sendRequest(
            endpoint: "/forget-password",
            method: .post,
            parameters: ["email": model.email]
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    let isSuccess = self?.handleEmailValidationResponse(data: data) ?? false
                    completion(isSuccess)
                case .failure(let error):
                    self?.handleAPIError(error)
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Validate Email
    private func validateEmail() -> Bool {
        var isValid = true

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "enter_valid_email".localized()
            isValid = false
        }

        return isValid
    }

    
    // MARK: - Validate New Password
    private func validateNewPassword() -> Bool {
        var isValid = true

        // Validate new password
        if model.newPassword.isEmpty {
            passwordErrorMessage = "enter_password".localized()
            isValid = false
        } else if model.newPassword.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        }

        // Validate confirm password
        if model.confirmPassword != model.newPassword {
            confirmPasswordErrorMessage = "passwords_not_matching".localized()
            isValid = false
        }

        return isValid
    }


    // MARK: - Validate and Reset Password
    func resetPasswordWithValidation(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateNewPassword() else {
            completion(false)
            return
        }

        isLoading = true
        APIManager.shared.sendRequest(
            endpoint: "/reset-password",
            method: .post,
            parameters: model.toDictionary()
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.handleSuccessPasswordResponse(data: data)
                    completion(true)
                case .failure(let error):
                    self?.handleAPIError(error)
                    completion(false)
                }
            }
        }
    }


    
    // MARK: - Handle Success Email Responses
    private func handleEmailValidationResponse(data: Data) -> Bool {
        // تحويل البيانات إلى نص
        if let responseString = String(data: data, encoding: .utf8) {
            print("Raw Response: \(responseString)") // طباعة الرد لفحصه

            // التحقق من محتوى الرد
            if responseString.lowercased().contains("we sent email"){
                successMessage = "send_email".localized() // اعتبره رسالة نجاح
                return true
            } else {
                apiErrorMessage = "valid_email".localized() // اعتبره رسالة خطأ
                return false
            }
        }

        // إذا لم يمكن تحويل البيانات إلى نص
        apiErrorMessage = "response_parsing_error".localized()
        print("Failed to parse response string.")
        return false
    }

    // MARK: - Handle Success Password Responses
    private func handleSuccessPasswordResponse(data: Data) {
        successMessage = "password_reset_success".localized()
        print("Password Reset Response: \(String(data: data, encoding: .utf8) ?? "")")
    }
    
    // MARK: - Handle API Error
    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .decodingError:
                apiErrorMessage = "response_parsing_error".localized()

            case .serverError(let message):
                // إذا كانت الرسالة JSON
                if let data = message.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // استخراج الرسالة من JSON
                    if let readableMessage = json["message"] as? String {
                        apiErrorMessage = readableMessage.localized()
                    } else if let errors = json["errors"] as? [String: [String]],
                              let firstError = errors.values.first?.first {
                        apiErrorMessage = firstError.localized()
                        if apiErrorMessage.contains("The selected email is invalid") {
                            apiErrorMessage = "Please enter a valid registered email.".localized()
                        }

                    } else {
                        apiErrorMessage = "unknown_error".localized()
                    }
                } else {
                    apiErrorMessage = message // في حالة عدم القدرة على تحليل JSON
                }

            default:
                apiErrorMessage = apiError.localizedDescription
            }
        } else {
            apiErrorMessage = error.localizedDescription
        }

        // طباعة الخطأ للتطوير
        print("API Error: \(apiErrorMessage)")
    }

    // MARK: - Clear Errors
    private func clearErrors() {
        emailErrorMessage = ""
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
        apiErrorMessage = ""
        successMessage = ""
    }
}
