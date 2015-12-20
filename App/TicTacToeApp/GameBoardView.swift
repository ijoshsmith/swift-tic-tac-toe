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
        drawGridLinesInRects(gridLineRects)
        drawMarksInRect(platformRect)
        
        if let winningPositions = winningPositions {
            let (startPoint, endPoint) = calculateStartAndEndPointsForWinningLineThroughPositions(winningPositions, inRect: platformRect)
            drawWinningLineFrom(startPoint, to: endPoint)
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
            return rect.contains(tapLocation) ? position : nil
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
    gridLine: CGFloat         =  4,
    mark: CGFloat             = 16,
    markMargin: CGFloat       = 20,
    platformBorder: CGFloat   =  2,
    platformMargin: CGFloat   = 16,
    winningLine: CGFloat      =  8,
    winningLineInset: CGFloat =  8
}



// MARK: - Layout calculation

private extension GameBoardView {
    func calculatePlatformBorderRect() -> CGRect {
        let
        width  = frame.width,
        height = frame.height,
        length = min(width, height) - (Thickness.platformMargin * 2),
        origin = CGPoint(x: width/2 - length/2, y: height/2 - length/2),
        size   = CGSize(width: length, height: length)
        return CGRect(origin: origin, size: size)
    }
    
    func calculatePlatformRectFromBorderRect(borderRect: CGRect) -> CGRect {
        return borderRect.insetUniformlyBy(Thickness.platformBorder)
    }
    
    func calculateGridLineRectsFromPlatformRect(platformRect: CGRect) -> [CGRect] {
        let
        lineLength    = platformRect.width,
        cellLength    = lineLength / CGFloat(cellsPerAxis),
        centerOffset  = Thickness.gridLine / CGFloat(2),
        verticalRects = (1..<cellsPerAxis).map { CGRect(
            x:      platformRect.minX + (CGFloat($0) * cellLength) - centerOffset,
            y:      platformRect.minY,
            width:  Thickness.gridLine,
            height: lineLength)
        },
        horizontalRects = (1..<cellsPerAxis).map { CGRect(
            x:      platformRect.minX,
            y:      platformRect.minY + (CGFloat($0) * cellLength) - centerOffset,
            width:  lineLength,
            height: Thickness.gridLine)
        }
        return [verticalRects, horizontalRects].flatMap { $0 }
    }
    
    var cellsPerAxis: Int {
        return gameBoard != nil ? gameBoard!.dimension : 0
    }
    
    func calculateStartAndEndPointsForWinningLineThroughPositions(positions: [GameBoard.Position], inRect rect: CGRect) -> (CGPoint, CGPoint) {
        let
        winningRects = calculateCellRectsWithPositions(positions, inRect: rect),
        startRect    = winningRects.first!,
        endRect      = winningRects.last!,
        orientation  = winningLineOrientationForStartRect(startRect, endRect: endRect),
        startPoint   = startPointForRect(startRect, winningLineOrientation: orientation),
        endPoint     = endPointForRect(endRect, winningLineOrientation: orientation)
        return (startPoint, endPoint)
    }
    
    func calculateCellRectsWithPositions(positions: [GameBoard.Position], inRect rect: CGRect) -> [CGRect] {
        return positions.map {
            calculateCellRectAtRow($0.row, column: $0.column, inRect: rect)
        }
    }
    
    func calculateCellRectAtRow(row: Int, column: Int, inRect rect: CGRect) -> CGRect {
        let
        totalLength = rect.width,
        cellLength  = totalLength / CGFloat(cellsPerAxis),
        leftEdge    = rect.minX + CGFloat(column) * cellLength,
        topEdge     = rect.minY + CGFloat(row) * cellLength,
        naturalRect = CGRect(x: leftEdge, y: topEdge, width: cellLength, height: cellLength),
        cellRect    = naturalRect.insetUniformlyBy(Thickness.gridLine)
        return cellRect
    }
    
    enum WinningLineOrientation {
        case Horizontal, Vertical, TopLeftToBottomRight, BottomLeftToTopRight
    }
    
    func winningLineOrientationForStartRect(startRect: CGRect, endRect: CGRect) -> WinningLineOrientation {
        let
        x1 = Int(startRect.minX), x2 = Int(endRect.minX),
        y1 = Int(startRect.minY), y2 = Int(endRect.minY)
        if x1 == x2 { return .Vertical }
        if y1 == y2 { return .Horizontal }
        if y1 <  y2 { return .TopLeftToBottomRight }
        return .BottomLeftToTopRight
    }
    
    func startPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetUniformlyBy(Thickness.winningLineInset)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerLeft
        case .Vertical:             return winningRect.topCenter
        case .TopLeftToBottomRight: return winningRect.topLeft
        case .BottomLeftToTopRight: return winningRect.bottomLeft
        }
    }
    
    func endPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetUniformlyBy(Thickness.winningLineInset)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerRight
        case .Vertical:             return winningRect.bottomCenter
        case .TopLeftToBottomRight: return winningRect.bottomRight
        case .BottomLeftToTopRight: return winningRect.topRight
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
        innerRect = rect.insetUniformlyBy(lineThickness)
        
        context.strokeRect(outerRect, color: Color.borderOuter, width: lineThickness)
        context.strokeRect(innerRect, color: Color.borderInner, width: lineThickness)
    }
    
    func drawPlatformInRect(rect: CGRect) {
        context.fillRect(rect, color: Color.platformFill)
    }
    
    func drawGridLinesInRects(gridLineRects: [CGRect]) {
        gridLineRects.forEach {
            context.fillRect($0, color: Color.gridLine)
        }
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
        let markRect = rect.insetUniformlyBy(Thickness.markMargin)
        switch mark {
        case .X: drawX(inRect: markRect)
        case .O: drawO(inRect: markRect)
        }
    }
    
    func drawX(inRect rect: CGRect) {
        context.strokeLineFrom(rect.topLeft, to: rect.bottomRight, color: Color.markX, width: Thickness.mark, lineCap: .Round)
        context.strokeLineFrom(rect.bottomLeft, to: rect.topRight, color: Color.markX, width: Thickness.mark, lineCap: .Round)
    }
    
    func drawO(inRect rect: CGRect) {
        context.strokeEllipseInRect(rect, color: Color.markO, width: Thickness.mark)
    }
    
    func drawWinningLineFrom(from: CGPoint, to: CGPoint) {
        context.strokeLineFrom(from, to: to, color: Color.winningLine, width: Thickness.winningLine, lineCap: .Round)
    }
}
