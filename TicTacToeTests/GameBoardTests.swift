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

    // MARK: - emptyPositions
    
    func test_emptyPositions_twoPositionsAreEmpty_returnsOnlyThoseTwoPositions() {
        let board = GameBoard(dimension: 3)
        board.marks = [
            [.X, .O,     .Empty],
            [.O, .X,     .X    ],
            [.O, .Empty, .O    ]]
        let emptyPositions = board.emptyPositions
        XCTAssertEqual(emptyPositions.count, 2)
        XCTAssertEqual(emptyPositions[0].row,    0)
        XCTAssertEqual(emptyPositions[0].column, 2)
        XCTAssertEqual(emptyPositions[1].row,    2)
        XCTAssertEqual(emptyPositions[1].column, 1)
    }
    
    // MARK: - marksInRow
    
    func test_marksInRow_rowIsEmpty_returnsEmptyRow() {
        let board = GameBoard(dimension: 3)
        XCTAssertEqual(board.marksInRow(0), [.Empty, .Empty, .Empty])
    }
    
    func test_marksInRow_rowIsXOX_returnsXOX() {
        let board = GameBoard(dimension: 3)
        board.marks = [
            [.Empty, .Empty, .Empty],
            [.X,     .O,     .X    ],
            [.Empty, .Empty, .Empty]]
        XCTAssertEqual(board.marksInRow(1), [.X, .O, .X])
    }
    
    // MARK: - marksInColumn
    
    func test_marksInColumn_columnIsEmpty_returnsEmptyColumn() {
        let board = GameBoard(dimension: 3)
        XCTAssertEqual(board.marksInColumn(0), [.Empty, .Empty, .Empty])
    }
    
    func test_marksInColumn_columnIsXOX_returnsXOX() {
        let board = GameBoard(dimension: 3)
        board.marks = [
            [.Empty, .X, .Empty],
            [.Empty, .O, .Empty],
            [.Empty, .X, .Empty]]
        XCTAssertEqual(board.marksInColumn(1), [.X, .O, .X])
    }
    
    // MARK: - marksInDiagnoal
    
    func test_marksInDiagnoal_topLeftToBottomRightIsEmpty_returnsAllEmpty() {
        let board = GameBoard(dimension: 3)
        XCTAssertEqual(board.marksInDiagnoal(.TopLeftToBottomRight), [.Empty, .Empty, .Empty])
    }
    
    func test_marksInDiagnoal_bottomLeftToTopRightIsEmpty_returnsAllEmpty() {
        let board = GameBoard(dimension: 3)
        XCTAssertEqual(board.marksInDiagnoal(.BottomLeftToTopRight), [.Empty, .Empty, .Empty])
    }
    
    func test_marksInDiagnoal_topLeftToBottomRightIsXEO_returnsXEO() {
        let board = GameBoard(dimension: 3)
        board.marks = [
            [.X,     .Empty, .Empty],
            [.Empty, .Empty, .Empty],
            [.Empty, .Empty, .O    ]]
        XCTAssertEqual(board.marksInDiagnoal(.TopLeftToBottomRight), [.X, .Empty, .O])
    }
    
    func test_marksInDiagnoal_bottomLeftToTopRightIsOXO_returnsOXO() {
        let board = GameBoard(dimension: 3)
        board.marks = [
            [.Empty, .Empty, .O    ],
            [.Empty, .X,     .Empty],
            [.O,     .Empty, .Empty]]
        XCTAssertEqual(board.marksInDiagnoal(.BottomLeftToTopRight), [.O, .X, .O])
    }
    
    // MARK: - positionsForRow
    
    func test_positionsForRow_firstRow_returnsCorrectPositions() {
        let board = GameBoard(dimension: 3)
        let positions = board.positionsForRow(0)
        XCTAssertEqual(positions.count, 3)
        XCTAssertEqual(positions[0].row, 0)
        XCTAssertEqual(positions[1].row, 0)
        XCTAssertEqual(positions[2].row, 0)
        XCTAssertEqual(positions[0].column, 0)
        XCTAssertEqual(positions[1].column, 1)
        XCTAssertEqual(positions[2].column, 2)
    }
    
    // MARK: - positionsForColumn
    
    func test_positionsForColumn_lastColumn_returnsCorrectPositions() {
        let board = GameBoard(dimension: 3)
        let positions = board.positionsForColumn(2)
        XCTAssertEqual(positions.count, 3)
        XCTAssertEqual(positions[0].row, 0)
        XCTAssertEqual(positions[1].row, 1)
        XCTAssertEqual(positions[2].row, 2)
        XCTAssertEqual(positions[0].column, 2)
        XCTAssertEqual(positions[1].column, 2)
        XCTAssertEqual(positions[2].column, 2)
    }
    
    // MARK: - positionsForDiagonal
    
    func test_positionsForDiagonal_topLeftToBottomRight_returnsCorrectPositions() {
        let board = GameBoard(dimension: 3)
        let positions = board.positionsForDiagonal(.TopLeftToBottomRight)
        XCTAssertEqual(positions.count, 3)
        XCTAssertEqual(positions[0].row, 0)
        XCTAssertEqual(positions[1].row, 1)
        XCTAssertEqual(positions[2].row, 2)
        XCTAssertEqual(positions[0].column, 0)
        XCTAssertEqual(positions[1].column, 1)
        XCTAssertEqual(positions[2].column, 2)
    }
    
    func test_positionsForDiagonal_bottomLeftToTopRight_returnsCorrectPositions() {
        let board = GameBoard(dimension: 3)
        let positions = board.positionsForDiagonal(.BottomLeftToTopRight)
        XCTAssertEqual(positions.count, 3)
        XCTAssertEqual(positions[0].row, 2)
        XCTAssertEqual(positions[1].row, 1)
        XCTAssertEqual(positions[2].row, 0)
        XCTAssertEqual(positions[0].column, 0)
        XCTAssertEqual(positions[1].column, 1)
        XCTAssertEqual(positions[2].column, 2)
    }
    
    // MARK: - putMarkInRowColumn
    
    func test_putMarkInRowColumn_markX_positionHasX() {
        let board = GameBoard(dimension: 3)
        board.putMark(.X, atPosition: (row: 1, column: 2))
        XCTAssertEqual(board.marks[1][2], Mark.X)
    }
    
    func test_putMarkInRowColumn_markO_positionHasO() {
        let board = GameBoard(dimension: 3)
        board.putMark(.O, atPosition: (row: 1, column: 0))
        XCTAssertEqual(board.marks[1][0], Mark.O)
    }
    
    func test_putMarkInRowColumn_markX_onlySpecifiedPositionIsUpdated() {
        let board = GameBoard(dimension: 3)
        board.putMark(.X, atPosition: (row: 1, column: 0))
        XCTAssertEqual(board.marks[1][0], Mark.X)
        XCTAssertEqual(board.marks.flatten().filter { $0 == Mark.X }.count, 1)
    }
}
