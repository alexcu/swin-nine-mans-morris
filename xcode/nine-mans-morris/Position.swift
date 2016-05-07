//
//  Position.swift
//  nine-mans-morris
//
//  Created by Alex on 6/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A position represents an intersection on a nine man's morris board
///
struct Position: Hashable {
    // MARK: Implement Hashable
    var hashValue: Int {
        return "\(self.label.x)\(self.label.y)".hashValue
    }
    
    ///
    /// A label typealias is a simple alias to a tuple containing an X and Y
    /// string coordinate
    ///
    typealias Label = (x: Int, y: Int)

    ///
    /// The label of the position
    /// - Remarks: **IMPLEMENTS** "Read label from a position"
    ///            This is a `let` property; it synthesises a getter
    ///
    let label: Label

    ///
    /// Returns `true` iff this position does not contains a `Token`
    /// - Remarks: **IMPLEMENTS** "Check if a position has a token at all"
    ///
    var isFree: Bool {
        return self.token == nil
    }

    ///
    /// The token on this position
    /// - Remarks: **IMPLEMENTS** "Get and set a specific position's token"
    ///            This is a `var` property; it synthesises a getter and setter
    ///
    var token: Token?

    ///
    /// The neighbors of this position
    /// - Remarks: **IMPLEMENTS** "Get adjacent neighbours from a specific position"
    ///
    var neighbors: (top: Position?, right: Position?, bottom: Position?, left: Position?) {
        let isLeftmost   = self.label.x == 0
        let isRightmost  = self.label.x == Game.sharedGame.board.size
        let isTopmost    = self.label.y == 0
        let isBottommost = self.label.y == Game.sharedGame.board.size
        
        var result: (
            left: Position?,
            right: Position?,
            bottom: Position?,
            top: Position?
        )
        
        func isBeyondCentre(val: Int) -> Bool {
            return val == 3 && self.label.x == 3 && self.label.y == 3
        }
        
        if !isLeftmost {
            var i = self.label.x - 1
            // Scan the board to find the leftmost neighbor
            while i > 0 && result.left == nil {
                let left = Game.sharedGame.board[i, self.label.y]
                i -= 1
                if isBeyondCentre(i) || left == self {
                    break
                } else {
                    result.left = left
                }
            }
        }
        if !isRightmost {
            var i = self.label.x + 1
            // Scan the board to find the rightmost neighbor
            while i < Game.sharedGame.board.size + 1 && result.right == nil {
                let right = Game.sharedGame.board[i, self.label.y]
                i -= 1
                if isBeyondCentre(i) || right == self {
                    break
                } else {
                    result.right = right
                }
            }
        }
        if !isTopmost {
            var i = self.label.y - 1
            // Scan the board to find the topmost neighbor
            while i > 0 && result.top == nil {
                let top = Game.sharedGame.board[self.label.x, i]
                i -= 1
                if isBeyondCentre(i) || top == self {
                    break
                } else {
                    result.top = top
                }
            }
        }
        if !isBottommost {
            var i = self.label.y + 1
            // Scan the board to find the rightmost neighbor
            while i < Game.sharedGame.board.size + 1 && result.bottom == nil {
                let bottom = Game.sharedGame.board[self.label.x, i]
                i -= 1
                if isBeyondCentre(i) || bottom == self {
                    break
                } else {
                    result.bottom = bottom
                }
            }
        }
        
        return result
    }
    
    ///
    /// Initialiser for a Position
    /// - Paramater label: The label for the position
    /// - Paramaters neighbors: The neighbours for the position
    ///
    init(label: Label) {
        self.label = label
    }
    
    ///
    /// Returns `true` iff the token on this position is the `token` provided
    /// - Remarks: **IMPLEMENTS** "Check if position contains specific token"
    ///
    func hasToken(token: Token) -> Bool {
        return self.isFree ? false : token == self.token!
    }
    
    ///
    /// Removes a token from this position
    /// - Returns: `true` iff the token was removed, `false` if position was free
    /// - Remarks: **IMPLEMENTS** "Remove a token off a position"
    ///
    mutating func removeToken() -> Bool {
        if self.isFree {
            return false
        } else {
            self.token = nil
            return true
        }
    }
    
    ///
    /// Checks if the specified position is adjacent to another position
    ///
    func isAdjacentTo(position: Position) -> Bool {
        return
            self.neighbors.top == position ||
            self.neighbors.right == position ||
            self.neighbors.bottom == position ||
            self.neighbors.left == position
    }
}


// MARK: Implement Equatable
func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.hashValue == rhs.hashValue
}