//
//  TabStack.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

protocol TabStackDelegate : AnyObject {
    func didClickTabStack(tabCode: String, isSelected: Bool)
}

class TabStack: UIView {
    
    let tabText = UILabel()
    let aArrowBtn = UIImageView()
    let cTabNotifyView = UIView()
    var isSelected = false
    var isNotifyRead = false
    var tabCode = ""
    var isTypeSmall = false
    var isUIChange = true
    var isArrowAdded = true
    var isNotifyFeatureAdded = true
    
    weak var delegate : TabStackDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        
//        self.backgroundColor = .green
        
        tabText.textAlignment = .center
        tabText.textColor = .white //white
        tabText.font = .boldSystemFont(ofSize: 14) //default 14
        self.addSubview(tabText)
        tabText.translatesAutoresizingMaskIntoConstraints = false
//        tabText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true //10, 5
//        tabText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        tabText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        tabText.layer.opacity = 0.5
        
        aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        aArrowBtn.tintColor = .white
//        aArrowBtn.backgroundColor = .red
        self.addSubview(aArrowBtn)
        aArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        aArrowBtn.leadingAnchor.constraint(equalTo: tabText.trailingAnchor).isActive = true
        aArrowBtn.centerYAnchor.constraint(equalTo: tabText.centerYAnchor).isActive = true
        aArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        aArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        aArrowBtn.isHidden = true
        
        cTabNotifyView.backgroundColor = .red
        self.addSubview(cTabNotifyView)
        cTabNotifyView.translatesAutoresizingMaskIntoConstraints = false
        cTabNotifyView.leadingAnchor.constraint(equalTo: tabText.trailingAnchor, constant: 0).isActive = true
        cTabNotifyView.bottomAnchor.constraint(equalTo: tabText.topAnchor, constant: 5).isActive = true //10
        cTabNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        cTabNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        cTabNotifyView.layer.cornerRadius = 5 //10
//        cTabNotifyView.layer.opacity = 0.5
        cTabNotifyView.isHidden = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTabStackClicked)))
    }
    @objc func onTabStackClicked(gesture: UITapGestureRecognizer) {
        delegate?.didClickTabStack(tabCode: tabCode, isSelected: isSelected)
    }
    
    func setTabTypeSmall(isSmall: Bool) {
        isTypeSmall = isSmall
        if(isSmall) {
            tabText.font = .boldSystemFont(ofSize: 13) //default 14
        } else {
            tabText.font = .boldSystemFont(ofSize: 14) //default 14
        }
    }
    
    func setTabTextMargin(isTabWidthFixed: Bool) {
        if(isTabWidthFixed) {
            tabText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        } else {
            tabText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26).isActive = true //20
            tabText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26).isActive = true
        }
    }
    
    func setTabTextMargin(isTabWidthFixed: Bool, margin: CGFloat) {
        if(isTabWidthFixed) {
            tabText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        } else {
            tabText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true //20
            tabText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        }
    }
    
    func setUIChange(isChange: Bool) {
        isUIChange = isChange
        if(isChange) {
            tabText.layer.opacity = 0.5
        } else {
            tabText.layer.opacity = 1.0
        }
    }
    
    func setArrowAdded(isArrowAdd: Bool) {
        isArrowAdded = isArrowAdd
    }
    
    func setNotifyFeature(isNotifyFeature: Bool) {
        isNotifyFeatureAdded = isNotifyFeature
    }
    
    func setShadow() {
        tabText.layer.shadowColor = UIColor.gray.cgColor
        tabText.layer.shadowRadius = 3.0  //ori 3
        tabText.layer.shadowOpacity = 0.5 //ori 1
        tabText.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func setTranslucent() {
        tabText.layer.opacity = 0.5
    }
    
    func selectStack() {
        if(isNotifyFeatureAdded) {
            cTabNotifyView.isHidden = true
            isNotifyRead = true
        }
        
        if(isArrowAdded){
            aArrowBtn.isHidden = false
        }
            
        if(isUIChange) {
            tabText.layer.opacity = 1.0 //0.7
            
            if(!isTypeSmall) {
                tabText.font = .boldSystemFont(ofSize: 15) //default 14
            }
        }
    }
    
    func unselectStack() {
        if(isNotifyFeatureAdded) {
            if(isNotifyRead) {
                cTabNotifyView.isHidden = true
            } else {
                cTabNotifyView.isHidden = false
            }
        }
        
        if(isArrowAdded){
            aArrowBtn.isHidden = true
        }
        
        if(isUIChange) {
            tabText.layer.opacity = 0.5
        
            if(!isTypeSmall) {
                tabText.font = .boldSystemFont(ofSize: 14)
            }
        }
    }
    
    func setText(d: String) {
        tabText.text = d
        tabCode = d
    }
    func setText(code: String, d: String) {
        tabText.text = d
        tabCode = code
    }
}
