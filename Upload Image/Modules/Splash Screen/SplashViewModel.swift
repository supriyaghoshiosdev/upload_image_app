//
//  SplashViewModel.swift
//  Upload Image
//
//  Created by Supriya on 10/11/25.
//

import Foundation

final class SplashViewModel: ObservableObject {
    @Published var shouldNavigateToDashboard = false
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            DispatchQueue.main.async {
                self?.shouldNavigateToDashboard.toggle()
            }
        }
    }
}
