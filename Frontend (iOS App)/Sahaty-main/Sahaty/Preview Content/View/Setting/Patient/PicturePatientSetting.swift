//
//  PicturePatientSetting.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct PicturePatientSetting: View {
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack() {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)

                }
                
                else if let image = patientViewModel.patient.img {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)

                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.accentColor)
                        .shadow(radius: 5)
                }
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "camera.fill")
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                .offset(x: -40, y: 40)
                
     
            }

        }
        .direction(appLanguage) // ضبط اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط البيئة
    
    }
}
