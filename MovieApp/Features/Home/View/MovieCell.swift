//
//  MovieCell.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    private lazy var movieImage = StandardImageView(image: nil)
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.8)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.backgroundColor = .systemYellow
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(movieImage)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ratingLabel.widthAnchor.constraint(equalToConstant: 40),
            ratingLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureCell(with movie: Movie) {
        if let poster = movie.poster {
            
            if movie.rating != 0 {
                self.ratingLabel.text = String(movie.rating)
            }
            movieImage.configureImage(with: poster)
        }
    }
}
