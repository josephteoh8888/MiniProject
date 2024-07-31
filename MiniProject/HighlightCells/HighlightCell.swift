//
//  HighlightCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class HighlightCell: UIView {
//    weak var delegate : HighlightDelegate?
    weak var delegate : HighlightCellDelegate?
}

protocol HighlightCellDelegate : AnyObject {
    func hcWillBeginDragging(offsetY: CGFloat)
    func hcScrollViewDidScroll(offsetY: CGFloat)
    func hcSrollViewDidEndDecelerating(offsetY: CGFloat)
    func hcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool)
    
    func didHighlightClickUser(id: String)
    func didHighlightClickPlace(id: String)
    func didHighlightClickSound(id: String)
    
    func didHighlightClickRefresh() //for refresh profile
}

////test > design for user fetch data error
//class FetchErrorHighlightCell: HighlightCell {
////class UserFetchErrorHighlightCell: UIView {
//    
//    let aHLightRect1 = UIView()
//    var viewHeight: CGFloat = 0
//    var viewWidth: CGFloat = 0
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        viewWidth = frame.width
//        viewHeight = frame.height
//        setupViews()
//        
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        setupViews()
//    }
//    
//    func setupViews() {
//        //move to redrawUI()
//    }
//    
//    func redrawUI() {
//        
//        self.addSubview(aHLightRect1)
//        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
//        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
//        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
//        
//        let aHLightRectBG = UIView()
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
//        aHLightRect1.addSubview(aHLightRectBG)
//        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.0 //0.2
//        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
//        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
//        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
//        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
//        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
//        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .center
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
////        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
////        aHLightTitle.text = "Post Status"
//        aHLightTitle.text = "Error Loading Data"
//
//        let aHSubDesc = UILabel()
//        aHSubDesc.textAlignment = .center
//        aHSubDesc.textColor = .white //white
//        aHSubDesc.font = .systemFont(ofSize: 13)
////        aHLightSection.addSubview(aHSubDesc)
//        aHLightRect1.addSubview(aHSubDesc)
//        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
////        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
//        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //10
////        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
//        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        aHSubDesc.text = "Something went wrong. Try again."
////                aHSubDesc.layer.opacity = 0.7
//        
//        let aBtn = UIView()
////        aBtn.backgroundColor = .yellow //test to remove color
//        aBtn.backgroundColor = .ddmDarkColor //test to remove color
//        aHLightRect1.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
//        aBtn.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true
//        aBtn.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
//        aBtn.layer.cornerRadius = 20
////        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRefreshClicked)))
//
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
////        bMiniBtn.tintColor = .black
//        bMiniBtn.tintColor = .white
//        aBtn.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//    }
//    
//    @objc func onRefreshClicked(gesture: UITapGestureRecognizer) {
//        self.delegate?.didHighlightClickRefresh()
//    }
//}
