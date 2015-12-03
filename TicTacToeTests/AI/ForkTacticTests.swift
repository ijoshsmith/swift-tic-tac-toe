//
//  ForkTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/2/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class ForkTacticTests: XCTestCase {

    func test_chooseWhereToPutMark_emptyBoard_returnsNil() {
        XCTAssertNil(ForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "   ",
            "   ",
            "   ")))
    }

    func test_chooseWhereToPutMark_cannotFork_returnsNil() {
        XCTAssertNil(ForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "XXO",
            "   ",
            " O ")))
    }
    
    func test_chooseWhereToPutMark_canForkTopLeftToBottomRightDiagonalWithMiddleRow_returnsCenterPosition() {
        let position = ForkTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "O X",
            "O  ",
            "XX "))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect diagonal/row fork.")
        }
    }
    
    func test_chooseWhereToPutMark_canForkBottomLeftToTopRightDiagonalWithMiddleRow_returnsCenterPosition() {
        let position = ForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "O X",
            "  X",
            "  O"))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect diagonal/row fork.")
        }
    }
    
    func test_chooseWhereToPutMark_canForkTopLeftToBottomRightDiagonalWithMiddleColumn_returnsCenterPosition() {
        let position = ForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "   ",
            "  O",
            "OXX"))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect diagonal/column fork.")
        }
    }
    
    func test_chooseWhereToPutMark_canForkBottomLeftToTopRightDiagonalWithMiddleColumn_returnsCenterPosition() {
        let position = ForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "   ",
            "O  ",
            "XXO"))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 1))
        }
        else {
            XCTFail("Did not detect diagonal/column fork.")
        }
    }
    
    func test_chooseWhereToPutMark_canForkRowWithColumn_returnsIntersectingPosition() {
        let position = ForkTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "OX ",
            "  O",
            "  X"))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 1))
        }
        else {
            XCTFail("Did not detect row/column fork.")
        }
    }
}
