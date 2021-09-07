//
//  Box.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

final class Observable<T>: NSObject {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    ///Create binding between the observer and the observed object
    /// - Parameters:
    ///   - onPublish: if true only emits new events
    ///   - listener: the one observing for changes
    func bind(onPublish: Bool = false, listener: @escaping Listener) {
        self.listener = listener
        if onPublish {
            listener(value)
        }
    }
}
