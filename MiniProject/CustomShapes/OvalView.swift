//
//  OvalView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

//test oval shape
class OvalView: UIView {

    let shapeLayer = CAShapeLayer()
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
////        shapeLayer.fillColor = UIColor.ddmDarkGrayColor.cgColor
//        shapeLayer.fillColor = UIColor.black.cgColor
////        shapeLayer.fillColor = UIColor.electricBlueColor.cgColor
//        self.layer.addSublayer(shapeLayer)
        
        //test > try gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        gradientLayer.locations = [
            NSNumber(value: 0.1),
            NSNumber(value: 1.0)
        ]
        gradientLayer.type = .radial
        gradientLayer.colors = [
            UIColor.ddmBlackOverlayColor.cgColor,
            UIColor.clear.cgColor
        ]
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
//        self.shapeLayer.frame = self.bounds
//
//        let width = self.bounds.size.width
//        let height = self.bounds.size.height
//        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: width, height: height))
//        shapeLayer.path = circlePath.cgPath
        
        //test > try gradient layer
        self.gradientLayer.frame = self.bounds
    }
    
}
