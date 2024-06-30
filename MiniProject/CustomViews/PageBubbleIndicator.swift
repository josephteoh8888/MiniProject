//
//  PageBubbleIndicator.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class PageBubbleIndicator: UIView {
    
    var indicatorNumber: Int = 0
    var indicatorColor: UIColor = .white
    var indicatorViewList = [UIView]()
    let box = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConfiguration(number: Int, color: UIColor) {
        indicatorNumber = number
        indicatorColor = color
        
        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        for number in 0...indicatorNumber - 1 {
            let aTab1 = UIView()
            aTab1.backgroundColor = .white
//            aTab1.backgroundColor = .yellow
            box.addSubview(aTab1)
            aTab1.translatesAutoresizingMaskIntoConstraints = false
            if(indicatorViewList.isEmpty) {
                aTab1.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 0).isActive = true //10
            } else {
                aTab1.leadingAnchor.constraint(equalTo: indicatorViewList[indicatorViewList.count - 1].trailingAnchor, constant: 5).isActive = true //10
            }
//            aTab1.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
            aTab1.topAnchor.constraint(equalTo: box.topAnchor).isActive = true
            aTab1.bottomAnchor.constraint(equalTo: box.bottomAnchor).isActive = true
            aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
            aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
            aTab1.layer.opacity = 0.5 //0.5
            aTab1.layer.cornerRadius = 1
            indicatorViewList.append(aTab1)
        }
        if(!indicatorViewList.isEmpty) {
            let lastArrayE = indicatorViewList[indicatorViewList.count - 1]
            lastArrayE.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: 0).isActive = true
        }
    }
    
    func setIndicatorSelected(index: Int) {
        if(!indicatorViewList.isEmpty) {
            for indicator in indicatorViewList {
                indicator.backgroundColor = .white
                indicator.layer.opacity = 0.5
            }
            indicatorViewList[index].backgroundColor = indicatorColor
            indicatorViewList[index].layer.opacity = 1.0 //0.5
        }
    }
}
