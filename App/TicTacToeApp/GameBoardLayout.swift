//
//  GameBoardLayout.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/20/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import TicTacToe
import UIKit

/** Calculates sizes and positions used to render a game board. */
final class GameBoardLayout {
    
    typealias Line = (startPoint: CGPoint, endPoint: CGPoint)
    
    init(frame: CGRect, marksPerAxis: Int) {
        self.frame = frame
        self.marksPerAxis = marksPerAxis
    }
    
    lazy var outerBorderRect: CGRect = {
        let
        width  = self.frame.width,
        height = self.frame.height,
        length = min(width, height) - (Thickness.platformMargin * 2),
        origin = CGPoint(x: width/2 - length/2, y: height/2 - length/2),
        size   = CGSize(width: length, height: length)
        return CGRect(origin: origin, size: size)
    }()
    
    lazy var innerBorderRect: CGRect = {
        return self.outerBorderRect.insetBy(Thickness.outerBorder)
    }()
    
    lazy var platformRect: CGRect = {
        return self.innerBorderRect.insetBy(Thickness.innerBorder)
    }()
    
    lazy var gridLines: [Line] = {
        let
        cellLength    = self.platformRect.width / CGFloat(self.marksPerAxis),
        lineNumbers   = 1..<self.marksPerAxis,
        verticalLines = lineNumbers.map { lineNumber -> Line in
            let x = self.platformRect.minX + CGFloat(lineNumber) * cellLength
            return Line(
                startPoint: CGPoint(x: x, y: self.platformRect.minY),
                endPoint:   CGPoint(x: x, y: self.platformRect.maxY))
        },
        horizontalLines = lineNumbers.map { lineNumber -> Line in
            let y = self.platformRect.minY + CGFloat(lineNumber) * cellLength
            return Line(
                startPoint: CGPoint(x: self.platformRect.minX, y: y),
                endPoint:   CGPoint(x: self.platformRect.maxX, y: y))
        }
        return verticalLines + horizontalLines
    }()
    
    func cellRectsAtPositions(positions: [GameBoard.Position]) -> [CGRect] {
        return positions.map(cellRectAtPosition)
    }
    
    private func cellRectAtPosition(position: GameBoard.Position) -> CGRect {
        let
        length = platformRect.width / CGFloat(marksPerAxis),
        left   = platformRect.minX + CGFloat(position.column) * length,
        top    = platformRect.minY + CGFloat(position.row) * length
        return CGRect(x: left, y: top, width: length, height: length)
    }
    
    func markRectAtPosition(position: GameBoard.Position) -> CGRect {
        let cellRect = cellRectAtPosition(position)
        return cellRect.insetBy(Thickness.gridLine/2 + Thickness.markMargin)
    }

    func lineThroughWinningPositions(winningPositions: [GameBoard.Position]) -> Line {
        let
        cellRects   = cellRectsAtPositions(winningPositions),
        startRect   = cellRects.first!,
        endRect     = cellRects.last!,
        orientation = winningLineOrientationForStartRect(startRect, endRect: endRect),
        startPoint  = startPointForRect(startRect, winningLineOrientation: orientation),
        endPoint    = endPointForRect(endRect, winningLineOrientation: orientation)
        return (startPoint, endPoint)
    }
    
    private enum WinningLineOrientation {
        case Horizontal, Vertical, TopLeftToBottomRight, BottomLeftToTopRight
    }
    
    private func winningLineOrientationForStartRect(startRect: CGRect, endRect: CGRect) -> WinningLineOrientation {
        let
        x1 = Int(startRect.minX), x2 = Int(endRect.minX),
        y1 = Int(startRect.minY), y2 = Int(endRect.minY)
        if x1 == x2 { return .Vertical }
        if y1 == y2 { return .Horizontal }
        if y1 <  y2 { return .TopLeftToBottomRight }
        return .BottomLeftToTopRight
    }
    
    private func startPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetBy(Thickness.winningLineInset)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerLeft
        case .Vertical:             return winningRect.topCenter
        case .TopLeftToBottomRight: return winningRect.topLeft
        case .BottomLeftToTopRight: return winningRect.bottomLeft
        }
    }
    
    private func endPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetBy(Thickness.winningLineInset)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerRight
        case .Vertical:             return winningRect.bottomCenter
        case .TopLeftToBottomRight: return winningRect.bottomRight
        case .BottomLeftToTopRight: return winningRect.topRight
        }
    }
    
    private let frame: CGRect
    private let marksPerAxis: Int
}
