//
//  SplashView.swift
//  Upload Image
//
//  Created by Supriya on 10/11/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    @StateObject var routeManager = RouteManager()
    var body: some View {
        NavigationStack(path: $routeManager.path) {
            GeometryReader { geometry in
                ZStack {
                    Color.MainThemeColor
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("MainLogo")
                        
                        
                    }
                }
            }
            .navigationDestination(for: RouteManager.Destination.self) { destination in
                switch destination {
                case .Dashboard:
                    TabBarView()
                        .navigationBarBackButtonHidden()
                }
            }
            .onDisappear {
                viewModel.shouldNavigateToDashboard = false
            }
            .onChange(of: viewModel.shouldNavigateToDashboard) { _ ,newValue in
                if newValue {
                    routeManager.path.append(.Dashboard)
                }
            }
        }
        .environmentObject(routeManager)
    }
}
