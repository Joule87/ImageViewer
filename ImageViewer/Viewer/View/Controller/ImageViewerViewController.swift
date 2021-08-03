//
//  ViewController.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageTableView: UITableView! {
        didSet {
            imageTableView.isAccessibilityElement = true
            imageTableView.accessibilityIdentifier = AccessibilityIdentifier.ImageViewerViewController.imageTableView
            registerTableViewCells()
        }
    }
    
    //MARK: - Properties
    var viewModel: ImageViewerViewModelInterface?
    private var isFirstLoad = true
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        return spinner
    }()
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "viewer.navigationBar.title".localized
        viewModel = ImageViewerViewModel()
        addInitLoadingAnimation()
        setupRefreshControl()
        setBindToImageListUpdate()
        setBindOnError()
    }
    
    ///Creates the binding, setting all the actions to take after list of images value has changed
    private func setBindToImageListUpdate() {
        viewModel?.imageList.bind { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.imageTableView.reloadData()
            
            self.removeInitLoadingAnimationIfNeeded()
            self.stopRefreshControlIfNeeded()
        }
    }
    
    ///Creates the binding, setting all the actions to take after an error has occurred
    private func setBindOnError() {
        guard let unWrappedViewModel = viewModel else {
            return
        }
        
        unWrappedViewModel.errorDescription.bind { [weak self] errorMessage in
            guard let self = self else {
                return
            }
            self.removeInitLoadingAnimationIfNeeded()
            self.stopRefreshControlIfNeeded()
            let alert = UIAlertController(title: "error".localized, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss".localized, style: .default))
            self.present(alert, animated: true)
        }
    }
    
    ///Adds an UIActivityIndicatorView in the background of imageTableView on initialization and disable tableview user interaction
    private func addInitLoadingAnimation() {
        imageTableView.backgroundView = spinner
        spinner.startAnimating()
        imageTableView.isUserInteractionEnabled = false
    }
    
    ///Stops and removed the UIActivityIndicatorView shown on initialization in the background, and enable tableview user interaction
    private func removeInitLoadingAnimationIfNeeded() {
        if !spinner.isAnimating {
            return
        }
        self.spinner.stopAnimating()
        self.imageTableView.backgroundView = nil
        self.imageTableView.isUserInteractionEnabled = true
    }
    
    private func registerTableViewCells() {
        imageTableView.register(UINib(nibName: ImageDetailsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageDetailsTableViewCell.identifier)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        imageTableView?.refreshControl = refreshControl
    }
    
    private func stopRefreshControlIfNeeded() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
            imageTableView.setContentOffset(.zero, animated: true)
        }
    }
    
    ///Begin UIRefreshControl refreshing animation and triggers a request for refreshing the data
    @objc private func refreshData() {
        refreshControl.beginRefreshing()
        viewModel?.shouldRefresh = true
    }
}

//MARK: - ImageViewerViewModelDelegate
extension ImageViewerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.imageList.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageDetailsTableViewCell.identifier) as? ImageDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.imageList.value[indexPath.row]
        cell.set(url: item.url, title: item.title, albumId: item.albumId, imageId: item.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageStringUrl = viewModel?.imageList.value[indexPath.row].url else {
            return
        }
        let imageDetailView = ImageDetailView(in: self.view)
        imageDetailView.loadImage(from: imageStringUrl)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animationFactory: CellAnimationFactoryInterface = TableViewCellAnimationFactory()
        let animation = animationFactory.getAnimation(type: .fade, isFirstLoad: isFirstLoad)
        
        let animator: TableViewCellAnimatorInterface = TableViewCellAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
        if isFirstLoad, tableView.isLastVisibleCell(at: indexPath) {
            isFirstLoad = false
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        hideNavigationBarOnScrolling(scrollView)
    }
    
    ///Hides navigation bar on scrolling down and shows it when scrolling up.
    private func hideNavigationBarOnScrolling(_ scrollView: UIScrollView) {
        let yAxisTranslation = scrollView.panGestureRecognizer.translation(in: scrollView).y
        yAxisTranslation < 0 ? navigationController?.setNavigationBarHidden(true, animated: true) : navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}
