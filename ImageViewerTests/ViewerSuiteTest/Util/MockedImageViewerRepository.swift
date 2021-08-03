//
//  MockedImageViewerRepository.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 1/8/21.
//

import Foundation
@testable import ImageViewer

class MockedImageViewerRepository: ImageViewerRepositoryInterface {
    var flow: ImageViewerRepositoryFlow
    
    init(flow: ImageViewerRepositoryFlow = .requestImageListSucceeded) {
        self.flow = flow
    }
    
    func requestImageList(completion: @escaping (Result<[ImageModel], NetworkError>) -> ()) {
        handleCompletion(completion: completion)
    }
    
    private func handleCompletion(completion: @escaping (Result<[ImageModel], NetworkError>) -> ()) {
        switch flow {
        case .requestImageListSucceeded:
            let mockedItem = ImageModel(id: 1, albumId: 2, title: "Mocked Title", url: "https://via.placeholder.com/600/92c952", thumbnailUrl: "https://via.placeholder.com/600/92c952")
            completion(.success([mockedItem]))
            return
        case .requestImageListFailed:
            completion(.failure(.invalidResponse))
            return
        }
    }
}
