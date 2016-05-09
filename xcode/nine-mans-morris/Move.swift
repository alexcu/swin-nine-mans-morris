//
//  Move.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Enum representing all possible errors
///
enum MoveError: String, ErrorType, CustomStringConvertible {
    case CannotPerformInInitial
        = "This move cannot be performed in initial game state"
    case CannotPerformInMidgame  = "This move cannot be performed in midgame state"
    case CannotPerformInEndgame  = "This move cannot be performed in endgame state"
    case NoMill                  = "Can only perform this mill if you have a mill"
    case TakeOpponentsToken      = "Can only take an opponent's token"
    case NoTokenAtPosition       = "No token at position specified"
    case CannotActionTokenToPos  = "Cannot action token at position specified"
    case NotMovingYourToken      = "Cannot perform this move to a token that isn't yours"
    case CanOnlySlideToAdjacent  = "Can only slide a token to an adjacent position"
    case MustHaveThreeTokens     = "Can only fly a token if you have three tokens left"
    case MustTakeMill            = "Your opponent has a mill which you must destroy first"
    
    var description: String {
        return self.rawValue
    }
}

///
/// Performs actions on a token to move that token around the 
/// board in a certain way
///
protocol Move {
    ///
    /// Token to move
    /// - Remarks: **IMPLEMENTS** "Get and set token from a move"
    ///
    var token: Token? { get set }
    
    ///
    /// Perform's the operation of this move
    /// - Return: Returns `true` iff the perform was successful
    /// - Remarks: **IMPLEMENTS** "Perform a move"
    ///
    func perform() throws -> Bool
    
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
    func validateLogic() throws -> Bool
}


extension Move {
    // Default implementation for perform
    func perform() throws -> Bool {
        // Validate according to ruleValidator and template function for validate
        // logic
        let validToRules = try Game.sharedGame.ruleValidator.validateMove(self)
        let validToLogic = try self.validateLogic()
        if validToRules && validToLogic {
            // Action the move according to template function
            self.action()
            return true
        } else {
            return false
        }
    }
}