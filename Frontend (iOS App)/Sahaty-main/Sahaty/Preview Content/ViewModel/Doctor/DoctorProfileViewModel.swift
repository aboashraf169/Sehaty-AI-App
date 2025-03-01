import Foundation
import SwiftUI

class DoctorProfileViewModel: ObservableObject {
    @Published var doctor: DoctorModel = DoctorModel()
    @Published var doctorInfo: DoctorInfoData = DoctorInfoData()
    @Published var doctorProfileImage: UIImage? = nil
    @Published var isSaveEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String = ""
    @AppStorage("isDarkModeDoctor")  var isDarkModeDoctor = false

    private let imageManager = ImageManager.shared

    // MARK: - get Doctor Data in login ViewModel
    func setDoctor(_ doctor: DoctorModel) {
         self.doctor = doctor
     }
    
    func updateData(UpdateData: DoctorModel,completien : @escaping (Bool) -> Void){
    clearErrors()
    guard validateData() else{
        completien(false)
        return
    }
    self.isLoading = true
    APIManager.shared.sendRequest(
        endpoint: "/doctor/update-profile",
        method: .post,
        parameters: [
            "name":UpdateData.name,
            "email":UpdateData.email,
            "bio": UpdateData.bio ?? "",
            "jop_specialty_number":UpdateData.jopSpecialtyNumber
            ]
    )
    {[weak self] result in
        DispatchQueue.main.async {
            self?.isLoading = false
            switch result {
            case .success(let data):
                completien(true)
                self?.successMessage = "success_update_data".localized()
                print("Success Update Data: \(String(data: data, encoding: .utf8) ?? "")")
                
                guard let decodingData = try? JSONDecoder().decode(Response.self, from: data) else {
                    print("error to decode data)")
                    return
                }
                print("success to decode data:\(decodingData)")
                self?.doctor = decodingData.user
            
            case .failure(let error):
                completien(false)
                print("error Update Data: \(error)")
                self?.errorMessage = "unsuccess_update_data".localized()
            }
        }
    }
}
    
    private func validateData() -> Bool{
      var isValid: Bool = true
        
        if doctor.email.isEmpty || !doctor.email.contains("@") {
            errorMessage = "enter_valid_email".localized()
            isValid = false
        }
        if doctor.jopSpecialtyNumber.isEmpty || doctor.jopSpecialtyNumber.count < 4{
            errorMessage = "enter_valid_jobSpecialtyNumber".localized()
            isValid = false
        }
        if doctor.name.isEmpty || doctor.name.count < 3{
            errorMessage = "name".localized()
            isValid = false
        }
        return isValid
    }
    
    func getInfoData(){
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/doctor/info", method: .get) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLoading = false
                switch result {
                    case .success(let data):
                    guard let deccodeData = try? JSONDecoder().decode(DoctorInfoData.self, from: data) else {
                    print("error to decode info doctor data")
                        return
                    }
                    print("get info doctor data success")
                    self?.successMessage = "get info doctor data success:\(deccodeData)"
                    self?.doctorInfo = deccodeData
                    
                    self?.loadImage(from: deccodeData.doctor_img)
                    
                    case .failure(let error):
                    self?.successMessage = "error to get info doctor data:\(error)"
                    print("error to get info doctor data:\(error)")

                }
            }
            
        }
    }
    
    

    private func clearErrors() {
        errorMessage = ""
    }
    
    func loadImage(from path: String) {
        ImageManager.shared.fetchImage(imagePath: path){[weak self] image in
            DispatchQueue.main.async {
                self?.doctorProfileImage = image
                print("image doctor Profile : \(path)")
            }
        }
    }
    
    func updateProfileImage(newImage: UIImage) {
        let uploadURL = "http://127.0.0.1:8000/api/doctor/update-img"
        isLoading = true
        imageManager.uploadImage(image: newImage, url: uploadURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPath):
                    
                    print("susses update image : \(newPath)")
                    guard let decodedData = try? JSONDecoder().decode(responseDoctorImg.self, from: newPath) else {
                        print("error to decode response doctor img!!!")
                        return
                    }
//                    let baseURL = "http://127.0.0.1:8000"
//                    let fullImageURL = baseURL + decodedData.image_url
                    self?.doctor.img = decodedData.image_url
                    self?.loadImage(from: decodedData.image_url)
                    self?.successMessage = decodedData.message
                    print("susses update image  in loadImage: \(decodedData.image_url)")

                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}

struct responseDoctorImg : Codable {
    var message: String
    var image_url : String
}
