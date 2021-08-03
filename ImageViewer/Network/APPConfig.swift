//
//  APPConfig.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

struct APPNetworkConfig {
    static var baseUrl: String? {
        guard let path = Bundle.main.path(forResource: ConstantFileName.INFO, ofType: ConstantFileType.PLIST),
              let infoDictionaty = NSDictionary(contentsOfFile: path),
              let serverURL = infoDictionaty[ConstantNetwork.SERVER_URL] as? String else {
            return nil
        }
        return serverURL
    }
}
