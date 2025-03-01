//
//  NotificationViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//

import Foundation

class doctorNotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    var apiManager = APIManager.shared

  
     func loadDefaultNotifications(){
        isLoading = true
        apiManager.sendRequest(endpoint: "/doctor/notifications", method: .get) {result in
            DispatchQueue.main.async { [weak self] in
                switch result{
                case .success(let data):
                    self?.isLoading = false
                    guard let decodedData = try? JSONDecoder().decode([NotificationModel].self, from: data) else {
                        print("error to decoded doctor data notificarion!!!")
                        return
                    }
                    print("success to decoded doctor data notifications")
                    self?.notifications = decodedData
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
