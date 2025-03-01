//
//  changePasswordView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct changePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    var usersType: UsersType // نوع المستخدم
    @StateObject private var changePasswordViewModel = ChangePasswordViewModel()
    @State private var isSuccessAlertPresented = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        
        VStack{
            HStack {
                Text("change_password".localized())
                .font(.title)
                Spacer()
            }
            .padding(.vertical)
            
            // MARK: - Old Password Field
            VStack{
                PasswordField(
                    password: $changePasswordViewModel.model.old_password,
                    placeholder: "enter_old_password".localized(),
                    label: "old_password".localized()
                )
                
                // Error Message for Password
                if !changePasswordViewModel.passwordErrorMessage.isEmpty {
                    Text(changePasswordViewModel.passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
            }
            }
            .padding(.top)



            // MARK: - New Password Field
            VStack{
                PasswordField(
                    password: $changePasswordViewModel.model.password,
                    placeholder: "enter_password".localized(),
                    label: "password".localized()
                )

            // Error Message for Password
            if !changePasswordViewModel.passwordErrorMessage.isEmpty {
                Text(changePasswordViewModel.passwordErrorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

            }
            }
            .padding(.top)
    
            

            // MARK: - Confirm Password Field
            VStack{
                PasswordField(
                    password: $changePasswordViewModel.model.confirmPassword,
                    placeholder: "confirm_password".localized(),
                    label: "confirm_password_label".localized()
                )
            // Error Message for Confirm Password
            if !changePasswordViewModel.confirmPasswordErrorMessage.isEmpty {
                Text(changePasswordViewModel.confirmPasswordErrorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

            }
            }
            .padding(.top)
            
            // MARK: - Submit Button
            Button(action: {
                changePasswordViewModel.validateAndChangePassword { _ in
                    self.isSuccessAlertPresented = true
                }
            }){
                Text("confirm".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.top,30)
            
            // Success Alert
            .alert(changePasswordViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("ok", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            Spacer()
            
        }
        .padding()
        .direction(appLanguage) // ضبط اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط البيئة
    
  
            
        
    }
}

#Preview {
    changePasswordView(usersType: .doctor)
}
