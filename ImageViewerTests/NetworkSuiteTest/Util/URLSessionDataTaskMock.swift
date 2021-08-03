//
//  URLSessionDataTaskMock.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 1/8/21.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
