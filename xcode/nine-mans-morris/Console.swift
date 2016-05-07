//
//  IO.swift
//  nine-mans-morris
//
//  Created by Alex on 7/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A basic class for all human interaction
/// - Remarks: **CHANGE 2** - 
///            HID class is needed since there is no way to communicate with the human
///            if there is no player class (i.e., need to enter the first name)
///
struct Console {
    ///
    /// Singleton for console
    ///
    static let sharedInstance = Console()
    
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
        
        write("   ")
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
    
    ///
    /// Keep prompting until condition provided is true
    ///
    func promptUntil(message: String, condition: (String) -> Bool) -> String {
        var str = self.prompt(message)
        while !condition(str ?? "") {
            str = self.prompt(message)
        }
        return str!
    }
}
