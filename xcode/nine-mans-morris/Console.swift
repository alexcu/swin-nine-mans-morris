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
class Console: OutputWriter, InputReader {
    ///
    /// Shared singleton instance of the console
    ///
    static let sharedInstance = Console()
    
    ///
    /// Writes to the console without a newline
    ///
    private func write(string: String) {
        print(string, separator: "", terminator: "")
    }
    
    // MARK: Implement OutputWriter protocol
    
    // Implementation of `OutputWriter.showAlert`
    func showAlert(message: String) {
        print(message)
    }
    
    // Implementation of `OutputWriter.showBoard`
    func showBoard(board: Board) {
        let size = board.size
        
        write("   ")
        for x in 0...size {
            write(" \(x) ")
        }
        print()
        
        for x in 0...size {
            write(" \(x) ")
            for y in 0...size {
                let pos = board[x,y]
                let posStr = pos == nil ? "---" : "[\(pos?.token?.color.description ?? " ")]"
                write(posStr)
            }
            print()
        }
    }
    
    // MARK: Implement InputReader protocol
    
    // Implementation of `InputReader.prompt`
    func prompt(message: String) -> String? {
        write("\(message): ")
        return readLine()
    }
    
    // Implementation of `InputReader.promptUntil`
    func promptUntil(message: String, condition: (String) -> Bool) -> String {
        var str = self.prompt(message)
        while !condition(str ?? "") {
            str = self.prompt(message)
        }
        return str!
    }
    
    // Implements `InputReader.readCoords`
    func readCoords(prompt: String) -> Position.Label {
        self.showAlert("> \(prompt)")
        let row = Int(Console.sharedInstance.promptUntil("> Enter row") {
            return Int($0) != nil
            })!
        let col = Int(Console.sharedInstance.promptUntil("> Enter col") {
            return Int($0) != nil
            })!
        return (row,col)
    }
    
    // Implements `InputReader.readPlaceMove`
    func readPlaceMove(game: Game) -> PlaceMove {
        let token = game.currentPlayer.tokensNotInitiallyPlaced.first
        let label = readCoords("Where would you like to place the token?")
        return PlaceMove(token: token, position: game.board[label])
    }
    
    // Implements `InputReader.readSlideMove`
    func readSlideMove(game: Game) -> SlideMove {
        let tolab = readCoords("Which token would you like to slide?")
        let token = game.board[tolab]?.token
        let label = readCoords("Where would you like to slide it?")
        return SlideMove(token: token, position: game.board[label])
    }
    
    // Implements `InputReader.readFlyMove`
    func readFlyMove(game: Game) -> FlyMove {
        let tolab = readCoords("Which token would you like to fly?")
        let token = game.board[tolab]?.token
        let label = readCoords("Where would you like to fly it?")
        return FlyMove(token: token, position: game.board[label])
    }
    
    // Implements `InputReader.readTakeMove`
    func readTakeMove(game: Game) -> TakeMove {
        let tolab = readCoords("Which token would you like to take?")
        let token = game.board[tolab]?.token
        return TakeMove(token: token)
    }
    
    // Implements `InputReader.handleInput`
    func handleInput(game: Game) -> Move? {
        ///
        /// Shows a menu
        ///
        func showMenu() {
            self.showAlert("It's \(game.currentPlayer.name)'s (\(game.currentPlayer.color!)) turn!")
            self.showAlert("> [P]lace token")
            self.showAlert("> [S]lide token")
            self.showAlert("> [F]ly   token")
            self.showAlert("> [U]ndo"       )
        }
        ///
        /// Reads in a character from the user to handle the menu
        ///
        func readMenu(input: String) -> Move? {
            switch input {
            case "p": return self.readPlaceMove(game)
            case "s": return self.readSlideMove(game)
            case "f": return self.readFlyMove(game)
            case "u":
                if game.undoLastMove() {
                    self.showAlert("Undone last turn")
                } else {
                    self.showAlert("Can't undo last turn!")
                }
                return nil
            default:
                self.showAlert("Invalid input!")
                return nil
            }
        }
        
        showMenu()
        guard let input = self.prompt("> [?]") else {
            return nil
        }
        return readMenu(input.lowercaseString)
    }
}
