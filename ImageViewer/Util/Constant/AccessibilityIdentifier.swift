//
//  AccessibilityIdentifier.swift
//  ImageViewer
//
//  Created by Julio Collado on 1/8/21.
//

import Foundation

struct AccessibilityIdentifier {
    struct ImageViewerViewController {
        static let imageTableView = "iv_imageTableView"
        static let imageTableViewCell = "iv_imageTableViewCell"
    }
    
    struct ImageDetailView {
        static let imageDetailView = "idv_ImageDetailView"
    }
    
    struct ImageDetailsTableViewCell {
        static let imageDetailView = "id_tableViewCell_imageView"
        static let titleLabel = "id_tableViewCell_titleLabel"
        static let albumIdLabel = "id_tableViewCell_albumLabel"
        static let imageIdLabel = "id_tableViewCell_imageIdLabel"
    }
}
