//
//  PostClipPhotoCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PostClipPhotoCellDelegate : AnyObject {
    func didClickPostClipCell(cell: PostClipPhotoCell)
}

class PostClipPhotoCell: UIView {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aHLightRect1 = UIView()
    weak var aDelegate : PostClipPhotoCellDelegate?
    
    var isSelected = false
    let selectedRect = UIView()
    
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
        //move to redrawUI()
    }
    
    func redrawUI() {
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        aHLightRect1.backgroundColor = .clear
        aHLightRect1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickPostClipPhotoClicked)))
        
        selectedRect.backgroundColor = .ddmGoldenYellowColor
//        selectedRect.backgroundColor = .clear
        aHLightRect1.addSubview(selectedRect)
        selectedRect.translatesAutoresizingMaskIntoConstraints = false
        selectedRect.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //0
        selectedRect.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
        selectedRect.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        selectedRect.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        selectedRect.layer.cornerRadius = 10
        selectedRect.isHidden = true
        
        let panelBG = UIView()
        panelBG.backgroundColor = .ddmBlackOverlayColor
        selectedRect.addSubview(panelBG)
        panelBG.translatesAutoresizingMaskIntoConstraints = false
        panelBG.leadingAnchor.constraint(equalTo: selectedRect.leadingAnchor, constant: 2).isActive = true
        panelBG.topAnchor.constraint(equalTo: selectedRect.topAnchor, constant: 2).isActive = true //5
        panelBG.bottomAnchor.constraint(equalTo: selectedRect.bottomAnchor, constant: -2).isActive = true
        panelBG.trailingAnchor.constraint(equalTo: selectedRect.trailingAnchor, constant: -2).isActive = true
        panelBG.layer.cornerRadius = 10
        
        let gifUrl1 = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        let g1 = SDAnimatedImageView()
        g1.contentMode = .scaleAspectFill
        g1.clipsToBounds = true
        g1.layer.cornerRadius = 10 //5
        g1.sd_setImage(with: gifUrl1)
        aHLightRect1.addSubview(g1)
        g1.translatesAutoresizingMaskIntoConstraints = false
        g1.widthAnchor.constraint(equalToConstant: 370).isActive = true //150
        g1.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
        g1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true //20
        g1.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //20, 0
        g1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-20, 0
        
        g1.isUserInteractionEnabled = true
        g1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickPostClipPhotoClicked)))
        
    }
    
    func selectCell() {
        selectedRect.isHidden = false
        isSelected = true
    }

    func unselectCell() {
        selectedRect.isHidden = true
        isSelected = false
    }
    
    @objc func onClickPostClipPhotoClicked(gesture: UITapGestureRecognizer) {
        
        aDelegate?.didClickPostClipCell(cell: self)
    }
    
    @objc func onClickClosePostClipPhotoClicked(gesture: UITapGestureRecognizer) {
//        aDelegate?.didClickPostClipCell(cell: self)
    }
}
