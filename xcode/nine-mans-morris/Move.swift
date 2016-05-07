//
//  Move.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Performs actions on a token to move that token around the 
/// board in a certain way
///
protocol Move {
    ///
    /// Token to move
    /// - Remarks: **IMPLEMENTS** "Get and set token from a move"
    ///
    var token: Token { get set }
    
    ///
    /// Perform's the operation of this move
    /// - Return: Returns `true` iff the perform was successful
    /// - Remarks: **IMPLEMENTS** "Perform a move"
    ///
    func perform() -> Bool
    
    ///
    /// Action this move and perform any changes that need to occur
    ///
    func action()
    
    ///
    /// Perform's the reverse operation of this move
    /// - Return: Returns a new move that represents the reversal move
    /// - Remarks: **IMPLEMENTS** "Reverse move"
    ///
    var inverseMove: Move { get }

    ///
    /// Validate's the move according to its own logic
    /// - Return: Returns `true` iff the move was validated
    ///
    func validateLogic() -> Bool
}


extension Move {
    // Default implementation for perform
    func perform() -> Bool {
        // Validate according to ruleValidator and template function for validate
        // logic
        if Game.sharedGame.ruleValidator.validateMove(self) && self.validateLogic() {
            // Action the move according to template function
            self.action()
            return true
        } else {
            return false
        }
    }
}