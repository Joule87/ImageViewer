//
//  TableViewCellAnimatorTest.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 2/8/21.
//

import Foundation
import XCTest
@testable import ImageViewer

class TableViewCellAnimatorTest: XCTestCase {
    
    func test_animate_succeed() {
        var didAnimate: Bool = false
        let tableViewCellAnimation: TableViewCellAnimation = { _, _, _ in
            didAnimate = true
        }
        let animator = TableViewCellAnimator(animation: tableViewCellAnimation)
        animator.animate(cell: UITableViewCell(), at: IndexPath(), in: UITableView())
        
        XCTAssertTrue(didAnimate)
    }
}
