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
    
//    let g1 = SDAnimatedImageView()
    
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
        aHLightRect1.addSubview(selectedRect)
        selectedRect.translatesAutoresizingMaskIntoConstraints = false
        selectedRect.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true //10
        selectedRect.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
        selectedRect.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        selectedRect.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true //-10
        selectedRect.layer.cornerRadius = 10
        selectedRect.isHidden = true
//        selectedRect.backgroundColor = .ddmDarkColor
        
        let panelBG = UIView()
        panelBG.backgroundColor = .ddmBlackOverlayColor
//        panelBG.backgroundColor = .ddmDarkColor
        selectedRect.addSubview(panelBG)
        panelBG.translatesAutoresizingMaskIntoConstraints = false
        panelBG.leadingAnchor.constraint(equalTo: selectedRect.leadingAnchor, constant: 2).isActive = true
        panelBG.topAnchor.constraint(equalTo: selectedRect.topAnchor, constant: 2).isActive = true //5
        panelBG.bottomAnchor.constraint(equalTo: selectedRect.bottomAnchor, constant: -2).isActive = true
        panelBG.trailingAnchor.constraint(equalTo: selectedRect.trailingAnchor, constant: -2).isActive = true
        panelBG.layer.cornerRadius = 10
//        panelBG.isHidden = true //test
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
        print("postclip selected")
        aDelegate?.didClickPostClipCell(cell: self)
    }
    
    @objc func onClickClosePostClipPhotoClicked(gesture: UITapGestureRecognizer) {
//        aDelegate?.didClickPostClipCell(cell: self)
    }
    
    //test > set image according to img url
    func setImage(url: URL) {
//        g1.sd_setImage(with: url)
    }
    
    func configure(data: String, cSize: CGSize) {
        
    }
    
    func configure(data: String, dataType: String, cSize: CGSize) {
        if(dataType == "p") {
            let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //20, 0
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            contentCell.redrawUI()
            contentCell.configure(data: "a")
        }
        else if(dataType == "p_s") {
            let contentCell = PostPhotoShotContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //20, 0
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            let t = "Shot text description"
            contentCell.setDescHeight(lHeight: 40, txt: t)
            contentCell.redrawUI()
            contentCell.configure(data: "a")
        }
        else if(dataType == "v") {
            let contentCell = PostVideoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true 
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //20, 0
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            contentCell.redrawUI()
            contentCell.configure(data: "a")
        }
        else if(dataType == "v_l") {
            let contentCell = PostVideoLoopContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //20, 0
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            let t = "Loop text description"
            contentCell.setDescHeight(lHeight: 40, txt: t)
            contentCell.redrawUI()
            contentCell.configure(data: "a")
        }
        else if(dataType == "q") {
            let contentCell = PostQuoteContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //20, 0
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            let t = "Nice food, nice environment! Worth a visit. \nSo Good."
            contentCell.configure(data: "a", text: t)
        }
    }
}
