//
//  TableViewCellAnimationFactory.swift
//  ImageViewer
//
//  Created by Julio Collado on 31/7/21.
//

import UIKit

protocol CellAnimationFactoryInterface {
    func getAnimation(type: TableViewCellAnimationType, isFirstLoad: Bool) -> TableViewCellAnimation
}

struct TableViewCellAnimationFactory: CellAnimationFactoryInterface {
    
    /// Gets a TableViewCellAnimation given a animation type
    /// - Parameters:
    ///   - type: type of animation
    ///   - isFirstLoad: if true the the animation will have a delay factor of 0.05, if false the animation will occur instantly
    /// - Returns: TableViewCellAnimation
    func getAnimation(type: TableViewCellAnimationType, isFirstLoad: Bool) -> TableViewCellAnimation {
        let delayFactor: Double = isFirstLoad ? 0.05 : 0
        switch type {
        case .fade:
            return getFadeAnimation(duration: 0.3, delayFactor: delayFactor)
        }
    }
    
    
    /// Creates animation of fading type
    /// - Parameters:
    ///   - duration: duration of the animation
    ///   - delayFactor: Time before the animation start
    /// - Returns: TableViewCellAnimation
    private func getFadeAnimation(duration: TimeInterval, delayFactor: Double) -> TableViewCellAnimation {
        return { cell, indexPath, _ in
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
                })
        }
    }
}
