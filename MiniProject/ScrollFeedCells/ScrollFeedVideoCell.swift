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
    
    func sfvcDidClickUser()
    func sfvcDidClickPlace()
    func sfvcDidClickSound()
    func sfvcDidClickComment()
    func sfvcDidClickShare()
}

class ScrollFeedVideoCell: UIView {
    
    var vcDataList = [VideoData]()
    var videoCV : UICollectionView?
    var currentIndexPath = IndexPath(item: 0, section: 0)
    
    weak var aDelegate : ScrollFeedVideoCellDelegate?
    
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    var bufferDataList = [VideoData]()
    
    var isInitialized = false
    
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
//        vcDataList.append("b")//test => loading data
        let vData = VideoData()
        vData.setDataType(data: "b")
        vData.setData(data: "b")
        vData.setTextString(data: "b")
        vcDataList.append(vData)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        let videoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    func startPlayVideo() {
        print("fvcAutoplayVideo startplay")
        guard let a = self.videoCV else {
            return
        }
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        print("fvcAutoplayVideo startplay after \(currentVc), \(a)")
        guard let b = currentVc as? VCViewCell else {
            return
        }
        b.playVideo()

    }
    //test > resume current video
    func resumeCurrentVideo() {
        guard let a = self.videoCV else {
            return
        }
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? VCViewCell else {
            return
        }
        b.resumeVideo()
    }
    //test > stop current video for closing
    func stopCurrentVideo() {
        guard let a = self.videoCV else {
            return
        }
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? VCViewCell else {
            return
        }
        b.stopVideo()
    }
    //test > pause current video for closing
    func pauseCurrentVideo() {
        guard let a = self.videoCV else {
            return
        }
        let currentVc = a.cellForItem(at: self.currentIndexPath)
        guard let b = currentVc as? VCViewCell else {
            return
        }
        b.pauseVideo()
    }
    
    //test > scroll to top
    func scrollToTopVideo() {
        videoCV?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        currentIndexPath = IndexPath(item: 0, section: 0)
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

        let w = self.vcDataList.count - 1
        let x = self.currentIndexPath.row
//        let y = self.vcDataList[w]
//        let z = self.vcDataList[x]
        let y = self.vcDataList[w].dataType
        let z = self.vcDataList[x].dataType

        if indexPath.row == vcDataList.count - 1 {

            //test
            print("FeedVideoCell willdisplay: \(dataFetchState)")
            if(dataFetchState == "end") { //means asyncFetchData has been performed once(initialized)
                if(y == "b") {
//                    if(dataPaginateStatus != "end") {
                    if(dataPaginateStatus == "") {
//                        if(pageNumber >= 2) {
//                            asyncPaginateFetchFeed(id: "post_feed_end")
//                        } else {
//                            asyncPaginateFetchFeed(id: "post_feed")
//                        }
                        
                        //test
                        aDelegate?.sfvcAsyncPaginateFeed(cell: self)
                    } else if (dataPaginateStatus == "buffer") {
                        //reload data if buffer has data
                        if(bufferDataList.isEmpty) {
                            self.dataPaginateStatus = "end"
//                            self.vcDataList[self.vcDataList.count - 1] = "c" //"a"
                            
                            let vData = VideoData()
                            vData.setDataType(data: "c")
                            vData.setData(data: "c")
                            vData.setTextString(data: "c")
                            self.vcDataList[self.vcDataList.count - 1] = vData
                        } else {
                            self.dataPaginateStatus = ""
                            self.vcDataList.insert(contentsOf: bufferDataList, at: self.vcDataList.count - 1)

                            bufferDataList.removeAll()
                        }
                        self.videoCV?.reloadData()
                    }
                }
            }
        }
//
//        //test > autoplay if current indexpath is the same as willDisplay indexpath, e.g. reload data
//        if(isPanelOpen) {
            if(currentIndexPath == indexPath && z == "a") {
                if let c = cell as? VCViewCell {
                    print("FeedVideoCell willdisplay play: \(indexPath), \(currentIndexPath)")
//                    c.playVideo()
                    aDelegate?.sfvcAutoplayVideo(cell: self, vCCell: c)
                }
            }
//        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("videoCVpanel didEndDisplay: \(indexPath)")
        
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
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCViewCell.identifier, for: indexPath) as! VCViewCell
//        cell.aDelegate = self
//
//        //test > video
//        cell.configure(data: vcDataList[indexPath.row])
//
//        return cell
        
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
    
        aDelegate?.sfvcWillBeginDragging(offsetY: scrollView.contentOffset.y)
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
        
//        let z = vcDataList[visibleIndexPath.row]
        let z = vcDataList[visibleIndexPath.row].dataType
        print("video scroll page point: \(visibleIndexPath), \(currentIndexPath), \(z)")
        
        //play video when current page
        let currentVc = a.cellForItem(at: visibleIndexPath)
        let previousVc = a.cellForItem(at: currentIndexPath)
//        print("video scroll page check: \(currentVc), \(previousVc)")
        
        currentIndexPath = visibleIndexPath
        
        guard let b = currentVc as? VCViewCell else {
            return
        }

        //test > only play video if data is "a"(valid data, not loading spinner) && scroll from previous viewcell
        if(currentVc != previousVc && z == "a") {
            b.playVideo()
        }
        
        aDelegate?.sfvcSrollViewDidEndDecelerating(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
        aDelegate?.sfvcScrollViewDidEndDragging(offsetY: scrollView.contentOffset.y, decelerate: decelerate)
    }
}

extension ScrollFeedVideoCell: VCViewCellDelegate{
    func didClickUser() {
        aDelegate?.sfvcDidClickUser()
    }
    
    func didClickPlace() {
        aDelegate?.sfvcDidClickPlace()
    }
    
    func didClickSound() {
        aDelegate?.sfvcDidClickSound()
    }
    
    func didClickComment() {
//        openComment()
        aDelegate?.sfvcDidClickComment()
    }
    func didClickShare() {
        //test
//        openShareSheet()
        aDelegate?.sfvcDidClickShare()
    }
}
