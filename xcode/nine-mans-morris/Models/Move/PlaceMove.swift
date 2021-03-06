//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
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
    internal(set) var token: Token?
    
    ///
    /// The position to place at
    ///
    private(set) var position: Position?

    ///
    /// Actions the Place Move
    ///
    internal func action() {
        self.placeTokenAtPosition()
    }

    ///
    /// Places the token at the position
    /// - Remarks: **IMPLEMENTS** Place a specific token at a new position
    ///
    private func placeTokenAtPosition() {
        self.position?.token = self.token
        self.token?.isPlaced = true // token is now placed
    }

    ///
    /// Returns an inverse take move that takes the taken token off the board
    ///
    internal func undo() {
        self.token?.takeOffBoard()
        self.token?.isPlaced = false // undo the token being placed
    }
    
    ///
    /// Returns `true` iff the position doesn't contain a token
    /// - Remarks: **IMPLEMENTS** Confirm if specific position has a token to place a new token at
    ///
    private var canPlaceAtPosition: Bool {
        return self.position?.isFree ?? false
    }
    
    ///
    /// Returns `true` iff the current player owns the token to be moved
    ///
    private var movingMyToken: Bool {
        return self.token?.ownedBy(Game.sharedGame.currentPlayer) ?? false
    }
    
    ///
    /// A token can logically always be placed
    ///
    internal func validateLogic() throws -> Bool {
        // Can only move our tokens and place at the position
        if !canPlaceAtPosition {
            throw MoveError.CannotActionTokenToPos
        }
        if !movingMyToken {
            throw MoveError.NotMovingYourToken
        }
        return true
    }
    
    ///
    /// Initialiser for placing a token
    ///
    init(token: Token?, position: Position?) {
        self.token = token
        self.position = position
    }
}
