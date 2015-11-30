//
//  NewellAndSimonStrategyTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

private struct MockTactic: NewellAndSimonTactic {
    let position: GameBoard.Position?
    
    func chooseWhereToPutMark(_: Mark, onGameBoard _: GameBoard) -> GameBoard.Position? {
        return position
    }
}

private func mockTacticsWithPositions(positions: GameBoard.Position?...) -> [NewellAndSimonTactic] {
    return positions.map { MockTactic(position: $0) }
}

private let
board  = GameBoard(),
center = GameBoard.Position(row: 1, column: 1),
corner = GameBoard.Position(row: 2, column: 2)

class NewellAndSimonStrategyTests: XCTestCase {

    func test_chooseWhereToPutMark_firstTacticReturnsCenter_choosesCenter() {
        let
        expectation = expectationWithDescription("Returns position chosen by first tactic"),
        tactics     = mockTacticsWithPositions(center, nil, corner),
        strategy    = NewellAndSimonStrategy(tactics: tactics)

        strategy.chooseWhereToPutMark(.X, onGameBoard: board) { position in
            XCTAssertTrue(position == center)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func test_chooseWhereToPutMark_middleAndLastReturnsPosition_choosesPositionFromMiddleTactic() {
        let
        expectation = expectationWithDescription("Returns position chosen by middle tactic"),
        tactics     = mockTacticsWithPositions(nil, center, corner),
        strategy    = NewellAndSimonStrategy(tactics: tactics)
        
        strategy.chooseWhereToPutMark(.X, onGameBoard: board) { position in
            XCTAssertTrue(position == center)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func test_chooseWhereToPutMark_onlyLastTacticReturnsPosition_choosesThatPosition() {
        let
        expectation = expectationWithDescription("Returns position chosen by last tactic"),
        tactics     = mockTacticsWithPositions(nil, nil, center),
        strategy    = NewellAndSimonStrategy(tactics: tactics)
        
        strategy.chooseWhereToPutMark(.X, onGameBoard: board) { position in
            XCTAssertTrue(position == center)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
