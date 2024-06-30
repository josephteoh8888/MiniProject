//
//  HPostListAViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol HListCellDelegate : AnyObject {
    func hListDidClickVcvComment()
    func hListDidClickVcvLove()
    func hListDidClickVcvShare()
    func hListDidClickVcvClickUser()
    func hListDidClickVcvClickPlace()
    func hListDidClickVcvClickSound()
    func hListDidClickVcvClickPost()
    func hListDidClickVcvClickPhoto(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func hListDidClickVcvClickVideo(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func hListDidClickVcvSortComment()
    func hListIsScrollCarousel(isScroll: Bool)
    
    //test > carousel photo scroll page
    func hListCarouselIdx(vc: UICollectionViewCell, idx: Int)
    
    //test > click play sound
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell)
}

//test > horizontal list viewcell for posts
class HPostListAViewCell: UICollectionViewCell {
    static let identifier = "HPostListStandardViewCell"
    var gifImage = SDAnimatedImageView()
    
    let bMiniBtn = UIImageView()
    let dMiniBtn = UIImageView()
    let aGridNameText = UILabel()
    let aText = UILabel()
    var gifImage1 = SDAnimatedImageView()
    
    weak var aDelegate : HListCellDelegate?
    
    //test > dynamic method for various cells format
    let aTest = UIView()
    let aTest2 = UIView()
    var aTestArray = [UIView]()
    var aTest2Array = [UIView]()
    
    //test > video player
    var player: AVPlayer!
//    var playerLooper: AVPlayerLooper!
//    var player: AVQueuePlayer!
    
    //test > for video container intersection as user scrolls to play/pause
    var vidConArray = [UIView]()
    var playBtnArray = [UIImageView]()
    var photoConArray = [UIView]()
    var bubbleArray = [PageBubbleIndicator]()
    
    var t_s = 0.0 //for video pause/resume time
    var p_s = 0 //for photo carousel last viewed photo
    
    let bText = UILabel()
    let cText = UILabel()
    let dText = UILabel()
    let eText = UILabel()
    
    var hideConArray = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        contentView.backgroundColor = .black
        contentView.clipsToBounds = true

        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {

        //test > result vertical panel layout
        let aResult = UIView()
        aResult.backgroundColor = .ddmDarkColor
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
        aResult.layer.opacity = 0.1 //0.3
//        aResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
        
        //test > added double tap for love click shortcut
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
//        atapGR.numberOfTapsRequired = 1
//        aResult.addGestureRecognizer(atapGR)
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
//        tapGR.numberOfTapsRequired = 2
//        aResult.addGestureRecognizer(tapGR)
//        atapGR.require(toFail: tapGR) //enable double tap
        //////////////////
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
        contentView.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 20).isActive = true //10
        eUserCover.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true //20
        eUserCover.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.layer.cornerRadius = 20
        eUserCover.layer.opacity = 1.0 //default 0.3
        
        let aUserPhoto = SDAnimatedImageView()
        contentView.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 40).isActive = true //36
        aUserPhoto.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 20
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkGreyColor
        aUserPhoto.isUserInteractionEnabled = true
        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))

//        let aGridNameText = UILabel()
        aGridNameText.textAlignment = .left
        aGridNameText.textColor = .white
        aGridNameText.font = .boldSystemFont(ofSize: 14)
//        aGridNameText.font = .systemFont(ofSize: 14)
        contentView.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
//        aGridNameText.centerYAnchor.constraint(equalTo: aUserPhoto.centerYAnchor).isActive = true
        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
//        aGridNameText.text = "Mic1809"
//        aGridNameText.text = "Michael Kins"
        aGridNameText.text = "-"
        
        //test > verified badge
        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .ddmGoldenYellowColor
//        vBtn.tintColor = .white //darkGray
        contentView.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aGridNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aGridNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        //
        
        let aUserNameText = UILabel()
        aUserNameText.textAlignment = .left
        aUserNameText.textColor = .white
        aUserNameText.font = .systemFont(ofSize: 12)
        contentView.addSubview(aUserNameText)
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.topAnchor.constraint(equalTo: aGridNameText.bottomAnchor).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
        aUserNameText.text = "3hr . 1.2m views"
//        aUserNameText.text = "@mic1809"
        aUserNameText.layer.opacity = 0.3 //0.5
        
//        let aTest = UIView()
        contentView.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
        //test > click on aTest for click post
//        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
        
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
        atapGR.numberOfTapsRequired = 1
        aTest.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
        tapGR.numberOfTapsRequired = 2
        aTest.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR) //enable double tap
        
        //test 2 > design location 2
        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmDarkColor
        contentView.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
//        aBox.leadingAnchor.constraint(equalTo: aText.leadingAnchor, constant: 0).isActive = true
        aBox.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
//        aBox.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 20).isActive = true
//        aBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
//        aBox.topAnchor.constraint(equalTo: aQuotePost.bottomAnchor, constant: 20).isActive = true
        aBox.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true
        aBox.layer.cornerRadius = 5
        aBox.layer.opacity = 0.2 //0.3
        aBox.isUserInteractionEnabled = true
        aBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))

        let bBox = UIView()
        bBox.backgroundColor = .clear //yellow
        contentView.addSubview(bBox)
        bBox.clipsToBounds = true
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 16).isActive = true //ori: 40
        bBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        bBox.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        bBox.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 5).isActive = true //10
        bBox.layer.cornerRadius = 5 //6

        let gridViewBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
//        let gridViewBtn = UIImageView(image: UIImage(named:"icon_round_location")?.withRenderingMode(.alwaysTemplate))
//        gridViewBtn.tintColor = .black
        gridViewBtn.tintColor = .white
        bBox.addSubview(gridViewBtn)
        gridViewBtn.translatesAutoresizingMaskIntoConstraints = false
        gridViewBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        gridViewBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        gridViewBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        gridViewBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        gridViewBtn.layer.opacity = 0.5

        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        aaText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
        contentView.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        aaText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        aaText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        aaText.text = "Petronas Twin Tower"
//        aaText.layer.opacity = 0.5
        
        //test > post performance count metrics
        let bMini = UIView()
        bMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
//        bMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
//        bMini.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 30).isActive = true
        bMini.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 10).isActive = true
//        bMini.leadingAnchor.constraint(equalTo: aText.leadingAnchor, constant: 0).isActive = true
        bMini.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        bMini.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        bMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bMini.layer.cornerRadius = 15
        bMini.layer.opacity = 0.4 //0.2
//        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        bMiniBtn.tintColor = .white
//        bMiniBtn.tintColor = .red
        contentView.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //16
        bMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
        bMiniBtn.isUserInteractionEnabled = true
//        bMiniBtn.layer.opacity = 0.5
        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.leadingAnchor.constraint(equalTo: bMini.trailingAnchor, constant: 2).isActive = true
        bText.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bText.text = "-"
//        bText.layer.opacity = 0.5
        
        let cMini = UIView()
        cMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
//        cMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        cMini.topAnchor.constraint(equalTo: bMini.topAnchor, constant: 0).isActive = true
        cMini.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
        cMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cMini.layer.cornerRadius = 15
        cMini.layer.opacity = 0.4 //0.2
//        cMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
//        cMiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
        cMiniBtn.tintColor = .white
        contentView.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        cMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true //16
        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.layer.opacity = 0.5
        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
//        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.leadingAnchor.constraint(equalTo: cMini.trailingAnchor, constant: 2).isActive = true
        cText.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cText.text = "-"
//        cText.layer.opacity = 0.5
        
        let dMini = UIView()
        dMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
//        dMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        dMini.topAnchor.constraint(equalTo: cMini.topAnchor, constant: 0).isActive = true
        dMini.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
        dMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dMini.layer.cornerRadius = 15
        dMini.layer.opacity = 0.4 //0.2
//        dMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat_on")?.withRenderingMode(.alwaysTemplate))
        dMiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
        dMiniBtn.tintColor = .white
//        dMiniBtn.tintColor = .ddmGoldenYellowColor
        contentView.addSubview(dMiniBtn)
        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //16
        dMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
        dMiniBtn.isUserInteractionEnabled = true
//        dMiniBtn.layer.opacity = 0.5
        dMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
//        let dText = UILabel()
        dText.textAlignment = .left
        dText.textColor = .white
        dText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(dText)
        dText.clipsToBounds = true
        dText.translatesAutoresizingMaskIntoConstraints = false
        dText.leadingAnchor.constraint(equalTo: dMini.trailingAnchor, constant: 2).isActive = true
        dText.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dText.text = "-"
//        dText.layer.opacity = 0.5
        
        let eMini = UIView()
        eMini.backgroundColor = .ddmDarkColor
//        eMini.backgroundColor = .green
        contentView.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
//        eMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        eMini.topAnchor.constraint(equalTo: dMini.topAnchor, constant: 0).isActive = true
        eMini.leadingAnchor.constraint(equalTo: dText.trailingAnchor, constant: 20).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        eMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        eMini.layer.cornerRadius = 15
        eMini.layer.opacity = 0.4 //0.2
//        eMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
//        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate))
        eMiniBtn.tintColor = .white
//        eMiniBtn.tintColor = .green
        contentView.addSubview(eMiniBtn)
        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        eMiniBtn.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eMiniBtn.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: -2).isActive = true //-2
        eMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //22
        eMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        eMiniBtn.isUserInteractionEnabled = true
//        eMiniBtn.layer.opacity = 0.5
        eMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
//        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate))
//        eMiniBtn.tintColor = .green
//        contentView.addSubview(eMiniBtn)
//        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        eMiniBtn.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
//        eMiniBtn.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: 0).isActive = true //-2
//        eMiniBtn.heightAnchor.constraint(equalToConstant: 19).isActive = true //22
//        eMiniBtn.widthAnchor.constraint(equalToConstant: 19).isActive = true
//        eMiniBtn.isUserInteractionEnabled = true
//        eMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
//        let eText = UILabel()
        eText.textAlignment = .left
        eText.textColor = .white
        eText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(eText)
        eText.clipsToBounds = true
        eText.translatesAutoresizingMaskIntoConstraints = false
        eText.leadingAnchor.constraint(equalTo: eMini.trailingAnchor, constant: 2).isActive = true
        eText.centerYAnchor.constraint(equalTo: eMini.centerYAnchor).isActive = true
        eText.text = "-"
//        eText.layer.opacity = 0.5
        
        //test > dynamic cell for comment
        contentView.addSubview(aTest2)
        aTest2.translatesAutoresizingMaskIntoConstraints = false
        aTest2.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest2.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
        aTest2.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 0).isActive = true
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("sfvideo prepare for reuse")
//        print("postvc prepare for reuse \(player), \(timeObserverTokenVideo)")
        
        removeTimeObserverVideo()
        
        //**test > deallocate avplayer
//        playerLooper = nil
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        
        vidConArray.removeAll()
        playBtnArray.removeAll()
        bubbleArray.removeAll()
        photoConArray.removeAll()
        hideConArray.removeAll()
        //**
        
        aGridNameText.text = "-"
//        aText.text = "-"
        
        bText.text = "0"
        cText.text = "0"
        dText.text = "0"
        eText.text = "0"
        
        for e in aTestArray {
            e.removeFromSuperview()
        }
        aTestArray.removeAll()
        
        for e in aTest2Array {
            e.removeFromSuperview()
        }
        aTest2Array.removeAll()
        
        var gifUrl1 = URL(string: "")
        gifImage1.sd_setImage(with: gifUrl1)
    }
    
//    func configure(data: String) {
//        aGridNameText.text = "Michael Kins"
//        aText.text = data
//
//        var gifUrl1 = URL(string: "")
//        if(data == "Nice food, nice environment! Worth a visit. \n\nSo Good.") {
//            gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        } else {
//            gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        }
//        gifImage1.sd_setImage(with: gifUrl1)
//    }
    func configure(data: PostData) {
        aGridNameText.text = "Michael Kins"
        
//        let attributedText = NSMutableAttributedString(string: "Michael ")
////        let linkText = "www.example.com"
//        let linkText = "#Tesla"
//        let linkRange = NSRange(location: attributedText.length, length: linkText.count)
//        let linkAttributes: [NSAttributedString.Key: Any] = [
////            .link: URL(string: linkText)!,
//            .foregroundColor: UIColor.yellow, //UIColor.blue
//            .font: UIFont.boldSystemFont(ofSize: 14)
////            .underlineStyle: NSUnderlineStyle.single.rawValue //underline
//        ]
//        attributedText.append(NSAttributedString(string: linkText, attributes: linkAttributes))
//        aGridNameText.attributedText = attributedText
        
        //test > dynamic create ui for various data types in sequence
        let dataL = data.dataArray
        for l in dataL {
            if(l == "t") {
                let aaText = UILabel()
                aaText.textAlignment = .left
                aaText.textColor = .white
                aaText.font = .systemFont(ofSize: 14)
                aaText.numberOfLines = 0
                aTest.addSubview(aaText)
                aaText.translatesAutoresizingMaskIntoConstraints = false
                if(aTestArray.isEmpty) {
                    aaText.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    aaText.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                aaText.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
                aaText.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
//                aaText.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
                aaText.text = data.dataTextString
                aTestArray.append(aaText)
            }
            else if(l == "p") {
                //carousel of images
                let scrollView = UIScrollView()
                aTest.addSubview(scrollView)
                scrollView.backgroundColor = .clear
                scrollView.translatesAutoresizingMaskIntoConstraints = false
//                scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                if(aTestArray.isEmpty) {
                    scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    scrollView.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true //0
//                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
                scrollView.widthAnchor.constraint(equalToConstant: 370).isActive = true  //280
                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.alwaysBounceHorizontal = true
                scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
        //        scrollView.contentSize = CGSize(width: 360, height: 280)
                scrollView.isPagingEnabled = true //false
                scrollView.delegate = self
                scrollView.layer.cornerRadius = 10 //5
                aTestArray.append(scrollView)
                photoConArray.append(scrollView)

//                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
//            https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg
                
                var gifImage1 = SDAnimatedImageView()
                gifImage1.contentMode = .scaleAspectFill
                gifImage1.clipsToBounds = true
                gifImage1.sd_setImage(with: gifUrl)
//                gifImage1.layer.cornerRadius = 10 //5
                scrollView.addSubview(gifImage1)
                gifImage1.translatesAutoresizingMaskIntoConstraints = false
                gifImage1.widthAnchor.constraint(equalToConstant: 370).isActive = true //180
                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //280
                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                //test > click on photo
                gifImage1.isUserInteractionEnabled = true
                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20

                var gifImage2 = SDAnimatedImageView()
                gifImage2.contentMode = .scaleAspectFill
                gifImage2.clipsToBounds = true
                gifImage2.sd_setImage(with: gifUrl)
//                gifImage2.layer.cornerRadius = 10 //5
                scrollView.addSubview(gifImage2)
                gifImage2.translatesAutoresizingMaskIntoConstraints = false
                gifImage2.widthAnchor.constraint(equalToConstant: 370).isActive = true //180
                gifImage2.heightAnchor.constraint(equalToConstant: 280).isActive = true //280
                gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 0).isActive = true //10
                
                //test > add bubble
                let dataCount = 2
                let p = data.p_s
                if(dataCount > 1) {
                    let bubbleBox = PageBubbleIndicator()
                    bubbleBox.backgroundColor = .clear
                    aTest.addSubview(bubbleBox)
                    bubbleBox.translatesAutoresizingMaskIntoConstraints = false
//                    bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
                    bubbleBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
                    bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
                    bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
    //                bubbleBox.isHidden = true
                    bubbleBox.setConfiguration(number: dataCount, color: .yellow)
//                    bubbleBox.setIndicatorSelected(index: 0)
                    bubbleBox.setIndicatorSelected(index: p) //revert to last viewed photo in carousel
                    aTestArray.append(bubbleBox)
                    
                    bubbleArray.append(bubbleBox)
                }
                
                //revert to last viewed photo in carousel
                let xOffset = CGFloat(p) * 370
                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
            }
            else if(l == "p_s") {
                //test > loop cover
                let pConBg = UIView()
                pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
                aTest.addSubview(pConBg)
                pConBg.frame = CGRect(x: 0, y: 0, width: 370, height: 320)
                pConBg.translatesAutoresizingMaskIntoConstraints = false
                pConBg.widthAnchor.constraint(equalToConstant: 370).isActive = true //150, 370
                pConBg.heightAnchor.constraint(equalToConstant: 320).isActive = true //250, 280
                if(aTestArray.isEmpty) {
                    pConBg.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    pConBg.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                pConBg.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
                pConBg.layer.cornerRadius = 10
                pConBg.layer.opacity = 0.4 //0.2
                aTestArray.append(pConBg)
                
                //carousel of images
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
//                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true //0
////                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
//                scrollView.widthAnchor.constraint(equalToConstant: 370).isActive = true  //280
//                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
//                scrollView.showsHorizontalScrollIndicator = false
//                scrollView.alwaysBounceHorizontal = true
//                scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
//        //        scrollView.contentSize = CGSize(width: 360, height: 280)
//                scrollView.isPagingEnabled = true //false
//                scrollView.delegate = self
//                scrollView.layer.cornerRadius = 10 //5
//                aTestArray.append(scrollView)
                
                let scrollView = UIScrollView()
                aTest.addSubview(scrollView)
                scrollView.backgroundColor = .clear
                scrollView.translatesAutoresizingMaskIntoConstraints = false
                scrollView.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
                scrollView.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true //0
//                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
                scrollView.widthAnchor.constraint(equalToConstant: 370).isActive = true  //280
                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.alwaysBounceHorizontal = true
                scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
        //        scrollView.contentSize = CGSize(width: 360, height: 280)
                scrollView.isPagingEnabled = true //false
                scrollView.delegate = self
                scrollView.layer.cornerRadius = 10 //5
                scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//                scrollView.clipsToBounds = true
//                scrollView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
                aTestArray.append(scrollView)
                photoConArray.append(scrollView)

//                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//            https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg
                
                var gifImage1 = SDAnimatedImageView()
                gifImage1.contentMode = .scaleAspectFill
                gifImage1.clipsToBounds = true
                gifImage1.sd_setImage(with: gifUrl)
//                gifImage1.layer.cornerRadius = 10 //5
                scrollView.addSubview(gifImage1)
                gifImage1.translatesAutoresizingMaskIntoConstraints = false
                gifImage1.widthAnchor.constraint(equalToConstant: 370).isActive = true //180
                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //280
                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                //test > click on photo
                gifImage1.isUserInteractionEnabled = true
                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoSClicked)))//20

                var gifImage2 = SDAnimatedImageView()
                gifImage2.contentMode = .scaleAspectFill
                gifImage2.clipsToBounds = true
                gifImage2.sd_setImage(with: gifUrl)
//                gifImage2.layer.cornerRadius = 10 //5
                scrollView.addSubview(gifImage2)
                gifImage2.translatesAutoresizingMaskIntoConstraints = false
                gifImage2.widthAnchor.constraint(equalToConstant: 370).isActive = true //180
                gifImage2.heightAnchor.constraint(equalToConstant: 280).isActive = true //280
                gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 0).isActive = true //10
                
                //test > add "shot" label
                let label = UIView()
                aTest.addSubview(label)
//                label.backgroundColor = .ddmDarkColor
                label.backgroundColor = .clear
                label.translatesAutoresizingMaskIntoConstraints = false
//                label.widthAnchor.constraint(equalToConstant: 80).isActive = true //80
                label.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
                label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
//                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5).isActive = true
                label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5).isActive = true
//                label.layer.opacity = 0.5
                label.layer.cornerRadius = 5
                aTestArray.append(label)
                
                let labelBg = UIView()
                label.addSubview(labelBg)
                labelBg.backgroundColor = .ddmDarkColor
//                labelBg.backgroundColor = .white
                labelBg.translatesAutoresizingMaskIntoConstraints = false
                labelBg.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
                labelBg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0).isActive = true
                labelBg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
                labelBg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
//                labelBg.layer.opacity = 0.8 //0.5
                labelBg.layer.opacity = 0.3 //0.5
                labelBg.layer.cornerRadius = 5
                
                let e2UserCover = UIView()
                e2UserCover.backgroundColor = .clear
                label.addSubview(e2UserCover)
                e2UserCover.translatesAutoresizingMaskIntoConstraints = false
//                e2UserCover.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true //20
                e2UserCover.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
                e2UserCover.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
                e2UserCover.heightAnchor.constraint(equalToConstant: 20).isActive = true //28
                e2UserCover.widthAnchor.constraint(equalToConstant: 20).isActive = true //28
                e2UserCover.layer.cornerRadius = 10
                e2UserCover.layer.opacity = 1.0 //default 0.3

                let a2UserPhoto = SDAnimatedImageView()
                label.addSubview(a2UserPhoto)
                a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
                a2UserPhoto.widthAnchor.constraint(equalToConstant: 20).isActive = true //36
                a2UserPhoto.heightAnchor.constraint(equalToConstant: 20).isActive = true
                a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
                a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
                a2UserPhoto.contentMode = .scaleAspectFill
                a2UserPhoto.layer.masksToBounds = true
                a2UserPhoto.layer.cornerRadius = 10
                let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                a2UserPhoto.sd_setImage(with: image2Url)
                a2UserPhoto.backgroundColor = .ddmDarkGreyColor
                
                let aGridNameText = UILabel()
                aGridNameText.textAlignment = .left
                aGridNameText.textColor = .white
//                aGridNameText.textColor = .ddmDarkColor
                aGridNameText.font = .boldSystemFont(ofSize: 12)
                label.addSubview(aGridNameText)
                aGridNameText.translatesAutoresizingMaskIntoConstraints = false
                aGridNameText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
                aGridNameText.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5).isActive = true
                aGridNameText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 5).isActive = true
                aGridNameText.text = "Shot"
//                aGridNameText.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
//                aGridNameText.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
                
                //test > add bubble
                let dataCount = 2
                let p = data.p_s
                if(dataCount > 1) {
                    let bubbleBox = PageBubbleIndicator()
                    bubbleBox.backgroundColor = .clear
                    aTest.addSubview(bubbleBox)
                    bubbleBox.translatesAutoresizingMaskIntoConstraints = false
//                    bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
                    bubbleBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
                    bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
                    bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
    //                bubbleBox.isHidden = true
                    bubbleBox.setConfiguration(number: dataCount, color: .yellow)
//                    bubbleBox.setIndicatorSelected(index: 0)
                    bubbleBox.setIndicatorSelected(index: p) //revert to last viewed photo in carousel
                    aTestArray.append(bubbleBox)
                    
                    bubbleArray.append(bubbleBox)
                }
                
                //revert to last viewed photo in carousel
                let xOffset = CGFloat(p) * 370
                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
                
                //test > shot description
                let pConBottom = UIView()
                pConBottom.frame = CGRect(x: 0, y: 0, width: 370, height: 40)
//                vConBottom.backgroundColor = .ddmDarkColor //.ddmDarkColor
                aTest.addSubview(pConBottom)
                pConBottom.translatesAutoresizingMaskIntoConstraints = false
                pConBottom.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 0).isActive = true
//                pConBottom.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
                pConBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
                pConBottom.widthAnchor.constraint(equalToConstant: 370).isActive = true
                pConBottom.bottomAnchor.constraint(equalTo: pConBg.bottomAnchor, constant: 0).isActive = true //0
                pConBottom.isUserInteractionEnabled = true
                pConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoSClicked)))
//                vConBottom.layer.cornerRadius = 10
                aTestArray.append(pConBottom)
                
                let moreBtn = UIImageView()
                moreBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
//                moreBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
                moreBtn.tintColor = .white
                pConBottom.addSubview(moreBtn)
                moreBtn.translatesAutoresizingMaskIntoConstraints = false
                moreBtn.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
                moreBtn.trailingAnchor.constraint(equalTo: pConBottom.trailingAnchor, constant: -5).isActive = true
                moreBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
                moreBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
                
                let aaText = UILabel()
                aaText.textAlignment = .left
                aaText.textColor = .white
                aaText.font = .systemFont(ofSize: 13)
                aaText.numberOfLines = 1
                pConBottom.addSubview(aaText)
                aaText.translatesAutoresizingMaskIntoConstraints = false
                aaText.centerYAnchor.constraint(equalTo: pConBottom.centerYAnchor, constant: 0).isActive = true
//                aaText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 10).isActive = true
                aaText.leadingAnchor.constraint(equalTo: pConBottom.leadingAnchor, constant: 10).isActive = true //5
                aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
                aaText.text = data.dataTextString
            }
            else if(l == "v_l") {//loop videos
                
                //test > loop cover
                let vConBg = UIView()
                vConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
                aTest.addSubview(vConBg)
                vConBg.frame = CGRect(x: 0, y: 0, width: 220, height: 390) //150, 250
                vConBg.translatesAutoresizingMaskIntoConstraints = false
                vConBg.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
                vConBg.heightAnchor.constraint(equalToConstant: 390).isActive = true //250, 280
                if(aTestArray.isEmpty) {
                    vConBg.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    vConBg.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                vConBg.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
                vConBg.layer.cornerRadius = 10
                vConBg.layer.opacity = 0.4 //0.2
                aTestArray.append(vConBg)
                
                //test 2 > with real video player
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
//                videoContainer.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
//                videoContainer.clipsToBounds = true
////                videoContainer.layer.cornerRadius = 10
//                videoContainer.backgroundColor = .black
//                videoContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//                videoContainer.isUserInteractionEnabled = true
//                videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
//                aTestArray.append(videoContainer)
                
                let videoContainer = UIView()
                videoContainer.frame = CGRect(x: 0, y: 0, width: 220, height: 350) //150, 250
                aTest.addSubview(videoContainer)
                videoContainer.translatesAutoresizingMaskIntoConstraints = false
                videoContainer.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
                videoContainer.heightAnchor.constraint(equalToConstant: 350).isActive = true //250, 280
                videoContainer.topAnchor.constraint(equalTo: vConBg.topAnchor, constant: 0).isActive = true
                videoContainer.leadingAnchor.constraint(equalTo: vConBg.leadingAnchor, constant: 0).isActive = true
                videoContainer.clipsToBounds = true
//                videoContainer.layer.cornerRadius = 10
                videoContainer.backgroundColor = .black
//                videoContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
                videoContainer.layer.cornerRadius = 10 //5
                videoContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                videoContainer.isUserInteractionEnabled = true
                videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
                aTestArray.append(videoContainer)
                
                vidConArray.append(videoContainer)
                
                //test > add "shot" label
                let label = UIView()
                aTest.addSubview(label)
//                label.backgroundColor = .ddmDarkColor
                label.backgroundColor = .clear
                label.translatesAutoresizingMaskIntoConstraints = false
//                label.widthAnchor.constraint(equalToConstant: 80).isActive = true //80
                label.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
                label.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 5).isActive = true
//                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5).isActive = true
                label.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
//                label.layer.opacity = 0.5
                label.layer.cornerRadius = 5
                aTestArray.append(label)
                
                let labelBg = UIView()
                label.addSubview(labelBg)
                labelBg.backgroundColor = .ddmDarkColor
//                labelBg.backgroundColor = .white
                labelBg.translatesAutoresizingMaskIntoConstraints = false
                labelBg.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
                labelBg.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 0).isActive = true
                labelBg.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
                labelBg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
//                labelBg.layer.opacity = 0.8 //0.5
                labelBg.layer.opacity = 0.3 //0.5
                labelBg.layer.cornerRadius = 5
                
                let e2UserCover = UIView()
                e2UserCover.backgroundColor = .clear
                label.addSubview(e2UserCover)
                e2UserCover.translatesAutoresizingMaskIntoConstraints = false
//                e2UserCover.topAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true //20
                e2UserCover.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
                e2UserCover.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
                e2UserCover.heightAnchor.constraint(equalToConstant: 20).isActive = true //28
                e2UserCover.widthAnchor.constraint(equalToConstant: 20).isActive = true //28
                e2UserCover.layer.cornerRadius = 10
                e2UserCover.layer.opacity = 1.0 //default 0.3

                let a2UserPhoto = SDAnimatedImageView()
                label.addSubview(a2UserPhoto)
                a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
                a2UserPhoto.widthAnchor.constraint(equalToConstant: 20).isActive = true //36
                a2UserPhoto.heightAnchor.constraint(equalToConstant: 20).isActive = true
                a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
                a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
                a2UserPhoto.contentMode = .scaleAspectFill
                a2UserPhoto.layer.masksToBounds = true
                a2UserPhoto.layer.cornerRadius = 10
                let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                a2UserPhoto.sd_setImage(with: image2Url)
                a2UserPhoto.backgroundColor = .ddmDarkGreyColor
                
                let aGridNameText = UILabel()
                aGridNameText.textAlignment = .left
                aGridNameText.textColor = .white
//                aGridNameText.textColor = .ddmDarkColor
                aGridNameText.font = .boldSystemFont(ofSize: 12)
                label.addSubview(aGridNameText)
                aGridNameText.translatesAutoresizingMaskIntoConstraints = false
                aGridNameText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
                aGridNameText.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5).isActive = true
                aGridNameText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 5).isActive = true
                aGridNameText.text = "Loop"
//                aGridNameText.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
//                aGridNameText.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5).isActive = true
                
                //test > play/pause btn
                let playBtn = UIImageView()
                playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
                playBtn.tintColor = .white
                aTest.addSubview(playBtn)
                playBtn.translatesAutoresizingMaskIntoConstraints = false
                playBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
                playBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
//                playBtn.leadingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
                playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
                playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
                playBtn.isUserInteractionEnabled = true
                playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
                aTestArray.append(playBtn)
                
                playBtnArray.append(playBtn)
                
                //test > sound on/off
                let soundOnBtn = UIImageView()
//                soundOnBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
                soundOnBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
                soundOnBtn.tintColor = .white
                aTest.addSubview(soundOnBtn)
                soundOnBtn.translatesAutoresizingMaskIntoConstraints = false
                soundOnBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
                soundOnBtn.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 5).isActive = true
                soundOnBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
                soundOnBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
                soundOnBtn.isUserInteractionEnabled = true
//                soundOnBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
                aTestArray.append(soundOnBtn)
                
                //video player
                let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
                let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
                
                //method 1
//                player = AVPlayer()
//                let playerView = AVPlayerLayer()
//                playerView.player = player
//                playerView.frame = videoContainer.bounds
//                playerView.videoGravity = .resizeAspectFill
//                videoContainer.layer.addSublayer(playerView)
//                let playerItem = AVPlayerItem(url: url)
//                player.replaceCurrentItem(with: playerItem)
////                player?.seek(to: .zero)
                
                //method 2
                if(player != nil && player.currentItem != nil) {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                }
                
                let item2 = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: item2)
                let layer2 = AVPlayerLayer(player: player)
                layer2.frame = videoContainer.bounds
                layer2.videoGravity = .resizeAspectFill
                videoContainer.layer.addSublayer(layer2)

                //test > resume to paused timestamp
                let t = data.t_s
                let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)

                //add timestamp video while playing
                addTimeObserverVideo()
                
                //test > for looping
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                
                //method 3 > loop
//                player = AVQueuePlayer()
//                let playerView = AVPlayerLayer(player: player)
//                let playerItem = AVPlayerItem(url: url)
//                playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
//                playerView.frame = videoContainer.bounds
//                playerView.videoGravity = .resizeAspectFill
//                videoContainer.layer.addSublayer(playerView)
//
//                let t = data.t_s
//                let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//                print("sfvideo configure $$ \(t), \(player)")
////                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//                player?.seek(to: seekTime)
//
//                addTimeObserverVideo()
                
                //test > loop description
                let vConBottom = UIView()
                vConBottom.frame = CGRect(x: 0, y: 0, width: 220, height: 40)
//                vConBottom.backgroundColor = .ddmDarkColor //.ddmDarkColor
                aTest.addSubview(vConBottom)
                vConBottom.translatesAutoresizingMaskIntoConstraints = false
                vConBottom.leadingAnchor.constraint(equalTo: vConBg.leadingAnchor, constant: 0).isActive = true
//                vConBottom.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
                vConBottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
                vConBottom.widthAnchor.constraint(equalToConstant: 220).isActive = true
                vConBottom.bottomAnchor.constraint(equalTo: vConBg.bottomAnchor, constant: 0).isActive = true //0
                vConBottom.isUserInteractionEnabled = true
                vConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoLClicked)))
//                vConBottom.layer.cornerRadius = 10
                aTestArray.append(vConBottom)
                
                let moreBtn = UIImageView()
                moreBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
//                moreBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
                moreBtn.tintColor = .white
                vConBottom.addSubview(moreBtn)
                moreBtn.translatesAutoresizingMaskIntoConstraints = false
                moreBtn.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
                moreBtn.trailingAnchor.constraint(equalTo: vConBottom.trailingAnchor, constant: -5).isActive = true
                moreBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
                moreBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
                
                let aaText = UILabel()
                aaText.textAlignment = .left
                aaText.textColor = .white
                aaText.font = .systemFont(ofSize: 13)
                aaText.numberOfLines = 1
                vConBottom.addSubview(aaText)
                aaText.translatesAutoresizingMaskIntoConstraints = false
                aaText.centerYAnchor.constraint(equalTo: vConBottom.centerYAnchor, constant: 0).isActive = true
//                aaText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 10).isActive = true
                aaText.leadingAnchor.constraint(equalTo: vConBottom.leadingAnchor, constant: 10).isActive = true //5
                aaText.trailingAnchor.constraint(equalTo: moreBtn.leadingAnchor, constant: -5).isActive = true //-30
                aaText.text = data.dataTextString
            }
            else if(l == "v") { //vi
                let videoContainer = UIView()
                videoContainer.frame = CGRect(x: 0, y: 0, width: 220, height: 350) //150, 250
                aTest.addSubview(videoContainer)
                videoContainer.translatesAutoresizingMaskIntoConstraints = false
                videoContainer.widthAnchor.constraint(equalToConstant: 220).isActive = true //150, 370
                videoContainer.heightAnchor.constraint(equalToConstant: 350).isActive = true //250, 280
                if(aTestArray.isEmpty) {
                    videoContainer.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    videoContainer.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                videoContainer.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
                videoContainer.clipsToBounds = true
                videoContainer.layer.cornerRadius = 10
                videoContainer.backgroundColor = .black
//                videoContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
                videoContainer.isUserInteractionEnabled = true
                videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoClicked)))
                aTestArray.append(videoContainer)
                
                vidConArray.append(videoContainer)
                
                //test > play/pause btn
                let playBtn = UIImageView()
                playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
                playBtn.tintColor = .white
                aTest.addSubview(playBtn)
                playBtn.translatesAutoresizingMaskIntoConstraints = false
                playBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
                playBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
//                playBtn.leadingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
                playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
                playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
                playBtn.isUserInteractionEnabled = true
                playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
                aTestArray.append(playBtn)
                
                playBtnArray.append(playBtn)
                
                //test > sound on/off
                let soundOnBtn = UIImageView()
//                soundOnBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
                soundOnBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
                soundOnBtn.tintColor = .white
                aTest.addSubview(soundOnBtn)
                soundOnBtn.translatesAutoresizingMaskIntoConstraints = false
                soundOnBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -5).isActive = true
                soundOnBtn.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 5).isActive = true
                soundOnBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //30, 26, 22
                soundOnBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
                soundOnBtn.isUserInteractionEnabled = true
//                soundOnBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoBtnClicked)))
                aTestArray.append(soundOnBtn)
                
                //video player
                let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
                let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
                
                if(player != nil && player.currentItem != nil) {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                }
                
                let item2 = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: item2)
                let layer2 = AVPlayerLayer(player: player)
                layer2.frame = videoContainer.bounds
                layer2.videoGravity = .resizeAspectFill
                videoContainer.layer.addSublayer(layer2)

                //test > resume to paused timestamp
                let t = data.t_s
                let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)

                //add timestamp video while playing
                addTimeObserverVideo()
                
                //test > for looping
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            }
            else if(l == "q") {
                let aQPost = UIView()
                aQPost.backgroundColor = .ddmDarkColor //.ddmDarkColor
                contentView.addSubview(aQPost)
                aQPost.translatesAutoresizingMaskIntoConstraints = false
                aQPost.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
                aQPost.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
//                aQPost.heightAnchor.constraint(equalToConstant: 120).isActive = true //120
//                aQPost.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
                if(aTestArray.isEmpty) {
                    aQPost.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    aQPost.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                aQPost.layer.cornerRadius = 10
                aTestArray.append(aQPost)
                //test > click on aTest for click post
                aQPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onQuotePostClicked)))
        
                let aQBG = UIView()
                aQBG.backgroundColor = .ddmBlackOverlayColor
//                aQBG.backgroundColor = .ddmDarkNewColor
                aQPost.addSubview(aQBG)
                aQBG.translatesAutoresizingMaskIntoConstraints = false
                aQBG.leadingAnchor.constraint(equalTo: aQPost.leadingAnchor, constant: 2).isActive = true
                aQBG.trailingAnchor.constraint(equalTo: aQPost.trailingAnchor, constant: -2).isActive = true
                aQBG.bottomAnchor.constraint(equalTo: aQPost.bottomAnchor, constant: -2).isActive = true
                aQBG.topAnchor.constraint(equalTo: aQPost.topAnchor, constant: 2).isActive = true
                aQBG.layer.cornerRadius = 10
                
                let aQBGa = UIView()
//                aQBGa.backgroundColor = .ddmBlackOverlayColor
                aQBGa.backgroundColor = .ddmDarkColor
                aQPost.addSubview(aQBGa)
                aQBGa.translatesAutoresizingMaskIntoConstraints = false
                aQBGa.leadingAnchor.constraint(equalTo: aQPost.leadingAnchor, constant: 2).isActive = true
                aQBGa.trailingAnchor.constraint(equalTo: aQPost.trailingAnchor, constant: -2).isActive = true
                aQBGa.bottomAnchor.constraint(equalTo: aQPost.bottomAnchor, constant: -2).isActive = true
                aQBGa.topAnchor.constraint(equalTo: aQPost.topAnchor, constant: 2).isActive = true
                aQBGa.layer.cornerRadius = 10
                aQBGa.layer.opacity = 0.1 //default 0.3
        
                let qUserCover = UIView()
                qUserCover.backgroundColor = .clear
                aQPost.addSubview(qUserCover)
                qUserCover.translatesAutoresizingMaskIntoConstraints = false
                qUserCover.topAnchor.constraint(equalTo: aQBG.topAnchor, constant: 10).isActive = true
                qUserCover.leadingAnchor.constraint(equalTo: aQBG.leadingAnchor, constant: 10).isActive = true //20
                qUserCover.heightAnchor.constraint(equalToConstant: 28).isActive = true
                qUserCover.widthAnchor.constraint(equalToConstant: 28).isActive = true
                qUserCover.layer.cornerRadius = 14
                qUserCover.layer.opacity = 1.0 //default 0.3
        
                let qUserPhoto = SDAnimatedImageView()
                aQPost.addSubview(qUserPhoto)
                qUserPhoto.translatesAutoresizingMaskIntoConstraints = false
                qUserPhoto.widthAnchor.constraint(equalToConstant: 28).isActive = true //24
                qUserPhoto.heightAnchor.constraint(equalToConstant: 28).isActive = true
                qUserPhoto.centerXAnchor.constraint(equalTo: qUserCover.centerXAnchor).isActive = true
                qUserPhoto.centerYAnchor.constraint(equalTo: qUserCover.centerYAnchor).isActive = true
                qUserPhoto.contentMode = .scaleAspectFill
                qUserPhoto.layer.masksToBounds = true
                qUserPhoto.layer.cornerRadius = 14
                let quoteImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                qUserPhoto.sd_setImage(with: quoteImageUrl)
                qUserPhoto.backgroundColor = .ddmDarkGreyColor
        
                let qGridNameText = UILabel()
                qGridNameText.textAlignment = .left
                qGridNameText.textColor = .white
                qGridNameText.font = .boldSystemFont(ofSize: 14)
                aQPost.addSubview(qGridNameText)
                qGridNameText.translatesAutoresizingMaskIntoConstraints = false
                qGridNameText.centerYAnchor.constraint(equalTo: qUserPhoto.centerYAnchor).isActive = true
                qGridNameText.leadingAnchor.constraint(equalTo: qUserPhoto.trailingAnchor, constant: 10).isActive = true
                qGridNameText.text = "Maryland Jen"
        
                let qText = UILabel()
                qText.textAlignment = .left
                qText.textColor = .white
                qText.font = .systemFont(ofSize: 14)
                qText.numberOfLines = 0
                aQPost.addSubview(qText)
                qText.translatesAutoresizingMaskIntoConstraints = false
                qText.topAnchor.constraint(equalTo: qUserPhoto.bottomAnchor, constant: 10).isActive = true
                qText.leadingAnchor.constraint(equalTo: qUserPhoto.leadingAnchor, constant: 0).isActive = true
                qText.trailingAnchor.constraint(equalTo: aQPost.trailingAnchor, constant: -20).isActive = true
                qText.bottomAnchor.constraint(equalTo: aQPost.bottomAnchor, constant: -20).isActive = true
                qText.text = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
            }
            else if(l == "c") {
                let aCPost = UIView()
//                aCPost.backgroundColor = .ddmDarkColor //.ddmDarkColor
                aTest2.addSubview(aCPost)
                aCPost.translatesAutoresizingMaskIntoConstraints = false
                aCPost.leadingAnchor.constraint(equalTo: aTest2.leadingAnchor, constant: 0).isActive = true
                aCPost.trailingAnchor.constraint(equalTo: aTest2.trailingAnchor, constant: 0).isActive = true //-30
//                aCPost.topAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
                if(aTest2Array.isEmpty) {
                    aCPost.topAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aTest2Array[aTest2Array.count - 1]
                    aCPost.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 0).isActive = true //20
                }
                aTest2Array.append(aCPost)
                aCPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
                
                let e2UserCover = UIView()
                e2UserCover.backgroundColor = .clear
                aCPost.addSubview(e2UserCover)
                e2UserCover.translatesAutoresizingMaskIntoConstraints = false
                e2UserCover.topAnchor.constraint(equalTo: aCPost.topAnchor, constant: 20).isActive = true //20
                e2UserCover.leadingAnchor.constraint(equalTo: aCPost.leadingAnchor, constant: 20).isActive = true
                e2UserCover.heightAnchor.constraint(equalToConstant: 28).isActive = true //40
                e2UserCover.widthAnchor.constraint(equalToConstant: 28).isActive = true //40
                e2UserCover.layer.cornerRadius = 14
                e2UserCover.layer.opacity = 1.0 //default 0.3
        
                let a2UserPhoto = SDAnimatedImageView()
                aCPost.addSubview(a2UserPhoto)
                a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
                a2UserPhoto.widthAnchor.constraint(equalToConstant: 28).isActive = true //36
                a2UserPhoto.heightAnchor.constraint(equalToConstant: 28).isActive = true
                a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
                a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
                a2UserPhoto.contentMode = .scaleAspectFill
                a2UserPhoto.layer.masksToBounds = true
                a2UserPhoto.layer.cornerRadius = 14
                let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                a2UserPhoto.sd_setImage(with: image2Url)
                a2UserPhoto.backgroundColor = .ddmDarkGreyColor
                a2UserPhoto.isUserInteractionEnabled = true
        //        a2UserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
                
                let a2GridNameText = UILabel()
                a2GridNameText.textAlignment = .left
                a2GridNameText.textColor = .white
                a2GridNameText.font = .boldSystemFont(ofSize: 13) //14
                aCPost.addSubview(a2GridNameText)
                a2GridNameText.translatesAutoresizingMaskIntoConstraints = false
                a2GridNameText.topAnchor.constraint(equalTo: a2UserPhoto.topAnchor).isActive = true
                a2GridNameText.leadingAnchor.constraint(equalTo: a2UserPhoto.trailingAnchor, constant: 10).isActive = true
        //        a2GridNameText.text = "Mic1809"
                a2GridNameText.text = "Michael Kins"
        //        a2GridNameText.text = "-"
                
                let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
        //        vBtn.tintColor = .yellow //ddmGoldenYellowColor
                vBtn.tintColor = .white //darkGray
                aCPost.addSubview(vBtn)
                vBtn.translatesAutoresizingMaskIntoConstraints = false
                vBtn.leadingAnchor.constraint(equalTo: a2GridNameText.trailingAnchor, constant: 5).isActive = true
                vBtn.centerYAnchor.constraint(equalTo: a2GridNameText.centerYAnchor, constant: 0).isActive = true
                vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
                vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
                let a2UserNameText = UILabel()
                a2UserNameText.textAlignment = .left
                a2UserNameText.textColor = .white
                a2UserNameText.font = .systemFont(ofSize: 12)
                aCPost.addSubview(a2UserNameText)
                a2UserNameText.translatesAutoresizingMaskIntoConstraints = false
                a2UserNameText.topAnchor.constraint(equalTo: a2GridNameText.bottomAnchor).isActive = true
                a2UserNameText.leadingAnchor.constraint(equalTo: a2GridNameText.leadingAnchor, constant: 0).isActive = true
                a2UserNameText.text = "2hr . 200k views"
        //        a2UserNameText.text = "@mic1809"
                a2UserNameText.layer.opacity = 0.3 //0.5
                
                let a2Text = UILabel()
                a2Text.textAlignment = .left
                a2Text.textColor = .white
                a2Text.font = .systemFont(ofSize: 14) //14 //13
                a2Text.numberOfLines = 0
                aCPost.addSubview(a2Text)
                a2Text.translatesAutoresizingMaskIntoConstraints = false
                a2Text.topAnchor.constraint(equalTo: a2UserPhoto.bottomAnchor, constant: 10).isActive = true
                a2Text.leadingAnchor.constraint(equalTo: a2GridNameText.leadingAnchor, constant: 0).isActive = true
                a2Text.trailingAnchor.constraint(equalTo: aCPost.trailingAnchor, constant: -20).isActive = true
                a2Text.text = "Worth a visit."
        //        a2Text.text = "-"
                
                let b2Mini = UIView()
                b2Mini.backgroundColor = .ddmDarkColor
                aCPost.addSubview(b2Mini)
                b2Mini.translatesAutoresizingMaskIntoConstraints = false
        //        b2Mini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        //        b2Mini.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 30).isActive = true
                b2Mini.topAnchor.constraint(equalTo: a2Text.bottomAnchor, constant: 10).isActive = true
                b2Mini.leadingAnchor.constraint(equalTo: a2Text.leadingAnchor, constant: 0).isActive = true
                b2Mini.bottomAnchor.constraint(equalTo: aCPost.bottomAnchor, constant: 0).isActive = true //-20
                b2Mini.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
                b2Mini.widthAnchor.constraint(equalToConstant: 26).isActive = true
                b2Mini.layer.cornerRadius = 13
                b2Mini.layer.opacity = 0.4 //0.2
        //        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
                let b2MiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        //        b2MiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
                b2MiniBtn.tintColor = .white
        //        b2MiniBtn.tintColor = .red
                aCPost.addSubview(b2MiniBtn)
                b2MiniBtn.translatesAutoresizingMaskIntoConstraints = false
                b2MiniBtn.centerXAnchor.constraint(equalTo: b2Mini.centerXAnchor).isActive = true
                b2MiniBtn.centerYAnchor.constraint(equalTo: b2Mini.centerYAnchor).isActive = true
                b2MiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
                b2MiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
                b2MiniBtn.isUserInteractionEnabled = true
        //        b2MiniBtn.layer.opacity = 0.5
        //        b2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
                let b2Text = UILabel()
                b2Text.textAlignment = .left
                b2Text.textColor = .white
                b2Text.font = .boldSystemFont(ofSize: 10)
                aCPost.addSubview(b2Text)
                b2Text.clipsToBounds = true
                b2Text.translatesAutoresizingMaskIntoConstraints = false
                b2Text.leadingAnchor.constraint(equalTo: b2Mini.trailingAnchor, constant: 2).isActive = true
                b2Text.centerYAnchor.constraint(equalTo: b2Mini.centerYAnchor).isActive = true
                b2Text.text = "478"
        //        b2Text.layer.opacity = 0.5
        
                let c2Mini = UIView()
                c2Mini.backgroundColor = .ddmDarkColor
                aCPost.addSubview(c2Mini)
                c2Mini.translatesAutoresizingMaskIntoConstraints = false
        //        c2Mini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
                c2Mini.topAnchor.constraint(equalTo: b2Mini.topAnchor, constant: 0).isActive = true
                c2Mini.leadingAnchor.constraint(equalTo: b2Text.trailingAnchor, constant: 20).isActive = true
                c2Mini.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
                c2Mini.widthAnchor.constraint(equalToConstant: 26).isActive = true
                c2Mini.layer.cornerRadius = 13
                c2Mini.layer.opacity = 0.4 //0.2
        //        c2Mini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
                let c2MiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
        //        c2MiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
                c2MiniBtn.tintColor = .white
                aCPost.addSubview(c2MiniBtn)
                c2MiniBtn.translatesAutoresizingMaskIntoConstraints = false
                c2MiniBtn.centerXAnchor.constraint(equalTo: c2Mini.centerXAnchor).isActive = true
                c2MiniBtn.centerYAnchor.constraint(equalTo: c2Mini.centerYAnchor).isActive = true
                c2MiniBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //16
                c2MiniBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //16
                c2MiniBtn.isUserInteractionEnabled = true
        //        c2MiniBtn.layer.opacity = 0.5
                c2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
                let c2Text = UILabel()
                c2Text.textAlignment = .left
                c2Text.textColor = .white
                c2Text.font = .boldSystemFont(ofSize: 10)
                aCPost.addSubview(c2Text)
                c2Text.clipsToBounds = true
                c2Text.translatesAutoresizingMaskIntoConstraints = false
                c2Text.leadingAnchor.constraint(equalTo: c2Mini.trailingAnchor, constant: 2).isActive = true
                c2Text.centerYAnchor.constraint(equalTo: c2Mini.centerYAnchor).isActive = true
                c2Text.text = "1309"
        //        c2Text.layer.opacity = 0.5
        
                let d2Mini = UIView()
                d2Mini.backgroundColor = .ddmDarkColor
                aCPost.addSubview(d2Mini)
                d2Mini.translatesAutoresizingMaskIntoConstraints = false
        //        d2Mini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
                d2Mini.topAnchor.constraint(equalTo: c2Mini.topAnchor, constant: 0).isActive = true
                d2Mini.leadingAnchor.constraint(equalTo: c2Text.trailingAnchor, constant: 20).isActive = true
                d2Mini.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
                d2Mini.widthAnchor.constraint(equalToConstant: 26).isActive = true
                d2Mini.layer.cornerRadius = 13
                d2Mini.layer.opacity = 0.4 //0.2
        //        d2Mini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
                let d2MiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
        //        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat_on")?.withRenderingMode(.alwaysTemplate))
        //        d2MiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
                d2MiniBtn.tintColor = .white
        //        d2MiniBtn.tintColor = .ddmGoldenYellowColor
                aCPost.addSubview(d2MiniBtn)
                d2MiniBtn.translatesAutoresizingMaskIntoConstraints = false
                d2MiniBtn.centerXAnchor.constraint(equalTo: d2Mini.centerXAnchor).isActive = true
                d2MiniBtn.centerYAnchor.constraint(equalTo: d2Mini.centerYAnchor).isActive = true
                d2MiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
                d2MiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
                d2MiniBtn.isUserInteractionEnabled = true
        //        d2MiniBtn.layer.opacity = 0.5
//                d2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
                let d2Text = UILabel()
                d2Text.textAlignment = .left
                d2Text.textColor = .white
                d2Text.font = .boldSystemFont(ofSize: 10)
                aCPost.addSubview(d2Text)
                d2Text.clipsToBounds = true
                d2Text.translatesAutoresizingMaskIntoConstraints = false
                d2Text.leadingAnchor.constraint(equalTo: d2Mini.trailingAnchor, constant: 2).isActive = true
                d2Text.centerYAnchor.constraint(equalTo: d2Mini.centerYAnchor).isActive = true
                d2Text.text = "512"
        //        d2Text.layer.opacity = 0.5
        
                let e2Mini = UIView()
                e2Mini.backgroundColor = .ddmDarkColor
        //        e2Mini.backgroundColor = .green
                aCPost.addSubview(e2Mini)
                e2Mini.translatesAutoresizingMaskIntoConstraints = false
        //        e2Mini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
                e2Mini.topAnchor.constraint(equalTo: d2Mini.topAnchor, constant: 0).isActive = true
                e2Mini.leadingAnchor.constraint(equalTo: d2Text.trailingAnchor, constant: 20).isActive = true
                e2Mini.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
                e2Mini.widthAnchor.constraint(equalToConstant: 26).isActive = true
                e2Mini.layer.cornerRadius = 13
                e2Mini.layer.opacity = 0.4 //0.2
        //        e2Mini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
                let e2MiniBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
        //        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate))
                e2MiniBtn.tintColor = .white
        //        eMiniBtn.tintColor = .green
                aCPost.addSubview(e2MiniBtn)
                e2MiniBtn.translatesAutoresizingMaskIntoConstraints = false
                e2MiniBtn.centerXAnchor.constraint(equalTo: e2Mini.centerXAnchor).isActive = true
                e2MiniBtn.centerYAnchor.constraint(equalTo: e2Mini.centerYAnchor, constant: -2).isActive = true //-2
                e2MiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //22
                e2MiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
                e2MiniBtn.isUserInteractionEnabled = true
        //        e2MiniBtn.layer.opacity = 0.5
//                e2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
                let e2Text = UILabel()
                e2Text.textAlignment = .left
                e2Text.textColor = .white
                e2Text.font = .boldSystemFont(ofSize: 10)
                aCPost.addSubview(e2Text)
                e2Text.clipsToBounds = true
                e2Text.translatesAutoresizingMaskIntoConstraints = false
                e2Text.leadingAnchor.constraint(equalTo: e2Mini.trailingAnchor, constant: 2).isActive = true
                e2Text.centerYAnchor.constraint(equalTo: e2Mini.centerYAnchor).isActive = true
                e2Text.text = "18.3K"
        //        e2Text.layer.opacity = 0.5
            }
        }
        
        if(!aTestArray.isEmpty) {
            let lastArrayE = aTestArray[aTestArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
        }
        
        if(!aTest2Array.isEmpty) {
            let lastArrayE = aTest2Array[aTest2Array.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aTest2.bottomAnchor, constant: 0).isActive = true
        }
        
        //populate data count
        let dataC = data.dataCount
        if let loveC = dataC["love"] {
            bText.text = String(loveC)
        }
        if let commentC = dataC["comment"] {
            cText.text = String(commentC)
        }
        if let bookmarkC = dataC["bookmark"] {
            dText.text = String(bookmarkC)
        }
        if let shareC = dataC["share"] {
            eText.text = String(shareC)
        }
    }
    
    @objc func onCommentBtnClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.hListDidClickVcvComment()
    }
    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.hListDidClickVcvShare()
    }
    @objc func onLoveClicked(gesture: UITapGestureRecognizer) {
        
        reactOnLoveClick()
    }
    @objc func onBookmarkClicked(gesture: UITapGestureRecognizer) {
        reactOnBookmarkClick()
    }
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        print("click open user panel:")
        aDelegate?.hListDidClickVcvClickUser()
    }
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        print("click open place panel:")
        aDelegate?.hListDidClickVcvClickPlace()
    }
    @objc func onSoundClicked(gesture: UITapGestureRecognizer) {
        print("click open sound panel:")
        aDelegate?.hListDidClickVcvClickSound()
    }
    
    //test > single and double clicked
    @objc func onSingleClicked(gesture: UITapGestureRecognizer) {
        print("post single clicked")
        aDelegate?.hListDidClickVcvClickPost()
    }
    @objc func onDoubleClicked(gesture: UITapGestureRecognizer) {
        print("post double clicked")
//        reactOnLoveClick()
        
        let aColor = bMiniBtn.tintColor
        if(aColor == .white) {
            reactOnLoveClick()
            
            let translation = gesture.location(in: self)
            let x = translation.x
            let y = translation.y
            
            let bigLove = UIImageView(frame: CGRect(x: x - 16.0, y: y - 16.0, width: 32, height: 32))
            bigLove.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
            bigLove.tintColor = .red
            contentView.addSubview(bigLove)
            
            UIView.animate(withDuration: 0.3, animations: {
                bigLove.frame = CGRect(x: x - 35.0, y: y - 35.0, width: 70, height: 70)
            }, completion: { _ in
    //            bigLove.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: {
                    bigLove.frame = CGRect(x: x - 5.0, y: y - 5.0, width: 10, height: 10)
                }, completion: { _ in
                    bigLove.removeFromSuperview()
                })
            })
            print("post double clicked: \(x), \(y)")
        }
    }
    @objc func onQuotePostClicked(gesture: UITapGestureRecognizer) {
        print("post quote clicked")
    }
    @objc func onCommentClicked(gesture: UITapGestureRecognizer) {
        print("post comment clicked")
    }
    @objc func onPhotoSClicked(gesture: UITapGestureRecognizer) {
        print("post photo shot clicked")
//        aDelegate?.hListDidClickVcvClickPhoto()
        
        if(!photoConArray.isEmpty) {
            let pContainer = photoConArray[0]
            let pFrame = pContainer.frame.origin
            let aTestFrame = aTest.frame.origin
            
            print("post photo shot clicked \(pFrame), \(aTestFrame)")
            
            let pointX = pFrame.x + aTestFrame.x
            let pointY = pFrame.y + aTestFrame.y
            aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX, pointY: pointY, view: pContainer, mode: PhotoTypes.P_SHOT_DETAIL)
        }
    }
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        print("post photo clicked")
        
        if(!photoConArray.isEmpty) {
            let pContainer = photoConArray[0]
            let pFrame = pContainer.frame.origin
            let aTestFrame = aTest.frame.origin
            
            let pointX = pFrame.x + aTestFrame.x
            let pointY = pFrame.y + aTestFrame.y
            aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX, pointY: pointY, view: pContainer, mode: PhotoTypes.P_0)
            
            //test > hide photo
            hideCell(view: pContainer)
        }
    }
    @objc func onVideoClicked(gesture: UITapGestureRecognizer) {
        print("post video clicked")
        
        if(!vidConArray.isEmpty) {
            let vContainer = vidConArray[0]
            let vFrame = vContainer.frame.origin
            let aTestFrame = aTest.frame.origin
            
            let pointX = vFrame.x + aTestFrame.x
            let pointY = vFrame.y + aTestFrame.y
            aDelegate?.hListDidClickVcvClickVideo(vc: self, pointX: pointX, pointY: pointY, view: vContainer, mode: VideoTypes.V_0)
            
            //test > hide video
            hideCell(view: vContainer)
        }
    }
    @objc func onVideoLClicked(gesture: UITapGestureRecognizer) {
        print("post video loop clicked")
        
        if(!vidConArray.isEmpty) {
            let vContainer = vidConArray[0]
            let vFrame = vContainer.frame.origin
            let aTestFrame = aTest.frame.origin
            
            let pointX = vFrame.x + aTestFrame.x
            let pointY = vFrame.y + aTestFrame.y
            aDelegate?.hListDidClickVcvClickVideo(vc: self, pointX: pointX, pointY: pointY, view: vContainer, mode: VideoTypes.V_LOOP)
            
            //test > hide video
            hideCell(view: vContainer)
        }
    }
    
    //test* > hide & dehide cells
    func dehideCell() {
        print("dehidecell hpostA: \(hideConArray)")
        if(!hideConArray.isEmpty) {
            let view = hideConArray[0]
            view.isHidden = false
            
            hideConArray.removeAll()
        }
    }
        
    func hideCell(view: UIView) {
        view.isHidden = true
        hideConArray.append(view)
    }
    //*
    
    func reactOnLoveClick() {
        let aColor = bMiniBtn.tintColor
        if(aColor == .white) {
            bMiniBtn.tintColor = .red
//            bMiniBtn.layer.opacity = 1
        } else {
            bMiniBtn.tintColor = .white
//            bMiniBtn.layer.opacity = 0.5
        }
        
//        updateResult()
    }
    func reactOnBookmarkClick() {
        let aColor = dMiniBtn.tintColor
        if(aColor == .white) {
            dMiniBtn.tintColor = .ddmGoldenYellowColor
//            dMiniBtn.layer.opacity = 1
        } else {
            dMiniBtn.tintColor = .white
//            dMiniBtn.layer.opacity = 0.5
        }
        
//        updateResult()
    }
    
    //for video play
    var timeObserverTokenVideo: Any?
    func addTimeObserverVideo() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
//        timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
//            [weak self] time in
//
//            let currentT = time.seconds
//            guard let s = self else {
//                return
//            }
//            print("hpl time observe videoT:\(currentT)")
//        }
        
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
                print("hpl time observe videoT:\(currentT)")
                s.t_s = currentT
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
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        if(player != nil && player.currentItem != nil) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        playVideo()
    }
    
    var vidPlayStatus = ""
    func playVideo() {
        player?.seek(to: .zero)
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    func stopVideo() {
        player?.seek(to: .zero)
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    func pauseVideo() {
        player?.pause()

        reactOnPlayStatus(status: "pause")
    }
    
    func resumeVideo() {
        player?.play()

        reactOnPlayStatus(status: "play")
    }
    func reactOnPlayStatus(status: String) {
        vidPlayStatus = status
        if(status == "play") {
            if(!playBtnArray.isEmpty) {
                let playBtn = playBtnArray[0]
                playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
            }
        } else {
            if(!playBtnArray.isEmpty) {
                let playBtn = playBtnArray[0]
                playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    @objc func onVideoBtnClicked(gesture: UITapGestureRecognizer) {
        if(vidPlayStatus == "play") {
            pauseVideo()
        } else {
            resumeVideo()
        }
    }
    
    func seekToV() {
        let t = 3.4
        let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
        player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}

//test > scroll view delegate for carousel of images
//extension HPostListViewNCell: UIScrollViewDelegate {
extension HPostListAViewCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("hpostview scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.hListIsScrollCarousel(isScroll: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        print("hpostview scrollview scroll: \(x), \(y)")
        aDelegate?.hListIsScrollCarousel(isScroll: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("hpostview scrollview end: \(scrollView.contentOffset.y)")
        
        aDelegate?.hListIsScrollCarousel(isScroll: false)
        
        //test > for bubble when scrolled thru carousel
        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        print("Current item index: \(tempCurrentIndex)")
        
        if(!bubbleArray.isEmpty) {
            let bubble1 = bubbleArray[0]
            bubble1.setIndicatorSelected(index: tempCurrentIndex)
            
            //test > for carousel page
            p_s = tempCurrentIndex
            aDelegate?.hListCarouselIdx(vc: self, idx: p_s)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("hpostview scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.hListIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("hpostview scrollview animation ended")

    }
}
