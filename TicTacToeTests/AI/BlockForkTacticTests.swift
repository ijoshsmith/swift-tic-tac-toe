//
//  BlockForkTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/3/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class BlockForkTacticTests: XCTestCase {

    func test_chooseWhereToPutMark_emptyBoard_returnsNil() {
        XCTAssertNil(BlockForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "   ",
            "   ",
            "   ")))
    }
    
    func test_chooseWhereToPutMark_opponentCannotFork_returnsNil() {
        XCTAssertNil(BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "   ",
            "XOX",
            "   ")))
    }
    
    func test_chooseWhereToPutMark_opponentCanForkInTopLeftOrBottomRightCorner_returnsOffensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "  X",
            " O ",
            "X  "))
        if let position = position {
            // Cannot put O in a corner because that would force X to create a fork when blocking it.
            XCTAssertTrue(
                position == (row: 0, column: 1) ||
                position == (row: 1, column: 0) ||
                position == (row: 1, column: 2) ||
                position == (row: 2, column: 1))
        }
        else {
            XCTFail("Did not detect opponent's fork and offensive position.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanForkInBottomLeftOrTopRightCorner_returnsOffensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X  ",
            " O ",
            "  X"))
        if let position = position {
            // Cannot put O in a corner because that would force X to create a fork when blocking it.
            XCTAssertTrue(
                position == (row: 0, column: 1) ||
                position == (row: 1, column: 0) ||
                position == (row: 1, column: 2) ||
                position == (row: 2, column: 1))
        }
        else {
            XCTFail("Did not detect opponent's fork and offensive position.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanForkInMiddleColumnAndBottomRow_returnsOffensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "XO ",
            "  X",
            "O  "))
        if let position = position {
            XCTAssertTrue(
                position == (row: 0, column: 2) ||
                position == (row: 1, column: 1) ||
                position == (row: 2, column: 1))
        }
        else {
            XCTFail("Did not detect opponent's fork and offensive position.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanForkAndPlayerCannotForceOpponentToBlock_returnsDefensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X  ",
            "   ",
            "OX "))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect opponent's fork position.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanForkToTheRightAndPlayerCannotForceOpponentToBlock_returnsDefensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X  ",
            "O  ",
            "X  "))
        if let position = position {
            XCTAssertTrue(
                position == (row: 0, column: 2) ||
                position == (row: 1, column: 1) ||
                position == (row: 2, column: 2))
        }
        else {
            XCTFail("Did not detect opponent's fork position.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanForkBelowAndPlayerCannotForceOpponentToBlock_returnsDefensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "XOX",
            "   ",
            "   "))
        if let position = position {
            XCTAssertTrue(
                position == (row: 1, column: 1) ||
                position == (row: 2, column: 0) ||
                position == (row: 2, column: 2))
        }
        else {
            XCTFail("Did not detect opponent's fork position.")
        }
    }
    
    func test_chooseWhereToPutMark_opponentCanForkInMiddleOfLastRow_returnsOffensivePosition() {
        let position = BlockForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            // Cannot put O in (0, 1) because X would go in (0, 2) to fork.
            // Cannot put O in (1, 0) because X would go in (2, 0) to fork.
            // Cannot put O in (1, 2) because X would go in (2, 0) to fork.
            // Cannot put O in (2, 1) because X would go in (1, 2) or (0, 2) to fork.
            // Must put O in (0, 2) or (2, 0)
            "O  ",
            " X ",
            "  X"))
        if let position = position {
            XCTAssertTrue(
                position == (row: 0, column: 2) ||
                position == (row: 2, column: 0))
        }
        else {
            XCTFail("Did not block opponent's fork position.")
        }
    }
}
