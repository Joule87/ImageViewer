//
//  UITableView+Extension.swift
//  ImageViewer
//
//  Created by Julio Collado on 31/7/21.
//

import UIKit

extension UITableView {
    /// Compare last index row visible with given index and return true if equals
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
}
