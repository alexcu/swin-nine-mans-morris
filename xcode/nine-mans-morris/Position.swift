//
//  Position.swift
//  nine-mans-morris
//
//  Created by Alex on 6/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A position represents an intersection on a nine man's morris board
///
class Position {
    ///
    /// A label typealias is a simple alias to a tuple containing an X and Y
    /// string coordinate
    ///
    typealias Label = (x: String, y: String)

    ///
    /// A typealias to make our tuple of optional neighbours of a position's
    /// neighbors more convienient
    ///
    typealias NeighborTuple = ( top: Position?,
                                right: Position?,
                                bottom: Position?,
                                left: Position?)

    ///
    /// The label of the position
    ///
    let label: Label

    ///
    /// Returns `true` iff this position contains a `Token`
    ///
    var hasToken: Bool {
        return self.token != nil
    }

    ///
    /// The token on this position
    ///
    var token: Token?

    ///
    /// Neighbors for a node
    ///
    let neighbors: NeighborTuple

    ///
    /// Initialiser for a Position
    /// - Paramater label: The label for the position
    /// - Paramaters neighbors: The neighbours for the position
    ///
    init(label: Label, neighbors: NeighborTuple) {
        self.label = label
        self.neighbors = neighbors
    }
}
