//
//  NewellAndSimonTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** Represents a single aspect of Newell and Simon's Tic-tac-toe strategy. */
protocol NewellAndSimonTactic {
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position?
}
