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
        
//        self.backgroundColor = .red
    }
    
    func selectCell() {
//        selectedRect.isHidden = false
        isSelected = true
        
        //test > new selected UI in contentCell
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? ContentCell{
                a.selectCell()
            }
        }
    }

    func unselectCell() {
//        selectedRect.isHidden = true
        isSelected = false
        
        //test > new selected UI in contentCell
        if(!aTestArray.isEmpty) {
            let c = aTestArray.count - 1
            if let a = aTestArray[c] as? ContentCell{
                a.unselectCell()
            }
        }
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
    
//    func configure(data: String, dataType: String, cSize: CGSize) {
    func configure(cData: ContentData, dataType: String, cSize: CGSize) {
        if(dataType == "photo") {
            let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //10
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
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
            
            //test > selectable
            contentCell.setSelectable(isEnabled: true)
        }
        else if(dataType == "photo_s") {
            let contentCell = PostPhotoShotContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //0
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
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
            
            //test > selectable
            contentCell.setSelectable(isEnabled: true)
        }
        else if(dataType == "video") {
            let contentCell = PostVideoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true 
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //10
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            contentCell.redrawUI()
            contentCell.configure(data: "a")
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            aTestArray.append(contentCell)
            
            //test > selectable
            contentCell.setSelectable(isEnabled: true)
        }
        else if(dataType == "video_l") {
            let contentCell = PostVideoLoopContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //10
            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            let t = "" //Loop text description
            contentCell.setDescHeight(lHeight: 40, txt: t)
            contentCell.redrawUI()
            contentCell.configure(data: "a")
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
            aTestArray.append(contentCell)
            
            //test > selectable
            contentCell.setSelectable(isEnabled: true)
        }
        else if(dataType == "quote") {
            let contentCell = PostQuoteContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aHLightRect1.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            contentCell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
            contentCell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //10
//            contentCell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            contentCell.aDelegate = self //test
            contentCell.setAutohide(isEnabled: false)
//            contentCell.configure(data: "a", text: t)
            
            let da = cData.dataArray
            let t = cData.dataTextString
            contentCell.setupContentViews(qPredata: da, text: t, contentData: cData)
            contentCell.configure(contentData: cData, isToForceRefreshData: true)
            aTestArray.append(contentCell)
            
            //test > selectable
            contentCell.setSelectable(isEnabled: true)
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
    
    func contentCellDidClickVcvClickPhoto(id: String, cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
//        let aTestFrame = aHLightRect1.frame.origin
//        let ccFrame = cc.frame.origin
//        
//        let pointX1 = pointX + aTestFrame.x + ccFrame.x
//        let pointY1 = pointY + aTestFrame.y + ccFrame.y
//        aDelegate?.pcDidClickPcClickPhoto(pc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        //test
        aDelegate?.pcDidClickPostClipCell(cell: self)
    }
    func contentCellDidClickVcvClickVideo(id: String, cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
//        let aTestFrame = aHLightRect1.frame.origin
//        let ccFrame = cc.frame.origin
//        
//        let pointX1 = pointX + aTestFrame.x + ccFrame.x
//        let pointY1 = pointY + aTestFrame.y + ccFrame.y
//        aDelegate?.pcDidClickPcClickVideo(pc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        //test
        aDelegate?.pcDidClickPostClipCell(cell: self)
    }
    func contentCellDidDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
    func contentCellDidClickSound(id: String){
        
    }
    func contentCellDidClickUser(id: String){
        
    }
    func contentCellDidClickPlace(id: String){
        
    }
    func contentCellDidClickPost(id: String, dataType: String){
//        aDelegate?.hListDidClickVcvClickPost()
        
        //test
        aDelegate?.pcDidClickPostClipCell(cell: self)
    }
    func contentCellDidClickVcvClickPlay(cc: UIView, isPlay: Bool){
        aDelegate?.pcDidClickPcClickPlay(pc: self, isPlay: isPlay)
    }
    func contentCellResize(cc: UIView){
    }
}
