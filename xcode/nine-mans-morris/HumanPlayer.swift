//
//  HumanPlayer.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A player controlled by a human that is interacting with the game.
/// Also interacts with human via HIDs
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
    /// Writes to the console without a newline
    ///
    private func write(string: String) {
        print(string, separator: "", terminator: "")
    }
    
    ///
    /// Displays an alert to the user
    /// - Remarks: **IMPLEMENTS** "Show alerts to the user"
    ///
    func displayAlert(message: String) {
        print(message)
    }
    
    ///
    /// Gets input from the user with the given question prompted
    /// - Remarks: **IMPLEMENTS** "Recieve input from the user"
    ///
    func prompt(message: String) -> String? {
        write("\(message): ")
        return readLine()
    }
    
    ///
    /// Displays the board to the human
    /// - Remarks: **IMPLEMENTS** "Show the board to user"
    ///
    func displayBoard() {
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
