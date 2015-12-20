//
//  Game.swift
//  TicTacToe
//
//  Created by Joshua Smith on 11/28/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import Foundation

/** Orchestrates gameplay between two players. */
public final class Game {
    
    public typealias CompletionHandler = Outcome -> Void
    
    public init(gameBoard: GameBoard, xStrategy: TicTacToeStrategy, oStrategy: TicTacToeStrategy) {
        self.gameBoard = gameBoard
        self.outcomeAnalyst = OutcomeAnalyst(gameBoard: gameBoard)
        self.playerX = Player(mark: .X, gameBoard: gameBoard, strategy: xStrategy)
        self.playerO = Player(mark: .O, gameBoard: gameBoard, strategy: oStrategy)
    }
    
    public func startPlayingWithCompletionHandler(completionHandler: CompletionHandler) {
        assert(self.completionHandler == nil, "Cannot start the same Game twice.")
        self.completionHandler = completionHandler
        currentPlayer = playerX
    }
    
    
    
    // MARK: - Non-public stored properties
    
    private var currentPlayer: Player? {
        didSet {
            currentPlayer?.choosePositionWithCompletionHandler(processChosenPosition)
        }
    }
    
    private var completionHandler: CompletionHandler!
    private let gameBoard: GameBoard
    private let outcomeAnalyst: OutcomeAnalyst
    private let playerO: Player
    private let playerX: Player
}



// MARK: - Private methods

private extension Game {
    func processChosenPosition(position: GameBoard.Position) {
        guard let currentPlayer = currentPlayer else {
            assertionFailure("Why was a position chosen if there is no current player?")
            return
        }
        
        gameBoard.putMark(currentPlayer.mark, atPosition: position)
        
        log(position)
        
        if let outcome = outcomeAnalyst.checkForOutcome() {
            finishWithOutcome(outcome)
        }
        else {
            switchCurrentPlayer()
        }
    }
    
    func log(position: GameBoard.Position) {
        print("--- \(currentPlayer!.mark) played (\(position.row), \(position.column)) ---\n\(gameBoard.textRepresentation)\n")
    }
    
    func finishWithOutcome(outcome: Outcome) {
        completionHandler(outcome)
        currentPlayer = nil
    }
    
    func switchCurrentPlayer() {
        let xIsCurrent = (currentPlayer!.mark == .X)
        currentPlayer = xIsCurrent ? playerO : playerX
    }
}
