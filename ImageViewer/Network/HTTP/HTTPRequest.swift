//
//  HTTPRequest.swift
//  ImageViewer
//
//  Created by Julio Collado on 4/8/21.
//

import Foundation

struct HTTPRequest {
    var baseUrl = URL(string: NetworkConfiguration.baseUrl!)!
    var method: HTTPMethod
    var path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    /// Creates request for api defined in NetworkConfiguration with specific path
    ///
    /// - Parameters:
    ///   - method: http method to execute request with
    ///   - path:  path of api resource
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
    
    /// Creates request for specific url
    ///
    /// - Parameters:
    ///   - method:  http method to execute request with
    ///   - url: url of the request
    ///   - path:  path of api resource
    init(method: HTTPMethod, url: URL, path: String) {
        self.method = method
        self.baseUrl = url
        self.path = path
    }
}
