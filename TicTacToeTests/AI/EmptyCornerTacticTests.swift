//
//  EmptyCornerTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class EmptyCornerTacticTests: XCTestCase {
    
    func test_choosePositionForMark_noCornersAreEmpty_returnsNil() {
        XCTAssertNil(EmptyCornerTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "X X",
            "   ",
            "X X")))
    }

    func test_choosePositionForMark_topLeftIsEmpty_returnsTopLeft() {
        let position = (EmptyCornerTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "  X",
            "   ",
            "X X")))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 0))
        }
        else {
            XCTFail("Did not detect that the top left corner is empty.")
        }
    }
    
    func test_choosePositionForMark_topRightIsEmpty_returnsTopRight() {
        let position = (EmptyCornerTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "X  ",
            "   ",
            "X X")))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 2))
        }
        else {
            XCTFail("Did not detect that the top right corner is empty.")
        }
    }
    
    func test_choosePositionForMark_bottomRightIsEmpty_returnsBottomRight() {
        let position = (EmptyCornerTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "X X",
            "   ",
            "X  ")))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 2))
        }
        else {
            XCTFail("Did not detect that the bottom right corner is empty.")
        }
    }
    
    func test_choosePositionForMark_bottomLeftIsEmpty_returnsBottomLeft() {
        let position = (EmptyCornerTactic().choosePositionForMark(.X, onGameBoard: board3x3(
            "X X",
            "   ",
            "  X")))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 0))
        }
        else {
            XCTFail("Did not detect that the bottom left corner is empty.")
        }
    }
}
