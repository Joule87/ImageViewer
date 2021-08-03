//
//  ImageDetailView.swift
//  ImageViewer
//
//  Created by Julio Collado on 31/7/21.
//

import UIKit

class ImageDetailView: UIView {
    
    private let imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = AccessibilityIdentifier.ImageDetailView.imageDetailView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(in parent: UIView) {
        self.init(frame: CGRect.zero)
        parent.addSubview(self)
        setupContainer()
    }
    
    func loadImage(from url: String) {
        imageView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: {
                self.imageView.transform = .identity
                self.imageView.loadImage(from: url)
            })
    }
    
    ///Setup all UI components in the view
    private func setupContainer() {
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        addDismissGestureRecognizer()
        layoutView()
        layoutImageView()
    }
    
    private func layoutView() {
        guard let parentView = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        [self.topAnchor.constraint(equalTo: parentView.topAnchor),
         self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
         self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
         self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)]
            .forEach{$0.isActive = true}
    }
    
    private func layoutImageView() {
        self.addSubview(imageView)
        [imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
         imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)]
            .forEach{$0.isActive = true}
    }
    
    ///Adds a UITapGestureRecognizer to the view for removing the view from it's parent
    private func addDismissGestureRecognizer() {
        let tapGestureToClose = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tapGestureToClose)
    }
    
    @objc private func dismiss() {
        self.removeFromSuperview()
    }
}
