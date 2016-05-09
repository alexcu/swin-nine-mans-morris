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
class Position: Hashable {
    // MARK: Implement Hashable
    var hashValue: Int {
        return "\(self.label.row)\(self.label.col)".hashValue
    }
    
    ///
    /// A label typealias is a simple alias to a tuple containing a row and column
    ///
    typealias Label = (row: Int, col: Int)

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
    /// Returns `true` iff this position contains a `Token`
    ///
    var isOccupied: Bool {
        return !self.isFree
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
        let isLeftmost   = self.label.col == 0
        let isRightmost  = self.label.col == Game.sharedGame.board.size
        let isTopmost    = self.label.row == 0
        let isBottommost = self.label.row == Game.sharedGame.board.size
        
        var result: (
            top: Position?,
            right: Position?,
            bottom: Position?,
            left: Position?
        )
        
        func isBeyondCentre(val: Int) -> Bool {
            return val == 3 && self.label.row == 3 && self.label.col == 3
        }
        
        if !isTopmost {
            var i = self.label.row - 1
            // Scan the board to find the leftmost neighbor
            while i >= 0 && result.top == nil {
                let top = Game.sharedGame.board[i,self.label.col]
                i -= 1
                if isBeyondCentre(i) || top == self {
                    break
                } else {
                    result.top = top
                }
            }
        }
        if !isBottommost {
            var i = self.label.row + 1
            // Scan the board to find the rightmost neighbor
            while i <= Game.sharedGame.board.size && result.bottom == nil {
                let bottom = Game.sharedGame.board[i,self.label.col]
                i += 1
                if isBeyondCentre(i) || bottom == self {
                    break
                } else {
                    result.bottom = bottom
                }
            }
        }
        if !isLeftmost {
            var i = self.label.col - 1
            // Scan the board to find the topmost neighbor
            while i >= 0 && result.left == nil {
                let left = Game.sharedGame.board[self.label.row, i]
                i -= 1
                if isBeyondCentre(i) || left == self {
                    break
                } else {
                    result.left = left
                }
            }
        }
        if !isRightmost {
            var i = self.label.col + 1
            // Scan the board to find the rightmost neighbor
            while i <= Game.sharedGame.board.size && result.right == nil {
                let right = Game.sharedGame.board[self.label.row,i]
                i += 1
                if isBeyondCentre(i) || right == self {
                    break
                } else {
                    result.right = right
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
    func removeToken() -> Bool {
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