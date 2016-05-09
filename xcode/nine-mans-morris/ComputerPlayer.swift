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
        guard let loser = Game.sharedGame.players.filter({$0.countOfTokensOnBoard < 3}).first else {
            return nil
        }
        return loser
    }
    
    ///
    /// Checks if a player is all out of legal moves
    /// - Remarks: **IMPLEMENTS** "Check if there are no more legal moves left"
    ///
    var playerOutOfMoves: Player? {
        guard let loser = Game.sharedGame.players.filter({ player in
            player.tokensOnBoard.values.reduce(true) { allSurrounded, token in
                return allSurrounded && token.isSurrounded
            }
        }).first else {
            return nil
        }
        return loser
    }
    
    ///
    /// Validates a move according to game rules
    /// - Remarks: **IMPLEMENTS** "Validate a human player's move"
    ///
    func validateMove(move: Move) throws -> Bool {
        var isValidMove = false
        // Validate by game state
        switch Game.sharedGame.currentState {
        case .Initial:
            isValidMove = move is PlaceMove
            if !isValidMove {
                throw MoveError.CannotPerformInInitial
            }
        case .Midgame:
            isValidMove = move is TakeMove || move is SlideMove
            if !isValidMove {
                throw MoveError.CannotPerformInMidgame
            }
        case .Endgame:
            isValidMove = move is TakeMove || move is SlideMove || move is FlyMove
            if !isValidMove {
                throw MoveError.CannotPerformInEndgame
            }
        }
        // If taking, we must check if we have a mill
        if move is TakeMove {
            isValidMove = isValidMove && Game.sharedGame.currentPlayer.hasMill
            if !isValidMove {
                throw MoveError.NoMill
            }
        }
        // If flying, we must check if we have 3 tokens
        if move is FlyMove && !(move is SlideMove) {
            isValidMove = isValidMove && Game.sharedGame.currentPlayer.countOfTokensOnBoard == 3
            if !isValidMove {
                throw MoveError.MustHaveThreeTokens
            }
        }
        return isValidMove
    }
    
    func performMove(move: Move) -> Bool {
        fatalError("Computer player does not have AI to implement move")
    }
}