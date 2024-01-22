//
//  CodeWindowView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI
import Highlighter

struct CodeWindowView<Content: View>: View {
    
    @Binding var theme: CodeEditor.ThemeName
    
    var controller: WindowController
    var language: CodeEditor.Language
    var isStatic: Bool = false
    @Binding var windowTitle: String
    
    let content: () -> Content
    
    var backgroundColor: Color {
        let highlighter = Highlightr()
        highlighter?.setTheme(to: theme.rawValue)
        #if os(macOS)
        return Color(nsColor: highlighter?.theme.themeBackgroundColor ?? .black)
        #else
        return Color(uiColor: highlighter?.theme.themeBackgroundColor ?? .black)
        #endif
    }
    
    var body: some View {
        VStack {
            HStack {
                switch controller {
                case .mac:
                    MacController()
                    fileThumbnail
                    .padding(.horizontal)
                    Spacer()
                case .macStroke:
                    MacController(shape: "circle")
                    fileThumbnail
                    .padding(.horizontal)
                    Spacer()
                case .macHexagon:
                    MacController(
                        shape: "hexagon.fill",
                        rotation: 29
                    )
                    fileThumbnail
                    .padding(.horizontal)
                    Spacer()
                case .msWindows:
                    fileThumbnail
                    Spacer()
                    MSWindowsController(foregroundColor: .gray)
                case .kde:
                    fileThumbnail
                    Spacer()
                    KdeController(foregroundColor: .gray)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 5)
            .dynamicTypeSize(.small)
            
            content()
        }
        .background(backgroundColor)
        .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.all, 8)
    }
    
    var fileThumbnail: some View {
        FileThumbnailView(
            title: $windowTitle,
            language: language,
            theme: theme,
            isStatic: isStatic
        )
    }
}


struct CodeWindowView_Previews: PreviewProvider {
    static var previews: some View {
        CodeWindowView(
            theme: .constant(CodeEditor.ThemeName(rawValue: "materia")),
            controller: .mac,
            language: .swift,
            windowTitle: .constant("Hello .swift")
        ) {
            CodeEditor(
                source: .constant("var name: String = \"Hello world\"\nlet opacity: float = 0.16\nprint(name + String(opacity))"),
                language: .swift,
                theme: CodeEditor.ThemeName(rawValue: "materia"),
                fontSize: .constant(CGFloat(16))
            )
            .padding([.horizontal, .bottom])
            .frame(maxHeight: 150)
        }
    }
}

