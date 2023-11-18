//
//  File.swift
//  Assignment-18: Assignment-15 + API
//
//  Created by Eka Kelenjeridze on 11.11.23.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://www.omdbapi.com"
    private let APIKey = "b5bf505c"
    
    func fetchMovies(searchKeyword: String, completion: @escaping([Movie]?) -> Void) {
        let urlString = "\(baseURL)/?apikey=\(APIKey)&s=\(searchKeyword.replacingOccurrences(of: " ", with: "+"))"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let searchedMovies = try JSONDecoder().decode(SearchedMovies.self, from: data)
                
                DispatchQueue.main.async {
                    completion(searchedMovies.Search)
                }
            } catch {
                completion(nil)
                print("Failed decoding data: \(error)")
            }
        }.resume()
    }
}
