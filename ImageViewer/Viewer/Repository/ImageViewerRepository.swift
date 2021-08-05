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
        let imageListPath = "photos"
        let request = HTTPRequest(method: .get, path: imageListPath)
        networkManager.fetchObject(for: request, completionHandler: completion)
    }
}
