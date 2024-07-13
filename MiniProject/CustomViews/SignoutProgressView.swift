//
//  SignoutProgressView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 12/07/2024.
//

import Foundation
import UIKit

class SignoutProgressView: UIView{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let viewBoundView = UIView()
    let semiTransparentSpinner = SpinLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(viewBoundView)
        viewBoundView.translatesAutoresizingMaskIntoConstraints = false
        viewBoundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        viewBoundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewBoundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        viewBoundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        getLocationPromptMsg.isHidden = true

        let getLocationPromptMsgBG = UIView()
        viewBoundView.addSubview(getLocationPromptMsgBG)
        getLocationPromptMsgBG.backgroundColor = .ddmBlackOverlayColor
        getLocationPromptMsgBG.layer.opacity = 0.3
        getLocationPromptMsgBG.translatesAutoresizingMaskIntoConstraints = false
        getLocationPromptMsgBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        getLocationPromptMsgBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        getLocationPromptMsgBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        getLocationPromptMsgBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let semiTransparentBg = UIView()
        viewBoundView.addSubview(semiTransparentBg)
        semiTransparentBg.backgroundColor = .ddmDarkColor
        semiTransparentBg.translatesAutoresizingMaskIntoConstraints = false
        semiTransparentBg.centerYAnchor.constraint(equalTo: viewBoundView.centerYAnchor).isActive = true
        semiTransparentBg.centerXAnchor.constraint(equalTo: viewBoundView.centerXAnchor).isActive = true
        semiTransparentBg.heightAnchor.constraint(equalToConstant: 100).isActive = true
        semiTransparentBg.widthAnchor.constraint(equalToConstant: 100).isActive = true
        semiTransparentBg.layer.cornerRadius = 10
        
        semiTransparentBg.addSubview(semiTransparentSpinner)
        semiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        semiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
        semiTransparentSpinner.centerYAnchor.constraint(equalTo: semiTransparentBg.centerYAnchor, constant: 0).isActive = true
        semiTransparentSpinner.centerXAnchor.constraint(equalTo: semiTransparentBg.centerXAnchor).isActive = true
        semiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        semiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        semiTransparentSpinner.startAnimating()
    }
    
    func closePanel(isAnimated: Bool) {
        
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            }, completion: { _ in
                
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
}
