//
//  ImageView.swift
//  MovieApp
//
//  Created by Sebastian Maludziński on 20/12/2021.
//

import UIKit

final class StandardImageView: UIImageView {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private var imageName: String = ""
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(with url: String) {
        self.imageName = url
        getImage()
    }
    
    private func getImage() {
        guard let image = ImagesCache.shared.getImageFromCache(name: imageName) else {
            downladImage()
            return
        }
        
        self.image = image
    }
    
    private func downladImage() {
        let url = Constants.imageBaseURL + imageName + Constants.apiKey
        
        networkManager.downloadData(from: url) { [weak self] (completion) in
            switch completion {
            case .success(let data):
                self?.generateImage(from: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func generateImage(from data: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let image = UIImage(data: data) else {
                self.image = UIImage(systemName: "xmark.octagon")
                return
            }
            
            self.image = image
            ImagesCache.shared.cacheImage(name: self.imageName, image: image)
        }
    }
}
