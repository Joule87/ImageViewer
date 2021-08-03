//
//  ImageViewerViewModel.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

protocol ImageViewerViewModelInterface {
    var repository: ImageViewerRepositoryInterface { get set }
    
    var imageList: Box<[ImageModel]> { get }
    var errorDescription: Box<String?> { get }
    
    var shouldRefresh: Bool { get set }
    
}

class ImageViewerViewModel: ImageViewerViewModelInterface {
    
    var repository: ImageViewerRepositoryInterface
    var imageList = Box<[ImageModel]>([])
    var errorDescription: Box<String?> = Box(nil)
    
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
