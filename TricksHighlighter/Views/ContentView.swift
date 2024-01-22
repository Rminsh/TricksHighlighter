//
//  ContentView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI
import Highlighter

struct ContentView: View {
    
    @State var source: String = "//Lets begin here"
    @State var language: CodeEditor.Language = .swift
    @State var theme: CodeEditor.ThemeName = .atomOneDark
    
    @State var windowController: WindowController = .mac
    @State var windowTitle: String = "Hello"
    
    @State private var rawWidth: CGFloat = 450
    @State private var rawHeight: CGFloat = 400
    
    private var width: CGFloat {
        #if os(iOS) && !os(visionOS)
        min(max(250, rawWidth), maxWidth)
        #elseif os(macOS) || os(visionOS)
        max(250, rawWidth)
        #endif
    }
    
    private var height: CGFloat {
        #if os(iOS) && !os(visionOS)
        min(max(250, rawHeight), maxHeight)
        #elseif os(macOS) || os(visionOS)
        max(250, rawHeight)
        #endif
    }
    
    #if os(iOS) && !os(visionOS)
    let maxWidth: CGFloat = UIScreen.main.bounds.size.width
    let maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    private var resizeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translation = value.translation
                rawWidth = rawWidth + translation.width
                rawHeight = rawHeight + translation.height
            }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                /// Background
                background
                
                VStack {
                    ZStack {
                        codeWindow
                    }
                    #if os(iOS)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    #elseif os(macOS)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    #endif
                    .task {
                        #if os(iOS) && !os(visionOS)
                        if horizontalSizeClass == .compact {
                            rawWidth = maxWidth
                        }
                        #endif
                    }
                    
                    /// Customization tools
                    tools
                        #if !os(visionOS)
                        .scrollDismissesKeyboard(.immediately)
                        #endif
                        .scrollContentBackground(.hidden)
                        .formStyle(.grouped)
                        .frame(height: 225)
                }
            }
            .toolbar {
                /// Save button
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        Task {
                            saveCodeSnapshot()
                        }
                    }) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
            }
        }
    }
}

extension ContentView {
    var codeWindow: some View {
        CodeWindowView(
            theme: $theme,
            controller: windowController,
            language: language,
            windowTitle: $windowTitle
        ){
            CodeEditor(
                source: $source,
                language: language,
                theme: theme,
                fontSize: .constant(CGFloat(14.1))
            )
            .padding(.bottom)
        }
        .overlay(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 10)
                .trim(from: 0.05, to: 0.20)
                .stroke(lineWidth: 4)
                .foregroundColor(.gray)
                .shadow(radius: 5)
                .frame(width: 50, height: 50)
                .padding(.all, 13)
                .background(Color.white.opacity(0.001))
                .gesture(
                    resizeGesture
                )
        }
        .frame(
            minWidth: 250,
            maxWidth: width,
            minHeight: 250,
            maxHeight: height,
            alignment: .center
        )
    }
    
    var tools: some View {
        Form {
            /// Language
            Picker(selection: $language) {
                ForEach(CodeEditor.availableLanguages) { language in
                    Text("\(language.rawValue.capitalized)")
                        .tag(language)
                }
            } label: {
                Label("Language", systemImage: "command")
            }
            
            /// Theme
            Picker(selection: $theme) {
                ForEach(CodeEditor.availableThemes, id: \.self) { theme in
                    Text("\(theme.rawValue)")
                        .tag(theme)
                }
            } label: {
                Label("Theme", systemImage: "paintbrush.fill")
            }
            
            /// Window Controller
            Picker(selection: $windowController) {
                ForEach(WindowController.allCases) { item in
                    Text(item.name)
                        .tag(item)
                }
            } label: {
                Label("Window Style", systemImage: "macwindow")
            }
        }
    }
    
    var background: some View {
        Group {
            #if os(macOS)
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow
            )
            .edgesIgnoringSafeArea(.all)
            #elseif os(iOS)
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            #endif
        }
    }
    
    func createCodeWindowPreview() -> some View {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: theme.rawValue)
        let highlightedCode = highlightr?.highlight(source, as: language.rawValue)
        
        let view = CodeWindowView(
            theme: $theme,
            controller: windowController,
            language: language,
            isStatic: true,
            windowTitle: $windowTitle
        ){
            Text(AttributedString(highlightedCode ?? NSAttributedString(string: "")))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.horizontal, .vertical])
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: width, height: height, alignment: .center)

        return view
    }
}
    
extension ContentView {
    @MainActor
    func saveCodeSnapshot() {
        let view = createCodeWindowPreview()
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        #if os(iOS)
        if let snapshot = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(snapshot, nil, nil, nil)
        }
        #elseif os(macOS)
        if let url = FileHelper.shared.showSavePanel(),
           let snapshot = renderer.nsImage{
            FileHelper.shared.savePNG(
                image: snapshot,
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
