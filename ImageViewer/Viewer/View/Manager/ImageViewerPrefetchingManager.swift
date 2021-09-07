//
//  ImageViewerPrefetchingManager.swift
//  ImageViewer
//
//  Created by Julio Collado on 19/8/21.
//

import UIKit

class ImageViewerPrefetchingManager: NSObject, DataSourceInterface {
    var data: [ImageModel] = []
    
    init(imageList: [ImageModel] = []) {
        self.data = imageList
    }
    
}

//MARK: - UITableViewDataSourcePrefetching
extension ImageViewerPrefetchingManager: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let downloader = ImageDownloader()
        indexPaths.forEach({ item in
            if let imageStringUrl = data[item.row].url {
                downloader.fetch(from: imageStringUrl)
            }
        })
    }
}
