//
//  WinTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** 
 Tactic #1 in Newell and Simon's strategy.
 If the player can play one mark to win, returns the winning position.
 */
struct WinTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        let desiredWinner = (mark == Mark.X) ? Winner.PlayerX : Winner.PlayerO
        for emptyPosition in gameBoard.emptyPositions {
            let
            possibleBoard  = gameBoard.cloneWithMark(mark, atPosition: emptyPosition),
            outcomeAnalyst = OutcomeAnalyst(gameBoard: possibleBoard)
            if let outcome = outcomeAnalyst.checkForOutcome() where outcome.winner == desiredWinner {
                return emptyPosition
            }
        }
        return nil
    }
}
