//
//  Game.swift
//  nine-mans-morris
//
//  Created by Alex on 6/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// The game class is responsible for all initialisation and overall control of
/// the game
class Game {
    ///
    /// The game state enum declares the three possible types of game state that
    /// can exist in a game of Nine Man's Morris
    /// - Remarks: *CHANGE 1* Added a new state enum type as this was missing in the
    ///            design
    ///
    enum State {
        ///
        /// Initial game state declares a state in which players can only place
        /// down their tokens. Only until all tokens are placed can the game progress
        /// to the next state
        ///
        case Initial
        ///
        /// Midgame state declares a state which players can play as normal granted
        /// that there are at least three tokens on the board
        ///
        case Midgame
        ///
        /// Endgame state declares a state in which one or more player(s) have only
        /// three tokens left
        ///
        case Endgame
    }

    ///
    /// Declares the current state of the game
    ///
    var currentState: State {
        // Compute the current state according to the game rules:

        // Rule 1.  If a player has not placed their all tokens, then we know that
        //          the game is in its initial game state
        let rule1 = true
        // Rule 2.  If both players have placed all their tokens then the game is 
        //          in the midgame state
        let rule2 = true
        // Rule 3.  If any player has only three tokens left on the board then the
        //          the game is in endgame state
        let rule3 = true

        if rule1 {
            return .Initial
        } else if rule2 {
            return .Midgame
        } else if rule3 {
            return .Endgame
        } else {
            fatalError("Current game state could not be determined!")
        }
    }
    
    ///
    /// Initialiser for a new game
    ///
    init() {

    }
}
