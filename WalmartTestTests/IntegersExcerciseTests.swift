//
//  WalmartTestTests.swift
//  WalmartTestTests
//
//  Created by Jorge Garay on 03/01/24.
//

import XCTest

final class IntegersExcerciseTests: XCTestCase {
    private let mockClass = IntegersExcerciseMocker.shared
    
    func testGetSumIntegers() {
        // Arrange
        let array = [1, 2, 3, 4, 5]
        
        // Act
        let result = mockClass.getSumIntegers(array)
        
        // Assert
        XCTAssertEqual(result, 15, "Sum of integers should be 15")
    }
    
    func testGetSumIntegersEmptyArray() {
        // Arrange
        let array: [Int] = []
        
        // Act
        let result = mockClass.getSumIntegers(array)
        
        // Assert
        XCTAssertEqual(result, 0, "Sum of an empty array should be 0")
    }
    
    func testGetSumIntegersNegativeNumbers() {
        // Arrange
        let array = [-1, -2, -3, -4, -5]
        
        // Act
        let result = mockClass.getSumIntegers(array)
        
        // Assert
        XCTAssertEqual(result, -15, "Sum of negative integers should be -15")
    }
    
}
