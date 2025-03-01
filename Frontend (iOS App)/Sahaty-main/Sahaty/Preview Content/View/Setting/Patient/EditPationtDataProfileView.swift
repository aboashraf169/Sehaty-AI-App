//
//  EditDoctorDataProfileView.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.




import SwiftUI
import PhotosUI

struct EditPationtDataProfileView: View {
    
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture
            VStack() {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
          
                    if let selectedImage = patientViewModel.patientProfileImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    else {
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
                
                Text(patientViewModel.patient.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(patientViewModel.patient.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Divider()
        ScrollView{
            EditField(title: "name".localized(), text: $patientViewModel.patient.name)
            EditField(title: "email".localized(), text: $patientViewModel.patient.email)
            }
            
            // Save Button
            Button(action: {
                
            }) {
                Text("save_changes".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()

        }
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
        .sheet(isPresented: $showImagePicker){
            ImagePicker(selectedImage: $patientViewModel.patientProfileImage) { image in
                patientViewModel.updateProfileImage(newImage: image)
            }
        }


     
    }
    
    
    

    struct EditField: View {
        
        let title: String
        @Binding var text: String
        var body: some View {
            VStack(alignment: .leading,spacing: 0) {
                Text(title)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                TextField("placeholder_text".localized(), text: $text)
                    .font(.callout)
                    .padding()
                    .background(Color(.systemGray6))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical,7)
            .padding(.horizontal)
        }
    }
}


#Preview {
    EditPationtDataProfileView(patientViewModel: PatientSettingViewModel())    
}
