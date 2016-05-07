//
//  Int+nthBit.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Extension to Swift's Integer class
///
extension Int {
    ///
    /// Returns the n'th bit of this integer
    ///
    func nthBit(n: Int) -> Int {
        return (self >> n) & 1
    }
}