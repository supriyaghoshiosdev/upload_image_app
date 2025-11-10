//
//  RouteManager.swift
//  Upload Image
//
//  Created by Supriya on 05/02/25.
//

import Foundation

class RouteManager: ObservableObject {
    enum Destination: Hashable {
        case Dashboard
    }
    @Published var path: [Destination] = []
}
