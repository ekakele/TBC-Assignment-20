//
//  MoviesResponse.swift
//  Assignment-20: Assignment-18 + MVVM
//
//  Created by Eka Kelenjeridze on 11.11.23.
//  Modified by Eka Kelenjeridze on 20.11.23.
//

import Foundation

struct MoviesResponse: Decodable {
    let result: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case result = "Search"
    }
}

struct Movie: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey  {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
