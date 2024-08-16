//
//  ScrollFeedCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

protocol ScrollFeedCellDelegate : AnyObject {
    func sfcWillBeginDragging(offsetY: CGFloat)
    func sfcScrollViewDidScroll(offsetY: CGFloat)
    func sfcSrollViewDidEndDecelerating(offsetY: CGFloat)
    func sfcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool)
    
    func sfcVCVPanBegan(offsetY: CGFloat, isScrollActive: Bool)
    func sfcVCVPanChanged(offsetY: CGFloat, isScrollActive: Bool)
    func sfcVCVPanEnded(offsetY: CGFloat, isScrollActive: Bool)
    
    func sfcDidClickVcvRefresh() //try
    func sfcDidClickVcvComment() //try
    func sfcDidClickVcvLove() //try
    func sfcDidClickVcvShare() //try
    func sfcDidClickVcvClickUser() //try
    func sfcDidClickVcvClickPlace() //try
    func sfcDidClickVcvClickSound() //try
    func sfcDidClickVcvClickPost() //try
    func sfcDidClickVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    func sfcDidClickVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    
    func sfcAsyncFetchFeed()
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?)
    
    func sfcIsScrollCarousel(isScroll: Bool) //test carousel
    
    //test
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?)
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?)
}

class ScrollFeedCell: UIView {
    
//    var vDataList = [String]()
    var vCV : UICollectionView?
    let aSpinner = SpinLoader()
    var isInitialized = false
    var dataPaginateStatus = "" //test
    weak var aDelegate : ScrollFeedCellDelegate?
    
    //footer
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    var footerState = ""
    var footerAaText = ""
    
    //test
//    var scrollFeedHeightCons: NSLayoutConstraint?
    
    //test > code for feed
    var feedCode = ""
    
    func initialize() {
        
    }
    
    func scrollToTop() {
        
    }
    
    func setShowVerticalScroll(isShowVertical: Bool) {
        
    }
    
    func setCode(code: String) {
        feedCode = code
    }
    
    func configureFooterUI(data: String) {
        
    }
    func setFooterAaText(text: String) {
        footerAaText = text
    }
}

class ScrollDataFeedCell: ScrollFeedCell {
    var vDataList = [PostData]()

}

class ScrollPhotoDataFeedCell: ScrollFeedCell {
    var vDataList = [PhotoData]()

}

class ScrollFeedHResultListCell: ScrollFeedCell {
//    var vDataList = [String]()
    var vDataList = [PostData]()
    
    //test > additional delegate
    weak var bDelegate : ScrollFeedHResultListCellDelegate?
}

class ScrollFeedHNotifyListCell: ScrollFeedCell {
    var vDataList = [String]()
}
