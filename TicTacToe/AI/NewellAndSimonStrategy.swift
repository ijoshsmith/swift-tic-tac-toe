//
//  NewellAndSimonStrategy.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/30/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** 
 An intelligent agent which implements Newell and Simon's Tic-tac-toe strategy for a 3x3 game board.
 For more information, refer to https://en.wikipedia.org/wiki/Tic-tac-toe#Strategy
 */
final class NewellAndSimonStrategy: TicTacToeStrategy {
    
    init(tactics: [NewellAndSimonTactic] = [
        WinTactic(),
        BlockTactic(),
        // TODO: ForkTactic
        // TODO: BlockForkTactic
        CenterTactic()
        // TODO: OppositeCornerTactic
        // TODO: EmptyCornerTactic
        // TODO: EmptySideTactic
        ]) {
        self.tactics = tactics
    }
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard, completionHandler: GameBoard.Position -> Void) {
        assert(gameBoard.dimension == 3)
        
        let position = tactics.reduce(nil) { (position, tactic) in
            position ?? tactic.chooseWhereToPutMark(mark, onGameBoard: gameBoard)
        }
        
        completionHandler(position!)
    }
    
    private let tactics: [NewellAndSimonTactic]
}
