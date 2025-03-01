//
//  PasswordField.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//



// لانشاء text field مخصص
// الهدف منه عند اضافة رمز اظهار كلمة المرور يتم اظهارها والعكس

import SwiftUI

struct PasswordField: View {
    
    @Binding var password: String
    @State private var isSecure: Bool = true
    var placeholder: String
    var label: String
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack(alignment: .leading) {
            
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)
            HStack {
                // حالة الاخفاء لكلمة المرور
                if isSecure {
                    SecureField(placeholder, text: $password)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .foregroundStyle(.secondary)
                } else {
                    
                // حالة الاظهار لكلمة المرور
                    TextField(placeholder, text: $password)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .foregroundStyle(.secondary)


                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
    }
}
