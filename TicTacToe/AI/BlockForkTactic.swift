//
//  BlockForkTactic.swift
//  TicTacToe
//
//  Created by Joshua Smith on 12/3/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/**
 Tactic #4 in Newell and Simon's strategy.
 If the opponent can play one mark to create two ways to win on their next turn,
 returns a position that forces the opponent to block on their next turn,
 or, if no offensive play is possible, returns the position to block the fork.
 */
struct BlockForkTactic: NewellAndSimonTactic {
    
    func chooseWhereToPutMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        assert(gameBoard.dimension == 3)
        
        // This tactic is only applicable when the opponent can create a fork.
        guard let forkPosition = findForkPositionForMark(mark.opponentMark(), onGameBoard: gameBoard) else {
            return nil
        }
        
        // An offensive position is 'safe' if it does not enable the opponent to create a fork by blocking it.
        let safeOffensivePosition = findSafeOffensivePositionForMark(mark, onGameBoard: gameBoard)
        return safeOffensivePosition ?? forkPosition
    }
    
    private func findForkPositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return ForkTactic().chooseWhereToPutMark(mark, onGameBoard: gameBoard)
    }
    
    private func findSafeOffensivePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return gameBoard.emptyPositions
            .filter { isSafeOffensivePlayForMark(mark, atPosition: $0, onGameBoard: gameBoard) }
            .first
    }
    
    private func isSafeOffensivePlayForMark(mark: Mark, atPosition position: GameBoard.Position, onGameBoard gameBoard: GameBoard) -> Bool {
        let possibleGameBoard = gameBoard.cloneWithMark(mark, atPosition: position)
        
        guard doesOffensivePositionExistForMark(mark, onGameBoard: possibleGameBoard) else {
            return false
        }
        
        guard !wouldForkExistWhenBlockingWithMark(mark.opponentMark(), onGameBoard: possibleGameBoard) else {
            return false
        }
        
        return true
    }
    
    private func doesOffensivePositionExistForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> Bool {
        let offensivePosition = BlockTactic().chooseWhereToPutMark(mark.opponentMark(), onGameBoard: gameBoard)
        return offensivePosition != nil
    }
    
    private func wouldForkExistWhenBlockingWithMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> Bool {
        let
        blockPosition  = BlockTactic().chooseWhereToPutMark(mark, onGameBoard: gameBoard),
        forkPosition   = ForkTactic().chooseWhereToPutMark(mark, onGameBoard: gameBoard),
        isForkingBlock = forkPosition != nil && blockPosition != nil && forkPosition! == blockPosition!
        return isForkingBlock
    }
}
