//
//  GenreLabel.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 21/12/2021.
//

import UIKit

final class StandardLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textColor = .black
    }
}
