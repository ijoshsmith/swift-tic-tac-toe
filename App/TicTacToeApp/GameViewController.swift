//
//  RootViewController.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/10/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import UIKit
import TicTacToe

/** The top-level view controller in the app. */
class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPlayingGame()
    }
    
    @IBAction private func handleTwoPlayerModeSwitch(sender: AnyObject) {
        startPlayingGame()
    }
    
    @IBAction private func handleRefreshButton(sender: AnyObject) {
        startPlayingGame()
    }
    
    private var game: Game?
    private var userStrategyX: UserStrategy?
    private var userStrategyO: UserStrategy?
    
    @IBOutlet private weak var gameBoardView: GameBoardView!
    @IBOutlet private weak var twoPlayerModeSwitch: UISwitch!
}



// MARK: - Gameplay

private extension GameViewController {
    func startPlayingGame() {
        let gameBoard = GameBoard()
        gameBoardView.gameBoard = gameBoard
        gameBoardView.tappedEmptyPositionClosure = { [weak self] position in
            self?.handleTappedEmptyPosition(position)
        }
        
        let isBetweenTwoUsers = twoPlayerModeSwitch.on
        userStrategyX = UserStrategy()
        userStrategyO = isBetweenTwoUsers ? UserStrategy() : nil
        
        let
        xStrategy = userStrategyX!,
        oStrategy = userStrategyO ?? createArtificalIntelligenceStrategy()
        
        game = Game(gameBoard: gameBoard, xStrategy: xStrategy, oStrategy: oStrategy)
        game!.startPlayingWithCompletionHandler { [weak self] outcome in
            self?.gameBoardView.winningPositions = outcome.winningPositions
        }
    }
    
    func handleTappedEmptyPosition(position: GameBoard.Position) {
        if !reportTappedPosition(position, forUserStrategy: userStrategyX) {
            reportTappedPosition(position, forUserStrategy: userStrategyO)
        }
        gameBoardView.refreshBoardState()
    }
    
    func reportTappedPosition(tappedPosition: GameBoard.Position, forUserStrategy userStrategy: UserStrategy?) -> Bool {
        guard let userStrategy = userStrategy where userStrategy.isWaitingToChoosePosition else {
            return false
        }
        
        userStrategy.choosePosition(tappedPosition)
        return true
    }
}
