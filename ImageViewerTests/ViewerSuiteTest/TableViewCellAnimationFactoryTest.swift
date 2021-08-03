//
//  TableViewCellAnimationFactoryTest.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 2/8/21.
//

import Foundation
import XCTest
@testable import ImageViewer

class TableViewCellAnimationFactoryTest: XCTestCase {
    
    func test_getAnimation_fade() {
        let animationFactory: CellAnimationFactoryInterface = TableViewCellAnimationFactory()
        let animation = animationFactory.getAnimation(type: .fade, isFirstLoad: false)
        
        let cell = UITableViewCell()
        cell.alpha = 0
        
        let indexPath = IndexPath(item: 0, section: 0)
        animation(cell, indexPath, UITableView())
        
        XCTAssertTrue(cell.alpha == 1)
    }
}
