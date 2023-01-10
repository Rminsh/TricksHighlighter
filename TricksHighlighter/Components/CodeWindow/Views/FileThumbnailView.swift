//
//  FileThumbnailView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/6/22.
//

import SwiftUI
import Highlighter

struct FileThumbnailView: View {
    
    @Binding var title: String
    var language: CodeEditor.Language
    var theme: CodeEditor.ThemeName
    
    var backgroundColor: RPColor {
        let highlighter = Highlightr()
        highlighter?.setTheme(to: theme.rawValue)
        return highlighter?.theme.themeBackgroundColor ?? .black
    }
    
    var iconThumbnail: FileThumbnail {
        FileThumbnail(language)
    }
    
    var body: some View {
        HStack {
            switch iconThumbnail.type {
            case .system:
                Image(systemName: iconThumbnail.icon)
                    .font(.body)
                    .foregroundColor(iconThumbnail.color)
            case .custom:
                Image(iconThumbnail.icon)
                    .font(.body)
                    .foregroundColor(iconThumbnail.color)
            }
            
            TextField("", text: $title)
                .foregroundColor(backgroundColor.isLight() ? .black : .white)
                .fixedSize()
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
                .border(.clear)
        }
        .font(.caption)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(backgroundColor.isLight() ? .black.opacity(0.075) : .white.opacity(0.15))
        .mask(RoundedRectangle(cornerRadius: 5, style: .continuous))
        .dynamicTypeSize(.xSmall ... .small)
    }
}

struct FileThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        FileThumbnailView(
            title: .constant("Hello.swift"),
            language: .swift,
            theme: CodeEditor.ThemeName(rawValue: "ir-black")
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
