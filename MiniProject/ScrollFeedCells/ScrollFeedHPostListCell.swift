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
    var currentPlayingVidIndex = -1
    
    //test > for video autoplay when user opens
    var isFeedDisplayed = false
    
    //test
    var hideCellIndex = -1
    
    var selectedItemIdx = -1
    
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

    //test > resume current video
    func resumeCurrentVideo() {
        guard let a = self.vCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            guard let b = currentVc as? HPostListAViewCell else {
                return
            }
            b.resumeVideo()
        }
        print("sfvideo resumeCurrentVideo: \(feedCode), \(currentPlayingVidIndex)")
    }

    //test > pause current video for closing
    func pauseCurrentVideo() -> CGFloat {
        guard let a = self.vCV else {
            return 0.0
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            guard let b = currentVc as? HPostListAViewCell else {
                return 0.0
            }
            b.pauseVideo()
//            vDataList[currentPlayingVidIndex].t_s = b.t_s
            print("sfvideo pauseCurrentVideo: \(feedCode), \(currentPlayingVidIndex)")
            
//            return b.t_s
            return 0.0
        } else {
            return 0.0
        }
    }
    
    //test > seek time
//    func seekToVideo() {
//        guard let a = self.vCV else {
//            return
//        }
//
//        let idxPath = IndexPath(item: 0, section: 0)
//        let currentVc = a.cellForItem(at: idxPath)
//        guard let b = currentVc as? HPostListAViewCell else {
//            return
//        }
//        b.seekToV()
//    }
    
    //test > dehide cell
    func dehideCell() {
        guard let a = self.vCV else {
            return
        }

        let idxPath = IndexPath(item: hideCellIndex, section: 0)
        let currentVc = a.cellForItem(at: idxPath)
        guard let b = currentVc as? HPostListAViewCell else {
            return
        }
        b.dehideCell()
        
        hideCellIndex = -1
    }
    
    //test > selected item for delete etc
    func unselectItemData(){
        selectedItemIdx = -1
    }
    
    //test > react to intersected video
    func reactToIntersectedVideo(intersectedIdx: Int) {
        guard let a = vCV else {
            return
        }
        if(intersectedIdx > -1) {
            if(currentPlayingVidIndex > -1) {
                if(currentPlayingVidIndex != intersectedIdx) {
                    let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                    let idxPath = IndexPath(item: intersectedIdx, section: 0)
                    let prevVc = a.cellForItem(at: prevIdxPath)
                    let currentVc = a.cellForItem(at: idxPath)
                    guard let b = prevVc as? HPostListAViewCell else {
                        return
                    }
                    guard let c = currentVc as? HPostListAViewCell else {
                        return
                    }
                    b.pauseVideo()
//                    vDataList[currentPlayingVidIndex].t_s = b.t_s

                    c.resumeVideo()
                    currentPlayingVidIndex = intersectedIdx
                }
            } else {
                let idxPath = IndexPath(item: intersectedIdx, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                guard let b = currentVc as? HPostListAViewCell else {
                    return
                }

                b.resumeVideo()
                currentPlayingVidIndex = intersectedIdx
            }
        } else {
            //if intersectedIdx == -1, all video should pause/stop
            if(currentPlayingVidIndex > -1) {
                let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                guard let b = currentVc as? HPostListAViewCell else {
                    return
                }
                b.pauseVideo()
//                vDataList[currentPlayingVidIndex].t_s = b.t_s
                currentPlayingVidIndex = -1
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
        let size = CGSize(width: textWidth, height: 1000) //1000 height is dummy
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("placepanel collection 2: \(indexPath)")
        print("sfvideo autoplay layout: \(indexPath)")

        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        let text = vDataList[indexPath.row].dataTextString
        let dataL = vDataList[indexPath.row].dataArray
        var contentHeight = 0.0
        for l in dataL {
            if(l == "t") {
                let tTopMargin = 20.0
                let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 30.0, fontSize: 14)
                let tHeight = tTopMargin + tContentHeight
                contentHeight += tHeight
            }
            else if(l == "p") {
                let cellWidth = collectionView.frame.width
                let lhsMargin = 20.0
                let rhsMargin = 20.0
                let availableWidth = cellWidth - lhsMargin - rhsMargin
                
                let assetSize = CGSize(width: 4, height: 3)
                var cSize = CGSize(width: 0, height: 0)
                if(assetSize.width > assetSize.height) {
                    //1 > landscape photo 4:3 w:h
                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                    let cHeight = availableWidth * aRatio.height / aRatio.width
                    cSize = CGSize(width: availableWidth, height: cHeight)
                }
                else if (assetSize.width < assetSize.height){
                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                    let cWidth = availableWidth * 2 / 3
                    let cHeight = cWidth * aRatio.height / aRatio.width
                    cSize = CGSize(width: cWidth, height: cHeight)
                } else {
                    //square
                    let cWidth = availableWidth
                    cSize = CGSize(width: cWidth, height: cWidth)
                }

                let pTopMargin = 20.0
//                let pContentHeight = 280.0
                let pContentHeight = cSize.height
                let pHeight = pTopMargin + pContentHeight
                contentHeight += pHeight
            }
            else if(l == "p_s") {
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
                    cSize = CGSize(width: availableWidth, height: cHeight)
                }
                else if (assetSize.width < assetSize.height){
                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                    let cWidth = availableWidth * 2 / 3
                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                    cSize = CGSize(width: cWidth, height: cHeight)
                } else {
                    //square
                    let cWidth = availableWidth
                    cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                }
                
                let pTopMargin = 20.0
//                let pContentHeight = 280.0
                let pContentHeight = cSize.height
//                let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
                let pHeight = pTopMargin + pContentHeight
                contentHeight += pHeight
            }
            else if(l == "v") {
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
                    cSize = CGSize(width: availableWidth, height: cHeight)
                }
                else if (assetSize.width < assetSize.height){
                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                    let cWidth = availableWidth * 2 / 3
                    let cHeight = cWidth * aRatio.height / aRatio.width
                    cSize = CGSize(width: cWidth, height: cHeight)
                } else {
                    //square
                    let cWidth = availableWidth
                    cSize = CGSize(width: cWidth, height: cWidth)
                }
                
                let vTopMargin = 20.0
//                let vContentHeight = 350.0 //250
                let vContentHeight = cSize.height
                let vHeight = vTopMargin + vContentHeight
                contentHeight += vHeight
            }
            else if(l == "v_l") {
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
                    cSize = CGSize(width: availableWidth, height: cHeight)
                }
                else if (assetSize.width < assetSize.height){
                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                    let cWidth = availableWidth * 2 / 3
                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                    cSize = CGSize(width: cWidth, height: cHeight)
                } else {
                    //square
                    let cWidth = availableWidth
                    cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                }
                
                let vTopMargin = 20.0
//                let vContentHeight = 350.0 //250
                let vContentHeight = cSize.height
                let vHeight = vTopMargin + vContentHeight
//                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                contentHeight += vHeight
            }
            else if(l == "q") {
                let qTopMargin = 20.0
                let qUserPhotoHeight = 28.0
                let qUserPhotoTopMargin = 10.0 //10
                let qContentTopMargin = 10.0
                let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
                let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                let qFrameBottomMargin = 20.0 //10
                let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qContentTopMargin + qContentHeight + qFrameBottomMargin
                contentHeight += qHeight
            }
        }
        
        let dataCh = vDataList[indexPath.row].xChainDataArray
        for l in dataCh {
            let xText = l.dataTextString
            let xDataL = l.dataArray
            var yContentHeight = 0.0
            for y in xDataL {
                if(y == "t") {
                    let xContentTopMargin = 20.0
                    let xContentHeight = estimateHeight(text: xText, textWidth: collectionView.frame.width - 53.0 - 20.0, fontSize: 13)
                    let xHeight = xContentTopMargin + xContentHeight
                    yContentHeight += xHeight
                }
                else if(y == "p") {
                    let pTopMargin = 20.0
                    let pContentHeight = 280.0
                    let pHeight = pTopMargin + pContentHeight
                    yContentHeight += pHeight
                }
                else if(y == "q") {
                    let qTopMargin = 20.0
                    let qUserPhotoHeight = 28.0
                    let qUserPhotoTopMargin = 10.0 //10
                    let qContentTopMargin = 10.0
                    let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
                    let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 53.0 - 20.0, fontSize: 13)
                    let qFrameBottomMargin = 20.0 //10
                    let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qContentTopMargin + qContentHeight + qFrameBottomMargin
                    yContentHeight += qHeight
                }
            }
            let cUserPhotoHeight = 28.0
            let cUserPhotoTopMargin = 10.0 //10
            let cActionBtnTopMargin = 20.0
            let cActionBtnHeight = 26.0
            let cFrameBottomMargin = 10.0 //10
            let cHeight = cUserPhotoHeight + cUserPhotoTopMargin + yContentHeight + cActionBtnTopMargin + cActionBtnHeight + cFrameBottomMargin
            contentHeight += cHeight
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
//                    currentPlayingVidIndex = 0 //test > try method 2 => check for intersected video first
                }

                isFeedDisplayed = true
                print("sfvideo autoplay: \(feedCode)")
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
    func hListDidClickVcvComment(vc: UICollectionViewCell) {
        aDelegate?.sfcDidClickVcvComment()
    }
    func hListDidClickVcvLove() {
        aDelegate?.sfcDidClickVcvLove()
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell) {
//        aDelegate?.sfcDidClickVcvShare()
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let selectedIndexPath = a.indexPath(for: cell)
                    aDelegate?.sfcDidClickVcvShare()
                    
                    if let c = selectedIndexPath {
                        selectedItemIdx = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickUser() {
        aDelegate?.sfcDidClickVcvClickUser()
    }
    func hListDidClickVcvClickPlace() {
        aDelegate?.sfcDidClickVcvClickPlace()
    }
    func hListDidClickVcvClickSound() {
        aDelegate?.sfcDidClickVcvClickSound()
    }
    func hListDidClickVcvClickPost() {
        aDelegate?.sfcDidClickVcvClickPost()
    }
    func hListDidClickVcvClickPhoto(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
//        aDelegate?.sfcDidClickVcvClickPhoto()
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("sfpost idx frame origin p: \(cell.frame.origin), \(originInRootView), \(visibleIndexPath)")
                    
                    aDelegate?.sfcDidClickVcvClickPhoto(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickVideo(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("sfpost idx frame origin v: \(cell.frame.origin), \(originInRootView), \(visibleIndexPath)")
                    
                    aDelegate?.sfcDidClickVcvClickVideo(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
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
    
    func hListCarouselIdx(vc: UICollectionViewCell, idx: Int) {
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
//                print("sfpost idx: \(cell == vc), \(indexPath)")
                
                if(cell == vc) {
                    vDataList[indexPath.row].p_s = idx
                    
                    break
                }
            }
        }
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, ts: Double){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    vDataList[indexPath.row].t_s = ts
                    
                    break
                }
            }
        }
    }
    
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        
    }
}
