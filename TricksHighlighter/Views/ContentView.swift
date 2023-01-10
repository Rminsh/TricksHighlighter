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
    @State var theme: CodeEditor.ThemeName = .ocean
    
    @State var windowController: WindowController = .mac
    @State var windowTitle: String = "Hello"
    
    @State private var toggleTools: Bool = true
    
    @State private var width: CGFloat = .zero
    @State private var height: CGFloat = 400
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                content
            }
        }
        #elseif os(macOS)
        ZStack {
            /// Background
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow
            )
            .edgesIgnoringSafeArea(.all)
            
            content
        }
        #endif
    }
    
    var content: some View {
        ZStack(alignment: .bottom) {
            codeWindow
            
            #if os(iOS)
            if toggleTools {
                BottomSheetView(
                    isOpen: $toggleTools,
                    maxHeight: 300
                ) {
                    Form {
                        Section(header: Text("Code window config")) {
                            tools
                        }
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeIn, value: toggleTools)
            }
            #endif
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    saveCodeSnapshot()
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
            }
            
            #if os(macOS)
            ToolbarItemGroup(placement: .automatic) {
                tools
            }
            #elseif os(iOS)
            ToolbarItem {
                Toggle(isOn: $toggleTools) {
                    Label("Tools", systemImage: "text.and.command.macwindow")
                }
            }
            #endif
        }
    }
    
    var tools: some View {
        Group {
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
}

extension ContentView {
    var codeWindow: some View {
        GeometryReader { proxy in
            ZStack {
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
                            DragGesture()
                                .onChanged { value in
                                    DispatchQueue.main.async {
                                        width = width + value.translation.width
                                        height = height + value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    DispatchQueue.main.async {
                                        width  = max(250, min(width, proxy.size.width))
                                        height = max(250, min(height, proxy.size.height))
                                    }
                                }
                        )
                }
                .frame(
                    width: max(250, width),
                    height: max(250, height),
                    alignment: .center
                )
            }
            .frame(maxWidth: .infinity)
            .task {
                width = 450
                #if os(iOS)
                if horizontalSizeClass == .compact {
                    width = proxy.size.width
                }
                #endif
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func codeWindowPreview() -> any View {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: theme.rawValue)
        let highlightedCode = highlightr?.highlight(source, as: language.rawValue)
        
        let view = CodeWindowView(
            theme: $theme,
            controller: windowController,
            language: language,
            windowTitle: $windowTitle
        ){
            Text(AttributedString(highlightedCode ?? NSAttributedString(string: "")))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.horizontal, .vertical])
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: width, height: height, alignment: .center)
        #if os(iOS)
        .padding(.bottom, 24)
        #endif

        return view
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
