//
//  SVPullToRefresh.swift
//  SVPullToRefresh
//
//  Created by Wizard Li on 6/29/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

public class SVPullToRefreshView{
    
}

public extension UIScrollView {
    private struct AssociatedKeys{
        static var TopRefreshViewName = "SVPullToRefreshViewTop"
        static var BottomRefreshViewName = "SVPullToRefreshViewBottom"
    }
    
    private struct PrivateKeyName{
        static let TopRefreshViewKeyName = "SVPullToRefreshViewTop"
        static let BottomRefreshViewKeyName = "SVPullToRefreshViewBottom"
    }
    
    public enum SVPullToRefreshPosition{
        case SVPullToRefreshPositionTop
        case SVPullToRefreshPositionBottom
    }
    
    var topRefreshView : SVPullToRefreshView? {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.TopRefreshViewName) as? SVPullToRefreshView
        }
        
        set{
            willChangeValueForKey(PrivateKeyName.TopRefreshViewKeyName)
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.TopRefreshViewName,
                    newValue as SVPullToRefreshView?, UInt(OBJC_ASSOCIATION_ASSIGN))
            }
            didChangeValueForKey(PrivateKeyName.TopRefreshViewKeyName)
        }
    }
    
    var bottomRefreshView : SVPullToRefreshView? {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.BottomRefreshViewName) as? SVPullToRefreshView
        }
        
        set{
            willChangeValueForKey(PrivateKeyName.BottomRefreshViewKeyName)
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.BottomRefreshViewName,
                    newValue as SVPullToRefreshView?, UInt(OBJC_ASSOCIATION_ASSIGN))
            }
            didChangeValueForKey(PrivateKeyName.BottomRefreshViewKeyName)
        }
    }

    public func addPullToRefreshWithAction(handler: ()->Void, withPosition position:SVPullToRefreshPosition){
        println("add Pull to refresh with action")
        switch(position){
        case .SVPullToRefreshPositionTop:
            if topRefreshView == nil {
                println("top refresh view is empty")
            }
        case .SVPullToRefreshPositionBottom:
            if bottomRefreshView == nil {
                println("bottom refresh view is empty")
            }
        }
    }
}
