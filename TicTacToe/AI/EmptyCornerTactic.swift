//
//  EmptyCornerTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/**
 Tactic #7 in Newell and Simon's strategy.
 If the center position is empty, returns the center position.
 */
struct EmptyCornerTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        let
        cornerPositions = cornerPositionsForGameBoard(gameBoard),
        emptyCorners = gameBoard.emptyPositions.filter { emptyPosition in
            cornerPositions.contains { cornerPosition in
                cornerPosition == emptyPosition
            }
        }
        return emptyCorners.first
    }
    
    private func cornerPositionsForGameBoard(gameBoard: GameBoard) -> [GameBoard.Position] {
        let
        lastIndex   = gameBoard.dimension - 1,
        topLeft     = GameBoard.Position(row: 0,         column: 0),
        topRight    = GameBoard.Position(row: 0,         column: lastIndex),
        bottomLeft  = GameBoard.Position(row: lastIndex, column: 0),
        bottomRight = GameBoard.Position(row: lastIndex, column: lastIndex)
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
}
