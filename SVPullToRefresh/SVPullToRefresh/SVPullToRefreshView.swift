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
    public enum SVPullToRefreshState{
        case Stop
        case Triggered
        case Loading
    }
    
    var internalState: SVPullToRefreshState = .Stop
    var state : SVPullToRefreshState {
        set{
            if internalState != newValue {
                
                let prevoiusState = internalState
                internalState = newValue
                
                setNeedsDisplay()
                layoutIfNeeded()
                
                switch(newValue){
                case .Stop:
                    resetScrollViewContentInset()
                case .Loading:
                    setScrollViewContentInsetForLoading()
                    
                    if prevoiusState == SVPullToRefreshState.Triggered && pullToRefreshHandler != nil
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
    
    
    lazy var arrow : SVPullToRefreshView = {
        [unowned self] in
        
        let _arrow = SVPullToRefreshView(frame: CGRectMake(0, self.bounds.height - 54, 22, 48))
        
        _arrow.backgroundColor = UIColor.clearColor()
        
        return _arrow
    }()
    
    lazy var activityIndicatorView : UIActivityIndicatorView = {
        [unowned self] in
        
        let _activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        
        _activityIndicator.hidesWhenStopped = true
        
        self.addSubview(_activityIndicator)
        
        return _activityIndicator
    }()
    
    
    var pullToRefreshHandler : (()->Void)?
    weak var scrollView : UIScrollView!
    
    
    
    // MARK: - override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //todo:
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //todo:
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        //todo:
    }
    
    public override func layoutSubviews() {
        //todo:
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
    
    func setScrollViewContentInset(insets : UIEdgeInsets){
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.scrollView.contentInset = insets
        }, completion: nil)
    }
    
    func setScrollViewContentInsetForLoading() {
        //todo:
    }
    
    // MARK: - observing
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        //todo:
    }
    
    func scrollViewDidScroll(contentOffset: CGPoint){
        //todo:
    }
    
    
    // MARK: -
    
    func startAnimating(){
        //todo:
    }
    
    func stopAnimating() {
        //todo:
    }
    
    func rotateArrow(degress: Float, hide:Bool){
        //todo:
    }
}