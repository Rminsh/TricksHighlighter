//
//  MacController.swift
//  TricksHighlighter
//
//  Created by Armin on 7/5/22.
//

import SwiftUI

struct MacController: View {
    
    @State var shape: String = "circle.fill"
    @State var font: Font = .callout
    @State var rotation: Double = 0
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: shape)
                .foregroundColor(.red)
                .rotationEffect(Angle(degrees: rotation))
            
            Image(systemName: shape)
                .foregroundColor(.yellow)
                .rotationEffect(Angle(degrees: rotation))
            
            Image(systemName: shape)
                .foregroundColor(.green)
                .rotationEffect(Angle(degrees: rotation))
        }
        .font(font)
        .shadow(radius: 0.5)
    }
}

struct MacController_Previews: PreviewProvider {
    static var previews: some View {
        MacController(
            shape: "hexagon.fill",
            font: .largeTitle,
            rotation: 29
        )
        .padding()
    }
}
