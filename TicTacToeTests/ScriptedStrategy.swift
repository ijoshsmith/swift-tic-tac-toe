//
//  ScriptedStrategy.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** A mock Tic-tac-toe strategy used for testing. */
final class ScriptedStrategy {
    
    /** Creates a scripted strategy for both players, based on a 3x3 pictographic game board representation. */
    static func strategiesFrom3x3TextDiagram(textDiagram: String) -> (xStrategy: ScriptedStrategy, oStrategy: ScriptedStrategy) {
        assert(textDiagram.characters.count == 9)
        
        var xPositions = Array<GameBoard.Position>(), oPositions = Array<GameBoard.Position>()
        
        let uppercaseSymbols = textDiagram.characters.map { String($0).uppercaseString }
        for (index, symbol) in uppercaseSymbols.enumerate() {
            let position = GameBoard.Position(row: index / 3, column: index % 3)
            switch symbol {
            case "X": xPositions.append(position)
            case "O": oPositions.append(position)
            default:  break
            }
        }

        return (ScriptedStrategy(positions: xPositions), ScriptedStrategy(positions: oPositions))
    }
    
    init(positions: [GameBoard.Position]) {
        self.positionGenerator = positions.generate()
    }
    
    var isFinished: Bool {
        return positionGenerator.next() == nil
    }
    
    private var positionGenerator: IndexingGenerator<[GameBoard.Position]>
}

extension ScriptedStrategy: TicTacToeStrategy {
    func chooseWhereToPutMark(_: Mark, onGameBoard _: GameBoard, completionHandler: (position: GameBoard.Position) -> Void) {
        completionHandler(position: positionGenerator.next()!)
    }
}
