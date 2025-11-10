//
//  TabBarView.swift
//  Upload Image
//
//  Created by Supriya on 12/02/25.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var viewModel: TabBarViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.MainThemeColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    switch viewModel.selectedTab {
                    case 0:
                        DashboardView(tabViewModel: viewModel)
                    case 1:
                        AllListView(tabViewModel: viewModel)
                    default:
                        Color.red
                    }
                }
                
                VStack {
                    Spacer()
                    
                    if !viewModel.hideTabBar {
                        CustomTabBar(viewModel: viewModel, height: geometry.size.height / 9.1)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

#Preview {
    TabBarView()
}
