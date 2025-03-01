import SwiftUI
import SwiftUI

struct OtpVerificationView: View {
    @StateObject private var otpViewModel : OtpVerificationViewModel
    @State private var otpDigits: [String] = ["", "", "", ""] // إدخالات لكل رقم
    @State private var resendTimer: Int = 60 // العداد الزمني
    @State private var canResend: Bool = false
    @State private var timer: Timer?
    @State private var isSuccessAlertPresented = false
    @State private var showNewPasswordView = false // عرض شاشة كلمة جديد
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    // لتحديد الحقل الحالي المركّز عليه
    @FocusState private var focusedField: Int?
    @State private var token: String? = nil // تخزين التوكن عند التحقق الناجح

    // MARK: - Initializer
    init(email: String) {
        _otpViewModel = StateObject(wrappedValue: OtpVerificationViewModel(email: email))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                headerView()

                otpInputView()

                if !otpViewModel.otpErrorMessage.isEmpty {
                    errorMessageView()
                }

                verifyButton()

                resendTimerView()
            }
            .padding()
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
            .alert(otpViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("ok".localized(), role: .cancel) {
                    token = otpViewModel.token // تخزين التوكن
                    showNewPasswordView = true
                }
            }
            .navigationDestination(isPresented: $showNewPasswordView) {
                if let token = token {
                    NewPasswordView(token: token) // تمرير التوكن المفكوك التغليف
                } else {
                    Text("Error: Token not found.") // في حال عدم وجود التوكن
                }
            }
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }

    // MARK: - Header View
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("otp_sent_message".localized())
                .font(.headline)
                .foregroundColor(Color.accentColor)
                .multilineTextAlignment(.leading)

            Text(otpViewModel.model.email)
                .font(.callout)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - OTP Input View
    private func otpInputView() -> some View {
        HStack(spacing: 25) {
            ForEach(0..<otpDigits.count, id: \.self) { index in
                TextField("", text: $otpDigits[index])
                    .keyboardType(.numberPad)
                    .frame(width: 60, height: 60)
                    .multilineTextAlignment(.center)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .focused($focusedField, equals: index) // ربط الحقل المركّز عليه
                    .onChange(of: otpDigits[index]) {
                        if otpDigits[index].count > 1 {
                        otpDigits[index] = String(otpDigits[index].prefix(1))
                        }
                        // الانتقال إلى الحقل التالي عند إدخال رقم
                        if !otpDigits[index].isEmpty && index < otpDigits.count - 1{
                        focusedField = index + 1
                        } else if index == otpDigits.count - 1 {
                            // إخفاء لوحة المفاتيح عند آخر حقل
                            focusedField = nil
                        }
                 }
            }
        }
        .padding(.horizontal, 20)
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
                   focusedField = 0 // التركيز على الحقل الأول عند الظهور
               }
    }

    // MARK: - Error Message View
    private func errorMessageView() -> some View {
        Text(otpViewModel.otpErrorMessage)
            .font(.caption)
            .foregroundColor(.red)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Verify Button
    private func verifyButton() -> some View {
        Button(action: {
            otpViewModel.model.otpCode = otpDigits.joined()
            otpViewModel.validateAndVerifyOtp { success in
                if success {
                    isSuccessAlertPresented = true
                }
            }
        }) {
            Text("verify".localized())
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(10)
        }
        .padding(.top, 20)
    }

    // MARK: - Resend Timer View
    private func resendTimerView() -> some View {
        if !canResend {
            AnyView(
                HStack(spacing: 5) {
                    Text("resend_otp_in".localized())
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("00:\(String(format: "%02d", resendTimer))")
                        .font(.caption)
                        .foregroundColor(Color.purple)
                }
            )
        } else {
            AnyView(
                Button(action: resendOtp) {
                    Text("resend_otp".localized())
                        .font(.caption)
                        .foregroundColor(Color.purple)
                }
            )
        }

    }

    // MARK: - Timer Management
    private func startTimer() {
        resendTimer = 60
        canResend = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if resendTimer > 0 {
                resendTimer -= 1
            } else {
                canResend = true
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resendOtp() {
        stopTimer()
        startTimer()
        otpViewModel.resendOtp()
    }
}

// MARK: - Preview
#Preview {
    OtpVerificationView(email: "mona@gmail.com")
}
