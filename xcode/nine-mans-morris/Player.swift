//
//  Player.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
            for _ in 0...9 {
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
}

// MARK: Implement extensions to Player for default behaviour

extension Player {
    // Default implementation of tokensOnBoard
    var tokensOnBoard: [Position:Token] {
        let result = [Position:Token]()
        return self.tokens.reduce(result) { memo, token in
            var memo = memo
            // Find the position of this token, if not found continue to next token
            guard let pos = Game.sharedGame.board.findToken(token) else {
                return memo
            }
            memo.updateValue(token, forKey: pos)
            return memo
        }
    }
    
    // Default implementation of countOfTokensOnBoard
    var countOfTokensOnBoard: Int {
        return self.tokensOnBoard.values.count
    }
    
    // Default implementation of hasMill
    var hasMill: Bool {
        for (pos, _) in self.tokensOnBoard {
            let leftOwned   = pos.neighbors.left?.token?.ownedBy(self) ?? false
            let rightOwned  = pos.neighbors.right?.token?.ownedBy(self) ?? false
            let topOwned    = pos.neighbors.top?.token?.ownedBy(self) ?? false
            let bottomOwned = pos.neighbors.bottom?.token?.ownedBy(self) ?? false
            
            // Mill only owned if left and right neighbors or top and bottom 
            // neighbors are owned by this player
            return (leftOwned && rightOwned) || (topOwned && bottomOwned)
        }
        return false
    }
}
