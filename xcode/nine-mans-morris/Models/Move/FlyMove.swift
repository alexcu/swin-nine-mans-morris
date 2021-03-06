//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
//

///
/// Performs a Place Move on a token with extended logic to fly that token to
/// another position specified if and only if the fly criteria are met.
///
class FlyMove: PlaceMove {
    ///
    /// The original position of the token before it is flown
    /// - Remarks: Missing from original behaviours
    ///
    private let oldPosition: Position?
    
    ///
    /// Override for a fly move that moves a token off the board first
    /// and then places it back to its old position
    ///
    override func undo() {
        self.token?.takeOffBoard()
        self.oldPosition?.token = self.token
    }

    ///
    /// Override for action to support removal of token from old position
    ///
    override func action() {
        self.takeTokenOffBoard() // first take the token off the board
        super.action()           // then action it according to place
    }

    ///
    /// Takes the token off the board
    /// - Remarks: **IMPLEMENTS** Remove token from its current position
    ///
    private func takeTokenOffBoard() {
        self.token?.takeOffBoard()
    }
    
    // Override for init to set the old position of the token
    override init(token: Token?, position: Position?) {
        self.oldPosition = token?.position
        super.init(token: token, position: position)
    }
}
