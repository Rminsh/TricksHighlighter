//
//  FileHelper.swift
//  TricksHighlighter
//
//  Created by Armin on 7/31/22.
//

#if os(macOS)
import AppKit

class FileHelper {
    
    static let shared = FileHelper()
    
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.nameFieldLabel = "Image file name:"
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    func savePNG(image: NSImage?, path: URL) {
        if let image,
           let tiffRep = image.tiffRepresentation,
           let imageRepresentation = NSBitmapImageRep(data: tiffRep),
           let pngData = imageRepresentation.representation(using: .png, properties: [:]) {
            do {
                try pngData.write(to: path)
            } catch {
                print (error)
            }
        } else {
            print("Failed to create and save the image")
        }
    }
}
#endif
