//
//  GameBoardView.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/17/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import TicTacToe
import UIKit

/** Displays the lines and marks of a Tic-tac-toe game. */
final class GameBoardView: UIView {
    
    var gameBoard: GameBoard? {
        didSet {
            _layout = nil
            _renderer = nil
            winningPositions = nil
        }
    }
    
    var winningPositions: [GameBoard.Position]? {
        didSet { refreshBoardState() }
    }
    
    func refreshBoardState() {
        setNeedsDisplay()
    }
    
    var tappedEmptyPositionHandler: (GameBoard.Position -> Void)?
    
    var tappedFinishedGameBoardHandler: (Void -> Void)?
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if gameBoard != nil {
            handleTouchesEnded(touches)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if gameBoard != nil {
            renderer.renderWithWinningPositions(winningPositions)
        }
    }
    
    private var _renderer: GameBoardRenderer?
    private var renderer: GameBoardRenderer {
        if _renderer == nil {
            let context = UIGraphicsGetCurrentContext()!
            _renderer = GameBoardRenderer(context: context, gameBoard: gameBoard!, layout: layout)
        }
        return _renderer!
    }
    
    private var _layout: GameBoardLayout?
    private var layout: GameBoardLayout {
        if _layout == nil {
            _layout = GameBoardLayout(frame: frame, marksPerAxis: gameBoard!.dimension)
        }
        return _layout!
    }
}



// MARK: - Touch handling

private extension GameBoardView {
    func handleTouchesEnded(touches: Set<UITouch>) {
        if isGameFinished {
            reportTapOnFinishedGameBoard()
        }
        else if let touch = touches.first {
            reportTapOnEmptyPositionWithTouch(touch)
        }
    }
    
    var isGameFinished: Bool {
        let
        wasWon  = winningPositions != nil,
        wasTied = gameBoard?.emptyPositions.count == 0
        return wasWon || wasTied
    }
    
    func reportTapOnFinishedGameBoard() {
        guard let tappedFinishedGameBoardHandler = tappedFinishedGameBoardHandler else { return }
        tappedFinishedGameBoardHandler()
    }
    
    func reportTapOnEmptyPositionWithTouch(touch: UITouch) {
        guard let gameBoard = gameBoard else { return }
        guard let tappedEmptyPositionHandler = tappedEmptyPositionHandler else { return }
        
        let
        tapLocation    = touch.locationInView(self),
        emptyPositions = gameBoard.emptyPositions,
        emptyCellRects = layout.cellRectsAtPositions(emptyPositions),
        emptyPositionsAndRects = Array(zip(emptyPositions, emptyCellRects))
        
        let tappedPositions = emptyPositionsAndRects.flatMap { (position, rect) in
            return rect.contains(tapLocation) ? position : nil
        }
        
        if let tappedPosition = tappedPositions.first {
            tappedEmptyPositionHandler(tappedPosition)
        }
    }
}
