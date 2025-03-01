//
//  ImageUploader.swift
//  Sahaty
//
//  Created by mido mj on 1/29/25.
//


import Foundation
import SwiftUI
import UIKit
import CoreImage


class ImageManager {
    
    static let shared = ImageManager()
    private let baseURL = "http://127.0.0.1:8000/"
    var bearerToken = KeychainManager.shared.getToken()

    
    // MARK: - Function to upload an image
    func uploadImage(image: UIImage, url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let convertedImage = convertToSupportedFormat(image: image) else {
            completion(.failure(NSError(domain: "Image Conversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unsupported image format"])))
            return
        }
        
        guard let uploadURL = URL(string: url) else {
            print("Error: Invalid URL")
            return
        }
        print("URL for uploadImage \(uploadURL)")
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let token = bearerToken {
            print("Bearer Token being sent: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        var body = Data()
        
        // Add image data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"img\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(convertedImage.data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body

        // Start the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async{
                if let error = error{
                    completion(.failure(error))
                    return
                }
                guard let data = data
                 else {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                    return
                }
                print("success uploded image in manager image")
                completion(.success(data))
            }
        }.resume()
    }
    
    
    // MARK: - Function to fetch an image from server
    func fetchImage(imagePath: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else{
            print("Error: Invalid Image URL")
            completion(nil)
            return
        }
        print("URL for fetchImage \(url)")
        
        URLSession.shared.dataTask(with: url) {data,response,error in
            DispatchQueue.main.async{
                // 1) تحقق من وجود خطأ اتصال
                if let error = error{
                    print("Failed to fetch image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // 2) تحقق من كود الاستجابة
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code:", httpResponse.statusCode)
                    if httpResponse.statusCode != 200 {
                        print("Server returned non-200 status code")
                        completion(nil)
                        return
                    }
                }
                // 3) تحقق من أن البيانات غير فارغة
                guard let data = data else {
                    print("No data returned from server")
                    completion(nil)
                    return
                }
                print("success to fetch image in fetchImage")
                // 4) طباعة البيانات كـ نص للمساعدة في التشخيص
                if let debugString = String(data: data, encoding: .utf8) {
                    print("Response Data Debug:\n\(debugString)")
                }
                
                // 5) محاولة تحويل البيانات إلى UIImage
                if let image = UIImage(data: data) {
                    print("success to conver image to UIImage in fetchImage")
                    completion(image)
                } else {
                    print("Error: Image data is invalid")
                    completion(nil)
                }
            }
        }.resume()
    }


}

func convertToSupportedFormat(image: UIImage) -> (data: Data, mimeType: String, fileExtension: String)? {
    // إذا كان بالإمكان تحويل الصورة إلى JPEG، نستخدمها لأنها الأقل حجمًا
    if let jpegData = image.jpegData(compressionQuality: 0.9) {
        return (jpegData, "image/jpeg", "jpg")
    }
    
    // إذا كان PNG هو الخيار المتاح، نستخدمه
    if let pngData = image.pngData() {
        return (pngData, "image/png", "png")
    }
    
    // ⚡ تحويل HEIC إلى PNG باستخدام CoreImage
    if let ciImage = CIImage(image: image) {
        let context = CIContext()
        if let heicData = context.heifRepresentation(of: ciImage, format: .RGBA8, colorSpace: ciImage.colorSpace!, options: [:]) {
            return (heicData, "image/heic", "heic")
        }
    }
    
    // إذا لم نتمكن من التحويل، نعيد nil
    return nil
}




struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: (UIImage) -> Void // ✅ دالة تُستدعى عند اختيار الصورة

    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImagePicked(image) // ✅ يتم استدعاء الدالة هنا عند اختيار الصورة
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

