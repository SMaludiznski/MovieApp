//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation

final class MovieDetail: Decodable {
    
    let adult: Bool
    let background: String?
    let budget: Int
    let genres: [Genre]?
    let homepage: String?
    let title: String
    let overview: String?
    let companies: [Company]
    let releaseDate: String
    let runtime: Int?
    let rating: Double
    let votesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case adult
        case background = "backdrop_path"
        case budget
        case genres
        case homepage
        case title = "original_title"
        case overview
        case companies = "production_companies"
        case releaseDate = "release_date"
        case runtime
        case rating = "vote_average"
        case votesCount = "vote_count"
    }
}
