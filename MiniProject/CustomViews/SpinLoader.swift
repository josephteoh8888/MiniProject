//
//  SpinLoader.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class SpinLoader: UIView {
    var viewSize: CGFloat = 0
    var viewLineWidth: CGFloat = 0
    var viewGap: CGFloat = 0
    var viewLineColor: UIColor = .white
    
    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewSize = frame.width
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConfiguration(size: CGFloat, lineWidth: CGFloat, gap:CGFloat, color: UIColor) {
        viewSize = size
        viewLineWidth = lineWidth
        viewGap = gap
        viewLineColor = color
    }
    
    func setupAnimation() {
        layer.sublayers = nil
        
//        let duration: CFTimeInterval = 0.75 //default 0.75
        let duration: CFTimeInterval = 1.5 //default 0.75
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [rotateAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw circle
        let circle = layerWith(size: CGSize(width: viewSize, height: viewSize), color: viewLineColor)
//        let frame = CGRect(x: (layer.bounds.size.width - viewSize) / 2,
//                           y: (layer.bounds.size.height - viewSize) / 2,
//                           width: viewSize,
//                           height: viewSize)
        let frame = CGRect(x: 0,
                           y: 0,
                           width: viewSize,
                           height: viewSize)

        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
        
        // Draw circle 2
        // Rotate animation
        let duration2: CFTimeInterval = 0.75
        let rotateAnimation2 = CAKeyframeAnimation(keyPath: "transform.rotation.z")

        rotateAnimation2.keyTimes = [0, 0.5, 1]
        rotateAnimation2.values = [0, -Double.pi, -2 * Double.pi]
//        rotateAnimation2.values = [0, Double.pi, 2 * Double.pi]

        // Animation
        let animation2 = CAAnimationGroup()

        animation2.animations = [rotateAnimation2]
        animation2.timingFunction = CAMediaTimingFunction(name: .linear)
        animation2.duration = duration2
        animation2.repeatCount = HUGE
        animation2.isRemovedOnCompletion = false
        
        let viewSize2 = viewSize - viewGap
        let circle2 = layerWith(size: CGSize(width: viewSize2, height: viewSize2), color: viewLineColor)
//        let frame2 = CGRect(x: (layer.bounds.size.width - viewSize2) / 2,
//                           y: (layer.bounds.size.height - viewSize2) / 2,
//                           width: viewSize2,
//                           height: viewSize2)
        let frame2 = CGRect(x: viewGap/2,
                           y: viewGap/2,
                           width: viewSize2,
                           height: viewSize2)

        circle2.frame = frame2
        circle2.add(animation2, forKey: "animation")
        layer.addSublayer(circle2)
    }
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
//        let lineWidth: CGFloat = 2
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: CGFloat(-3 * Double.pi / 4),
                    endAngle: CGFloat(-Double.pi / 4),
                    clockwise: false)
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = viewLineWidth
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
    
    func startAnimating() {
//        layer.speed = 1
//        setupAnimation()
        
        //test
        if(!isAnimating) {
            layer.speed = 1
            setupAnimation()
        }
        isAnimating = true //test
    }
    
    func stopAnimating() {
        
//        layer.sublayers?.removeAll()
        
        //test
        if(isAnimating) {
            layer.sublayers?.removeAll()
        }
        isAnimating = false //test
    }
}
