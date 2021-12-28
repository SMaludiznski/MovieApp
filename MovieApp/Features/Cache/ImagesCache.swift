//
//  ImageCache.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation
import UIKit

final class ImagesCache {
    
    static let shared = ImagesCache()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 30
        cache.totalCostLimit = 1024 * 1024 * 50
        return cache
    }()
    
    
    func cacheImage(name: String, image: UIImage) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    func getImageFromCache(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}
