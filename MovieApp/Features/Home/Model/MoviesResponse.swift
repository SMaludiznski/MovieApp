//
//  MoviesResponse.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
}
