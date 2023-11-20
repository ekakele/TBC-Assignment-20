//
//  DetailsViewModel.swift
//  Assignment-15
//
//  Created by Eka Kelenjeridze on 20.11.23.
//

import Foundation

final class DetailsViewModel {
    // MARK: - Properties
    private var movie: Movie?
    
    var ratingLabel: String {
        return "\(self.movie?.imdbID ?? "N/A")"
    }
    
    var titleLabel: String {
        return "\(self.movie?.title ?? "N/A")"
    }
    
    var posterURL: URL? {
        guard let posterString = movie?.poster, let url = URL(string: posterString) else {
            return nil
        }
        return url
    }
    
    // MARK: - Methods
    func loadImageData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }.resume()
    }
    
    // MARK: - Configure
    func configure(with movie: Movie) {
        self.movie = movie
    }
}
