//
//  MSWindowsController.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI

struct MSWindowsController: View {
    
    @State var foregroundColor: Color
    @State var font: Font = .callout
    
    var body: some View {
        HStack(alignment: .bottom) {
            Image(systemName: "minus")
            Image(systemName: "square")
            Image(systemName: "xmark")
        }
        .foregroundColor(foregroundColor)
        .font(font)
    }
}

struct WindowsController_Previews: PreviewProvider {
    static var previews: some View {
        MSWindowsController(
            foregroundColor: .primary,
            font: .largeTitle
        )
            .padding()
    }
}
