//
//  UIImageView.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /// Download image from given urlString and  cache it using urlString as a key.
    func loadImage(from urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        NetworkManager().fetchData(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                self.image = UIImage(data: data)
            case .failure(_):
                self.image = UIImage(named: "placeholder")
            }
        }
    }
}
