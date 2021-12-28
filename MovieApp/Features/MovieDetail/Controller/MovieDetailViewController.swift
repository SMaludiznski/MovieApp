//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let parseDataManager: ParseDataManagerProtocol = ParseDataManager()
    
    private var monvieId: String = ""
    
    private lazy var spinner: LoadingSpinner = LoadingSpinner(style: .medium)
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var movieDetailStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var backgroundMovieImage: StandardImageView = {
        let imageView = StandardImageView(image: nil)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var infrormationLabel: StandardLabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "Informations:"
        return label
    }()
    
    private lazy var durationLabel: DetailInformationLabel = DetailInformationLabel()
    private lazy var relaseLabel: DetailInformationLabel = DetailInformationLabel()
    private lazy var ratingLabel: DetailInformationLabel = DetailInformationLabel()
    private lazy var overviewLabel: OverviewLabel = OverviewLabel()
    
    private lazy var adultInfoLabel: InfoLabel = InfoLabel()
    private lazy var budgetInfoLabel: InfoLabel = InfoLabel()
    private lazy var votesLabel: InfoLabel = InfoLabel()
    
    private lazy var genresLabel: UILabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .systemYellow
        view.backgroundColor = .white
        
        view.addSubview(mainStackView)
        view.addSubview(backgroundMovieImage)
        view.addSubview(spinner)
        
        mainStackView.addArrangedSubview(movieTitleLabel)
        mainStackView.addArrangedSubview(genresLabel)
        mainStackView.addArrangedSubview(movieDetailStack)
        
        movieDetailStack.addArrangedSubview(durationLabel)
        movieDetailStack.addArrangedSubview(relaseLabel)
        movieDetailStack.addArrangedSubview(ratingLabel)
        movieDetailStack.addArrangedSubview(UIView())
        
        mainStackView.addArrangedSubview(overviewLabel)
        
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(infrormationLabel)
        infoStackView.addArrangedSubview(adultInfoLabel)
        infoStackView.addArrangedSubview(budgetInfoLabel)
        infoStackView.addArrangedSubview(votesLabel)
        
        mainStackView.addArrangedSubview(UIView())
        
        NSLayoutConstraint.activate([
            
            backgroundMovieImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundMovieImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundMovieImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundMovieImage.heightAnchor.constraint(equalToConstant: 300),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: backgroundMovieImage.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureView(with movieId: Int) {
        self.monvieId = String(movieId)
        getMovie()
    }
    
    private func getMovie() {
        guard let movie = MoviesCache.shared.getMovieFromCache(name: monvieId) else {
            downloadMovie()
            return
        }
        
        reloadView(with: movie)
    }
    
    private func downloadMovie() {
        startLoading()
        let url = "https://api.themoviedb.org/3/movie/\(monvieId)" + Constants.apiKey
        
        networkManager.downloadData(from: url) { [weak self] (completion) in
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
            let decodedData = try parseDataManager.parseData(from: data, expecting: MovieDetail.self)
            MoviesCache.shared.cacheMovie(name: monvieId, movie: decodedData)
            reloadView(with: decodedData)
        } catch {
            show(error)
        }
    }
    
    private func reloadView(with movie: MovieDetail) {
        DispatchQueue.main.async { [weak self] in
            self?.movieTitleLabel.text = movie.title
            
            if let background = movie.background {
                self?.backgroundMovieImage.configureImage(with: background)
            }
            
            if let genres = movie.genres {
                self?.genresLabel.text = self?.generateGenres(genres)
            }
            
            if let runtime = movie.runtime {
                if let time = self?.minutesToHoursAndMinutes(runtime) {
                    let duration = "\(time.hours)h \(time.leftMinutes)min"
                    self?.durationLabel.configureLabelWith(value: duration, name: "Duration")
                }
            }
            
            self?.relaseLabel.configureLabelWith(value: movie.releaseDate, name: "Release")
            
            let rating =  String(movie.rating)
            self?.ratingLabel.configureLabelWith(value: rating, name: "Rating")
            
            if let overview = movie.overview {
                self?.overviewLabel.configureView(with: overview)
            }
            
            self?.adultInfoLabel.configureLabelWith(infoTitle: "Adult", info: movie.adult.description.capitalized)
            self?.budgetInfoLabel.configureLabelWith(infoTitle: "Budget", info: "\(movie.budget) $")
            self?.votesLabel.configureLabelWith(infoTitle: "Votes", info: "\(movie.votesCount)")
            
            self?.stopLoading()
        }
    }
    
    private func generateGenres(_ genres: [Genre]) -> String {
        var names: [String] = []
        for genre in genres {
            names.append(genre.name)
        }
        return names.joined(separator: ", ")
    }
    
    private func minutesToHoursAndMinutes (_ minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    private func show(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alertVc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self?.stopLoading()
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alertVc, animated: true)
        }
    }
    
    private func startLoading() {
        spinner.startAnimating()
        mainStackView.isHidden = true
    }
    
    private func stopLoading() {
        spinner.stopAnimating()
        mainStackView.isHidden = false
    }
}
