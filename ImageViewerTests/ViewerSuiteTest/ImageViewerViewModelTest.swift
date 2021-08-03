//
//  ImageViewerViewModelTest.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 1/8/21.
//

import Foundation

import XCTest
@testable import ImageViewer

class ImageViewerViewModelTest: XCTestCase {
    
    var viewModel: ImageViewerViewModelInterface!
    
    override func setUp() {
        viewModel = ImageViewerViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_refreshList_succeeded_noEmptyList() {
        viewModel.repository = MockedImageViewerRepository()
        var totalImages = 0
        
        viewModel.imageList.bind { imageList in
            totalImages = imageList.count
        }
        viewModel.shouldRefresh = true
        XCTAssertTrue(totalImages > 0)
    }
    
    func test_refreshList_failed() {
        let mockedRepository = MockedImageViewerRepository(flow: .requestImageListFailed(errorType: .invalidData))
        viewModel.repository = mockedRepository
        
        var errorDescription: String? = nil
        viewModel.errorDescription.bind { error in
            errorDescription = error
        }
        viewModel.shouldRefresh = true
        
        XCTAssertFalse(errorDescription == nil)
    }
    
}
