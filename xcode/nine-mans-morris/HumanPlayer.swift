//
//  HumanPlayer.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A player controlled by a human that is interacting with the game.
/// Also interacts with human via HIDs
///
class HumanPlayer: Player {
    // MARK: Implement Player protocol
    internal(set) var color: Token.Color?
    internal(set) var tokens = [Token]()
    
    ///
    /// Name of the player
    ///
    let name: String

    ///
    /// Initialises a new human player with a given name
    ///
    internal init(name: String) {
        self.name = name
    }
    
    ///
    /// Last moves made by the player
    /// - Remarks: **IMPLEMENTS** "Get, set and clear the last move that was made"
    ///
    var lastMoves: Stack<Move>?
    
    ///
    /// Perform undo of move made by the player
    /// - Remarks: **IMPLEMENTS** "Undo last move made"
    ///
    func undoLastMove() throws -> Bool {
        if let lastMove = self.lastMoves?.pop() {
            // If the last move was a take move, we need to pop again to also undo
            // the move that allowed the token to be taken in the first place
            var result = try lastMove.inverseMove.perform()
            if let takeLastMove = self.lastMoves?.pop() where lastMove is TakeMove {
                result = try takeLastMove.inverseMove.perform() && result
            }
            return result
        } else {
            return false
        }
    }
    
    ///
    /// Performs a move on the player
    ///
    func performMove(move: Move) throws -> Bool {
        if try move.perform() {
            // Set the player's last move to this
            self.lastMoves?.push(move)
            return true
        }
        return false
    }
}
