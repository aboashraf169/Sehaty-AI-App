//
//  SpecializationViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/21/24.
//


import SwiftUI

class SpecializationViewModel: ObservableObject {
    
    @Published var specializations: [spectialties] = []
    
    let specialtiesTranslation: [String: String] = [
        "أمراض القلب والشرايين": "Cardiology and Vascular Diseases",
        "الجراحة العامة": "General Surgery",
        "الأمراض الباطنية": "Internal Medicine",
        "الأمراض الجلدية": "Dermatology",
        "الأمراض العصبية": "Neurology",
        "الأمراض النفسية": "Psychiatry",
        "الأمراض النسائية والتوليد": "Obstetrics and Gynecology",
        "الأطفال": "Pediatrics",
        "الأورام": "Oncology",
        "الأعصاب والجراحة العصبية": "Neurology and Neurosurgery"
    ]
    @Published var selectedSpecialty: spectialties? // التخصص المختار
    @AppStorage("appLanguage") private var appLanguage = "ar"
    
    @Published var ranslatedSpecialties: [spectialties] = []

   
    func getTranslatedSpecialties() -> [spectialties] {
            if appLanguage == "en" {
                // تحويل التخصصات إلى الإنجليزية باستخدام القاموس
                return specializations.compactMap { specialty in
                    if let translatedName = specialtiesTranslation[specialty.name] {
                        return spectialties(id: specialty.id, name: translatedName)
                    }
                    return nil
                }
            } else {
                // إرجاع التخصصات كما هي (باللغة العربية)
                return specializations
            }
        }
    func getSpacialties() {
       let url = "http://127.0.0.1:8000/api/specialties"
       let method : String = "GET"
       guard let  urlRequest = URL(string: url) else {
           print("uri error Not Found!!")
           return
       }
       var request = URLRequest(url: urlRequest)
       request.httpMethod = method
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue("application/json", forHTTPHeaderField: "Accept")
       
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
       let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
           
           guard let response = response as? HTTPURLResponse else {
               print(APIError.serverError(message: "serverError"))
               return
           }
           guard response.statusCode >= 200 && response.statusCode < 300 else {
               let message = response.statusCode == 401 ? "Unauthorized" : "Server Error"
               print(APIError.serverError(message: message))
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
              guard let decodedData = try? JSONDecoder().decode(dataSpectialties.self, from: data) else {
                  print("error fetch data!!!!!")
                  return
              }
              self?.specializations = decodedData.data
              self?.selectedSpecialty = self?.specializations.first // تعيين أول تخصص كافتراضي
              print("fetch specialties successfully!: \(decodedData)")

          }

       }
       task.resume()
   }
   
}
    
