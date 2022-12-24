//
//  SnapshotCreator.swift
//  TricksHighlighter
//
//  Created by Armin on 7/31/22.
//

import SwiftUI

extension View {
    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        return view.bitmapImage()
    }
}

class NoInsetHostingView<V>: NSHostingView<V> where V: View {
    override var safeAreaInsets: NSEdgeInsets {
        return .init()
    }
}

public extension NSView {
    func bitmapImage() -> NSImage? {
        self.viewWillDraw()
        
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }
        self.cacheDisplay(in: bounds, to: rep)
        
        guard let cgImage = rep.cgImage else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: bounds.size)
    }
}
