//
//  WindowController.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import Foundation

enum WindowController: CaseIterable {
    case mac
    case macStroke
    case macHexagon
    case msWindows
    case kde
    
    var name: String {
        switch self {
        case .mac:
            return "MacOS"
        case .macStroke:
            return "MacOS Stroked"
        case .macHexagon:
            return "MacOS Hexagon"
        case .msWindows:
            return "MS Windows"
        case .kde:
            return "KDE Plasma"
        }
    }
}

extension WindowController: Identifiable {
    var id: Self { self }
}
