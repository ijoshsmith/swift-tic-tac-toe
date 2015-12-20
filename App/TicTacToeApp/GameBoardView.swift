//
//  GameBoardView.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/17/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import TicTacToe
import UIKit

/** Renders lines and marks that depict a Tic-tac-toe game. */
final class GameBoardView: UIView {
    
    var gameBoard: GameBoard? {
        didSet { winningPositions = nil }
    }
    
    var winningPositions: [GameBoard.Position]? {
        didSet { refreshBoardState() }
    }
    
    func refreshBoardState() {
        setNeedsDisplay()
    }
    
    var tappedEmptyPositionClosure: (GameBoard.Position -> Void)?
    
    var tappedFinishedGameBoardClosure: (Void -> Void)?
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let isGameOver = winningPositions != nil || gameBoard?.emptyPositions.count == 0
        if isGameOver {
            guard let tappedFinishedGameBoardClosure = tappedFinishedGameBoardClosure else { return }
            tappedFinishedGameBoardClosure()
        }
        else {
            guard let touch = touches.first else { return }
            reportTapOnEmptyPositionWithTouch(touch)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard gameBoard != nil else { return }
        
        let
        borderRect    = calculatePlatformBorderRect(),
        platformRect  = calculatePlatformRectFromBorderRect(borderRect),
        gridLineRects = calculateGridLineRectsFromPlatformRect(platformRect)
        
        drawPlatformInRect(platformRect)
        drawPlatformBorderInRect(borderRect)
        drawMarksInRect(platformRect)
        drawGridLinesInRects(gridLineRects)
        
        if let winningPositions = winningPositions {
            let
            winningRects = calculateCellRectsWithPositions(winningPositions, inRect: platformRect),
            startRect    = winningRects.first!,
            endRect      = winningRects.last!,
            orientation  = winningLineOrientationForStartRect(startRect, endRect: endRect),
            startPoint   = startPointForRect(startRect, winningLineOrientation: orientation),
            endPoint     = endPointForRect(endRect, winningLineOrientation: orientation)
            
            drawWinningLineFromStartPoint(startPoint, toEndPoint: endPoint)
        }
    }
}



// MARK: - User interaction

private extension GameBoardView {
    func reportTapOnEmptyPositionWithTouch(touch: UITouch) {
        guard let gameBoard = gameBoard else { return }
        guard let tappedEmptyPositionClosure = tappedEmptyPositionClosure else { return }
        
        let
        tapLocation    = touch.locationInView(self),
        borderRect     = calculatePlatformBorderRect(),
        platformRect   = calculatePlatformRectFromBorderRect(borderRect),
        emptyPositions = gameBoard.emptyPositions,
        emptyCellRects = calculateCellRectsWithPositions(gameBoard.emptyPositions, inRect: platformRect),
        emptyPositionsAndRects = Array(zip(emptyPositions, emptyCellRects))
        
        let tappedPositions = emptyPositionsAndRects.flatMap { (position, rect) in
            return CGRectContainsPoint(rect, tapLocation) ? position : nil
        }
        
        if let tappedPosition = tappedPositions.first {
            tappedEmptyPositionClosure(tappedPosition)
        }
    }
}



// MARK: - Stylistic settings

private struct Color {
    static let
    borderInner  = UIColor.darkGrayColor(),
    borderOuter  = UIColor.whiteColor(),
    gridLine     = UIColor.darkGrayColor(),
    markO        = UIColor.blueColor(),
    markX        = UIColor.greenColor(),
    platformFill = UIColor.whiteColor(),
    winningLine  = UIColor.redColor()
}

private struct Thickness {
    static let
    cellMargin: CGFloat       = 20,
    gridLine: CGFloat         =  4,
    mark: CGFloat             = 16,
    platformBorder: CGFloat   =  2,
    platformMargin: CGFloat   = 16,
    winningLine: CGFloat      =  8,
    winningLineInset: CGFloat =  8
}



// MARK: - Layout calculation

private extension GameBoardView {
    func calculatePlatformBorderRect() -> CGRect {
        let
        width  = CGRectGetWidth(self.frame),
        height = CGRectGetHeight(self.frame),
        length = min(width, height) - (Thickness.platformMargin * 2),
        origin = CGPoint(x: width/2 - length/2, y: height/2 - length/2),
        size   = CGSize(width: length, height: length)
        return CGRect(origin: origin, size: size)
    }
    
    func calculatePlatformRectFromBorderRect(borderRect: CGRect) -> CGRect {
        return CGRectInset(borderRect, Thickness.platformBorder, Thickness.platformBorder)
    }
    
    func calculateCellRectAtRow(row: Int, column: Int, inRect rect: CGRect) -> CGRect {
        let
        totalLength = CGRectGetWidth(rect),
        cellLength  = totalLength / CGFloat(cellsPerAxis),
        leftEdge    = CGRectGetMinX(rect) + CGFloat(column) * cellLength,
        topEdge     = CGRectGetMinY(rect) + CGFloat(row) * cellLength,
        naturalRect = CGRect(x: leftEdge, y: topEdge, width: cellLength, height: cellLength),
        cellRect    = CGRectInset(naturalRect, Thickness.gridLine, Thickness.gridLine)
        return cellRect
    }
    
    func calculateGridLineRectsFromPlatformRect(platformRect: CGRect) -> [CGRect] {
        let
        lineLength    = CGRectGetWidth(platformRect),
        cellLength    = lineLength / CGFloat(cellsPerAxis),
        centerOffset  = Thickness.gridLine / CGFloat(2),
        leftEdge      = CGRectGetMinX(platformRect),
        topEdge       = CGRectGetMinY(platformRect),
        verticalRects = (1..<cellsPerAxis).map { CGRect(
            x: leftEdge + (CGFloat($0) * cellLength) - centerOffset,
            y: topEdge,
            width: Thickness.gridLine,
            height: lineLength)
        },
        horizontalRects = (1..<cellsPerAxis).map { CGRect(
            x: leftEdge,
            y: topEdge + (CGFloat($0) * cellLength) - centerOffset,
            width: lineLength,
            height: Thickness.gridLine)
        }
        return [verticalRects, horizontalRects].flatMap { $0 }
    }
    
    var cellsPerAxis: Int {
        if let gameBoard = gameBoard {
            return gameBoard.dimension
        }
        else {
            return 0
        }
    }
    
    func calculateCellRectsWithPositions(positions: [GameBoard.Position], inRect rect: CGRect) -> [CGRect] {
        return positions
            .map { calculateCellRectAtRow($0.row, column: $0.column, inRect: rect) }
            .map { CGRectInset($0, Thickness.winningLineInset, Thickness.winningLineInset) }
    }
    
    enum WinningLineOrientation {
        case Horizontal, Vertical, TopLeftToBottomRight, BottomLeftToTopRight
    }
    
    func winningLineOrientationForStartRect(startRect: CGRect, endRect: CGRect) -> WinningLineOrientation {
        let
        startX = Int(startRect.origin.x),
        startY = Int(startRect.origin.y),
        endX   = Int(endRect.origin.x),
        endY   = Int(endRect.origin.y)
        
        switch (startX, endX, startY, endY) {
        case (let x1, let x2,      _,      _) where x1 == x2: return .Vertical
        case (     _,      _, let y1, let y2) where y1 == y2: return .Horizontal
        case (     _,      _, let y1, let y2) where y1 <  y2: return .TopLeftToBottomRight
        default:                                              return .BottomLeftToTopRight
        }
    }
    
    func startPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        switch winningLineOrientation {
        case .Horizontal:           return CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect))
        case .Vertical:             return CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect))
        case .TopLeftToBottomRight: return CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect))
        case .BottomLeftToTopRight: return CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect))
        }
    }
    
    func endPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        switch winningLineOrientation {
        case .Horizontal:           return CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMidY(rect))
        case .Vertical:             return CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect))
        case .TopLeftToBottomRight: return CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
        case .BottomLeftToTopRight: return CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMinY(rect))
        }
    }
}



// MARK: - Rendering

private extension GameBoardView {
    
    var context: CGContextRef {
        return UIGraphicsGetCurrentContext()!
    }
    
    func drawPlatformBorderInRect(rect: CGRect) {
        let
        numberOfBorderLines = 2,
        lineThickness = Thickness.platformBorder / CGFloat(numberOfBorderLines),
        outerRect = rect,
        innerRect = CGRectInset(rect, lineThickness, lineThickness)
        
        [(outerRect, Color.borderOuter), (innerRect, Color.borderInner)].forEach { (rect, color) in
            context.strokeRect(rect, color: color, width: lineThickness)
        }
    }
    
    func drawPlatformInRect(rect: CGRect) {
        context.fillRect(rect, color: Color.platformFill)
    }
    
    func drawMarksInRect(rect: CGRect) {
        guard let gameBoard = gameBoard else { return }
        for row in 0..<gameBoard.dimension {
            let marksInRow = gameBoard.marksInRow(row)
            for column in 0..<gameBoard.dimension {
                if let mark = marksInRow[column] {
                    let cellRect = calculateCellRectAtRow(row, column: column, inRect: rect)
                    drawMark(mark, inRect: cellRect)
                }
            }
        }
    }
    
    func drawMark(mark: Mark, inRect rect: CGRect) {
        let markRect = CGRectInset(rect, Thickness.cellMargin, Thickness.cellMargin)
        switch mark {
        case .X: drawX(inRect: markRect)
        case .O: drawO(inRect: markRect)
        }
    }
    
    func drawX(inRect rect: CGRect) {
        let
        left   = CGRectGetMinX(rect),
        right  = CGRectGetMaxX(rect),
        top    = CGRectGetMinY(rect),
        bottom = CGRectGetMaxY(rect),
        topLeft     = CGPoint(x: left,  y: top),
        topRight    = CGPoint(x: right, y: top),
        bottomLeft  = CGPoint(x: left,  y: bottom),
        bottomRight = CGPoint(x: right, y: bottom)
        
        context.strokeLineFrom(topLeft, to: bottomRight, color: Color.markX, width: Thickness.mark, lineCap: .Round)
        context.strokeLineFrom(bottomLeft, to: topRight, color: Color.markX, width: Thickness.mark, lineCap: .Round)
    }
    
    func drawO(inRect rect: CGRect) {
        context.strokeEllipseInRect(rect, color: Color.markO, width: Thickness.mark)
    }
    
    func drawGridLinesInRects(gridLineRects: [CGRect]) {
        gridLineRects.forEach {
            context.fillRect($0, color: Color.gridLine)
        }
    }
    
    func drawWinningLineFromStartPoint(startPoint: CGPoint, toEndPoint endPoint: CGPoint) {
        context.strokeLineFrom(startPoint, to: endPoint, color: Color.winningLine, width: Thickness.winningLine, lineCap: .Round)
    }
}
