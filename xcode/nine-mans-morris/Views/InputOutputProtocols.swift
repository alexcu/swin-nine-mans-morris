//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A3 - Nine Man's Morris
//  Unit:           SWE30003 - SAD
//  Date:           9/05/2016
//

///
/// A protocol for any object that desires to read input from the human
///
protocol InputReader {
    ///
    /// Reads in coordinates from the user, returning a label coordinate
    /// - Paramater prompt: Prompt to ask users when reading coordinates
    /// - Returns: A new label
    ///
    func readCoords(prompt: String) -> Position.Label
    ///
    /// Reads in a place move
    /// - Paramater game: Game to handle input for
    /// - Returns: A new place move
    ///
    func readPlaceMove(game: Game) -> PlaceMove
    ///
    /// Reads in a slide move
    /// - Paramater game: Game to handle input for
    /// - Returns: A new slide move
    ///
    func readSlideMove(game: Game) -> SlideMove
    ///
    /// Reads in a fly move
    /// - Paramater game: Game to handle input for
    /// - Returns: A new fly move
    ///
    func readFlyMove(game: Game) -> FlyMove
    ///
    /// Reads in a take move
    /// - Paramater game: Game to handle input for
    /// - Returns: A new take move
    ///
    func readTakeMove(game: Game) -> TakeMove
    ///
    /// Gets input from the user with the given question prompted
    /// - Paramater prompt: Prompt message
    /// - Returns: String that was read in
    /// - Remarks: **IMPLEMENTS** "Recieve input from the user"
    ///
    func prompt(message: String) -> String?
    ///
    /// Keep prompting until condition provided is true
    /// - Paramater prompt: Prompt message
    /// - Paramater condition: Condition that is to be satisfied until user input is accepted
    /// - Returns: String that was read in
    ///
    func promptUntil(message: String, condition: (String) -> Bool) -> String
    ///
    /// Handles input for the game
    /// - Paramater game: Game to handle input for
    /// - Returns: The next move to be actioned
    ///
    func handleInput(game: Game) -> Move?
}

///
/// A protocol for any object that desires to display output to a user
///
protocol OutputWriter {
    ///
    /// Displays an alert to the user
    /// - Paramater message: Message to be displayed
    /// - Remarks: **IMPLEMENTS** "Show alerts to the user"
    ///
    func showAlert(message: String)
    ///
    /// Displays the board to the human
    /// - Paramater board: Board to show
    /// - Remarks: **IMPLEMENTS** "Show the board to user"
    ///
    func showBoard(board: Board)
}