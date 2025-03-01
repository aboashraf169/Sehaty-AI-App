//
//  NewPasswordViewModel 2.swift
//  Sahaty
//
//  Created by mido mj on 1/20/25.
//
import Foundation

class ChangePasswordViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = changePasswordModel(old_password: "", password: "", confirmPassword: "")

    // MARK: - Error Messages
    @Published var passwordErrorMessage: String = ""
    @Published var oldPasswordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var apiErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false

    // MARK: - Error Message

    

    
    // MARK: - Validation and Change Password
    func validateAndChangePassword(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateNewPassword() else {
            print("Validation Failed. Password Error: \(oldPasswordErrorMessage),Validation Failed. Password Error: \(passwordErrorMessage), Confirm Password Error: \(confirmPasswordErrorMessage)")
            completion(false)
            return
        }

        print("Validation Successful. Proceeding to change password.")
        
        // Call API to change password
        changePassword(completion: completion)
    }

    func validateNewPassword() -> Bool {
        var isValid = true
        
        // Validate old password
        if model.old_password.isEmpty {
            oldPasswordErrorMessage = "enter_password".localized()
            print("Validation Error: \(oldPasswordErrorMessage)")
            isValid = false
        } else if model.old_password.count < 6 {
            oldPasswordErrorMessage = "password_min_length".localized()
            print("Validation Error: \(oldPasswordErrorMessage)")

            isValid = false
        }

        // Validate new password
        if model.password.isEmpty {
            passwordErrorMessage = "enter_password".localized()
            print("Validation Error: \(passwordErrorMessage)")
            isValid = false
        } else if model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            print("Validation Error: \(passwordErrorMessage)")

            isValid = false
        }

        // Validate confirm password
        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "passwords_not_matching".localized()
            print("Validation Error: \(confirmPasswordErrorMessage)")
            isValid = false
        }
        
        if !isValid {
            apiErrorMessage = "validation_failed".localized()
            print("Validation Failed: \(apiErrorMessage)")
        }
        return isValid
    }
    
    // MARK: - Clear Errors
    private func clearErrors() {
        print("Clearing all error messages.")
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
        apiErrorMessage = ""
        successMessage = ""
        oldPasswordErrorMessage = ""
    }

    // MARK: - API Call for Changing Password
    private func changePassword(completion: @escaping (Bool) -> Void) {
        isLoading = true
        print("Request Parameters: \(model.toDictionary())")
        APIManager.shared.sendRequest(
            endpoint: "/change-password",
            method: .post,
            parameters: model.toDictionary()
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    print("Request Successful. Data Received: \(String(data: data, encoding: .utf8) ?? "No Data")")
                    completion(true)
                    self?.successMessage = "password_change_success".localized()
                case .failure(let error):
                    print("Request Failed. Error: \(error.localizedDescription)")
                    self?.handleAPIError(error)
                    completion(false)
                    self?.apiErrorMessage = "error sending request".localized()

                }
            }
            
        }
        
    }
    
    private func handleVerificationSuccess(data: Data) -> Bool {
            print("Parsing Success Response.")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = json["message"] as? String {
                print("Success Message from Server: \(message)")
                successMessage = "password_change_success".localized()
                return true
            } else {
                print("Invalid Response Format. Missing 'message' field.")
                apiErrorMessage = "invalid".localized()
                return false
            }
    }

    private func handleAPIError(_ error: Error) {
        apiErrorMessage = "unexpected_error_occurred".localized()

        if let apiError = error as? APIError {
            switch apiError {
            case .decodingError:
                apiErrorMessage = "response_parsing_error".localized()
                print("API Error: Decoding Error.")
            default:
                apiErrorMessage = error.localizedDescription
                print("API Error: \(apiErrorMessage)")
            }
        } else {
            apiErrorMessage = error.localizedDescription
            print("Unexpected Error: \(error.localizedDescription)")
        }
        print("API Error: \(apiErrorMessage)")
    }


}
