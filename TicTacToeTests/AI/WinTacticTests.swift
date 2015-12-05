//
//  WinTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class WinTacticTests: XCTestCase {
    
    func test_choosePositionForMark_cannotWin_returnsNil() {
        XCTAssertNil(WinTactic().choosePositionForMark(.O, onGameBoard: board3x3(
            "X O",
            "O X",
            "X  ")))
    }
    
    func test_choosePositionForMark_rowCanWin_returnsPositionInRow() {
        let position = WinTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "XX ",
            "O  ",
            "X O"))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 2))
        }
        else {
            XCTFail("Did not detect winning row.")
        }
    }
    
    func test_choosePositionForMark_columnCanWin_returnsPositionInColumn() {
        let position = WinTactic().choosePositionForMark(.O, onGameBoard: board3x3(
            "XOX",
            " O ",
            "X  "))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 1))
        }
        else {
            XCTFail("Did not detect winning column.")
        }
    }
    
    func test_choosePositionForMark_topLeftToBottomRightDiagonalCanWin_returnsPositionInDiagonal() {
        let position = WinTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "XXO",
            "O  ",
            "  X"))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect winning diagonal.")
        }
    }
    
    func test_choosePositionForMark_bottomLeftToTopRightDiagonalCanWin_returnsPositionInDiagonal() {
        let position = WinTactic().choosePositionForMark(.O, onGameBoard: board3x3(
            "X  ",
            "XO ",
            "O X"))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 2))
        }
        else {
            XCTFail("Did not detect winning diagonal.")
        }
    }
    
    func test_choosePositionForMark_onlyOtherPlayerCanWin_returnsNil() {
        XCTAssertNil(WinTactic().choosePositionForMark(.O, onGameBoard: board3x3(
            "XX ",
            "X O",
            "O  ")))
    }
    
    func test_choosePositionForMark_bothPlayersCanWin_returnsPositionForCorrectPlayer() {
        let position = WinTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "OO ",
            " XX",
            "   "))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 0))
        }
        else {
            XCTFail("Did not detect correct winning row.")
        }
    }
}
