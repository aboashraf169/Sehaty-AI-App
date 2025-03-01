//
//  SignUpViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class SignUpViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var model = SignUpModel(name: "", email: "", password: "", password_confirmation: "", usersType: .patient)
    @Published var fullNameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var specializationErrorMessage: String = ""
    @Published var licenseNumberErrorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    
    // MARK: - Validation and API Call
    func validateAndSignUp(userType: UsersType,completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateSignUp() else {
            completion(false)
            return
        }

        // Call API to register user
        signUpUser(userType: userType)
    }
    
    private func validateSignUp() -> Bool {
        var isValid = true

        if model.name.isEmpty || model.name.count <= 2 {
            fullNameErrorMessage = "enter_full_name".localized()
            isValid = false
        }

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "enter_valid_email".localized()
            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        }

        if model.usersType == .doctor {
            if let jop_specialty_number = model.jop_specialty_number, jop_specialty_number.isEmpty {
                licenseNumberErrorMessage = "enter_license_number".localized()
                isValid = false
            }

            if let specialty_id = model.specialty_id, specialty_id.isEmpty {
                specializationErrorMessage = "enter_specialization".localized()
                isValid = false
            }
        }

        return isValid
    }
    
    private func clearErrors() {
        fullNameErrorMessage = ""
        emailErrorMessage = ""
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
        specializationErrorMessage = ""
        licenseNumberErrorMessage = ""
        successMessage = ""
        errorMessage = ""
    }
    
  
    private func signUpUser(userType : UsersType) {
        isLoading = true
        let url = "http://127.0.0.1:8000/api/register"
        let method  : String = "POST"
        let parameterDoctor = model.toDictionary()
        let parameterPatient = model.toDictionaryPatient()
        
        guard  let urlRequest = URL(string: url) else {
            print("uri error Not Found!!")
            return
        }
        var request = URLRequest(url: urlRequest)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: userType == .doctor  ? parameterDoctor : parameterPatient)
        
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "error reading Request Body")")
        
        
       let  task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
           
           guard let response = response as? HTTPURLResponse else {
               print(APIError.serverError(message: "serverError"))
               DispatchQueue.main.async {
                   self?.isLoading = false
                   self?.successMessage = "error to create account".localized()
               }
               return
           }
           guard response.statusCode >= 200 && response.statusCode < 300 else {
               let message = response.statusCode == 401 ? "Unauthorized" : "Server Error"
               print(APIError.serverError(message: message))
               DispatchQueue.main.async {
                   self?.isLoading = false
                   self?.successMessage = "email is already registered!!".localized()
               }
               print("Status Code: \(response.statusCode)")
               return
           }

           if let error {
               print("error to signup :\(error)")
               return
           }
           
            guard let data = data else {
                print(APIError.noData)
                return
            }
           
           DispatchQueue.main.async {
               self?.isLoading = false
               self?.successMessage = "signup_success".localized()
               print("SignUp Success: \(data)")
           }
           
       }
        task.resume()
    }
    
    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .decodingError:
                emailErrorMessage = "response_parsing_error".localized()
            default:
                errorMessage = error.localizedDescription // استخدم خطأ عام
            }
        } else {
            errorMessage = error.localizedDescription // خطأ عام
        }
        print("API Error: \(error.localizedDescription)")
    }
}
