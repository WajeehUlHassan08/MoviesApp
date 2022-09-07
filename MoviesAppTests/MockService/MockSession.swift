//
//  MockNetworkManager.swift
//  MoviesAppTests
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import Foundation
@testable import MoviesApp

class MockSession: Session {
    
    func retrieveData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // First Success
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            do {
                let bundle = Bundle(for: MoviesAppTests.self)
                let path = bundle.path(forResource: "MockMovieData", ofType: "json") ?? ""
                
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                completion(jsonData, nil, nil)
            } catch {
                print(error)
                completion(nil, nil, nil)
            }
        }
        
    }
    
}

