//
//  String+Extension.swift
//  ImageViewer
//
//  Created by Julio Collado on 2/8/21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, locale: nil, arguments: arguments)
    }
}
