//
//  CGContextExtension.swift
//  TicTacToeApp
//
//  Created by Joshua Smith on 12/18/15.
//  Copyright © 2015 iJoshSmith. All rights reserved.
//

import UIKit

internal extension CGContext {
    func strokeLineFrom(from: CGPoint, to: CGPoint, color: UIColor, width: CGFloat, lineCap: CGLineCap) {
        CGContextSetStrokeColorWithColor(self, color.CGColor)
        CGContextSetLineWidth(self, width)
        CGContextSetLineCap(self, lineCap)
        
        CGContextMoveToPoint(self, from.x, from.y)
        CGContextAddLineToPoint(self, to.x, to.y)
        CGContextStrokePath(self)
    }
    
    func fillRect(rect: CGRect, color: UIColor) {
        CGContextSetFillColorWithColor(self, color.CGColor)
        CGContextFillRect(self, rect)
        CGContextStrokePath(self)
    }
    
    func strokeRect(rect: CGRect, color: UIColor, width: CGFloat) {
        CGContextSetLineWidth(self, width)
        CGContextSetStrokeColorWithColor(self, color.CGColor)
        CGContextAddRect(self, rect)
        CGContextStrokePath(self)
    }
    
    func strokeEllipseInRect(rect: CGRect, color: UIColor, width: CGFloat) {
        CGContextSetStrokeColorWithColor(self, color.CGColor)
        CGContextSetLineWidth(self, width)
        CGContextAddEllipseInRect(self, rect)
        CGContextStrokePath(self)
    }
}
