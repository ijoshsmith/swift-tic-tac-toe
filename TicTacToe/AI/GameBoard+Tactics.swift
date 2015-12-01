//
//  GameBoard+Tactics.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

extension GameBoard {
    /** @return The empty positions in the specified array. */
    func intersectEmptyPositionsWithPositions(positions: [GameBoard.Position]) -> [GameBoard.Position] {
        return emptyPositions.filter { emptyPosition in
            positions.contains { position in
                position == emptyPosition
            }
        }
    }
}
