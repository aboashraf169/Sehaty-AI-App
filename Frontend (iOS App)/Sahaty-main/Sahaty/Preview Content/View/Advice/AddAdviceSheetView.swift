import SwiftUI
struct AddAdviceSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var adviceViewModel: AdviceViewModel
    @State var adiveText: String = ""
    @AppStorage("appLanguage") private var appLanguage = "ar"

    var body: some View {
        VStack {
            // العنوان
            Text("create_daily_advice".localized())
                .font(.title)
                .padding(.vertical)
            

//             إدخال النص
            TextEditor(text: $adviceViewModel.advice.advice)
                .frame(height: 150)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)

//             زر الحفظ
            Button {
                adviceViewModel.AddAdvices(advice: adviceViewModel.advice) { _ in
                    print("advice successfully added")
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("publish".localized())
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
    AddAdviceSheetView(adviceViewModel:  AdviceViewModel())
}
