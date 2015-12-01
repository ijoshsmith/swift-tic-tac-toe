//
//  BlockTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class BlockTacticTests: XCTestCase {
    
    func test_chooseWhereToPutMark_cannotWin_returnsNil() {
        XCTAssertNil(BlockTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "X O",
            "O X",
            "X  ")))
    }
    
    func test_chooseWhereToPutMark_opponentCanWinInRow_returnsPositionInRow() {
        let position = BlockTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "XX ",
            "O  ",
            "X O"))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 2))
        }
        else {
            XCTFail("Did not detect opponent's winning row.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanWinInColumn_returnsPositionInColumn() {
        let position = BlockTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            " XO",
            "XO ",
            "X  "))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 0))
        }
        else {
            XCTFail("Did not detect opponent's winning column.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanWinInTopLeftToBottomRightDiagonal_returnsPositionInDiagonal() {
        let position = BlockTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "O X",
            "X  ",
            "  O"))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect opponent's winning diagonal.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanWinInBottomLeftToTopRightDiagonal_returnsPositionInDiagonal() {
        let position = BlockTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "X  ",
            "XOO",
            "O X"))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 2))
        }
        else {
            XCTFail("Did not detect winning diagonal.")
        }
    }
}
