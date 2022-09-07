//
//  TestImageCache.swift
//  MoviesAppTests
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import XCTest
@testable import MoviesApp

class ImageCacheTests: XCTestCase {
    var imageCache: ImageCache?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.imageCache = ImageCache()
    }
    
    override func tearDownWithError() throws {
        self.imageCache = nil
        try super.tearDownWithError()
    }
    
    func testCacheKeyNotFound() {
        // Arrange
        let key = "ImageKey"
        
        // Act
        let imageData = self.imageCache?.getImageData(key: key)
        
        // Assert
        XCTAssertNil(imageData)
    }
    
    func testCacheAll() {
        // Arrange
        let key = "ImageKey"
        let sampleImage = UIImage(named: "posterimagee")?.jpegData(compressionQuality: 1.0) ?? Data()
        
        // Act
        self.imageCache?.setImageData(data: sampleImage, key: key)
        let pulledImageData = self.imageCache?.getImageData(key: key)
        
        // Assert
        XCTAssertEqual(pulledImageData, sampleImage)
    }
    
}
