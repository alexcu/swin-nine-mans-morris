//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
//

///
/// Players pieces that represent each ‘men’ on the board
///
class Token: Hashable, Equatable {
    ///
    /// Unique identifier of each token
    ///
    private static var id = 0
    
    // MARK: Implement Hashable
    lazy var hashValue: Int = {
        Token.id += 1
        return Token.id
    }()
    
    ///
    /// An enum representing the different colors applicable to tokens
    ///
    enum Color: CustomStringConvertible {
        case Black, White
        // MARK: Implement CustomStringConvertible
        var description: String {
            switch self {
            case .Black:
                return "●"
            case .White:
                return "○"
            }
        }
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
        return self.position != nil
    }
    
    ///
    /// Removes the token off the board
    /// - Returns: `true` iff the token was removed, `false` if position was free
    /// - Remarks: **IMPLEMENTS* "Remove token from the board" and
    ///                          "Remove a token from it's current position"
    ///
    func takeOffBoard() -> Bool {
        return self.position?.removeToken() ?? false
    }
    
    ///
    /// Returns `true` iff the provided player owns this token
    /// - Remarks: **IMPLEMENTS** "Check if a specific token is owned by a specific player"
    ///
    func ownedBy(player: Player) -> Bool {
        return player.color == self.color
    }
    
    ///
    /// Returns the position of this token
    ///
    var position: Position? {
        return Game.sharedGame.board.findToken(self)
    }
    
    ///
    /// Returns whether or not the token has been placed (initially false)
    /// - Remarks: Missing from original behaviours
    ///
    var isPlaced: Bool = false
    
    ///
    /// Returns the player who owns this token
    /// - Remarks: Missing from original behaviours
    ///
    var owningPlayer: Player {
        guard let player = Game.sharedGame.players.filter({self.ownedBy($0)}).first else {
            fatalError("Token must be owned by someone!")
        }
        return player
    }
    
    ///
    /// Returns `true` iff the token is surrounded by tokens
    /// - Remarks: Missing from original behaviours
    ///
    var isSurrounded: Bool {
        return
            self.position?.neighbors.top?.isOccupied    ?? true &&
            self.position?.neighbors.right?.isOccupied  ?? true &&
            self.position?.neighbors.bottom?.isOccupied ?? true &&
            self.position?.neighbors.left?.isOccupied   ?? true
    }
    
    ///
    /// Returns `true` iff the token is part of a mill
    /// - Remarks: **IMPLEMENTS** "Check if a specific token forms part of a mill"
    ///
    var isPartOfMill: Bool {
        // Don't even bother if not on board
        if !self.isOnBoard {
            return false
        }
        
        // Get the owning player of the token
        let owningPlayer = self.owningPlayer
        
        // An annoynmous enum for direction, only ever used in this function
        enum Direction {
            case Top, Right, Bottom, Left
            // Return the neighbor of the token provided in this direction
            func neighbor(token: Token) -> Position? {
                switch self {
                case .Top:      return token.position!.neighbors.top
                case .Right:    return token.position!.neighbors.right
                case .Bottom:   return token.position!.neighbors.bottom
                case .Left:     return token.position!.neighbors.left
                }
            }
        }
        
        // Count the number of tokens I own in the direction provided
        func countOwnedTokens(dir: Direction, _ token: Token, _ count: Int = 0) -> Int {
            let owned = token.ownedBy(owningPlayer) && token != self ? 1 : 0
            guard let neighborToken = dir.neighbor(token)?.token else { return count + owned }
            return count + owned + countOwnedTokens(dir, neighborToken, count)
        }
        
        // Check vertically and horizontally (if there are two owned beside me
        // then I know I have a mill)
        let ownedVertically   = countOwnedTokens(.Bottom, self) + countOwnedTokens(.Top, self) == 2
        let ownedHorizontally = countOwnedTokens(.Left  , self) + countOwnedTokens(.Right, self) == 2
        
        // Mill only owned if left and right neighbors or top and bottom
        // neighbors are owned by this player
        return ownedVertically || ownedHorizontally
    }

    ///
    /// Initialiser for a token, accepting its color
    ///
    init(color: Color) {
        self.color = color
    }
}

func ==(lhs: Token, rhs: Token) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
