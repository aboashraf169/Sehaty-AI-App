//
//  SessionManager.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.
//


import Foundation

class SessionManager {
    static let shared = SessionManager() // Singleton instance
    
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainManager.shared
    
    // User-related keys
    private let tokenKey = "userToken"
    private let userTypeKey = "userType"
    private let doctorDataKey = "doctorData"
    private let patientDataKey = "patientData"


    
    
    // MARK: - Save Session
    func saveDocotrSession(token: String,doctorData: DoctorModel) {
           userDefaults.set(token, forKey: tokenKey)
           userDefaults.set("doctor", forKey: userTypeKey)
        // Save user data in UserDefaults
          guard let userData = try? JSONEncoder().encode(doctorData) else{
              print("❌ فشل في تحويل بيانات المستخدم إلى JSON")
              return
          }
          print("✅ بيانات الدكتور تم حفظها بنجاح في UserDefaults")
      
        userDefaults.set(userData, forKey: doctorDataKey)
       }
    
    func savePatientSession(token: String,patientData: PatiantModel) {
           userDefaults.set(token, forKey: tokenKey)
           userDefaults.set("patient", forKey: userTypeKey)
        // Save user data in UserDefaults
          guard let userData = try? JSONEncoder().encode(patientData) else{
              print("❌ فشل في تحويل بيانات المستخدم إلى JSON")
              return
          }
          print("✅ بيانات المريض تم حفظها بنجاح في UserDefaults")
      
        userDefaults.set(userData, forKey: patientDataKey)
       }
   
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
 
    
    func getUserType() -> String? {
        if let userTypeRaw = userDefaults.string(forKey: userTypeKey) {
            return userTypeRaw
        }
        return nil
    }
    
    func getPatientData() -> PatiantModel{
           guard let userData = userDefaults.data(forKey: patientDataKey) else { return PatiantModel() }
           guard let data = try? JSONDecoder().decode(PatiantModel.self, from: userData)
           else{
               print("❌ فشل في تحويل JSON إلى Dictionary")
               return PatiantModel()
           }
           print("✅ بيانات المستخدم المسترجعة")
           return data
       }
    
    func getDoctorData() -> DoctorModel{
          guard let userData = userDefaults.data(forKey: doctorDataKey) else { return DoctorModel() }
          guard let data = try? JSONDecoder().decode(DoctorModel.self, from: userData)
          else{
              print("❌ فشل في تحويل JSON إلى Dictionary")
              return DoctorModel()
          }
          print("✅ بيانات الدكتور المسترجعة")
          return data

      }
    
    func getPatientData() -> PatiantModel? {
        if let patientDataRaw = userDefaults.object(forKey: patientDataKey) as? PatiantModel {
            return patientDataRaw
        }
        return nil
    }


    func clearSession() {
           UserDefaults.standard.removeObject(forKey: tokenKey)
           UserDefaults.standard.removeObject(forKey: userTypeKey)
       }
}


//    // MARK: - Retrieve Session
//    func isUserLoggedIn() -> Bool {
//        return keychain.getToken() != nil
//    }

    // MARK: - Destroy Session
//    func clearSession() {
//        // Remove token from Keychain
//     let _ = keychain.deleteToken(forKey: "BearerToken")
//
//        // Remove user data from UserDefaults
//        userDefaults.removeObject(forKey: userTypeKey)
//        userDefaults.removeObject(forKey: tokenKey)
//    }
