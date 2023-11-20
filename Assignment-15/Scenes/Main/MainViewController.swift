//
//  MainViewController.swift
//  Assignment-20: Assignment-18 + MVVM
//
//  Created by Eka Kelenjeridze on 03.11.23.
//  Modified by Eka Kelenjeridze on 11.11.23.
//  Modified by Eka Kelenjeridze on 20.11.23.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.502, blue: 0.212, alpha: 1)
        button.layer.cornerRadius = 8
        button.frame = CGRect(x: 0, y: 0, width: 77, height: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = CGColor(red: 1, green: 0.502, blue: 0.212, alpha: 0.25)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 16
        button.clipsToBounds = false
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recommended Movies"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let searchController = UISearchController()
    private var movies = [Movie]()
    private var viewModel = MainViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupSubviews()
        setupNavigationBar()
        setupSearchBar()
        setupLabelConstraints()
        setupCollectionView()
        setupCollectionViewConstraints()
        
        setupViewModelDelegate()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: logoImageView
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: profileButton
        )
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        setupCollectionView()
    }
    
    private func setupLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 342),
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(moviesCollectionView)
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        moviesCollectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55
                                                     ),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
}

// MARK: - CollectionView DataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: movies[indexPath.row])
        return cell
    }
}
// MARK: - CollectionView Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let movieDetailsPage = MovieDetailViewController()
        //        movieDetailsPage.configure(with: movies[indexPath.row])
        //        navigationController?.pushViewController(movieDetailsPage, animated: true)
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int((view.frame.width / 2) - 24)
        let height = 278
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 32, right: 16)
    }
}

// MARK: - SearchController Methods
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        //        fetchMovies(keyword: text)
    }
}

// MARK: - HomeViewModelDelegate
extension MainViewController: HomeViewModelDelegate {
    func moviesFetched(_ movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
}
