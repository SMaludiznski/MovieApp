//
//  OverviewLabel.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 22/12/2021.
//

import UIKit

final class OverviewLabel: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var overviewLabel: StandardLabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "Overview"
        return label
    }()
    
    private lazy var textLabel: StandardLabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .justified
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
        self.addSubview(stackView)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(textLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            overviewLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureView(with text: String) {
        self.textLabel.text = text
    }
}
