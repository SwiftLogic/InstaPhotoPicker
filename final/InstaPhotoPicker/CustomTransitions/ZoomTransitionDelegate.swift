//
//  ZoomTransitionDelegate.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import UIKit
@objc protocol ZoomViewController {
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView?
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView?
}

enum TransitionState {
    case initial
    case final
}

import UIKit
class ZoomTransitionDelegate: NSObject {
    private var transitionDuration = 0.5
    private var usingSpringWithDamping: CGFloat = 0.5
    var operation: UINavigationController.Operation = .none
    var contentMode: UIView.ContentMode = .scaleToFill
    var backGroundViewContentMode: UIView.ContentMode = .scaleToFill
    
    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(1.0)
    
    typealias ZoomingViews = (otherView: UIView, imageView: UIView)
    
    func configureViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews) {
        
        switch state {
        case .initial:
            backgroundViewController.view.transform = CGAffineTransform.identity
            backgroundViewController.view.alpha = 1
            snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)
            
        case .final :
            backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
            backgroundViewController.view.alpha = 0
            
            snapshotViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
    }
    
    
}

extension ZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController
        
        if operation == .pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
            
            
        }
        
        let maybeBackgroundImageView = (backgroundViewController as? ZoomViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundViewController as? ZoomViewController)?.zoomingImageView(for: self)
        
        assert(maybeBackgroundImageView != nil, "Cannot find imageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Cannot find imageView in foregroundVC")
        
        let backgroundImageView = maybeBackgroundImageView!
        let foregroundImageView = maybeForegroundImageView!
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        
        
        //works PERFECTLY FOR CONTENT MODES!
        if operation == .push {
            imageViewSnapshot.contentMode = foregroundImageView.contentMode
        } else {
            imageViewSnapshot.contentMode = backgroundImageView.contentMode
        }
        
        
        imageViewSnapshot.layer.masksToBounds = true
        imageViewSnapshot.layer.cornerRadius = backgroundImageView.layer.cornerRadius
        imageViewSnapshot.layer.borderWidth = backgroundImageView.layer.borderWidth
        imageViewSnapshot.layer.borderColor = backgroundImageView.layer.borderColor
        imageViewSnapshot.layer.borderWidth = backgroundImageView.layer.borderWidth
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
        foregroundViewController.view.backgroundColor = UIColor.clear
        containerView.backgroundColor =  foregroundViewBackgroundColor
        
        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(imageViewSnapshot)
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == .pop {
            preTransitionState = .final
            postTransitionState = .initial
        }
        
        configureViews(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
        
        foregroundViewController.view.layoutIfNeeded()
        
       
        
        if operation == .push {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseIn], animations: { [weak self] in
                
                self?.configureViews(for: postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
                
                
            }) { (finished) in
                backgroundViewController.view.transform = CGAffineTransform.identity
                imageViewSnapshot.removeFromSuperview()
                backgroundImageView.isHidden = false
                foregroundImageView.isHidden = false
                foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: { [weak self] in

                self?.configureViews(for: postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
                
                
            }) { (finished) in
                backgroundViewController.view.transform = CGAffineTransform.identity
                imageViewSnapshot.removeFromSuperview()
                backgroundImageView.isHidden = false
                foregroundImageView.isHidden = false
                foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
       
        
        
        
    }
}

extension ZoomTransitionDelegate: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is ZoomViewController && toVC is ZoomViewController {
            self.operation = operation
            return self
        } else {
            return nil
        }
        
    }
    
}





