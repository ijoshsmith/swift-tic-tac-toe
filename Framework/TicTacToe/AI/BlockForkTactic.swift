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
    
    func choosePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
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
        return ForkTactic().choosePositionForMark(mark, onGameBoard: gameBoard)
    }
    
    private func findSafeOffensivePositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return gameBoard.emptyPositions
            .filter { isSafeOffensivePosition($0, forMark: mark, onGameBoard: gameBoard) }
            .first
    }
    
    private func isSafeOffensivePosition(offensivePosition: GameBoard.Position, forMark mark: Mark, onGameBoard gameBoard: GameBoard) -> Bool {
        let possibleGameBoard = gameBoard.cloneWithMark(mark, atPosition: offensivePosition)
        
        guard let winningPosition = findWinningPositionForMark(mark, onGameBoard: possibleGameBoard) else {
            return false
        }
        
        if wouldCreateForkForMark(mark.opponentMark(), byBlockingPosition: winningPosition, onGameBoard: possibleGameBoard) {
            return false
        }
        
        return true
    }
    
    private func findWinningPositionForMark(mark: Mark, onGameBoard gameBoard: GameBoard) -> GameBoard.Position? {
        return WinTactic().choosePositionForMark(mark, onGameBoard: gameBoard)
    }
    
    private func wouldCreateForkForMark(mark: Mark, byBlockingPosition blockPosition: GameBoard.Position, onGameBoard gameBoard: GameBoard) -> Bool {
        let
        forkPositions  = ForkTactic().findForkPositionsForMark(mark, onGameBoard: gameBoard),
        isForkingBlock = forkPositions.contains { $0 == blockPosition }
        return isForkingBlock
    }
}
