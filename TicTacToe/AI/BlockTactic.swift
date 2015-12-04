//
//  BlockTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/**
 Tactic #2 in Newell and Simon's strategy.
 If the opponent can play one mark to win, returns the position to block/occupy.
 */
struct BlockTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return WinTactic().chooseWhereToPutMark(mark.opponentMark(), onGameBoard: gameBoard)
    }
}
