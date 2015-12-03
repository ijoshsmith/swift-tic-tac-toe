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
    case PlayerX, PlayerO
    
    static func fromMark(mark: Mark) -> Winner {
        switch mark {
        case .X: return .PlayerX
        case .O: return .PlayerO
        }
    }
}

/** Information about a finished game. If `winner` and `winningPositions` are nil, the game was tied. */
public typealias Outcome = (winner: Winner?, winningPositions: [GameBoard.Position]?)

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
            return Outcome(winner: nil, winningPositions: nil)
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
            GameBoard.Diagonal.allValues(),
            marksClosure: gameBoard.marksInDiagonal,
            winningPositionsClosure: gameBoard.positionsForDiagonal)
    }
    
    func findOutcomeWithIdentifiers<Identity>(identifiers: [Identity], marksClosure: Identity -> [Mark?], winningPositionsClosure: Identity -> [GameBoard.Position]) -> Outcome? {
        for identifier in identifiers {
            let marks = marksClosure(identifier)
            if let winner = winnerFromMarks(marks) {
                let winningPositions = winningPositionsClosure(identifier)
                return Outcome(winner: winner, winningPositions: winningPositions)
            }
        }
        return nil
    }
    
    func winnerFromMarks(marks: [Mark?]) -> Winner? {
        if let mark = marks.first! where areWinningMarks(marks) {
            return Winner.fromMark(mark)
        }
        return nil
    }
    
    func areWinningMarks(marks: [Mark?]) -> Bool {
        let
        validMarks  = marks.flatMap { $0 }, // remove nil elements
        areAllValid = validMarks.count == marks.count,
        areSameMark = Set(validMarks).count == 1
        return areAllValid && areSameMark
    }
}
