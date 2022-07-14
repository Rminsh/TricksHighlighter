//
//  ContentView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI
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
            VStack {
                CodeWindowView(
                    theme: $theme,
                    controller: $windowController,
                    thumbnail: $thumbnail
                ){
                    CodeEditor(
                        source: $source,
                        language: language,
                        theme: theme,
                        fontSize: .constant(CGFloat(16))
                    )
                    .padding([.horizontal, .bottom])
                }
                .frame(maxHeight: 350)
                
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}