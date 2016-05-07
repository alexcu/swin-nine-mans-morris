//
//  ComputerPlayer.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Representation of a computer player
///
struct ComputerPlayer: Player {
    // MARK: Implement Player protocol
    internal(set) var color: Token.Color?
    internal(set) var tokens = [Token]()
    
    // Prevent construction of computer players externally
    internal init() {
        // computers never active so color is nil
        self.color = nil
    }
    
    ///
    /// Checks a player has won, and if so, returns that player
    /// - Remarks: **IMPLEMENTS** "Check if player has won"
    ///
    var playerOutOfTokens: Player? {
        for player in Game.sharedGame.players {
            // Only need to check humans
            if player is HumanPlayer && player.countOfTokensOnBoard < 3 {
                return player
            }
        }
        return nil
    }
    
    ///
    /// Checks if a player is all out of legal moves
    /// - Remarks: **IMPLEMENTS** "Check if there are no more legal moves left"
    ///
    var noMoreLeftsForPlayer: Player? {
        for player in Game.sharedGame.players {
            // Only need to check humans
            if player is HumanPlayer {
                var outOfMoves = true
                for (pos, _) in player.tokensOnBoard {
                    outOfMoves = !(pos.neighbors.top?.token?.ownedBy(player) ?? false) &&
                                 !(pos.neighbors.right?.token?.ownedBy(player) ?? false) &&
                                 !(pos.neighbors.bottom?.token?.ownedBy(player) ?? false) &&
                                 !(pos.neighbors.left?.token?.ownedBy(player) ?? false)
                    if outOfMoves == true {
                        return player
                    }
                }
            }
        }
        return nil
    }
}