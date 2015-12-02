//
//  OppositeCornerTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/1/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/**
 Tactic #6 in Newell and Simon's strategy.
 If the opponent is in a corner and the opposite corner (along the diagonal) is empty, returns the opposite corner position.
 */
struct OppositeCornerTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension == 3)
        
        let positions = [.TopLeftToBottomRight, .BottomLeftToTopRight].flatMap {
            choosePositionInDiagonal($0, forMark: mark, gameBoard: gameBoard)
        }
        return positions.isEmpty ? nil : positions.first!
    }
    
    private func choosePositionInDiagonal(diagonal: GameBoard.Diagonal, forMark mark: Mark, gameBoard: GameBoard) -> GameBoard.Position? {
        let
        marks     = gameBoard.marksInDiagonal(diagonal),
        positions = gameBoard.positionsForDiagonal(diagonal),
        (leftMark, rightMark) = (marks[0],     marks[2]),
        (leftPos,  rightPos)  = (positions[0], positions[2])
        
        let opponent = mark.otherMark()
        
        switch (leftMark, rightMark) {
        case (opponent?, nil): return rightPos
        case (nil, opponent?): return leftPos
        default:               return nil
        }
    }
}
