//
//  ScriptedStrategy.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** A mock Tic-tac-toe strategy used for testing. */
final class ScriptedStrategy: TicTacToeStrategy {
    
    init(positions: [GameBoard.Position]) {
        self.positionGenerator = positions.generate()
    }
    
    func chooseWhereToPutMark(_: Mark, onGameBoard _: GameBoard, completionHandler: (position: GameBoard.Position) -> Void) {
        completionHandler(position: positionGenerator.next()!)
    }
    
    private var positionGenerator: IndexingGenerator<[GameBoard.Position]>
}
