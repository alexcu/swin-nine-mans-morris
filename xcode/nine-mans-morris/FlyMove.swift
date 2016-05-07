//
//  FlyMove.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Performs a Place Move on a token with extended logic to fly that token to
/// another position specified if and only if the fly criteria are met.
///
class FlyMove: PlaceMove {
    ///
    /// Override for action to support removal of token from old position
    /// - Remarks: **IMPLEMENTS** Remove token from its current position
    ///
    override func action() {
        self.token?.takeOffBoard() // first take the token off the board
        super.action() // then action it according to place
    }
}
