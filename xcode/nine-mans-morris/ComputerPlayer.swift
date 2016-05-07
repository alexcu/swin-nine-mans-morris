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
class ComputerPlayer: Player {
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
    var playerOutOfMoves: Player? {
        for player in Game.sharedGame.players {
            // Only need to check humans
            if player is HumanPlayer {
                var outOfMoves = true
                for (pos, _) in player.tokensOnBoard {
                    outOfMoves = !(pos.neighbors.top?.token?.ownedBy(player) ?? true) &&
                                 !(pos.neighbors.right?.token?.ownedBy(player) ?? true) &&
                                 !(pos.neighbors.bottom?.token?.ownedBy(player) ?? true) &&
                                 !(pos.neighbors.left?.token?.ownedBy(player) ?? true)
                }
                if outOfMoves {
                    return player
                }
            }
        }
        return nil
    }
    
    ///
    /// Validates a move according to game rules
    /// - Remarks: **IMPLEMENTS** "Validate a human player's move"
    ///
    func validateMove(move: Move) -> Bool {
        var isValidMove = false
        // Validate by game state
        switch Game.sharedGame.currentState {
        case .Initial:
            isValidMove = move is PlaceMove
        case .Midgame:
            isValidMove = move is TakeMove || move is SlideMove
        case .Endgame:
            isValidMove = move is TakeMove || move is SlideMove || move is FlyMove
        }
        // If taking, we must check if we have a mill
        if move is TakeMove {
            isValidMove = isValidMove && Game.sharedGame.currentPlayer.hasMill
        }
        return isValidMove
    }
    
    func performMove(move: Move) -> Bool {
        fatalError("Computer player does not have AI to implement move")
    }
}