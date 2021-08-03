//
//  ImageViewerViewControllerUITests.swift
//  ImageViewerUITests
//
//  Created by Julio Collado on 30/7/21.
//

import XCTest
@testable import ImageViewer

class ImageViewerViewControllerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    func test_imageTableView_existence() {
        let imageTableViewExist = app.tables[AccessibilityIdentifier.ImageViewerViewController.imageTableView].exists
        XCTAssertTrue(imageTableViewExist)
    }
    
    func test_imageTableView_elements_existence() {
        let cellsExist = app.tables[AccessibilityIdentifier.ImageViewerViewController.imageTableView]
            .cells[AccessibilityIdentifier.ImageViewerViewController.imageTableViewCell]
            .waitForExistence(timeout: 5)
       
        XCTAssertTrue(cellsExist)
        
        app.tables[AccessibilityIdentifier.ImageViewerViewController.imageTableView].cells.element(boundBy: 0).tap()
        
        let imageDetailViewExist = app.images[AccessibilityIdentifier.ImageDetailsTableViewCell.imageDetailView].exists
        XCTAssertTrue(imageDetailViewExist)
    }
    
    func test_imageTableViewCell_existence() {
        let cells = app.tables[AccessibilityIdentifier.ImageViewerViewController.imageTableView].cells[AccessibilityIdentifier.ImageViewerViewController.imageTableViewCell]
        let imageTableViewCellsExist = cells.waitForExistence(timeout: 3)
        XCTAssert(imageTableViewCellsExist)
        
    }
    
    func test_imageTableViewCell_elements_existence() {
        let cells = app.tables[AccessibilityIdentifier.ImageViewerViewController.imageTableView].cells[AccessibilityIdentifier.ImageViewerViewController.imageTableViewCell]
        let _ = cells.waitForExistence(timeout: 3)
        let imageDetailViewExist = app.images[AccessibilityIdentifier.ImageDetailsTableViewCell.imageDetailView].exists
        let titleLabelExist = app.staticTexts[AccessibilityIdentifier.ImageDetailsTableViewCell.titleLabel].exists
        let albumIdLabelExist = app.staticTexts[AccessibilityIdentifier.ImageDetailsTableViewCell.albumIdLabel].exists
        let imageIdLabelExist = app.staticTexts[AccessibilityIdentifier.ImageDetailsTableViewCell.imageIdLabel].exists
        
        XCTAssertTrue(imageDetailViewExist)
        XCTAssertTrue(titleLabelExist)
        XCTAssertTrue(albumIdLabelExist)
        XCTAssertTrue(imageIdLabelExist)
    }
    
}
