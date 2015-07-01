//
//  SVPullToRefreshView.swift
//  SVPullToRefresh
//
//  Created by Wizard Li on 6/29/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

public class SVPullToRefreshView : UIView{
    
    func fequalzero(value: CGFloat) -> Bool{
        return Float(fabs(value)) < FLT_EPSILON
    }
    
    func fequal(value1: CGFloat, _ value2: CGFloat) -> Bool{
        return fabs(Float(value1) - Float(value2)) < FLT_EPSILON
    }
    
    public enum SVPullToRefreshState: Printable{
        case Stop
        case Triggered
        case Loading
        
        public var description : String {
            get{
                switch(self){
                case .Stop:
                    return "Stop"
                case .Loading:
                    return "Loading"
                case .Triggered:
                    return "Triggered"
                }
            }
        }
    }
    
    var state : SVPullToRefreshState {
        set{
            if internalState != newValue {
                
                let prevoiusState = internalState
                internalState = newValue
                
                setNeedsLayout()
                layoutIfNeeded()
                
                switch(newValue){
                case .Stop:
                    resetScrollViewContentInset()
                case .Loading:
                    setScrollViewContentInsetForLoading()
                    
                    if prevoiusState == SVPullToRefreshState.Triggered
                        && pullToRefreshHandler != nil
                    {
                        pullToRefreshHandler!()
                    }
                case .Triggered:
                    break
                }
            }
        }
        
        get{
            return internalState
        }
    }
    
    var position = SVPullToRefreshPosition.Top
    var originalTopInset : CGFloat = 0
    var originalBottomInset : CGFloat = 0
    var isObserving : Bool = false
    
    var activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    var textColor = UIColor.darkGrayColor()
    var internalState: SVPullToRefreshState = .Stop {
        didSet{
            println("set internal state:\(internalState)")
        }
    }
    var showsDateLabel = false
    var wasTriggeredByUser : Bool = true
    
    
    lazy var arrow : SVPullToRefreshArrow = {
        [unowned self] in
        
        let _arrow = SVPullToRefreshArrow(frame: CGRectMake(0, self.bounds.height - 54, 22, 48))
        
        _arrow.backgroundColor = UIColor.clearColor()
        
        self.addSubview(_arrow)
        
        return _arrow
    }()
    
    lazy var activityIndicatorView : UIActivityIndicatorView = {
        [unowned self] in
        
        let _activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorViewStyle)
        
        _activityIndicator.hidesWhenStopped = true
        
        self.addSubview(_activityIndicator)
        
        return _activityIndicator
    }()
    
    
    var pullToRefreshHandler : (()->Void)?
    weak var scrollView : UIScrollView!
    
    
    
    // MARK: - override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setup()
    {
        autoresizingMask = UIViewAutoresizing.FlexibleWidth
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if superview != nil && newSuperview == nil {
            if let scrollView = superview as? UIScrollView {
                var isShowing : Bool = false
                switch(position)
                {
                case .Bottom:
                    isShowing = scrollView.showsBottomPullToRefresh
                case .Top:
                    isShowing = scrollView.showsTopPullToRefresh
                }
                
                if isShowing
                {
                    scrollView .removeObserver(self, forKeyPath: "contentOffset")
                    scrollView .removeObserver(self, forKeyPath: "contentOffset")
                    scrollView .removeObserver(self, forKeyPath: "contentOffset")
                    isObserving = false
                }
            }
        }
    }
    
    // todo: need improve
    public override func layoutSubviews() {

        println("layout subviews : state : \(state)")
        switch(state)
        {
        case .Stop:
            arrow.alpha = 1
            activityIndicatorView.stopAnimating()
            switch(position)
            {
            case .Top:
                rotateArrow(0, hide: false)
            case .Bottom:
                rotateArrow(CGFloat(M_PI), hide: false)
            }
            
        case .Triggered:
            switch(position)
            {
            case .Top:
                rotateArrow(CGFloat(M_PI), hide: false)
            case .Bottom:
                rotateArrow(0, hide: false)
            }
            
        case .Loading:
            activityIndicatorView.startAnimating()
            
            switch(position)
            {
            case .Top:
                rotateArrow(0, hide: true)
            case .Bottom:
                rotateArrow(CGFloat(M_PI), hide: true)
            }
        }
        
        let width = max(arrow.bounds.width, activityIndicatorView.bounds.width)
        arrow.center = CGPointMake(bounds.width / 2 , bounds.height / 2)
        activityIndicatorView.center = arrow.center
    }
    
    // MARK: - scroll view
    func resetScrollViewContentInset(){
        var currentInsets = scrollView.contentInset
        
        switch(position){
        case .Top:
            currentInsets.top = originalTopInset
        case .Bottom:
            currentInsets.bottom = originalBottomInset
        }
        
        setScrollViewContentInset(currentInsets)
    }
    
    func setScrollViewContentInset(insets : UIEdgeInsets)
    {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { () -> Void in
                self.scrollView.contentInset = insets
            },
            completion: nil)
    }
    
    func setScrollViewContentInsetForLoading() {
        let offset = max(-scrollView.contentOffset.y , 0)
        var currentInsets = scrollView.contentInset
        
        switch(position){
        case .Top:
            currentInsets.top = min(offset, originalTopInset + bounds.size.height)
        case .Bottom:
            currentInsets.bottom = min(offset, originalBottomInset + bounds.size.height)
        }
        
        setScrollViewContentInset(currentInsets)
    }
    
    // MARK: - observing
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        switch (keyPath)
        {
        case "contentOffset":
            scrollViewDidScroll(change[NSKeyValueChangeNewKey]!.CGPointValue())
            
        case "contentSize":
            layoutSubviews()
            
            var yOrigin : CGFloat = 0.0
            switch(position)
            {
            case .Top:
                yOrigin = -SVPullToRefreshConstants.SVPullToRefreshViewHeight
            case .Bottom:
                yOrigin = max(scrollView.contentSize.height, scrollView.bounds.height)
            }
            
            frame = CGRectMake(0, yOrigin, bounds.width, bounds.height)
            
        case "frame":
            layoutSubviews()
            
        default:
            break
        }
    }
    
    func scrollViewDidScroll(contentOffset: CGPoint)
    {
        if state != .Loading
        {
            var scrollOffsetThread : CGFloat
            
            switch(position)
            {
            case .Top:
                scrollOffsetThread = frame.origin.y - originalTopInset
            case .Bottom:
                scrollOffsetThread = max(scrollView.contentSize.height - scrollView.bounds.height, 0) + bounds.size.height + originalBottomInset
            }
            
            if !scrollView.dragging && state == .Triggered
            {
                state = .Loading
            }
            else if contentOffset.y < scrollOffsetThread && scrollView.dragging && state == .Stop && position == .Top {
                state = .Triggered
            }
            else if contentOffset.y >= scrollOffsetThread && state != .Stop && position == .Top {
                state = .Stop
            }
            else if contentOffset.y > scrollOffsetThread && scrollView.dragging && state == .Stop && position == .Bottom {
                state = .Triggered
            }
            else if contentOffset.y <= scrollOffsetThread && state != .Stop && position == .Bottom {
                state = .Stop
            }
        }
        else
        {
            var offset : CGFloat
            var contentInset : UIEdgeInsets
            
            switch(position)
            {
            case .Top:
                offset = max( -scrollView.contentOffset.y, 0)
                offset = min(offset, originalTopInset + bounds.height)

                contentInset = scrollView.contentInset
                
                scrollView.contentInset = UIEdgeInsetsMake(offset,
                    contentInset.left,
                    contentInset.bottom,
                    contentInset.right)
                
            case .Bottom:
                if scrollView.contentSize.height >= scrollView.bounds.height
                {
                    offset = max(scrollView.contentSize.height - scrollView.bounds.height + bounds.height, 0.0)
                    offset = min(offset, originalBottomInset + bounds.height)

                    contentInset = scrollView.contentInset
                    
                    scrollView.contentInset = UIEdgeInsetsMake(contentInset.top,
                        contentInset.left,
                        offset,
                        contentInset.right)
                }
                else if (wasTriggeredByUser)
                {
                    offset = min(bounds.size.height, originalBottomInset + bounds.size.height)
                    contentInset = scrollView.contentInset
                    scrollView.contentInset = UIEdgeInsetsMake(-offset,
                        contentInset.left,
                        contentInset.bottom,
                        contentInset.right)
                }
            }
        }
    }
    
    
    // MARK: -
    
    public func startAnimating(){
        switch(position)
        {
        case .Top:
            if fequalzero(scrollView.contentOffset.y) {
                scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, -frame.height), animated: true)
                wasTriggeredByUser = false
            }
            else {
                wasTriggeredByUser = true
            }
        case .Bottom:
            if fequalzero(scrollView.contentOffset.y) && scrollView.contentSize.height < scrollView.bounds.height
                || fequal(scrollView.contentOffset.y, scrollView.contentSize.height - scrollView.bounds.height)
            {
                let x = scrollView.contentOffset.x
                let y = max(scrollView.contentSize.height - scrollView.bounds.height, 0.0) + frame.height
                scrollView.setContentOffset(CGPointMake(x, y), animated: true)
                wasTriggeredByUser = false
            }
            else{
                wasTriggeredByUser = true
            }
        }
        
        state = .Loading
    }
    
    public func stopAnimating() {
        state = .Stop
        
        switch(position){
        case .Top:
            if !wasTriggeredByUser {
                scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, -originalTopInset), animated: true)
            }
        case .Bottom:
            if !wasTriggeredByUser {
                scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x,scrollView.contentSize.height - scrollView.bounds.height + originalBottomInset), animated: true)
            }
        }
    }
    
    func rotateArrow(degrees: CGFloat, hide:Bool){
        UIView.animateWithDuration(0.2,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { () -> Void in
                self.arrow.layer.opacity = hide ? 0 : 1
                self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1)
            },
            completion: nil)
    }
}