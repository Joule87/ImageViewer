//
//  ImageViewerDataSourceManager.swift
//  ImageViewer
//
//  Created by Julio Collado on 4/8/21.
//

import UIKit

class ImageViewerDataSourceManager: NSObject, DataSourceInterface, Navigable {
    var data: [ImageModel] = []
    weak var navigationController: UINavigationController?
    private var isFirstLoad: Bool = true
    
    init(imageList: [ImageModel] = [], navigationController: UINavigationController? = nil) {
        self.data = imageList
        self.navigationController = navigationController
    }
    
    ///Hides navigation bar on scrolling down and shows it when scrolling up.
    private func hideNavigationBarOnScrolling(_ scrollView: UIScrollView) {
        guard let navigationController = self.navigationController else { return }
        let yAxisTranslation = scrollView.panGestureRecognizer.translation(in: scrollView).y
        yAxisTranslation < 0 ? navigationController.setNavigationBarHidden(true, animated: true) : navigationController.setNavigationBarHidden(false, animated: true)
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ImageViewerDataSourceManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageDetailsTableViewCell.identifier) as? ImageDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = data[indexPath.row]
        cell.set(url: item.url, title: item.title, albumId: item.albumId, imageId: item.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageStringUrl = data[indexPath.row].url, let navController = navigationController else {
            return
        }
        
        let imageDetailView = ImageDetailView(in: navController.view)
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
}
