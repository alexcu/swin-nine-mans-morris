//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
//

///
/// Factory struct to create new players
///
struct PlayerFactory {
    ///
    /// Literal types that can be constructed into concrete Players
    /// - Remarks: Needed for the `playerOfType:` extension method of `Player` to
    ///            implement the Factory Pattern
    ///
    enum PlayerLiteralType {
        case Computer, Human
    }

    ///
    /// Factory method that creates new players of the provided type
    /// - Parameter type: The type of the player to make
    /// - Parameter name: Optional name of the player, ignored if `.Computer`
    /// - Parameter name: Indicates if the player goes first, ignored if `.Computer`
    /// - Remarks: **IMPLEMENTS** "Create player of type"
    ///
    static func playerOfType(type: PlayerLiteralType, name: String? = nil, isFirst: Bool? = nil) -> Player {
        switch type {
        case .Computer:
            return ComputerPlayer()
        case .Human:
            assert(name    != nil, "Human players must be given a name")
            assert(isFirst != nil, "Human players must be told if they go first")
            // White always goes first
            let color: Token.Color = isFirst == true ? .White : .Black
            var player: Player = HumanPlayer(name: name!)
            // Insert all the tokens for this player
            for _ in 1...9 {
                player.tokens.append(Token(color: color))
            }
            player.color = color
            return player
        }
    }
}

///
/// Defines an contractual interface between all concrete players
///
protocol Player {
    ///
    /// Name of the player
    ///
    var name: String { get set }

    ///
    /// The color of the player is a token color type. Set as an optional type as
    /// only active players will have a color.
    /// - Remarks: **IMPLEMENTS** "Get and Set color of player"
    ///
    var color: Token.Color? { get set }

    ///
    /// Set of tokens that the player has
    /// - Remarks: **IMPLEMENTS** "Get and set tokens of player"
    ///
    var tokens: [Token] { get set }
    
    ///
    /// Returns all the tokens that are still on the board and their respective
    /// positions
    /// - Remarks: **IMPLEMENTS** "Get tokens of a player that are still on board"
    ///                       and "Get all positions of a player's tokens"
    ///
    var tokensOnBoard: [Position:Token] { get }

    ///
    /// Returns the count of all tokens left on the board
    /// - Remarks: **IMPLEMENTS** "Get count of all player's tokens still on the board"
    ///
    var countOfTokensOnBoard: Int { get }
    
    ///
    /// Returns `true` iff the player has a mill
    ///
    var hasMill: Bool { get }
    
    ///
    /// Returns `true` iff the player has placed all their tokens
    ///
    var hasPlacedAllTokens: Bool { get }
    
    ///
    /// Perform a move, return `true` if successful
    ///
    func performMove(move: Move) throws -> Bool
    
    ///
    /// Returns the tokens that have not yet been placed on the board
    ///
    var tokensNotInitiallyPlaced: [Token] { get }

    ///
    /// Perform undo of move made by the player
    /// - Remarks: **IMPLEMENTS** "Undo last move made"
    ///
    mutating func undoLastMove() -> Bool

    ///
    /// Checks if the player can undo the last turn
    ///
    var canUndoLastMove: Bool { get }

    ///
    /// Last moves made by the player
    /// - Remarks: **IMPLEMENTS** "Get, set and clear the last move that was made"
    ///
    var lastMoves: Stack<Move> { get set }
}

// MARK: Implement extensions to Player for default behaviour

extension Player {
    // Default implementation of tokensOnBoard
    var tokensOnBoard: [Position:Token] {
        return self.tokens.reduce([Position:Token]()) { dict, tok in
            var dict = dict
            if let pos = tok.position {
                dict.updateValue(tok, forKey: pos)
            }
            return dict
        }
    }
    
    // Default implementation of tokensNotInitiallyPlaced
    var tokensNotInitiallyPlaced: [Token] {
        return self.tokens.filter({!$0.isPlaced})
    }
    
    // Default implementation of countOfTokensOnBoard
    var countOfTokensOnBoard: Int {
        return self.tokensOnBoard.values.count
    }
    
    // Default implementation of hasMill
    var hasMill: Bool {
        return self.tokens.contains({$0.isPartOfMill})
    }
    
    // Default implementation of hasPlacedAllTokens
    var hasPlacedAllTokens: Bool {
        return self.tokensNotInitiallyPlaced.isEmpty
    }

    // Default implementation of undoLastMove
    mutating func undoLastMove() -> Bool {
        if let lastMove = self.lastMoves.pop() {
            // If the last move was a take move, we need to pop again to also undo
            // the move that allowed the token to be taken in the first place
            lastMove.undo()
            if lastMove is TakeMove {
                self.lastMoves.pop()!.undo()
            }
            return true
        } else {
            return false
        }
    }

    // Default implementation of canUndoLastMove
    var canUndoLastMove: Bool {
        return !self.lastMoves.isEmpty
    }
}
