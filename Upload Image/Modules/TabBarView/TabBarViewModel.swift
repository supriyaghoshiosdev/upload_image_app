//
//  TabBarViewModel.swift
//  Upload Image
//
//  Created by Supriya on 12/02/25.
//

import Foundation

struct TabItem {
    let selectedImage: String
    let unselectedImage: String
    let title: String
}

class TabBarViewModel: ObservableObject {
    
    @Published var selectedTab: Int = 0
    
    @Published var hideTabBar: Bool = false
    
    @Published var tabItems: [TabItem] = [
        TabItem(selectedImage: "home_logo_selected", unselectedImage: "home_logo", title: "Home"),
        
        TabItem(selectedImage: "list_logo_selected", unselectedImage: "list_logo", title: "All Images")
    ]
}
