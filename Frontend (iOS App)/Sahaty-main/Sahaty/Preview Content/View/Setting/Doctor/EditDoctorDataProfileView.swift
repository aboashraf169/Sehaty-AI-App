//
//  EditProfileView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//
import Foundation
import SwiftUI
import PhotosUI


struct EditDoctorDataProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
    @State private var showAlert = false
    let imagePath: String
    @ObservedObject var viewModel : DoctorProfileViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
            VStack(spacing: 20) {
                // Profile Picture
                VStack() {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        if let selectedImage = viewModel.doctorProfileImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        else if let image = viewModel.doctor.img {
                          Image(image)
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
                    
                    Text(viewModel.doctor.name)
                        .font(.headline)
                        .fontWeight(.medium)
                   
                }
                    .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
                    .onChange(of: selectedImageItem) { _, newValue in
                    }
                
                Divider()
            ScrollView{
                                
                EditField(title: "name".localized(), text: $viewModel.doctor.name)

                EditField(title: "personal_bio".localized(),
                                text: Binding(
                                    get: { viewModel.doctor.bio ?? "" },
                                set: { viewModel.doctor.bio = $0 }))
                
                EditField(title: "email".localized(), text: $viewModel.doctor.email)
                EditField(
                    title: "license_number".localized(),
                    text: Binding(
                        get: { viewModel.doctor.jopSpecialtyNumber},
                        set: { viewModel.doctor.jopSpecialtyNumber = $0}
                    )
                )

                }
                
                // Save Button
                Button(action: {
                    viewModel.updateData(UpdateData: viewModel.doctor) { result in
                        if result {
                            showAlert = true
                            print("updated successfly")
                        }else{
                            print("not update data")
                        }
                    }
                }){
                    Text("save_changes".localized())
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding()
                .alert(viewModel.successMessage, isPresented: $showAlert) {
                    Button("الغاء",role: .cancel){
                        presentationMode.wrappedValue.dismiss()
                    }
                }

            }
             .direction(appLanguage) // ضبط الاتجاه
             .environment(\.locale, .init(identifier: appLanguage))
             .onAppear {
                 viewModel.loadImage(from: imagePath)
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




#Preview{
    EditDoctorDataProfileView(imagePath: "", viewModel: DoctorProfileViewModel())
}
