//
//  ShadowView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class ShadowView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setupViews()
    }
    
    func setupViews() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.opacity = 1.0
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    func setupInvertedViews() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.opacity = 1.0
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradientLayer.frame = self.bounds
    }
}

//test > gradient view
class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setupViews()
    }
    
    func setupViews() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.opacity = 1.0
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.yellow.cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradientLayer.frame = self.bounds
    }
}

class BShadowView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setupViews()
    }
    
    func setupViews() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.opacity = 1.0
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ddmBlackOverlayColor.cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    func setupInvertedViews() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.opacity = 1.0
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ddmBlackOverlayColor.cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradientLayer.frame = self.bounds
    }
}
