//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
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
    /// Returns `true` iff the move provided allows a token to be taken after
    /// it is performed
    /// - Remarks: **CHANGE** Need a way to check if a move has formed a mill and
    ///            if so take a token
    ///
    func checkMoveForTake(move: Move) -> Bool {
        // If the move placed the token in a mill
        return move.token?.isPartOfMill ?? false && move is PlaceMove
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
            // Cannot be fly move or decendents at initial phase
            isValidMove = move is TakeMove || move is PlaceMove && !(move is FlyMove)
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
        // If taking, we must check if we have a mill or take a mill token if opponent
        // has a mill
        if move is TakeMove {
            // Check if player has mill
            isValidMove = isValidMove && Game.sharedGame.currentPlayer.hasMill
            if !isValidMove {
                throw MoveError.NoMill
            }
            // Check if oppenent has mill and taking from mill
            if Game.sharedGame.currentOpponent.hasMill {
                isValidMove = isValidMove && move.token?.isPartOfMill ?? false
                if !isValidMove {
                    throw MoveError.MustTakeMill
                }
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