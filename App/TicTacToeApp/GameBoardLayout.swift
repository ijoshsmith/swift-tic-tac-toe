//
//  GameBoardLayout.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/20/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import TicTacToe
import UIKit

/** Provides layout information used to render a game board. */
final class GameBoardLayout {
    
    init(frame: CGRect, marksPerAxis: Int) {
        self.frame = frame
        self.marksPerAxis = marksPerAxis
    }
    
    lazy var platformBorderRect: CGRect = {
        let
        width  = self.frame.width,
        height = self.frame.height,
        length = min(width, height) - (GameBoardView.Thickness.platformMargin * 2),
        origin = CGPoint(x: width/2 - length/2, y: height/2 - length/2),
        size   = CGSize(width: length, height: length)
        return CGRect(origin: origin, size: size)
    }()
    
    lazy var platformRect: CGRect = {
        return self.platformBorderRect.insetUniformlyBy(GameBoardView.Thickness.platformBorder)
    }()
    
    lazy var gridLineRects: [CGRect] = {
        let
        lineLength    = self.platformRect.width,
        cellLength    = lineLength / CGFloat(self.marksPerAxis),
        centerOffset  = GameBoardView.Thickness.gridLine / CGFloat(2),
        verticalRects = (1..<self.marksPerAxis).map { CGRect(
            x:      self.platformRect.minX + (CGFloat($0) * cellLength) - centerOffset,
            y:      self.platformRect.minY,
            width:  GameBoardView.Thickness.gridLine,
            height: lineLength)
        },
        horizontalRects = (1..<self.marksPerAxis).map { CGRect(
            x:      self.platformRect.minX,
            y:      self.platformRect.minY + (CGFloat($0) * cellLength) - centerOffset,
            width:  lineLength,
            height: GameBoardView.Thickness.gridLine)
        }
        return [verticalRects, horizontalRects].flatMap { $0 }
    }()
    
    func pointsForWinningLineThroughPositions(positions: [GameBoard.Position]) -> (startPoint: CGPoint, endPoint: CGPoint) {
        let
        winningRects = cellRectsAtPositions(positions),
        startRect    = winningRects.first!,
        endRect      = winningRects.last!,
        orientation  = winningLineOrientationForStartRect(startRect, endRect: endRect),
        startPoint   = startPointForRect(startRect, winningLineOrientation: orientation),
        endPoint     = endPointForRect(endRect, winningLineOrientation: orientation)
        return (startPoint, endPoint)
    }
    
    func cellRectsAtPositions(positions: [GameBoard.Position]) -> [CGRect] {
        return positions.map(cellRectAtPosition)
    }
    
    func cellRectAtPosition(position: GameBoard.Position) -> CGRect {
        return cellRectAtRow(position.row, column: position.column)
    }
    
    func cellRectAtRow(row: Int, column: Int) -> CGRect {
        let
        totalLength = platformRect.width,
        cellLength  = totalLength / CGFloat(marksPerAxis),
        leftEdge    = platformRect.minX + CGFloat(column) * cellLength,
        topEdge     = platformRect.minY + CGFloat(row) * cellLength,
        naturalRect = CGRect(x: leftEdge, y: topEdge, width: cellLength, height: cellLength),
        cellRect    = naturalRect.insetUniformlyBy(GameBoardView.Thickness.gridLine)
        return cellRect
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
        let winningRect = rect.insetUniformlyBy(GameBoardView.Thickness.winningLineInset)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerLeft
        case .Vertical:             return winningRect.topCenter
        case .TopLeftToBottomRight: return winningRect.topLeft
        case .BottomLeftToTopRight: return winningRect.bottomLeft
        }
    }
    
    private func endPointForRect(rect: CGRect, winningLineOrientation: WinningLineOrientation) -> CGPoint {
        let winningRect = rect.insetUniformlyBy(GameBoardView.Thickness.winningLineInset)
        switch winningLineOrientation {
        case .Horizontal:           return winningRect.centerRight
        case .Vertical:             return winningRect.bottomCenter
        case .TopLeftToBottomRight: return winningRect.bottomRight
        case .BottomLeftToTopRight: return winningRect.topRight
        }
    }
    
    private let marksPerAxis: Int
    private let frame: CGRect
}
