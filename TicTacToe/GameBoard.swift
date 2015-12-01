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

public func == (position1: GameBoard.Position, position2: GameBoard.Position) -> Bool {
    return (position1.row == position2.row) && (position1.column == position2.column)
}

public func != (position1: GameBoard.Position, position2: GameBoard.Position) -> Bool {
    return !(position1 == position2)
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
    
    public convenience init(dimension: Int = 3) {
        assert(dimension >= 3)
        
        let
        emptyRow = [Mark](count: dimension, repeatedValue: .Empty),
        marks = [[Mark]](count: dimension, repeatedValue: emptyRow)
        
        self.init(dimension: dimension, marks: marks)
    }
    
    private init(dimension: Int, marks: [[Mark]]) {
        self.dimension = dimension
        self.dimensionIndexes = [Int](0..<dimension)
        self.marks = marks
    }
    
    public let dimension: Int
    
    public let dimensionIndexes: [Int]
    
    public var emptyPositions: [Position] {
        return positions.filter(isEmptyAtPosition)
    }
    
    public func marksInRow(row: Int) -> [Mark] {
        return positionsForRow(row).map(markAtPosition)
    }
    
    public func marksInColumn(column: Int) -> [Mark] {
        return positionsForColumn(column).map(markAtPosition)
    }
    
    public func marksInDiagonal(diagonal: Diagonal) -> [Mark] {
        return positionsForDiagonal(diagonal).map(markAtPosition)
    }
    
    // MARK: - Non-public stored properties
    
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

// MARK: - Internal methods

internal extension GameBoard {
    func cloneWithMark(mark: Mark, atPosition position: Position) -> GameBoard {
        let clone = GameBoard(dimension: dimension, marks: [[Mark]](marks))
        clone.putMark(mark, atPosition: position)
        return clone
    }
    
    func positionsForRow(row: Int) -> [Position] {
        return dimensionIndexes.map { (row: row, column: $0) }
    }
    
    func positionsForColumn(column: Int) -> [Position] {
        return dimensionIndexes.map { (row: $0, column: column) }
    }
    
    func positionsForDiagonal(diagonal: Diagonal) -> [Position] {
        let rows = dimensionIndexes, columns = dimensionIndexes
        switch diagonal {
        case .TopLeftToBottomRight: return Array(zip(rows, columns))
        case .BottomLeftToTopRight: return Array(zip(rows.reverse(), columns))
        }
    }
    
    func putMark(mark: Mark, atPosition position: Position) {
        assertPosition(position)
        assert(isEmptyAtPosition(position))
        assert(mark != .Empty)
        marks[position.row][position.column] = mark
    }
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
}
