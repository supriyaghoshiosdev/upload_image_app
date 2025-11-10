//
//  DashboardViewModel.swift
//  Upload Image
//
//  Created by Supriya on 11/02/25.
//

import SwiftUI
import FirebaseDatabase
import FirebaseCore


@MainActor
class DashboardViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var downloadedImage: UIImage? = nil
    @Published var isLoading = false
    @Published var uploadProgress: Double = 0.0
    @Published var uploadSuccess: Bool = false
    
    
    private var dbRef: DatabaseReference {
        Database.database().reference()
    }
    
    // MARK: - Upload Base64 image to Realtime Database
    func uploadImage() {
        guard let image = selectedImage else { return }
        isLoading = true
        uploadProgress = 0
        uploadSuccess = false
        
        DispatchQueue.global(qos: .background).async {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            let base64String = imageData.base64EncodedString()
            
            // Store inside "images" node with unique ID
            let imagesRef = Database.database().reference().child("images").childByAutoId()
            
            // Simulate progress for UI (optional)
            for i in 1...10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                    self.uploadProgress = Double(i) / 10.0
                }
            }
            
            // Upload base64 string under unique child
            imagesRef.setValue(base64String) { error, _ in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        print("Upload error: \(error.localizedDescription)")
                        return
                    }
                    
                    self.uploadProgress = 1.0
                    self.uploadSuccess = true
                    
                    print("Image uploaded successfully to Firebase")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.uploadSuccess = false
                            self.selectedImage = nil
                        }
                    }
                }
            }
        }
    }
}



