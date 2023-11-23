//
//  MovieDetails.swift
//  Assignment-15
//
//  Created by Eka Kelenjeridze on 23.11.23.
//

import Foundation

struct MovieDetails: Decodable {
    let title: String
    let releaseYear: String
    let genre: String
    let runtime: String
    let director: String
    let actors: String
    let plot: String
    let poster: String
    let imdbRating: String
    let language: String
    let country: String
    //    let imdbID: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case releaseYear = "Year"
        case genre = "Genre"
        case runtime = "Runtime"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case poster = "Poster"
        case imdbRating
        case language = "Language"
        case country = "Country"
        //        case imdbID
    }
}
