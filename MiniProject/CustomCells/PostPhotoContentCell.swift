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
    func contentCellCarouselIdx(idx: Int)
}

class PostPhotoContentCell: UIView {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let scrollView = UIScrollView()
    let bubbleBox = PageBubbleIndicator()
    
    weak var aDelegate : ContentCellDelegate?
    
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
        
        //carousel of images
//        let scrollView = UIScrollView()
//        aHLightRect1.addSubview(scrollView)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
//        scrollView.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true //0
//        scrollView.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        scrollView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
//        scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
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
    func configure(data: String) {
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
            for _ in vDataList {
                
                let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
//              let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                
                let gifImage1 = SDAnimatedImageView()
                gifImage1.contentMode = .scaleAspectFill
                gifImage1.clipsToBounds = true
                gifImage1.sd_setImage(with: gifUrl)
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
                gifImage1.isUserInteractionEnabled = true
                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                aHLightViewArray.append(gifImage1)
            }
            
            let dataCount = vDataList.count
            if(dataCount > 1) {
                bubbleBox.setConfiguration(number: dataCount, color: .yellow)
                bubbleBox.isHidden = false
            }
            
            let totalWidth = CGFloat(dataCount) * viewWidth
            scrollView.contentSize = CGSize(width: totalWidth, height: viewHeight) //800, 280
        }
    }
    
    //test > revert to last viewed photo in carousel
    func setState(p: Int) {
        bubbleBox.setIndicatorSelected(index: p)
        
        let xOffset = CGFloat(p) * viewWidth
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
    }
    
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click photo:")
    }
}

extension PostPhotoContentCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("postphoto scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        print("postphoto scrollview scroll: \(x), \(y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
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
        aDelegate?.contentCellCarouselIdx(idx: tempCurrentIndex)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("postphoto scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("postphoto scrollview animation ended")

    }
}

class PostPhotoShotContentCell: UIView {
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var descHeight: CGFloat = 0
    var descTxt = ""
    
    let scrollView = UIScrollView()
    let bubbleBox = PageBubbleIndicator()
    let aaText = UILabel()
    let a2UserPhoto = SDAnimatedImageView()
    
    weak var aDelegate : ContentCellDelegate?
    
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
        
        let pConBg = UIView()
        pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: 370, height: 320)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        pConBg.layer.cornerRadius = 10
        pConBg.layer.opacity = 0.4 //0.2
        
        //carousel of images
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        scrollView.heightAnchor.constraint(equalToConstant: viewHeight - descHeight).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
//        scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
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
        
        let label = UIView()
        self.addSubview(label)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
        label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5).isActive = true
        label.layer.cornerRadius = 5
        
        let labelBg = UIView()
        label.addSubview(labelBg)
        labelBg.backgroundColor = .ddmDarkColor
        labelBg.translatesAutoresizingMaskIntoConstraints = false
        labelBg.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
        labelBg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0).isActive = true
        labelBg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
        labelBg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        labelBg.layer.opacity = 0.3 //0.5
        labelBg.layer.cornerRadius = 5
        
        let e2UserCover = UIView()
        e2UserCover.backgroundColor = .clear
        label.addSubview(e2UserCover)
        e2UserCover.translatesAutoresizingMaskIntoConstraints = false
        e2UserCover.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
        e2UserCover.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
        e2UserCover.heightAnchor.constraint(equalToConstant: 20).isActive = true //28
        e2UserCover.widthAnchor.constraint(equalToConstant: 20).isActive = true //28
        e2UserCover.layer.cornerRadius = 10
        e2UserCover.layer.opacity = 1.0 //default 0.3

//        let a2UserPhoto = SDAnimatedImageView()
        label.addSubview(a2UserPhoto)
        a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
        a2UserPhoto.widthAnchor.constraint(equalToConstant: 20).isActive = true //36
        a2UserPhoto.heightAnchor.constraint(equalToConstant: 20).isActive = true
        a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
        a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
        a2UserPhoto.contentMode = .scaleAspectFill
        a2UserPhoto.layer.masksToBounds = true
        a2UserPhoto.layer.cornerRadius = 10
        a2UserPhoto.backgroundColor = .ddmDarkColor
        
        let aGridNameText = UILabel()
        aGridNameText.textAlignment = .left
        aGridNameText.textColor = .white
        aGridNameText.font = .boldSystemFont(ofSize: 12)
        label.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
        aGridNameText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
        aGridNameText.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 5).isActive = true
        aGridNameText.text = "Shot"
        
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
        
//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
        aaText.font = .systemFont(ofSize: 13)
        aaText.numberOfLines = 1
        pConBottom.addSubview(aaText)
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
        aaText.leadingAnchor.constraint(equalTo: pConBottom.leadingAnchor, constant: 10).isActive = true //5
        aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
    }
    
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
    func configure(data: String) {
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
            for _ in vDataList {
                
                let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
//              let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                
                let gifImage1 = SDAnimatedImageView()
                gifImage1.contentMode = .scaleAspectFill
                gifImage1.clipsToBounds = true
                gifImage1.sd_setImage(with: gifUrl)
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
                gifImage1.isUserInteractionEnabled = true
                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                aHLightViewArray.append(gifImage1)
            }
            
            let dataCount = vDataList.count
            if(dataCount > 1) {
                bubbleBox.setConfiguration(number: dataCount, color: .yellow)
                bubbleBox.isHidden = false
            }
            
            let totalWidth = CGFloat(dataCount) * viewWidth
            scrollView.contentSize = CGSize(width: totalWidth, height: viewHeight - descHeight) //800, 280
            
            //test > populate description text and label
            aaText.text = descTxt
            let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            a2UserPhoto.sd_setImage(with: image2Url)
        }
    }
    
    //test > revert to last viewed photo in carousel
    func setState(p: Int) {
        bubbleBox.setIndicatorSelected(index: p)
        
        let xOffset = CGFloat(p) * viewWidth
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
    }
    
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click photo:")
    }
    
    @objc func onPhotoSClicked(gesture: UITapGestureRecognizer) {
        print("postphoto click photo shot:")
    }
}

extension PostPhotoShotContentCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("postphoto scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        print("postphoto scrollview scroll: \(x), \(y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: true)
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
        aDelegate?.contentCellCarouselIdx(idx: tempCurrentIndex)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("postphoto scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.contentCellIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("postphoto scrollview animation ended")

    }
}



//test > backup for HCommentListViewCell
//class HCommentListViewCell: UICollectionViewCell {
//    static let identifier = "HCommentListViewCell"
//    
//    let aGridNameText = UILabel()
//    let aText = UILabel()
//    let aUserPhoto = SDAnimatedImageView()
//    let vBtn = UIImageView()
//    let aUserNameText = UILabel()
//    
//    let bMiniBtn = UIImageView()
//    let dMiniBtn = UIImageView()
//    
//    //test > video player
//    var player: AVPlayer!
//    
//    //test > dynamic method for various cells format
//    let aTest = UIView()
//    var aTestArray = [UIView]()
//    let aTest2 = UIView()
//    var aTest2Array = [UIView]()
//    let aConnector = UIView()
//    
//    let bText = UILabel()
//    let cText = UILabel()
//    let dText = UILabel()
//    let eText = UILabel()
//    
//    //test > for video container intersection as user scrolls to play/pause
//    var vidConArray = [UIView]()
//    var playBtnArray = [UIImageView]()
//    var photoConArray = [UIView]()
//    var hideConArray = [UIView]()
//    var bubbleArray = [PageBubbleIndicator]()
//    
//    weak var aDelegate : HListCellDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.clipsToBounds = true
//
//        addSubViews()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func addSubViews() {
//        //test > result vertical panel layout
//        let aResult = UIView()
//        aResult.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aResult)
//        aResult.translatesAutoresizingMaskIntoConstraints = false
//        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
////        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.1 //0.3
////        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
////        aResult.addGestureRecognizer(atapGR)
//        
//        //test > add container for clicks event
//        let aCon = UIView()
//        contentView.addSubview(aCon)
////        aCon.backgroundColor = .red
//        aCon.translatesAutoresizingMaskIntoConstraints = false
//        aCon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        aCon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
////        aCon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//        aCon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
//        atapGR.numberOfTapsRequired = 1
//        aCon.addGestureRecognizer(atapGR)
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
//        tapGR.numberOfTapsRequired = 2
//        aCon.addGestureRecognizer(tapGR)
//        atapGR.require(toFail: tapGR) //enable double tap
//        
//        let eUserCover = UIView()
////        eUserCover.backgroundColor = .ddmBlackOverlayColor
////        eUserCover.backgroundColor = .white
//        eUserCover.backgroundColor = .clear
////        contentView.addSubview(eUserCover)
//        aCon.addSubview(eUserCover)
//        eUserCover.translatesAutoresizingMaskIntoConstraints = false
//        eUserCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//        eUserCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
//        eUserCover.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        eUserCover.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        eUserCover.layer.cornerRadius = 14
//        eUserCover.layer.opacity = 1.0 //default 0.3
//        
////        let aUserPhoto = SDAnimatedImageView()
////        contentView.addSubview(aUserPhoto)
//        aCon.addSubview(aUserPhoto)
//        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
//        aUserPhoto.widthAnchor.constraint(equalToConstant: 28).isActive = true //24
//        aUserPhoto.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
//        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
////        aUserPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
////        aUserPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
//        aUserPhoto.contentMode = .scaleAspectFill
//        aUserPhoto.layer.masksToBounds = true
//        aUserPhoto.layer.cornerRadius = 14
////        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
////        aUserPhoto.sd_setImage(with: imageUrl)
//        aUserPhoto.backgroundColor = .ddmDarkColor
//        aUserPhoto.isUserInteractionEnabled = true
//        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
//        
////        let rhsMoreBtn = UIImageView(image: UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate))
//////        rhsMoreBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
////        rhsMoreBtn.tintColor = .white
////        contentView.addSubview(rhsMoreBtn)
////        rhsMoreBtn.translatesAutoresizingMaskIntoConstraints = false
////        rhsMoreBtn.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
////        rhsMoreBtn.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true
////        rhsMoreBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //16
////        rhsMoreBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //16
////        rhsMoreBtn.isUserInteractionEnabled = true
////        rhsMoreBtn.layer.opacity = 0.5
//
////        let aGridNameText = UILabel()
//        aGridNameText.textAlignment = .left
//        aGridNameText.textColor = .white
//        aGridNameText.font = .boldSystemFont(ofSize: 13)
////        contentView.addSubview(aGridNameText)
//        aCon.addSubview(aGridNameText)
//        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
////        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
////        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 5).isActive = true
////        aGridNameText.bottomAnchor.constraint(equalTo: eUserCover.bottomAnchor).isActive = true
//        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
//        aGridNameText.leadingAnchor.constraint(equalTo: eUserCover.trailingAnchor, constant: 5).isActive = true
//        aGridNameText.text = "-"
//        
//        //test > verified badge
////        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow
////        contentView.addSubview(vBtn)
//        aCon.addSubview(vBtn)
//        vBtn.translatesAutoresizingMaskIntoConstraints = false
//        vBtn.leadingAnchor.constraint(equalTo: aGridNameText.trailingAnchor, constant: 5).isActive = true
//        vBtn.centerYAnchor.constraint(equalTo: aGridNameText.centerYAnchor, constant: 0).isActive = true
//        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
//        //
//        
////        let aUserNameText = UILabel()
//        aUserNameText.textAlignment = .left
//        aUserNameText.textColor = .white
//        aUserNameText.font = .systemFont(ofSize: 12)
////        contentView.addSubview(aUserNameText)
//        aCon.addSubview(aUserNameText)
//        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
//        aUserNameText.topAnchor.constraint(equalTo: aGridNameText.bottomAnchor).isActive = true
//        aUserNameText.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
//        aUserNameText.text = "-"
//        aUserNameText.layer.opacity = 0.3 //0.5
//
////        contentView.addSubview(aTest)
//        aCon.addSubview(aTest)
//        aTest.translatesAutoresizingMaskIntoConstraints = false
//        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
//        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
////        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
//        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
////        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
//        
//////        let aText = UILabel()
////        aText.textAlignment = .left
////        aText.textColor = .white
////        aText.font = .systemFont(ofSize: 13)
////        contentView.addSubview(aText)
////        aText.numberOfLines = 0
////        aText.translatesAutoresizingMaskIntoConstraints = false
//////        aText.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 10).isActive = true
////        aText.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 10).isActive = true
//////        aText.leadingAnchor.constraint(equalTo: aUserPhoto.leadingAnchor, constant: 0).isActive = true
////        aText.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
////        aText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
//////        aText.text = "Nice food, nice environment! Worth a visit."
////        aText.text = "-"
//        
////        var gifImage1 = SDAnimatedImageView()
////        gifImage1.contentMode = .scaleAspectFill
////        gifImage1.clipsToBounds = true
////        let gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
////        gifImage1.sd_setImage(with: gifUrl1)
////        gifImage1.layer.cornerRadius = 10 //5
////        contentView.addSubview(gifImage1)
////        gifImage1.translatesAutoresizingMaskIntoConstraints = false
////        gifImage1.widthAnchor.constraint(equalToConstant: 100).isActive = true //ori: 24
////        gifImage1.heightAnchor.constraint(equalToConstant: 150).isActive = true
////        gifImage1.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 10).isActive = true
////        gifImage1.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
//        
//        //test > post performance count metrics
//        let bMiniCon = UIView()
//        aCon.addSubview(bMiniCon)
//        bMiniCon.translatesAutoresizingMaskIntoConstraints = false
//        bMiniCon.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: 0).isActive = true
//        bMiniCon.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true
//        bMiniCon.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
//        bMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        bMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        bMiniCon.isUserInteractionEnabled = true
//        bMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
//        
//        let bMini = UIView()
//        bMini.backgroundColor = .ddmDarkColor
////        contentView.addSubview(bMini)
////        aCon.addSubview(bMini)
//        bMiniCon.addSubview(bMini)
//        bMini.translatesAutoresizingMaskIntoConstraints = false
////        bMini.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: 0).isActive = true
////        bMini.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true
////        bMini.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
//        bMini.centerYAnchor.constraint(equalTo: bMiniCon.centerYAnchor).isActive = true
//        bMini.centerXAnchor.constraint(equalTo: bMiniCon.centerXAnchor).isActive = true
//        bMini.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        bMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        bMini.layer.cornerRadius = 14
//        bMini.layer.opacity = 0.4 //0.2
////        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
//        
////        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
//        bMiniBtn.tintColor = .white
////        bMiniBtn.tintColor = .red
////        contentView.addSubview(bMiniBtn)
////        aCon.addSubview(bMiniBtn)
//        bMiniCon.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
////        bMiniBtn.isUserInteractionEnabled = true
//////        bMiniBtn.layer.opacity = 0.5
////        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
//        
////        let bText = UILabel()
//        bText.textAlignment = .left
//        bText.textColor = .white
//        bText.font = .boldSystemFont(ofSize: 10)
////        contentView.addSubview(bText)
//        aCon.addSubview(bText)
//        bText.clipsToBounds = true
//        bText.translatesAutoresizingMaskIntoConstraints = false
////        bText.leadingAnchor.constraint(equalTo: bMini.trailingAnchor, constant: 2).isActive = true
////        bText.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
//        bText.leadingAnchor.constraint(equalTo: bMiniCon.trailingAnchor, constant: 2).isActive = true
//        bText.centerYAnchor.constraint(equalTo: bMiniCon.centerYAnchor).isActive = true
//        bText.text = "-"
////        bText.layer.opacity = 0.5
//        
//        let cMiniCon = UIView()
//        aCon.addSubview(cMiniCon)
//        cMiniCon.translatesAutoresizingMaskIntoConstraints = false
//        cMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
//        cMiniCon.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
//        cMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        cMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        cMiniCon.isUserInteractionEnabled = true
//        cMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
//        
//        let cMini = UIView()
//        cMini.backgroundColor = .ddmDarkColor
////        contentView.addSubview(cMini)
////        aCon.addSubview(cMini)
//        cMiniCon.addSubview(cMini)
//        cMini.translatesAutoresizingMaskIntoConstraints = false
////        cMini.topAnchor.constraint(equalTo: bMini.topAnchor, constant: 0).isActive = true
////        cMini.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
//        cMini.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
//        cMini.centerXAnchor.constraint(equalTo: cMiniCon.centerXAnchor).isActive = true
//        cMini.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        cMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        cMini.layer.cornerRadius = 14
//        cMini.layer.opacity = 0.4 //0.2
////        cMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
//        
//        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
////        cMiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
//        cMiniBtn.tintColor = .white
////        contentView.addSubview(cMiniBtn)
////        aCon.addSubview(cMiniBtn)
//        cMiniCon.addSubview(cMiniBtn)
//        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
//        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
//        cMiniBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //14
//        cMiniBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //14
////        cMiniBtn.isUserInteractionEnabled = true
////        cMiniBtn.layer.opacity = 0.5
////        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
//        
////        let cText = UILabel()
//        cText.textAlignment = .left
//        cText.textColor = .white
//        cText.font = .boldSystemFont(ofSize: 10)
////        contentView.addSubview(cText)
//        aCon.addSubview(cText)
//        cText.clipsToBounds = true
//        cText.translatesAutoresizingMaskIntoConstraints = false
////        cText.leadingAnchor.constraint(equalTo: cMini.trailingAnchor, constant: 2).isActive = true
////        cText.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
//        cText.leadingAnchor.constraint(equalTo: cMiniCon.trailingAnchor, constant: 2).isActive = true
//        cText.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
//        cText.text = "-"
////        cText.layer.opacity = 0.5
//        
//        let dMiniCon = UIView()
//        aCon.addSubview(dMiniCon)
//        dMiniCon.translatesAutoresizingMaskIntoConstraints = false
//        dMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
//        dMiniCon.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
//        dMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        dMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        dMiniCon.isUserInteractionEnabled = true
//        dMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
//        
//        let dMini = UIView()
//        dMini.backgroundColor = .ddmDarkColor
////        contentView.addSubview(dMini)
////        aCon.addSubview(dMini)
//        dMiniCon.addSubview(dMini)
//        dMini.translatesAutoresizingMaskIntoConstraints = false
////        dMini.topAnchor.constraint(equalTo: cMini.topAnchor, constant: 0).isActive = true
////        dMini.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
//        dMini.centerYAnchor.constraint(equalTo: dMiniCon.centerYAnchor).isActive = true
//        dMini.centerXAnchor.constraint(equalTo: dMiniCon.centerXAnchor).isActive = true
//        dMini.heightAnchor.constraint(equalToConstant: 28).isActive = true//26
//        dMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        dMini.layer.cornerRadius = 14
//        dMini.layer.opacity = 0.4 //0.2
////        dMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
//        
////        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
////        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat_on")?.withRenderingMode(.alwaysTemplate))
//        dMiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
//        dMiniBtn.tintColor = .white
////        dMiniBtn.tintColor = .ddmGoldenYellowColor
////        contentView.addSubview(dMiniBtn)
////        aCon.addSubview(dMiniBtn)
//        dMiniCon.addSubview(dMiniBtn)
//        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
//        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
//        dMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
//        dMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
////        dMiniBtn.isUserInteractionEnabled = true
////        dMiniBtn.layer.opacity = 0.5
////        dMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
//        
////        let dText = UILabel()
//        dText.textAlignment = .left
//        dText.textColor = .white
//        dText.font = .boldSystemFont(ofSize: 10)
////        contentView.addSubview(dText)
//        aCon.addSubview(dText)
//        dText.clipsToBounds = true
//        dText.translatesAutoresizingMaskIntoConstraints = false
////        dText.leadingAnchor.constraint(equalTo: dMini.trailingAnchor, constant: 2).isActive = true
////        dText.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
//        dText.leadingAnchor.constraint(equalTo: dMiniCon.trailingAnchor, constant: 2).isActive = true
//        dText.centerYAnchor.constraint(equalTo: dMiniCon.centerYAnchor).isActive = true
//        dText.text = "-"
////        dText.layer.opacity = 0.5
//        
//        let eMiniCon = UIView()
//        aCon.addSubview(eMiniCon)
//        eMiniCon.translatesAutoresizingMaskIntoConstraints = false
//        eMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
//        eMiniCon.leadingAnchor.constraint(equalTo: dText.trailingAnchor, constant: 20).isActive = true
//        eMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        eMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        eMiniCon.isUserInteractionEnabled = true
//        eMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
//        
//        let eMini = UIView()
//        eMini.backgroundColor = .ddmDarkColor
////        eMini.backgroundColor = .green
////        contentView.addSubview(eMini)
////        aCon.addSubview(eMini)
//        eMiniCon.addSubview(eMini)
//        eMini.translatesAutoresizingMaskIntoConstraints = false
////        eMini.topAnchor.constraint(equalTo: dMini.topAnchor, constant: 0).isActive = true
////        eMini.leadingAnchor.constraint(equalTo: dText.trailingAnchor, constant: 20).isActive = true
//        eMini.centerYAnchor.constraint(equalTo: eMiniCon.centerYAnchor).isActive = true
//        eMini.centerXAnchor.constraint(equalTo: eMiniCon.centerXAnchor).isActive = true
//        eMini.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
//        eMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
//        eMini.layer.cornerRadius = 14
//        eMini.layer.opacity = 0.4 //0.2
////        eMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
//        
//        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
////        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate))
//        eMiniBtn.tintColor = .white
////        eMiniBtn.tintColor = .green
////        contentView.addSubview(eMiniBtn)
////        aCon.addSubview(eMiniBtn)
//        eMiniCon.addSubview(eMiniBtn)
//        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        eMiniBtn.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
//        eMiniBtn.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: -2).isActive = true //-2
//        eMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
//        eMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
////        eMiniBtn.isUserInteractionEnabled = true
////        eMiniBtn.layer.opacity = 0.5
////        eMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
//        
////        let eText = UILabel()
//        eText.textAlignment = .left
//        eText.textColor = .white
//        eText.font = .boldSystemFont(ofSize: 10)
////        contentView.addSubview(eText)
//        aCon.addSubview(eText)
//        eText.clipsToBounds = true
//        eText.translatesAutoresizingMaskIntoConstraints = false
////        eText.leadingAnchor.constraint(equalTo: eMini.trailingAnchor, constant: 2).isActive = true
////        eText.centerYAnchor.constraint(equalTo: eMini.centerYAnchor).isActive = true
//        eText.leadingAnchor.constraint(equalTo: eMiniCon.trailingAnchor, constant: 2).isActive = true
//        eText.centerYAnchor.constraint(equalTo: eMiniCon.centerYAnchor).isActive = true
//        eText.text = "-"
////        eText.layer.opacity = 0.5
//        
//        //test > dynamic cell for comment
//        contentView.addSubview(aTest2)
//        aTest2.translatesAutoresizingMaskIntoConstraints = false
//        aTest2.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
//        aTest2.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest2.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 10).isActive = true
//        
//        //test > inter-post connector lines
////        aBox.backgroundColor = .ddmBlackOverlayColor
//        aConnector.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aConnector)
//        aConnector.clipsToBounds = true
//        aConnector.translatesAutoresizingMaskIntoConstraints = false
//        aConnector.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor, constant: 0).isActive = true
//        aConnector.widthAnchor.constraint(equalToConstant: 3).isActive = true //default: 50
//        aConnector.bottomAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
//        aConnector.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 10).isActive = true
////        aConnector.layer.opacity = 0.5
//        aConnector.isHidden = true
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        print("prepare for reuse")
//        
//        photoConArray.removeAll()
//        
//        aGridNameText.text = "-"
//        vBtn.image = nil
//        let imageUrl = URL(string: "")
//        aUserPhoto.sd_setImage(with: imageUrl)
//        
//        bText.text = "0"
//        cText.text = "0"
//        dText.text = "0"
//        eText.text = "0"
//        
//        for e in aTestArray {
//            e.removeFromSuperview()
//        }
//        aTestArray.removeAll()
//        
//        for e in aTest2Array {
//            e.removeFromSuperview()
//        }
//        aTest2Array.removeAll()
//        
//        aConnector.isHidden = true
//    }
//    
//    //*test > async fetch images/names/videos
//    func asyncConfigure(data: String) {
//        let id = "u_"
//        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
//            switch result {
//                case .success(let l):
//
//                //update UI on main thread
//                DispatchQueue.main.async {
//                    print("pdp api success \(id), \(l)")
//                    
//                    guard let self = self else {
//                        return
//                    }
//
//                    self.aGridNameText.text = "Michael Kins"
//                    self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
//                    
//                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                    self.aUserPhoto.sd_setImage(with: imageUrl)
//                }
//
//                case .failure(let error):
//                DispatchQueue.main.async {
//                    
//                    guard let self = self else {
//                        return
//                    }
//                    self.aGridNameText.text = "-"
//                    self.vBtn.image = nil
//                    
//                    let imageUrl = URL(string: "")
//                    self.aUserPhoto.sd_setImage(with: imageUrl)
//                    
//                }
//                break
//            }
//        }
//    }
//    //*
//    
//    func configure(data: BaseData) {
////        aGridNameText.text = "Michael Gerber"
//        asyncConfigure(data: "")
//        
//        aUserNameText.text = "4hr . 324k views"
//        
//        //test > dynamic create ui for various data types in sequence
//        let dataL = data.dataArray
////        var count = 0
//        for l in dataL {
//            if(l == "t") {
//                let aaText = UILabel()
//                aaText.textAlignment = .left
//                aaText.textColor = .white
//                aaText.font = .systemFont(ofSize: 13)
//                aaText.numberOfLines = 0
//                aTest.addSubview(aaText)
//                aaText.translatesAutoresizingMaskIntoConstraints = false
//                if(aTestArray.isEmpty) {
//                    aaText.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                } else {
//                    let lastArrayE = aTestArray[aTestArray.count - 1]
//                    aaText.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
//                }
//                aaText.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
//                aaText.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
////                aaText.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
//                aaText.text = data.dataTextString
//                aTestArray.append(aaText)
//            }
//            else if(l == "p") {
//                //single image
////                let gifImage1 = SDAnimatedImageView()
////                gifImage1.contentMode = .scaleAspectFill
////                gifImage1.clipsToBounds = true
////                let gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
////                gifImage1.sd_setImage(with: gifUrl1)
////                gifImage1.layer.cornerRadius = 10 //5
////                aTest.addSubview(gifImage1)
////                gifImage1.translatesAutoresizingMaskIntoConstraints = false
////                gifImage1.widthAnchor.constraint(equalToConstant: 180).isActive = true //150
////                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
////                if(aTestArray.isEmpty) {
////                    gifImage1.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
////                } else {
////                    let lastArrayE = aTestArray[aTestArray.count - 1]
////                    gifImage1.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
////                }
////                gifImage1.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
////                gifImage1.isUserInteractionEnabled = true
////                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20
////                aTestArray.append(gifImage1)
////                //test > hide photo when clicked
////                photoConArray.append(gifImage1)
//                
//                //carousel of images
////                let scrollView = UIScrollView()
////                aTest.addSubview(scrollView)
////                scrollView.backgroundColor = .clear
////                scrollView.translatesAutoresizingMaskIntoConstraints = false
//////                scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
////                if(aTestArray.isEmpty) {
////                    scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
////                } else {
////                    let lastArrayE = aTestArray[aTestArray.count - 1]
////                    scrollView.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
////                }
////                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 0).isActive = true
////                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: 0).isActive = true
////                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //250
////                scrollView.showsHorizontalScrollIndicator = false
////                scrollView.alwaysBounceHorizontal = true
////                scrollView.contentSize = CGSize(width: 720, height: 280) //720, 250
////        //        scrollView.contentSize = CGSize(width: 360, height: 280)
//////                scrollView.delegate = self
////                aTestArray.append(scrollView)
////
////                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
////
////                var gifImage1 = SDAnimatedImageView()
////                gifImage1.contentMode = .scaleAspectFill
////                gifImage1.clipsToBounds = true
////                gifImage1.sd_setImage(with: gifUrl)
////                gifImage1.layer.cornerRadius = 10 //5
////                scrollView.addSubview(gifImage1)
////                gifImage1.translatesAutoresizingMaskIntoConstraints = false
////                gifImage1.widthAnchor.constraint(equalToConstant: 180).isActive = true //150
////                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
////                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
////                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 53).isActive = true
////
////                var gifImage2 = SDAnimatedImageView()
////                gifImage2.contentMode = .scaleAspectFill
////                gifImage2.clipsToBounds = true
////                gifImage2.sd_setImage(with: gifUrl)
////                gifImage2.layer.cornerRadius = 10 //5
////                scrollView.addSubview(gifImage2)
////                gifImage2.translatesAutoresizingMaskIntoConstraints = false
////                gifImage2.widthAnchor.constraint(equalToConstant: 180).isActive = true //150
////                gifImage2.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
////                gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
////                gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 10).isActive = true
//                
//                //carousel of images
//                let scrollView = UIScrollView()
//                aTest.addSubview(scrollView)
//                scrollView.backgroundColor = .clear
//                scrollView.translatesAutoresizingMaskIntoConstraints = false
////                scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                if(aTestArray.isEmpty) {
//                    scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                } else {
//                    let lastArrayE = aTestArray[aTestArray.count - 1]
//                    scrollView.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
//                }
//                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true //20
////                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
//                scrollView.widthAnchor.constraint(equalToConstant: 330).isActive = true  //280
//                scrollView.heightAnchor.constraint(equalToConstant: 240).isActive = true  //280
//                scrollView.showsHorizontalScrollIndicator = false
//                scrollView.alwaysBounceHorizontal = true
//                scrollView.contentSize = CGSize(width: 660, height: 240) //800, 280
//        //        scrollView.contentSize = CGSize(width: 360, height: 280)
//                scrollView.isPagingEnabled = true //false
////                scrollView.delegate = self
//                scrollView.layer.cornerRadius = 10 //5
//                aTestArray.append(scrollView)
//                photoConArray.append(scrollView)
//
////                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
////                let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
////            https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg
//                
//                let gifImage1 = SDAnimatedImageView()
//                gifImage1.contentMode = .scaleAspectFill
//                gifImage1.clipsToBounds = true
//                gifImage1.sd_setImage(with: gifUrl)
//                scrollView.addSubview(gifImage1)
//                gifImage1.translatesAutoresizingMaskIntoConstraints = false
//                gifImage1.widthAnchor.constraint(equalToConstant: 330).isActive = true //180
//                gifImage1.heightAnchor.constraint(equalToConstant: 240).isActive = true //280
//                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
//                //test > click on photo
//                gifImage1.isUserInteractionEnabled = true
//                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20
//
//                let gifImage2 = SDAnimatedImageView()
//                gifImage2.contentMode = .scaleAspectFill
//                gifImage2.clipsToBounds = true
////                gifImage2.sd_setImage(with: gifUrl)
//                scrollView.addSubview(gifImage2)
//                gifImage2.translatesAutoresizingMaskIntoConstraints = false
//                gifImage2.widthAnchor.constraint(equalToConstant: 330).isActive = true //180
//                gifImage2.heightAnchor.constraint(equalToConstant: 240).isActive = true //280
//                gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 0).isActive = true //10
//                
//                //test > add bubble
//                let dataCount = 2
//                let p = data.p_s
//                if(dataCount > 1) {
//                    let bubbleBox = PageBubbleIndicator()
//                    bubbleBox.backgroundColor = .clear
//                    aTest.addSubview(bubbleBox)
//                    bubbleBox.translatesAutoresizingMaskIntoConstraints = false
////                    bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
//                    bubbleBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
//                    bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
//                    bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
//    //                bubbleBox.isHidden = true
//                    bubbleBox.setConfiguration(number: dataCount, color: .yellow)
////                    bubbleBox.setIndicatorSelected(index: 0)
//                    bubbleBox.setIndicatorSelected(index: p) //revert to last viewed photo in carousel
//                    aTestArray.append(bubbleBox)
//                    
//                    bubbleArray.append(bubbleBox)
//                }
//                
//                //revert to last viewed photo in carousel
//                let xOffset = CGFloat(p) * 330
//                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
//            }
//            else if(l == "p_s") {
//                //test > loop cover
//                let pConBg = UIView()
//                pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
//                aTest.addSubview(pConBg)
//                pConBg.frame = CGRect(x: 0, y: 0, width: 330, height: 320)
//                pConBg.translatesAutoresizingMaskIntoConstraints = false
//                pConBg.widthAnchor.constraint(equalToConstant: 330).isActive = true //150, 370
//                pConBg.heightAnchor.constraint(equalToConstant: 320).isActive = true //250, 280
//                if(aTestArray.isEmpty) {
//                    pConBg.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                } else {
//                    let lastArrayE = aTestArray[aTestArray.count - 1]
//                    pConBg.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
//                }
//                pConBg.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true //20
//                pConBg.layer.cornerRadius = 10
//                pConBg.layer.opacity = 0.4 //0.2
//                aTestArray.append(pConBg)
//                
//                //carousel of images
////                let scrollView = UIScrollView()
////                aTest.addSubview(scrollView)
////                scrollView.backgroundColor = .clear
////                scrollView.translatesAutoresizingMaskIntoConstraints = false
//////                scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
////                if(aTestArray.isEmpty) {
////                    scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
////                } else {
////                    let lastArrayE = aTestArray[aTestArray.count - 1]
////                    scrollView.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
////                }
////                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true //0
//////                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
////                scrollView.widthAnchor.constraint(equalToConstant: 370).isActive = true  //280
////                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
////                scrollView.showsHorizontalScrollIndicator = false
////                scrollView.alwaysBounceHorizontal = true
////                scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
////        //        scrollView.contentSize = CGSize(width: 360, height: 280)
////                scrollView.isPagingEnabled = true //false
////                scrollView.delegate = self
////                scrollView.layer.cornerRadius = 10 //5
////                aTestArray.append(scrollView)
//                
//                let scrollView = UIScrollView()
//                aTest.addSubview(scrollView)
//                scrollView.backgroundColor = .clear
//                scrollView.translatesAutoresizingMaskIntoConstraints = false
//                scrollView.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
//                scrollView.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true //0
////                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
//                scrollView.widthAnchor.constraint(equalToConstant: 330).isActive = true  //280
//                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
//                scrollView.showsHorizontalScrollIndicator = false
//                scrollView.alwaysBounceHorizontal = true
//                scrollView.contentSize = CGSize(width: 660, height: 280) //800, 280
//        //        scrollView.contentSize = CGSize(width: 360, height: 280)
//                scrollView.isPagingEnabled = true //false
////                scrollView.delegate = self
//                scrollView.layer.cornerRadius = 10 //5
//                scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
////                scrollView.clipsToBounds = true
////                scrollView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//                aTestArray.append(scrollView)
//                photoConArray.append(scrollView)
//
////                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
////            https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg
//                
//                let gifImage1 = SDAnimatedImageView()
//                gifImage1.contentMode = .scaleAspectFill
//                gifImage1.clipsToBounds = true
//                gifImage1.sd_setImage(with: gifUrl)
////                gifImage1.layer.cornerRadius = 10 //5
//                scrollView.addSubview(gifImage1)
//                gifImage1.translatesAutoresizingMaskIntoConstraints = false
//                gifImage1.widthAnchor.constraint(equalToConstant: 330).isActive = true //180
//                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //280
//                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
//                //test > click on photo
//                gifImage1.isUserInteractionEnabled = true
////                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoSClicked)))//20
//
//                let gifImage2 = SDAnimatedImageView()
//                gifImage2.contentMode = .scaleAspectFill
//                gifImage2.clipsToBounds = true
//                gifImage2.sd_setImage(with: gifUrl)
////                gifImage2.layer.cornerRadius = 10 //5
//                scrollView.addSubview(gifImage2)
//                gifImage2.translatesAutoresizingMaskIntoConstraints = false
//                gifImage2.widthAnchor.constraint(equalToConstant: 330).isActive = true //180
//                gifImage2.heightAnchor.constraint(equalToConstant: 280).isActive = true //280
//                gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 0).isActive = true //10
//                
//                //test > add "shot" label
//                let label = UIView()
//                aTest.addSubview(label)
////                label.backgroundColor = .ddmDarkColor
//                label.backgroundColor = .clear
//                label.translatesAutoresizingMaskIntoConstraints = false
////                label.widthAnchor.constraint(equalToConstant: 80).isActive = true //80
//                label.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
//                label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
////                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5).isActive = true
//                label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5).isActive = true
////                label.layer.opacity = 0.5
//                label.layer.cornerRadius = 5
//                aTestArray.append(label)
//                
//                let labelBg = UIView()
//                label.addSubview(labelBg)
//                labelBg.backgroundColor = .ddmDarkColor
////                labelBg.backgroundColor = .white
//                labelBg.translatesAutoresizingMaskIntoConstraints = false
//                labelBg.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
//                labelBg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0).isActive = true
//                labelBg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
//                labelBg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
////                labelBg.layer.opacity = 0.8 //0.5
//                labelBg.layer.opacity = 0.3 //0.5
//                labelBg.layer.cornerRadius = 5
//                
//                let e2UserCover = UIView()
//                e2UserCover.backgroundColor = .clear
//                label.addSubview(e2UserCover)
//                e2UserCover.translatesAutoresizingMaskIntoConstraints = false
////                e2UserCover.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true //20
//                e2UserCover.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
//                e2UserCover.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
//                e2UserCover.heightAnchor.constraint(equalToConstant: 20).isActive = true //28
//                e2UserCover.widthAnchor.constraint(equalToConstant: 20).isActive = true //28
//                e2UserCover.layer.cornerRadius = 10
//                e2UserCover.layer.opacity = 1.0 //default 0.3
//
//                let a2UserPhoto = SDAnimatedImageView()
//                label.addSubview(a2UserPhoto)
//                a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
//                a2UserPhoto.widthAnchor.constraint(equalToConstant: 20).isActive = true //36
//                a2UserPhoto.heightAnchor.constraint(equalToConstant: 20).isActive = true
//                a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
//                a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
//                a2UserPhoto.contentMode = .scaleAspectFill
//                a2UserPhoto.layer.masksToBounds = true
//                a2UserPhoto.layer.cornerRadius = 10
//                let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                a2UserPhoto.sd_setImage(with: image2Url)
//                a2UserPhoto.backgroundColor = .ddmDarkGreyColor
//                
//                let aGridNameText = UILabel()
//                aGridNameText.textAlignment = .left
//                aGridNameText.textColor = .white
////                aGridNameText.textColor = .ddmDarkColor
//                aGridNameText.font = .boldSystemFont(ofSize: 12)
//                label.addSubview(aGridNameText)
//                aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//                aGridNameText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
//                aGridNameText.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5).isActive = true
//                aGridNameText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 5).isActive = true
//                aGridNameText.text = "Shot"
////                aGridNameText.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
////                aGridNameText.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
//                
//                //test > add bubble
//                let dataCount = 2
//                let p = data.p_s
//                if(dataCount > 1) {
//                    let bubbleBox = PageBubbleIndicator()
//                    bubbleBox.backgroundColor = .clear
//                    aTest.addSubview(bubbleBox)
//                    bubbleBox.translatesAutoresizingMaskIntoConstraints = false
////                    bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
//                    bubbleBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
//                    bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
//                    bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
//    //                bubbleBox.isHidden = true
//                    bubbleBox.setConfiguration(number: dataCount, color: .yellow)
////                    bubbleBox.setIndicatorSelected(index: 0)
//                    bubbleBox.setIndicatorSelected(index: p) //revert to last viewed photo in carousel
//                    aTestArray.append(bubbleBox)
//                    
//                    bubbleArray.append(bubbleBox)
//                }
//                
//                //revert to last viewed photo in carousel
//                let xOffset = CGFloat(p) * 330
//                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
//                
//                //test > shot description
//                let pConBottom = UIView()
//                pConBottom.frame = CGRect(x: 0, y: 0, width: 330, height: 40)
////                vConBottom.backgroundColor = .ddmDarkColor //.ddmDarkColor
//                aTest.addSubview(pConBottom)
//                pConBottom.translatesAutoresizingMaskIntoConstraints = false
//                pConBottom.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true
////                pConBottom.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
//                pConBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
//                pConBottom.widthAnchor.constraint(equalToConstant: 330).isActive = true
//                pConBottom.bottomAnchor.constraint(equalTo: pConBg.bottomAnchor, constant: 0).isActive = true //0
//                pConBottom.isUserInteractionEnabled = true
////                pConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoSClicked)))
////                vConBottom.layer.cornerRadius = 10
//                aTestArray.append(pConBottom)
//                
//                let moreBtn = UIImageView()
//                moreBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
////                moreBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
//                moreBtn.tintColor = .white
//                pConBottom.addSubview(moreBtn)
//                moreBtn.translatesAutoresizingMaskIntoConstraints = false
//                moreBtn.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
//                moreBtn.trailingAnchor.constraint(equalTo: pConBottom.trailingAnchor, constant: -5).isActive = true
//                moreBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
//                moreBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                
//                let aaText = UILabel()
//                aaText.textAlignment = .left
//                aaText.textColor = .white
//                aaText.font = .systemFont(ofSize: 13)
//                aaText.numberOfLines = 1
//                pConBottom.addSubview(aaText)
//                aaText.translatesAutoresizingMaskIntoConstraints = false
//                aaText.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
////                aaText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 10).isActive = true
//                aaText.leadingAnchor.constraint(equalTo: pConBottom.leadingAnchor, constant: 10).isActive = true //5
//                aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
//                aaText.text = data.dataTextString
//            }
//            else if(l == "v_l") {//loop videos
//                
//                //test > loop cover
//                let vConBg = UIView()
//                vConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
//                aTest.addSubview(vConBg)
//                vConBg.frame = CGRect(x: 0, y: 0, width: 220, height: 390) //150, 250
//                vConBg.translatesAutoresizingMaskIntoConstraints = false
//                vConBg.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
//                vConBg.heightAnchor.constraint(equalToConstant: 390).isActive = true //250, 280
//                if(aTestArray.isEmpty) {
//                    vConBg.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                } else {
//                    let lastArrayE = aTestArray[aTestArray.count - 1]
//                    vConBg.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
//                }
//                vConBg.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
//                vConBg.layer.cornerRadius = 10
//                vConBg.layer.opacity = 0.4 //0.2
//                aTestArray.append(vConBg)
//                
//                //test 2 > with real video player
////                let videoContainer = UIView()
////                videoContainer.frame = CGRect(x: 0, y: 0, width: 220, height: 350) //150, 250
////                aTest.addSubview(videoContainer)
////                videoContainer.translatesAutoresizingMaskIntoConstraints = false
////                videoContainer.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
////                videoContainer.heightAnchor.constraint(equalToConstant: 350).isActive = true //250, 280
////                if(aTestArray.isEmpty) {
////                    videoContainer.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
////                } else {
////                    let lastArrayE = aTestArray[aTestArray.count - 1]
////                    videoContainer.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
////                }
////                videoContainer.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
////                videoContainer.clipsToBounds = true
//////                videoContainer.layer.cornerRadius = 10
////                videoContainer.backgroundColor = .black
////                videoContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
////                videoContainer.isUserInteractionEnabled = true
////                videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
////                aTestArray.append(videoContainer)
//                
//                let videoContainer = UIView()
//                videoContainer.frame = CGRect(x: 0, y: 0, width: 220, height: 350) //150, 250
//                aTest.addSubview(videoContainer)
//                videoContainer.translatesAutoresizingMaskIntoConstraints = false
//                videoContainer.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
//                videoContainer.heightAnchor.constraint(equalToConstant: 350).isActive = true //250, 280
//                videoContainer.topAnchor.constraint(equalTo: vConBg.topAnchor, constant: 0).isActive = true
//                videoContainer.leadingAnchor.constraint(equalTo: vConBg.leadingAnchor, constant: 0).isActive = true
//                videoContainer.clipsToBounds = true
////                videoContainer.layer.cornerRadius = 10
//                videoContainer.backgroundColor = .black
////                videoContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//                videoContainer.layer.cornerRadius = 10 //5
//                videoContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//                videoContainer.isUserInteractionEnabled = true
//                videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
//                aTestArray.append(videoContainer)
//                
//                vidConArray.append(videoContainer)
//                
//                //test > add "shot" label
//                let label = UIView()
//                aTest.addSubview(label)
////                label.backgroundColor = .ddmDarkColor
//                label.backgroundColor = .clear
//                label.translatesAutoresizingMaskIntoConstraints = false
////                label.widthAnchor.constraint(equalToConstant: 80).isActive = true //80
//                label.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
//                label.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 5).isActive = true
////                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5).isActive = true
//                label.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
////                label.layer.opacity = 0.5
//                label.layer.cornerRadius = 5
//                aTestArray.append(label)
//                
//                let labelBg = UIView()
//                label.addSubview(labelBg)
//                labelBg.backgroundColor = .ddmDarkColor
////                labelBg.backgroundColor = .white
//                labelBg.translatesAutoresizingMaskIntoConstraints = false
//                labelBg.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
//                labelBg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0).isActive = true
//                labelBg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
//                labelBg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
////                labelBg.layer.opacity = 0.8 //0.5
//                labelBg.layer.opacity = 0.3 //0.5
//                labelBg.layer.cornerRadius = 5
//                
//                let e2UserCover = UIView()
//                e2UserCover.backgroundColor = .clear
//                label.addSubview(e2UserCover)
//                e2UserCover.translatesAutoresizingMaskIntoConstraints = false
////                e2UserCover.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true //20
//                e2UserCover.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
//                e2UserCover.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
//                e2UserCover.heightAnchor.constraint(equalToConstant: 20).isActive = true //28
//                e2UserCover.widthAnchor.constraint(equalToConstant: 20).isActive = true //28
//                e2UserCover.layer.cornerRadius = 10
//                e2UserCover.layer.opacity = 1.0 //default 0.3
//
//                let a2UserPhoto = SDAnimatedImageView()
//                label.addSubview(a2UserPhoto)
//                a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
//                a2UserPhoto.widthAnchor.constraint(equalToConstant: 20).isActive = true //36
//                a2UserPhoto.heightAnchor.constraint(equalToConstant: 20).isActive = true
//                a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
//                a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
//                a2UserPhoto.contentMode = .scaleAspectFill
//                a2UserPhoto.layer.masksToBounds = true
//                a2UserPhoto.layer.cornerRadius = 10
//                let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                a2UserPhoto.sd_setImage(with: image2Url)
//                a2UserPhoto.backgroundColor = .ddmDarkGreyColor
//                
//                let aGridNameText = UILabel()
//                aGridNameText.textAlignment = .left
//                aGridNameText.textColor = .white
////                aGridNameText.textColor = .ddmDarkColor
//                aGridNameText.font = .boldSystemFont(ofSize: 12)
//                label.addSubview(aGridNameText)
//                aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//                aGridNameText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
//                aGridNameText.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5).isActive = true
//                aGridNameText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 5).isActive = true
//                aGridNameText.text = "Loop"
////                aGridNameText.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
////                aGridNameText.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
//                
//                //test > play/pause btn
//                let playBtn = UIImageView()
//                playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
////                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
//                playBtn.tintColor = .white
//                aTest.addSubview(playBtn)
//                playBtn.translatesAutoresizingMaskIntoConstraints = false
//                playBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
//                playBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
////                playBtn.leadingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
//                playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
//                playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                playBtn.isUserInteractionEnabled = true
//                playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
//                aTestArray.append(playBtn)
//                
//                playBtnArray.append(playBtn)
//                
//                //test > sound on/off
//                let soundOnBtn = UIImageView()
////                soundOnBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                soundOnBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
//                soundOnBtn.tintColor = .white
//                aTest.addSubview(soundOnBtn)
//                soundOnBtn.translatesAutoresizingMaskIntoConstraints = false
//                soundOnBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
//                soundOnBtn.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 5).isActive = true
//                soundOnBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
//                soundOnBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                soundOnBtn.isUserInteractionEnabled = true
////                soundOnBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
//                aTestArray.append(soundOnBtn)
//                
//                //video player
//                let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
//                let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
//                
//                //method 1
////                player = AVPlayer()
////                let playerView = AVPlayerLayer()
////                playerView.player = player
////                playerView.frame = videoContainer.bounds
////                playerView.videoGravity = .resizeAspectFill
////                videoContainer.layer.addSublayer(playerView)
////                let playerItem = AVPlayerItem(url: url)
////                player.replaceCurrentItem(with: playerItem)
//////                player?.seek(to: .zero)
//                
//                //method 2
//                if(player != nil && player.currentItem != nil) {
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//                }
//                
//                let item2 = AVPlayerItem(url: url)
//                player = AVPlayer(playerItem: item2)
//                let layer2 = AVPlayerLayer(player: player)
//                layer2.frame = videoContainer.bounds
//                layer2.videoGravity = .resizeAspectFill
//                videoContainer.layer.addSublayer(layer2)
//
//                //test > resume to paused timestamp
//                let t = data.t_s
//                let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//
//                //add timestamp video while playing
//                addTimeObserverVideo()
//                
//                //test > for looping
//                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//                
//                //method 3 > loop
////                player = AVQueuePlayer()
////                let playerView = AVPlayerLayer(player: player)
////                let playerItem = AVPlayerItem(url: url)
////                playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
////                playerView.frame = videoContainer.bounds
////                playerView.videoGravity = .resizeAspectFill
////                videoContainer.layer.addSublayer(playerView)
////
////                let t = data.t_s
////                let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
////                print("sfvideo configure $$ \(t), \(player)")
//////                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
////                player?.seek(to: seekTime)
////
////                addTimeObserverVideo()
//                
//                //test > loop description
//                let vConBottom = UIView()
//                vConBottom.frame = CGRect(x: 0, y: 0, width: 220, height: 40)
////                vConBottom.backgroundColor = .ddmDarkColor //.ddmDarkColor
//                aTest.addSubview(vConBottom)
//                vConBottom.translatesAutoresizingMaskIntoConstraints = false
//                vConBottom.leadingAnchor.constraint(equalTo: vConBg.leadingAnchor, constant: 0).isActive = true
////                vConBottom.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
//                vConBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
//                vConBottom.widthAnchor.constraint(equalToConstant: 220).isActive = true
//                vConBottom.bottomAnchor.constraint(equalTo: vConBg.bottomAnchor, constant: 0).isActive = true //0
//                vConBottom.isUserInteractionEnabled = true
//                vConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
////                vConBottom.layer.cornerRadius = 10
//                aTestArray.append(vConBottom)
//                
//                let moreBtn = UIImageView()
//                moreBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
////                moreBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
//                moreBtn.tintColor = .white
//                vConBottom.addSubview(moreBtn)
//                moreBtn.translatesAutoresizingMaskIntoConstraints = false
//                moreBtn.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
//                moreBtn.trailingAnchor.constraint(equalTo: vConBottom.trailingAnchor, constant: -5).isActive = true
//                moreBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
//                moreBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                
//                let aaText = UILabel()
//                aaText.textAlignment = .left
//                aaText.textColor = .white
//                aaText.font = .systemFont(ofSize: 13)
//                aaText.numberOfLines = 1
//                vConBottom.addSubview(aaText)
//                aaText.translatesAutoresizingMaskIntoConstraints = false
//                aaText.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
////                aaText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 10).isActive = true
//                aaText.leadingAnchor.constraint(equalTo: vConBottom.leadingAnchor, constant: 10).isActive = true //5
//                aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
//                aaText.text = data.dataTextString
//            }
//            else if(l == "v") { //vi
//                let videoContainer = UIView()
//                videoContainer.frame = CGRect(x: 0, y: 0, width: 220, height: 350) //150, 250
//                aTest.addSubview(videoContainer)
//                videoContainer.translatesAutoresizingMaskIntoConstraints = false
//                videoContainer.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
//                videoContainer.heightAnchor.constraint(equalToConstant: 350).isActive = true //250, 280
//                if(aTestArray.isEmpty) {
//                    videoContainer.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                } else {
//                    let lastArrayE = aTestArray[aTestArray.count - 1]
//                    videoContainer.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
//                }
//                videoContainer.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
//                videoContainer.clipsToBounds = true
//                videoContainer.layer.cornerRadius = 10
//                videoContainer.backgroundColor = .black
////                videoContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//                videoContainer.isUserInteractionEnabled = true
//                videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoClicked)))
//                aTestArray.append(videoContainer)
//                
//                vidConArray.append(videoContainer)
//                
//                //test > play/pause btn
//                let playBtn = UIImageView()
//                playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
////                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
//                playBtn.tintColor = .white
//                aTest.addSubview(playBtn)
//                playBtn.translatesAutoresizingMaskIntoConstraints = false
//                playBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
//                playBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
////                playBtn.leadingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
//                playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
//                playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                playBtn.isUserInteractionEnabled = true
//                playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
//                aTestArray.append(playBtn)
//                
//                playBtnArray.append(playBtn)
//                
//                //test > sound on/off
//                let soundOnBtn = UIImageView()
////                soundOnBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                soundOnBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
//                soundOnBtn.tintColor = .white
//                aTest.addSubview(soundOnBtn)
//                soundOnBtn.translatesAutoresizingMaskIntoConstraints = false
//                soundOnBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
//                soundOnBtn.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 5).isActive = true
//                soundOnBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
//                soundOnBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                soundOnBtn.isUserInteractionEnabled = true
////                soundOnBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
//                aTestArray.append(soundOnBtn)
//                
//                //video player
//                let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
//                let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
//                
//                if(player != nil && player.currentItem != nil) {
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//                }
//                
//                let item2 = AVPlayerItem(url: url)
//                player = AVPlayer(playerItem: item2)
//                let layer2 = AVPlayerLayer(player: player)
//                layer2.frame = videoContainer.bounds
//                layer2.videoGravity = .resizeAspectFill
//                videoContainer.layer.addSublayer(layer2)
//
//                //test > resume to paused timestamp
//                let t = data.t_s
//                let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//
//                //add timestamp video while playing
//                addTimeObserverVideo()
//                
//                //test > for looping
//                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//            }
//            else if(l == "q") {
//                let aQPost = UIView()
//                aQPost.backgroundColor = .ddmDarkColor //.ddmDarkColor
//                aTest.addSubview(aQPost)
//                aQPost.translatesAutoresizingMaskIntoConstraints = false
//                aQPost.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
//                aQPost.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
////                aQPost.heightAnchor.constraint(equalToConstant: 120).isActive = true //120
////                aQPost.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
//                if(aTestArray.isEmpty) {
//                    aQPost.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
//                } else {
//                    let lastArrayE = aTestArray[aTestArray.count - 1]
//                    aQPost.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
//                }
//                aQPost.layer.cornerRadius = 10
//                aTestArray.append(aQPost)
//                //test > click on aTest for click post
//                aQPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onQuotePostClicked)))
//
//                let aQBG = UIView()
//                aQBG.backgroundColor = .ddmBlackOverlayColor
//                aQPost.addSubview(aQBG)
//                aQBG.translatesAutoresizingMaskIntoConstraints = false
//                aQBG.leadingAnchor.constraint(equalTo: aQPost.leadingAnchor, constant: 2).isActive = true
//                aQBG.trailingAnchor.constraint(equalTo: aQPost.trailingAnchor, constant: -2).isActive = true
//                aQBG.bottomAnchor.constraint(equalTo: aQPost.bottomAnchor, constant: -2).isActive = true
//                aQBG.topAnchor.constraint(equalTo: aQPost.topAnchor, constant: 2).isActive = true
//                aQBG.layer.cornerRadius = 10
//                
//                let aQBGa = UIView()
////                aQBGa.backgroundColor = .ddmBlackOverlayColor
//                aQBGa.backgroundColor = .ddmDarkColor
//                aQPost.addSubview(aQBGa)
//                aQBGa.translatesAutoresizingMaskIntoConstraints = false
//                aQBGa.leadingAnchor.constraint(equalTo: aQPost.leadingAnchor, constant: 2).isActive = true
//                aQBGa.trailingAnchor.constraint(equalTo: aQPost.trailingAnchor, constant: -2).isActive = true
//                aQBGa.bottomAnchor.constraint(equalTo: aQPost.bottomAnchor, constant: -2).isActive = true
//                aQBGa.topAnchor.constraint(equalTo: aQPost.topAnchor, constant: 2).isActive = true
//                aQBGa.layer.cornerRadius = 10
//                aQBGa.layer.opacity = 0.1 //default 0.3
//
//                let qUserCover = UIView()
//                qUserCover.backgroundColor = .clear
//                aQPost.addSubview(qUserCover)
//                qUserCover.translatesAutoresizingMaskIntoConstraints = false
//                qUserCover.topAnchor.constraint(equalTo: aQBG.topAnchor, constant: 10).isActive = true
//                qUserCover.leadingAnchor.constraint(equalTo: aQBG.leadingAnchor, constant: 10).isActive = true //20
//                qUserCover.heightAnchor.constraint(equalToConstant: 28).isActive = true
//                qUserCover.widthAnchor.constraint(equalToConstant: 28).isActive = true
//                qUserCover.layer.cornerRadius = 14
//                qUserCover.layer.opacity = 1.0 //default 0.3
//
//                let qUserPhoto = SDAnimatedImageView()
//                aQPost.addSubview(qUserPhoto)
//                qUserPhoto.translatesAutoresizingMaskIntoConstraints = false
//                qUserPhoto.widthAnchor.constraint(equalToConstant: 28).isActive = true //24
//                qUserPhoto.heightAnchor.constraint(equalToConstant: 28).isActive = true
//                qUserPhoto.centerXAnchor.constraint(equalTo: qUserCover.centerXAnchor).isActive = true
//                qUserPhoto.centerYAnchor.constraint(equalTo: qUserCover.centerYAnchor).isActive = true
//                qUserPhoto.contentMode = .scaleAspectFill
//                qUserPhoto.layer.masksToBounds = true
//                qUserPhoto.layer.cornerRadius = 14
//                let quoteImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                qUserPhoto.sd_setImage(with: quoteImageUrl)
//                qUserPhoto.backgroundColor = .ddmDarkGreyColor
//
//                let qGridNameText = UILabel()
//                qGridNameText.textAlignment = .left
//                qGridNameText.textColor = .white
//                qGridNameText.font = .boldSystemFont(ofSize: 13)
//                aQPost.addSubview(qGridNameText)
//                qGridNameText.translatesAutoresizingMaskIntoConstraints = false
//                qGridNameText.centerYAnchor.constraint(equalTo: qUserPhoto.centerYAnchor).isActive = true
//                qGridNameText.leadingAnchor.constraint(equalTo: qUserPhoto.trailingAnchor, constant: 10).isActive = true
//                qGridNameText.text = "Maryland Jen"
//
//                let qText = UILabel()
//                qText.textAlignment = .left
//                qText.textColor = .white
//                qText.font = .systemFont(ofSize: 13)
//                qText.numberOfLines = 0
//                aQPost.addSubview(qText)
//                qText.translatesAutoresizingMaskIntoConstraints = false
//                qText.topAnchor.constraint(equalTo: qUserPhoto.bottomAnchor, constant: 10).isActive = true
//                qText.leadingAnchor.constraint(equalTo: qUserPhoto.leadingAnchor, constant: 0).isActive = true
//                qText.trailingAnchor.constraint(equalTo: aQPost.trailingAnchor, constant: -20).isActive = true
//                qText.bottomAnchor.constraint(equalTo: aQPost.bottomAnchor, constant: -20).isActive = true
//                qText.text = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
//            }
//        }
//        
//        //test > for comment chaining
////        let dataCh = data.chainDataArray
//        let dataCh = data.xChainDataArray
//        var countCh = 0
//        for l in dataCh {
//            let aCPost = UIView()
////                aCPost.backgroundColor = .ddmDarkColor //.ddmDarkColor
//            aTest2.addSubview(aCPost)
//            aCPost.translatesAutoresizingMaskIntoConstraints = false
//            aCPost.leadingAnchor.constraint(equalTo: aTest2.leadingAnchor, constant: 0).isActive = true
//            aCPost.trailingAnchor.constraint(equalTo: aTest2.trailingAnchor, constant: 0).isActive = true //-30
////                aCPost.topAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
//            if(aTest2Array.isEmpty) {
//                aCPost.topAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
//            } else {
//                let lastArrayE = aTest2Array[aTest2Array.count - 1]
//                aCPost.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 0).isActive = true //20
//            }
//            aTest2Array.append(aCPost)
//            
//            //test > use custom cell method for chaining comment
//            let cell = CommentChainCell(frame: CGRect(x: 0 , y: 0, width: 100, height: 100))
//            aCPost.addSubview(cell)
//            cell.translatesAutoresizingMaskIntoConstraints = false
//            cell.trailingAnchor.constraint(equalTo: aCPost.trailingAnchor, constant: 0).isActive = true
//            cell.leadingAnchor.constraint(equalTo: aCPost.leadingAnchor, constant: 0).isActive = true
//            cell.topAnchor.constraint(equalTo: aCPost.topAnchor, constant: 0).isActive = true
//            cell.bottomAnchor.constraint(equalTo: aCPost.bottomAnchor, constant: 0).isActive = true
//            cell.redrawUI()
//            cell.aDelegate = self
//            cell.configure(data: l)
//            
//            if(countCh == dataCh.count - 1) {
//                cell.hideConnector()
//            }
//            
//            countCh += 1
//        }
//        
//        if(!dataCh.isEmpty){
////        if(dataCh.contains("c")) {
//            aConnector.isHidden = false
//        }
//        
//        if(!aTestArray.isEmpty) {
//            let lastArrayE = aTestArray[aTestArray.count - 1]
//            lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
//        }
//        
//        if(!aTest2Array.isEmpty) {
//            let lastArrayE = aTest2Array[aTest2Array.count - 1]
//            lastArrayE.bottomAnchor.constraint(equalTo: aTest2.bottomAnchor, constant: 0).isActive = true
//        }
//        
//        //populate data count
//        let dataC = data.dataCount
//        if let loveC = dataC["love"] {
//            bText.text = String(loveC)
//        }
//        if let commentC = dataC["comment"] {
//            cText.text = String(commentC)
//        }
//        if let bookmarkC = dataC["bookmark"] {
//            dText.text = String(bookmarkC)
//        }
//        if let shareC = dataC["share"] {
//            eText.text = String(shareC)
//        }
//    }
//    
//    @objc func onCommentClicked(gesture: UITapGestureRecognizer) {
//        aDelegate?.hListDidClickVcvComment(vc: self)
//    }
//    
//    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
//        aDelegate?.hListDidClickVcvClickUser()
//    }
//    @objc func onSingleClicked(gesture: UITapGestureRecognizer) {
//        print("comment single clicked")
//        aDelegate?.hListDidClickVcvClickPost()
//    }
//    @objc func onDoubleClicked(gesture: UITapGestureRecognizer) {
//        print("comment double clicked")
//        let aColor = bMiniBtn.tintColor
//        if(aColor == .white) {
//            reactOnLoveClick()
//            
//            let translation = gesture.location(in: self)
//            let x = translation.x
//            let y = translation.y
//            
//            let bigLove = UIImageView(frame: CGRect(x: x - 10.0, y: y - 10.0, width: 20, height: 20))
//            bigLove.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
//            bigLove.tintColor = .red
//            contentView.addSubview(bigLove)
//            
//            UIView.animate(withDuration: 0.3, animations: {
//                bigLove.frame = CGRect(x: x - 20.0, y: y - 20.0, width: 40, height: 40)
//            }, completion: { _ in
//    //            bigLove.removeFromSuperview()
//                UIView.animate(withDuration: 0.2, animations: {
//                    bigLove.frame = CGRect(x: x - 5.0, y: y - 5.0, width: 10, height: 10)
//                }, completion: { _ in
//                    bigLove.removeFromSuperview()
//                })
//            })
//        }
//    }
//    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
//        print("comment photo clicked")
//        if(!photoConArray.isEmpty) {
//            let pContainer = photoConArray[0]
//            let pFrame = pContainer.frame.origin
//            let aTestFrame = aTest.frame.origin
//            
//            let pointX = pFrame.x + aTestFrame.x
//            let pointY = pFrame.y + aTestFrame.y
//            aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX, pointY: pointY, view: pContainer, mode: PhotoTypes.P_0)
//            
//            //test > hide photo
//            hideCell(view: pContainer)
//        }
//    }
//    @objc func onQuotePostClicked(gesture: UITapGestureRecognizer) {
//        print("comment quote clicked")
//    }
//    @objc func onLoveClicked(gesture: UITapGestureRecognizer) {
//        reactOnLoveClick()
//    }
//    @objc func onBookmarkClicked(gesture: UITapGestureRecognizer) {
//        reactOnBookmarkClick()
//    }
//    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
//        print("comment share clicked")
//        aDelegate?.hListDidClickVcvShare(vc: self)
//    }
//    @objc func onVideoBtnClicked(gesture: UITapGestureRecognizer) {
//        if(vidPlayStatus == "play") {
//            pauseVideo()
//        } else {
//            resumeVideo()
//        }
//    }
//    @objc func onVideoClicked(gesture: UITapGestureRecognizer) {
//        print("post video clicked")
//        
//        if(!vidConArray.isEmpty) {
//            let vContainer = vidConArray[0]
//            let vFrame = vContainer.frame.origin
//            let aTestFrame = aTest.frame.origin
//            
//            let pointX = vFrame.x + aTestFrame.x
//            let pointY = vFrame.y + aTestFrame.y
//            aDelegate?.hListDidClickVcvClickVideo(vc: self, pointX: pointX, pointY: pointY, view: vContainer, mode: VideoTypes.V_0)
//            
//            //test > hide video
//            hideCell(view: vContainer)
//        }
//    }
//    @objc func onVideoLClicked(gesture: UITapGestureRecognizer) {
//        print("post video loop clicked")
//        
//        if(!vidConArray.isEmpty) {
//            let vContainer = vidConArray[0]
//            let vFrame = vContainer.frame.origin
//            let aTestFrame = aTest.frame.origin
//            
//            let pointX = vFrame.x + aTestFrame.x
//            let pointY = vFrame.y + aTestFrame.y
//            aDelegate?.hListDidClickVcvClickVideo(vc: self, pointX: pointX, pointY: pointY, view: vContainer, mode: VideoTypes.V_LOOP)
//            
//            //test > hide video
//            hideCell(view: vContainer)
//        }
//    }
//    
//    //test* > hide & dehide cells
//    func dehideCell() {
//        print("dehidecell hpostA: \(hideConArray)")
//        if(!hideConArray.isEmpty) {
//            let view = hideConArray[0]
//            view.isHidden = false
//            
//            hideConArray.removeAll()
//        }
//    }
//        
//    func hideCell(view: UIView) {
//        view.isHidden = true
//        hideConArray.append(view)
//    }
//    //*
//    
//    func reactOnLoveClick() {
//        let aColor = bMiniBtn.tintColor
//        if(aColor == .white) {
//            bMiniBtn.tintColor = .red
//        } else {
//            bMiniBtn.tintColor = .white
//        }
//    }
//    func reactOnBookmarkClick() {
//        let aColor = dMiniBtn.tintColor
//        if(aColor == .white) {
//            dMiniBtn.tintColor = .ddmGoldenYellowColor
//        } else {
//            dMiniBtn.tintColor = .white
//        }
//    }
//    
//    //for video play
//    var timeObserverTokenVideo: Any?
//    func addTimeObserverVideo() {
//        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
//        
//        //test > new method
//        if let tokenV = timeObserverTokenVideo {
//            //check if token exists
//        } else {
//            timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
//                [weak self] time in
//
//                let currentT = time.seconds
//                guard let s = self else {
//                    return
//                }
//                print("hpl time observe videoT:\(currentT)")
////                s.t_s = currentT
//                s.aDelegate?.hListVideoStopTime(vc: s, ts: currentT)
//            }
//        }
//    }
//    func removeTimeObserverVideo() {
//        //remove video observer
//        if let tokenV = timeObserverTokenVideo {
//            player?.removeTimeObserver(tokenV)
//            timeObserverTokenVideo = nil
//        }
//        
//        //test > for looping
////        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//        if(player != nil && player.currentItem != nil) {
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//        }
//    }
//    @objc func playerDidFinishPlaying(_ notification: Notification) {
//        playVideo()
//    }
//    
//    var vidPlayStatus = ""
//    func playVideo() {
//        player?.seek(to: .zero)
//        player?.play()
//
//        reactOnPlayStatus(status: "play")
//    }
//    func stopVideo() {
//        player?.seek(to: .zero)
//        player?.pause()
//
//        reactOnPlayStatus(status: "pause")
//    }
//    
//    func pauseVideo() {
//        player?.pause()
//
//        reactOnPlayStatus(status: "pause")
//    }
//    
//    func resumeVideo() {
//        player?.play()
//
//        reactOnPlayStatus(status: "play")
//    }
//    func reactOnPlayStatus(status: String) {
//        vidPlayStatus = status
//        if(status == "play") {
//            if(!playBtnArray.isEmpty) {
//                let playBtn = playBtnArray[0]
//                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
//            }
//        } else {
//            if(!playBtnArray.isEmpty) {
//                let playBtn = playBtnArray[0]
//                playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//            }
//        }
//    }
//    func seekToV() {
//        let t = 3.4
//        let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//        player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//    }
//}
//
//extension HCommentListViewCell: CChainCellDelegate {
//    func cChainDidClickComment() {
//
//    }
//    func cChainDidClickLove(){}
//    func cChainDidClickShare(){
//        
//    }
//    func cChainDidClickClickUser(){
//        aDelegate?.hListDidClickVcvClickUser()
//    }
//    func cChainDidClickClickPlace(){}
//    func cChainDidClickClickSound(){}
//    func cChainDidClickClickPost(){
//        aDelegate?.hListDidClickVcvClickPost()
//    }
//    func cChainDidClickClickPhoto(cell: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
//        
//    }
//    func cChainDidClickClickVideo(cell: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
//        
//    }
//    func cChainIsScrollCarousel(isScroll: Bool){}
//    
//    //test > carousel photo scroll page
//    func cChainCarouselIdx(cell: UIView, idx: Int){}
//    
//    //test > click play sound
//    func cChainDidClickPlayAudio(cell: UIView){}
//}
