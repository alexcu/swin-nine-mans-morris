//
//  ComputerPlayer.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//


///
/// Representation of a computer player
///
struct ComputerPlayer: Player {
    // MARK: Implement Player protocol
    internal(set) var color: Token.Color?
    internal(set) var tokens = [Token]()
    
    // Prevent construction of computer players externally
    internal init() {
        // computers never active so color is nil
        self.color = nil
    }
}