//
//  ImageCache.swift
//  FeedReader
//
//  Created by Stan Gajda on 26/07/2021.
//

import UIKit
import SwiftUI

protocol ImageCacheInterface {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCacheInterface {
    private let cache = NSCache<NSURL, UIImage>()
    
    init(){
        cache.totalCostLimit = CACHE_TOTAL_COST_LIMIT
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            cache.object(forKey: key as NSURL)
        }
        set {
            guard let newValue = newValue else {
                cache.removeObject(forKey: key as NSURL)
                return
            }
            cache.setObject(newValue, forKey: key as NSURL)
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCacheInterface = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCacheInterface {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}