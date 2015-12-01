//
//  GameBoard+DSL.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

extension GameBoard {
    static func gameBoardFrom3x3TextDiagram(textDiagram: String) -> GameBoard {
        assert(textDiagram.characters.count == 9)
        
        let
        board   = GameBoard(),
        symbols = textDiagram.characters.map { String($0).uppercaseString },
        marks   = symbols.map(markFromSymbol)
        for (index, mark) in marks.enumerate() where mark != .Empty {
            let position = GameBoard.Position(row: index / 3, column: index % 3)
            board.putMark(mark, atPosition: position)
        }
        return board
    }
    
    private static func markFromSymbol(symbol: String) -> Mark {
        switch symbol {
        case "X": return .X
        case "O": return .O
        default:  return .Empty
        }
    }
}
