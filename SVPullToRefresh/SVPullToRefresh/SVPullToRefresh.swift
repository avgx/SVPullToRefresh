//
//  SVPullToRefresh.swift
//  SVPullToRefresh
//
//  Created by Wizard Li on 6/29/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

    
public enum SVPullToRefreshPosition{
        case Top
        case Bottom
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
    
    private struct Constants{
        static let SVPullToRefreshViewHeight : CGFloat = 60
    }
    
    var showsTopPullToRefresh : Bool{
        set{
            topRefreshView!.hidden = !newValue
            
            if !newValue {
                removeObserverOfRefreshView(topRefreshView!)
            }
            else{
                addObserverOfRefreshView(topRefreshView!)
            }
        }
        
        get{
            return !(topRefreshView!.hidden)
        }
    }
    
    var showsBottomPullToRefresh : Bool{
        set{
            bottomRefreshView!.hidden = !newValue
            
            if !newValue {
                removeObserverOfRefreshView(bottomRefreshView!)
            }
            else{
                addObserverOfRefreshView(bottomRefreshView!)
            }
        }
        
        get{
            return !(bottomRefreshView!.hidden)
        }
    }
    
    func addObserverOfRefreshView(refreshView: SVPullToRefreshView)
    {
        if !refreshView.isObserving {
            addObserver(refreshView, forKeyPath: "ContentOffset",
                options: NSKeyValueObservingOptions.New, context: nil)
            addObserver(refreshView, forKeyPath: "contentSize",
                options: NSKeyValueObservingOptions.New, context: nil)
            addObserver(refreshView, forKeyPath: "frame",
                options: NSKeyValueObservingOptions.New, context: nil)
            
            refreshView.isObserving = true
            
            var yOrigin : CGFloat = 0
            
            switch(refreshView.position)
            {
            case .Top:
                yOrigin = -Constants.SVPullToRefreshViewHeight
            case .Bottom:
                yOrigin = contentSize.height
            }
            
            refreshView.frame = CGRectMake(0, yOrigin, bounds.width, bounds.height)
        }
    }
    
    func removeObserverOfRefreshView(refreshView: SVPullToRefreshView)
    {
        if refreshView.isObserving {
            removeObserver(refreshView, forKeyPath: "contentOffset")
            removeObserver(refreshView, forKeyPath: "contentSize")
            removeObserver(refreshView, forKeyPath: "frame")
            
            refreshView.resetScrollViewContentInset()
            refreshView.isObserving = false
        }
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
        
        func addHeaderView(headerView: SVPullToRefreshView){
            headerView.pullToRefreshHandler = handler
            headerView.scrollView = self
            headerView.originalTopInset = contentInset.top
            headerView.originalBottomInset = contentInset.bottom
            
            addSubview(headerView)
        }
        
        switch(position){
            
        case .Top:
            if topRefreshView == nil {
                let headerView = SVPullToRefreshView(frame: CGRectMake(0,
                    -Constants.SVPullToRefreshViewHeight,
                    bounds.width,
                    Constants.SVPullToRefreshViewHeight))
                
                headerView.position = position
                
                addHeaderView(headerView)
                topRefreshView = headerView
                
                showsTopPullToRefresh = true
            }
            
        case .Bottom:
            if bottomRefreshView == nil {
                let headerView = SVPullToRefreshView(frame: CGRectMake(0,
                    contentSize.height,
                    bounds.width,
                    Constants.SVPullToRefreshViewHeight))
                
                headerView.position = position
                
                addHeaderView(headerView)
                bottomRefreshView = headerView
                
                showsBottomPullToRefresh = true
            }
        }
    }
    
    public func triggerPullToRefresh(position:SVPullToRefreshPosition)
    {
        var pullToRefreshView : SVPullToRefreshView!
        
        switch(position)
        {
        case .Top:
            pullToRefreshView = topRefreshView
        case .Bottom:
            pullToRefreshView = bottomRefreshView
        }
        
        pullToRefreshView.startAnimating()
    }
}














































