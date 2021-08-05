//
//  ImageViewerDataSourceManager.swift
//  ImageViewer
//
//  Created by Julio Collado on 4/8/21.
//

import UIKit

protocol ImageViewerDataSourceManagerInterface: UITableViewDataSource, UITableViewDelegate {
    var imageList: [ImageModel] { get set }
    var isFirstLoad: Bool { get set }
    var navigationController: UINavigationController? { get set }
}

class ImageViewerDataSourceManager: NSObject, ImageViewerDataSourceManagerInterface {
    var isFirstLoad: Bool = true
    var imageList: [ImageModel] = []
    weak var navigationController: UINavigationController?
    
    init(imageList: [ImageModel] = [], navigationController: UINavigationController? = nil) {
        self.imageList = imageList
        self.navigationController = navigationController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageDetailsTableViewCell.identifier) as? ImageDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = imageList[indexPath.row]
        cell.set(url: item.url, title: item.title, albumId: item.albumId, imageId: item.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageStringUrl = imageList[indexPath.row].url, let parentView = tableView.superview else {
            return
        }
        
        let imageDetailView = ImageDetailView(in: parentView)
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
        guard let navigationController = self.navigationController else { return }
        let yAxisTranslation = scrollView.panGestureRecognizer.translation(in: scrollView).y
        yAxisTranslation < 0 ? navigationController.setNavigationBarHidden(true, animated: true) : navigationController.setNavigationBarHidden(false, animated: true)
    }
    
}
