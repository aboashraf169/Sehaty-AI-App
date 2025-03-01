//
//  PatientSettingModelView.swift
//  Sahaty
//
//  Created by mido mj on 1/21/25.
//

import Foundation
import SwiftUI

struct responseFollowDoctor : Codable {
    let message: String
    let following: Bool
}

class PatientSettingViewModel : ObservableObject {
    
    @Published var patient = PatiantModel()
    @Published var doctorFollowers : [DoctorModel] = [] {
        didSet {
            if doctorFollowers.isEmpty {
                articlesViewModel.articals = []
            }
        }
    }
    @Published var articlesViewModel = ArticalsViewModel()
    @Published var spaclizationDctors : [DoctorModel] = []
    @Published var doctorsBySpecialization: [Int: [DoctorModel]] = [:] // تخزين الأطباء لكل تخصص
    @Published var patientProfileImage: UIImage? = nil
    @Published var doctorImages: [Int: UIImage] = [:]
    @Published var doctorsIsFollow: [Int: Bool] = [:]
    @Published var expandedSpecializations: [Int: Bool] = [:]     // حالة التوسيع لكل تخصص
    @Published var isLoading : Bool = false
    private let imageManager = ImageManager.shared
    @AppStorage("isDarkModePatient")  var isDarkModePatient = false // حفظ الاختيار

    // MARK: - Set Patient Data
    func SetPateintData(_ patient : PatiantModel){
        self.patient = patient
        self.loadImage(from: patient.img ?? "")

        
    }
    
    // MARK: - get doctor Follow data
    func getDoctorsFollowers(){
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/user/doctors", method: .get) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLoading = false
                switch result {
                case.success(let data):
                    guard let decodeData = try? JSONDecoder().decode([DoctorModel].self, from: data)else {
                        print("error to decode doctor follower data")
                        return
                    }
                    self?.doctorFollowers = decodeData
                    print("success to get followers doctors")
                case.failure(let error):
                    print("error to get followers doctors: \(error)")
                }
            }
        }
    }
    
    // MARK: -  get Speciaty Doctors data
    func getSpeciatyDoctors(speciatyid: Int){
       self.isLoading = true
       APIManager.shared.sendRequest(endpoint: "/speciaty/\(speciatyid)/doctors", method: .get) { result in
           DispatchQueue.main.async {[weak self] in
               self?.isLoading = false
               switch result {
               case.success(let data):
                   guard let decodeData = try? JSONDecoder().decode(ResponseSpeciatyDoctor.self, from: data)else {
                       print("error to decode doctor follower data")
                       return
                   }
                   self?.doctorsBySpecialization[speciatyid] = decodeData.data
                   print("success to get Speciaty Doctors doctors: \(speciatyid)")
               case .failure(let error) :
                   print("error to get data for spaclity:\(error)")
               }
           }
       }
        
    }
    
    // MARK: -  action follow doctor
    func actionFollowDoctor(doctorId : Int) {
        self.isLoading = true
        
        APIManager.shared.sendRequest(endpoint: "/user/follow-doctor/\(doctorId)",method: .post) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLoading = false
                switch result {
                    case .success(let data):
                    guard let decodeData = try? JSONDecoder().decode(responseFollowDoctor.self, from: data) else {
                        print("error to decode action Follow Doctor data")
                        return
                    }
                    print("Doctor follower data id:\(doctorId):\(decodeData.message)")
                    // تحديث حالة المتابعة بناءً على وجود كلمة "unfollow" في الرسالة
                                    if decodeData.message.lowercased().contains("unfollow") {
                                        self?.doctorsIsFollow[doctorId] = false
                                    } else {
                                        self?.doctorsIsFollow[doctorId] = true
                                    }
                    case.failure(let error):
                    print("error to decode action Follow Doctor data: \(error)")

                }
            }
        }
        
    }
    // MARK: - Image
    func loadImage(from path: String) {
        ImageManager.shared.fetchImage(imagePath: path){[weak self] image in
            DispatchQueue.main.async {
                self?.patientProfileImage = image
                print("image patient Profile : \(path)")
            }
        }
    }
    
    func doctorImage(from path: String,for doctorId: Int) {
        ImageManager.shared.fetchImage(imagePath: path) { image in
            DispatchQueue.main.async {[weak self] in
                self?.doctorImages[doctorId] = image
            }
        }
    }
    
    func updateProfileImage(newImage: UIImage) {
        
        let uploadURL = "http://127.0.0.1:8000/api/user/update-img"
        isLoading = true
        imageManager.uploadImage(image: newImage, url: uploadURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPath):
                    
                    print("susses update image : \(newPath)")
                    guard let decodedData = try? JSONDecoder().decode(responsePatientImg.self, from: newPath) else {
                        print("error to decode response doctor img!!!")
                        return
                    }
                    self?.patient.img = decodedData.image_url
                    self?.loadImage(from: decodedData.image_url)
                    print("susses update image  in loadImage: \(decodedData.image_url)")

                case .failure(let error):
                    print("error updateProfileImage: \(error)")
                }
            }
        }
    }


}
struct responsePatientImg : Codable {
    var message: String
    var image_url : String
}
