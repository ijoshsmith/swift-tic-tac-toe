//
//  ForkTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/2/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class ForkTacticTests: XCTestCase {

    func test_choosePositionForMark_emptyBoard_returnsNil() {
        XCTAssertNil(ForkTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "   ",
            "   ",
            "   ")))
    }

    func test_choosePositionForMark_cannotFork_returnsNil() {
        XCTAssertNil(ForkTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "XXO",
            "   ",
            " O ")))
    }
    
    func test_choosePositionForMark_canForkTopLeftToBottomRightDiagonalWithMiddleRow_returnsCenterPosition() {
        let position = ForkTactic().choosePositionForMark(.O, onGameBoard: board3x3(
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
    
    func test_choosePositionForMark_canForkBottomLeftToTopRightDiagonalWithMiddleRow_returnsCenterPosition() {
        let position = ForkTactic().choosePositionForMark(.X, onGameBoard: board3x3(
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
    
    func test_choosePositionForMark_canForkTopLeftToBottomRightDiagonalWithMiddleColumn_returnsCenterPosition() {
        let position = ForkTactic().choosePositionForMark(.X, onGameBoard: board3x3(
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
    
    func test_choosePositionForMark_canForkBottomLeftToTopRightDiagonalWithMiddleColumn_returnsCenterPosition() {
        let position = ForkTactic().choosePositionForMark(.X, onGameBoard: board3x3(
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
    
    func test_choosePositionForMark_canForkRowWithColumn_returnsIntersectingPosition() {
        let position = ForkTactic().choosePositionForMark(.X, onGameBoard: board3x3(
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
