//
//  ImageViewerPrefetchingManager.swift
//  ImageViewer
//
//  Created by Julio Collado on 19/8/21.
//

import UIKit

protocol ImageViewerPrefetchingInterface: UITableViewDataSourcePrefetching {
    var imageList: [ImageModel] { get set }
}

class ImageViewerPrefetchingManager: NSObject, ImageViewerPrefetchingInterface {
    var imageList: [ImageModel] = []
    
    init(imageList: [ImageModel] = []) {
        self.imageList = imageList
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let downloader = ImageDownloader()
        indexPaths.forEach({ item in
            if let imageStringUrl = imageList[item.row].url {
                downloader.fetch(from: imageStringUrl)
            }
        })
    }
}
