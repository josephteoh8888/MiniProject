//
//  ScrollFeedVideoCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol ScrollFeedVideoCellDelegate : AnyObject {
    func sfvcWillBeginDragging(offsetY: CGFloat)
    func sfvcScrollViewDidScroll(offsetY: CGFloat)
    func sfvcSrollViewDidEndDecelerating(offsetY: CGFloat)
    func sfvcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool)
    
    func sfvcAsyncFetchFeed()
    func sfvcAsyncPaginateFeed(cell: ScrollFeedVideoCell?)
    func sfvcAutoplayVideo(cell: ScrollFeedVideoCell?, vCCell: VCViewCell?)
    
    func sfvcDidClickUser(id: String)
    func sfvcDidClickPlace(id: String)
    func sfvcDidClickSound(id: String)
    func sfvcDidClickComment()
    func sfvcDidClickShare()
    
    func sfvcDidClickRefresh()
}

//TODO: erase currentIndexPath, replace with visibleitems
class ScrollFeedVideoCell: UIView {
    
    var vcDataList = [VideoData]()
    var videoCV : UICollectionView?
    var currentIndexPath = IndexPath(item: 0, section: 0)
    
    weak var aDelegate : ScrollFeedVideoCellDelegate?
    
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    
    var isInitialized = false
    
    var selectedItemIdx = -1
    
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

//        let vData = VideoData()
//        vData.setDataType(data: "b")
//        vData.setData(data: "b")
//        vData.setTextString(data: "b")
//        vcDataList.append(vData)

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
        videoCV.register(VCAViewCell.self, forCellWithReuseIdentifier: VCAViewCell.identifier)
        videoCV.register(VCBViewCell.self, forCellWithReuseIdentifier: VCBViewCell.identifier)
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
        guard let b = currentVc as? VCViewCell else {
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
        guard let b = currentVc as? VCViewCell else {
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
        guard let b = currentVc as? VCViewCell else {
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
        guard let b = currentVc as? VCViewCell else {
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
            if let c = cell as? VCViewCell {
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
}

extension ScrollFeedVideoCell: UICollectionViewDelegateFlowLayout {
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
        
//        let w = self.vcDataList.count - 1
//        let x = self.currentIndexPath.row
//        let y = self.vcDataList[w].dataType
//        let z = self.vcDataList[x].dataType
//        
//        if indexPath.row == vcDataList.count - 1 {
//
//            //test
//            print("FeedVideoCell willdisplay: \(dataFetchState)")
//            if(dataFetchState == "end") { //means asyncFetchData has been performed once(initialized)
//                if(y == "b") {
//                    if(dataPaginateStatus == "") {
//                        //test
//                        aDelegate?.sfvcAsyncPaginateFeed(cell: self)
//                    }
//                }
//            }
//        }
//
        //test 2
        if indexPath.row == vcDataList.count - 1 {
            if(dataFetchState == "end") { //means asyncFetchData has been performed once(initialized)
                let y = vcDataList[indexPath.row].dataCode
                if(y == "b") {
                    if(dataPaginateStatus == "") {
                        aDelegate?.sfvcAsyncPaginateFeed(cell: self)
                    }
                }
            }
        }
        
////        //test > autoplay if current indexpath is the same as willDisplay indexpath, e.g. reload data
//        if(currentIndexPath == indexPath && z == "a") {
//            if let c = cell as? VCViewCell {
//                print("FeedVideoCell willdisplay play: \(indexPath), \(currentIndexPath)")
//                aDelegate?.sfvcAutoplayVideo(cell: self, vCCell: c)
//            }
//        }
        
        //test 2 > only play video if user not scrolling
        if(!isUserScrolling) {
            let z = vcDataList[indexPath.row].dataCode
            if(z == "a") {
                if let c = cell as? VCViewCell {
                    aDelegate?.sfvcAutoplayVideo(cell: self, vCCell: c)
                }
            }
            //test > renew currentindexpath after deleted item
            currentIndexPath = indexPath
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("video scroll page point enddisplay: \(indexPath)")
        
        //test > stop video when scroll past
        if let c = cell as? VCViewCell {
            c.stopVideo()
            print("FeedVideoCell didEndDisplay stop video: \(indexPath)")
        }
    }
}

extension ScrollFeedVideoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("FeedVideoCell cellForItem: \(indexPath)")
        
        //test > for ui mode = pure_video
        if(vcDataList[indexPath.row].uiMode == VideoTypes.V_LOOP) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCAViewCell.identifier, for: indexPath) as! VCAViewCell
            cell.aDelegate = self
            
            //test > video
            cell.configure(data: vcDataList[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCBViewCell.identifier, for: indexPath) as! VCBViewCell
            
            //test > video
            cell.configure(data: vcDataList[indexPath.row])
            
            return cell
        }
    }
}

extension ScrollFeedVideoCell: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollview begin: \(scrollView.contentOffset.y)")
        print("video scroll page point begin drag: ")
        aDelegate?.sfvcWillBeginDragging(offsetY: scrollView.contentOffset.y)
        
        //test
        isUserScrolling = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollview scroll: ")
        aDelegate?.sfvcScrollViewDidScroll(offsetY: scrollView.contentOffset.y)
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
        
        guard let b = currentVc as? VCViewCell else {
            return
        }
        
        if(!vcDataList.isEmpty) {
            let z = vcDataList[visibleIndexPath.row].dataCode
            
            //test > only play video if data is "a"(valid data, not loading spinner) && scroll from previous viewcell to prevent restart of video if scroll slightly
            if(currentVc != previousVc && z == "a") {
                b.playVideo()
            }
        }
        
        aDelegate?.sfvcSrollViewDidEndDecelerating(offsetY: scrollView.contentOffset.y)
        
        //test
        isUserScrolling = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
//        print("video scroll page point end drag: ")
        aDelegate?.sfvcScrollViewDidEndDragging(offsetY: scrollView.contentOffset.y, decelerate: decelerate)
    }
}

extension ScrollFeedVideoCell: VCViewCellDelegate{
    func didClickUser(id: String) {
        aDelegate?.sfvcDidClickUser(id: id)
    }
    
    func didClickPlace(id: String) {
        aDelegate?.sfvcDidClickPlace(id: id)
    }
    
    func didClickSound(id: String) {
        aDelegate?.sfvcDidClickSound(id: id)
    }
    
    func didClickComment() {
//        openComment()
        aDelegate?.sfvcDidClickComment()
    }
    func didClickShare(vc: VCViewCell) {
        //test
//        aDelegate?.sfvcDidClickShare()
        
        guard let a = self.videoCV else {
            return
        }
        //test 2
//        print("video scroll page point share: \(a.indexPathsForVisibleItems)")
//        let currentVc = a.cellForItem(at: self.currentIndexPath)
//        if(currentVc == vc) {
//            
//            aDelegate?.sfvcDidClickShare()
//            
//            selectedItemIdx = currentIndexPath.row
//            print("scrollfeedvideo selected \(selectedItemIdx)")
//        }
        
        //test 3 > use indexpath for visible item
        let idxPath = a.indexPath(for: vc)
        guard let idxPath = idxPath else {
            return
        }
        aDelegate?.sfvcDidClickShare()
        selectedItemIdx = idxPath.row
    }
    func didClickRefresh() {
        aDelegate?.sfvcDidClickRefresh()
    }
}
