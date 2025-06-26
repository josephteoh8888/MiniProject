//
//  PostPhotoContentCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 25/08/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol ContentCellDelegate : AnyObject {
    func contentCellIsScrollCarousel(isScroll: Bool)
    func contentCellCarouselIdx(cc: UIView,idx: Int)
    func contentCellVideoStopTime(cc: UIView,ts: Double)
    func contentCellDidClickVcvClickPhoto(id: String, cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func contentCellDidClickVcvClickVideo(id: String, cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func contentCellDidDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat)
    func contentCellDidClickSound(id: String)
    func contentCellDidClickUser(id: String)
    func contentCellDidClickPlace(id: String)
    func contentCellDidClickPost(id: String, dataType: String, cc: UIView, pointX: CGFloat, pointY: CGFloat)
    func contentCellDidClickVcvClickPlay(cc: UIView, isPlay: Bool)
    
    //test > reload item for resizing
    func contentCellResize(cc: UIView)
}

class ContentCell: UIView {
    func dehideCell() {}
    func hideCell() {}
    func destroyCell() {}
    func selectCell() {}
    func unselectCell() {}
}
class MediaContentCell: ContentCell {
    func resumeMedia() {}
    func pauseMedia() {}
    func playMedia() {}
    func stopMedia() {}
}
class PostPhotoContentCell: ContentCell {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let scrollView = UIScrollView()
    let bubbleBox = PageBubbleIndicator()
    
    weak var aDelegate : ContentCellDelegate?
    
    //test
    var current_p_s = 0
    var initial_x = 0.0 //test for scrollview x-scroll direction
    
    //test
    var isAutohideEnabled = true
    var isSelectable = false //for post creator panel
    
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
        self.layer.borderWidth = 0.0 //2
        self.layer.borderColor = UIColor.clear.cgColor //default
        
        let pConBg = UIView()
//        pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        pConBg.layer.cornerRadius = 10
//        pConBg.layer.opacity = 0.4 //0.2
        
        //carousel of images
//        let scrollView = UIScrollView()
//        aHLightRect1.addSubview(scrollView)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true //0
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        scrollView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true //false
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10 //5

//        let bubbleBox = PageBubbleIndicator()
        bubbleBox.backgroundColor = .clear
//        aHLightRect1.addSubview(bubbleBox)
        self.addSubview(bubbleBox)
        bubbleBox.translatesAutoresizingMaskIntoConstraints = false
//                    bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
        bubbleBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
        bubbleBox.isHidden = true
    }
    
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
    func configure(data: [String]) {
//    func configure(data: String) {
//        if(data == "a") {
//            vDataList.append("p")
        
            for p in data {
                vDataList.append(p)
            }

            for p_ in vDataList {
                
//                let gifUrl = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
                
//                let gifImage1 = SDAnimatedImageView()
//                gifImage1.contentMode = .scaleAspectFill
//                gifImage1.clipsToBounds = true
//                gifImage1.sd_setImage(with: gifUrl)
                let gifImage1 = CustomImageView()
                gifImage1.setupViews()
//                gifImage1.setImage(url: gifUrl)
                gifImage1.setImage(url: p_)
                scrollView.addSubview(gifImage1)
                gifImage1.translatesAutoresizingMaskIntoConstraints = false
                gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
                gifImage1.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //280
                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    gifImage1.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                }
//                gifImage1.isUserInteractionEnabled = true
//                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                aHLightViewArray.append(gifImage1)
                gifImage1.aDelegate = self
            }
            
            let dataCount = vDataList.count
            if(dataCount > 1) {
                bubbleBox.setConfiguration(number: dataCount, color: .white)//yellow
                bubbleBox.isHidden = false
            }
            
            let totalWidth = CGFloat(dataCount) * viewWidth
            scrollView.contentSize = CGSize(width: totalWidth, height: viewHeight) //800, 280
//        }
    }
    
    //test > revert to last viewed photo in carousel
    func setState(p: Int) {
        bubbleBox.setIndicatorSelected(index: p)
        
        let xOffset = CGFloat(p) * viewWidth
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        
        //test
        current_p_s = p
    }
    
    func setAutohide(isEnabled: Bool) {
        isAutohideEnabled = isEnabled
    }
    
    override func hideCell() {
//        scrollView.isHidden = true
        
        //test 2 > try opacity
        self.layer.opacity = 0.1
    }
    
    override func dehideCell() {
//        scrollView.isHidden = false
        
        //test 2 > try opacity
        self.layer.opacity = 1.0
    }
    
    func setSelectable(isEnabled: Bool) {
        isSelectable = isEnabled
    }
    
    override func selectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 2.0 //2
            self.layer.borderColor = UIColor.ddmGoldenYellowColor.cgColor //default
        }
    }

    override func unselectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 0.0 //2
            self.layer.borderColor = UIColor.clear.cgColor //default
        }
    }
}

extension PostPhotoContentCell: CustomImageViewDelegate {
    func customImageViewClickPhoto(){
        let pFrame = scrollView.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + scrollView.frame.width/2
        let pointY = pFrame.y + scrollView.frame.height/2
        aDelegate?.contentCellDidClickVcvClickPhoto(id: "", cc: self, pointX: pointX, pointY: pointY, view: scrollView, mode: PhotoTypes.P_0)
        
        //test > hide photo
        if(isAutohideEnabled) {
            hideCell()
        }
    }
    
    func customImageViewDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
}

extension PostPhotoContentCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("postphoto scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
        
        //test
        initial_x = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        print("postphoto scrollview scroll: \(x), \(y)")
//        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
        
        //test
        let x_diff = x - initial_x
        print("postphoto scrollview scroll: \(x_diff)")
        if(vDataList.count > 1) {
            if(current_p_s == 0) {
                if(x_diff < 0) {
                    aDelegate?.contentCellIsScrollCarousel(isScroll: false)
                }
            }
            else if (current_p_s == vDataList.count - 1) {
                if(x_diff > 0) {
                    aDelegate?.contentCellIsScrollCarousel(isScroll: false)
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("postphoto scrollview end: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
        
        //test > for bubble when scrolled thru carousel
        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        print("Current item index: \(tempCurrentIndex)")
        
        bubbleBox.setIndicatorSelected(index: tempCurrentIndex)
        
        //test > for carousel page
        aDelegate?.contentCellCarouselIdx(cc: self, idx: tempCurrentIndex)
        
        //test
        current_p_s = tempCurrentIndex
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("postphoto scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("postphoto scrollview animation ended")

    }
}

class PostPhotoShotContentCell: ContentCell {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var descHeight: CGFloat = 0
    var descTxt = ""
    
    let scrollView = UIScrollView()
    let bubbleBox = PageBubbleIndicator()
    let aaText = UILabel()
    let a2UserPhoto = SDAnimatedImageView()
    
    weak var aDelegate : ContentCellDelegate?
    
    //test
    var current_p_s = 0
    var initial_x = 0.0 //test for scrollview x-scroll direction
    
    //test
    var isAutohideEnabled = true
    var isSelectable = false //for post creator panel
    
    let pConBg = UIView()
    
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
    
    //description label height
    func setDescHeight(lHeight: CGFloat, txt: String) {
        descHeight = lHeight
        descTxt = txt
    }
    
    func redrawUI() {
      
//        let pConBg = UIView()
        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        pConBg.layer.cornerRadius = 10
//        pConBg.layer.opacity = 0.4 //0.2
        
        //carousel of images
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        scrollView.heightAnchor.constraint(equalToConstant: viewHeight - descHeight).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true //false
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10 //5
        scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

//        let bubbleBox = PageBubbleIndicator()
        bubbleBox.backgroundColor = .clear
//        aHLightRect1.addSubview(bubbleBox)
        self.addSubview(bubbleBox)
        bubbleBox.translatesAutoresizingMaskIntoConstraints = false
//                    bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
        bubbleBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
        bubbleBox.isHidden = true
        
        //test > shot description
        let pConBottom = UIView()
//        pConBottom.frame = CGRect(x: 0, y: 0, width: 370, height: 40)
        self.addSubview(pConBottom)
        pConBottom.translatesAutoresizingMaskIntoConstraints = false
        pConBottom.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true
        pConBottom.heightAnchor.constraint(equalToConstant: descHeight).isActive = true
        pConBottom.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        pConBottom.bottomAnchor.constraint(equalTo: pConBg.bottomAnchor, constant: 0).isActive = true //0
        pConBottom.isUserInteractionEnabled = true
        pConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoSClicked)))
        
        let moreBtn = UIImageView()
        moreBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
        moreBtn.tintColor = .white
        pConBottom.addSubview(moreBtn)
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
        moreBtn.trailingAnchor.constraint(equalTo: pConBottom.trailingAnchor, constant: -5).isActive = true
        moreBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
        moreBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        //test 2 > just user photo at desc
        let e2UserCover = UIView()
        e2UserCover.backgroundColor = .clear
        pConBottom.addSubview(e2UserCover)
        e2UserCover.translatesAutoresizingMaskIntoConstraints = false
        e2UserCover.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
        e2UserCover.leadingAnchor.constraint(equalTo: pConBottom.leadingAnchor, constant: 5).isActive = true
        e2UserCover.heightAnchor.constraint(equalToConstant: 24).isActive = true //20
        e2UserCover.widthAnchor.constraint(equalToConstant: 24).isActive = true //20
        e2UserCover.layer.cornerRadius = 12
        e2UserCover.layer.opacity = 1.0 //default 0.3

//        let a2UserPhoto = SDAnimatedImageView()
        pConBottom.addSubview(a2UserPhoto)
        a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
        a2UserPhoto.widthAnchor.constraint(equalToConstant: 24).isActive = true //20
        a2UserPhoto.heightAnchor.constraint(equalToConstant: 24).isActive = true
        a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
        a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
        a2UserPhoto.contentMode = .scaleAspectFill
        a2UserPhoto.layer.masksToBounds = true
        a2UserPhoto.layer.cornerRadius = 12
        a2UserPhoto.backgroundColor = .ddmDarkColor
        
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.font = .systemFont(ofSize: 13)
        aaText.font = .boldSystemFont(ofSize: 12)
        aaText.numberOfLines = 1
        pConBottom.addSubview(aaText)
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
        aaText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 7).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
    }
    
    func changeBaseColorInQuoteMode() {
        //test
//        pConBg.backgroundColor = .ddmDarkBlack
        pConBg.backgroundColor = .ddmDarkColor
        a2UserPhoto.backgroundColor = .ddmBlackDark
    }
    
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
//    func configure(data: [String], state: Int) {
    func configure(data: [String]) {
//    func configure(data: String) {
//        if(data == "a") {
//            vDataList.append("p")
//            vDataList.append("p")
        
            for p in data {
                vDataList.append(p)
            }
        
            for p_ in vDataList {
//                let gifUrl = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
                
//                let gifImage1 = SDAnimatedImageView()
//                gifImage1.contentMode = .scaleAspectFill
//                gifImage1.clipsToBounds = true
//                gifImage1.sd_setImage(with: gifUrl)
                let gifImage1 = CustomImageView()
                gifImage1.setupViews()
//                gifImage1.setImage(url: gifUrl)
                gifImage1.setImage(url: p_)
                scrollView.addSubview(gifImage1)
                gifImage1.translatesAutoresizingMaskIntoConstraints = false
                gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
                gifImage1.heightAnchor.constraint(equalToConstant: viewHeight - descHeight).isActive = true //280
                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    gifImage1.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                }
//                gifImage1.isUserInteractionEnabled = true
//                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                aHLightViewArray.append(gifImage1)
                gifImage1.aDelegate = self
            }
            
            let dataCount = vDataList.count
            if(dataCount > 1) {
                bubbleBox.setConfiguration(number: dataCount, color: .white) //yellow
                bubbleBox.isHidden = false
            }
            
            let totalWidth = CGFloat(dataCount) * viewWidth
            scrollView.contentSize = CGSize(width: totalWidth, height: viewHeight - descHeight) //800, 280
            
            //test > set state p_s asynchronously
//            setState(p: state)
            refreshStateUI()
    }
    
//    func configure(data: String, state: Int) {
    func configure(data: String) {
        asyncConfigure(data: data)
    }
    
    //*test > async fetch photo shot data
//    func asyncConfigure(data: String, state: Int) {
    func asyncConfigure(data: String) {
//        let id_ = "post"
//        DataFetchManager.shared.fetchPhotoFeedData(id: id_, isPaginate: false) { [weak self]result in
        let id_ = "photo1"
        DataFetchManager.shared.fetchPhotoData2(id: id_) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
//                    if(!l.isEmpty) {
//                        let l_0 = l[0]
                        let uData = PhotoData()
//                        uData.setData(rData: l_0)
                        uData.setData(rData: l)
                        let l_ = uData.dataCode
                        
                        if(l_ == "a") {
                            let t = uData.dataTextString
                            let dataCL = uData.contentDataArray
                            
                            self.aaText.text = t

                            let image2Url = URL(string: "")
                            self.a2UserPhoto.sd_setImage(with: image2Url)
                            
                            for cl in dataCL {
                                let l = cl.dataCode
                                if(l == "p") {
                                    let da = cl.dataArray
                                    print("postphotoshot da: \(da)")
//                                    self.configure(data: da, state: state)
                                    self.configure(data: da)
                                }
                            }
                        }
//                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    guard let self = self else {
                        return
                    }
                }
                break
            }
        }
    }
    
    //test > revert to last viewed photo in carousel
    func setState(p: Int) {
//        bubbleBox.setIndicatorSelected(index: p)
//        
//        let xOffset = CGFloat(p) * viewWidth
//        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        
        //test
        current_p_s = p
    }
    
    //test > new method to revert to last viewed photo in carousel
    func refreshStateUI() {
        bubbleBox.setIndicatorSelected(index: current_p_s)
        
        let xOffset = CGFloat(current_p_s) * viewWidth
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
    }
    
    func setAutohide(isEnabled: Bool) {
        isAutohideEnabled = isEnabled
    }
    
    override func hideCell() {
//        scrollView.isHidden = true
        
        //test 2 > try opacity
        self.layer.opacity = 0.1
    }
    
    override func dehideCell() {
//        scrollView.isHidden = false
        
        //test 2 > try opacity
        self.layer.opacity = 1.0
    }
    
    func setSelectable(isEnabled: Bool) {
        isSelectable = isEnabled
    }
    
    override func selectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 2.0 //2
            self.layer.borderColor = UIColor.ddmGoldenYellowColor.cgColor //default
        }
    }

    override func unselectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 0.0 //2
            self.layer.borderColor = UIColor.clear.cgColor //default
        }
    }
    
    @objc func onPhotoSClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click photo shot:")
        let pFrame = scrollView.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + scrollView.frame.width/2
        let pointY = pFrame.y + scrollView.frame.height/2
        aDelegate?.contentCellDidClickVcvClickPhoto(id: "", cc: self, pointX: pointX, pointY: pointY, view: scrollView, mode: PhotoTypes.P_SHOT_DETAIL)
        
        //test > hide photo
//        hideCell()
        
        //test > hide photo
        if(isAutohideEnabled) {
            hideCell()
        }
    }
}

extension PostPhotoShotContentCell: CustomImageViewDelegate {
    func customImageViewClickPhoto(){
        let pFrame = scrollView.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + scrollView.frame.width/2
        let pointY = pFrame.y + scrollView.frame.height/2
        aDelegate?.contentCellDidClickVcvClickPhoto(id: "", cc: self, pointX: pointX, pointY: pointY, view: scrollView, mode: PhotoTypes.P_SHOT_DETAIL)
        
        //test > hide photo
        if(isAutohideEnabled) {
            hideCell()
        }
    }
    
    func customImageViewDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
}

extension PostPhotoShotContentCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("postphoto scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
        
        //test
        initial_x = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        print("postphoto scrollview scroll: \(x), \(y)")
//        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
        
        //test
        let x_diff = x - initial_x
        print("postphoto scrollview scroll: \(x_diff)")
        if(vDataList.count > 1) {
            if(current_p_s == 0) {
                if(x_diff < 0) {
                    aDelegate?.contentCellIsScrollCarousel(isScroll: false)
                }
            }
            else if (current_p_s == vDataList.count - 1) {
                if(x_diff > 0) {
                    aDelegate?.contentCellIsScrollCarousel(isScroll: false)
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("postphoto scrollview end: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
        
        //test > for bubble when scrolled thru carousel
        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        print("Current item index: \(tempCurrentIndex)")
        
        bubbleBox.setIndicatorSelected(index: tempCurrentIndex)
        
        //test > for carousel page
        aDelegate?.contentCellCarouselIdx(cc: self, idx: tempCurrentIndex)
        
        //test
        current_p_s = tempCurrentIndex
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("postphoto scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("postphoto scrollview animation ended")

    }
}

class PostVideoContentCell: MediaContentCell {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let videoContainer = UIView()
    let playBtn = UIImageView()
    let soundOnBtn = UIImageView()
    var player: AVPlayer!
    
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    let bSpinner = SpinLoader()
    
    weak var aDelegate : ContentCellDelegate?
    
    //TODO:
    //1) setState t_s when asyncconfig
    var t_s_ = 0.0
    //2) indicate whether asset is loaded, then only playable
    
    //test
    var isAutohideEnabled = true
    var isSelectable = false //for post creator panel
    
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
        let vConBg = UIView()
//        vConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
        vConBg.backgroundColor = .ddmBlackDark
        self.addSubview(vConBg)
        vConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight) //150, 250
        vConBg.translatesAutoresizingMaskIntoConstraints = false
        vConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        vConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        vConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        vConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        vConBg.layer.cornerRadius = 10
//        vConBg.layer.opacity = 0.4 //0.2
        
        let videoContainerBg = UIView()
        self.addSubview(videoContainerBg)
        videoContainerBg.translatesAutoresizingMaskIntoConstraints = false
        videoContainerBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //150, 370
        videoContainerBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //250, 280
        videoContainerBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        videoContainerBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        videoContainerBg.clipsToBounds = true
        videoContainerBg.layer.cornerRadius = 10
        videoContainerBg.backgroundColor = .ddmDarkColor
        
//        let videoContainer = UIView()
        videoContainer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight) //150, 250
        self.addSubview(videoContainer)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //150, 370
        videoContainer.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //250, 280
        videoContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        videoContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 10
        videoContainer.backgroundColor = .black
//        videoContainer.backgroundColor = .ddmDarkColor
        videoContainer.isUserInteractionEnabled = true
        videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoClicked)))

        //test > play/pause btn
//        let playBtn = UIImageView()
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        self.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
        playBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
        playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
        
        //test > sound on/off
//        let soundOnBtn = UIImageView()
//                soundOnBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        soundOnBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
        soundOnBtn.tintColor = .white
        self.addSubview(soundOnBtn)
        soundOnBtn.translatesAutoresizingMaskIntoConstraints = false
        soundOnBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
        soundOnBtn.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 5).isActive = true
        soundOnBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
        soundOnBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        soundOnBtn.isUserInteractionEnabled = true
//                soundOnBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))

        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        self.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
//        errorText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        errorText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        errorText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        self.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
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
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
            bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.isHidden = true
    }
    
    //test > async fetch asset
    func asyncConfigure(data: String) {
        
        let id = "a"
        DataFetchManager.shared.fetchDummyDataTimeDelay(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //UI change
                    self.bSpinner.stopAnimating()
                    self.bSpinner.isHidden = true
                    
                    self.videoContainer.isHidden = false
                    self.soundOnBtn.isHidden = false
                    self.playBtn.isHidden = false
                    
                    self.errorText.text = "-"
                    self.errorText.isHidden = true
                    self.errorRefreshBtn.isHidden = true
                    
                    //populate video
                    var videoURL = ""
                    videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
                    let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
                    
                    if(self.player != nil && self.player.currentItem != nil) {
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    }
                    
                    let item2 = AVPlayerItem(url: url)
                    self.player = AVPlayer(playerItem: item2)
                    let layer2 = AVPlayerLayer(player: self.player)
                    layer2.frame = self.videoContainer.bounds
                    layer2.videoGravity = .resizeAspectFill
                    self.videoContainer.layer.addSublayer(layer2)
                    
                    //add timestamp video while playing
                    self.addTimeObserverVideo()
                    
                    //test > for looping
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    
                    //seek to previously viewed state t_s
                    let seekTime = CMTime(seconds: self.t_s_, preferredTimescale: CMTimeScale(1000)) //1000
                    self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    //test > autoplay video after video loaded
                    if(self.vidPlayStatus == "play") {
                        self.resumeMedia()
//                        self.aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: true)
                        print("getinter ccvideo play: ")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    self.bSpinner.isHidden = true
                    
                    self.videoContainer.isHidden = true
                    self.soundOnBtn.isHidden = true
                    self.playBtn.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Error occurs. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    //test > async config
    func configure(data: String) {
        bSpinner.startAnimating()
        bSpinner.isHidden = false
        
        //error handling e.g. refetch button
        self.errorText.text = "-"
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        self.videoContainer.isHidden = true
        self.soundOnBtn.isHidden = true
        self.playBtn.isHidden = true
        
        asyncConfigure(data: "")
    }
    
    //test > resume to paused timestamp
    func setState(t: Double) {
        t_s_ = t
    }
    
    func setAutohide(isEnabled: Bool) {
        isAutohideEnabled = isEnabled
    }
    
    override func hideCell() {
//        videoContainer.isHidden = true
        
        //test 2 > try opacity
        self.layer.opacity = 0.1
    }
    
    override func dehideCell() {
//        videoContainer.isHidden = false
        
        //test 2 > try opacity
        self.layer.opacity = 1.0
    }
    
    func setSelectable(isEnabled: Bool) {
        isSelectable = isEnabled
    }
    
    override func selectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 2.0 //2
            self.layer.borderColor = UIColor.ddmGoldenYellowColor.cgColor //default
        }
    }

    override func unselectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 0.0 //2
            self.layer.borderColor = UIColor.clear.cgColor //default
        }
    }
    
    override func destroyCell() {
        print("postvideocc destroy cell")
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        
        t_s_ = 0.0
    }
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        refreshFetchData()
    }
    
    func refreshFetchData() {
        
        t_s_ = 0.0 //reset t_s
        
        self.bSpinner.startAnimating()
        self.bSpinner.isHidden = false
        
        //error handling e.g. refetch button
        self.errorText.text = "-"
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        self.videoContainer.isHidden = true
        self.soundOnBtn.isHidden = true
        self.playBtn.isHidden = true
        
        asyncConfigure(data: "")
    }
    
    @objc func onVideoClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click video:")
        let pFrame = videoContainer.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + videoContainer.frame.width/2
        let pointY = pFrame.y + videoContainer.frame.height/2
        aDelegate?.contentCellDidClickVcvClickVideo(id: "", cc: self, pointX: pointX, pointY: pointY, view: videoContainer, mode: VideoTypes.V_0)
        
        //test > hide photo
//        hideCell() //disabled for testing only
        
        //test > hide photo
        if(isAutohideEnabled) {
            hideCell()
        }
    }
    @objc func onVideoBtnClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click video btn:")
        if(vidPlayStatus == "play") {
            pauseMedia()
            
            //test > new method
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: false)
        } else {
            resumeMedia()
            
            //test > new method
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: true)
        }
    }
    
    //for video play
    var timeObserverTokenVideo: Any?
    func addTimeObserverVideo() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
        
        //test > new method
        if let tokenV = timeObserverTokenVideo {
            //check if token exists
        } else {
            timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
                [weak self] time in

                let currentT = time.seconds
                guard let s = self else {
                    return
                }
                print("postvideo time observe videoT:\(currentT)")
//                s.aDelegate?.hListVideoStopTime(vc: s, ts: currentT)
                s.aDelegate?.contentCellVideoStopTime(cc: s, ts: currentT)
            }
        }
    }
    func removeTimeObserverVideo() {
        //remove video observer
        if let tokenV = timeObserverTokenVideo {
            player?.removeTimeObserver(tokenV)
            timeObserverTokenVideo = nil
        }
        
        //test > for looping
        if(player != nil && player.currentItem != nil) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        playMedia()
    }
    
    var vidPlayStatus = ""
    override func playMedia() {
        player?.seek(to: .zero)
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    override func stopMedia() {
        player?.seek(to: .zero)
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    override func pauseMedia() {
        player?.pause()
        reactOnPlayStatus(status: "pause")
    }
    
    override func resumeMedia() {
        player?.play()
        reactOnPlayStatus(status: "play")
    }
    func reactOnPlayStatus(status: String) {
        vidPlayStatus = status
        if(status == "play") {
            playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        } else {
            playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        }
    }

}

class PostVideoLoopContentCell: MediaContentCell {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var descHeight: CGFloat = 0
    var descTxt = ""
    
    let videoContainer = UIView()
    let playBtn = UIImageView()
    let soundOnBtn = UIImageView()
    var player: AVPlayer!
    let a2UserPhoto = SDAnimatedImageView()
    let aaText = UILabel()
    
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    let bSpinner = SpinLoader()
    
    weak var aDelegate : ContentCellDelegate?
    
    //TODO:
    //1) setState t_s when asyncconfig
    var t_s_ = 0.0
    //2) indicate whether asset is loaded, then only playable
    
    //test
    var isAutohideEnabled = true
    var isSelectable = false //for post creator panel
    
    let vConBg = UIView()
    
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
    
    //description label height
    func setDescHeight(lHeight: CGFloat, txt: String) {
        descHeight = lHeight
        descTxt = txt
    }
    
    func redrawUI() {
//        let vConBg = UIView()
        vConBg.backgroundColor = .ddmBlackDark
        self.addSubview(vConBg)
        vConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight) //150, 250
        vConBg.translatesAutoresizingMaskIntoConstraints = false
        vConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        vConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        vConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        vConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        vConBg.layer.cornerRadius = 10
//        vConBg.layer.opacity = 0.4 //0.2
        
        let videoContainerBg = UIView()
        self.addSubview(videoContainerBg)
        videoContainerBg.translatesAutoresizingMaskIntoConstraints = false
        videoContainerBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //150, 370
        videoContainerBg.heightAnchor.constraint(equalToConstant: viewHeight - descHeight).isActive = true //250, 280
        videoContainerBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        videoContainerBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        videoContainerBg.clipsToBounds = true
        videoContainerBg.layer.cornerRadius = 10
        videoContainerBg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        videoContainerBg.backgroundColor = .ddmDarkColor
        
//        let videoContainer = UIView()
        videoContainer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight - descHeight) //150, 250
        self.addSubview(videoContainer)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //150, 370
        videoContainer.heightAnchor.constraint(equalToConstant: viewHeight - descHeight).isActive = true //250, 280
        videoContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        videoContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 10
        videoContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        videoContainer.backgroundColor = .black
        videoContainer.backgroundColor = .ddmDarkColor
        videoContainer.isUserInteractionEnabled = true
        videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoClicked)))

        //test > play/pause btn
//        let playBtn = UIImageView()
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        self.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
        playBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
        playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
        
        //test > sound on/off
//        let soundOnBtn = UIImageView()
//                soundOnBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        soundOnBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
        soundOnBtn.tintColor = .white
        self.addSubview(soundOnBtn)
        soundOnBtn.translatesAutoresizingMaskIntoConstraints = false
        soundOnBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
        soundOnBtn.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 5).isActive = true
        soundOnBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
        soundOnBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        soundOnBtn.isUserInteractionEnabled = true
//                soundOnBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        self.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor, constant: -20).isActive = true
//        errorText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        errorText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        errorText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        self.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
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
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
            bSpinner.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.isHidden = true
        
        //test > shot description
        let vConBottom = UIView()
//        pConBottom.frame = CGRect(x: 0, y: 0, width: 370, height: 40)
        self.addSubview(vConBottom)
        vConBottom.translatesAutoresizingMaskIntoConstraints = false
        vConBottom.leadingAnchor.constraint(equalTo: vConBg.leadingAnchor, constant: 0).isActive = true
        vConBottom.heightAnchor.constraint(equalToConstant: descHeight).isActive = true
        vConBottom.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        vConBottom.bottomAnchor.constraint(equalTo: vConBg.bottomAnchor, constant: 0).isActive = true //0
        vConBottom.isUserInteractionEnabled = true
        vConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
        
        let moreBtn = UIImageView()
        moreBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
        moreBtn.tintColor = .white
        vConBottom.addSubview(moreBtn)
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
        moreBtn.trailingAnchor.constraint(equalTo: vConBottom.trailingAnchor, constant: -5).isActive = true
        moreBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
        moreBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        //test 2 > just user photo at desc
        let e2UserCover = UIView()
        e2UserCover.backgroundColor = .clear
        vConBottom.addSubview(e2UserCover)
        e2UserCover.translatesAutoresizingMaskIntoConstraints = false
        e2UserCover.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
        e2UserCover.leadingAnchor.constraint(equalTo: vConBottom.leadingAnchor, constant: 5).isActive = true
        e2UserCover.heightAnchor.constraint(equalToConstant: 24).isActive = true //20
        e2UserCover.widthAnchor.constraint(equalToConstant: 24).isActive = true //20
        e2UserCover.layer.cornerRadius = 12
        e2UserCover.layer.opacity = 1.0 //default 0.3

//        let a2UserPhoto = SDAnimatedImageView()
        vConBottom.addSubview(a2UserPhoto)
        a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
        a2UserPhoto.widthAnchor.constraint(equalToConstant: 24).isActive = true //20
        a2UserPhoto.heightAnchor.constraint(equalToConstant: 24).isActive = true
        a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
        a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
        a2UserPhoto.contentMode = .scaleAspectFill
        a2UserPhoto.layer.masksToBounds = true
        a2UserPhoto.layer.cornerRadius = 12
        a2UserPhoto.backgroundColor = .ddmDarkColor
        
//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.font = .systemFont(ofSize: 13)
        aaText.font = .boldSystemFont(ofSize: 12)
        aaText.numberOfLines = 1
        vConBottom.addSubview(aaText)
        aaText.text = "-"
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
//        aaText.leadingAnchor.constraint(equalTo: vConBottom.leadingAnchor, constant: 10).isActive = true //5
        aaText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 7).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
    }
    
    func changeBaseColorInQuoteMode() {
        //test
//        vConBg.backgroundColor = .ddmDarkBlack
        vConBg.backgroundColor = .ddmDarkColor
        a2UserPhoto.backgroundColor = .ddmBlackDark
    }
    
    //test > async fetch asset
    func asyncConfigure(data: String) {
        //test 2 > new method to fetch video data
        let id = "video1"
        DataFetchManager.shared.fetchVideoData2(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
//                    print("222 pdp api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }
                    let uData = VideoData()
                    uData.setData(rData: l)
                    let l_ = uData.dataCode
                    
                    //UI change
                    self.bSpinner.stopAnimating()
                    self.bSpinner.isHidden = true
                    
                    self.videoContainer.isHidden = false
                    self.soundOnBtn.isHidden = false
                    self.playBtn.isHidden = false
                    
                    self.errorText.text = "-"
                    self.errorText.isHidden = true
                    self.errorRefreshBtn.isHidden = true
                    
                    //populate video
                    var videoURL = ""
                    if(l_ == "a") {
                        videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
                        
                        //test > populate description text and label
                        let t = uData.dataTextString
                        self.aaText.text = t

                        let image2Url = URL(string: "")
                        self.a2UserPhoto.sd_setImage(with: image2Url)
                    }
                    
                    let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
                    
                    if(self.player != nil && self.player.currentItem != nil) {
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    }
                    
                    let item2 = AVPlayerItem(url: url)
                    self.player = AVPlayer(playerItem: item2)
                    let layer2 = AVPlayerLayer(player: self.player)
                    layer2.frame = self.videoContainer.bounds
                    layer2.videoGravity = .resizeAspectFill
                    self.videoContainer.layer.addSublayer(layer2)
                    
                    //add timestamp video while playing
                    self.addTimeObserverVideo()
                    
                    //test > for looping
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    
                    //seek to previously viewed state t_s
                    let seekTime = CMTime(seconds: self.t_s_, preferredTimescale: CMTimeScale(1000)) //1000
                    self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    //test > autoplay video after video loaded
                    if(self.vidPlayStatus == "play") {
                        self.resumeMedia()
                        print("getinter ccvideoloop play: ")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {

                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    self.bSpinner.isHidden = true
                    
                    self.videoContainer.isHidden = true
                    self.soundOnBtn.isHidden = true
                    self.playBtn.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Error occurs. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    //test > async config
    func configure(data: String) {
        bSpinner.startAnimating()
        bSpinner.isHidden = false
        
        //error handling e.g. refetch button
        self.errorText.text = "-"
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        self.videoContainer.isHidden = true
        self.soundOnBtn.isHidden = true
        self.playBtn.isHidden = true
        
        asyncConfigure(data: "")
    }
    
    //test > resume to paused timestamp
    func setState(t: Double) {
        t_s_ = t
    }
//    func setState(t: Double) {
//        let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//        player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//    }
    
    func setAutohide(isEnabled: Bool) {
        isAutohideEnabled = isEnabled
    }
    
    override func hideCell() {
//        videoContainer.isHidden = true
        
        //test 2 > try opacity
        self.layer.opacity = 0.1
    }
    
    override func dehideCell() {
//        videoContainer.isHidden = false
        
        //test 2 > try opacity
        self.layer.opacity = 1.0
    }
    
    func setSelectable(isEnabled: Bool) {
        isSelectable = isEnabled
    }
    
    override func selectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 2.0 //2
            self.layer.borderColor = UIColor.ddmGoldenYellowColor.cgColor //default
        }
    }

    override func unselectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 0.0 //2
            self.layer.borderColor = UIColor.clear.cgColor //default
        }
    }
    
    override func destroyCell() {
        print("postvideoloopcc destroy cell")
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        
        t_s_ = 0.0 //reset t_s
    }
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        refreshFetchData()
    }
    
    func refreshFetchData() {
        
        t_s_ = 0.0 //reset t_s
        
        self.bSpinner.startAnimating()
        self.bSpinner.isHidden = false
        
        //error handling e.g. refetch button
        self.errorText.text = "-"
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        self.videoContainer.isHidden = true
        self.soundOnBtn.isHidden = true
        self.playBtn.isHidden = true
        
        asyncConfigure(data: "")
    }
    
    @objc func onVideoLClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click video loop:")
        let pFrame = videoContainer.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + videoContainer.frame.width/2
        let pointY = pFrame.y + videoContainer.frame.height/2
        aDelegate?.contentCellDidClickVcvClickVideo(id: "", cc: self, pointX: pointX, pointY: pointY, view: videoContainer, mode: VideoTypes.V_LOOP)
        
        //test > hide photo
//        hideCell() //disabled for testing only
        
        //test > hide photo
        if(isAutohideEnabled) {
            hideCell()
        }
    }
    @objc func onVideoClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click video:")
        let pFrame = videoContainer.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + videoContainer.frame.width/2
        let pointY = pFrame.y + videoContainer.frame.height/2
        aDelegate?.contentCellDidClickVcvClickVideo(id: "", cc: self, pointX: pointX, pointY: pointY, view: videoContainer, mode: VideoTypes.V_LOOP)
        
        //test > hide photo
//        hideCell() //disabled for testing only
        
        //test > hide photo
        if(isAutohideEnabled) {
            hideCell()
        }
    }
    @objc func onVideoBtnClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click video btn:")
        if(vidPlayStatus == "play") {
            pauseMedia()
            
            //test > new method
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: false)
        } else {
            resumeMedia()
            
            //test > new method
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: true)
        }
    }
    
    //for video play
    var timeObserverTokenVideo: Any?
    func addTimeObserverVideo() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
        
        //test > new method
        if let tokenV = timeObserverTokenVideo {
            //check if token exists
        } else {
            timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
                [weak self] time in

                let currentT = time.seconds
                guard let s = self else {
                    return
                }
                print("postvideo time observe videoT:\(currentT)")
//                s.aDelegate?.hListVideoStopTime(vc: s, ts: currentT)
                s.aDelegate?.contentCellVideoStopTime(cc: s, ts: currentT)
            }
        }
    }
    func removeTimeObserverVideo() {
        //remove video observer
        if let tokenV = timeObserverTokenVideo {
            player?.removeTimeObserver(tokenV)
            timeObserverTokenVideo = nil
        }
        
        //test > for looping
        if(player != nil && player.currentItem != nil) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        playMedia()
    }
    
    var vidPlayStatus = ""
    override func playMedia() {
        player?.seek(to: .zero)
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    override func stopMedia() {
        player?.seek(to: .zero)
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    override func pauseMedia() {
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    override func resumeMedia() {
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    func reactOnPlayStatus(status: String) {
        vidPlayStatus = status
        if(status == "play") {
            playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        } else {
            playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

class ShotPhotoContentCell: ContentCell {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let scrollView = UIScrollView()
    let bubbleBox = PageBubbleIndicator()
    var bubbleHeight: CGFloat = 0
    
    weak var aDelegate : ContentCellDelegate?
    
    //test
    var current_p_s = 0
    var initial_x = 0.0 //test for scrollview x-scroll direction
    
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
    
    //bubble label height
    func setBubbleHeight(lHeight: CGFloat) {
        bubbleHeight = lHeight
    }
    
    func redrawUI() {
        
        let pConBg = UIView()
//        pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight - bubbleHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight - bubbleHeight).isActive = true  //280
        pConBg.layer.cornerRadius = 10
//        pConBg.layer.opacity = 0.4 //0.2
        
        //carousel of images
//        let scrollView = UIScrollView()
//        aHLightRect1.addSubview(scrollView)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        scrollView.heightAnchor.constraint(equalToConstant: viewHeight - bubbleHeight).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true //false
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10 //5

        bubbleBox.backgroundColor = .clear
//        aHLightRect1.addSubview(bubbleBox)
        self.addSubview(bubbleBox)
        bubbleBox.translatesAutoresizingMaskIntoConstraints = false
        bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
        bubbleBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true //test
        bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
        bubbleBox.isHidden = true
    }
    
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
    func configure(data: [String]) {
//    func configure(data: String) {
//        if(data == "a") {
//            vDataList.append("p")
//            vDataList.append("p")
//            vDataList.append("p")
        
            for p in data {
                vDataList.append(p)
            }

            for p_ in vDataList {
                
//                let gifUrl = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
//                let gifUrl = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
//                let gifUrl = "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media"
                
                let gifImage1 = CustomDoubleTapImageView()
                gifImage1.setupViews()
//                gifImage1.setImage(url: gifUrl)
                gifImage1.setImage(url: p_)
                scrollView.addSubview(gifImage1)
                gifImage1.translatesAutoresizingMaskIntoConstraints = false
                gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
                gifImage1.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //280
                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    gifImage1.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                }
//                gifImage1.isUserInteractionEnabled = true
//                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                aHLightViewArray.append(gifImage1)
                gifImage1.aDelegate = self
            }
            
            let dataCount = vDataList.count
            if(dataCount > 1) {
                bubbleBox.setConfiguration(number: dataCount, color: .white) //yellow
                bubbleBox.isHidden = false
            }
            
            let totalWidth = CGFloat(dataCount) * viewWidth
            scrollView.contentSize = CGSize(width: totalWidth, height: viewHeight - bubbleHeight) //800, 280
//        }
    }
    
    //test > revert to last viewed photo in carousel
    func setState(p: Int) {
        bubbleBox.setIndicatorSelected(index: p)
        
        let xOffset = CGFloat(p) * viewWidth
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        
        //test
        current_p_s = p
    }
    
    override func hideCell() {
//        scrollView.isHidden = true
        
        //test 2 > try opacity
        self.layer.opacity = 0.1
    }
    
    override func dehideCell() {
//        scrollView.isHidden = false
        
        //test 2 > try opacity
        self.layer.opacity = 1.0
    }
    
//    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
//        print("postphoto click photo:")
//        let pFrame = scrollView.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
//        aDelegate?.contentCellDidClickVcvClickPhoto(cc: self, pointX: pointX, pointY: pointY, view: scrollView, mode: PhotoTypes.P_0)
//        
//        //test > hide photo
//        hideCell()
//    }
}

extension ShotPhotoContentCell: CustomImageViewDelegate {
    func customImageViewClickPhoto(){
        let pFrame = scrollView.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation method
        let pointX = pFrame.x + scrollView.frame.width/2
        let pointY = pFrame.y + scrollView.frame.height/2
        aDelegate?.contentCellDidClickVcvClickPhoto(id: "", cc: self, pointX: pointX, pointY: pointY, view: scrollView, mode: PhotoTypes.P_0)
        
        //test > hide photo
        hideCell()
    }
    
    func customImageViewDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        aDelegate?.contentCellDidDoubleClickPhoto(pointX: pointX, pointY: pointY)
    }
}

extension ShotPhotoContentCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("postphoto scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
        
        //test
        initial_x = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
//        print("postphoto scrollview scroll: \(x), \(y)")
//        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
        
        //test
        let x_diff = x - initial_x
        print("postphoto scrollview scroll: \(x_diff)")
        if(vDataList.count > 1) {
            if(current_p_s == 0) {
                if(x_diff < 0) {
                    aDelegate?.contentCellIsScrollCarousel(isScroll: false)
                }
            }
            else if (current_p_s == vDataList.count - 1) {
                if(x_diff > 0) {
                    aDelegate?.contentCellIsScrollCarousel(isScroll: false)
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("postphoto scrollview end: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
        
        //test > for bubble when scrolled thru carousel
        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        print("Current item index: \(tempCurrentIndex)")
        
        bubbleBox.setIndicatorSelected(index: tempCurrentIndex)
        
        //test > for carousel page
        aDelegate?.contentCellCarouselIdx(cc: self, idx: tempCurrentIndex)
        
        //test
        current_p_s = tempCurrentIndex
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("postphoto scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("postphoto scrollview animation ended")

    }
}

class ShotSoundContentCell: MediaContentCell {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aaBox = UIView()
    let mText = UILabel()
    let dMiniCon = UIView()
    let mPlayBtn = UIImageView()
    var player: AVPlayer!
    
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    let bSpinner = SpinLoader()
    
    weak var aDelegate : ContentCellDelegate?
    
    //TODO:
    //1) setState t_s when asyncconfig
    var t_s_ = 0.0
    //2) indicate whether asset is loaded, then only playable
    
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
        //test > try sound section
//        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
//        aaBox.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aBox)
        aaBox.frame = CGRect(x: 0, y: 0, width: 5, height: 5) //150, 250
        self.addSubview(aaBox)
        aaBox.clipsToBounds = true
        aaBox.translatesAutoresizingMaskIntoConstraints = false
        aaBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        aaBox.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //default: 50
        aaBox.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aaBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true //20
        aaBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true //test
        aaBox.isUserInteractionEnabled = true
        aaBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        
        let aBox = UIView()
        aBox.backgroundColor = .ddmBlackDark
//        aBox.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aBox)
        aaBox.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: aaBox.leadingAnchor, constant: 0).isActive = true
        aBox.topAnchor.constraint(equalTo: aaBox.topAnchor, constant: 0).isActive = true
        aBox.trailingAnchor.constraint(equalTo: aaBox.trailingAnchor, constant: 0).isActive = true //20
        aBox.bottomAnchor.constraint(equalTo: aaBox.bottomAnchor, constant: 0).isActive = true //test
        aBox.layer.cornerRadius = 5
//        aBox.layer.opacity = 0.2 //0.3
        
        let mBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
//        mBtn.tintColor = .black
        mBtn.tintColor = .white
//        contentView.addSubview(mBtn)
        aaBox.addSubview(mBtn)
        mBtn.translatesAutoresizingMaskIntoConstraints = false
        mBtn.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 5).isActive = true
        mBtn.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        mBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        mBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
//        let mText = UILabel()
        mText.textAlignment = .left
        mText.textColor = .white
        mText.font = .boldSystemFont(ofSize: 12) //13
//        contentView.addSubview(mText)
        aaBox.addSubview(mText)
        mText.translatesAutoresizingMaskIntoConstraints = false
        mText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
        mText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
//        mText.text = "明知故犯 - HubertWu"
        mText.text = "-"
        mText.isUserInteractionEnabled = true
//        mText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        mText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        mText.isHidden = true
        
//        let dMiniCon = UIView()
        self.addSubview(dMiniCon)
//        aaBox.addSubview(dMiniCon)
        dMiniCon.translatesAutoresizingMaskIntoConstraints = false
        dMiniCon.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        dMiniCon.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -5).isActive = true //0
        dMiniCon.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        dMiniCon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dMiniCon.isUserInteractionEnabled = true
        dMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
        dMiniCon.isHidden = true
        
        mPlayBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                let mPlayBtn = UIImageView(image: UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate))
        mPlayBtn.tintColor = .white
        dMiniCon.addSubview(mPlayBtn)
        mPlayBtn.translatesAutoresizingMaskIntoConstraints = false
        mPlayBtn.centerYAnchor.constraint(equalTo: dMiniCon.centerYAnchor).isActive = true
        mPlayBtn.centerXAnchor.constraint(equalTo: dMiniCon.centerXAnchor).isActive = true //0
//        mPlayBtn.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -5).isActive = true //0
        mPlayBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
        mPlayBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        mPlayBtn.isUserInteractionEnabled = true
//        mPlayBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 12)
//        self.addSubview(errorText)
        aaBox.addSubview(errorText)
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
        errorText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
        errorText.text = ""
//        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
//        aaBox.addSubview(errorRefreshBtn)
        self.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        errorRefreshBtn.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        errorRefreshBtn.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -5).isActive = true //0
//        errorRefreshBtn.layer.cornerRadius = 15
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
        bMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        bSpinner.setConfiguration(size: 14, lineWidth: 2, gap: 6, color: .white)//white, 20
        aaBox.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true //0
        bSpinner.heightAnchor.constraint(equalToConstant: 14).isActive = true //20
        bSpinner.widthAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    func asyncConfigure(data: String) {
        let id_ = data //s4
//        DataFetchManager.shared.fetchSoundData(id: id) { [weak self]result in
        DataFetchManager.shared.fetchSoundData2(id: id_) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id_), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    var videoURL = ""
//                    if(!l.isEmpty) {
//                        let l_0 = l[0]
                        let pData = SoundData()
//                        pData.setData(rData: l_0)
                        pData.setData(rData: l)
                        let l_ = pData.dataCode
                        if(l_ == "a") {
                            self.mText.text  = pData.dataTextString
                            self.mText.isHidden = false
                            self.dMiniCon.isHidden = false
                            
                            self.errorText.text = "-"
                            self.errorText.isHidden = true
                            self.errorRefreshBtn.isHidden = true
                            
                            videoURL = ""
//                            videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
                        }
//                    }
                    
//                    var videoURL = ""
//                    videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
                    let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
                    
                    if(self.player != nil && self.player.currentItem != nil) {
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    }
                    
                    let asset2 = AVAsset(url: audioUrl)
                    let item2 = AVPlayerItem(asset: asset2)
                    self.player = AVPlayer(playerItem: item2)
                    let layer2 = AVPlayerLayer(player: self.player)
                    layer2.frame = self.aaBox.bounds
                    self.aaBox.layer.addSublayer(layer2)
                    
                    //add timestamp video while playing
                    self.addTimeObserverVideo()
                    
                    //test > for looping
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    
                    //seek to previously viewed state t_s
                    let seekTime = CMTime(seconds: self.t_s_, preferredTimescale: CMTimeScale(1000)) //1000
                    self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    //test > autoplay video after video loaded
                    if(self.vidPlayStatus == "play") {
                        self.resumeMedia()
                        print("getinter ccsoundshot play: ")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.mText.text = "-"
                    self.mText.isHidden = true
                    self.dMiniCon.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Error occurs. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    //test > set id for init
    var id = ""
    func setId(id: String) {
        self.id = id
    }
    
    func configure(data: String) {
        
        setId(id: data)
        
        //test 2 > try async fetch sound data
        bSpinner.startAnimating()
        
        //error handling e.g. refetch button
        self.errorText.text = "-"
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        self.mText.text = "-"
        self.mText.isHidden = false
        self.dMiniCon.isHidden = true
        
        asyncConfigure(data: id) //""
    }
    
    @objc func onSoundClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click sound btn:")
        aDelegate?.contentCellDidClickSound(id: id)
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click sound refresh btn:")
        refreshFetchData()
    }
    
    @objc func onVideoBtnClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click video btn:")
        if(vidPlayStatus == "play") {
            pauseMedia()
            
            //test > new method
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: false)
        } else {
            resumeMedia()
            
            //test > new method
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: true)
        }
    }
    
    func refreshFetchData() {
        
        t_s_ = 0.0 //reset t_s
        
        bSpinner.startAnimating()
        
        //error handling e.g. refetch button
        self.errorText.text = "-"
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        self.mText.text = "-"
        self.mText.isHidden = false
        self.dMiniCon.isHidden = true
        
        asyncConfigure(data: id) //""
    }
    //test > resume to paused timestamp
    func setState(t: Double) {
        t_s_ = t
    }
    //test > resume to paused timestamp
//    func setState(t: Double) {
//        let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//        player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//    }
    
    //for video play
    var timeObserverTokenVideo: Any?
    func addTimeObserverVideo() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
        
        //test > new method
        if let tokenV = timeObserverTokenVideo {
            //check if token exists
        } else {
            timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
                [weak self] time in

                let currentT = time.seconds
                guard let s = self else {
                    return
                }
                print("postvideo time observe videoT:\(currentT)")
                s.aDelegate?.contentCellVideoStopTime(cc: s, ts: currentT)
            }
        }
    }
    func removeTimeObserverVideo() {
        //remove video observer
        if let tokenV = timeObserverTokenVideo {
            player?.removeTimeObserver(tokenV)
            timeObserverTokenVideo = nil
        }
        
        //test > for looping
        if(player != nil && player.currentItem != nil) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        playMedia()
    }
    
    override func destroyCell() {
        print("shotsoundcc destroy cell")
        
        //test > clear id
        setId(id: "")
        
        mText.text = "-"
        
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        
        t_s_ = 0.0 //reset t_s
    }
    
    var vidPlayStatus = ""
    override func playMedia() {
        player?.seek(to: .zero)
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    override func stopMedia() {
        player?.seek(to: .zero)
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    override func pauseMedia() {
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    override func resumeMedia() {
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    func reactOnPlayStatus(status: String) {
        vidPlayStatus = status
        if(status == "play") {
            mPlayBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        } else {
            mPlayBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

//test > try out "quote" only
class PostQuoteContentCell: MediaContentCell {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aGridNameText = UILabel()
    let aText = UILabel()
    let aUserPhoto = SDAnimatedImageView()
    let vBtn = UIImageView()
    
    //test > dynamic method for various cells format
    let aTest = UIView()
    var aTestArray = [UIView]()
    
    //test > for video container intersection as user scrolls to play/pause
    var mediaArray = [MediaContentCell]()
    //test > new method for storing hiding asset
    var hiddenAssetIdx = -1
    var playingMediaAssetIdx = -1
    
    weak var aDelegate : ContentCellDelegate?
    
    //test
    let spinnerCover = UIView()
    let bSpinner = SpinLoader()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    var isSelectable = false //for post creator panel
    
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
        let photoSize = 28.0
        let photoLhsMargin = 20.0 //20
        let usernameLhsMargin = 5.0
//        let indentSize = photoSize + photoLhsMargin + usernameLhsMargin

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onQuoteClicked)))
        //test > bg color
        self.backgroundColor = .ddmBlackDark
        //test > border for selectable
//        self.layer.borderWidth = 2.0 //2
//        self.layer.borderColor = UIColor.ddmGoldenYellowColor.cgColor //default
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
        self.addSubview(eUserCover)
//        aResult.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true //20
        eUserCover.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: photoLhsMargin).isActive = true
        eUserCover.heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        eUserCover.layer.cornerRadius = 14
        eUserCover.layer.opacity = 1.0 //default 0.3
        
//        let aUserPhoto = SDAnimatedImageView()
//        contentView.addSubview(aUserPhoto)
        self.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: photoSize).isActive = true //24
        aUserPhoto.heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 14
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkColor
        aUserPhoto.isUserInteractionEnabled = true
        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))

//        let aGridNameText = UILabel()
        aGridNameText.textAlignment = .left
        aGridNameText.textColor = .white
        aGridNameText.font = .boldSystemFont(ofSize: 13)
//        contentView.addSubview(aGridNameText)
        self.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.centerYAnchor.constraint(equalTo: aUserPhoto.centerYAnchor, constant: 0).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: eUserCover.trailingAnchor, constant: usernameLhsMargin).isActive = true
        aGridNameText.text = "-"
        aGridNameText.isUserInteractionEnabled = true
        aGridNameText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
        vBtn.tintColor = .yellow
//        contentView.addSubview(vBtn)
        self.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aGridNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aGridNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        //
        
        self.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        aTest.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true //-10
        aTest.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 0).isActive = true
        //test > size of atest
//        aTest.backgroundColor = .blue
        aTest.clipsToBounds = true //to prevent subviews overflowing
        
        //test > spinner loader
//        spinnerCover.backgroundColor = .ddmDarkBlack
        spinnerCover.backgroundColor = .ddmBlackDark
        spinnerCover.layer.cornerRadius = 0
        self.addSubview(spinnerCover)
        spinnerCover.translatesAutoresizingMaskIntoConstraints = false
//        spinnerCover.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //20
        spinnerCover.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 20).isActive = true
        spinnerCover.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        spinnerCover.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        spinnerCover.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        spinnerCover.isHidden = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        spinnerCover.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: spinnerCover.centerYAnchor).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: spinnerCover.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        spinnerCover.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: spinnerCover.centerYAnchor, constant: 0).isActive = true
        errorText.centerXAnchor.constraint(equalTo: spinnerCover.centerXAnchor, constant: -20).isActive = true //-20
        errorText.text = ""
//        errorText.text = "Unable to load."
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkBlack //ddmDarkColor
        spinnerCover.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerYAnchor.constraint(equalTo: errorText.centerYAnchor, constant: 0).isActive = true
        errorRefreshBtn.leadingAnchor.constraint(equalTo: errorText.trailingAnchor).isActive = true
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
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    //*test
    var isAutohideEnabled = true
    func setAutohide(isEnabled: Bool) {
        isAutohideEnabled = isEnabled
    }
    
    override func hideCell() {
        for e in aTestArray {
            if let a = e as? ContentCell {
                a.hideCell()
            }
        }
    }
    //*
    
    override func dehideCell() {
        for e in aTestArray {
            if let a = e as? ContentCell {
                a.dehideCell()
            }
        }
        
        //test > UI for click
        self.layer.opacity = 1.0
    }
    
    func setSelectable(isEnabled: Bool) {
        isSelectable = isEnabled
    }
    
    override func selectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 2.0 //2
            self.layer.borderColor = UIColor.ddmGoldenYellowColor.cgColor //default
        }
    }

    override func unselectCell() {
        if(isSelectable) {
            self.layer.borderWidth = 0.0 //2
            self.layer.borderColor = UIColor.clear.cgColor //default
        }
    }
    
    override func destroyCell() {
        print("quote destroy cell")
        
        //test > clear id
        setId(id: "")
        setIds(uId: "", pId: "", sId: "")
        setContentDataType(data: "")
        
        for e in aTestArray {
            //test > destroy inner content cell before removed
            if let a = e as? ContentCell {
                a.destroyCell()
            }
            
            e.removeFromSuperview()
        }
        aTestArray.removeAll()
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error quote refresh clicked")
        //reload entire cell
        self.aDelegate?.contentCellResize(cc: self)
    }
    
    //test > fetch from contentData
    func configure(contentData: ContentData) {
        configure(contentData: contentData, isToForceRefreshData: false)
    }
    func configure(contentData: ContentData, isToForceRefreshData: Bool) {
        let d = contentData.contentDataCode
        if(d == "" || isToForceRefreshData) {
            setId(id: contentData.id)
            setContentDataType(data: contentData.contentDataType)
            
            spinnerCover.isHidden = false
            bSpinner.startAnimating()
            
            self.errorText.isHidden = true
            self.errorRefreshBtn.isHidden = true
            
            if(self.contentDataType == "post") {
                asyncConfigurePost(contentData: contentData)
            }
            else if (self.contentDataType == "comment") {
                asyncConfigureComment(contentData: contentData)
            }
        }
    }
    
    //*test > async fetch post/comment data
    func asyncConfigurePost(contentData: ContentData) {
        let id_ = contentData.id
//        let id_ = "p"
        DataFetchManager.shared.fetchPostData2(id: id_) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.spinnerCover.isHidden = true
                    self.bSpinner.stopAnimating()
                    
                    let pData = PostData()
                    pData.setData(rData: l)
                    let l_ = pData.dataCode
                        
                    self.configureUI(data: pData)
                    
                    //test > reload item
                    print("quote asyncconfigure post \(l_)")
                    if(l_ == "na" || l_ == "us") {
                        contentData.setContentDataCode(data: l_)
                        self.aDelegate?.contentCellResize(cc: self)
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    guard let self = self else {
                        return
                    }
                    
                    self.spinnerCover.isHidden = false
                    self.bSpinner.stopAnimating()
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    func asyncConfigureComment(contentData: ContentData) {
        let id_ = contentData.id
//        let id_ = "s"
        DataFetchManager.shared.fetchCommentData2(id: id_) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.spinnerCover.isHidden = true
                    self.bSpinner.stopAnimating()
                    
                    let pData = CommentData()
                    pData.setData(rData: l)
                    let l_ = pData.dataCode
                        
                    self.configureUI(data: pData)
                    
                    //test > reload item
                    print("quote asyncconfigure comment \(l_)")
                    if(l_ == "na" || l_ == "us") {
                        contentData.setContentDataCode(data: l_)
                        self.aDelegate?.contentCellResize(cc: self)
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    guard let self = self else {
                        return
                    }
                    
                    self.spinnerCover.isHidden = false
                    self.bSpinner.stopAnimating()
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    //real post/comment data by fetching
    func configureUI(data: BaseData) {
        guard let a = data as? BasePostData else {
            return
        }
        
        let d = a.dataCode
        
        self.spinnerCover.isHidden = true
        self.bSpinner.stopAnimating()
        
        if(d == "a") {
            let u = a.userId
            setIds(uId: u, pId: "", sId: "")
            asyncConfigureUser(data: u)
            
            let dataCL = a.contentDataArray
            
            var elementIdx = 0
            if(!aTestArray.isEmpty) {
                for cl in dataCL {
                    let l = cl.dataCode
                    let da = cl.dataArray
                    
                    if(elementIdx < aTestArray.count) {
                        let e = aTestArray[elementIdx]
                        if(l == "text") {
                            if let a = e as? UILabel {
                                a.text = cl.dataTextString
                            }
                        }
                        else if(l == "photo") {
                            if let a = e as? PostPhotoContentCell {
                                a.configure(data: da)
                                a.setState(p: 0) //do not revert state for simplicity
                            }
                        }
                        else if(l == "photo_s") {
                            if let a = e as? PostPhotoShotContentCell {
                                a.configure(data: "a") //"a"
                                a.setState(p: 0) //do not revert state for simplicity
                            }
                        }
                        else if(l == "video") {
                            if let a = e as? PostVideoContentCell {
                                a.configure(data: "a") //"a"
                                a.setState(t: 0.0) //do not revert state for simplicity
                            }
                        }
                        else if(l == "video_l") {
                            if let a = e as? PostVideoLoopContentCell {
                                a.configure(data: "a") //"a"
                                a.setState(t: 0.0) //do not revert state for simplicity
                            }
                        }
                        elementIdx += 1
                    }
                }
            }
        }
        else if(d == "na") {
            for e in aTestArray {
                //test > destroy inner content cell before removed
                if let a = e as? ContentCell {
                    a.destroyCell()
                }
                
                e.removeFromSuperview()
            }
            aTestArray.removeAll()
            
            //test > error handling
            let cellWidth = viewWidth
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let contentCell = PostNotFoundContentCell(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 120.0))
            aTest.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            if(aTestArray.isEmpty) {
                contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
            } else {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
            }
            contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
            contentCell.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
            contentCell.layer.cornerRadius = 10 //5
            aTestArray.append(contentCell)
            contentCell.redrawUI()
            
            if(!aTestArray.isEmpty) {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true //-10
            }
        }
        else if(d == "us") {
            for e in aTestArray {
                //test > destroy inner content cell before removed
                if let a = e as? ContentCell {
                    a.destroyCell()
                }
                
                e.removeFromSuperview()
            }
            aTestArray.removeAll()
            
            //test > error handling
            let cellWidth = viewWidth
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let contentCell = PostSuspendedContentCell(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 120.0))
            aTest.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            if(aTestArray.isEmpty) {
                contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
            } else {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
            }
            contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
            contentCell.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
            contentCell.layer.cornerRadius = 10 //5
            aTestArray.append(contentCell)
            contentCell.redrawUI()
            
            if(!aTestArray.isEmpty) {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true //-10
            }
        }
    }
    
    //test > set id for init
    var id = ""
    var userId = ""
    var placeId = ""
    var soundId = ""
    var contentDataType = ""
    func setId(id: String) {
        self.id = id
    }
    func setIds(uId: String, pId: String, sId: String) {
        self.userId = uId
        self.placeId = pId
        self.soundId = sId
    }
    func setContentDataType(data: String) {
        self.contentDataType = data
    }
    
    //setup views with predata that is stored within post, without fetching the real quote data yet
    func setupContentViews(qPredata: [String], text: String, contentData: ContentData) {
        
        let d = contentData.contentDataCode
        print("quote setupContentViews: \(d)")
        if(d == "a" || d == "") {
            var qDataArray = [String]()
            
            for d in qPredata {
                qDataArray.append(d)
            }
            //**
            
            for l in qDataArray {
                if(l == "text") {
                    let aaText = UILabel()
                    aaText.textAlignment = .left
                    aaText.textColor = .white //white
    //                aaText.textColor = .ddmDarkBlack
                    aaText.font = .systemFont(ofSize: 14)
                    aaText.numberOfLines = 0 //0
                    aTest.addSubview(aaText)
                    aaText.translatesAutoresizingMaskIntoConstraints = false
                    if(aTestArray.isEmpty) {
                        aaText.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true //20
                    } else {
                        let lastArrayE = aTestArray[aTestArray.count - 1]
                        aaText.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                    }
                    aaText.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true //20
                    aaText.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
    //                aaText.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
                    aaText.text = text
                    aTestArray.append(aaText)
                }
                else if(l == "photo") {
                    let cellWidth = viewWidth
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 4, height: 3)//landscape
    //                let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
    //                    let cWidth = availableWidth //test full width for portrait
                        let cHeight = cWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: round(cWidth), height: round(cWidth))
                    }
                    
                    //test 2 > reusable custom view
    //                let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: 370, height: 280))
                    let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
                    aTest.addSubview(contentCell)
                    contentCell.translatesAutoresizingMaskIntoConstraints = false
                    if(aTestArray.isEmpty) {
                        contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                    } else {
                        let lastArrayE = aTestArray[aTestArray.count - 1]
                        contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                    }
                    contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
    //                contentCell.widthAnchor.constraint(equalToConstant: 370).isActive = true  //370
    //                contentCell.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
                    contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
                    contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
                    contentCell.layer.cornerRadius = 10 //5
                    aTestArray.append(contentCell)
                    contentCell.redrawUI()
//                    var da = [String]() //temp solution
//                    da.append("https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
//                    da.append("https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                    contentCell.configure(data: da)
//                    contentCell.setState(p: 0) //do not revert state for simplicity
                    contentCell.aDelegate = self
                    contentCell.setAutohide(isEnabled: isAutohideEnabled)
                }
                else if(l == "photo_s") {
                    let cellWidth = viewWidth
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
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                    }
                    
                    //test 2 > reusable custom view
    //                let contentCell = PostPhotoShotContentCell(frame: CGRect(x: 0, y: 0, width: 370, height: 320))
                    let contentCell = PostPhotoShotContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
                    aTest.addSubview(contentCell)
                    contentCell.translatesAutoresizingMaskIntoConstraints = false
                    if(aTestArray.isEmpty) {
                        contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                    } else {
                        let lastArrayE = aTestArray[aTestArray.count - 1]
                        contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                    }
                    contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
    //                contentCell.widthAnchor.constraint(equalToConstant: 370).isActive = true  //370
    //                contentCell.heightAnchor.constraint(equalToConstant: 320).isActive = true  //320
                    contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
                    contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //320
                    contentCell.layer.cornerRadius = 10 //5
                    aTestArray.append(contentCell)
                    contentCell.setDescHeight(lHeight: descHeight, txt: text)
                    contentCell.redrawUI()
//                    contentCell.configure(data: "a") //"a"
//                    contentCell.setState(p: 0) //do not revert state for simplicity
                    contentCell.aDelegate = self
                    contentCell.setAutohide(isEnabled: isAutohideEnabled)
                    
                    //test > change color in quote mode
                    contentCell.changeBaseColorInQuoteMode()
                }
                else if(l == "video_l") {//loop videos
                    let cellWidth = viewWidth
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
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                    }
                    
                    //test 2 > reusable custom view
    //                let contentCell = PostVideoLoopContentCell(frame: CGRect(x: 0, y: 0, width: 220, height: 390))
                    let contentCell = PostVideoLoopContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
                    aTest.addSubview(contentCell)
                    contentCell.translatesAutoresizingMaskIntoConstraints = false
                    if(aTestArray.isEmpty) {
                        contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                    } else {
                        let lastArrayE = aTestArray[aTestArray.count - 1]
                        contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                    }
                    contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
    //                contentCell.widthAnchor.constraint(equalToConstant: 220).isActive = true  //220
    //                contentCell.heightAnchor.constraint(equalToConstant: 390).isActive = true  //390
                    contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //220
                    contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //390
                    contentCell.layer.cornerRadius = 10 //5
                    aTestArray.append(contentCell)
                    contentCell.setDescHeight(lHeight: descHeight, txt: text)
                    contentCell.redrawUI()
//                    contentCell.configure(data: "a")
//                    contentCell.setState(t: 0.0)
                    contentCell.aDelegate = self
                    contentCell.setAutohide(isEnabled: isAutohideEnabled)
                
                    mediaArray.append(contentCell)
                    
                    //test > change color in quote mode
                    contentCell.changeBaseColorInQuoteMode()
                }
                else if(l == "video") { //vi
                    let cellWidth = viewWidth
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: round(cWidth), height: round(cWidth))
                    }
                    
                    //test 2 > reusable custom view
    //                let contentCell = PostVideoContentCell(frame: CGRect(x: 0, y: 0, width: 220, height: 350))
                    let contentCell = PostVideoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
                    aTest.addSubview(contentCell)
                    contentCell.translatesAutoresizingMaskIntoConstraints = false
                    if(aTestArray.isEmpty) {
                        contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                    } else {
                        let lastArrayE = aTestArray[aTestArray.count - 1]
                        contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                    }
                    contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
    //                contentCell.widthAnchor.constraint(equalToConstant: 220).isActive = true  //220
    //                contentCell.heightAnchor.constraint(equalToConstant: 350).isActive = true  //350
                    contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //220
                    contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //350
                    contentCell.layer.cornerRadius = 10 //5
                    aTestArray.append(contentCell)
                    contentCell.redrawUI()
//                    contentCell.configure(data: "a")
//                    contentCell.setState(t: 0.0)
                    contentCell.aDelegate = self
                    contentCell.setAutohide(isEnabled: isAutohideEnabled)
                    
                    mediaArray.append(contentCell)
                }
                else if(l == "quote") {
                    let aaText = UILabel()
                    aaText.textAlignment = .left
                    aaText.textColor = .white
                    aaText.font = .systemFont(ofSize: 14)
                    aaText.numberOfLines = 0 //0
                    aTest.addSubview(aaText)
                    aaText.translatesAutoresizingMaskIntoConstraints = false
                    if(aTestArray.isEmpty) {
                        aaText.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true //20
                    } else {
                        let lastArrayE = aTestArray[aTestArray.count - 1]
                        aaText.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                    }
                    aaText.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
                    aaText.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
    //                aaText.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
                    aaText.text = "[Quote]"
                    aTestArray.append(aaText)
                }
            }
        }
        else if(d == "na") {
            //test > error handling
            let cellWidth = viewWidth
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let contentCell = PostNotFoundContentCell(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 120.0))
            aTest.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            if(aTestArray.isEmpty) {
                contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
            } else {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
            }
            contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
            contentCell.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
            contentCell.layer.cornerRadius = 10 //5
            aTestArray.append(contentCell)
            contentCell.redrawUI()
        }
        else if(d == "us") {
            let cellWidth = viewWidth
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let contentCell = PostSuspendedContentCell(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 120.0))
            aTest.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            if(aTestArray.isEmpty) {
                contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
            } else {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
            }
            contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
            contentCell.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
            contentCell.layer.cornerRadius = 10 //5
            aTestArray.append(contentCell)
            contentCell.redrawUI()
        }
        
        if(!aTestArray.isEmpty) {
            let lastArrayE = aTestArray[aTestArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true //-10
        }
    }
    
    @objc func onQuoteClicked(gesture: UITapGestureRecognizer) {
        print("quote post clicked")
//        aDelegate?.contentCellDidClickPost(id: id, dataType: contentDataType, cc: self, pointX: 0, pointY: 0)
        
        //test 2 > use click position as starting point
        let translation = gesture.location(in: self)
        let x = translation.x
        let y = translation.y
        let pointX = x
        let pointY = y
        aDelegate?.contentCellDidClickPost(id: id, dataType: contentDataType, cc: self, pointX: pointX, pointY: pointY)
        
        //test > UI for click p_shot_detail
        self.layer.opacity = 0.1
    }
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.contentCellDidClickUser(id: userId)
    }
    
    override func pauseMedia() {
        if(playingMediaAssetIdx > -1) {
            if(!aTestArray.isEmpty && playingMediaAssetIdx < aTestArray.count) {
                let asset = aTestArray[playingMediaAssetIdx]
                if let a = asset as? MediaContentCell {
                    a.pauseMedia()
                    playingMediaAssetIdx = -1
                }
            }
        }
    }
    
    override func resumeMedia() {
        if(!mediaArray.isEmpty) {
            let m = mediaArray[0] //for simplicity only the first video
            if let j = aTestArray.firstIndex(of: m) {
                playingMediaAssetIdx = j
                m.resumeMedia()
            }
        }
    }
    
    //*test > async fetch images/names/videos
    func asyncConfigureUser(data: String) {
        let id = data //u1
        DataFetchManager.shared.fetchUserData2(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    let uData = UserData()
                    uData.setData(rData: l)
                    let l_ = uData.dataCode
                    
                    if(l_ == "a") {
                        self.aGridNameText.text = uData.dataTextString
                        if(uData.isAccountVerified) {
                            self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
                        }
                        let imageUrl = URL(string: uData.coverPhotoString)
                        self.aUserPhoto.sd_setImage(with: imageUrl)
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.aGridNameText.text = "-"
                    self.vBtn.image = nil
                    
                    let imageUrl = URL(string: "")
                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                }
                break
            }
        }
    }
    //*
}

extension PostQuoteContentCell: ContentCellDelegate {
    func contentCellIsScrollCarousel(isScroll: Bool){
        aDelegate?.contentCellIsScrollCarousel(isScroll: isScroll)
    }
    
    func contentCellCarouselIdx(cc: UIView, idx: Int){

    }
    
    func contentCellVideoStopTime(cc: UIView, ts: Double){
        
    }
    
    func contentCellDidClickVcvClickPhoto(id: String, cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aTest.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.contentCellDidClickVcvClickPhoto(id: id, cc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        //test 2 > new method to store hide asset
//        if let j = aTestArray.firstIndex(of: cc) {
//            hiddenAssetIdx = j
//        }
    }
    func contentCellDidClickVcvClickVideo(id: String, cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aTest.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.contentCellDidClickVcvClickVideo(id: id, cc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        //test 2 > new method to store hide asset
//        if let j = aTestArray.firstIndex(of: cc) {
//            hiddenAssetIdx = j
//        }
    }
    func contentCellDidDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
    func contentCellDidClickSound(id: String){
        
    }
    func contentCellDidClickUser(id: String){
        
    }
    func contentCellDidClickPlace(id: String){
    }
    func contentCellDidClickPost(id: String, dataType: String, cc: UIView, pointX: CGFloat, pointY: CGFloat){

    }
    func contentCellDidClickVcvClickPlay(cc: UIView, isPlay: Bool){
        if let j = aTestArray.firstIndex(of: cc) {
            playingMediaAssetIdx = j
            
            aDelegate?.contentCellDidClickVcvClickPlay(cc: self, isPlay: isPlay)
        }
    }
    func contentCellResize(cc: UIView){
    }
}

//test > post not avail
class PostNotFoundContentCell: ContentCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmBlackDark
//        aHLightRectBG.layer.borderWidth = 2.0 //2
//        aHLightRectBG.layer.borderColor = UIColor.ddmDarkColor.cgColor //default
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .center
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
////        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
////        aHLightTitle.text = "Post Status"
//        aHLightTitle.text = "Post Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHSubDesc.font = .boldSystemFont(ofSize: 12)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHSubDesc.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
//        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-40
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "Post does not exist."
//                aHSubDesc.layer.opacity = 0.7
    }
}

class PostSuspendedContentCell: ContentCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmBlackDark
//        aHLightRectBG.layer.borderWidth = 2.0 //2
//        aHLightRectBG.layer.borderColor = UIColor.ddmDarkColor.cgColor //default
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .center
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
////        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
////        aHLightTitle.text = "Post Status"
//        aHLightTitle.text = "Post Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHSubDesc.font = .boldSystemFont(ofSize: 12)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHSubDesc.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
//        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-40
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "Post violated community rules."
//                aHSubDesc.layer.opacity = 0.7
    }
}

//test > shot not avail
class ShotNotFoundContentCell: ContentCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmBlackDark
//        aHLightRectBG.layer.borderWidth = 2.0 //2
//        aHLightRectBG.layer.borderColor = UIColor.ddmDarkColor.cgColor //default
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .center
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
////        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
////        aHLightTitle.text = "Post Status"
//        aHLightTitle.text = "Post Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHSubDesc.font = .boldSystemFont(ofSize: 12)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHSubDesc.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 20).isActive = true //10
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "Shot does not exist."
//                aHSubDesc.layer.opacity = 0.7
    }
}

class ShotSuspendedContentCell: ContentCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmBlackDark
//        aHLightRectBG.layer.borderWidth = 2.0 //2
//        aHLightRectBG.layer.borderColor = UIColor.ddmDarkColor.cgColor //default
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .center
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
////        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
////        aHLightTitle.text = "Post Status"
//        aHLightTitle.text = "Post Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHSubDesc.font = .boldSystemFont(ofSize: 12)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHSubDesc.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 20).isActive = true //10
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-40
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "Shot violated community rules."
//                aHSubDesc.layer.opacity = 0.7
    }
}
