//
//  PieChartPresentationController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/02/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import UIKit

class PieChartPresentationController: UIPresentationController {

    fileprivate var blurredView : UIView!
    fileprivate var visualEffectView : UIVisualEffectView!
    
    func prepareAndActivateConstraints(between subview: UIView, and superview: UIView) {
        let equalWidths = NSLayoutConstraint(item: subview,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: superview,
                                             attribute: .width,
                                             multiplier: 1,
                                             constant: 0)
        
        let equalHeights = NSLayoutConstraint(item: subview,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: superview,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: 0)
        
        let equalCenterX = NSLayoutConstraint(item: subview,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: superview,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0)
        
        let equalCenterY = NSLayoutConstraint(item: subview,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: superview,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0)
        
        NSLayoutConstraint.activate([equalWidths, equalHeights, equalCenterX, equalCenterY])
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        let blurEffect = UIBlurEffect(style: .light)

        self.visualEffectView = UIVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false

        self.blurredView = UIView()
        self.blurredView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.blurredView.addSubview(visualEffectView)
        self.containerView?.addSubview(self.blurredView)
        

        self.prepareAndActivateConstraints(between: visualEffectView, and: self.blurredView)
        self.prepareAndActivateConstraints(between: self.blurredView, and: self.containerView!)
        
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            self.visualEffectView.effect = blurEffect
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.visualEffectView.effect = blurEffect
        })
    
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            self.visualEffectView.effect = nil
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.visualEffectView.effect = nil
        })

    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
    }
    
    override func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}
