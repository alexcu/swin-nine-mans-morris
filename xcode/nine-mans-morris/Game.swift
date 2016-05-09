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
    private(set) var players = [HumanPlayer]()
    
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
    /// Link to an input reader
    ///
    let input: InputReader = Console.sharedInstance
    
    ///
    /// Link to an output writer
    ///
    let output: OutputWriter = Console.sharedInstance
    
    ///
    /// Initialiser for a new game
    ///
    private init() {
        // Set up the rule validator
        self.ruleValidator = PlayerFactory.playerOfType(.Computer) as! ComputerPlayer
        
        output.showAlert("Setting up game...")
        let p1Name = input.prompt("Enter first player's name")
        let p2Name = input.promptUntil("Enter second player's name") {
            $0 != p1Name
        }
        
        let p1 = PlayerFactory.playerOfType(.Human, name: p1Name, isFirst: true) as! HumanPlayer
        let p2 = PlayerFactory.playerOfType(.Human, name: p2Name, isFirst: false) as! HumanPlayer
        
        self.players.append(p1)
        self.players.append(p2)
        
        self.currentPlayer = p1
    }
    
    ///
    /// Checks if the game is over
    /// - Remarks: **IMPLEMENTS**: "Check if game is over"
    ///
    var isGameOver: Bool {
        return self.currentState != .Initial && (self.ruleValidator.playerOutOfMoves != nil || self.ruleValidator.playerOutOfTokens != nil)
    }
    
    ///
    /// Announce winner only announce if game is over
    /// - Remarks: **IMPLEMENTS**: "Announce a winner"
    ///
    func announceWinner() {
        if self.isGameOver {
            let loser = (self.ruleValidator.playerOutOfTokens ?? self.ruleValidator.playerOutOfMoves)! as! HumanPlayer
            let reason = self.ruleValidator.playerOutOfTokens == nil ? "\(loser.name) out of legal moves" : "\(loser.name) out of tokens"
            let winner = self.playerWhoIsnt(loser)
            output.showAlert("\(winner.name) has won - \(reason)")
        }
    }
    
    ///
    /// Returns the player who isn't the player specified
    ///
    func playerWhoIsnt(player: Player) -> HumanPlayer {
        return players.filter({$0.color != currentPlayer.color}).first!
    }
    
    ///
    /// Returns the current opponent
    ///
    var currentOpponent: HumanPlayer {
        // Update the current player to the player who isn't the current player
        return self.playerWhoIsnt(self.currentPlayer)
    }
    
    ///
    /// Switches the current player to the next player
    ///
    func proceedPlayer() {
        self.currentPlayer = self.currentOpponent
    }
    
    ///
    /// Tries to ask the player to perform a move
    /// - Paramater move: The move to perform
    /// - Returns: Whether or not the move was successfully carried out
    ///
    func tryPerformMove(move: Move) -> Bool {
        do {
            try self.currentPlayer.performMove(move)
            return true
        }
        catch let error {
            output.showAlert("Error! \(error)")
            return false
        }
    }
    
    ///
    /// Undoes the current player's turn, if possible
    /// - Returns: `true` if last turn was undone, else `false`
    ///
    func undoLastMove() -> Bool {
        if self.currentPlayer.canUndoLastMove {
            // Undo the current opponent's last move in order to undo current
            // players to get back to a state when the current player just
            // performed their move
            self.currentOpponent.undoLastMove()
            return self.currentPlayer.undoLastMove()
        }
        return false
    }
    
    ///
    /// Plays the game
    /// - Remarks: **IMPLEMENTS**: "Start game"
    ///
    func play() {
        while !self.isGameOver {
            // Show board before each input
            output.showBoard(self.board)

            // Read in the next move
            guard let move = input.handleInput(self) else {
                continue
            }
            
            let success = tryPerformMove(move)
            
            // Can now take after performing this move?
            if ruleValidator.checkMoveForTake(move) {
                // Keep asking while the move was a success
                repeat {
                    output.showAlert("You formed a mill! You may now take an opponent's token!")
                } while !tryPerformMove(input.readTakeMove(self))
            }
        
            // If the move was successful, swap the player
            if success {
                self.proceedPlayer()
            }
        }
        // Announce winner
        announceWinner()
    }
}
