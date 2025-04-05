//
//  PostClipPhotoCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PostClipCellDelegate : AnyObject {
    func pcDidClickPostClipCell(cell: PostClipCell)
    func pcDidClickPcClickPhoto(pc: PostClipCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func pcDidClickPcClickVideo(pc: PostClipCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func pcDidClickPcClickPlay(pc: PostClipCell, isPlay: Bool)
}

class PostClipCell: UIView {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aHLightRect1 = UIView()
    weak var aDelegate : PostClipCellDelegate?
    
    var isSelected = false
    let selectedRect = UIView()
    
    var aTestArray = [UIView]()
    
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
        selectedRect.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        selectedRect.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
        selectedRect.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        selectedRect.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true //-10
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
        aDelegate?.pcDidClickPostClipCell(cell: self)
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
    
    //test* > hide & dehide cells
    func hideCell() {
        print("hidecell postclipcell:")
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? ContentCell{
                a.hideCell()
            }
        }
    }
    
    func dehideCell() {
        print("dehidecell postclipcell:")
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? ContentCell{
                a.dehideCell()
            }
        }
    }
    //*
    
    //**test 2 > new method to play/stop media with asset idx for multi-assets per cell
    func pauseMedia() {
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? MediaContentCell{
                a.pauseMedia()
            }
        }
    }
    func resumeMedia() {
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? MediaContentCell{
                a.resumeMedia()
            }
        }
    }
    //**
    
    //test > destroy view to avoid timeobserver memory leak
    func destroyCell() {
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? ContentCell{
                a.destroyCell()
            }
        }
    }
    
    func configure(data: String, dataType: String, cSize: CGSize) {
        if(dataType == "photo") {
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
//            contentCell.configure(data: "a")
            var da = [String]() //temp solution
            da.append("https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
            contentCell.configure(data: da)
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            aTestArray.append(contentCell)
        }
        else if(dataType == "photo_s") {
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
            contentCell.configure(data: "a") //ori
//            contentCell.configure(data: "a", state: 0)
//            var da = [String]() //temp solution
//            da.append("https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//            contentCell.configure(data: da)
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            aTestArray.append(contentCell)
        }
        else if(dataType == "video") {
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
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            aTestArray.append(contentCell)
        }
        else if(dataType == "video_l") {
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
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            aTestArray.append(contentCell)
        }
        else if(dataType == "quote") {
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
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            contentCell.configure(data: "a", text: t)
            aTestArray.append(contentCell)
        }
    }
}

extension PostClipCell: ContentCellDelegate {
    func contentCellIsScrollCarousel(isScroll: Bool){
//        aDelegate?.hListIsScrollCarousel(isScroll: isScroll)
    }
    
    func contentCellCarouselIdx(cc: UIView, idx: Int){
//        if let j = aTestArray.firstIndex(of: cc) {
//            aDelegate?.hListCarouselIdx(vc: self, aIdx: j, idx: idx)
//        }
    }
    
    func contentCellVideoStopTime(cc: UIView, ts: Double){
//        if let j = aTestArray.firstIndex(of: cc) {
//            aDelegate?.hListVideoStopTime(vc: self, aIdx: j, ts: ts)
//        }
    }
    
    func contentCellDidClickVcvClickPhoto(cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aHLightRect1.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.pcDidClickPcClickPhoto(pc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
    }
    func contentCellDidClickVcvClickVideo(cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aHLightRect1.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.pcDidClickPcClickVideo(pc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
    }
    func contentCellDidDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
    func contentCellDidClickSound(){
        
    }
    func contentCellDidClickUser(){
        
    }
    func contentCellDidClickPlace(){
        
    }
    func contentCellDidClickPost(){
//        aDelegate?.hListDidClickVcvClickPost()
    }
    func contentCellDidClickVcvClickPlay(cc: UIView, isPlay: Bool){
        aDelegate?.pcDidClickPcClickPlay(pc: self, isPlay: isPlay)
    }
}
