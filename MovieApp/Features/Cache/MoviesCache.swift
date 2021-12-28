//
//  MoviesCache.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation

final class MoviesCache {
    
    static let shared = MoviesCache()
    private init() {}
    
    var moviesCache: NSCache<NSString, MovieDetail> = {
        let cache = NSCache<NSString, MovieDetail>()
        cache.totalCostLimit = 50 * 1024 * 1024
        cache.countLimit = 50
        return cache
    }()
    
    func cacheMovie(name: String, movie: MovieDetail) {
        moviesCache.setObject(movie, forKey: name as NSString)
    }
    
    func getMovieFromCache(name: String) -> MovieDetail? {
        return moviesCache.object(forKey: name as NSString)
    }
}
