//
//  EditAdviceSheetView.swift
//  Sahaty
//
//  Created by mido mj on 1/22/25.
//

import SwiftUI

struct EditAdviceSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var advice: AdviceModel
    @AppStorage("appLanguage") private var appLanguage = "ar"
    var onSave: (AdviceModel) -> Void
    var body: some View {
        VStack {
            // العنوان
            Text("edit_advice".localized())
                .font(.title)
                .padding(.vertical)

//             إدخال النص
            TextEditor(text: $advice.advice)
                .frame(height: 150)
                .padding(5)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)

//             زر الحفظ
            Button {
                onSave(advice)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("edit".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.top)
            }
        }
        .padding()
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }
}

#Preview {
    EditAdviceSheetView(advice: AdviceModel(id: 0, advice: ""), onSave: {_ in})
}
