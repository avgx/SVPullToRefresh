//
//  SVInfiniteScrolling.swift
//  SVPullToRefresh
//
//  Created by Wizard Li on 7/1/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation

public extension UIScrollView
{
    private struct AssociatedKey {
        static var InfiniteScrollingViewName = "InifiniteScrollingView"
    }
    
    private struct PrivateKeyName {
        static let InfiniteScrollingViewName = "InifiniteScrollingView"
    }
    
    public var infiniteScrollingView : SVInfiniteScrollingView {
        get{
            return objc_getAssociatedObject(self,
                &AssociatedKey.InfiniteScrollingViewName)
                as! SVInfiniteScrollingView
        }
        
        set
        {
            willChangeValueForKey(PrivateKeyName.InfiniteScrollingViewName)
                
            objc_setAssociatedObject(self,
                &AssociatedKey.InfiniteScrollingViewName,
                newValue as SVInfiniteScrollingView,
                UInt(OBJC_ASSOCIATION_ASSIGN))

        }
    }
    
    public var showsInfiniteScrolling : Bool {
        set{
            infiniteScrollingView.hidden = !newValue
            
            if !newValue
            {
                if infiniteScrollingView.observing {
                    removeObserver(infiniteScrollingView, forKeyPath: "contentOffset")
                    removeObserver(infiniteScrollingView, forKeyPath: "contentSize")
                    infiniteScrollingView.resetScrollViewContentInset()
                    infiniteScrollingView.observing = false
                }
            }
            else
            {
                if !infiniteScrollingView.observing
                {
                    addObserver(infiniteScrollingView,
                        forKeyPath: "contentOffset",
                        options: NSKeyValueObservingOptions.New,
                        context: nil)
                    
                    addObserver(infiniteScrollingView,
                        forKeyPath: "contentSize",
                        options: NSKeyValueObservingOptions.New,
                        context: nil)
                    
                    infiniteScrollingView.observing = true
                }
            }
        }
        
        get {
            return !infiniteScrollingView.hidden
        }
    }
    
    public func addInfiniteScrollingWithActionHandler(handler: ()->Void)
    {
        //todo:
    }
    
    public func triggerInfiniteScrolling()
    {
        //todo:
    }
    
}
