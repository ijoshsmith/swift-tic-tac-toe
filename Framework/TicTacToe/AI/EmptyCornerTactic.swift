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
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        let
        allCorners   = cornerPositionsForGameBoard(gameBoard),
        emptyCorners = allCorners.filter(gameBoard.isEmptyAtPosition)
        return emptyCorners.first
    }
    
    private func cornerPositionsForGameBoard(gameBoard: GameBoard) -> [GameBoard.Position] {
        assert(gameBoard.dimension == 3)
        
        let
        topLeft     = GameBoard.Position(row: 0, column: 0),
        topRight    = GameBoard.Position(row: 0, column: 2),
        bottomRight = GameBoard.Position(row: 2, column: 2),
        bottomLeft  = GameBoard.Position(row: 2, column: 0)
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
}
