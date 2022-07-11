//
//  FileThumbnail.swift
//  TricksHighlighter
//
//  Created by Armin on 7/6/22.
//

import SwiftUI

struct FileThumbnail: View {
    
    @Binding var thumbnail: WindowThumbnailPreviewer
    @Binding var backgroundColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: thumbnail.icon)
                .foregroundColor(thumbnail.iconColor)
            
            Text(thumbnail.title)
                .foregroundColor(thumbnail.titleColor)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(backgroundColor)
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
            backgroundColor: .constant(.white.opacity(0.8))
        )
        .padding()
    }
}
