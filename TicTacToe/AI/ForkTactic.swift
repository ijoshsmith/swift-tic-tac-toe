//
//  ForkTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/2/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/**
 Tactic #3 in Newell and Simon's strategy.
 If the player can play one mark to create two ways to win on their next turn, returns that mark's position.
 */
struct ForkTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension == 3)
        
        let
        indexes       = gameBoard.dimensionIndexes,
        diagonals     = GameBoard.Diagonal.allValues(),
        rowInfos      = indexes.map   { Info(marks: gameBoard.marksInRow($0),      positions: gameBoard.positionsForRow($0))      },
        columnInfos   = indexes.map   { Info(marks: gameBoard.marksInColumn($0),   positions: gameBoard.positionsForColumn($0))   },
        diagonalInfos = diagonals.map { Info(marks: gameBoard.marksInDiagonal($0), positions: gameBoard.positionsForDiagonal($0)) }
        
        let
        forkableRowInfos      = rowInfos.filter      { $0.isForkableWithMark(mark) },
        forkableColumnInfos   = columnInfos.filter   { $0.isForkableWithMark(mark) },
        forkableDiagonalInfos = diagonalInfos.filter { $0.isForkableWithMark(mark) }
        
        return findForkPositionWithInfos(forkableRowInfos,    andOtherInfos: forkableColumnInfos  )
            ?? findForkPositionWithInfos(forkableRowInfos,    andOtherInfos: forkableDiagonalInfos)
            ?? findForkPositionWithInfos(forkableColumnInfos, andOtherInfos: forkableDiagonalInfos)
    }
    
    private func findForkPositionWithInfos(infos: [Info], andOtherInfos otherInfos: [Info]) -> GameBoard.Position? {
        return infos
            .flatMap { findForkPositionWithInfo($0, andOtherInfos: otherInfos) }
            .first
    }
    
    private func findForkPositionWithInfo(info: Info, andOtherInfos otherInfos: [Info]) -> GameBoard.Position? {
        return otherInfos
            .filter  { info.markedPosition != $0.markedPosition  }
            .flatMap { info.findIntersectingPositionWithInfo($0) }
            .first
    }
}

private struct Info {
    let marks: [Mark?]
    let positions: [GameBoard.Position]
    
    func isForkableWithMark(mark: Mark) -> Bool {
        let
        nonNilMarks = marks.flatMap { $0 },
        onlyOneMark = nonNilMarks.count == 1,
        isRightMark = nonNilMarks.first == mark
        return onlyOneMark && isRightMark
    }
    
    var markedPosition: GameBoard.Position {
        let markIndex = marks.indexOf { $0 != nil }
        return positions[markIndex!]
    }
    
    func findIntersectingPositionWithInfo(info: Info) -> GameBoard.Position? {
        return positions.filter { info.containsPosition($0) }.first
    }
    
    func containsPosition(position: GameBoard.Position) -> Bool {
        return positions.contains { $0 == position }
    }
}
