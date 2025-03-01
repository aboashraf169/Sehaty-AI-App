import Foundation
import SwiftUI


class AdviceViewModel: ObservableObject {
    // MARK: - Properties
    @Published var doctorAdvices: [AdviceModel] = []
    @Published var userAdvices: [AdviceModel] = []
    @Published var advice: AdviceModel = AdviceModel()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var SuccessMessage: String? = nil
    @Published var selectedAdvice: AdviceModel?

    
    // MARK: - fetch Advices
    func fetchAdvices() {
        isLoading = true
        APIManager.shared.sendRequest(endpoint: "/doctor/get-today-advice", method: .get) { result in
          switch result {
            case .success (let data):
              guard let decodeData = try? JSONDecoder().decode(ResponseAdvice.self, from: data)
              else{
                  print("error to decding advice")
                  return
              }
                  DispatchQueue.main.async{ [weak self]  in
                    self?.isLoading = false
                      self?.doctorAdvices = decodeData.data
                  }
                  print("fetch Advices successfully")
              
            case .failure(let error):
              print("error to get advice")
              print("error :\(error)")
            }
        }
    }
    
    
    // MARK: - Add Advice
    func AddAdvices(advice : AdviceModel,complitien : @escaping (Bool) -> Void){
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/doctor/advice/store", method: .post, parameters: advice.toDictionary()) { Result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false

                switch Result {
                    case .success(let data):
                    self?.SuccessMessage = "added advice successfully"
                    print("added advice successfully")
                    self?.advice.advice = ""
                    complitien(true)
                    guard let decodeData = try? JSONDecoder().decode(ResponAddUpdateAdvice.self, from: data) else {
                        print("Could not decode JSON")
                        complitien(false)
                        return
                    }
                    self?.doctorAdvices.append(decodeData.data)
                    case .failure(let error):
                    self?.errorMessage = "error add advice!!"
                    print("error to add advice")
                    print("error :\(error)")
                    complitien(false)
                }
                
            }
        }
    }
    
    
    // MARK: - Update Advice
    func updateAdvice(advice : AdviceModel, complitien : @escaping (Bool) -> Void){
        self.isLoading = true
        APIManager.shared.sendRequest(
            endpoint: "/doctor/advice/\(advice.id)/update",
            method: .post,
            parameters: ["advice" : advice.advice]
        ) { Result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch Result {
                case .success(let data):
                    self?.SuccessMessage = "Update Advice Success"
                    print("update success \(data)")
                    complitien(true)
                    if let index =
                        self?.doctorAdvices.firstIndex(where: { $0.id == advice.id }){
                        self?.doctorAdvices[index] = advice
                    }
                case.failure(let error):
                    self?.errorMessage = "error update advice!!"
                    print("erorr update adivce: \(error)")
                    complitien(false)
                }
            }
        }
    }
    
    
    // MARK: - Delete Advice
    func deleteAdvice(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let item = doctorAdvices[index]
        APIManager.shared.sendRequest(endpoint: "/doctor/advice/\(item.id)/destroy", method: .delete) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(_):
                    self?.doctorAdvices.remove(at: index)
                    print("Item deleted successfully")
                    self?.SuccessMessage = "Delete Advice Success"
                case .failure(let error):
                    print("error Advice Success\(error.localizedDescription)")
                }
                
            }
        }
    }
    
    
    // MARK: - get User Advices
    func getUserAdvice() {
        APIManager.shared.sendRequest(endpoint: "/user/get-today-advice", method: .get) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let data):
                    guard let decodeData = try? JSONDecoder().decode(ResponseAdvice.self, from: data)else {
                        print("error to decode  user data advice")
                        return
                    }
                    self?.userAdvices = decodeData.data
                    print("get user advicies Success!!!")
                case .failure(let error):
                    print("error to Advice:\(error)")

                }
                
            }
        }
    }
    
}
