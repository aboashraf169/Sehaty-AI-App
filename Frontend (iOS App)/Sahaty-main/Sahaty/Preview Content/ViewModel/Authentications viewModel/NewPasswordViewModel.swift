//
//  NewPasswordViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation

class NewPasswordViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = NewPasswordModel(password: "", confirmPassword: "")

    // MARK: - Error Messages
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var apiErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false

    // MARK: - Error Message

    // MARK: - TOKEN
    private var token: String

    init(token: String) {
        self.token = token
        print("Initializing NewPasswordViewModel with token: \(token)")
        APIManager.shared.setBearerToken(token) // تعيين التوكن في APIManager
    }

    
    // MARK: - Validation and Change Password
    func validateAndChangePassword(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateNewPassword() else {
            print("Validation Failed. Password Error: \(passwordErrorMessage), Confirm Password Error: \(confirmPasswordErrorMessage)")
            completion(false)
            return
        }

        print("Validation Successful. Proceeding to change password.")
        // Call API to change password
        changePassword(completion: completion)
    }

    func validateNewPassword() -> Bool {
        var isValid = true

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

//        // Validate old password
//        if let oldPassword = model.oldPassword, oldPassword.isEmpty {
//            oldPasswordErrorMessage = "enter_old_password".localized()
//            isValid = false
//        }
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
    }

    // MARK: - API Call for Changing Password
    private func changePassword(completion: @escaping (Bool) -> Void) {
        isLoading = true
        print("Request Parameters: \(model.toDictionary())")
        APIManager.shared.sendRequest(
            endpoint: "/reset-password",
            method: .post,
            parameters: model.toDictionary()
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    print("Request Successful. Data Received: \(String(data: data, encoding: .utf8) ?? "No Data")")
                    let isVerified = self?.handleVerificationSuccess(data: data) ?? false
                    completion(isVerified)
                case .failure(let error):
                    print("Request Failed. Error: \(error.localizedDescription)")
                    self?.handleAPIError(error)
                    completion(false)
                }
            }
            
        }
        
    }
    
    private func handleVerificationSuccess(data: Data) -> Bool {
            print("Parsing Success Response.")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = json["message"] as? String {
                print("Token: \(token)")
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
