//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import Foundation


internal class NetworkManager {
    
    let session: Session
    let decoder: JSONDecoder = JSONDecoder()
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager {
    
    func fetchPage(urlStr: URL?, completion: @escaping (Result<MoviePage, NetworkError>) -> Void) {
        
        guard let url = urlStr else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
        
        self.session.retrieveData(url: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            
            if let hResponse = response as? HTTPURLResponse, !(200..<300).contains(hResponse.statusCode) {
                completion(.failure(NetworkError.serverResponse(hResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataFailure))
                return
            }
            
            do {
                let model = try self.decoder.decode(MoviePage.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(NetworkError.decodeError(error)))
            }
        }
        
    }
    
    
    func fetchImageData(urlStr: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        guard let url = urlStr else {
            completion(.failure(NetworkError.urlFailure))
            return
        }
        
        
        self.session.retrieveData(url: url) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkError.other(error)))
                return
            }
            
            if let hResponse = response as? HTTPURLResponse, !(200..<300).contains(hResponse.statusCode) {
                completion(.failure(NetworkError.serverResponse(hResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataFailure))
                return
            }
            
            completion(.success(data))
            
        }
        
    }
    
}
