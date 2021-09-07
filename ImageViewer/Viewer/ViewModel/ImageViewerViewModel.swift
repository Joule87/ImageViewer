//
//  ImageViewerViewModel.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

protocol ImageViewerViewModelInterface {
    var repository: ImageViewerRepositoryInterface { get set }
    
    var imageList: Observable<[ImageModel]> { get }
    var errorDescription: Observable<String?> { get }
    
    var shouldRefresh: Bool { get set }
    
}

class ImageViewerViewModel: ImageViewerViewModelInterface {
    
    var repository: ImageViewerRepositoryInterface
    var imageList = Observable<[ImageModel]>([])
    var errorDescription: Observable<String?> = Observable(nil)
    
    var shouldRefresh: Bool = false {
        didSet {
            refreshImageList()
        }
    }
    
    init() {
        repository = ImageViewerRepository(networkManager: NetworkManager())
        requestImageList()
    }
    
    private func requestImageList() {
        repository.requestImageList{ [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.imageList.value = value
            case .failure(let error):
                self.errorDescription.value = error.customDescription
                break
            }
        }
    }
    
    private func refreshImageList() {
        if shouldRefresh {
            self.requestImageList()
            shouldRefresh = false
        }
    }
    
}
