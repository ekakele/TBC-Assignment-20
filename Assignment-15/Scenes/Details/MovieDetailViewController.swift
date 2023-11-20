//
//  MovieDetailViewController.swift
//  Assignment-15
//
//  Created by Eka Kelenjeridze on 03.11.23.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    // MARK: - UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let ratingSourceLabel: UILabel = {
        let label = UILabel()
        label.text = "IMDB ID"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let bottomSectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor(red: 31/255.0, green: 41/255.0, blue: 61/255.0, alpha: 1)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    
    private let selectSessionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select session", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()
    
    private var movie: Movie?
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupNavigationBar()
        setupMainStackView()
        setupMovieRatingInformation()
        setupDescriptionLabel()
        setupBottomSectionStackView()
        setupSelectSessionButton()
        setupMovieWithInformation()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
    }
    
    private func setupNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupMovieRatingInformation() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(red: 99/255.0, green: 115/255.0, blue: 148/255.0, alpha: 0.1)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(ratingSourceLabel)
        
        mainStackView.addArrangedSubview(stackView)
    }
    
    private func setupDescriptionLabel() {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 12, right: 16)
        
        stackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(stackView)
    }
    
    private func createInfoStackView(_ title: String, detail: String) {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .light)
        titleLabel.textColor = UIColor(red: 0.389, green: 0.452, blue: 0.58, alpha: 1)
        titleLabel.widthAnchor.constraint(equalToConstant: 86).isActive = true
        
        let detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.textColor = .white
        detailLabel.numberOfLines = 0
        detailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        
        mainStackView.addArrangedSubview(stackView)
    }
    
    private func setupBottomSectionStackView() {
        view.addSubview(bottomSectionStackView)
        
        NSLayoutConstraint.activate([
            bottomSectionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSectionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSectionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSectionStackView.heightAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func setupSelectSessionButton() {
        bottomSectionStackView.addArrangedSubview(selectSessionButton)
    }
    
    private func setupMovieWithInformation() {
        guard let movie else { return }
        navigationItem.title = movie.title
        ratingLabel.text = movie.imdbID
        if let url = URL(string: movie.poster!) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.movieImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    // MARK: - Configure
    func configure(with movie: Movie) {
        self.movie = movie
    }
}




