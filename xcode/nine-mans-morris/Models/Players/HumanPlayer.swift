//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
//

///
/// A player controlled by a human that is interacting with the game.
/// - Remarks: Behaviours moved to Player protocol 
///
class HumanPlayer: Player {
    // MARK: Implement Player protocol
    internal(set) var color: Token.Color?
    internal(set) var tokens = [Token]()
    internal(set) var name: String
    internal(set) var lastMoves = Stack<Move>()

    ///
    /// Initialises a new human player with a given name
    ///
    internal init(name: String) {
        self.name = name
    }

    ///
    /// Performs a move on the player
    ///
    func performMove(move: Move) throws -> Bool {
        if try move.perform() {
            // Set the player's last move to this
            self.lastMoves.push(move)
            return true
        }
        return false
    }
}
