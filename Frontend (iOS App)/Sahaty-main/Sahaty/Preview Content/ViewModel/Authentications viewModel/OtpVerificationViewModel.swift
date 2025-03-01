import Foundation

class OtpVerificationViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = OtpVerificationModel(email: "", otpCode: "")
    @Published var token: String? = nil // لتخزين التوكن بعد التحقق

    // MARK: - Error Message
    @Published var otpErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false

    // MARK: - Initializer
     init(email: String) {
         self.model = OtpVerificationModel(email: email, otpCode: "")
     }
    // MARK: - Validate OTP
    func validateAndVerifyOtp(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateOtp() else {
            print("OTP Validation Failed: \(otpErrorMessage)")
            completion(false)
            return
        }

        // Call API to verify OTP
        verifyOtp(completion: completion)
    }

     func validateOtp() -> Bool {
        var isValid = true

        if model.otpCode.isEmpty || model.otpCode.count != 4 {
            otpErrorMessage = "enter_valid_otp".localized()
            isValid = false
        }

        return isValid
    }

    // MARK: - Clear Errors
    private func clearErrors() {
        otpErrorMessage = ""
        successMessage = ""
    }

    // MARK: - API Call for OTP Verification
    private func verifyOtp(completion: @escaping (Bool) -> Void) {
        isLoading = true
        print("Starting OTP Verification for email: \(model.email)")

        APIManager.shared.sendRequest(
            endpoint: "/check-code",
            method: .post,
            parameters: model.toDictionary()
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    let isVerified = self?.handleOtpVerificationSuccess(data: data) ?? false
                    completion(isVerified)
                case .failure(let error):
                    self?.handleAPIError(error)
                    completion(false)
                }
            }
        }
    }
    
    private func handleOtpVerificationSuccess(data: Data) -> Bool {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let receivedToken = json["token"] as? String {
                print("OTP Verification Success. Token: \(receivedToken)")
                token = receivedToken // تخزين التوكن
                successMessage = "otp_verification_success".localized()
                // يمكنك هنا حفظ التوكن إذا كان ذلك مطلوبًا
                return true
            } else {
                otpErrorMessage = "invalid_otp".localized()
                return false
            }
        } catch {
            print("Failed to parse JSON: \(error.localizedDescription)")
            otpErrorMessage = "response_parsing_error".localized()
            return false
        }
    }


    private func handleAPIError(_ error: Error) {
        otpErrorMessage = "unexpected_error_occurred".localized()

        if let apiError = error as? APIError {
            switch apiError {
            case .decodingError:
                otpErrorMessage = "response_parsing_error".localized()
            default:
                otpErrorMessage = apiError.localizedDescription
            }
        } else {
            otpErrorMessage = error.localizedDescription
        }
        print("API Error: \(otpErrorMessage)")
    }


    // MARK: - Resend OTP
    func resendOtp() {
        print("Resending OTP for email: \(model.email)")
        isLoading = true

        APIManager.shared.sendRequest(
            endpoint: "/resend-otp",
            method: .post,
            parameters: ["email": model.email]
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.handleResendOtpSuccess(data: data)
                case .failure(let error):
                    self?.handleAPIError(error)
                }
            }
        }
    }

    private func handleResendOtpSuccess(data: Data) {
        successMessage = "otp_resend_success".localized()
        print("Resend OTP Success: \(String(data: data, encoding: .utf8) ?? "")")
    }
}
