//
//  Player.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** Represents a Tic-tac-toe contestant, either human or computer. */
internal final class Player {
    
    init(mark: Mark, gameBoard: GameBoard, strategy: TicTacToeStrategy) {
        self.mark = mark
        self.gameBoard = gameBoard
        self.strategy = strategy
    }
    
    let mark: Mark
    
    func choosePositionWithCompletionHandler(completionHandler: GameBoard.Position -> Void) {
        strategy.chooseWhereToPutMark(mark, onGameBoard: gameBoard, completionHandler: completionHandler)
    }
    
    // MARK: - Non-public stored properties
    
    private let gameBoard: GameBoard
    private let strategy: TicTacToeStrategy
}
