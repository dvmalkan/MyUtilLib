//
//  ImageCache.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 4/14/26.
//
#if os(iOS)
import UIKit

public final class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    
    public  init() {
        // Reasonable defaults for small CarPlay icons
    }

    public func image (for key: String) -> UIImage? {
        cache.object (forKey: key as NSString)
    }

    public func set (_ image: UIImage, for key: String) {
        cache.setObject (image, forKey: key as NSString)
    }
}

#endif
