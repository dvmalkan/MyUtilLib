//
//  UIImage.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 6/22/25.
//

#if os (iOS)
import UIKit

public extension UIImage {
    @available(iOS 13.0, *)
    func overlayImage (image: UIImage, overlayScale: CGFloat = 1.0) -> UIImage {
        // Choose a dynamic color that automatically adapts to light/dark
        let dynamicColor = UIColor.label

        // Apply tint before compositing
        let selfTinted = self.withTintColor (dynamicColor, renderingMode: .alwaysOriginal)
        let imageTinted = image.withTintColor (dynamicColor, renderingMode: .alwaysOriginal)
        
        let size = self.size
        let overlaySize = CGSize (width: size.width * overlayScale, height: size.height * overlayScale)

        UIGraphicsBeginImageContextWithOptions (size, false, 0.0)
        
        selfTinted.draw (in: CGRect (origin: .zero, size: size))
        
        /*
        if let ctx = UIGraphicsGetCurrentContext () {
            let backgroundColor = UIColor.label
            backgroundColor.setFill ()
            
            let overlayRect = CGRect(origin: .zero, size: overlaySize)
            ctx.fill (overlayRect)
        }
         */
        
        imageTinted.draw (in: CGRect(origin: .zero, size: overlaySize), blendMode: .normal, alpha: 1.0)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext ()
        UIGraphicsEndImageContext ()
        return combinedImage!
    }
    
    // Downscale image to a target max dimension to keep listed images in gui lightweight
    func scaledDown (maxDimension: CGFloat = 80) -> UIImage {
        let maxSide = max (size.width, size.height)
        guard maxSide > maxDimension else { return self }
        
        let scaleFactor = maxDimension / maxSide
        let newSize = CGSize (width: size.width * scaleFactor, height: size.height * scaleFactor)

        let format = UIGraphicsImageRendererFormat.default ()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer (size: newSize, format: format)
        return renderer.image { _ in
            self.draw (in: CGRect(origin: .zero, size: newSize))
        }
    }
} // UIImage
#endif
