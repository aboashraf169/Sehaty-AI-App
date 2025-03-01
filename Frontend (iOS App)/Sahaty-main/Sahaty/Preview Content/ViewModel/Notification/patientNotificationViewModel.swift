//
//  NotificationViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//

import Foundation

class patientNotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    var apiManager = APIManager.shared
    

     func loadDefaultNotifications() {
        self.isLoading = true
        apiManager.sendRequest(endpoint: "/user/notifications", method: .get) {[weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result{
                case .success(let data):
                    guard let decodedData = try? JSONDecoder().decode([NotificationModel].self, from: data) else {
                        print("error to decoded user data notificarion!!!")
                        return
                    }
                    self?.notifications = decodedData
                    print("success to decoded user data notifications")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
