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
    func sfcDidClickVcvShare(id: String, dataType: String) //try
    func sfcDidClickVcvClickUser(id: String) //try
    func sfcDidClickVcvClickPlace(id: String) //try
    func sfcDidClickVcvClickSound(id: String) //try
    func sfcDidClickVcvClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat) //try
    func sfcDidClickVcvClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    func sfcDidClickVcvClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    
    func sfcAsyncFetchFeed()
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?)
    
    func sfcIsScrollCarousel(isScroll: Bool) //test carousel
    
    //test
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?)
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?)
}

protocol ScrollFeedHResultListCellDelegate : AnyObject {
    func didScrollFeedHResultClickSignIn()
    func didScrollFeedHResultResignKeyboard()
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
    
    //test > code for feed
    var feedCode = ""
    
    //test > selectable items
    var selectedItemIdx = -1
    
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
    func unselectItemData() {
        selectedItemIdx = -1
    }
}

class ScrollDataFeedCell: ScrollFeedCell {
//    var vDataList = [PostData]()
    var vDataList = [BaseData]()
}

class ScrollPhotoDataFeedCell: ScrollFeedCell {
    var vDataList = [PhotoData]()

}

class ScrollFeedHResultListCell: ScrollFeedCell {
//    var vDataList = [PostData]()
    var vDataList = [BaseData]()

    //test > additional delegate
    weak var bDelegate : ScrollFeedHResultListCellDelegate?
    
    func destroyCell() {}
}

class ScrollFeedHNotifyListCell: ScrollFeedCell {
//    var vDataList = [String]()
    var vDataList = [NotifyData]()
}
