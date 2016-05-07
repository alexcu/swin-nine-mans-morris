//
//  TakeMove.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Extends a standard move by removing the token from the provided position 
/// if and only if the player has at least one mill.
///
struct TakeMove: Move {
    // MARK: Implement Move
    
    ///
    /// The token to take
    ///
    internal(set) var token: Token?
    
    ///
    /// Take the token
    /// - Remarks: **IMPLEMENTS** "Remove token from specific position"
    ///
    func action() {
        token?.takeOffBoard()
    }

    ///
    /// Returns an inverse take move that places the taken token onto the position
    ///
    var inverseMove: Move {
        let pos = self.token?.position!
        return PlaceMove(token: self.token, position: pos)
    }
    
    ///
    /// Returns `true` iff the specific position has a token
    /// - Remarks: **IMPLEMENTS** "Check if a specific position has a token to take a token from"
    ///
    var canTakeFromPosition: Bool {
        guard let pos = self.token?.position else {
            return false
        }
        return !pos.isFree
    }
    
    ///
    /// Returns `true` iff the specific position to take from is an opponent token
    /// - Remarks: **IMPLEMENTS** "Check if specific position has a token that is not owned by current player"
    ///
    var isOpponentToken: Bool {
        return (self.token?.ownedBy(Game.sharedGame.currentPlayer)) ?? false
    }
    
    ///
    /// Validates that token can be taken with regard to positional logic
    ///
    func validateLogic() throws -> Bool {
        if !canTakeFromPosition {
            throw MoveError.NoTokenAtPosition
        }
        if !isOpponentToken {
            throw MoveError.TakeOpponentsToken
        }
        return true
    }
}
