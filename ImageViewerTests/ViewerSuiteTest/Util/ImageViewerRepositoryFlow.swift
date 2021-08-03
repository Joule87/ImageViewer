//
//  ImageViewerRepositoryFlow.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 1/8/21.
//

import Foundation
@testable import ImageViewer

enum ImageViewerRepositoryFlow {
    case requestImageListSucceeded
    case requestImageListFailed(errorType: NetworkError)
}
