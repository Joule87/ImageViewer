//
//  Animator.swift
//  TableViewCellAnimator
//
//  Created by Julio Collado on 31/7/21.
//

import UIKit

typealias TableViewCellAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

protocol TableViewCellAnimatorInterface {
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView)
}

struct TableViewCellAnimator: TableViewCellAnimatorInterface {
    
    private let animation: TableViewCellAnimation
    
    init(animation: @escaping TableViewCellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        animation(cell, indexPath, tableView)
    }
    
}
