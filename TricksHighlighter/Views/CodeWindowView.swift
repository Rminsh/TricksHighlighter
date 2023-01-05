//
//  CodeWindowView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI
import CodeEditor
import Highlightr

struct WindowThumbnailPreviewer {
    var title: String
    var titleColor: Color
    var icon: String
    var iconColor: Color
}

struct CodeWindowView<Content: View>: View {
    
    @Binding var theme: CodeEditor.ThemeName
    @Binding var controller: WindowController
    
    @Binding var thumbnail: WindowThumbnailPreviewer
    
    let content: () -> Content
    
    var backgroundColor: Color {
        let highlighter = Highlightr()
        highlighter?.setTheme(to: theme.rawValue)
        #if os(iOS)
        return Color(uiColor: highlighter?.theme.themeBackgroundColor ?? .black)
        #elseif os(macOS)
        return Color(nsColor: highlighter?.theme.themeBackgroundColor ?? .black)
        #endif
    }
    
    var body: some View {
        VStack {
            HStack {
                switch controller {
                case .mac:
                    MacController()
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        theme: $theme
                    )
                    .padding(.horizontal)
                    Spacer()
                case .macStroke:
                    MacController(shape: "circle")
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        theme: $theme
                    )
                    .padding(.horizontal)
                    Spacer()
                case .macHexagon:
                    MacController(
                        shape: "hexagon.fill",
                        rotation: 29
                    )
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        theme: $theme
                    )
                    .padding(.horizontal)
                    Spacer()
                case .msWindows:
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        theme: $theme
                    )
                    Spacer()
                    MSWindowsController(foregroundColor: .gray)
                case .kde:
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        theme: $theme
                    )
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
        .shadow(color: backgroundColor.opacity(0.8), radius: 5)
        .shadow(color: .gray,radius: 0.5)
        .padding()
    }
}


struct CodeWindowView_Previews: PreviewProvider {
    static var previews: some View {
        CodeWindowView(
            theme: .constant(CodeEditor.ThemeName(rawValue: "xcode")),
            controller: .constant(.mac),
            thumbnail: .constant(WindowThumbnailPreviewer(
                title: "Hello.swift",
                titleColor: .white.opacity(0.8),
                icon: "swift",
                iconColor: .orange
            ))
        ) {
            CodeEditor(
                source: .constant("var name: String = \"Hello world\"\nlet opacity: float = 0.16\nprint(name + String(opacity))"),
                language: .swift,
                theme: CodeEditor.ThemeName(rawValue: "xcode"),
                fontSize: .constant(CGFloat(16))
            )
            .padding([.horizontal, .bottom])
            .frame(maxHeight: 150)
        }
    }
}

