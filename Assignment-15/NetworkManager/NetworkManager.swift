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
    
    // MARK: - Fetch Movies
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
    
    // MARK: - Download Image
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}

// MARK: - Fetch Movie Details
extension NetworkManager {
    func fetchMovieDetails(for imdbID: String) async throws -> MovieDetails {
        let urlString = "\(baseURL)/?i=\(imdbID)&apikey=\(APIKey)#"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetails.self, from: data)
                return movieDetail
            } catch {
                throw NSError(domain: "com.yourdomain.app", code: -2, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
            }
        } catch {
            throw NSError(domain: "com.yourdomain.app", code: -3, userInfo: [NSLocalizedDescriptionKey: "Network request failed: \(error.localizedDescription)"])
        }
    }
}
