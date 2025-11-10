//
//  Font.swift
//  Upload Image
//
//  Created by Supriya on 10/11/25.
//

import Foundation
import SwiftUI


extension Font {
    
    static func appBoldFont(size: CGFloat) -> Font {
        return Font.custom("Inter-Bold", size: size)
    }
    
    static func appMediumFont(size: CGFloat) -> Font {
        return Font.custom("Inter-Medium", size: size)
    }
    
    static func appSemiboldFont(size: CGFloat) -> Font {
        return Font.custom("Inter-SemiBold", size: size)
    }
    
    static func appRegularFont(size: CGFloat) -> Font {
        return Font.custom("Inter-Regular", size: size)
    }
}

