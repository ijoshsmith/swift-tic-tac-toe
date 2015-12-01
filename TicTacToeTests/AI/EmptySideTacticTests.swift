//
//  EmptySideTacticTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/1/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class EmptySideTacticTests: XCTestCase {

    func test_chooseWhereToPutMark_noSidesAreEmpty_returnsNil() {
        XCTAssertNil(EmptySideTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            " X ",
            "X X",
            " X ")))
    }
    
    func test_chooseWhereToPutMark_topIsEmpty_returnsTop() {
        let position = (EmptySideTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            "   ",
            "X X",
            " X ")))
        if let position = position {
            XCTAssertTrue(position == (row: 0, column: 1))
        }
        else {
            XCTFail("Did not detect that the top is empty.")
        }
    }
    
    func test_chooseWhereToPutMark_rightIsEmpty_returnsRight() {
        let position = (EmptySideTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            " X ",
            "X  ",
            " X ")))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 2))
        }
        else {
            XCTFail("Did not detect that the right is empty.")
        }
    }
    
    func test_chooseWhereToPutMark_bottomIsEmpty_returnsBottom() {
        let position = (EmptySideTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            " X ",
            "X X",
            "   ")))
        if let position = position {
            XCTAssertTrue(position == (row: 2, column: 1))
        }
        else {
            XCTFail("Did not detect that the bottom is empty.")
        }
    }
    
    func test_chooseWhereToPutMark_leftIsEmpty_returnsLeft() {
        let position = (EmptySideTactic().chooseWhereToPutMark(.X, onGameBoard: board3x3(
            " X ",
            "  X",
            " X ")))
        if let position = position {
            XCTAssertTrue(position == (row: 1, column: 0))
        }
        else {
            XCTFail("Did not detect that the left is empty.")
        }
    }
}
