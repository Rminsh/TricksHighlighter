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
        case .graphql:
            return "graphql"
        case .haskell:
            return "haskell"
        case .java:
            return "java"
        case .javascript:
            return "javascript"
        case .json:
            return "json"
        case .julia:
            return "julia"
        case .kotlin:
            return "kotlin"
        case .latex:
            return "latex"
        case .less:
            return "less"
        case .lua:
            return "lua"
        case .markdown:
            return "markdown"
        case .matlab:
            return "matlab"
        case .objectiveC:
            return "xcode"
        case .perl:
            return "perl"
        case .pgsql:
            return "postgresql"
        case .php, .phpTemplate:
            return "php"
        case .powershell:
            return "powershell"
        case .python, .pythonRepl:
            return "python"
        case .qml:
            return "qt"
        case .ruby:
            return "ruby"
        case .rust:
            return "rust"
        case .scala:
            return "scala"
        case .scss:
            return "sass"
        case .shell:
            return "shell"
        case .typescript:
            return "typescript"
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
             .gradle,
             .graphql,
             .haskell,
             .java,
             .javascript,
             .json,
             .julia,
             .kotlin,
             .latex,
             .less,
             .lua,
             .markdown,
             .matlab,
             .objectiveC,
             .perl,
             .pgsql,
             .php,
             .phpTemplate,
             .powershell,
             .python,
             .pythonRepl,
             .qml,
             .ruby,
             .rust,
             .scala,
             .scss,
             .shell,
             .typescript:
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
        case .graphql:
            return Color(hex: "E10098")
        case .haskell:
            return Color(hex: "5D4F85")
        case .java:
            return .red
        case .javascript:
            return Color(hex: "F7DF1E")
        case .json:
            return Color(hex: "000000")
        case .julia:
            return Color(hex: "9558B2")
        case .kotlin:
            return Color(hex: "7F52FF")
        case .latex:
            return Color(hex: "008080")
        case .less:
            return Color(hex: "1D365D")
        case .lua:
            return Color(hex: "2C2D72")
        case .markdown:
            return Color(hex: "000000")
        case .matlab:
            return .blue
        case .objectiveC:
            return Color(hex: "147EFB")
        case .perl:
            return Color(hex: "39457E")
        case .pgsql:
            return Color(hex: "4169E1")
        case .php, .phpTemplate:
            return Color(hex: "777BB4")
        case .powershell:
            return Color(hex: "5391FE")
        case .python, .pythonRepl:
            return Color(hex: "3776AB")
        case .qml:
            return Color(hex: "41CD52")
        case .ruby:
            return Color(hex: "CC342D")
        case .rust:
            return .red
        case .scala:
            return Color(hex: "DC322F")
        case .scss:
            return Color(hex: "CC6699")
        case .shell:
            return Color(hex: "FFD500")
        case .typescript:
            return Color(hex: "3178C6")
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
