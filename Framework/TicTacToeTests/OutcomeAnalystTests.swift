//
//  OutcomeAnalystTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class OutcomeAnalystTests: XCTestCase {

    func test_checkForOutcome_emptyBoard_returnsNil() {
        let board = GameBoard()
        let analyst = OutcomeAnalyst(gameBoard: board)
        XCTAssertNil(analyst.checkForOutcome())
    }
    
    func test_checkForOutcome_noWinnerYet_returnsNil() {
        let board = GameBoard()
        board.marks = [
            [nil, .O,  nil],
            [nil, nil, nil],
            [.X,  .X,  .O ]]
        let analyst = OutcomeAnalyst(gameBoard: board)
        XCTAssertNil(analyst.checkForOutcome())
    }
    
    func test_checkForOutcome_tied_returnsTiedAndNoWinningPositions() {
        let board = GameBoard()
        board.marks = [
            [.O, .X, .O],
            [.X, .X, .O],
            [.O, .O, .X]]
        let analyst = OutcomeAnalyst(gameBoard: board)
        if let outcome = analyst.checkForOutcome() {
            XCTAssertNil(outcome.winner)
            XCTAssertNil(outcome.winningPositions)
        }
        else {
            XCTFail("Tie was not detected.")
        }
    }
    
    func test_checkForOutcome_winningRowForX_returnsRowForPlayerX() {
        let board = GameBoard()
        board.marks = [
            [nil, nil, nil],
            [nil, nil, nil],
            [.X,  .X,  .X ]]
        let analyst = OutcomeAnalyst(gameBoard: board)
        if let outcome = analyst.checkForOutcome() {
            XCTAssertEqual(outcome.winner, Winner.PlayerX)
            
            if let positions = outcome.winningPositions {
                XCTAssertEqual(positions.count, 3)
                XCTAssertTrue(positions[0] == (row: 2, column: 0))
                XCTAssertTrue(positions[1] == (row: 2, column: 1))
                XCTAssertTrue(positions[2] == (row: 2, column: 2))
            }
            else {
                XCTFail("Winning positions are missing.")
            }
        }
        else {
            XCTFail("Winning row was not found.")
        }
    }
    
    func test_checkForOutcome_winningColumnForO_returnsColumnForPlayerO() {
        let board = GameBoard()
        board.marks = [
            [nil, .O, nil],
            [nil, .O, nil],
            [nil, .O, nil]]
        let analyst = OutcomeAnalyst(gameBoard: board)
        if let outcome = analyst.checkForOutcome() {
            XCTAssertEqual(outcome.winner, Winner.PlayerO)
            
            if let positions = outcome.winningPositions {
                XCTAssertEqual(positions.count, 3)
                XCTAssertTrue(positions[0] == (row: 0, column: 1))
                XCTAssertTrue(positions[1] == (row: 1, column: 1))
                XCTAssertTrue(positions[2] == (row: 2, column: 1))
            }
            else {
                XCTFail("Winning positions are missing.")
            }
        }
        else {
            XCTFail("Winning column was not found.")
        }
    }
    
    func test_checkForOutcome_winningTopLeftToBottomRightDiagonalForX_returnsDiagonalForPlayerX() {
        let board = GameBoard()
        board.marks = [
            [.X,  nil, nil],
            [nil, .X,  nil],
            [nil, nil, .X ]]
        let analyst = OutcomeAnalyst(gameBoard: board)
        if let outcome = analyst.checkForOutcome() {
            XCTAssertEqual(outcome.winner, Winner.PlayerX)
            
            if let positions = outcome.winningPositions {
                XCTAssertEqual(positions.count, 3)
                XCTAssertTrue(positions[0] == (row: 0, column: 0))
                XCTAssertTrue(positions[1] == (row: 1, column: 1))
                XCTAssertTrue(positions[2] == (row: 2, column: 2))
            }
            else {
                XCTFail("Winning positions are missing.")
            }
        }
        else {
            XCTFail("Winning diagonal was not found.")
        }
    }
    
    func test_checkForOutcome_winningBottomLeftToTopRightDiagonalForO_returnsDiagonalForPlayerO() {
        let board = GameBoard()
        board.marks = [
            [nil, nil, .O ],
            [nil, .O,  nil],
            [.O,  nil, nil]]
        let analyst = OutcomeAnalyst(gameBoard: board)
        if let outcome = analyst.checkForOutcome() {
            XCTAssertEqual(outcome.winner, Winner.PlayerO)
            
            if let positions = outcome.winningPositions {
                XCTAssertEqual(positions.count, 3)
                XCTAssertTrue(positions[0] == (row: 2, column: 0))
                XCTAssertTrue(positions[1] == (row: 1, column: 1))
                XCTAssertTrue(positions[2] == (row: 0, column: 2))
            }
            else {
                XCTFail("Winning positions are missing.")
            }
        }
        else {
            XCTFail("Winning diagonal was not found.")
        }
    }
}
