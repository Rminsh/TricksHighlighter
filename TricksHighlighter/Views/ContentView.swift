//
//  ContentView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var code: String = "//Lets begin here"
    @State var windowController: WindowController = .mac
    @State var thumbnail: WindowThumbnailPreviewer = WindowThumbnailPreviewer(
        title: "Hello.swift",
        titleColor: .white.opacity(0.8),
        icon: "swift",
        iconColor: .orange
    )
    
    @State var backgroundColor: Color = Color(red: 29.0/255.0, green: 27.0/255.0, blue: 35.0/255.0)
    @State var secondBackgroundColor: Color = Color(red: 43.0/255.0, green: 42.0/255.0, blue: 51.0/255.0)
    @State var accentColor: Color = .clear
    
    init() {
        #if os(iOS)
        UITextView.appearance().backgroundColor = .clear
        #endif
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeWindowView(
                    backgroundColor: $backgroundColor,
                    backgroundSecondColor: $secondBackgroundColor,
                    backgroundThirdColor: $accentColor,
                    controller: $windowController,
                    thumbnail: $thumbnail
                ){
                    TextEditor(text: $code)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .padding([.horizontal, .bottom])
                }
                .frame(maxHeight: 350)
                
                Form {
                    Section("Window Controller") {
                        Picker("Window Controls", selection: $windowController) {
                            ForEach(WindowController.allCases) { item in
                                Text(item.name)
                                    .tag(item)
                            }
                        }
                        
                        TextField("Preview name", text: $thumbnail.title)
                    }
                    
                    Section("Theme") {
                        ColorPicker("Background Color", selection: $backgroundColor)
                        ColorPicker("Second Background Color", selection: $secondBackgroundColor)
                        ColorPicker("Accent Color", selection: $accentColor)
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

#if os(macOS)
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
#endif
