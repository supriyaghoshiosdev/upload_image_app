//
//  AllListView.swift
//  Upload Image
//
//  Created by Supriya on 11/11/25.
//

import SwiftUI
import AVFoundation
import Photos

struct AllListView: View {
    @StateObject private var viewModel = AllListViewModel()
    @ObservedObject var tabViewModel: TabBarViewModel
    @EnvironmentObject var routeManager: RouteManager
    
    @State private var showDeletePopup = false
    @State private var imageToDelete: String? = nil
    
    let gridLayout = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.MainThemeColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("All Uploaded Images")
                            .font(.appBoldFont(size: 28))
                            .foregroundStyle(.white)
                        Text("View and manage your uploaded images")
                            .font(.appRegularFont(size: 16))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.top, 50)
                    
                    // MARK: - Content Scroll
                    ScrollView(showsIndicators: false) {
                        if viewModel.isLoading {
                            ProgressView("Loading images...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .foregroundColor(.white)
                                .padding(.top, 100)
                        } else if viewModel.allImages.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.7))
                                Text("No images uploaded yet")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.appRegularFont(size: 18))
                            }
                            .padding(.top, 80)
                        } else {
                            LazyVGrid(columns: gridLayout, spacing: 16) {
                                ForEach(viewModel.allImages, id: \.id) { item in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: item.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (geometry.size.width / 2) - 24, height: (geometry.size.width / 2) - 24)
                                            .clipped()
                                            .cornerRadius(14)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color.green.opacity(0.8), lineWidth: 1.5)
                                            )
                                        
                                        // Delete button
                                        Button(action: {
                                            imageToDelete = item.id
                                            showDeletePopup = true
                                        }) {
                                            Image(systemName: "trash.fill")
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .background(Color.red)
                                                .clipShape(Circle())
                                                .shadow(radius: 4)
                                        }
                                        .padding(8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .frame(width: geometry.size.width)
                .blur(radius: showDeletePopup ? 3 : 0)
                
                // Custom delete confirmation popup
                if showDeletePopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    VStack(spacing: 20) {
                        Text("Delete Image?")
                            .font(.appBoldFont(size: 22))
                            .foregroundColor(.white)
                        
                        Text("Are you sure you want to delete this image? This action cannot be undone.")
                            .font(.appRegularFont(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    showDeletePopup = false
                                    imageToDelete = nil
                                }
                            }) {
                                Text("Cancel")
                                    .font(.appBoldFont(size: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                if let id = imageToDelete {
                                    withAnimation {
                                        viewModel.deleteImage(withId: id)
                                    }
                                }
                                withAnimation(.easeInOut) {
                                    showDeletePopup = false
                                    imageToDelete = nil
                                }
                            }) {
                                Text("Delete")
                                    .font(.appBoldFont(size: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut, value: showDeletePopup)
                }
            }
            .onAppear {
                viewModel.fetchAllImages()
            }
        }
    }
}
