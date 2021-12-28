//
//  Movie.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let poster: String?
    let title: String
    let rating: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case poster = "poster_path"
        case title = "original_title"
        case rating = "vote_average"
    }
}

extension Movie {
    static let new = Movie(id: 0,
                           poster: "",
                           title: "",
                           rating: 0)
}
