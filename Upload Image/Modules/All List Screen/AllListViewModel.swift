//
//  AllListViewModel.swift
//  Upload Image
//
//  Created by Supriya on 11/11/25.
//

import SwiftUI
import FirebaseDatabase
import FirebaseCore

@MainActor
class AllListViewModel: ObservableObject {
    @Published var allImages: [(id: String, image: UIImage)] = []
    @Published var isLoading = false
    
    private var dbRef: DatabaseReference {
        Database.database().reference()
    }
    
    // MARK: - Fetch All Images
    func fetchAllImages() {
        isLoading = true
        allImages.removeAll()
        
        dbRef.child("images").observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let imagesDict = snapshot.value as? [String: String] else {
                print("No images found in database")
                return
            }
            
            var loadedImages: [(id: String, image: UIImage)] = []
            
            for (key, base64String) in imagesDict {
                if let imageData = Data(base64Encoded: base64String),
                   let uiImage = UIImage(data: imageData) {
                    loadedImages.append((id: key, image: uiImage))
                } else {
                    print("Failed to decode image for key: \(key)")
                }
            }
            
            DispatchQueue.main.async {
                self.allImages = loadedImages
            }
        }
    }
    
    // MARK: - Delete Image
    func deleteImage(withId id: String) {
        dbRef.child("images").child(id).removeValue { error, _ in
            if let error = error {
                print("Failed to delete image: \(error.localizedDescription)")
                return
            }
            print("Deleted image with ID: \(id)")
            DispatchQueue.main.async {
                self.allImages.removeAll { $0.id == id }
            }
        }
    }
}
