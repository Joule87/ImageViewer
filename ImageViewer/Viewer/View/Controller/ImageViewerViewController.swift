//
//  ViewController.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import UIKit

struct DataSourceAnimatableManager<M: DataSourceInterface, Navigable> {
    var manager: M
}

struct DataSourceManager<M: DataSourceInterface> {
    var manager: M
}

class ImageViewerViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageTableView: UITableView! {
        didSet {
            imageTableView.isAccessibilityElement = true
            imageTableView.accessibilityIdentifier = AccessibilityIdentifier.ImageViewerViewController.imageTableView
            registerTableViewCells()
            imageTableView.dataSource = tableViewDataSourceManager.manager
            imageTableView.delegate = tableViewDataSourceManager.manager
            imageTableView.prefetchDataSource = tableViewPrefetchManager.manager
        }
    }
    
    //MARK: - Properties
    var viewModel: ImageViewerViewModelInterface? = ImageViewerViewModel()
    
    var tableViewDataSourceManager: DataSourceAnimatableManager = DataSourceAnimatableManager<ImageViewerDataSourceManager, Navigable>(manager: ImageViewerDataSourceManager())
    var tableViewPrefetchManager: DataSourceManager = DataSourceManager<ImageViewerPrefetchingManager>(manager: ImageViewerPrefetchingManager())
    
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
        tableViewDataSourceManager.manager.navigationController = navigationController
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
            let imageList = self.viewModel?.imageList.value ?? []
            self.tableViewDataSourceManager.manager.data = imageList
            self.tableViewPrefetchManager.manager.data = imageList
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
