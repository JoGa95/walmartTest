//
//  IntegersExcerciseMocker.swift
//  WalmartTestTests
//
//  Created by Jorge Garay on 03/01/24.
//

import Foundation

class IntegersExcerciseMocker {
    static let shared = IntegersExcerciseMocker()
    
    func getSumIntegers(_ array: [Int]) -> Int {
        let sum = array.reduce(0, +)
        return sum
    }
}
