//
//  FileThumbnail.swift
//  TricksHighlighter
//
//  Created by Armin on 1/10/23.
//

import SwiftUI
import Highlighter

enum IconType {
    case system
    case custom
}

struct FileThumbnail {
    let language: CodeEditor.Language
    
    init(_ language: CodeEditor.Language) {
        self.language = language
    }
    
    var icon: String {
        switch self.language {
        case .asciidoc:
            return "asciidoc"
        case .bash:
            return "bash"
        case .c:
            return "c.lang"
        case .cmake:
            return "cmake"
        case .cpp:
            return "cpp.lang"
        case .csharp:
            return "csharp"
        case .css:
            return "css3"
        case .d:
            return "d.lang"
        case .dart:
            return "dart"
        case .delphi:
            return "delphi"
        case .dockerfile:
            return "docker"
        case .elixir:
            return "elixir"
        case .elm:
            return "elm"
        case .fortran:
            return "fortran"
        case .go:
            return "go"
        case .gradle:
            return "gradle"
        case .swift:
            return "swift"
        default:
            return "chevron.left.forwardslash.chevron.right"
        }
    }
    
    var type: IconType {
        switch self.language {
        case .asciidoc,
             .bash,
             .c,
             .cmake,
             .cpp,
             .csharp,
             .css,
             .d,
             .dart,
             .delphi,
             .dockerfile,
             .elixir,
             .elm,
             .fortran,
             .go,
             .gradle:
            return .custom
        default:
            return .system
        }
    }
    
    var color: Color {
        switch self.language {
        case .asciidoc:
            return .cyan
        case .bash:
            return Color(hex: "4EAA25")
        case .c:
            return .orange
        case .cmake, .cpp:
            return Color(hex: "00599C")
        case .csharp:
            return Color(hex: "239120")
        case .css:
            return Color(hex: "1572B6")
        case .d:
            return Color(hex: "B03931")
        case .dart:
            return Color(hex: "0175C2")
        case .delphi:
            return Color(hex: "EE1F35")
        case .dockerfile:
            return Color(hex: "2496ED")
        case .elixir:
            return Color(hex: "4B275F")
        case .elm:
            return Color(hex: "1293D8")
        case .fortran:
            return Color(hex: "734F96")
        case .go:
            return Color(hex: "00ADD8")
        case .gradle:
            return Color(hex: "02303A")
        case .swift:
            return .orange
        default:
            return .gray
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
