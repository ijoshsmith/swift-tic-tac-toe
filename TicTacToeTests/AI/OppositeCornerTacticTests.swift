//
//  OppositeCornerTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/1/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class OppositeCornerTacticTests: XCTestCase {

    func test_chooseWhereToPutMark_allCornersAreEmpty_returnsNil() {
        XCTAssertNil(OppositeCornerTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "   ",
            "   ",
            "   ")))
    }
    
    func test_chooseWhereToPutMark_allCornersAreMarked_returnsNil() {
        XCTAssertNil(OppositeCornerTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X X",
            "   ",
            "X X")))
    }
    
    func test_chooseWhereToPutMark_topLeftIsMarkedAndBottomRightIsEmpty_returnsBottomRight() {
        let position = (OppositeCornerTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X X",
            "   ",
            "X  ")))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 2))
        }
        else {
            XCTFail("Did not detect that the bottom right corner should be marked.")
        }
    }
    
    func test_chooseWhereToPutMark_topRightIsMarkedAndBottomLeftIsEmpty_returnsBottomLeft() {
        let position = (OppositeCornerTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X X",
            "   ",
            "  X")))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 0))
        }
        else {
            XCTFail("Did not detect that the bottom left corner should be marked.")
        }
    }
    
    func test_chooseWhereToPutMark_bottomRightIsMarkedAndTopLeftIsEmpty_returnsTopLeft() {
        let position = (OppositeCornerTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "  X",
            "   ",
            "X X")))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 0))
        }
        else {
            XCTFail("Did not detect that the top left corner should be marked.")
        }
    }
    
    func test_chooseWhereToPutMark_bottomLeftIsMarkedAndTopRightIsEmpty_returnsTopRight() {
        let position = (OppositeCornerTactic().chooseWhereToPutMark(.O, onGameBoard: board3x3(
            "X  ",
            "   ",
            "X X")))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 2))
        }
        else {
            XCTFail("Did not detect that the top right corner should be marked.")
        }
    }
}
