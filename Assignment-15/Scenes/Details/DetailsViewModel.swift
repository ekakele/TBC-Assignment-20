//
//  DetailsViewModel.swift
//  Assignment-15
//
//  Created by Eka Kelenjeridze on 20.11.23.
//

import UIKit


protocol DetailsViewModelDelegate: AnyObject {
    func movieDetailsFetched(_ movie: MovieDetails)
    func showError(_ error: Error)
    func movieDetailsImageFetched(_ image: UIImage)
}

protocol DetailsViewModel {
    var delegate: DetailsViewModelDelegate? { get set }
    func viewDidLoad()
}

final class DefaultDetailsViewModel: DetailsViewModel {
    // MARK: - Properties
    private var imdbID: String
    weak var delegate: DetailsViewModelDelegate?
    
    // MARK: - Init
    init(imdbID: String) {
        self.imdbID = imdbID
    }
    
    // MARK: - ViewLifeCycle
    func viewDidLoad() {
        fetchMovieDetails()
    }
    
    // MARK: - Private Methods
    private func fetchMovieDetails() {
        Task {
            do {
                let movieDetails = try await NetworkManager.shared.fetchMovieDetails(for: imdbID)
                delegate?.movieDetailsFetched(movieDetails)
                downloadImage(from: movieDetails.poster)
            } catch let error {
                delegate?.showError(error)
            }
        }
    }
    
    private func downloadImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            self?.delegate?.movieDetailsImageFetched(image ?? UIImage())
        }
    }
}
