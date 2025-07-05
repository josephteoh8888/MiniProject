//
//  ScrollFeedHPostListCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class ScrollFeedHPostListCell: ScrollDataFeedCell {
    
//    var vDataList = [PostData]()
//    weak var aDelegate : ScrollFeedCellDelegate?
    
    //test > record which cell video is playing
//    var currentPlayingVidIndex = -1
    
    //test > for video autoplay when user opens
    var isFeedDisplayed = false
    
    //test
    var hideCellIndex = -1
    
//    var selectedItemIdx = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }
    
    func setupViews() {
        //move to redrawUI()
    }
    
    override func scrollToTop() {
        vCV?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    override func initialize() {
        if(!isInitialized) {
            redrawUI()
        }
        isInitialized = true
    }
    
    func redrawUI() {
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
        gridLayout.minimumLineSpacing = 10 //try 20 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns

        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }

//        vCV.register(HPostListThreadViewCell.self, forCellWithReuseIdentifier: HPostListThreadViewCell.identifier)
        vCV.register(HPostListAViewCell.self, forCellWithReuseIdentifier: HPostListAViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
//        vCV.showsVerticalScrollIndicator = true //false
//        vCV.backgroundColor = .blue
        vCV.backgroundColor = .clear
//        vCV.isPagingEnabled = true
        self.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
        vCV.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        vCV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
//        vCV.isScrollEnabled = false
        vCV.alwaysBounceVertical = true //test > when empty result, still can refetch data
        
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        vCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        //test > top spinner
        vCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: vCV.topAnchor, constant: CGFloat(35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: vCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func setShowVerticalScroll(isShowVertical: Bool) {
        vCV?.showsVerticalScrollIndicator = isShowVertical
    }
    
    //test > dehide cell
    func dehideCell() {
        guard let a = self.vCV else {
            return
        }

        if(hideCellIndex > -1) {
            let idxPath = IndexPath(item: hideCellIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            guard let b = currentVc as? HPostListAViewCell else {
                return
            }
            b.dehideCell()
            
            hideCellIndex = -1
        }
    }
    
    //test > selected item for delete etc
//    override func unselectItemData(){
//        selectedItemIdx = -1
//    }
    
    //test > resume current video
    func resumePlayingMedia() {
        //test 2 > new method for cell-asset idx
        resumeMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
    }

    //test > pause current video for closing
    func pausePlayingMedia() {
        //test 2 > new method for cell-asset idx
        pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
    }
    
    //test > destroy cell
    func destroyCell() {
        guard let a = self.vCV else {
            return
        }
        for cell in a.visibleCells {
            if let b = cell as? HPostListAViewCell {
                b.destroyCell()
            }
        }
    }
    
    //test 2 > new method for pausing video with cell-asset idx
    var playingCellMediaAssetIdx = [-1, -1] //none playing initially
    func pauseMediaAsset(cellAssetIdx: [Int]) {
        guard let a = self.vCV else {
            return
        }
        if(cellAssetIdx.count == 2) {
            let cIdx = cellAssetIdx[0] //cell index
            let aIdx = cellAssetIdx[1] //asset index
            if(cIdx > -1 && aIdx > -1) {
                let cIdxPath = IndexPath(item: cIdx, section: 0)
                let cell = a.cellForItem(at: cIdxPath)
                if let c = cell as? HPostListAViewCell {
                    if(!c.aTestArray.isEmpty && aIdx < c.aTestArray.count) {
                        c.pauseMedia(aIdx: aIdx)
//                        playingCellMediaAssetIdx = [-1, -1] //disabled for pauseCurrentVideo() and resume
                    }
                }
            }
        }
    }
    
    func resumeMediaAsset(cellAssetIdx: [Int]) {
        guard let a = self.vCV else {
            return
        }
        if(cellAssetIdx.count == 2) {
            let cIdx = cellAssetIdx[0]
            let aIdx = cellAssetIdx[1]
            if(cIdx > -1 && aIdx > -1) {
                let cIdxPath = IndexPath(item: cIdx, section: 0)
                let cell = a.cellForItem(at: cIdxPath)
                if let c = cell as? HPostListAViewCell {
                    if(!c.aTestArray.isEmpty && aIdx < c.aTestArray.count) {
                        c.resumeMedia(aIdx: aIdx)
                    }
                }
            }
        }
    }
    
    //test > footer error handling for refresh feed
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error refresh clicked")
        aDelegate?.sfcDidClickVcvRefresh()
    }
    
    override func configureFooterUI(data: String) {
        aaText.text = ""
        errorText.text = ""
        errorRefreshBtn.isHidden = true
        
        if(data == "end") {
            aaText.text = "End"
        }
        else if(data == "e") {
            errorText.text = "Something went wrong. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            aaText.text = footerAaText
            //removed, text to be customized at panelview level
        }
        
        footerState = data
    }
}

extension ScrollFeedHPostListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        print("placepanel collection: \(section)")
        //margin between sections
        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
//        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        if(text == ""){
            return 0
        } else {
            let size = CGSize(width: textWidth, height: 1000) //1000 height is dummy
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return estimatedFrame.height.rounded(.up)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let text = vDataList[indexPath.row].dataTextString
//        let dataL = vDataList[indexPath.row].dataArray
        let dataCL = vDataList[indexPath.row].contentDataArray
        let d = vDataList[indexPath.row].dataCode
        
        var contentHeight = 0.0
        
        if(d == "a") {
            for cl in dataCL {
                let l = cl.dataCode
                let da = cl.dataArray

                if(l == "text") {
                    let tTopMargin = 20.0
//                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 30.0, fontSize: 14)
                    let t = cl.dataTextString
                    let tContentHeight = estimateHeight(text: t, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) //-20-30
                    let tHeight = tTopMargin + tContentHeight
                    contentHeight += tHeight
                }
                else if(l == "photo") {
                    let cellWidth = collectionView.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
    //                let assetSize = CGSize(width: 4, height: 3)//landscape
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: availableWidth, height: cHeight) //ori
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: cWidth, height: cHeight) //ori
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth) //ori
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth))
                    }

                    let pTopMargin = 20.0
    //                let pContentHeight = 280.0
                    let pContentHeight = cSize.height
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "photo_s") {
                    let cellWidth = self.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 4, height: 3)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                    }
                    
                    let pTopMargin = 20.0
    //                let pContentHeight = 280.0
                    let pContentHeight = cSize.height
    //                let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "video") {
                    let cellWidth = self.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth))
                    }
                    
                    let vTopMargin = 20.0
    //                let vContentHeight = 350.0 //250
                    let vContentHeight = cSize.height
                    let vHeight = vTopMargin + vContentHeight
                    contentHeight += vHeight
                }
                else if(l == "video_l") {
                    let cellWidth = collectionView.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                    }
                    
                    let vTopMargin = 20.0
    //                let vContentHeight = 350.0 //250
                    let vContentHeight = cSize.height
                    let vHeight = vTopMargin + vContentHeight
    //                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += vHeight
                }
                else if(l == "quote") {
                    
                    let qLhsMargin = 20.0
                    let qRhsMargin = 20.0
                    let quoteWidth = collectionView.frame.width - qLhsMargin - qRhsMargin
                    
                    let dd = cl.contentDataCode
                    if(dd == "a" || dd == "") {
                        var qDataArray = [String]()
                        
                        for d in da {
                            qDataArray.append(d)
                        }

                        for i in qDataArray {
                            if(i == "text") {
                                let tTopMargin = 20.0
    //                            let tContentHeight = estimateHeight(text: text, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let t = cl.dataTextString
                                let tContentHeight = estimateHeight(text: t, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let tHeight = tTopMargin + tContentHeight
                                contentHeight += tHeight
                            }
                            else if(i == "photo") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 4, height: 3)//landscape
        //                        let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                //                    let cWidth = availableWidth //test full width for portrait
                                    let cHeight = cWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth))
                                }

                                let pTopMargin = 20.0
                //                let pContentHeight = 280.0
                                let pContentHeight = cSize.height
                                let pHeight = pTopMargin + pContentHeight
                                contentHeight += pHeight
                            }
                            else if(i == "photo_s") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let descHeight = 40.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 4, height: 3)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                                }
                                
                                let pTopMargin = 20.0
                //                let pContentHeight = 280.0
                                let pContentHeight = cSize.height
                                let pHeight = pTopMargin + pContentHeight
                                contentHeight += pHeight
                            }
                            else if(i == "video") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth))
                                }
                                
                                let vTopMargin = 20.0
                //                let vContentHeight = 350.0 //250
                                let vContentHeight = cSize.height
                                let vHeight = vTopMargin + vContentHeight
                                contentHeight += vHeight
                            }
                            else if(i == "video_l") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let descHeight = 40.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                                }
                                
                                let vTopMargin = 20.0
                //                let vContentHeight = 350.0 //250
                                let vContentHeight = cSize.height
                                let vHeight = vTopMargin + vContentHeight
                //                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                                contentHeight += vHeight
                            }
                            else if(i == "quote") {
                                let tTopMargin = 20.0
                                let t = "[Quote]"
                                let tContentHeight = estimateHeight(text: t, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let tHeight = tTopMargin + tContentHeight
                                contentHeight += tHeight
                            }
                        }
                    }
                    else if(dd == "na") {
                        let qNpTopMargin = 20.0
                        let qNpTTopMargin = 10.0 //20
                        let qNpTBottomMargin = 10.0
                        let qNpText = "Post does not exist."
                        let qNpContentHeight = estimateHeight(text: qNpText, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 13)
                        let qNpHeight = qNpTTopMargin + qNpContentHeight + qNpTBottomMargin + qNpTopMargin
                        contentHeight += qNpHeight
                    }
                    else if(dd == "us") {
                        let qNpTopMargin = 20.0
                        let qNpTTopMargin = 10.0 //20
                        let qNpTBottomMargin = 10.0
                        let qNpText = "Post violated community rules."
                        let qNpContentHeight = estimateHeight(text: qNpText, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 13)
                        let qNpHeight = qNpTTopMargin + qNpContentHeight + qNpTBottomMargin + qNpTopMargin
                        contentHeight += qNpHeight
                    }
                    let qTopMargin = 20.0
                    let qUserPhotoHeight = 28.0
                    let qUserPhotoTopMargin = 15.0 //20
                    let qFrameBottomMargin = 20.0 //10
                    let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qFrameBottomMargin
                    contentHeight += qHeight
                }
            }
        }
        else if(d == "na") {
            let npTopMargin = 20.0
            let npTTopMargin = 10.0 //20
            let npTBottomMargin = 10.0
            let npText = "Post does not exist."
            let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
            let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
            contentHeight += npHeight
        }
        else if(d == "us") {
            let npTopMargin = 20.0
            let npTTopMargin = 10.0 //20
            let npTBottomMargin = 10.0
            let npText = "Post violated community rules."
            let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
            let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
            contentHeight += npHeight
        }
        
        let userPhotoHeight = 40.0
        let userPhotoTopMargin = 20.0 //10
        let actionBtnTopMargin = 10.0
        let actionBtnHeight = 30.0
        let frameBottomMargin = 20.0 //10
        let locationTopMargin = 20.0
        let locationHeight = estimateHeight(text: "Petronas", textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) + 10
        let miscHeight = userPhotoHeight + userPhotoTopMargin + actionBtnTopMargin + actionBtnHeight + locationHeight + locationTopMargin + frameBottomMargin
        let totalHeight = contentHeight + miscHeight
        
        return CGSize(width: collectionView.frame.width, height: totalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.row == vDataList.count - 1 {
            print("feedhresultlistcell willdisplay: \(indexPath.row)")
            
            //test
            if(dataPaginateStatus != "end") {
                print("feedhresultlistcell paginate async")
                aDelegate?.sfcAsyncPaginateFeed(cell: self)
            }
        }
        
        //test > for video autoplay when user opens
        if(!isFeedDisplayed) {
            if(indexPath.row == 0) {
                if let c = cell as? HPostListAViewCell {
                    aDelegate?.sfcAutoplayVideo(cell: self, vCCell: c)
                }
                isFeedDisplayed = true
            }
        }
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("postpanelscroll footer reuse")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            header.addSubview(headerView)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
//            footer.addSubview(footerView)
            
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100) //50
//            footerView.backgroundColor = .ddmDarkColor
//            footerView.backgroundColor = .blue
            footer.addSubview(footerView)
//            footerView.isHidden = true

            aaText.textAlignment = .center //left
            aaText.textColor = .white
            aaText.font = .systemFont(ofSize: 12)
            footerView.addSubview(aaText)
            aaText.clipsToBounds = true
            aaText.translatesAutoresizingMaskIntoConstraints = false
//            aaText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            aaText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            aaText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            aaText.layer.opacity = 0.5
            //test > try remove and use configure() method
//            if(dataPaginateStatus == "end") {
//                aaText.text = "End"
//            } else {
//                aaText.text = ""
//            }

            bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)//white
            footer.addSubview(bSpinner)
            bSpinner.translatesAutoresizingMaskIntoConstraints = false
//            bSpinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
            bSpinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
            bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            bSpinner.isHidden = true
            
            //test > error handling
            errorText.textAlignment = .center //left
            errorText.textColor = .white
            errorText.font = .systemFont(ofSize: 13)
            footerView.addSubview(errorText)
            errorText.clipsToBounds = true
            errorText.translatesAutoresizingMaskIntoConstraints = false
//            errorText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            errorText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            errorText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            errorText.text = ""
            
            errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
            footerView.addSubview(errorRefreshBtn)
            errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
            errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            errorRefreshBtn.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 10).isActive = true
            errorRefreshBtn.layer.cornerRadius = 20
            errorRefreshBtn.isUserInteractionEnabled = true
            errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
            errorRefreshBtn.isHidden = true
            
            let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
    //        bMiniBtn.tintColor = .black
            bMiniBtn.tintColor = .white
            errorRefreshBtn.addSubview(bMiniBtn)
            bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
            bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
            bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
            bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
            bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            configureFooterUI(data: footerState)
            
            return footer
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("postpanel referencesize: \(section)")
//        return CGSize(width: collectionView.bounds.size.width, height: 50)
        return CGSize(width: collectionView.bounds.size.width, height: 100)
    }
}

extension ScrollFeedHPostListCell: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("sf scrollview begin: \(scrollView.contentOffset.y)")
        
        //test > vcv pan vs collectionview scroll
//        isScrollActive = true
        aDelegate?.sfcWillBeginDragging(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print("sf scrollview scroll: \(scrollView.contentOffset.y)")
        aDelegate?.sfcScrollViewDidScroll(offsetY: scrollView.contentOffset.y)
        
        //test > method 1 => try visible rect identification
        guard let a = scrollView as? UICollectionView else {
            return
        }
        
        //test > to avoid accidental inability to scroll to close panel
        aDelegate?.sfcIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("sf scrollview end: \(scrollView.contentOffset.y)")
        aDelegate?.sfcSrollViewDidEndDecelerating(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("sf scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
        aDelegate?.sfcScrollViewDidEndDragging(offsetY: scrollView.contentOffset.y, decelerate: decelerate)
    }
}

extension ScrollFeedHPostListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPostListAViewCell.identifier, for: indexPath) as! HPostListAViewCell
        cell.aDelegate = self
        
        //test > configure cell
        cell.configure(data: vDataList[indexPath.row])
        print("sfvideo configure: \(indexPath.row), \(vDataList[indexPath.row].t_s)")
        print("sfvideo autoplay configure: \(indexPath.row)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension ScrollFeedHPostListCell: HListCellDelegate {
    func hListDidClickVcvComment(vc: UICollectionViewCell, id: String, dataType: String, pointX: CGFloat, pointY: CGFloat) {
        aDelegate?.sfcDidClickVcvComment()
    }
    func hListDidClickVcvLove() {
        aDelegate?.sfcDidClickVcvLove()
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell, id: String, dataType: String) {
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let selectedIndexPath = a.indexPath(for: cell)
                    aDelegate?.sfcDidClickVcvShare(id: id, dataType: dataType)
                    
                    if let c = selectedIndexPath {
                        selectedItemIdx = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickUser(id: String) {
        aDelegate?.sfcDidClickVcvClickUser(id: id)
    }
    func hListDidClickVcvClickPlace(id: String) {
        aDelegate?.sfcDidClickVcvClickPlace(id: id)
    }
    func hListDidClickVcvClickSound(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String) {
//        aDelegate?.sfcDidClickVcvClickSound(id: id)
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    aDelegate?.sfcDidClickVcvClickSound(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickPost(id: String, dataType: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat) {
//        aDelegate?.sfcDidClickVcvClickPost(id: id, dataType: dataType)
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    aDelegate?.sfcDidClickVcvClickPost(id: id, dataType: dataType, pointX: pointX1, pointY: pointY1)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickPhoto(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    aDelegate?.sfcDidClickVcvClickPhoto(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickVideo(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    aDelegate?.sfcDidClickVcvClickVideo(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvSortComment(){
        
    }
    func hListIsScrollCarousel(isScroll: Bool) {
        aDelegate?.sfcIsScrollCarousel(isScroll: isScroll)
    }
    
    func hListCarouselIdx(vc: UICollectionViewCell, aIdx: Int, idx: Int) {
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
//                    vDataList[indexPath.row].p_s = idx
                    
                    //test > new method
                    let data = vDataList[indexPath.row]
                    let dataCL = data.contentDataArray
                    if(aIdx > -1 && aIdx < dataCL.count) {
                        dataCL[aIdx].p_s = idx
                    }
                    
                    break
                }
            }
        }
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, aIdx: Int, ts: Double){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
//                    vDataList[indexPath.row].t_s = ts
                    
                    //test > new method
                    let data = vDataList[indexPath.row]
                    let dataCL = data.contentDataArray
                    if(aIdx > -1 && aIdx < dataCL.count) {
                        dataCL[aIdx].t_s = ts
                    }
                    
                    break
                }
            }
        }
    }
    
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        
    }
    
    func hListDidClickVcvClickPlay(vc: UICollectionViewCell, isPlay: Bool){
        //test > try new method for manual play/stop video
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    if let s = cell as? HPostListAViewCell {
                        let mIdx = s.playingMediaAssetIdx
                        if(isPlay) {
                            pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
                            playingCellMediaAssetIdx = [indexPath.row, mIdx]
                        } else {
                            playingCellMediaAssetIdx = [-1, -1]
                        }
                    }
                    
                    break
                }
            }
        }
        
        print("hpostA playingCellMediaAssetIdx: \(playingCellMediaAssetIdx)")
    }
    
    //test > reload item for resizing
    //*problem for those outside of visible cells
    func hListResize(vc: UICollectionViewCell){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    if let s = cell as? HPostListAViewCell {
                        var idxArray: [IndexPath] = []
                        idxArray.append(indexPath)
                        a.reloadItems(at: idxArray)
                    }
                    
                    break
                }
            }
        }
    }
}
