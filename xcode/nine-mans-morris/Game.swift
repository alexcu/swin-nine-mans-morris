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
    /// The singleton game instance
    ///
    static let sharedGame = Game()
    
    ///
    /// Reference to the game's board
    /// - Remarks: **IMPLEMENTS** "Set up board"
    ///
    let board = Board()
    
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
    /// Declares the current state of the game according to the three rules:
    ///
    /// 1.  If a player has not placed their all tokens, then we know that
    ///     the game is in its initial game state
    /// 2.  If both players have placed all their tokens then the game is
    ///     in the midgame state
    /// 3.  If any player has only three tokens left on the board then the
    ///     the game is in endgame state
    ///
    var currentState: State {
        for player in players {
            // Rule 1 applies when there is at least one token not yet placed
            if !self.currentPlayer.hasPlacedAllTokens {
                return .Initial
            }
            // Rule 3 applies
            if player.countOfTokensOnBoard == 3 {
                return .Endgame
            }
        }
        // Else Rule 2 applies
        return .Midgame
    }
    
    ///
    /// Players playing the game
    ///
    private(set) var players = [Player]()
    
    ///
    /// Rule validator
    ///
    let ruleValidator: ComputerPlayer

    ///
    /// The current player
    /// - Remarks: **IMPLEMENTS**: "Check if it is a specified player's turn" and
    ///                            "Set and get the current player"
    ///
    var currentPlayer: HumanPlayer
    
    ///
    /// Initialiser for a new game
    ///
    private init() {
        // Set up the rule validator
        self.ruleValidator = PlayerFactory.playerOfType(.Computer) as! ComputerPlayer
        Console.sharedInstance.displayAlert("Setting up game...")
        let p1Name = Console.sharedInstance.prompt("Enter first player's name")
        let p2Name = Console.sharedInstance.promptUntil("Enter second player's name") {
            $0 != p1Name
        }
        
        let p1 = PlayerFactory.playerOfType(.Human, name: p1Name, isFirst: true)
        let p2 = PlayerFactory.playerOfType(.Human, name: p2Name, isFirst: false)
        
        self.players.append(p1)
        self.players.append(p2)
        
        self.currentPlayer = p1 as! HumanPlayer
    }
    
    ///
    /// Checks if the game is over
    /// - Remarks: **IMPLEMENTS**: "Check if game is over"
    ///
    var isGameOver: Bool {
        return self.currentState != .Initial && (self.ruleValidator.playerOutOfMoves != nil || self.ruleValidator.playerOutOfTokens != nil)
    }
    
    ///
    /// Plays the game
    /// - Remarks: **IMPLEMENTS**: "Start game", "Announce a winner"
    ///
    func play() {
        func readCoords(prompt: String) -> Position.Label {
            Console.sharedInstance.displayAlert("> \(prompt)")
            let row = Int(Console.sharedInstance.promptUntil("> Enter row") {
                return Int($0) != nil
                })!
            let col = Int(Console.sharedInstance.promptUntil("> Enter col") {
                return Int($0) != nil
            })!
            return (row,col)
        }
        func placeMove() -> PlaceMove {
            let token = self.currentPlayer.tokens.filter({!$0.isPlaced}).first
            let label = readCoords("Where would you like to place the token?")
            return PlaceMove(token: token, position: self.board[label])
        }
        func slideMove() -> SlideMove {
            let tolab = readCoords("Which token would you like to slide?")
            let token = self.board[tolab]?.token
            let label = readCoords("Where would you like to slide it?")
            return SlideMove(token: token, position: self.board[label])
        }
        func flyMove() -> FlyMove {
            let tolab = readCoords("Which token would you like to fly?")
            let token = self.board[tolab]?.token
            let label = readCoords("Where would you like to fly it?")
            return FlyMove(token: token, position: self.board[label])
        }
        func takeMove() -> TakeMove {
            let tolab = readCoords("Which token would you like to take?")
            let token = self.board[tolab]?.token
            return TakeMove(token: token)
        }
        func handleInput(input: String?) -> Bool {
            Console.sharedInstance.displayBoard()
            guard let input = input?.lowercaseString else {
                return false
            }
            var move: Move? = nil
            switch input {
                case "p": move = placeMove()
                case "s": move = slideMove()
                case "t": move = takeMove()
                case "f": move = flyMove()
                default:
                    Console.sharedInstance.displayAlert("Invalid entry!")
                    return false
            }
            if let move = move where !self.currentPlayer.performMove(move) {
                Console.sharedInstance.displayAlert("Cannot perform that move!")
                return false
            } else {
                Console.sharedInstance.displayBoard()
            }
            return true
        }
        while !self.isGameOver {
            Console.sharedInstance.displayAlert("It's \(self.currentPlayer.name)'s (\(self.currentPlayer.color!)) turn!")
            Console.sharedInstance.displayAlert("> [P]lace token")
            Console.sharedInstance.displayAlert("> [S]lide token")
            Console.sharedInstance.displayAlert("> [F]ly   token")
            Console.sharedInstance.displayAlert("> [T]ake  token")
            if handleInput(Console.sharedInstance.prompt("> [?]")) {
                currentPlayer = players.filter({$0.color != currentPlayer.color}).first! as! HumanPlayer
            }
        }
    }
}
