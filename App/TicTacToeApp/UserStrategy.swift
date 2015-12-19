//
//  UserStrategy.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/19/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation
import TicTacToe

/** A Tic-tac-toe strategy that allows a person to decide where to put marks on a game board. */
final class UserStrategy: TicTacToeStrategy {
    
    func choosePositionForMark(_: Mark, onGameBoard _: GameBoard, completionHandler: GameBoard.Position -> Void) {
        self.reportChosenPositionClosure = completionHandler
    }
    
    func reportChosenPosition(position: GameBoard.Position) {
        if let reportChosenPositionClosure = reportChosenPositionClosure {
            self.reportChosenPositionClosure = nil
            reportChosenPositionClosure(position)
        }
    }
    
    var isWaitingToChoosePosition: Bool {
        return reportChosenPositionClosure != nil
    }
    
    private var reportChosenPositionClosure: (GameBoard.Position -> Void)?
}
