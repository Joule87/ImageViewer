//
//  UIImageView.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    /// Load image if already cached or download it given urlString and cache it using urlString as a key.
    func loadImage(from urlSting: String) {
        let downloader: Downloadable = ImageDownloader()
        downloader.fetch(from: urlSting) { [weak self] data in
            guard let self = self else { return }
            if let imageData = data {
                self.image = UIImage(data: imageData)
            } else {
                self.image = UIImage(named: "placeholder")
            }
        }
    }
}
