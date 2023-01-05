//
//  ContentView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI
import Highlightr
import CodeEditor

struct ContentView: View {
    
    @State var source: String = "//Lets begin here"
    @State var language: CodeEditor.Language = .swift
    @State var theme: CodeEditor.ThemeName = .ocean
    
    @State var windowController: WindowController = .mac
    @State var thumbnail: WindowThumbnailPreviewer = WindowThumbnailPreviewer(
        title: "Hello.swift",
        titleColor: .white.opacity(0.8),
        icon: "swift",
        iconColor: .orange
    )
    
    var body: some View {
        NavigationStack {
            content
        }
    }
    
    var content: some View {
        VStack {
            codeWindow
            
            Form {
                Section("Code") {
                    Picker("Language", selection: $language) {
                        ForEach(CodeEditor.availableLanguages) { language in
                            Text("\(language.rawValue.capitalized)")
                                .tag(language)
                        }
                    }
                    Picker("Theme", selection: $theme) {
                        ForEach(CodeEditor.availableThemes, id: \.self) { theme in
                            Text("\(theme.rawValue)")
                                .tag(theme)
                        }
                    }
                }
                Section("Window Controller") {
                    Picker("Window Controls", selection: $windowController) {
                        ForEach(WindowController.allCases) { item in
                            Text(item.name)
                                .tag(item)
                        }
                    }
                    
                    TextField("Preview name", text: $thumbnail.title)
                }
            }
            .formStyle(.grouped)
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    saveCodeSnapshot()
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
            }
        }
    }
}

extension ContentView {
    var codeWindow: some View {
        CodeWindowView(
            theme: $theme,
            controller: $windowController,
            thumbnail: $thumbnail
        ){
            CodeEditor(
                source: $source,
                language: language,
                theme: theme,
                fontSize: .constant(CGFloat(14.1))
            )
            .padding(.bottom)
        }
    }
    
    func codeWindowPreview() -> any View {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: theme.rawValue)
        let highlightedCode = highlightr?.highlight(source, as: language.rawValue)
        
        return CodeWindowView(
            theme: $theme,
            controller: $windowController,
            thumbnail: $thumbnail
        ){
            Text(AttributedString(highlightedCode ?? NSAttributedString(string: "")))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .bottom])
        }
        .frame(width: 512, height: 512)
    }
}
    
extension ContentView {
    func saveCodeSnapshot() {
        #if os(iOS)
        let image = codeWindowPreview().snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        #elseif os(macOS)
        if let url = FileHelper.shared.showSavePanel() {
            FileHelper.shared.savePNG(
                image: codeWindowPreview().snapshot(),
                path: url
            )
        }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
