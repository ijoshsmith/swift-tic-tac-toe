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
        print("gameBoard = \(gameBoard)")
    }
    
}
