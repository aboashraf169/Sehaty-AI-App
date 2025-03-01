//
//  LoginViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation
import SwiftUI
class LoginViewModel: ObservableObject {
    @Published var model = LoginModel()
    @Published var sessionManager = SessionManager()
    @Published var doctorModel = DoctorModel()
    @Published var patientModel = PatiantModel()

    // رسائل الأخطاء
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var apiErrorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false


    
    // التحقق من تسجيل الدخول
    func validateAndLogin(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateLogin() else {
            completion(false)
            return
        }
        
        // Call API for login
        loginUser(completion: completion)
    }

    private func validateLogin() -> Bool {
        var isValid = true

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "enter_valid_email".localized()
            apiErrorMessage = "nodata".localized()

            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            apiErrorMessage = "nodata".localized()
            isValid = false
        }

        return isValid
    }

    private func clearErrors() {
        emailErrorMessage = ""
        passwordErrorMessage = ""
        apiErrorMessage = ""
        successMessage = ""
    }

    private func loginUser(completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        APIManager.shared.sendRequest(
            endpoint: "/login",
            method: .post,
            parameters: model.toDictionary()
        ){ [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.handleLoginSuccess(data: data, completion: completion)
                case .failure(let error):
                    self?.handleAPIError(error)
                    self?.apiErrorMessage = "invalid_credentials".localized()
                    completion(false)
                }
            }
        }
    }

    private func handleLoginSuccess(data: Data, completion: @escaping (Bool) -> Void) {
        do {
            // محاولة فك البيانات القادمة من الـ API
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String,
                  let userInfo = json["user"] as? [String: Any]
            else {
                // إذا فشل فك البيانات أو لم يتم العثور على الحقول المتوقعة
                apiErrorMessage = "invalid_credentials".localized()
                print("Login Response Error: Missing expected fields.")
                completion(false)
                return
            }
            print("user data:\(userInfo)")
            let serverUserType = determineUserType(from: userInfo)
            guard model.usersType == serverUserType else {
                apiErrorMessage = "user_type_mismatch".localized() // رسالة توضح الخطأ
                print("User type mismatch: Selected \(model.usersType), Server returned \(serverUserType)")
                completion(false)
                return
            }
            model.usersType = serverUserType
//            sessionManager.saveSession(token: token, userType: serverUserType, userData: userInfo)

            if serverUserType == .doctor{
                guard let doctorData = try? JSONSerialization.data(withJSONObject: userInfo)else{
                    print("erorr ro serializing")
                    return
                }
                guard let doctor = try? JSONDecoder().decode(DoctorModel.self, from: doctorData)
                else{ print("error to decding Doctor Data")
                    return }
                print("Doctor:\(doctor)")
                    self.doctorModel = doctor
                sessionManager.saveDocotrSession(token: token, doctorData: doctor)
                UserDefaults.standard.set(token, forKey: "userToken")
                
                UserDefaults.standard.set(doctor.id, forKey: "currentUserID")
                print("تم حفظ معرف المستخدم:", doctor.id)
            }else{
                guard let PatiantData = try? JSONSerialization.data(withJSONObject: userInfo)else{
                    print("erorr ro serializing")
                    return
                }
                guard let Patiant = try? JSONDecoder().decode(PatiantModel.self, from: PatiantData)
                else{ print("error to decding Patiant Data")
                    return}
                print("Patiant:\(Patiant)")
                    self.patientModel = Patiant
                sessionManager.savePatientSession(token: token, patientData: Patiant)
                UserDefaults.standard.set(Patiant.id, forKey: "currentUserID")
                UserDefaults.standard.set(token, forKey: "userToken")

                print("تم حفظ معرف المستخدم:", Patiant.id)

            }
           
        


            // إذا نجح تسجيل الدخول
            successMessage = "login_success".localized()
            print("Login Response: \(json)")
            // تخزين التوكن
            if KeychainManager.shared.saveToken(token) {
                print("Token saved successfully.")
            } else {
                print("Failed to save token.")
            }
            
            APIManager.shared.setBearerToken(token)

            completion(true)
 
        } catch {
            // التعامل مع أي خطأ أثناء فك البيانات
            apiErrorMessage = "response_parsing_error".localized()
            print("Error parsing login response: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func determineUserType(from userData: [String: Any]) -> UsersType {
        if let _ = userData["jop_specialty_number"] {
            return .doctor
        } else {
            return .patient
        }
    }

    func handleAPIError(_ error: Error) {
    if let apiError = error as? APIError {
        switch apiError {
        case .decodingError:
            apiErrorMessage = "response_parsing_error".localized()
        case .serverError(let message):
            apiErrorMessage = message // رسالة الخطأ القادمة من الخادم
        default:
            apiErrorMessage = "server error send request".localized()
        }
    } else {
        apiErrorMessage = error.localizedDescription
    }
    print("API Error: \(apiErrorMessage)")
}

    func extractToken(from response: String) -> String? {
    guard let data = response.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let token = json["token"] as? String else {
        return nil
    }
    return token
}
}
