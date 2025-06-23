//
//  UIImage.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 6/22/25.
//

#if os (iOS)
import UIKit

public extension UIImage {
    func overlayImage (image: UIImage, overlayScale: CGFloat = 1.0) -> UIImage {
        let size = self.size
        let overlaySize = CGSize (width: size.width * overlayScale, height: size.height * overlayScale)
        UIGraphicsBeginImageContextWithOptions (size, false, 0.0)
        
        self.draw (in: CGRect (origin: .zero, size: size))
        image.draw (in: CGRect(origin: .zero, size: overlaySize))
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext ()
        UIGraphicsEndImageContext ()
        return combinedImage!
    }
}
#endif
