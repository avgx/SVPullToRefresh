//
//  SVPullToRefreshArrow.swift
//  SVPullToRefresh
//
//  Created by Wizard Li on 6/30/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

public class SVPullToRefreshArrow : UIView
{
    var internalArrowColor : UIColor?
    
    var arrowColor : UIColor {
        get{
            if let color = internalArrowColor {
                return color
            }
            
            return UIColor.grayColor()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()
        
        // the rects above the arrow
        CGContextAddRect(c, CGRectMake(5, 0, 12, 4)); // to-do: use dynamic points
        CGContextAddRect(c, CGRectMake(5, 6, 12, 4)); // currently fixed size: 22 x 48pt
        CGContextAddRect(c, CGRectMake(5, 12, 12, 4));
        CGContextAddRect(c, CGRectMake(5, 18, 12, 4));
        CGContextAddRect(c, CGRectMake(5, 24, 12, 4));
        CGContextAddRect(c, CGRectMake(5, 30, 12, 4));
        
        // the arrow
        CGContextMoveToPoint(c, 0, 34);
        CGContextAddLineToPoint(c, 11, 48);
        CGContextAddLineToPoint(c, 22, 34);
        CGContextAddLineToPoint(c, 0, 34);
        CGContextClosePath(c);
        
        CGContextSaveGState(c);
        CGContextClip(c);
        
        // Gradient Declaration
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaGradientLocations: [CGFloat] = [0, 0.8];
        
        let alphaGradientColors : CFArray = [arrowColor.colorWithAlphaComponent(0).CGColor,
                arrowColor.colorWithAlphaComponent(1).CGColor]
            
        let alphaGradient = CGGradientCreateWithColors(colorSpace, alphaGradientColors, alphaGradientLocations)
        
        CGContextDrawLinearGradient(c, alphaGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
        
        CGContextRestoreGState(c)
    }
}