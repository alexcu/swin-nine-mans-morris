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
    /// Last move made by the player
    /// - Remarks: **IMPLEMENTS** "Get, set and clear the last move that was made"
    ///
    var lastMove: Move?
    
    ///
    /// Perform undo of move made by the player
    /// - Remarks: **IMPLEMENTS** "Undo last move made"
    ///
    func undoLastMove() throws -> Bool {
        if let lastMove = self.lastMove {
            return try lastMove.inverseMove.perform()
        } else {
            return false
        }
    }
    
    ///
    /// Performs a move on the player
    ///
    func performMove(move: Move) throws -> Bool {
        if try move.perform() {
            self.lastMove = move
            return true
        }
        return false
    }
}
