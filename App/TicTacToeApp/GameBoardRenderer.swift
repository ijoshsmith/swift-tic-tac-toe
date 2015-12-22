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
        let (outerRect, innerRect) = layout.borderRects
        context.strokeRect(outerRect, color: UIColor.outerBorder, width: Thickness.outerBorder)
        context.strokeRect(innerRect, color: UIColor.innerBorder, width: Thickness.innerBorder)
    }
    
    func renderPlatform() {
        context.fillRect(layout.platformRect, color: UIColor.platform)
    }
    
    func renderGridLines() {
        layout.gridLines.forEach {
            context.strokeLineFrom($0.startPoint, to: $0.endPoint, color: UIColor.gridLine, width: Thickness.gridLine, lineCap: .Butt)
        }
    }
    
    func renderMarks() {
        gameBoard.marksAndPositions
            .map     { (mark, position) in (mark, layout.cellRectAtPosition(position)) }
            .map     { (mark, cellRect) in (mark, cellRect.insetBy(Thickness.markMargin)) }
            .forEach { (mark, markRect) in renderMark(mark, inRect: markRect) }
    }
    
    func renderMark(mark: Mark, inRect rect: CGRect) {
        switch mark {
        case .X: renderX(inRect: rect)
        case .O: renderO(inRect: rect)
        }
    }
    
    func renderX(inRect rect: CGRect) {
        context.strokeLineFrom(rect.topLeft, to: rect.bottomRight, color: UIColor.markX, width: Thickness.mark, lineCap: .Round)
        context.strokeLineFrom(rect.bottomLeft, to: rect.topRight, color: UIColor.markX, width: Thickness.mark, lineCap: .Round)
    }
    
    func renderO(inRect rect: CGRect) {
        context.strokeEllipseInRect(rect, color: UIColor.markO, width: Thickness.mark)
    }
    
    func renderLineThroughWinningPositions(winningPositions: [GameBoard.Position]) {
        let (startPoint, endPoint) = layout.lineThroughWinningPositions(winningPositions)
        context.strokeLineFrom(startPoint, to: endPoint, color: UIColor.winningLine, width: Thickness.winningLine, lineCap: .Round)
    }
}



// MARK: - Element colors

private extension UIColor {
    static let
    gridLine    = UIColor.darkGrayColor(),
    innerBorder = UIColor.darkGrayColor(),
    markO       = UIColor.blueColor(),
    markX       = UIColor.greenColor(),
    outerBorder = UIColor.whiteColor(),
    platform    = UIColor.whiteColor(),
    winningLine = UIColor.redColor()
}
