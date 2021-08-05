//
//  NetworkManagerTests.swift
//  ImageViewerTests
//
//  Created by Julio Collado on 1/8/21.
//

import XCTest
@testable import ImageViewer

class NetworkManagerTests: XCTestCase {
    
    private var networkManager: NetworkManager!
    private var session: URLSessionMock!
    private let url = URL(string: NetworkConfiguration.baseUrl!)!
    private let request = HTTPRequest(method: .get, path: "photos")
    
    override func setUp() {
        session = URLSessionMock()
        networkManager = NetworkManager(session: session)
    }
    
    override func tearDown() {
        session = nil
        networkManager = nil
    }
    
    func test_fetchData_Succeeded() {
        let data = Data([0, 1, 0, 1])
        session.data = data
        
        networkManager.fetchData(from: url, completion: { (result) in
            switch result {
            case .success(let value):
                XCTAssertEqual(data, value)
            case .failure(_):
                XCTAssertNil(false)
            }
        })
    }
    
    func test_fetchData_invalidData() {
        networkManager.fetchData(from: url, completion: { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case .invalidData:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        })
    }
    
    func test_fetchData_Error() {
        session.error = NetworkError.error(errorDescription: "Mocked Error")
        
        networkManager.fetchData(from: url, completion: { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case .error(_):
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        })
    }
    
    func test_fetchObject_Succeeded() {
        let mockedImage = ImageModel(id: 1, albumId: 2, title: "Mocked Title", url: "https://via.placeholder.com/600/92c952", thumbnailUrl: "https://via.placeholder.com/600/92c952")
        guard let data = try? JSONEncoder().encode([mockedImage]) else {
            XCTAssert(false)
            return
        }
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        session.data = data
        session.response = urlResponse
        
        let completion: (Result<[ImageModel], NetworkError>) -> () = { result in
            switch result {
            case .success(let value):
                XCTAssertTrue(value.count == 1)
            case .failure(_):
                XCTAssert(false)
            }
        }
        networkManager.fetchObject(for: request, completionHandler: completion)
    }
    
    func test_fetchObject_Error() {
        session.error = NetworkError.error(errorDescription: "Mocked Error")
        let completion: (Result<[ImageModel], NetworkError>) -> () = { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case .error(_):
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        }
        networkManager.fetchObject(for: request, completionHandler: completion)
    }
    
    func test_fetchObject_dataNotFound() {
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = urlResponse
        
        let completion: (Result<[ImageModel], NetworkError>) -> () = { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case .invalidData:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        }
        networkManager.fetchObject(for: request, completionHandler: completion)
    }
    
    func test_fetchObject_invalidResponse() {
        let urlResponse = HTTPURLResponse(url: url, statusCode: 503, httpVersion: nil, headerFields: nil)
        session.response = urlResponse
        
        let completion: (Result<[ImageModel], NetworkError>) -> () = { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case .invalidResponse:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        }
        networkManager.fetchObject(for: request, completionHandler: completion)
    }
    
    func test_fetchObject_decodeError() {
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = urlResponse
        session.data = Data()
        
        let completion: (Result<[ImageModel], NetworkError>) -> () = { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error {
                case .decodingError:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        }
        networkManager.fetchObject(for: request, completionHandler: completion)
    }
}
