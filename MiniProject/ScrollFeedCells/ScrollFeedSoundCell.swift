//
//  ScrollFeedHResultHashtagListCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol ScrollFeedSoundCellDelegate : AnyObject {
    func sfscWillBeginDragging(offsetY: CGFloat)
    func sfscScrollViewDidScroll(offsetY: CGFloat)
    func sfscSrollViewDidEndDecelerating(offsetY: CGFloat)
    func sfscScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool)
    
    func sfscAsyncFetchFeed()
    func sfscAsyncPaginateFeed(cell: ScrollFeedSoundCell?)
    func sfscAutoplayVideo(cell: ScrollFeedSoundCell?, vCCell: SCViewCell?)
    
    func sfscDidClickUser(id: String)
    func sfscDidClickPlace(id: String)
    func sfscDidClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
    func sfscDidClickComment()
    func sfscDidClickShare(id: String, dataType: String)
    
    func sfscDidClickRefresh()
}

class ScrollFeedSoundCell: UIView {
    var vcDataList = [SoundData]()
    var videoCV : UICollectionView?
    var currentIndexPath = IndexPath(item: 0, section: 0)
    
    weak var aDelegate : ScrollFeedSoundCellDelegate?
    
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    
    var isInitialized = false
    
    var selectedItemIdx = -1
    
    //test
    var hideCellIndex = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        contentView.clipsToBounds = true
        self.clipsToBounds = true

        addSubViews()
        
        //test
        print("FeedVideoCell init 2")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        videoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let videoCV = videoCV else {
            return
        }
        videoCV.register(SCAViewCell.self, forCellWithReuseIdentifier: SCAViewCell.identifier)
        videoCV.register(SCBViewCell.self, forCellWithReuseIdentifier: SCBViewCell.identifier)
        videoCV.isPagingEnabled = true
        videoCV.dataSource = self
        videoCV.delegate = self
        videoCV.showsVerticalScrollIndicator = false
//        videoCV.backgroundColor = .black
        videoCV.backgroundColor = .ddmBlackOverlayColor
//        videoCV.backgroundColor = .clear
        self.addSubview(videoCV)
        videoCV.translatesAutoresizingMaskIntoConstraints = false
        videoCV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        videoCV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        videoCV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        videoCV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        videoCV.contentInsetAdjustmentBehavior = .never
        videoCV.layer.cornerRadius = 10
        videoCV.alwaysBounceVertical = true
    }
    
    //test > start play video
    func startPlayMedia() {
        guard let a = self.videoCV else {
            return
        }
        print("aaa startplay: \(a.indexPathsForVisibleItems), \(currentIndexPath)")
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? SCViewCell else {
            return
        }
        if(currentIndexPath.row > -1) {
            if(!vcDataList.isEmpty && currentIndexPath.row < vcDataList.count) {
                let z = vcDataList[currentIndexPath.row].dataCode
                if(z == "a") {
                    b.playVideo()
                }
            }
        }
    }
    //test > resume current video
    func resumePlayingMedia() {
        guard let a = self.videoCV else {
            return
        }
        print("aaa resume: \(a.indexPathsForVisibleItems), \(currentIndexPath)")
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? SCViewCell else {
            return
        }
        if(currentIndexPath.row > -1) {
            if(!vcDataList.isEmpty && currentIndexPath.row < vcDataList.count) {
                let z = vcDataList[currentIndexPath.row].dataCode
                if(z == "a") {
                    b.resumeVideo()
                }
            }
        }
    }
    //test > stop current video for closing
    func stopPlayingMedia() {
        guard let a = self.videoCV else {
            return
        }
        print("aaa stopplay: \(a.indexPathsForVisibleItems), \(currentIndexPath)")
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? SCViewCell else {
            return
        }
        if(currentIndexPath.row > -1) {
            if(!vcDataList.isEmpty && currentIndexPath.row < vcDataList.count) {
                let z = vcDataList[currentIndexPath.row].dataCode
                if(z == "a") {
                    b.stopVideo()
                }
            }
        }
    }
    //test > pause current video for closing
    func pausePlayingMedia() {
        guard let a = self.videoCV else {
            return
        }
        print("aaa pause: \(a.indexPathsForVisibleItems), \(currentIndexPath)")
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? SCViewCell else {
            return
        }
        if(currentIndexPath.row > -1) {
            if(!vcDataList.isEmpty && currentIndexPath.row < vcDataList.count) {
                let z = vcDataList[currentIndexPath.row].dataCode
                if(z == "a") {
                    b.pauseVideo()
                }
            }
        }
    }
    //**test > destroy cell
    func destroyCell() {
        guard let a = self.videoCV else {
            return
        }
        for cell in a.visibleCells {
            if let c = cell as? SCViewCell {
                c.destroyCell()
            }
        }
    }
    
    //test > scroll to top
    func scrollToTopVideo() {
        videoCV?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        currentIndexPath = IndexPath(item: 0, section: 0)
    }
    
    //test > selected item for delete etc
    var isUserScrolling = false
    func unselectItemData(){
        selectedItemIdx = -1
    }
    
    //test > make viewcell image reappear after video panel closes
    func dehideCell(){
        if(hideCellIndex > -1) {
            let vc = videoCV?.cellForItem(at: IndexPath(item: hideCellIndex, section: 0))
            guard let b = vc as? SCViewCell else {
                return
            }
            b.dehideCell()
            hideCellIndex = -1
        }
    }
    
    func hideCellAt(itemIndex: Int) {
        let vc = videoCV?.cellForItem(at: IndexPath(item: itemIndex, section: 0))
        guard let b = vc as? SCViewCell else {
            return
        }
        b.hideCell()
        hideCellIndex = itemIndex
    }
}

extension ScrollFeedSoundCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

//        print("video scroll page point willdisplay: \(currentIndexPath),/ \(indexPath), \(collectionView.indexPathsForVisibleItems)")
        print("video scroll page point willdisplay: \(currentIndexPath), \(indexPath), \(isUserScrolling)")
        
        //test 2
        if indexPath.row == vcDataList.count - 1 {
            if(dataFetchState == "end") { //means asyncFetchData has been performed once(initialized)
                let y = vcDataList[indexPath.row].dataCode
                if(y == "b") {
                    if(dataPaginateStatus == "") {
                        aDelegate?.sfscAsyncPaginateFeed(cell: self)
                    }
                }
            }
        }
        
        //test 2 > only play video if user not scrolling
        if(!isUserScrolling) {
            let z = vcDataList[indexPath.row].dataCode
            if(z == "a") {
                if let c = cell as? SCViewCell {
                    aDelegate?.sfscAutoplayVideo(cell: self, vCCell: c)
                }
            }
            //test > renew currentindexpath after deleted item
            currentIndexPath = indexPath
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("video scroll page point enddisplay: \(indexPath)")
        
        //test > stop video when scroll past
        if let c = cell as? SCViewCell {
            c.stopVideo()
            print("FeedVideoCell didEndDisplay stop video: \(indexPath)")
        }
    }
}

extension ScrollFeedSoundCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("FeedVideoCell cellForItem: \(indexPath)")
        
        //ORI
        if(vcDataList[indexPath.row].uiMode == SoundTypes.S_0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCAViewCell.identifier, for: indexPath) as! SCAViewCell
            cell.aDelegate = self
            
            //test > video
            cell.configure(data: vcDataList[indexPath.row])
            
            return cell
        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCBViewCell.identifier, for: indexPath) as! SCBViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCAViewCell.identifier, for: indexPath) as! SCAViewCell
            cell.aDelegate = self
            
            //test > video
            cell.configure(data: vcDataList[indexPath.row])
            
            return cell
        }
    }
}

extension ScrollFeedSoundCell: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollview begin: \(scrollView.contentOffset.y)")
        print("video scroll page point begin drag: ")
        aDelegate?.sfscWillBeginDragging(offsetY: scrollView.contentOffset.y)
        
        //test
        isUserScrolling = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollview scroll: ")
        aDelegate?.sfscScrollViewDidScroll(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("video scrollview end: \(scrollView.contentOffset.y)")
        print("videoCVpanel endAccelerating: \(scrollView.contentOffset.y)")
        
        guard let a = scrollView as? UICollectionView else {
            return
        }
        
        //method 4 => IMO the best and accurate
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = a.indexPathForItem(at: visiblePoint)
        guard let visibleIndexPath = visibleIndexPath else {
            return
        }
        
        print("video scroll page point: \(visibleIndexPath), \(a.indexPathsForVisibleItems)")
        
        //play video when current page
        let currentVc = a.cellForItem(at: visibleIndexPath)
        let previousVc = a.cellForItem(at: currentIndexPath)
//        print("video scroll page check: \(currentVc), \(previousVc)")
        
        currentIndexPath = visibleIndexPath
        
        guard let b = currentVc as? SCViewCell else {
            return
        }
        
        if(!vcDataList.isEmpty) {
            let z = vcDataList[visibleIndexPath.row].dataCode
            
            //test > only play video if data is "a"(valid data, not loading spinner) && scroll from previous viewcell to prevent restart of video if scroll slightly
            if(currentVc != previousVc && z == "a") {
                b.playVideo()
            }
        }
        
        aDelegate?.sfscSrollViewDidEndDecelerating(offsetY: scrollView.contentOffset.y)
        
        //test
        isUserScrolling = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
//        print("video scroll page point end drag: ")
        aDelegate?.sfscScrollViewDidEndDragging(offsetY: scrollView.contentOffset.y, decelerate: decelerate)
    }
}

extension ScrollFeedSoundCell: SCViewCellDelegate{
    func didSCClickUser(id: String) {
        aDelegate?.sfscDidClickUser(id: id)
    }
    
    func didSCClickPlace(id: String) {
        aDelegate?.sfscDidClickPlace(id: id)
    }
    
    func didSCClickSound(id: String, vc: SCViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String) {
//        aDelegate?.sfscDidClickSound(id: id)
        
        //test > new method for non-scrollable panel
        if let a = videoCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    aDelegate?.sfscDidClickSound(id: id, pointX: pointX1, pointY: pointY1, view:view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    
    func didSCClickComment() {
//        openComment()
        aDelegate?.sfscDidClickComment()
    }
    func didSCClickShare(vc: SCViewCell, id: String, dataType: String) {
        
        guard let a = self.videoCV else {
            return
        }
        
        //test 3 > use indexpath for visible item
        let idxPath = a.indexPath(for: vc)
        guard let idxPath = idxPath else {
            return
        }
        aDelegate?.sfscDidClickShare(id: id, dataType: dataType)
        selectedItemIdx = idxPath.row
    }
    func didSCClickRefresh() {
        aDelegate?.sfscDidClickRefresh()
    }
}
