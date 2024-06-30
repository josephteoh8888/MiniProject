//
//  TriangleView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

//test > try construct triangle uiview
class TriangleView: UIView {
    
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
        shapeLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: width/2, y: width/2))
        path.addLine(to: CGPoint(x: width/2, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))

//        let shape = CAShapeLayer()
        shapeLayer.path = path
//        shapeLayer.fillColor = UIColor.blue.cgColor

        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    func changeFillColor(color: UIColor) {
        shapeLayer.fillColor = color.cgColor
    }
}

//test > human marker with chat bubble like tail
class RightTriangleView: UIView {
    
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
        shapeLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))

//        let shape = CAShapeLayer()
        shapeLayer.path = path

        self.layer.insertSublayer(shapeLayer, at: 0)
    }
}

//test 2
class RightCenterTriangleView: UIView {
    
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
        shapeLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: height/2))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))

//        let shape = CAShapeLayer()
        shapeLayer.path = path

        self.layer.insertSublayer(shapeLayer, at: 0)
    }
}
