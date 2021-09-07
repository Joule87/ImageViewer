//
//  UITableViewDataSourceInterface.swift
//  ImageViewer
//
//  Created by Julio Collado on 27/8/21.
//

import Foundation

protocol DataSourceInterface {
    associatedtype T
    var data: T { get set }
}
