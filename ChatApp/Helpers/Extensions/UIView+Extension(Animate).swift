//
//  UIView+Extension(Animate).swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 03.05.2023.
//

import UIKit

extension UIView {
    
    func startShakeAnimation() {
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        let angle = CGFloat.pi / 10
        rotateAnimation.values = [angle, -angle]
        
        let moveAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        let secondPosition = CGPoint(x: self.layer.position.x + 5, y: self.layer.position.y + 5)
        let thirdPosition = CGPoint(x: self.layer.position.x - 5, y: self.layer.position.y - 5)
        moveAnimation.values = [secondPosition, thirdPosition]
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.animations = [rotateAnimation, moveAnimation]
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            let rotationTransform = CGAffineTransform(rotationAngle: angle)
            let moveTransform = CGAffineTransform(translationX: 5, y: 5)
            self.transform = rotationTransform.concatenating(moveTransform)
        } completion: { _ in
            self.transform = .identity
            self.layer.add(group, forKey: "shakeAndMove")
        }
    }
    
    func stopShakeAnimation() {
        guard let presentationLayer = self.layer.presentation() else { return }
        let currentTransform = presentationLayer.transform
        self.layer.removeAllAnimations()
        self.transform = CATransform3DGetAffineTransform(currentTransform)
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = .identity
        })
    }
}
