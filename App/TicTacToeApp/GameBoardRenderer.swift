//
//  GameBoardRenderer.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/20/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import TicTacToe
import UIKit

/** Draws a game board on the screen. */
final class GameBoardRenderer {
    
    init(context: CGContextRef, gameBoard: GameBoard, layout: GameBoardLayout) {
        self.context = context
        self.gameBoard = gameBoard
        self.layout = layout
    }
    
    func renderWithWinningPositions(winningPositions: [GameBoard.Position]?) {
        renderPlatformBorder()
        renderPlatform()
        renderGridLines()
        renderMarks()
        if let winningPositions = winningPositions {
            renderLineThroughWinningPositions(winningPositions)
        }
    }
    
    private let context: CGContextRef
    private let gameBoard: GameBoard
    private let layout: GameBoardLayout
}



// MARK: - Rendering routines

private extension GameBoardRenderer {
    func renderPlatformBorder() {
        let
        lineCount = 2,
        lineWidth = GameBoardView.Thickness.platformBorder / CGFloat(lineCount),
        outerRect = layout.platformBorderRect,
        innerRect = outerRect.insetUniformlyBy(lineWidth)
        
        context.strokeRect(outerRect, color: UIColor.borderOuter, width: lineWidth)
        context.strokeRect(innerRect, color: UIColor.borderInner, width: lineWidth)
    }
    
    func renderPlatform() {
        context.fillRect(layout.platformRect, color: UIColor.platformFill)
    }
    
    func renderGridLines() {
        layout.gridLineRects.forEach {
            context.fillRect($0, color: UIColor.gridLine)
        }
    }
    
    func renderMarks() {
        gameBoard.marksAndPositions
            .map     { (mark, position) in (mark: mark, cellRect: layout.cellRectAtPosition(position)) }
            .forEach { (mark, cellRect) in renderMark(mark, inRect: cellRect) }
    }
    
    func renderMark(mark: Mark, inRect rect: CGRect) {
        let markRect = rect.insetUniformlyBy(GameBoardView.Thickness.markMargin)
        switch mark {
        case .X: renderX(inRect: markRect)
        case .O: renderO(inRect: markRect)
        }
    }
    
    func renderX(inRect rect: CGRect) {
        context.strokeLineFrom(rect.topLeft, to: rect.bottomRight, color: UIColor.markX, width: GameBoardView.Thickness.mark, lineCap: .Round)
        context.strokeLineFrom(rect.bottomLeft, to: rect.topRight, color: UIColor.markX, width: GameBoardView.Thickness.mark, lineCap: .Round)
    }
    
    func renderO(inRect rect: CGRect) {
        context.strokeEllipseInRect(rect, color: UIColor.markO, width: GameBoardView.Thickness.mark)
    }
    
    func renderLineThroughWinningPositions(winningPositions: [GameBoard.Position]) {
        let (startPoint, endPoint) = layout.pointsForLineThroughWinningPositions(winningPositions)
        context.strokeLineFrom(startPoint, to: endPoint, color: UIColor.winningLine, width: GameBoardView.Thickness.winningLine, lineCap: .Round)
    }
}



// MARK: - Element colors

private extension UIColor {
    static let
    borderInner  = UIColor.darkGrayColor(),
    borderOuter  = UIColor.whiteColor(),
    gridLine     = UIColor.darkGrayColor(),
    markO        = UIColor.blueColor(),
    markX        = UIColor.greenColor(),
    platformFill = UIColor.whiteColor(),
    winningLine  = UIColor.redColor()
}
