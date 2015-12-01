//
//  GameBoard+Tactics.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

extension GameBoard {
    /** @return The empty positions in the specified array, in the order they appear in the array. */
    func intersectEmptyPositionsWithPositions(positions: [GameBoard.Position]) -> [GameBoard.Position] {
        let emptyPositions = self.emptyPositions
        return positions.filter { position in
            emptyPositions.contains { emptyPosition in
                position == emptyPosition
            }
        }
    }
}
