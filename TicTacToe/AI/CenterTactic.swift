//
//  CenterTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/**
 Tactic #5 in Newell and Simon's strategy.
 If the center position is empty, returns the center position.
 */
struct CenterTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension == 3)
        
        let
        centerPosition = GameBoard.Position(row: 1, column: 1),
        isCenterEmpty  = gameBoard.emptyPositions.contains { $0 == centerPosition }
        return isCenterEmpty ? centerPosition : nil
    }
}
