//
//  SlideMove.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Performs a move that can only move a token to an adjacent and free 
/// position (i.e., slide token across by one position). Essentially a Fly Move
/// with extended logic in which the move must “fly” a token to an adjacent position.
///
class SlideMove: FlyMove {
    ///
    /// Override for validate logic to check if we are moving the token adjacently
    /// - Remarks: **IMPLEMENTS* "Check if a specific token can slide to an adjacent position"
    ///
    override func validateLogic() -> Bool {
        // We call out super validate logic for our superclass Fly and make sure
        // that we are flying to an adjacent position
        return super.validateLogic() && self.token.position!.isAdjacentTo(self.position)
    }
}
