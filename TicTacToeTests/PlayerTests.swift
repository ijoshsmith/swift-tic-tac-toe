//
//  PlayerTests.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import XCTest

class PlayerTests: XCTestCase {

    // MARK: - choosePositionWithCompletionHandler

    func test_choosePositionWithCompletionHandler_strategyChoosesCenterPosition_choosesCenterPosition() {
        let
        board  = GameBoard(dimension: 3),
        center = GameBoard.Position(row: 1, column: 1),
        script = ScriptedStrategy(positions: [center]),
        player = Player(mark: .X, gameBoard: board, strategy: script)
        
        // Use an expectation to avoid assuming the completion handler is immediately invoked.
        let expectation = expectationWithDescription("Player chooses center position")
        player.choosePositionWithCompletionHandler { position in
            XCTAssertEqual(position.row, center.row)
            XCTAssertEqual(position.column, center.column)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
