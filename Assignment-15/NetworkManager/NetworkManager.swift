//
//  NetworkManager.swift
//  Assignment-20: Assignment-18 + MVVM
//
//  Created by Eka Kelenjeridze on 11.11.23.
//  Modified by Eka Kelenjeridze on 20.11.23.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://www.omdbapi.com"
    private let APIKey = "b5bf505c"
    
    private init() {}
    
    func fetchMovies(searchKeyword: String, completion: @escaping(Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/?apikey=\(APIKey)&s=\(searchKeyword.replacingOccurrences(of: " ", with: "+"))"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(moviesResponse.result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
