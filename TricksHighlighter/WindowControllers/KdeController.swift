//
//  KdeController.swift
//  TricksHighlighter
//
//  Created by Armin on 7/10/22.
//

import SwiftUI

struct KdeController: View {
    
    @State var foregroundColor: Color
    @State var font: Font = .callout
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.down")
            Image(systemName: "chevron.up")
            Image(systemName: "xmark")
        }
        .foregroundColor(foregroundColor)
        .font(font)
    }
}

struct KdeController_Previews: PreviewProvider {
    static var previews: some View {
        KdeController(
            foregroundColor: .gray,
            font: .largeTitle
        )
        .padding()
    }
}
