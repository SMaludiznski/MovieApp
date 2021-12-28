//
//  ParseDataManager.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import Foundation

protocol ParseDataManagerProtocol {
    func parseData<T: Decodable>(from data: Data, expecting: T.Type) throws -> T
}

final class ParseDataManager: ParseDataManagerProtocol {
    
    func parseData<T: Decodable>(from data: Data, expecting: T.Type) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkingErrors.decodingError
        }
    }
}
