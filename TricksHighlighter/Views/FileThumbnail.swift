//
//  FileThumbnail.swift
//  TricksHighlighter
//
//  Created by Armin on 7/6/22.
//

import SwiftUI
import CodeEditor
import Highlightr

struct FileThumbnail: View {
    
    @Binding var thumbnail: WindowThumbnailPreviewer
    @Binding var theme: CodeEditor.ThemeName
    
    var backgroundColor: RPColor {
        let highlighter = Highlightr()
        highlighter?.setTheme(to: theme.rawValue)
        return highlighter?.theme.themeBackgroundColor ?? .black
    }
    
    
    var body: some View {
        HStack {
            Image(systemName: thumbnail.icon)
                .foregroundColor(thumbnail.iconColor)
            
            Text(thumbnail.title)
                .foregroundColor(backgroundColor.isLight() ? .black : .white)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        #if os(iOS)
        .background(Color(uiColor: backgroundColor).contrast(0.8))
        #elseif os(macOS)
        .background(Color(nsColor: backgroundColor).contrast(0.8))
        #endif
        .mask(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

struct FileThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        FileThumbnail(
            thumbnail: .constant(WindowThumbnailPreviewer(
                title: "Hello.swift",
                titleColor: .black.opacity(0.8),
                icon: "swift",
                iconColor: .orange
            )),
            theme: .constant(CodeEditor.ThemeName(rawValue: "ir-black"))
        )
        .padding()
    }
}

extension RPColor {
    func isLight() -> Bool {
        guard let components = cgColor.components, components.count > 2 else {return true}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}
