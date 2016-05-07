//
//  Token.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Players pieces that represent each ‘men’ on the board
///
struct Token: Hashable, Equatable {
    // MARK: Implement Hashable
    var hashValue: Int {
        return "\(self.position?.label.x ?? -1)\(self.position?.label.y ?? -1)\(self.owningPlayer.color)".hashValue
    }
    
    ///
    /// An enum representing the different colors applicable to tokens
    ///
    enum Color {
        case Black, White
    }
    
    ///
    /// The colour of this token
    /// - Remarks: **IMPLEMENTS* "Get and set the color of a token"
    ///            We shouldn't want to change the color of a token during the
    ///            game so setting a color is only done in the initialiser of
    ///            the class. Hence, this is a `let` statement and synthesises a
    ///            getter method only.
    ///
    let color: Color
    
    ///
    /// Returns `true` iff the token is on the board
    /// - Remarks: **IMPLEMENTS** "Check if a specific token is on the board"
    ///
    var isOnBoard: Bool {
        // Ask the game's board to find this token. If not nil, then we know it
        // is on the board!
        return Game.sharedGame.board.findToken(self) != nil
    }
    
    ///
    /// Removes the token off the board
    /// - Returns: `true` iff the token was removed, `false` if position was free
    /// - Remarks: **IMPLEMENTS* "Remove token from the board" and
    ///                          "Remove a token from it's current position"
    ///
    func takeOffBoard() -> Bool {
        guard var pos = Game.sharedGame.board.findToken(self) else {
            return false
        }
        return pos.removeToken()
    }
    
    ///
    /// Returns `true` iff the provided player owns this token
    /// - Remarks: **IMPLEMENTS** "Check if a specific token is owned by a specific player"
    ///
    func ownedBy(player: Player) -> Bool {
        return Game.sharedGame.players.contains({$0.tokens.contains(self)})
    }
    
    ///
    /// Returns the position of this token
    ///
    var position: Position? {
        return Game.sharedGame.board.findToken(self)
    }
    
    ///
    /// Returns the player who owns this token
    ///
    var owningPlayer: Player {
        guard let player = Game.sharedGame.players.filter({self.ownedBy($0)}).first else {
            fatalError("Token must be owned by someone!")
        }
        return player
    }
    
    ///
    /// Returns `true` iff the token is part of a mill
    /// - Remarks: **IMPLEMENTS** "Check if a specific token forms part of a mill"
    ///
    var partOfMill: Bool {
        // Don't even bother if not on board
        if !self.isOnBoard {
            return false
        }
        let owningPlayer = self.owningPlayer
        let pos = self.position!
        
        let leftOwned   = pos.neighbors.left?.token?.ownedBy(owningPlayer) ?? false
        let rightOwned  = pos.neighbors.right?.token?.ownedBy(owningPlayer) ?? false
        let topOwned    = pos.neighbors.top?.token?.ownedBy(owningPlayer) ?? false
        let bottomOwned = pos.neighbors.bottom?.token?.ownedBy(owningPlayer) ?? false
        
        // Mill only owned if left and right neighbors or top and bottom
        // neighbors are owned by this player
        return (leftOwned && rightOwned) || (topOwned && bottomOwned)
    }
}

func ==(lhs: Token, rhs: Token) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
