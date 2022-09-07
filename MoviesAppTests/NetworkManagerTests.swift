//
//  NetworkManagerTests.swift
//  MoviesAppTests
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import XCTest
@testable import MoviesApp

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.networkManager = NetworkManager(session: MockSession())
    }
    
    override func tearDownWithError() throws {
        self.networkManager = nil
        try super.tearDownWithError()
    }
    
    func testGetModelDataSuccess() {
        // Arrange
        var models: [Movie] = []
        let expectation = XCTestExpectation(description: "Successfully Fetched Movies")
        
        // Act
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else { return }
        
        self.networkManager?.fetchPage(urlStr: url) { (result: Result<MoviePage, NetworkError>) in
            switch result {
            case .success(let page):
                models = page.results
                expectation.fulfill()
            case .failure(let error):
                XCTFail()
                XCTAssertNil(error.localizedDescription)
            }
            
        }
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(models.count, 20)
        XCTAssertEqual(models.first?.title, "Dragon Ball Super: Super Hero")
        XCTAssertEqual(models.first?.id, 610150)
    }
    
    func testGetModelDataError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Movies Not Fetched Successfully")
        
        // Act
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popularr") else { return }
        
        self.networkManager?.fetchPage(urlStr: url) { (result: Result<MoviePage, NetworkError>) in
            switch result {
            case .success(let page):
                XCTAssertNil(page)
                
            case .failure(let error):
                expectation.fulfill()
                XCTFail()
                XCTAssertNotNil(error.localizedDescription)
                
            }
            
        }
    }
    
}
