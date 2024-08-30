//
//  HPostListBViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

//test > horizontal list viewcell for posts
class HPostListBViewCell: UICollectionViewCell {
    static let identifier = "HPostListStandardBViewCell"
    var gifImage = SDAnimatedImageView()
    
    let bMiniBtn = UIImageView()
    let dMiniBtn = UIImageView()
    let aGridNameText = UILabel()
    let aText = UILabel()
//    var gifImage1 = SDAnimatedImageView()
    let aUserPhoto = SDAnimatedImageView()
    let aaText = UILabel()
    let vBtn = UIImageView()
    let aUserNameText = UILabel()
    
//    weak var aDelegate : FeedHListCellDelegate?
    weak var aDelegate : HListCellDelegate?
    
    //test > dynamic method for various cells format
    let aTest = UIView()
//    let aTest2 = UIView()
    var aTestArray = [UIView]()
//    var aTest2Array = [UIView]()
    
    //test > video player
//    var player: AVPlayer!
    
    //test > for video container intersection as user scrolls to play/pause
    var vidConArray = [UIView]()
//    var playBtnArray = [UIImageView]()
//    var photoConArray = [UIView]()
//    var bubbleArray = [PageBubbleIndicator]()
    
    var t_s = 0.0 //for video pause/resume time
//    var p_s = 0 //for photo carousel last viewed photo
    
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
        
        //test > added double tap for love click shortcut
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
//        atapGR.numberOfTapsRequired = 1
//        aResult.addGestureRecognizer(atapGR)
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
//        tapGR.numberOfTapsRequired = 2
//        aResult.addGestureRecognizer(tapGR)
//        atapGR.require(toFail: tapGR) //enable double tap
        ////////////////////

        //test > add container for clicks event
        let aCon = UIView()
        contentView.addSubview(aCon)
//        aCon.backgroundColor = .red
        aCon.translatesAutoresizingMaskIntoConstraints = false
        aCon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aCon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        aCon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aCon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
        atapGR.numberOfTapsRequired = 1
        aCon.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
        tapGR.numberOfTapsRequired = 2
        aCon.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR) //enable double tap
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
//        contentView.addSubview(eUserCover)
        aCon.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aCon.topAnchor, constant: 20).isActive = true //10
        eUserCover.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true //20
        eUserCover.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.layer.cornerRadius = 20
        eUserCover.layer.opacity = 1.0 //default 0.3
        
//        let aUserPhoto = SDAnimatedImageView()
//        contentView.addSubview(aUserPhoto)
        aCon.addSubview(aUserPhoto)
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
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkColor
        aUserPhoto.isUserInteractionEnabled = true
        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))

//        let aGridNameText = UILabel()
        aGridNameText.textAlignment = .left
        aGridNameText.textColor = .white
        aGridNameText.font = .boldSystemFont(ofSize: 14)
//        aGridNameText.font = .systemFont(ofSize: 14)
//        contentView.addSubview(aGridNameText)
        aCon.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
//        aGridNameText.centerYAnchor.constraint(equalTo: aUserPhoto.centerYAnchor).isActive = true
        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
//        aGridNameText.text = "Mic1809"
//        aGridNameText.text = "Michael Kins"
        aGridNameText.text = "-"
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .white //darkGray
//        contentView.addSubview(vBtn)
        aCon.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aGridNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aGridNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        //
        
//        let aUserNameText = UILabel()
        aUserNameText.textAlignment = .left
        aUserNameText.textColor = .white
        aUserNameText.font = .systemFont(ofSize: 12)
//        contentView.addSubview(aUserNameText)
        aCon.addSubview(aUserNameText)
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.topAnchor.constraint(equalTo: aGridNameText.bottomAnchor).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
        aUserNameText.text = "-"
//        aUserNameText.text = "@mic1809"
        aUserNameText.layer.opacity = 0.3 //0.5
        
//        let aTest = UIView()
//        contentView.addSubview(aTest)
        aCon.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
        //test > click on aTest for click post
//        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
        
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
//        atapGR.numberOfTapsRequired = 1
//        aTest.addGestureRecognizer(atapGR)
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
//        tapGR.numberOfTapsRequired = 2
//        aTest.addGestureRecognizer(tapGR)
//        atapGR.require(toFail: tapGR) //enable double tap
        
        //test 2 > design location 2
        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aBox)
        aCon.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
//        aBox.leadingAnchor.constraint(equalTo: aText.leadingAnchor, constant: 0).isActive = true
        aBox.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
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
//        contentView.addSubview(bBox)
        aCon.addSubview(bBox)
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

//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        aaText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
//        contentView.addSubview(aaText)
        aCon.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        aaText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        aaText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
//        aaText.text = "Petronas Twin Tower"
        aaText.text = "-"
//        aaText.layer.opacity = 0.5
        
        //test > post performance count metrics
        let bMiniCon = UIView()
        aCon.addSubview(bMiniCon)
        bMiniCon.translatesAutoresizingMaskIntoConstraints = false
        bMiniCon.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 10).isActive = true
        bMiniCon.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
        bMiniCon.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        bMiniCon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bMiniCon.isUserInteractionEnabled = true
        bMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
        let bMini = UIView()
        bMini.backgroundColor = .ddmDarkColor
//        contentView.addSubview(bMini)
        bMiniCon.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
        bMini.centerYAnchor.constraint(equalTo: bMiniCon.centerYAnchor).isActive = true
        bMini.centerXAnchor.constraint(equalTo: bMiniCon.centerXAnchor).isActive = true
        bMini.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        bMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bMini.layer.cornerRadius = 15
        bMini.layer.opacity = 0.4 //0.2
//        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        bMiniBtn.tintColor = .white
//        bMiniBtn.tintColor = .red
//        contentView.addSubview(bMiniBtn)
        bMiniCon.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //16
        bMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        bMiniBtn.isUserInteractionEnabled = true
//        bMiniBtn.layer.opacity = 0.5
//        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(bText)
        aCon.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.leadingAnchor.constraint(equalTo: bMiniCon.trailingAnchor, constant: 2).isActive = true
        bText.centerYAnchor.constraint(equalTo: bMiniCon.centerYAnchor).isActive = true
        bText.text = "-"
//        bText.layer.opacity = 0.5
        
        let cMiniCon = UIView()
        aCon.addSubview(cMiniCon)
        cMiniCon.translatesAutoresizingMaskIntoConstraints = false
        cMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
        cMiniCon.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
        cMiniCon.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        cMiniCon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cMiniCon.isUserInteractionEnabled = true
        cMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
        let cMini = UIView()
        cMini.backgroundColor = .ddmDarkColor
//        contentView.addSubview(cMini)
        cMiniCon.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
        cMini.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
        cMini.centerXAnchor.constraint(equalTo: cMiniCon.centerXAnchor).isActive = true
        cMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cMini.layer.cornerRadius = 15
        cMini.layer.opacity = 0.4 //0.2
//        cMini.isHidden = true
//        cMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
//        cMiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
        cMiniBtn.tintColor = .white //white
//        contentView.addSubview(cMiniBtn)
        cMiniCon.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        cMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true //16
//        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.layer.opacity = 0.5
//        cMiniBtn.isHidden = true
//        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
//        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(cText)
        aCon.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.leadingAnchor.constraint(equalTo: cMiniCon.trailingAnchor, constant: 2).isActive = true
        cText.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
        cText.text = "-"
//        cText.isHidden = true
//        cText.layer.opacity = 0.5
        
        let dMiniCon = UIView()
        aCon.addSubview(dMiniCon)
        dMiniCon.translatesAutoresizingMaskIntoConstraints = false
        dMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
        dMiniCon.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
        dMiniCon.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        dMiniCon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dMiniCon.isUserInteractionEnabled = true
        dMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
        let dMini = UIView()
        dMini.backgroundColor = .ddmDarkColor
//        contentView.addSubview(dMini)
        dMiniCon.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
        dMini.centerYAnchor.constraint(equalTo: dMiniCon.centerYAnchor).isActive = true
        dMini.centerXAnchor.constraint(equalTo: dMiniCon.centerXAnchor).isActive = true
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
//        contentView.addSubview(dMiniBtn)
        dMiniCon.addSubview(dMiniBtn)
        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //16
        dMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        dMiniBtn.isUserInteractionEnabled = true
//        dMiniBtn.layer.opacity = 0.5
//        dMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
//        let dText = UILabel()
        dText.textAlignment = .left
        dText.textColor = .white
        dText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(dText)
        aCon.addSubview(dText)
        dText.clipsToBounds = true
        dText.translatesAutoresizingMaskIntoConstraints = false
        dText.leadingAnchor.constraint(equalTo: dMiniCon.trailingAnchor, constant: 2).isActive = true
        dText.centerYAnchor.constraint(equalTo: dMiniCon.centerYAnchor).isActive = true
        dText.text = "-"
//        dText.layer.opacity = 0.5
        
        let eMiniCon = UIView()
        aCon.addSubview(eMiniCon)
        eMiniCon.translatesAutoresizingMaskIntoConstraints = false
        eMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
        eMiniCon.leadingAnchor.constraint(equalTo: dText.trailingAnchor, constant: 20).isActive = true
        eMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        eMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        eMiniCon.isUserInteractionEnabled = true
        eMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
        let eMini = UIView()
        eMini.backgroundColor = .ddmDarkColor
//        eMini.backgroundColor = .green
//        contentView.addSubview(eMini)
        eMiniCon.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
        eMini.centerYAnchor.constraint(equalTo: eMiniCon.centerYAnchor).isActive = true
        eMini.centerXAnchor.constraint(equalTo: eMiniCon.centerXAnchor).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        eMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        eMini.layer.cornerRadius = 15
        eMini.layer.opacity = 0.4 //0.2
//        eMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
//        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate))
        eMiniBtn.tintColor = .white
//        eMiniBtn.tintColor = .green
//        contentView.addSubview(eMiniBtn)
        eMiniCon.addSubview(eMiniBtn)
        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        eMiniBtn.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eMiniBtn.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: -2).isActive = true //-2
        eMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //22
        eMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        eMiniBtn.isUserInteractionEnabled = true
//        eMiniBtn.layer.opacity = 0.5
//        eMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
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
//        contentView.addSubview(eText)
        aCon.addSubview(eText)
        eText.clipsToBounds = true
        eText.translatesAutoresizingMaskIntoConstraints = false
        eText.leadingAnchor.constraint(equalTo: eMiniCon.trailingAnchor, constant: 2).isActive = true
        eText.centerYAnchor.constraint(equalTo: eMiniCon.centerYAnchor).isActive = true
        eText.text = "-"
//        eText.layer.opacity = 0.5
        
//        //test** > comment divider
        let e2UserCover = UIView()
        e2UserCover.backgroundColor = .clear
//        contentView.addSubview(e2UserCover)
        aCon.addSubview(e2UserCover)
        e2UserCover.translatesAutoresizingMaskIntoConstraints = false
        e2UserCover.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 30).isActive = true //20
        e2UserCover.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 0).isActive = true
        e2UserCover.heightAnchor.constraint(equalToConstant: 26).isActive = true //40
        e2UserCover.widthAnchor.constraint(equalToConstant: 0).isActive = true //40
        e2UserCover.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: 0).isActive = true //test
        
        let commentTitleText = UILabel()
        commentTitleText.textAlignment = .center
        commentTitleText.textColor = .white
//        commentTitleText.font = .systemFont(ofSize: 13) //default 14
        commentTitleText.font = .boldSystemFont(ofSize: 13) //default 14
        commentTitleText.text = "Comments"
        aCon.addSubview(commentTitleText)
//        contentView.addSubview(commentTitleText)
        commentTitleText.translatesAutoresizingMaskIntoConstraints = false
        commentTitleText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor, constant: 0).isActive = true
        commentTitleText.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
//        commentTitleText.layer.opacity = 0.5

        let commentTitleBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
//            aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        commentTitleBtn.tintColor = .white
//        contentView.addSubview(commentTitleBtn)
        aCon.addSubview(commentTitleBtn)
        commentTitleBtn.translatesAutoresizingMaskIntoConstraints = false
        commentTitleBtn.leadingAnchor.constraint(equalTo: commentTitleText.trailingAnchor).isActive = true
        commentTitleBtn.centerYAnchor.constraint(equalTo: commentTitleText.centerYAnchor).isActive = true
        commentTitleBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        commentTitleBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        //**
        
        //test > dynamic cell for comment
//        contentView.addSubview(aTest2)
//        aTest2.translatesAutoresizingMaskIntoConstraints = false
//        aTest2.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
//        aTest2.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest2.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 0).isActive = true
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        
//        removeTimeObserverVideo()
        
//        player?.pause()
//        player?.replaceCurrentItem(with: nil)
//        player = nil
//        
//        vidPlayStatus = ""
        
        vidConArray.removeAll()
//        playBtnArray.removeAll()
//        bubbleArray.removeAll()
//        photoConArray.removeAll()
        hideConArray.removeAll()
        //**
        
        aGridNameText.text = "-"
        vBtn.image = nil
        aaText.text = "-"
        let imageUrl = URL(string: "")
        aUserPhoto.sd_setImage(with: imageUrl)
        
        bText.text = "0"
        cText.text = "0"
        dText.text = "0"
        eText.text = "0"
        
        for e in aTestArray {
            //test > destroy inner content cell before removed
            if let a = e as? ContentCell {
                a.destroyCell()
            }
            
            e.removeFromSuperview()
        }
        aTestArray.removeAll()
        
//        for e in aTest2Array {
//            e.removeFromSuperview()
//        }
//        aTest2Array.removeAll()
        
//        let gifUrl1 = URL(string: "")
//        gifImage1.sd_setImage(with: gifUrl1)
    }
    
    //*test > async fetch images/names/videos
    func asyncConfigure(data: String) {
        let id = "u_"
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    self.aGridNameText.text = "Michael Kins"
                    self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
                    
                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                    self.aUserPhoto.sd_setImage(with: imageUrl)
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
    
    func configure(data: PostData) {
//        aGridNameText.text = "Michael Kins"
        asyncConfigure(data: "")
        
        aUserNameText.text = "3hr . 1.2m views"
        aaText.text = "Petronas Twin Tower"
        
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
                let cellWidth = self.frame.width
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
                contentCell.configure(data: "a")
                contentCell.setState(p: data.p_s)
                contentCell.aDelegate = self

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
                contentCell.setDescHeight(lHeight: 40, txt: data.dataTextString)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
                contentCell.setState(p: data.p_s)
                contentCell.aDelegate = self
                
            }
            else if(l == "v_l") {//loop videos
                let cellWidth = self.frame.width
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
                contentCell.setDescHeight(lHeight: 40, txt: data.dataTextString)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
                contentCell.setState(t: data.t_s)
                contentCell.aDelegate = self
                
                vidConArray.append(contentCell)
                
            }
            else if(l == "v") { //vi
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
                contentCell.configure(data: "a")
                contentCell.setState(t: data.t_s)
                contentCell.aDelegate = self
                
                vidConArray.append(contentCell)
                
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

            }
        }
        
        if(!aTestArray.isEmpty) {
            let lastArrayE = aTestArray[aTestArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
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
        aDelegate?.hListDidClickVcvComment(vc: self)
    }
    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.hListDidClickVcvShare(vc: self)
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
//        aDelegate?.hListDidClickVcvClickPost()
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
//    @objc func onPhotoSClicked(gesture: UITapGestureRecognizer) {
//        print("post photo shot clicked")
////        aDelegate?.hListDidClickVcvClickPhoto()
//        
//        if(!photoConArray.isEmpty) {
//            let pContainer = photoConArray[0]
//            let pFrame = pContainer.frame.origin
//            let aTestFrame = aTest.frame.origin
//            
//            print("post photo shot clicked \(pFrame), \(aTestFrame)")
//            
//            let pointX = pFrame.x + aTestFrame.x
//            let pointY = pFrame.y + aTestFrame.y
//            aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX, pointY: pointY, view: pContainer, mode: PhotoTypes.P_SHOT_DETAIL)
//        }
//    }
//    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
//        print("post photo clicked")
//        
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
    
    //test* > hide & dehide cells
    func dehideCell() {
        print("dehidecell hpostA: \(hideConArray)")
//        if(!hideConArray.isEmpty) {
//            let view = hideConArray[0]
//            view.isHidden = false
//            
//            hideConArray.removeAll()
//        }
        
        //test 2 > reusableview
        if(!hideConArray.isEmpty) {
            let view = hideConArray[0]
            if let a = view as? ContentCell{
                a.dehideCell()
            }
            
            hideConArray.removeAll()
        }
    }
        
//    func hideCell(view: UIView) {
//        view.isHidden = true
//        hideConArray.append(view)
//    }
    //*
    
    func reactOnLoveClick() {
        let aColor = bMiniBtn.tintColor
        if(aColor == .white) {
            bMiniBtn.tintColor = .red
        } else {
            bMiniBtn.tintColor = .white
        }
    }
    func reactOnBookmarkClick() {
        let aColor = dMiniBtn.tintColor
        if(aColor == .white) {
            dMiniBtn.tintColor = .ddmGoldenYellowColor
        } else {
            dMiniBtn.tintColor = .white
        }
    }
    
    //for video play
//    var timeObserverTokenVideo: Any?
//    func addTimeObserverVideo() {
//        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
////        timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
////            [weak self] time in
////
////            let currentT = time.seconds
////            guard let s = self else {
////                return
////            }
////            print("hpl time observe videoT:\(currentT)")
////        }
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
    func playVideo() {
//        player?.seek(to: .zero)
//        player?.play()
//
//        reactOnPlayStatus(status: "play")
        
        //test 2 > reusable view
        if(!vidConArray.isEmpty) {
            let vidC = vidConArray[0]
            if let a = vidC as? PostVideoContentCell {
                a.playVideo()
            }
            else if let b = vidC as? PostVideoLoopContentCell {
                b.playVideo()
            }
        }
    }
    func stopVideo() {
//        player?.seek(to: .zero)
//        player?.pause()
//
//        reactOnPlayStatus(status: "pause")
        
        //test 2 > reusable view
        if(!vidConArray.isEmpty) {
            let vidC = vidConArray[0]
            if let a = vidC as? PostVideoContentCell {
                a.stopVideo()
            }
            else if let b = vidC as? PostVideoLoopContentCell {
                b.stopVideo()
            }
        }
    }
    
    func pauseVideo() {
//        player?.pause()
//
//        reactOnPlayStatus(status: "pause")
        
        //test 2 > reusable view
        if(!vidConArray.isEmpty) {
            let vidC = vidConArray[0]
            if let a = vidC as? PostVideoContentCell {
                a.pauseVideo()
            }
            else if let b = vidC as? PostVideoLoopContentCell {
                b.pauseVideo()
            }
        }
    }
    
    func resumeVideo() {
//        player?.play()
//
//        reactOnPlayStatus(status: "play")
//        
//        print("postdetail B cell: resume vid")
        
        //test 2 > reusable view
        if(!vidConArray.isEmpty) {
            let vidC = vidConArray[0]
            if let a = vidC as? PostVideoContentCell {
                a.resumeVideo()
            }
            else if let b = vidC as? PostVideoLoopContentCell {
                b.resumeVideo()
            }
        }
    }
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
//    @objc func onVideoBtnClicked(gesture: UITapGestureRecognizer) {
//        if(vidPlayStatus == "play") {
//            pauseVideo()
//        } else {
//            resumeVideo()
//        }
//    }
//    
//    func seekToV() {
//        let t = 3.4
//        let seekTime = CMTime(seconds: t, preferredTimescale: CMTimeScale(1000)) //1000
//        player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//    }
}

//test > scroll view delegate for carousel of images
//extension HPostListViewNCell: UIScrollViewDelegate {
//extension HPostListBViewCell: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("hpostview scrollview begin: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: true)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("hpostview scrollview scroll: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: true)
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("hpostview scrollview end: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: false)
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("hpostview scrollview end drag: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: false)
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("hpostview scrollview animation ended")
//
//    }
//}

extension HPostListBViewCell: ContentCellDelegate {
    func contentCellIsScrollCarousel(isScroll: Bool){
        aDelegate?.hListIsScrollCarousel(isScroll: isScroll)
    }
    
    func contentCellCarouselIdx(idx: Int){
        aDelegate?.hListCarouselIdx(vc: self, idx: idx)
    }
    
    func contentCellVideoStopTime(ts: Double){
        aDelegate?.hListVideoStopTime(vc: self, ts: ts)
    }
    
    func contentCellDidClickVcvClickPhoto(cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aTest.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        hideConArray.append(cc)
    }
    func contentCellDidClickVcvClickVideo(cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aTest.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.hListDidClickVcvClickVideo(vc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        hideConArray.append(cc)
    }
    func contentCellDidDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
}
