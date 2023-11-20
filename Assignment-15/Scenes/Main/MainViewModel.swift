//
//  MainViewModel.swift
//  Assignment-15
//
//  Created by Eka Kelenjeridze on 20.11.23.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func moviesFetched(_ movies: [Movie])
    func showError(_ error: Error)
}

final class MainViewModel {
    private var movies: [Movie]?
    weak var delegate: HomeViewModelDelegate?
    
    func viewDidLoad() {
        fetchMovies(keyword: "Christmas")
    }
    
    private func fetchMovies(keyword: String) {
        NetworkManager.shared.fetchMovies(searchKeyword: keyword) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.delegate?.moviesFetched(movies)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}