//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
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
    /// The original position of the token
    ///
    private let position: Position?
    
    ///
    /// Take the token
    /// - Remarks: **IMPLEMENTS** "Remove token from specific position"
    ///
    internal func action() {
        token?.takeOffBoard()
    }

    ///
    /// Returns an inverse take move that places the taken token onto the position
    ///
    internal func undo() {
        position?.token = token
    }
    
    ///
    /// Returns `true` iff the specific position has a token
    /// - Remarks: **IMPLEMENTS** "Check if a specific position has a token to take a token from"
    ///
    private var canTakeFromPosition: Bool {
        guard let pos = self.token?.position else {
            return false
        }
        return !pos.isFree
    }
    
    ///
    /// Returns `true` iff the specific position to take from is an opponent token
    /// - Remarks: **IMPLEMENTS** "Check if specific position has a token that is not owned by current player"
    ///
    private var isOpponentToken: Bool {
        let ownedByMe = self.token?.ownedBy(Game.sharedGame.currentPlayer) ?? false
        return !ownedByMe
    }
    
    ///
    /// Validates that token can be taken with regard to positional logic
    ///
    internal func validateLogic() throws -> Bool {
        if !self.canTakeFromPosition {
            throw MoveError.NoTokenAtPosition
        }
        if !self.isOpponentToken {
            throw MoveError.TakeOpponentsToken
        }
        return true
    }
    
    ///
    /// Initialiser for the take token move
    /// - Parameter token: The token to take
    ///
    init(token: Token?) {
        self.token = token
        self.position = self.token?.position
    }
}
