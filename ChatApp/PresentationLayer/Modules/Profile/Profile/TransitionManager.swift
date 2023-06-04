//
//  TransitionManager.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.05.2023.
//

import UIKit

enum TransitionType {
    case present
    case dismiss
}

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration = 0.3

    var transitionType: TransitionType = .present
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var startFrame: CGRect = .zero
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        return imageView
    }()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
    
        switch transitionType {
        case .present:
            if let presentedView = transitionContext.view(forKey: .to) {
                imageView.frame = startFrame
                presentedView.alpha = 0
                containerView.addSubview(imageView)
                containerView.addSubview(presentedView)
                
                UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        self.imageView.transform = .identity
                        self.imageView.frame.origin.y = 76 + UIView.topSafeAreaInsets
                        presentedView.alpha = 1
                    }
                } completion: { completed in
                    transitionContext.completeTransition(completed)
                }
            }
        case .dismiss:
            if let returnedView = transitionContext.view(forKey: .from) {
                returnedView.removeFromSuperview()
                UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        self.imageView.transform = .identity
                        self.imageView.frame = self.startFrame
                    }
                } completion: { _ in
                    self.imageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}
