//
//  HPhotoListBViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

class HPhotoListBViewCell: UICollectionViewCell {
    static let identifier = "HPhotoListBViewCell"
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
    
    let photoText = UILabel()
    let aResult = UIView()
    var aDataList = [String]()
//    let bubbleBox = PageBubbleIndicator()
    
    var aBubbleArray = [PageBubbleIndicator]()
    
    let aTestMusic = UIView()
    var aTestMusicArray = [UIView]()
    var player2: AVPlayer!
    
    var musicConArray = [UIView]()
    var mPlayArray = [UIImageView]()
    var mPauseArray = [UIImageView]()
    
    var photoConArray = [UIView]()
    
    var p_s = 0
    
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
//        let aResult = UIView()
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
        ////////////////////
        
//        let aTest = UIView()
        contentView.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
//        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 0).isActive = true //10
        //test > click on aTest for click post
//        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked))
        atapGR.numberOfTapsRequired = 1
        aTest.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
        tapGR.numberOfTapsRequired = 2
        aTest.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR) //enable double tap
        
        //test > add bubble for multi images
//        bubbleBox.backgroundColor = .clear
//        contentView.addSubview(bubbleBox)
//        bubbleBox.translatesAutoresizingMaskIntoConstraints = false
//        bubbleBox.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 10).isActive = true
//        bubbleBox.centerXAnchor.constraint(equalTo: aResult.centerXAnchor, constant: 0).isActive = true
//        bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
//        bubbleBox.isHidden = true
        
        //test > sound on top of profile name
//        let sBox = UIView()
////        sBox.backgroundColor = .ddmBlackOverlayColor
//        sBox.backgroundColor = .ddmDarkColor
//        contentView.addSubview(sBox)
//        sBox.clipsToBounds = true
//        sBox.translatesAutoresizingMaskIntoConstraints = false
//        sBox.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
//        sBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
////        sBox.topAnchor.constraint(equalTo: bubbleBox.bottomAnchor, constant: 10).isActive = true
//        sBox.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
//        sBox.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true //20
//        sBox.layer.cornerRadius = 5
//        sBox.layer.opacity = 0.2 //0.3
//        sBox.isUserInteractionEnabled = true
////        sBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
//
//        let sBoxInner = UIView()
//        sBoxInner.backgroundColor = .clear //yellow
//        contentView.addSubview(sBoxInner)
//        sBoxInner.clipsToBounds = true
//        sBoxInner.translatesAutoresizingMaskIntoConstraints = false
//        sBoxInner.widthAnchor.constraint(equalToConstant: 16).isActive = true //ori: 40
//        sBoxInner.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        sBoxInner.centerYAnchor.constraint(equalTo: sBox.centerYAnchor).isActive = true
//        sBoxInner.leadingAnchor.constraint(equalTo: sBox.leadingAnchor, constant: 25).isActive = true //10
//        sBoxInner.layer.cornerRadius = 5 //6
//
//        let mSBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
////        mSBtn.tintColor = .black
//        mSBtn.tintColor = .white
////        contentView.addSubview(mBtn)
//        contentView.addSubview(mSBtn)
//        mSBtn.translatesAutoresizingMaskIntoConstraints = false
//        mSBtn.centerXAnchor.constraint(equalTo: sBoxInner.centerXAnchor).isActive = true
//        mSBtn.centerYAnchor.constraint(equalTo: sBoxInner.centerYAnchor).isActive = true
//        mSBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        mSBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//
//        let mSText = UILabel()
//        mSText.textAlignment = .left
//        mSText.textColor = .white
//        mSText.font = .boldSystemFont(ofSize: 12) //13
////        contentView.addSubview(mText)
//        contentView.addSubview(mSText)
//        mSText.translatesAutoresizingMaskIntoConstraints = false
//        mSText.centerYAnchor.constraint(equalTo: mSBtn.centerYAnchor).isActive = true
//        mSText.leadingAnchor.constraint(equalTo: mSBtn.trailingAnchor, constant: 10).isActive = true
//        mSText.text = "明知故犯 - HubertWu"
//        mSText.isUserInteractionEnabled = true
//        mSText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
//        mSText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
//
//        bubbleBox.backgroundColor = .clear
//        contentView.addSubview(bubbleBox)
//        bubbleBox.translatesAutoresizingMaskIntoConstraints = false
////        bubbleBox.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 7).isActive = true
//        bubbleBox.topAnchor.constraint(equalTo: sBox.bottomAnchor, constant: 7).isActive = true
//        bubbleBox.centerXAnchor.constraint(equalTo: aResult.centerXAnchor, constant: 0).isActive = true
//        bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
//        bubbleBox.isHidden = true
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
        contentView.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 10).isActive = true //10
//        eUserCover.topAnchor.constraint(equalTo: bubbleBox.bottomAnchor, constant: 10).isActive = true //10
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
        aGridNameText.centerYAnchor.constraint(equalTo: aUserPhoto.centerYAnchor).isActive = true
//        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
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
        
        //text
//        let photoText = UILabel()
        photoText.textAlignment = .left
        photoText.textColor = .white
        photoText.font = .systemFont(ofSize: 14)
        photoText.numberOfLines = 0
        contentView.addSubview(photoText)
        photoText.translatesAutoresizingMaskIntoConstraints = false
        photoText.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 10).isActive = true
        photoText.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        photoText.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true //-30
//        photoText.text = data.dataTextString
        photoText.text = "-"
//        aTestArray.append(aaText)
        
        let aUserNameText = UILabel()
        aUserNameText.textAlignment = .left
        aUserNameText.textColor = .white
        aUserNameText.font = .systemFont(ofSize: 12)
        contentView.addSubview(aUserNameText)
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.topAnchor.constraint(equalTo: photoText.bottomAnchor, constant: 10).isActive = true
//        aUserNameText.topAnchor.constraint(equalTo: mBtn.bottomAnchor, constant: 10).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aUserNameText.text = "1.2m views . 3hr"
        aUserNameText.layer.opacity = 0.3 //0.5
        
        //test > dynamic cell for comment
        contentView.addSubview(aTestMusic)
        aTestMusic.translatesAutoresizingMaskIntoConstraints = false
        aTestMusic.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTestMusic.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
        aTestMusic.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 0).isActive = true
        
//        //test > sound text
//        let mBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
////        mBtn.tintColor = .black
//        mBtn.tintColor = .white
////        contentView.addSubview(mBtn)
//        contentView.addSubview(mBtn)
//        mBtn.translatesAutoresizingMaskIntoConstraints = false
//        mBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
//        mBtn.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 10).isActive = true
////        mBtn.topAnchor.constraint(equalTo: photoText.bottomAnchor, constant: 10).isActive = true
//        mBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        mBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//
//        let mText = UILabel()
//        mText.textAlignment = .left
//        mText.textColor = .white
//        mText.font = .boldSystemFont(ofSize: 12) //13
////        contentView.addSubview(mText)
//        contentView.addSubview(mText)
//        mText.translatesAutoresizingMaskIntoConstraints = false
//        mText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
//        mText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
//        mText.text = "明知故犯 - HubertWu"
//        mText.isUserInteractionEnabled = true
//        mText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
//        mText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true

//        //test > sound play button on photo carousel
//        let playMini = UIView()
//        playMini.backgroundColor = .ddmDarkColor
//        contentView.addSubview(playMini)
//        playMini.translatesAutoresizingMaskIntoConstraints = false
//        playMini.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: -5).isActive = true //10
//        playMini.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -5).isActive = true
//        playMini.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
//        playMini.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        playMini.layer.cornerRadius = 13 //15
//        playMini.layer.opacity = 0.3 //0.2
//        playMini.isHidden = true
//
//        let playBtn = UIImageView()
//        playBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
////        playBtn.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
//        playBtn.tintColor = .white
//        contentView.addSubview(playBtn)
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        playBtn.centerYAnchor.constraint(equalTo: playMini.centerYAnchor).isActive = true //10
//        playBtn.centerXAnchor.constraint(equalTo: playMini.centerXAnchor).isActive = true
////        playBtn.isHidden = true
//        playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //16, 20
//        playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        playBtn.isUserInteractionEnabled = true
////        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
//        //
        
        //test 2 > design location 2
        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmDarkColor
        contentView.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
//        aBox.topAnchor.constraint(equalTo: mBtn.bottomAnchor, constant: 10).isActive = true
        aBox.topAnchor.constraint(equalTo: aTestMusic.bottomAnchor, constant: 10).isActive = true //20
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
        
//        let aUserNameText = UILabel()
//        aUserNameText.textAlignment = .left
//        aUserNameText.textColor = .white
//        aUserNameText.font = .systemFont(ofSize: 12)
//        contentView.addSubview(aUserNameText)
//        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
//        aUserNameText.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 10).isActive = true
//        aUserNameText.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
////        aUserNameText.text = "3hr . 1.2m views"
//        aUserNameText.text = "1.2m views . 3hr"
//        aUserNameText.layer.opacity = 0.3 //0.5
        
        //test > post performance count metrics
        let bMini = UIView()
        bMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
//        bMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
//        bMini.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 10).isActive = true
        bMini.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 10).isActive = true
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
        
//        //test** > comment divider
        let e2UserCover = UIView()
        e2UserCover.backgroundColor = .clear
        contentView.addSubview(e2UserCover)
        e2UserCover.translatesAutoresizingMaskIntoConstraints = false
        e2UserCover.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 30).isActive = true //20
        e2UserCover.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        e2UserCover.heightAnchor.constraint(equalToConstant: 26).isActive = true //40
        e2UserCover.widthAnchor.constraint(equalToConstant: 0).isActive = true //40
        
        let commentTitleText = UILabel()
        commentTitleText.textAlignment = .center
        commentTitleText.textColor = .white
//        commentTitleText.font = .systemFont(ofSize: 13) //default 14
        commentTitleText.font = .boldSystemFont(ofSize: 13) //default 14
        commentTitleText.text = "Comments"
        contentView.addSubview(commentTitleText)
        commentTitleText.translatesAutoresizingMaskIntoConstraints = false
        commentTitleText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor, constant: 0).isActive = true
        commentTitleText.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
//        commentTitleText.layer.opacity = 0.5

        let commentTitleBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
//            aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        commentTitleBtn.tintColor = .white
        contentView.addSubview(commentTitleBtn)
        commentTitleBtn.translatesAutoresizingMaskIntoConstraints = false
        commentTitleBtn.leadingAnchor.constraint(equalTo: commentTitleText.trailingAnchor).isActive = true
        commentTitleBtn.centerYAnchor.constraint(equalTo: commentTitleText.centerYAnchor).isActive = true
        commentTitleBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        commentTitleBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        //**
        
        //test > dynamic cell for comment
        contentView.addSubview(aTest2)
        aTest2.translatesAutoresizingMaskIntoConstraints = false
        aTest2.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest2.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
        aTest2.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 0).isActive = true
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        
        aGridNameText.text = "-"
        photoText.text = "-"
        
        bText.text = "0"
        cText.text = "0"
        dText.text = "0"
        eText.text = "0"
        
        player2?.pause()
        player2?.replaceCurrentItem(with: nil)
        player2 = nil
        
        musicConArray.removeAll()
        mPlayArray.removeAll()
        mPauseArray.removeAll()
        
        photoConArray.removeAll()
        hideConArray.removeAll()
        
        aBubbleArray.removeAll()
        
        for e in aTestArray {
            e.removeFromSuperview()
        }
        aTestArray.removeAll()
        
        for e in aTestMusicArray {
            e.removeFromSuperview()
        }
        aTestMusicArray.removeAll()
        
        for e in aTest2Array {
            e.removeFromSuperview()
        }
        aTest2Array.removeAll()
        
        var gifUrl1 = URL(string: "")
        gifImage1.sd_setImage(with: gifUrl1)
        
        aDataList.removeAll()
    }
    
    func configure(data: PhotoData, width: CGFloat) {
//    func configure(data: BaseData, width: CGFloat) {
//        aGridNameText.text = "Michael Kins"
//        photoText.text = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀."
        
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
            if(l == "m") {
                //with music
                aGridNameText.text = "Michael Kins"
//                photoText.text = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀."
                photoText.text = data.dataTextString
                
                aDataList.append("a")
                
                //carousel of images
                let scrollView = UIScrollView()
                aTest.addSubview(scrollView)
                scrollView.backgroundColor = .clear
                scrollView.translatesAutoresizingMaskIntoConstraints = false
//                scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                if(aTestArray.isEmpty) {
                    scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    scrollView.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 0).isActive = true
                }
                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 0).isActive = true //0
                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: 0).isActive = true
//                scrollView.widthAnchor.constraint(equalToConstant: 370).isActive = true
                scrollView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.alwaysBounceHorizontal = true
                let contentWidth = width * CGFloat(aDataList.count)
                scrollView.contentSize = CGSize(width: contentWidth, height: 400.0) //800, 280
        //        scrollView.contentSize = CGSize(width: 360, height: 280)
                scrollView.isPagingEnabled = true //false
                scrollView.delegate = self
                scrollView.layer.cornerRadius = 10 //5
                aTestArray.append(scrollView)
                photoConArray.append(scrollView)

                var viewList = [SDAnimatedImageView]()
                for aData in aDataList {
                    var gifImage1 = SDAnimatedImageView()
                    gifImage1.contentMode = .scaleAspectFill
                    gifImage1.clipsToBounds = true
                    let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    gifImage1.sd_setImage(with: gifUrl)
    //                gifImage1.layer.cornerRadius = 10 //5
                    scrollView.addSubview(gifImage1)
                    gifImage1.translatesAutoresizingMaskIntoConstraints = false
                    gifImage1.widthAnchor.constraint(equalToConstant: width).isActive = true //180
                    gifImage1.heightAnchor.constraint(equalToConstant: 400.0).isActive = true //280
                    gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                    if(viewList.isEmpty){
                        gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                    } else {
                        gifImage1.leadingAnchor.constraint(equalTo: viewList[viewList.count - 1].trailingAnchor, constant: 0).isActive = true
                    }
                    viewList.append(gifImage1)
                    
//                    gifImage1.isUserInteractionEnabled = true
//                    gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                }
                
                //test > sound play button on photo carousel
//                let playMini = UIView()
//                playMini.backgroundColor = .ddmDarkColor
////                contentView.addSubview(playMini)
//                aTest.addSubview(playMini)
//                playMini.translatesAutoresizingMaskIntoConstraints = false
//                playMini.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5).isActive = true //10
//                playMini.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5).isActive = true
//                playMini.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
//                playMini.widthAnchor.constraint(equalToConstant: 26).isActive = true
//                playMini.layer.cornerRadius = 13 //15
//                playMini.layer.opacity = 0.3 //0.2
//                playMini.isHidden = true
//                aTestArray.append(playMini)
//
//                let playBtn = UIImageView()
//                playBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
//        //        playBtn.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
//                playBtn.tintColor = .white
////                contentView.addSubview(playBtn)
//                aTest.addSubview(playBtn)
//                playBtn.translatesAutoresizingMaskIntoConstraints = false
//                playBtn.centerYAnchor.constraint(equalTo: playMini.centerYAnchor).isActive = true //10
//                playBtn.centerXAnchor.constraint(equalTo: playMini.centerXAnchor).isActive = true
//        //        playBtn.isHidden = true
//                playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //16, 20
//                playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//                playBtn.isUserInteractionEnabled = true
//        //        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
//                aTestArray.append(playBtn)
                
                let p = data.p_s
                
                let bubbleBox = PageBubbleIndicator()
                bubbleBox.backgroundColor = .clear
                aTest.addSubview(bubbleBox)
                bubbleBox.translatesAutoresizingMaskIntoConstraints = false
                bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
                bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
                bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
                bubbleBox.setConfiguration(number: aDataList.count, color: .yellow)
                bubbleBox.setIndicatorSelected(index: p) //revert to last viewed photo in carousel
                bubbleBox.isHidden = true
                aTestArray.append(bubbleBox)
                aBubbleArray.append(bubbleBox)
                if(aDataList.count > 1) {
                    bubbleBox.isHidden = false
                }
                
                //revert to last viewed photo in carousel
                let xOffset = CGFloat(p) * width
                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)

                //test > sound text
                let audioContainer = UIView()
                audioContainer.frame = CGRect(x: 0, y: 0, width: 5, height: 5) //150, 250
                aTestMusic.addSubview(audioContainer)
                audioContainer.translatesAutoresizingMaskIntoConstraints = false
                audioContainer.widthAnchor.constraint(equalToConstant: 5).isActive = true //150, 370
                audioContainer.heightAnchor.constraint(equalToConstant: 5).isActive = true //250, 280
                audioContainer.topAnchor.constraint(equalTo: aTestMusic.topAnchor, constant: 10).isActive = true
                audioContainer.leadingAnchor.constraint(equalTo: aTestMusic.leadingAnchor, constant: 25).isActive = true
                audioContainer.clipsToBounds = true
                audioContainer.layer.cornerRadius = 0
                aTestMusicArray.append(audioContainer)
                
                musicConArray.append(audioContainer)
                
                let mBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        //        mBtn.tintColor = .black
                mBtn.tintColor = .white
        //        contentView.addSubview(mBtn)
                aTestMusic.addSubview(mBtn)
                mBtn.translatesAutoresizingMaskIntoConstraints = false
                mBtn.leadingAnchor.constraint(equalTo: aTestMusic.leadingAnchor, constant: 25).isActive = true
//                mBtn.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 10).isActive = true
                mBtn.topAnchor.constraint(equalTo: aTestMusic.topAnchor, constant: 10).isActive = true
                mBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
                mBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
                aTestMusicArray.append(mBtn)

                let mText = UILabel()
                mText.textAlignment = .left
                mText.textColor = .white
                mText.font = .boldSystemFont(ofSize: 12) //13
        //        contentView.addSubview(mText)
                aTestMusic.addSubview(mText)
                mText.translatesAutoresizingMaskIntoConstraints = false
                mText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
                mText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
                mText.text = "明知故犯 - HubertWu"
                mText.isUserInteractionEnabled = true
                mText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
                mText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
                aTestMusicArray.append(mText)
                
                let mPlayBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
//                let mPlayBtn = UIImageView(image: UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate))
                mPlayBtn.tintColor = .white
                aTestMusic.addSubview(mPlayBtn)
                mPlayBtn.translatesAutoresizingMaskIntoConstraints = false
                mPlayBtn.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
                mPlayBtn.leadingAnchor.constraint(equalTo: mText.trailingAnchor, constant: 10).isActive = true //0
                mPlayBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
                mPlayBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
                mPlayBtn.isUserInteractionEnabled = true
                mPlayBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeAudioClicked)))
                mPlayBtn.isHidden = false
                aTestMusicArray.append(mPlayBtn)
                mPlayArray.append(mPlayBtn)
                
                let mPauseBtn = UIImageView(image: UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate))
//                let mPauseBtn = UIImageView(image: UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate))
                mPauseBtn.tintColor = .white
                aTestMusic.addSubview(mPauseBtn)
                mPauseBtn.translatesAutoresizingMaskIntoConstraints = false
                mPauseBtn.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
                mPauseBtn.leadingAnchor.constraint(equalTo: mText.trailingAnchor, constant: 10).isActive = true //0
                mPauseBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
                mPauseBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
                mPauseBtn.isUserInteractionEnabled = true
                mPauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseAudioClicked)))
                mPauseBtn.isHidden = true
                aTestMusicArray.append(mPauseBtn)
                mPauseArray.append(mPauseBtn)
                
                //preload audio
                let videoURL2 = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
                let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
                let asset2 = AVAsset(url: audioUrl)
                let item2 = AVPlayerItem(asset: asset2)
                player2 = AVPlayer(playerItem: item2)
                let layer2 = AVPlayerLayer(player: player2)
                layer2.frame = audioContainer.bounds
                audioContainer.layer.addSublayer(layer2)
            }
            else if(l == "p") {
                //without music
                aGridNameText.text = "Gerber Dharat"
//                photoText.text = "Nice food, nice environment! Worth a visit. \nSo good!"
                photoText.text = data.dataTextString
                
                aDataList.append("a")
                aDataList.append("a")
                aDataList.append("a")
                aDataList.append("a")
                
                //carousel of images
                let scrollView = UIScrollView()
                aTest.addSubview(scrollView)
                scrollView.backgroundColor = .clear
                scrollView.translatesAutoresizingMaskIntoConstraints = false
//                scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                if(aTestArray.isEmpty) {
                    scrollView.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    scrollView.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 0).isActive = true
                }
                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 0).isActive = true //0
                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: 0).isActive = true
//                scrollView.widthAnchor.constraint(equalToConstant: 370).isActive = true
                scrollView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.alwaysBounceHorizontal = true
                let contentWidth = width * CGFloat(aDataList.count)
                scrollView.contentSize = CGSize(width: contentWidth, height: 400.0) //800, 280
        //        scrollView.contentSize = CGSize(width: 360, height: 280)
                scrollView.isPagingEnabled = true //false
                scrollView.delegate = self
                scrollView.layer.cornerRadius = 10 //5
                aTestArray.append(scrollView)
                photoConArray.append(scrollView)

                var viewList = [SDAnimatedImageView]()
                for aData in aDataList {
                    var gifImage1 = SDAnimatedImageView()
                    gifImage1.contentMode = .scaleAspectFill
                    gifImage1.clipsToBounds = true
                    let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    gifImage1.sd_setImage(with: gifUrl)
    //                gifImage1.layer.cornerRadius = 10 //5
                    scrollView.addSubview(gifImage1)
                    gifImage1.translatesAutoresizingMaskIntoConstraints = false
                    gifImage1.widthAnchor.constraint(equalToConstant: width).isActive = true //180
                    gifImage1.heightAnchor.constraint(equalToConstant: 400.0).isActive = true //280
                    gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                    if(viewList.isEmpty){
                        gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
                    } else {
                        gifImage1.leadingAnchor.constraint(equalTo: viewList[viewList.count - 1].trailingAnchor, constant: 0).isActive = true
                    }
                    viewList.append(gifImage1)
                    
//                    gifImage1.isUserInteractionEnabled = true
//                    gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
                }
                
                let p = data.p_s
                
                let bubbleBox = PageBubbleIndicator()
                bubbleBox.backgroundColor = .clear
                aTest.addSubview(bubbleBox)
                bubbleBox.translatesAutoresizingMaskIntoConstraints = false
                bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true
                bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
                bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
                bubbleBox.setConfiguration(number: aDataList.count, color: .yellow)
                bubbleBox.setIndicatorSelected(index: p) //revert to last viewed photo in carousel
                bubbleBox.isHidden = true
                aTestArray.append(bubbleBox)
                aBubbleArray.append(bubbleBox)
                if(aDataList.count > 1) {
                    bubbleBox.isHidden = false
                }
                
                //revert to last viewed photo in carousel
                let xOffset = CGFloat(p) * width
                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
  
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
        
        if(!aTestMusicArray.isEmpty) {
            let lastArrayE = aTestMusicArray[aTestMusicArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aTestMusic.bottomAnchor, constant: 0).isActive = true
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
        print("photo click comment")
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
//        aDelegate?.hListDidClickVcvClickPost()
    }
    @objc func onDoubleClicked(gesture: UITapGestureRecognizer) {
        
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
            print("photo double clicked: \(x), \(y)")
        }
    }
    @objc func onQuotePostClicked(gesture: UITapGestureRecognizer) {
        print("post quote clicked")
    }
    @objc func onCommentClicked(gesture: UITapGestureRecognizer) {
        print("post comment clicked")
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
            
            //test
            hideCell(view: pContainer)
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
    }
    
    func playAudio() {
        player2?.seek(to: .zero)
        player2?.play()
        
        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
            mPlayArray[0].isHidden = true
            mPauseArray[0].isHidden = false
        }
    }
    func stopAudio() {
        player2?.seek(to: .zero)
        player2?.pause()
        
        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
            mPlayArray[0].isHidden = false
            mPauseArray[0].isHidden = true
        }
    }
    
    func pauseAudio() {
        player2?.pause()
        
        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
            mPlayArray[0].isHidden = false
            mPauseArray[0].isHidden = true
        }
    }
    
    func resumeAudio() {
        player2?.play()
        
        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
            mPlayArray[0].isHidden = true
            mPauseArray[0].isHidden = false
        }
    }
    
    @objc func onResumeAudioClicked(gesture: UITapGestureRecognizer) {
        print("resume audio clicked")
        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
            mPlayArray[0].isHidden = true
            mPauseArray[0].isHidden = false
        }
        aDelegate?.hListDidClickVcvPlayAudio(vc: self)
    }
    
    @objc func onPauseAudioClicked(gesture: UITapGestureRecognizer) {
        print("pause audio clicked")
        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
            mPlayArray[0].isHidden = false
            mPauseArray[0].isHidden = true
        }
        aDelegate?.hListDidClickVcvPlayAudio(vc: self)
    }
}

//test > scroll view delegate for carousel of images
extension HPhotoListBViewCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("HPhotoListViewCell scrollview begin: \(scrollView.contentOffset.y)")
        aDelegate?.hListIsScrollCarousel(isScroll: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("HPhotoListViewCell scrollview scroll: \(scrollView.contentOffset.y)")
        aDelegate?.hListIsScrollCarousel(isScroll: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("HPhotoListViewCell scrollview end: \(scrollView.contentOffset.y)")
        
        aDelegate?.hListIsScrollCarousel(isScroll: false)
        
        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        print("Current item index: \(tempCurrentIndex)")
//        bubbleBox.setIndicatorSelected(index: tempCurrentIndex)
        if(!aBubbleArray.isEmpty) {
            aBubbleArray[0].setIndicatorSelected(index: tempCurrentIndex)
        }
        
        //test > for carousel page
        p_s = tempCurrentIndex
        aDelegate?.hListCarouselIdx(vc: self, idx: p_s)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("HPhotoListViewCell scrollview end drag: \(scrollView.contentOffset.y)")
        aDelegate?.hListIsScrollCarousel(isScroll: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("HPhotoListViewCell scrollview animation ended")

    }
}
