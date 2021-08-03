//
//  NetworkManager.swift
//  ImageViewer
//
//  Created by Julio Collado on 30/7/21.
//

import Foundation

protocol NetworkManagerInterface {
    func fetchObject<T: Codable>(for url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void)
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

struct NetworkManager: NetworkManagerInterface {
    
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs request and decode the data
    /// - Parameters:
    ///   - url: url object
    ///   - completion: handler called upon request completion
    func fetchObject<T: Codable>(for url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response , error in
            if let unwrappedError = error {
                print("Fetch failed with error: \(unwrappedError.localizedDescription)")
                DispatchQueue.main.async {
                    completionHandler(.failure(.error(errorDescription: unwrappedError.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200  else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.invalidData))
                }
                return
            }
            
            do {
                let jsonObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(jsonObject))
                }
            } catch let decodeError {
                if let error = decodeError as? DecodingError {
                    switch error {
                    case .typeMismatch(let key, let value):
                        print("Mismatch Error: \(key), value: \(value), Description: \(error.localizedDescription)")
                    case .valueNotFound(let key, let value):
                        print("Value not Error: \(key), value: \(value), Description: \(error.localizedDescription)")
                    case .keyNotFound(let key, let value):
                        print("Key not found error: \(key), value: \(value), Description: \(error.localizedDescription)")
                    case .dataCorrupted(let key):
                        print("Data Corrupted error: \(key), Description: \(error.localizedDescription)")
                    default:
                        print("ERROR: \(error.localizedDescription)")
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    /// Performs request  and returns the data as it is from given URL
    /// - Parameters:
    ///   - url: url object
    ///   - completion: handler called upon request completion
    func fetchData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, _ , error in
            if let error = error {
                completion(.failure(.error(errorDescription: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }.resume()
    }
}
