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
class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameBoard = GameBoard()
        gameBoard.putMark(.X, atPosition: (row: 1, column: 1))
        gameBoard.putMark(.O, atPosition: (row: 0, column: 0))
        gameBoard.putMark(.X, atPosition: (row: 2, column: 2))
        gameBoard.putMark(.O, atPosition: (row: 0, column: 2))
        gameBoard.putMark(.X, atPosition: (row: 0, column: 1))
        gameBoard.putMark(.O, atPosition: (row: 2, column: 1))
        gameBoard.putMark(.X, atPosition: (row: 1, column: 2))
        gameBoard.putMark(.O, atPosition: (row: 1, column: 0))
        gameBoard.putMark(.X, atPosition: (row: 2, column: 0))
        self.gameBoardView.gameBoard = gameBoard
    }
    
    @IBOutlet private weak var gameBoardView: GameBoardView!
}
