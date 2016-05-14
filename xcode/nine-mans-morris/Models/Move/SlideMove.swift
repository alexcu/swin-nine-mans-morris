//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           7/05/2016
//

///
/// Performs a move that can only move a token to an adjacent and free 
/// position (i.e., slide token across by one position). Essentially a Fly Move
/// with extended logic in which the move must “fly” a token to an adjacent position.
///
class SlideMove: FlyMove {
    ///
    /// Returns `true` iff the token to be moved is being moved to an adjacent
    /// position
    /// - Remarks: **IMPLEMENTS* "Check if a specific token can slide to an adjacent position"
    ///
    private var movingToAdjacent: Bool {
        return self.token?.position!.isAdjacentTo(self.position!) ?? false
    }
    
    ///
    /// Override for validate logic to check if we are moving the token adjacently
    ///
    override internal func validateLogic() throws -> Bool {
        // We call out super validate logic for our superclass Fly and make sure
        // that we are flying to an adjacent position
        let superOk = try super.validateLogic()
        if !self.movingToAdjacent {
            throw MoveError.CanOnlySlideToAdjacent
        }
        return superOk
    }
}
