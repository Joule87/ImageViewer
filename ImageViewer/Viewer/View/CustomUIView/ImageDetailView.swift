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
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private let bluerEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView()
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.effect = UIBlurEffect(style: .dark)
        return effectView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSAttributedString(string: "X", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
                                                                 NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.8
        button.layer.cornerRadius = 10
        return button
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
        layoutBlurEffect()
        layoutView()
        layoutImageView()
        layoutSlider()
        layoutCloseButton()
        addAnimation()
        addDismissGestureRecognizer()
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
    
    private func layoutBlurEffect() {
        self.addSubview(bluerEffectView)
        NSLayoutConstraint.activate([bluerEffectView.topAnchor.constraint(equalTo: self.topAnchor),
                                     bluerEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     bluerEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     bluerEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    private func layoutImageView() {
        bluerEffectView.contentView.addSubview(imageView)
        [imageView.centerYAnchor.constraint(equalTo: bluerEffectView.centerYAnchor),
         imageView.centerXAnchor.constraint(equalTo: bluerEffectView.centerXAnchor),
         imageView.widthAnchor.constraint(equalTo: bluerEffectView.widthAnchor, multiplier: 0.7),
         imageView.heightAnchor.constraint(equalTo: bluerEffectView.heightAnchor, multiplier: 0.3)]
            .forEach{$0.isActive = true}
    }
    
    private func layoutSlider() {
        bluerEffectView.contentView.addSubview(slider)
        NSLayoutConstraint.activate([slider.bottomAnchor.constraint(equalTo: bluerEffectView.bottomAnchor, constant: -60),
                                     slider.leadingAnchor.constraint(equalTo: bluerEffectView.leadingAnchor, constant: 40),
                                     slider.trailingAnchor.constraint(equalTo: bluerEffectView.trailingAnchor, constant: -40)])
        
    }
    
    private func layoutCloseButton() {
        bluerEffectView.contentView.addSubview(closeButton)
        NSLayoutConstraint.activate([closeButton.widthAnchor.constraint(equalToConstant: 35),
                                     closeButton.heightAnchor.constraint(equalToConstant: 35),
                                     closeButton.topAnchor.constraint(equalTo: bluerEffectView.topAnchor, constant: 50),
                                     closeButton.trailingAnchor.constraint(equalTo: bluerEffectView.trailingAnchor, constant: -25)])
    }
    
    private func addAnimation() {
        animator.addAnimations {
            self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    ///Adds a UITapGestureRecognizer to the view for removing the view from it's parent
    private func addDismissGestureRecognizer() {
        let tapGestureToClose = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        closeButton.addGestureRecognizer(tapGestureToClose)
    }
    
    @objc private func dismiss() {
        animator.stopAnimation(true)
        self.removeFromSuperview()
    }
    
    @objc func handleSliderChange() {
        animator.fractionComplete = CGFloat(slider.value)
    }
}
