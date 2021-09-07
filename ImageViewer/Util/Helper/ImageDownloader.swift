//
//  ImageDownloader.swift
//  ImageViewer
//
//  Created by Julio Collado on 19/8/21.
//

import UIKit

protocol Downloadable {
    func fetch(from urlSting: String, completion: ((Data?) -> Void)?)
}

struct ImageDownloader: Downloadable {
    
    var networkManager: NetworkManagerInterface = NetworkManager()
    
    /// Download image from given urlString and cache it using urlString as a key.
    /// - Parameters:
    ///   - urlSting: String URL
    ///   - completion: A block object to be executed over fetched data.
    func fetch(from urlSting: String, completion: ((Data?) -> Void)? = nil) {
        guard let url = URL(string: urlSting) else {
            completion?(nil)
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject), let data = imageFromCache as? Data {
            completion?(data)
            return
        }
        
        networkManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else {
                    completion?(nil)
                    return
                }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                completion?(data)
            case .failure(_):
                completion?(nil)
            }
        }
    }
}
