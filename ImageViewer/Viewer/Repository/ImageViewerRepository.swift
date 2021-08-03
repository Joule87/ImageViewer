//
//  ImageViewerRepository.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

protocol ImageViewerRepositoryInterface {
    func requestImageList(completion: @escaping (Result<[ImageModel], NetworkError>) -> ())
}

class ImageViewerRepository: ImageViewerRepositoryInterface {
    private var networkManager: NetworkManagerInterface
    
    init(networkManager: NetworkManagerInterface) {
        self.networkManager = networkManager
    }
    
    func requestImageList(completion: @escaping (Result<[ImageModel], NetworkError>) -> ()) {
        guard let baseUrl = NetworkConfiguration.baseUrl,
              let url = URL(string: baseUrl) else {
            print("Invalid URL")
            completion(.failure(.error(errorDescription: "data.error".localized)))
            return
        }
        networkManager.fetchObject(for: url, completionHandler: completion)
    }
}
