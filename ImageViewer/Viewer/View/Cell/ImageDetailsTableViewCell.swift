//
//  ImageDetailsTableViewCell.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import UIKit

class ImageDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "ImageDetailsTableViewCell"
    
    @IBOutlet weak var pictureImageView: UIImageView! {
        didSet {
            pictureImageView.layer.cornerRadius = 25
            pictureImageView.accessibilityIdentifier = AccessibilityIdentifier.ImageDetailsTableViewCell.imageDetailView
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.accessibilityIdentifier = AccessibilityIdentifier.ImageDetailsTableViewCell.titleLabel
        }
    }
    
    @IBOutlet weak var albumIdLabel: UILabel! {
        didSet {
            albumIdLabel.font = UIFont.systemFont(ofSize: 14)
            albumIdLabel.textColor = .darkGray
            albumIdLabel.accessibilityIdentifier = AccessibilityIdentifier.ImageDetailsTableViewCell.albumIdLabel
        }
    }
    
    @IBOutlet weak var imageIdLabel: UILabel! {
        didSet {
            imageIdLabel.font = UIFont.systemFont(ofSize: 14)
            imageIdLabel.textColor = .darkGray
            imageIdLabel.accessibilityIdentifier = AccessibilityIdentifier.ImageDetailsTableViewCell.imageIdLabel
        }
    }
    
    func set(url: String?, title: String?, albumId: Int?, imageId: Int?) {
        if let urlString = url {
            pictureImageView.loadImage(from: urlString)
        } else {
            pictureImageView.image = UIImage(named: "placeholder")
        }
        
        self.titleLabel.text = title
        guard let albumIdentifier = albumId, let imageIdentifier = imageId else {
            return
        }
        let albumText = "album".localized
        let imageText = "image".localized
        self.albumIdLabel.text = "\(albumText) #: \(albumIdentifier)"
        self.imageIdLabel.text = "\(imageText) #: \(imageIdentifier)"
    }
    
}
