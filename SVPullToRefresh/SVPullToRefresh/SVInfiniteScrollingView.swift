//
//  SVInfiniteScrollingView.swift
//  SVPullToRefresh
//
//  Created by Wizard Li on 7/1/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation

public struct SVInfiniteScrollingConstants{
    static let SVInfiniteScrollingViewHeight : CGFloat = 60
}

public class SVInfiniteScrollingView : UIView
{
    public enum SVInfiniteScrollingState : Printable
    {
        case Stopped
        case Triggered
        case Loading
        
        public var description : String {
            get{
                switch(self){
                case .Stopped:
                    return "Stopped"
                case .Loading:
                    return "Loading"
                case .Triggered:
                    return "Triggered"
                }
            }
        }
    }
    
    var observing : Bool = false
    
    var state : SVInfiniteScrollingState = .Stopped
    
    public var activityIndicatorViewStyle : UIActivityIndicatorViewStyle {
        get {
            return activityIndicatorView.activityIndicatorViewStyle
        }
        
        set {
            activityIndicatorView.activityIndicatorViewStyle = newValue
        }
    }
    
    public var enabled : Bool = false
    
    var infiniteScrollingHandler : (()->Void)?
    
    weak var scrollView : UIScrollView!

    lazy var activityIndicatorView : UIActivityIndicatorView = {
        [unowned self] in
        
        let _indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        _indicator.hidesWhenStopped = true
        
        self.addSubview(_indicator)
        
        return _indicator
    }()
    
    var wasTriggeredByUser : Bool = true
    
    public func startAnimating()
    {
        //todo:
    }
    
    public func stopAnimating()
    {
        //todo:
    }
    
    func resetScrollViewContentInset()
    {
        //todo:
    }
    
    func setScrollViewContentInsetForInfiniteScrolling()
    {
        //todo:
    }
    
    func setScrollViewContentInset(insets: UIEdgeInsets)
    {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { () -> Void in
                self.scrollView.contentInset = insets
            },
            completion: nil)
    }
    
    // MARK: - observing
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        switch(keyPath)
        {
        case "contentOffset":
            scrollViewDidScroll(change[NSKeyValueChangeNewKey]!.CGPointValue())
        case "contentSize":
            layoutSubviews()
            frame = CGRectMake(0, scrollView.contentSize.height, bounds.width, SVInfiniteScrollingConstants.SVInfiniteScrollingViewHeight)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(contentOffset : CGPoint)
    {
        if state != .Loading && enabled {
            let scrollViewContentHeight = scrollView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - scrollView.bounds.height
            
            if !scrollView.dragging && state == .Triggered {
                state = .Loading
            }
            else if contentOffset.y > scrollOffsetThreshold && state == .Stopped && scrollView.dragging{
                state = .Triggered
            }
            else if contentOffset.y < scrollOffsetThreshold && state != .Stopped {
                state = .Stopped
            }
        }
    }
    
}