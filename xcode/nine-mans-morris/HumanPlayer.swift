//
//  HumanPlayer.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Representation of a human player
///
struct HumanPlayer: Player {
    // MARK: Implement Player protocol
    internal(set) var color: Token.Color?
    internal(set) var tokens = [Token]()

    ///
    /// Name of the player
    ///
    let name: String

    ///
    /// Initialises a new human player with a given name
    ///
    internal init(name: String) {
        self.name = name
    }
    
    ///
    /// Displays the board to the human
    ///
    func displayBoard() {
        func write(string: String) {
            print(string, separator: "", terminator: "")
        }
        
        let size = Game.sharedGame.board.size
        
        write(" x,y ")
        for x in 0...size {
            write(" \(x) ")
        }
        print()
        
        for x in 0...size {
            write(" \(x) ")
            for y in 0...size {
                let pos = Game.sharedGame.board[x,y]
                let posStr = pos == nil ? "---" : "[\(pos?.token?.color.description ?? " ")]"
                write(posStr)
            }
            print()
        }
    }
}
