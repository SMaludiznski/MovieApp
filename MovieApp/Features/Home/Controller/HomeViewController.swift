//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import UIKit

final class HomeViewController: UIViewController, UISearchBarDelegate {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let parseDataManager: ParseDataManagerProtocol = ParseDataManager()
    
    private var movies: [Movie] = []
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var error: SearchError = SearchError()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadMovies()
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        setupCollectionView()
        searchBar.delegate = self
        
        title = "Movies"
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    private func downloadMovies() {
        networkManager.downloadData(from: Constants.moviesBaseURL) { [weak self] (completion) in
            switch completion {
            case .success(let data):
                self?.parseData(from: data)
            case .failure(let error):
                self?.show(error)
            }
        }
    }
    
    private func parseData(from data: Data) {
        do {
            let decodedData = try parseDataManager.parseData(from: data, expecting: MoviesResponse.self)
            reloadView(with: decodedData.results)
        } catch {
            show(error)
        }
    }
    
    private func reloadView(with movies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.movies = movies
            self?.collectionView.reloadData()
        }
    }
    
    private func show(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alertVc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self?.downloadMovies()
            }))
            self?.present(alertVc, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            let query = transformStringIntoQuery(text)
            generateURL(from: query)
            downloadMovies()
        }
    }
    
    private func transformStringIntoQuery(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "-")
    }
    
    private func generateURL(from query: String) {
        let url = "https://api.themoviedb.org/3/search/movie" + Constants.apiKey + "&query=\(query)"
        Constants.moviesBaseURL = url
    }
}

//MARK: - Setup collectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            fatalError()
        }
        
        let movie = movies[indexPath.row]
        cell.configureCell(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.configureView(with: movies[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width/2,
                      height: view.bounds.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
