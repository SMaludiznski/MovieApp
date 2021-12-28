//
//  Company.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation

struct Company: Decodable {
    let logo: String?
    
    private enum CodingKeys: String, CodingKey {
        case logo = "logo_path"
    }
}
