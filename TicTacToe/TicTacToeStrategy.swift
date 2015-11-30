//
//  TicTacToeStrategy.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** Describes an object capable of deciding where to put the next mark on a GameBoard. */
public protocol TicTacToeStrategy {
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: GameBoard.Position -> Void)
}
