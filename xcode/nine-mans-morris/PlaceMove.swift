//
//  TakeMove.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Performs a placement of a token onto a single position on the board. Used 
/// for initial token placement and subclasses used during gameplay for certain
/// moves
///
class PlaceMove: Move {
    // MARK: Implement Move
    
    ///
    /// The token to place
    ///
    var token: Token
    
    ///
    /// The position to place at
    ///
    var position: Position
    
    ///
    /// Take the token
    /// - Remarks: **IMPLEMENT** Place a specific token at a new position
    ///
    func action() {
        position.token = self.token
    }
    
    ///
    /// Returns an inverse take move that takes the taken token off the board
    ///
    var inverseMove: Move {
        return TakeMove(token: self.token)
    }
    
    ///
    /// Returns `true` iff the position doesn't contain a token
    /// - Remarks: **IMPLEMENTS** Confirm if specific position has a token to place a new token at
    ///
    var canPlaceAtPosition: Bool {
        return self.position.isFree
    }
    
    ///
    /// A token can logically always be placed
    ///
    func validateLogic() -> Bool {
        return canPlaceAtPosition
    }
    
    ///
    /// Initialiser for placing a token
    ///
    init(token: Token, position: Position) {
        self.token = token
        self.position = position
    }
}
