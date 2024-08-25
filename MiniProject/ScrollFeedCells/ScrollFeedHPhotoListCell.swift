//
//  ScrollFeedHPhotoListCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class ScrollFeedHPhotoListCell: ScrollPhotoDataFeedCell {
    
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

        vCV.register(HPhotoListAViewCell.self, forCellWithReuseIdentifier: HPhotoListAViewCell.identifier)
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
    func resumeCurrentAudio() {
        guard let a = self.vCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            guard let b = currentVc as? HPhotoListAViewCell else {
                return
            }
            b.resumeAudio()
        }
        print("sfvideo resumeCurrentAudio: \(feedCode), \(currentPlayingVidIndex)")
    }

    //test > pause current video for closing
    func pauseCurrentAudio() {
        guard let a = self.vCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            guard let b = currentVc as? HPhotoListAViewCell else {
                return
            }
            b.pauseAudio()
//            vDataList[currentPlayingVidIndex].t_s = b.t_s
            
            //test > new method to play sound, not automatic scroll and play
            currentPlayingVidIndex = -1
        }
        print("sfvideo pauseCurrentAudio: \(feedCode), \(currentPlayingVidIndex)")
    }
    
    //test > dehide cell
    func dehideCell() {
        guard let a = self.vCV else {
            return
        }

        let idxPath = IndexPath(item: hideCellIndex, section: 0)
        let currentVc = a.cellForItem(at: idxPath)
        guard let b = currentVc as? HPhotoListAViewCell else {
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
    func reactToIntersectedAudio(intersectedIdx: Int) {
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
                    guard let b = prevVc as? HPhotoListAViewCell else {
                        return
                    }
                    guard let c = currentVc as? HPhotoListAViewCell else {
                        return
                    }
                    b.pauseAudio()

//                    c.resumeAudio()
//                    currentPlayingVidIndex = intersectedIdx
                    
                    //test > new method to play sound, not automatic scroll and play
                    currentPlayingVidIndex = -1
                    
                    print("reactintersect photo A")
                }
            } else {
                let idxPath = IndexPath(item: intersectedIdx, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                guard let b = currentVc as? HPhotoListAViewCell else {
                    return
                }

//                b.resumeAudio()
//                currentPlayingVidIndex = intersectedIdx
                
                print("reactintersect photo B")
            }
        } else {
            //if intersectedIdx == -1, all video should pause/stop
            if(currentPlayingVidIndex > -1) {
                let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                guard let b = currentVc as? HPhotoListAViewCell else {
                    return
                }
                b.pauseAudio()
                currentPlayingVidIndex = -1
                
                print("reactintersect photo B")
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

extension ScrollFeedHPhotoListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        print("placepanel collection: \(section)")
        //margin between sections
//        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
//        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 100.0, right: 0.0)
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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

        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        let text = vDataList[indexPath.row].dataTextString
        let dataL = vDataList[indexPath.row].dataArray
//        let xText = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀."
        let statText = "1.2m views . 3hr"
        var contentHeight = 0.0
        for l in dataL {
            if(l == "m") {
                let pTopMargin = 0.0
                let pContentHeight = 400.0 //280.0
                let tTopMargin = 10.0
//                let tText = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀."
                let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
//                let pHeight = pTopMargin + pContentHeight
                let pBubbleTopMargin = 10.0
                let pBubbleHeight = 3.0
                let soundTopMargin = 10.0
                let soundHeight = 16.0
                let pHeight = pTopMargin + pContentHeight + pBubbleTopMargin + pBubbleHeight + tTopMargin + tContentHeight + soundTopMargin + soundHeight
                contentHeight += pHeight
            }
            else if(l == "p") {
                let pTopMargin = 0.0
                let pContentHeight = 400.0 //280.0
                let tTopMargin = 10.0
//                let tText = "Nice food, nice environment! Worth a visit. \nSo good!"
                let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                print("photo p text size: \(tContentHeight), \(text)")
//                let pHeight = pTopMargin + pContentHeight
                let pBubbleTopMargin = 10.0
                let pBubbleHeight = 3.0
                let pHeight = pTopMargin + pContentHeight + pBubbleTopMargin + pBubbleHeight + tTopMargin + tContentHeight
                contentHeight += pHeight
            }
            else if(l == "q") {
//                let qTopMargin = 20.0
//                let qUserPhotoHeight = 28.0
//                let qUserPhotoTopMargin = 10.0 //10
//                let qContentTopMargin = 10.0
//                let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
//                let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
//                let qFrameBottomMargin = 20.0 //10
//                let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qContentTopMargin + qContentHeight + qFrameBottomMargin
//                contentHeight += qHeight
            }
            else if(l == "c") {
//                let cUserPhotoHeight = 28.0
//                let cUserPhotoTopMargin = 20.0 //10
//                let cContentTopMargin = 10.0
//                let cText = "Worth a visit."
//                let cContentHeight = estimateHeight(text: cText, textWidth: collectionView.frame.width - 58.0 - 20.0, fontSize: 14)
//                let cActionBtnTopMargin = 10.0
//                let cActionBtnHeight = 26.0
//                let cHeight = cUserPhotoHeight + cUserPhotoTopMargin + cContentTopMargin + cContentHeight + cActionBtnTopMargin + cActionBtnHeight
//                contentHeight += cHeight
            }
        }
        
        let userPhotoHeight = 40.0
        let userPhotoTopMargin = 10.0 //10
//        let tTopMargin = 10.0
//        let tContentHeight = estimateHeight(text: xText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
        let statTopMargin = 10.0
        let statContentHeight = estimateHeight(text: statText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 12)
        let actionBtnTopMargin = 10.0
        let actionBtnHeight = 30.0
        let frameBottomMargin = 20.0 + 10.0//20
        let locationTopMargin = 10.0
        let locationHeight = estimateHeight(text: "Petronas", textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) + 10
//        let miscHeight = userPhotoHeight + userPhotoTopMargin + tTopMargin + tContentHeight + statTopMargin + statContentHeight + actionBtnTopMargin + actionBtnHeight + locationHeight + locationTopMargin + soundHeight + soundTopMargin + frameBottomMargin
        let miscHeight = userPhotoHeight + userPhotoTopMargin + statTopMargin + statContentHeight + actionBtnTopMargin + actionBtnHeight + locationHeight + locationTopMargin + frameBottomMargin
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
                if let c = cell as? HPhotoListAViewCell {
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
        
        print("postpanel footer reuse")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            header.addSubview(headerView)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
//            footer.addSubview(footerView)
            
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
//            footerView.backgroundColor = .ddmDarkColor
//            footerView.backgroundColor = .blue
            footer.addSubview(footerView)
//            footerView.isHidden = true

            aaText.textAlignment = .left
            aaText.textColor = .white
            aaText.font = .systemFont(ofSize: 12)
            footerView.addSubview(aaText)
            aaText.clipsToBounds = true
            aaText.translatesAutoresizingMaskIntoConstraints = false
//            aaText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            aaText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            aaText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            aaText.layer.opacity = 0.5
//            if(dataPaginateStatus == "end") {
//                aaText.text = "End"
//            } else {
//                aaText.text = ""
//            }

            bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
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
        return CGSize(width: collectionView.bounds.size.width, height: 100)
        
    }
}

extension ScrollFeedHPhotoListCell: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("sf scrollview begin: \(scrollView.contentOffset.y)")
        
        //test > vcv pan vs collectionview scroll
//        isScrollActive = true
        aDelegate?.sfcWillBeginDragging(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("sf scrollview scroll: \(scrollView.contentOffset.y)")
        aDelegate?.sfcScrollViewDidScroll(offsetY: scrollView.contentOffset.y)
        
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

extension ScrollFeedHPhotoListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPhotoListAViewCell.identifier, for: indexPath) as! HPhotoListAViewCell
        cell.aDelegate = self
        
        //test > configure cell
        print("scrollfeedhphoto: \(self.frame.width)")
        cell.configure(data: vDataList[indexPath.row], width: self.frame.width)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

     }
}

extension ScrollFeedHPhotoListCell: HListCellDelegate {
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
//        aDelegate?.sfcDidClickVcvClickPost()
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
                    print("sfpost idx frame origin: \(cell.frame.origin), \(originInRootView)")
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
                print("sfphoto idx: \(cell == vc), \(indexPath)")
                
                if(cell == vc) {
                    vDataList[indexPath.row].p_s = idx
                    break
                }
            }
        }
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, ts: Double){
        
    }
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    print("sfphoto play audio: \(cell == vc), \(indexPath)")
                    let intersectedIdx = indexPath.row
                    if(currentPlayingVidIndex > -1) {
                        if(currentPlayingVidIndex != intersectedIdx) {
                            let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                            let idxPath = IndexPath(item: intersectedIdx, section: 0)
                            let prevVc = a.cellForItem(at: prevIdxPath)
                            let currentVc = a.cellForItem(at: idxPath)
                            guard let b = prevVc as? HPhotoListAViewCell else {
                                return
                            }
                            guard let c = currentVc as? HPhotoListAViewCell else {
                                return
                            }
                            b.pauseAudio()

                            c.resumeAudio()
                            currentPlayingVidIndex = intersectedIdx
                            
                            print("reactintersect photo play AA")
                        } else {
                            let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                            let prevVc = a.cellForItem(at: prevIdxPath)
                            guard let b = prevVc as? HPhotoListAViewCell else {
                                return
                            }

                            b.pauseAudio()
                            currentPlayingVidIndex = -1
                        }
                    } else {
                        let idxPath = IndexPath(item: intersectedIdx, section: 0)
                        let currentVc = a.cellForItem(at: idxPath)
                        guard let b = currentVc as? HPhotoListAViewCell else {
                            return
                        }

                        b.resumeAudio()
                        currentPlayingVidIndex = intersectedIdx
                        
                        print("reactintersect photo play BB")
                    }
                    
                    break
                }
            }
        }
    }
}
