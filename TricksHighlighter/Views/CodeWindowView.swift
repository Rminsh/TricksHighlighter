//
//  CodeWindowView.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI

struct WindowThumbnailPreviewer {
    var title: String
    var titleColor: Color
    var icon: String
    var iconColor: Color
}

struct CodeWindowView<Content: View>: View {
    
    @Binding var backgroundColor: Color
    @Binding var backgroundSecondColor: Color
    @Binding var backgroundThirdColor: Color
    @Binding var controller: WindowController
    
    @Binding var thumbnail: WindowThumbnailPreviewer
    
    let content: () -> Content
    
    var body: some View {
        VStack {
            HStack {
                switch controller {
                case .mac:
                    MacController()
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        backgroundColor: $backgroundSecondColor
                    )
                    .padding(.horizontal)
                    Spacer()
                case .macStroke:
                    MacController(shape: "circle")
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        backgroundColor: $backgroundSecondColor
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
                        backgroundColor: $backgroundSecondColor
                    )
                    .padding(.horizontal)
                    Spacer()
                case .msWindows:
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        backgroundColor: $backgroundSecondColor
                    )
                    Spacer()
                    MSWindowsController(foregroundColor: .gray)
                case .kde:
                    FileThumbnail(
                        thumbnail: $thumbnail,
                        backgroundColor: $backgroundSecondColor
                    )
                    Spacer()
                    KdeController(foregroundColor: .gray)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(backgroundThirdColor)
            
            content()
        }
        
        .background(backgroundColor)
        .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding()
    }
}


struct CodeWindowView_Previews: PreviewProvider {
    static var previews: some View {
        CodeWindowView(
            backgroundColor: .constant(Color(red: 29.0/255.0, green: 27.0/255.0, blue: 35.0/255.0)),
            backgroundSecondColor: .constant(Color(red: 43.0/255.0, green: 42.0/255.0, blue: 51.0/255.0)),
            backgroundThirdColor: .constant(Color.clear),
            controller: .constant(.mac),
            thumbnail: .constant(WindowThumbnailPreviewer(
                title: "Hello.swift",
                titleColor: .white.opacity(0.8),
                icon: "swift",
                iconColor: .orange
            ))
        ) {
            Text("var name: String = \"Hello world\"\nlet opacity: float = 0.16\nprint(name + String(opacity))")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }
}

