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
    
    init(gameBoard: GameBoard, layout: GameBoardLayout) {
        self.gameBoard = gameBoard
        self.layout = layout
    }
    
    func renderWithWinningPositions(winningPositions: [GameBoard.Position]?) {
        renderPlatformBorder()
        renderPlatform()
        renderGridLines()
        renderMarks()
        if let winningPositions = winningPositions {
            renderWinningLineThroughPositions(winningPositions)
        }
    }
    
    private let gameBoard: GameBoard
    private let layout: GameBoardLayout
}



// MARK: - Rendering routines

private extension GameBoardRenderer {
    struct Color {
        static let
        borderInner  = UIColor.darkGrayColor(),
        borderOuter  = UIColor.whiteColor(),
        gridLine     = UIColor.darkGrayColor(),
        markO        = UIColor.blueColor(),
        markX        = UIColor.greenColor(),
        platformFill = UIColor.whiteColor(),
        winningLine  = UIColor.redColor()
    }
    
    var context: CGContextRef {
        return UIGraphicsGetCurrentContext()!
    }
    
    func renderPlatformBorder() {
        let
        numberOfBorderLines = 2,
        lineThickness = GameBoardView.Thickness.platformBorder / CGFloat(numberOfBorderLines),
        outerRect = self.layout.platformBorderRect,
        innerRect = outerRect.insetUniformlyBy(lineThickness)
        
        context.strokeRect(outerRect, color: Color.borderOuter, width: lineThickness)
        context.strokeRect(innerRect, color: Color.borderInner, width: lineThickness)
    }
    
    func renderPlatform() {
        context.fillRect(self.layout.platformRect, color: Color.platformFill)
    }
    
    func renderGridLines() {
        self.layout.gridLineRects.forEach {
            context.fillRect($0, color: Color.gridLine)
        }
    }
    
    func renderMarks() {
        gameBoard.marksAndPositions
            .filter  { $0.mark != nil }
            .map     { (mark: $0.mark!, cellRect: layout.cellRectAtPosition($0.position)) }
            .forEach { renderMark($0.mark, inRect: $0.cellRect) }
    }
    
    func renderMark(mark: Mark, inRect rect: CGRect) {
        let markRect = rect.insetUniformlyBy(GameBoardView.Thickness.markMargin)
        switch mark {
        case .X: renderX(inRect: markRect)
        case .O: renderO(inRect: markRect)
        }
    }
    
    func renderX(inRect rect: CGRect) {
        context.strokeLineFrom(rect.topLeft, to: rect.bottomRight, color: Color.markX, width: GameBoardView.Thickness.mark, lineCap: .Round)
        context.strokeLineFrom(rect.bottomLeft, to: rect.topRight, color: Color.markX, width: GameBoardView.Thickness.mark, lineCap: .Round)
    }
    
    func renderO(inRect rect: CGRect) {
        context.strokeEllipseInRect(rect, color: Color.markO, width: GameBoardView.Thickness.mark)
    }
    
    func renderWinningLineThroughPositions(positions: [GameBoard.Position]) {
        let (startPoint, endPoint) = layout.pointsForWinningLineThroughPositions(positions)
        context.strokeLineFrom(startPoint, to: endPoint, color: Color.winningLine, width: GameBoardView.Thickness.winningLine, lineCap: .Round)
    }
}
