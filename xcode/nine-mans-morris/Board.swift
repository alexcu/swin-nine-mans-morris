//
//  Board.swift
//  nine-mans-morris
//
//  Created by Alex on 6/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A board represents the game's board in a nine man's morris game
///
class Board {
    let positions: [Position] = {
        var positions: [[Position]] = []
        let rows = Array<Int>((1...7))
        let cols = Array<Int>((1...7))

        for row in rows {
            for col in cols {
                let label = (x: col, y: row)
                let neighbors = (
                    positions[col-1][row-1],
                    positions[col-1][row-1],
                    positions[col-1][row-1],
                    positions[col-1][row-1],
                )
                let pos = Position(label: label,
                                   neighbors: <#T##NeighborTuple#>)
            }
        }

        return positions.flatMap({$0})
    }()
}
