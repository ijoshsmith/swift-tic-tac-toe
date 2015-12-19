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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = Color.background
    }
    
    var gameBoard: GameBoard?
    
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
    }
}



// MARK: - Stylistic settings

private struct Color {
    static let
    background   = UIColor.lightGrayColor(),
    borderInner  = UIColor.darkGrayColor(),
    borderOuter  = UIColor.whiteColor(),
    gridLine     = UIColor.darkGrayColor(),
    markO        = UIColor.blueColor(),
    markX        = UIColor.greenColor(),
    platformFill = UIColor.whiteColor()
}

private struct Thickness {
    static let
    cellMargin: CGFloat     = 20,
    gridLine: CGFloat       = 2,
    mark: CGFloat           = 16,
    platformBorder: CGFloat = 2
}



// MARK: - Layout calculation

private extension GameBoardView {
    func calculatePlatformBorderRect() -> CGRect {
        let
        width  = CGRectGetWidth(self.frame),
        height = CGRectGetHeight(self.frame),
        margin = CGFloat(0.92),
        length = min(width, height) * margin,
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
}



// MARK: - Rendering

private extension GameBoardView {
    func drawPlatformBorderInRect(rect: CGRect) {
        let
        context = UIGraphicsGetCurrentContext(),
        numberOfBorderLines = 2,
        borderLineThickness = Thickness.platformBorder / CGFloat(numberOfBorderLines),
        outerRect = rect,
        innerRect = CGRectInset(rect, borderLineThickness, borderLineThickness)
        
        CGContextSetLineWidth(context, borderLineThickness)
        
        [(outerRect, Color.borderOuter), (innerRect, Color.borderInner)].forEach { (rect, color) in
            CGContextSetStrokeColorWithColor(context, color.CGColor)
            CGContextAddRect(context, rect)
            CGContextStrokePath(context)
        }
    }
    
    func drawPlatformInRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, Color.platformFill.CGColor)
        CGContextFillRect(context, rect)
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
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, Color.markX.CGColor)
        CGContextSetLineWidth(context, Thickness.mark)
        CGContextSetLineCap(context, CGLineCap.Round)
        
        let
        left   = CGRectGetMinX(rect),
        right  = CGRectGetMaxX(rect),
        top    = CGRectGetMinY(rect),
        bottom = CGRectGetMaxY(rect)
        
        CGContextMoveToPoint(context, left, top)
        CGContextAddLineToPoint(context, right, bottom)
        
        CGContextMoveToPoint(context, left, bottom)
        CGContextAddLineToPoint(context, right, top)
        
        CGContextStrokePath(context)
    }
    
    func drawO(inRect rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, Color.markO.CGColor)
        CGContextSetLineWidth(context, Thickness.mark)
        CGContextAddEllipseInRect(context, rect)
        CGContextStrokePath(context)
    }
    
    func drawGridLinesInRects(gridLineRects: [CGRect]) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, Color.gridLine.CGColor)
        CGContextSetLineWidth(context, Thickness.gridLine)
        gridLineRects.forEach {
            CGContextAddRect(context, $0)
            CGContextStrokePath(context)
        }
    }
}
