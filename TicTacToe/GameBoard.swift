//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/27/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** The possible states for a position on a GameBoard. */
public enum Mark {
    case Empty, X, O
}

/** 
 Represents the state of a Tic-tac-toe game.
 Each position on the board can be empty or marked.
 A position is identified by zero-based row/column indexes.
 */
public final class GameBoard {
    
    public typealias Position = (row: Int, column: Int)
    
    public enum Diagonal {
        case TopLeftToBottomRight, BottomLeftToTopRight
    }
    
    public init(dimension: Int) {
        assert(dimension >= 3)
        self.dimension = dimension
        
        let emptyRow = [Mark](count: dimension, repeatedValue: .Empty)
        self.marks = [[Mark]](count: dimension, repeatedValue: emptyRow)
    }
    
    public var emptyPositions: [Position] {
        return positions.filter { isEmptyAtPosition($0) }
    }
    
    public func marksInRow(row: Int) -> [Mark] {
        return dimensionIndexes.map { markAtPosition((row, $0)) }
    }
    
    public func marksInColumn(column: Int) -> [Mark] {
        return dimensionIndexes.map { markAtPosition(($0, column)) }
    }
    
    public func marksInDiagnoal(diagonal: Diagonal) -> [Mark] {
        return positionsForDiagnoal(diagonal).map { markAtPosition($0) }
    }
    
    public func putMark(mark: Mark, atPosition position: Position) {
        assertPosition(position)
        assert(isEmptyAtPosition(position))
        assert(mark != .Empty)
        marks[position.row][position.column] = mark
    }
    
    // MARK: - Non-public stored properties
    
    private let dimension: Int
    
    private lazy var dimensionIndexes: [Int] = {
        [Int](0..<self.dimension)
    }()
    
    internal var marks: [[Mark]] // internal for unit test access
    
    private lazy var positions: [Position] = {
        self.dimensionIndexes.flatMap { row -> [Position] in
            let
            rows = [Int](count: self.dimension, repeatedValue: row),
            cols = self.dimensionIndexes
            return Array(zip(rows, cols))
        }
    }()
}

// MARK: - Private methods

private extension GameBoard {
    func assertIndex(index: Int) {
        assert(-1 < index && index < dimension)
    }
    
    func assertPosition(position: Position) {
        assertIndex(position.row)
        assertIndex(position.column)
    }
    
    func isEmptyAtPosition(position: Position) -> Bool {
        return markAtPosition(position) == .Empty
    }
    
    func markAtPosition(position: Position) -> Mark {
        assertPosition(position)
        return marks[position.row][position.column]
    }
    
    func positionsForDiagnoal(diagonal: Diagonal) -> [Position] {
        switch diagonal {
        case .TopLeftToBottomRight: return Array(zip(dimensionIndexes, dimensionIndexes))
        case .BottomLeftToTopRight: return Array(zip(dimensionIndexes.reverse(), dimensionIndexes))
        }
    }
}
