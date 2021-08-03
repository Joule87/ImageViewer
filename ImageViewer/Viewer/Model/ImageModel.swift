//
//  ImageModel.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

struct ImageModel: Codable {
    let id: Int?
    let albumId: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}
