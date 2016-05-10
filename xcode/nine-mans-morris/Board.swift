//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           6/05/2016
//

///
/// A board represents the game's board in a nine man's morris game
///
class Board {
    ///
    /// The size of the board (0-based)
    ///
    let size = 6
    
    ///
    /// Bits representing if a position can exist at the given row (key)
    /// and column (value)
    /// - Remarks: *CHANGE 2* Too hard to implement neighbors for a position whilst
    ///            creating the position. Would require a public readwrite property
    ///            of neighbors, which is unsafe. This is a good workaround.
    ///
    private let positionBits: [Int:Int]

    ///
    /// Positions on the board
    ///
    private(set) var positions: [Position]
    
    ///
    /// Returns `true` iff there is a position at the coordinates specified at
    /// `row` and `col`
    ///
    func validPosition(row row: Int, col: Int) -> Bool {
        return self.positionBits[row]?.nthBit(col) == 1
    }
    
    ///
    /// Finds the position on the board at the given coordinates
    /// - Paramater row: The row number
    /// - Paramater col: The column number
    /// - Remarks: **IMPLEMENTS** "Get positions"
    /// - Returns: The position at the coordinate or `nil` if the position was
    ///            invalid
    ///
    func positionAt(row row:Int, col: Int) -> Position? {
        // Find iff the label specified is valid
        if self.validPosition(row: row, col: col) {
            // Find the position in my positions whose label matches the x and y
            // coordinates specified
            return self.positions.filter({$0.label == (row,col)}).first
        } else {
            return nil
        }
    }
    
    ///
    /// Alias for `positionAt`
    ///
    subscript(label: Position.Label) -> Position? {
        return self[label.row, label.col]
    }
    
    ///
    /// Finds the position of the specified token
    /// - Paramaters token: The token to find
    /// - Returns: A position if found, otherwise `nil`
    /// - Remarks: **IMPLEMENTS** "Locate a specific token's position"
    ///
    func findToken(token: Token) -> Position? {
        return self.positions.filter({$0.hasToken(token)}).first
    }
    
    ///
    /// Subscript function allows us to find the position at the given coordinates
    /// in a more convienent fashion
    ///
    subscript(row: Int, col: Int) -> Position? {
        return self.positionAt(row: row, col: col)
    }
    
    ///
    /// Checks if position at the specified coordinates is free
    /// - Remarks: Where the position provided is invalid, default to `false`
    /// - Remarks: **IMPLEMENTS** "Check if specified position is free"
    ///
    func isFreeAt(row row: Int, col: Int) -> Bool {
        return self[row,col]?.isFree ?? false
    }
    
    ///
    /// Constructor for a board
    ///
    init() {
        self.positions = [Position]()
        ///
        /// Initialises the position bits
        ///
        func createPositionBits() -> [Int:Int]  {
            // Generate a sequence from 0 to 6 and use bit-wise logic
            // to determine if this row should have a position or not
            let rows = Array<Int>((0...6))
            let cols = Array<Int>((0...6))
            var bitLogic = [Int:Int]() // row:col
            for row in rows {
                for _ in cols {
                    var bits: Int = 0
                    if row % 6 == 0 {
                        bits = 0b1001001
                    } else if 5 % row == 0 {
                        bits = 0b0101010
                    } else if row % 2 == 0 {
                        bits = 0b0011100
                    } else if row % 3 == 0 {
                        bits = 0b1110111
                    } else {
                        assertionFailure("Board creation logic cannot fail")
                    }
                    bitLogic[row] = bits
                }
            }
            return bitLogic
        }
        
        ///
        /// Creates new positions
        /// - Remarks: *IMPLEMENTS* "Create new positions":
        ///
        func createPositions() -> [Position] {
            let cols = Array<Int>((0...6))
            let rows = Array<Int>((0...6))
            var positions = [Position]()
            
            for row in rows {
                for col in cols {
                    if self.validPosition(row: row, col: col) {
                        // Create the new position
                        let pos = Position(label: (row, col))
                        positions.append(pos)
                    }
                }
            }
            
            return positions
        }
        // Call the creations of the position (bits) in the constructor
        self.positionBits = createPositionBits()
        self.positions = createPositions()
    }
}
