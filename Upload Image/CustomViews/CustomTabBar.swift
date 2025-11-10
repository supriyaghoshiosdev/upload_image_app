//
//  CustomTabBar.swift
//  Upload Image
//
//  Created by Supriya on 12/02/25.
//

import Foundation
import SwiftUI

struct CustomTabBar: View {
    @ObservedObject var viewModel: TabBarViewModel
    let height: CGFloat
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.99))
                .frame(height: height)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: -5)
            
            HStack(alignment: .center) {
                ForEach(0..<viewModel.tabItems.count, id: \.self) { index in
                    Button(action: {
                        if viewModel.selectedTab != index {
                            viewModel.selectedTab = index
                        }
                    }) {
                        VStack(spacing: 5) {
                            Image(viewModel.selectedTab == index ? viewModel.tabItems[index].selectedImage : viewModel.tabItems[index].unselectedImage)
                                .frame(maxWidth: .infinity)
                            
                            Text(viewModel.tabItems[index].title)
                                .font(.appSemiboldFont(size: 12))
                                .foregroundColor(viewModel.selectedTab == index ? Color.ButtonColor : Color.white)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
