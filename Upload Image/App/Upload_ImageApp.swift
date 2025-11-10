//
//  Upload_ImageApp.swift
//  Upload Image
//
//  Created by Supriya on 10/11/25.
//

import SwiftUI
import Firebase

@main
struct Upload_ImageApp: App {
    @StateObject private var dashboardViewModel = DashboardViewModel()
    @StateObject var tabViewModel = TabBarViewModel()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(tabViewModel)
                .environmentObject(dashboardViewModel)
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
