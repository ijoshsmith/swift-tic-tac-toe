//
//  GameBoardTests.swift
//  TicTacToeTests
//
//  Created by Joshua Smith on 11/27/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest
@testable import TicTacToe

class GameBoardTests: XCTestCase {
    
    // MARK: - cloneWithMarkAtPosition
    
    func test_cloneWithMarkAtPosition_emptyBoardAndCenterMark_onlyCloneHasMarkAtCenter() {
        let
        board = GameBoard(),
        clone = board.cloneWithMark(.X, atPosition: (row: 1, column: 1))
        XCTAssertEqual(clone.marks[1][1], Mark.X)
        XCTAssertNil(board.marks[1][1])
    }
    
    func test_cloneWithMarkAtPosition_clonedBoardIsModified_doesNotAffectOriginal() {
        let
        board = GameBoard(),
        clone = board.cloneWithMark(.X, atPosition: (row: 1, column: 1))
        clone.putMark(.X, atPosition: (row: 0, column: 0))
        XCTAssertNil(board.marks[0][0])
    }

    // MARK: - emptyPositions
    
    func test_emptyPositions_twoPositionsAreEmpty_returnsOnlyThoseTwoPositions() {
        let board = GameBoard()
        board.marks = [
            [.X, .O,  nil],
            [.O, .X,  .X ],
            [.O, nil, .O ]]
        let emptyPositions = board.emptyPositions
        XCTAssertEqual(emptyPositions.count, 2)
        XCTAssertTrue(emptyPositions[0] == (row: 0, column: 2))
        XCTAssertTrue(emptyPositions[1] == (row: 2, column: 1))
    }
    
    // MARK: - marksInRow
    
    func test_marksInRow_rowIsEmpty_returnsEmptyRow() {
        let board = GameBoard()
        let marks = board.marksInRow(0)
        XCTAssertNil(marks[0])
        XCTAssertNil(marks[1])
        XCTAssertNil(marks[2])
    }
    
    func test_marksInRow_rowIsXOX_returnsXOX() {
        let board = GameBoard()
        board.marks = [
            [nil, nil, nil],
            [.X,  .O,  .X ],
            [nil, nil, nil]]
        let marks = board.marksInRow(1)
        XCTAssertEqual(marks[0], .X)
        XCTAssertEqual(marks[1], .O)
        XCTAssertEqual(marks[2], .X)
    }
    
    // MARK: - marksInColumn
    
    func test_marksInColumn_columnIsEmpty_returnsEmptyColumn() {
        let board = GameBoard()
        let marks = board.marksInColumn(0)
        XCTAssertNil(marks[0])
        XCTAssertNil(marks[1])
        XCTAssertNil(marks[2])
    }
    
    func test_marksInColumn_columnIsXOX_returnsXOX() {
        let board = GameBoard()
        board.marks = [
            [nil, .X, nil],
            [nil, .O, nil],
            [nil, .X, nil]]
        let marks = board.marksInColumn(1)
        XCTAssertEqual(marks[0], .X)
        XCTAssertEqual(marks[1], .O)
        XCTAssertEqual(marks[2], .X)
    }
    
    // MARK: - marksInDiagonal
    
    func test_marksInDiagonal_topLeftToBottomRightIsEmpty_returnsEmptyDiagonal() {
        let board = GameBoard()
        let marks = board.marksInDiagonal(.TopLeftToBottomRight)
        XCTAssertNil(marks[0])
        XCTAssertNil(marks[1])
        XCTAssertNil(marks[2])
    }
    
    func test_marksInDiagonal_bottomLeftToTopRightIsEmpty_returnsEmptyDiagonal() {
        let board = GameBoard()
        let marks = board.marksInDiagonal(.BottomLeftToTopRight)
        XCTAssertNil(marks[0])
        XCTAssertNil(marks[1])
        XCTAssertNil(marks[2])
    }
    
    func test_marksInDiagonal_topLeftToBottomRightIsXEmptyO_returnsXEmptyO() {
        let board = GameBoard()
        board.marks = [
            [.X,  nil, nil],
            [nil, nil, nil],
            [nil, nil, .O ]]
        let marks = board.marksInDiagonal(.TopLeftToBottomRight)
        XCTAssertEqual(marks[0], .X)
        XCTAssertNil(marks[1])
        XCTAssertEqual(marks[2], .O)
    }
    
    func test_marksInDiagonal_bottomLeftToTopRightIsOXO_returnsOXO() {
        let board = GameBoard()
        board.marks = [
            [nil, nil, .O ],
            [nil, .X,  nil],
            [.O,  nil, nil]]
        let marks = board.marksInDiagonal(.BottomLeftToTopRight)
        XCTAssertEqual(marks[0], .O)
        XCTAssertEqual(marks[1], .X)
        XCTAssertEqual(marks[2], .O)
    }
    
    // MARK: - positionsForRow
    
    func test_positionsForRow_firstRow_returnsCorrectPositions() {
        let board = GameBoard()
        let positions = board.positionsForRow(0)
        XCTAssertEqual(positions.count, 3)
        XCTAssertTrue(positions[0] == (row: 0, column: 0))
        XCTAssertTrue(positions[1] == (row: 0, column: 1))
        XCTAssertTrue(positions[2] == (row: 0, column: 2))
    }
    
    // MARK: - positionsForColumn
    
    func test_positionsForColumn_lastColumn_returnsCorrectPositions() {
        let board = GameBoard()
        let positions = board.positionsForColumn(2)
        XCTAssertEqual(positions.count, 3)
        XCTAssertTrue(positions[0] == (row: 0, column: 2))
        XCTAssertTrue(positions[1] == (row: 1, column: 2))
        XCTAssertTrue(positions[2] == (row: 2, column: 2))
    }
    
    // MARK: - positionsForDiagonal
    
    func test_positionsForDiagonal_topLeftToBottomRight_returnsCorrectPositions() {
        let board = GameBoard()
        let positions = board.positionsForDiagonal(.TopLeftToBottomRight)
        XCTAssertEqual(positions.count, 3)
        XCTAssertTrue(positions[0] == (row: 0, column: 0))
        XCTAssertTrue(positions[1] == (row: 1, column: 1))
        XCTAssertTrue(positions[2] == (row: 2, column: 2))
    }
    
    func test_positionsForDiagonal_bottomLeftToTopRight_returnsCorrectPositions() {
        let board = GameBoard()
        let positions = board.positionsForDiagonal(.BottomLeftToTopRight)
        XCTAssertEqual(positions.count, 3)
        XCTAssertTrue(positions[0] == (row: 2, column: 0))
        XCTAssertTrue(positions[1] == (row: 1, column: 1))
        XCTAssertTrue(positions[2] == (row: 0, column: 2))
    }
    
    // MARK: - putMarkAtPosition
    
    func test_putMarkAtPosition_markX_positionHasX() {
        let board = GameBoard()
        board.putMark(.X, atPosition: (row: 1, column: 2))
        XCTAssertEqual(board.marks[1][2], Mark.X)
    }
    
    func test_putMarkAtPosition_markO_positionHasO() {
        let board = GameBoard()
        board.putMark(.O, atPosition: (row: 1, column: 0))
        XCTAssertEqual(board.marks[1][0], Mark.O)
    }
    
    func test_putMarkAtPosition_markX_onlySpecifiedPositionIsUpdated() {
        let board = GameBoard()
        board.putMark(.X, atPosition: (row: 1, column: 0))
        XCTAssertEqual(board.marks[1][0], Mark.X)
        XCTAssertEqual(board.marks.flatten().filter { $0 == Mark.X }.count, 1)
    }
}
