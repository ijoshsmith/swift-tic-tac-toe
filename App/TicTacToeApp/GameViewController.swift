//
//  RootViewController.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/10/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import UIKit
import TicTacToe

/** The view controller that manages Tic-tac-toe gameplay. */
final class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameBoardView.tappedEmptyPositionHandler = { [weak self] position in
            self?.handleTappedEmptyPosition(position)
        }
        
        gameBoardView.tappedFinishedGameBoardHandler = { [weak self] in
            self?.startPlayingGame()
        }
        
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
        
        userStrategyX = UserStrategy()
        userStrategyO = twoPlayerModeSwitch.on ? UserStrategy() : nil
        
        let
        xStrategy = userStrategyX!,
        oStrategy = userStrategyO ?? createArtificialIntelligenceStrategy()
        
        game = Game(gameBoard: gameBoard, xStrategy: xStrategy, oStrategy: oStrategy)
        game!.startPlayingWithCompletionHandler { [weak self] outcome in
            self?.gameBoardView.winningPositions = outcome.winningPositions
        }
    }
    
    func handleTappedEmptyPosition(position: GameBoard.Position) {
        if !reportChosenPosition(position, forUserStrategy: userStrategyX) {
            reportChosenPosition(position, forUserStrategy: userStrategyO)
        }
        gameBoardView.refreshBoardState()
    }
    
    func reportChosenPosition(position: GameBoard.Position, forUserStrategy userStrategy: UserStrategy?) -> Bool {
        guard let userStrategy = userStrategy where userStrategy.isWaitingToReportChosenPosition else {
            return false
        }
        
        userStrategy.reportChosenPosition(position)
        return true
    }
}
