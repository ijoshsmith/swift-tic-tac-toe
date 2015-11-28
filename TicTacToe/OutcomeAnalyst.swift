//
//  OutcomeAnalyst.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** Represents the possible victors of a game. */
public enum Winner {
    case PlayerX, PlayerO, Tied
}

/** Information about a finished game. If `winner` is Tied, `winningPositions` will be nil. */
public typealias Outcome = (winner: Winner, winningPositions: [GameBoard.Position]?)

/** Inspects a GameBoard to detect if a player has won, or if both players tied. */
internal final class OutcomeAnalyst {
    
    init(gameBoard: GameBoard) {
        self.gameBoard = gameBoard
    }
    
    func checkForOutcome() -> Outcome?  {
        if let outcome = checkRowsForOutcome() {
            return outcome
        }
        
        if let outcome = checkColumnsForOutcome() {
            return outcome
        }
        
        if let outcome = checkDiagonalsForOutcome() {
            return outcome
        }
        
        if gameBoard.emptyPositions.count == 0 {
            return Outcome(winner: .Tied, winningPositions: nil)
        }
        
        return nil
    }
    
    private let gameBoard: GameBoard
}

// MARK: - Private methods

private extension OutcomeAnalyst {
    func checkRowsForOutcome() -> Outcome? {
        return findOutcomeWithIdentifiers(
            gameBoard.dimensionIndexes,
            marksClosure: gameBoard.marksInRow,
            winningPositionsClosure: gameBoard.positionsForRow)
    }
    
    func checkColumnsForOutcome() -> Outcome? {
        return findOutcomeWithIdentifiers(
            gameBoard.dimensionIndexes,
            marksClosure: gameBoard.marksInColumn,
            winningPositionsClosure: gameBoard.positionsForColumn)
    }
    
    func checkDiagonalsForOutcome() -> Outcome? {
        return findOutcomeWithIdentifiers(
            [.TopLeftToBottomRight, .BottomLeftToTopRight],
            marksClosure: gameBoard.marksInDiagnoal,
            winningPositionsClosure: gameBoard.positionsForDiagonal)
    }
    
    func findOutcomeWithIdentifiers<Identity>(identifiers: [Identity], marksClosure: Identity -> [Mark], winningPositionsClosure: Identity -> [GameBoard.Position]) -> Outcome? {
        for identifier in identifiers {
            let marks = marksClosure(identifier)
            if let winner = winnerFromMarks(marks) {
                let winningPositions = winningPositionsClosure(identifier)
                return Outcome(winner: winner, winningPositions: winningPositions)
            }
        }
        return nil
    }
    
    func winnerFromMarks(marks: [Mark]) -> Winner? {
        if areWinningMarks(marks) {
            let mark = marks.first!
            return (mark == .X) ? Winner.PlayerX : Winner.PlayerO
        }
        return nil
    }
    
    func areWinningMarks(marks: [Mark]) -> Bool {
        let
        uniqueMarks = Set(marks),
        allSameMark = uniqueMarks.count == 1,
        theOnlyMark = uniqueMarks.first
        return allSameMark && theOnlyMark != .Empty
    }
}
