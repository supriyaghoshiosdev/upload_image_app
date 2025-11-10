//
//  DashboardView.swift
//  Upload Image
//
//  Created by Supriya on 11/02/25.
//

import SwiftUI
import AVFoundation
import Photos

struct DashboardView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @ObservedObject var tabViewModel: TabBarViewModel
    @EnvironmentObject var routeManager: RouteManager
    
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showPermissionAlert = false
    @State private var permissionMessage = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.MainThemeColor.edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        
                        // MARK: - Title + Subtitle
                        VStack(spacing: 15) {
                            Text("Upload your photo")
                                .font(.appBoldFont(size: 32))
                                .foregroundStyle(Color.white)
                            
                            Text("Regulations require you to upload a profile image. Don't worry, your data will stay safe and private.")
                                .font(.appRegularFont(size: 18))
                                .foregroundColor(Color.SubtitleColor)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        .padding(.horizontal)
                        
                        // MARK: - File Upload Box
                        VStack {
                            if let image = viewModel.selectedImage {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.green, lineWidth: 2)
                                        )
                                        .clipped()
                                    
                                    // Cross Button (only show if not uploading or after success)
                                    if !viewModel.isLoading && !viewModel.uploadSuccess {
                                        Button(action: {
                                            withAnimation {
                                                viewModel.selectedImage = nil
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 22))
                                                .foregroundColor(.white)
                                                .background(
                                                    Circle()
                                                        .fill(Color.black.opacity(0.5))
                                                        .frame(width: 28, height: 28)
                                                )
                                                .offset(x: -8, y: 8)
                                        }
                                    }

                                    // MARK: - Uploading Overlay
                                    if viewModel.isLoading {
                                        ZStack {
                                            Color.black.opacity(0.4)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                            
                                            VStack(spacing: 8) {
                                                ProgressView(value: viewModel.uploadProgress)
                                                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                                    .frame(width: 150)
                                                
                                                Text("Uploading \(Int(viewModel.uploadProgress * 100))%")
                                                    .font(.appRegularFont(size: 14))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .frame(height: 200)
                                        .transition(.opacity)
                                    }

                                    // MARK: - Upload Success Overlay
                                    if viewModel.uploadSuccess {
                                        ZStack {
                                            Color.green.opacity(0.85)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                            
                                            VStack(spacing: 10) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.white)
                                                Text("Image uploaded successfully")
                                                    .font(.appSemiboldFont(size: 16))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .frame(height: 200)
                                        .transition(.opacity)
                                    }
                                }
                                .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.uploadSuccess)

                            } else {
                                VStack(spacing: 10) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color.white.opacity(0.6))
                                    
                                    Text("Select file")
                                        .font(.appRegularFont(size: 18))
                                        .foregroundColor(Color.white.opacity(0.8))
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                                .onTapGesture {
                                    checkPhotoLibraryPermission()
                                }
                            }
                        }
                        .padding(.horizontal, 30)

                        
                        // MARK: - OR Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.white.opacity(0.2))
                            Text("or")
                                .foregroundColor(Color.white.opacity(0.6))
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.white.opacity(0.2))
                        }
                        .padding(.horizontal, 40)
                        
                        // MARK: - Camera Button
                        Button(action: {
                            checkCameraPermission()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "camera.fill")
                                Text("Open Camera & Take Photo")
                            }
                            .font(.appSemiboldFont(size: 16))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        // MARK: - Continue Button
                        Button(action: {
                            viewModel.uploadImage()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Continue")
                                    .font(.appSemiboldFont(size: 16))
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color.ButtonColor)
                        .clipShape(Capsule())
                        .padding(.horizontal, 30)
                        .padding(.bottom, 90)
                    }
                }
            }
            // Sheets
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage)
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage)
            }
            // Alert if permission denied
            .alert(isPresented: $showPermissionAlert) {
                Alert(
                    title: Text("Permission Required"),
                    message: Text(permissionMessage),
                    primaryButton: .default(Text("Settings"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    // MARK: - Permission Handlers
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            showImagePicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async { showImagePicker = true }
                } else {
                    DispatchQueue.main.async {
                        permissionMessage = "Photo library access is needed to select a profile picture."
                        showPermissionAlert = true
                    }
                }
            }
        default:
            permissionMessage = "Photo library access is needed to select a profile picture."
            showPermissionAlert = true
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        showCamera = true
                    } else {
                        permissionMessage = "Camera access is needed to take a photo."
                        showPermissionAlert = true
                    }
                }
            }
        default:
            permissionMessage = "Camera access is needed to take a photo."
            showPermissionAlert = true
        }
    }
}



// MARK: - UIKit Image Picker Wrapper
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
