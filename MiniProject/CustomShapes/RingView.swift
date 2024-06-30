//
//  RingView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class RingView: QueueableView {
//class RingView: UIView {

    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
            
        self.layer.addSublayer(shapeLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.shapeLayer.frame = self.bounds
        
        let size = self.bounds.size.width
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2), radius: CGFloat(size/2), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        shapeLayer.path = circlePath.cgPath
    }
    
    func changeLineWidth(width: CGFloat) {
        shapeLayer.lineWidth = width
    }
    
    //default stroke color is white
    func changeStrokeColor(color: UIColor) {
        shapeLayer.strokeColor = color.cgColor
    }
    
}

