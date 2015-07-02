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
    var distanceToBottom : CGFloat = 49
    
    var internalState : SVInfiniteScrollingState = .Stopped
//    {
//        didSet{
//            println("set state : \(internalState)")
//        }
//    }
    
    var state : SVInfiniteScrollingState{
        get{
            return internalState
        }
        
        set{
            if internalState != newValue
            {
                let previous = internalState
                internalState = newValue
                
                activityIndicatorView.center = CGPointMake(bounds.width/2, bounds.height/2)
                switch newValue
                {
                case .Stopped:
                    activityIndicatorView.stopAnimating()
                case .Triggered:
                    activityIndicatorView.startAnimating()
                case .Loading:
                    activityIndicatorView.startAnimating()
                }
                
                if previous == .Triggered && newValue == .Loading && infiniteScrollingHandler != nil && enabled {
                    infiniteScrollingHandler!()
                }
            }
        }
    }
    
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
    var originalBottomInset : CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()
    {
        enabled = true
        autoresizingMask = UIViewAutoresizing.FlexibleWidth
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if superview != nil && newSuperview == nil {
            let scrollView = superview as! UIScrollView
            if scrollView.showsInfiniteScrolling  && observing{
                scrollView.removeObserver(self, forKeyPath: "contentOffset")
                scrollView.removeObserver(self, forKeyPath: "contentSize")
                observing = false
            }
        }
    }
    
    public override func layoutSubviews() {
        activityIndicatorView.center = CGPointMake(bounds.width/2, bounds.height/2)
    }
    
    
    public func startAnimating()
    {
        state = .Loading
    }
    
    public func stopAnimating()
    {
        state = .Stopped
    }
    
    func resetScrollViewContentInset()
    {
        var currentInsets = scrollView.contentInset
        currentInsets.bottom = originalBottomInset
        setScrollViewContentInset(currentInsets)
    }
    
    func setScrollViewContentInsetForInfiniteScrolling()
    {
        var currentInsets = scrollView.contentInset
        currentInsets.bottom = originalBottomInset + SVInfiniteScrollingConstants.SVInfiniteScrollingViewHeight
        setScrollViewContentInset(currentInsets)
    }
    
    func setScrollViewContentInset(insets: UIEdgeInsets)
    {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.BeginFromCurrentState,
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
            let scrollOffsetThreshold = max(scrollView.contentSize.height - scrollView.bounds.height - distanceToBottom, 0)
            
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