//
//  HCommentListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

//test > horizontal list viewcell for comment
class HCommentListViewCell: UICollectionViewCell {
    static let identifier = "HCommentListViewCell"
    
    let aGridNameText = UILabel()
    let aText = UILabel()
    let aUserPhoto = SDAnimatedImageView()
    let vBtn = UIImageView()
    let aUserNameText = UILabel()
    
    let bMiniBtn = UIImageView()
    let dMiniBtn = UIImageView()
    
    //test > dynamic method for various cells format
    let aTest = UIView()
    var aTestArray = [UIView]()
    let aConnector = UIView()
    
    let bText = UILabel()
    let cText = UILabel()
    let dText = UILabel()
    let eText = UILabel()
    
    //test > for video container intersection as user scrolls to play/pause
    var mediaArray = [UIView]()
    
    //test > new method for storing hiding asset
    var hiddenAssetIdx = -1
    var playingMediaAssetIdx = -1
    
    weak var aDelegate : HListCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true

        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        //test > result vertical panel layout
        let aResult = UIView()
//        aResult.backgroundColor = .ddmDarkColor
        aResult.backgroundColor = .ddmDarkBlack
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.1 //0.3
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
//        aResult.addGestureRecognizer(atapGR)
        
        //* simulate line spacing between rows
//        let upLine = UIView()
////        upLine.backgroundColor = .green
//        upLine.backgroundColor = .ddmBlackOverlayColor
////        upLine.backgroundColor = .ddmDarkColor
//        contentView.addSubview(upLine)
//        upLine.translatesAutoresizingMaskIntoConstraints = false
//        upLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        upLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        upLine.heightAnchor.constraint(equalToConstant: 5).isActive = true //5
//        upLine.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        
//        let lowLine = UIView()
//        lowLine.backgroundColor = .red
//        contentView.addSubview(lowLine)
//        lowLine.translatesAutoresizingMaskIntoConstraints = false
//        lowLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        lowLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        lowLine.heightAnchor.constraint(equalToConstant: 5).isActive = true //5
//        lowLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        //*
        
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
        
        let photoSize = 28.0
        let photoLhsMargin = 20.0
        let usernameLhsMargin = 5.0
        let indentSize = photoSize + photoLhsMargin + usernameLhsMargin
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
//        contentView.addSubview(eUserCover)
        aCon.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        eUserCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        eUserCover.heightAnchor.constraint(equalToConstant: photoSize).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: photoSize).isActive = true
        eUserCover.layer.cornerRadius = 14
//        eUserCover.layer.opacity = 1.0 //default 0.3
        
//        let aUserPhoto = SDAnimatedImageView()
//        contentView.addSubview(aUserPhoto)
        aCon.addSubview(aUserPhoto)
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
        
//        let rhsMoreBtn = UIImageView(image: UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate))
////        rhsMoreBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
//        rhsMoreBtn.tintColor = .white
//        contentView.addSubview(rhsMoreBtn)
//        rhsMoreBtn.translatesAutoresizingMaskIntoConstraints = false
//        rhsMoreBtn.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
//        rhsMoreBtn.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true
//        rhsMoreBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //16
//        rhsMoreBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //16
//        rhsMoreBtn.isUserInteractionEnabled = true
//        rhsMoreBtn.layer.opacity = 0.5

//        let aGridNameText = UILabel()
        aGridNameText.textAlignment = .left
        aGridNameText.textColor = .white
        aGridNameText.font = .boldSystemFont(ofSize: 13)
//        contentView.addSubview(aGridNameText)
        aCon.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
//        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 5).isActive = true
//        aGridNameText.bottomAnchor.constraint(equalTo: eUserCover.bottomAnchor).isActive = true
        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: eUserCover.trailingAnchor, constant: usernameLhsMargin).isActive = true
        aGridNameText.text = "-"
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
        vBtn.tintColor = .yellow
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
        aUserNameText.textColor = .ddmDarkGrayColor
        aUserNameText.font = .systemFont(ofSize: 12)
//        contentView.addSubview(aUserNameText)
        aCon.addSubview(aUserNameText)
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.topAnchor.constraint(equalTo: aGridNameText.bottomAnchor).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
        aUserNameText.text = "-"
//        aUserNameText.layer.opacity = 0.3 //0.5

//        contentView.addSubview(aTest)
        aCon.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
//        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
   
        //test > post performance count metrics
        let bMiniCon = UIView()
        aCon.addSubview(bMiniCon)
        bMiniCon.translatesAutoresizingMaskIntoConstraints = false
        bMiniCon.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: -20).isActive = true //0
        bMiniCon.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true
        bMiniCon.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
        bMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        bMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        bMiniCon.isUserInteractionEnabled = true
        bMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
        let bMini = UIView()
//        bMini.backgroundColor = .ddmDarkColor
        bMini.backgroundColor = .ddmBlackDark
//        contentView.addSubview(bMini)
//        aCon.addSubview(bMini)
        bMiniCon.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
//        bMini.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: 0).isActive = true
//        bMini.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true
//        bMini.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
        bMini.centerYAnchor.constraint(equalTo: bMiniCon.centerYAnchor).isActive = true
        bMini.centerXAnchor.constraint(equalTo: bMiniCon.centerXAnchor).isActive = true
        bMini.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        bMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
        bMini.layer.cornerRadius = 14
//        bMini.layer.opacity = 0.4 //0.2
//        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        bMiniBtn.tintColor = .white
//        bMiniBtn.tintColor = .red
//        contentView.addSubview(bMiniBtn)
//        aCon.addSubview(bMiniBtn)
        bMiniCon.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        bMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        bMiniBtn.isUserInteractionEnabled = true
////        bMiniBtn.layer.opacity = 0.5
//        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(bText)
        aCon.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
//        bText.leadingAnchor.constraint(equalTo: bMini.trailingAnchor, constant: 2).isActive = true
//        bText.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bText.leadingAnchor.constraint(equalTo: bMiniCon.trailingAnchor, constant: 2).isActive = true
        bText.centerYAnchor.constraint(equalTo: bMiniCon.centerYAnchor).isActive = true
        bText.text = "-"
//        bText.layer.opacity = 0.5
        
        let cMiniCon = UIView()
        aCon.addSubview(cMiniCon)
        cMiniCon.translatesAutoresizingMaskIntoConstraints = false
        cMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
        cMiniCon.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
        cMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        cMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        cMiniCon.isUserInteractionEnabled = true
        cMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
        let cMini = UIView()
//        cMini.backgroundColor = .ddmDarkColor
        cMini.backgroundColor = .ddmBlackDark
//        contentView.addSubview(cMini)
//        aCon.addSubview(cMini)
        cMiniCon.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
//        cMini.topAnchor.constraint(equalTo: bMini.topAnchor, constant: 0).isActive = true
//        cMini.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
        cMini.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
        cMini.centerXAnchor.constraint(equalTo: cMiniCon.centerXAnchor).isActive = true
        cMini.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        cMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
        cMini.layer.cornerRadius = 14
//        cMini.layer.opacity = 0.4 //0.2
//        cMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
//        cMiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
        cMiniBtn.tintColor = .white
//        contentView.addSubview(cMiniBtn)
//        aCon.addSubview(cMiniBtn)
        cMiniCon.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //14
        cMiniBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //14
//        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.layer.opacity = 0.5
//        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
//        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(cText)
        aCon.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
//        cText.leadingAnchor.constraint(equalTo: cMini.trailingAnchor, constant: 2).isActive = true
//        cText.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cText.leadingAnchor.constraint(equalTo: cMiniCon.trailingAnchor, constant: 2).isActive = true
        cText.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
        cText.text = "-"
//        cText.layer.opacity = 0.5
        
        let dMiniCon = UIView()
        aCon.addSubview(dMiniCon)
        dMiniCon.translatesAutoresizingMaskIntoConstraints = false
        dMiniCon.topAnchor.constraint(equalTo: bMiniCon.topAnchor, constant: 0).isActive = true
        dMiniCon.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
        dMiniCon.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        dMiniCon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        dMiniCon.isUserInteractionEnabled = true
        dMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
        let dMini = UIView()
//        dMini.backgroundColor = .ddmDarkColor
        dMini.backgroundColor = .ddmBlackDark
//        contentView.addSubview(dMini)
//        aCon.addSubview(dMini)
        dMiniCon.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
//        dMini.topAnchor.constraint(equalTo: cMini.topAnchor, constant: 0).isActive = true
//        dMini.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
        dMini.centerYAnchor.constraint(equalTo: dMiniCon.centerYAnchor).isActive = true
        dMini.centerXAnchor.constraint(equalTo: dMiniCon.centerXAnchor).isActive = true
        dMini.heightAnchor.constraint(equalToConstant: 28).isActive = true//26
        dMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
        dMini.layer.cornerRadius = 14
//        dMini.layer.opacity = 0.4 //0.2
//        dMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat_on")?.withRenderingMode(.alwaysTemplate))
        dMiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
        dMiniBtn.tintColor = .white
//        dMiniBtn.tintColor = .ddmGoldenYellowColor
//        contentView.addSubview(dMiniBtn)
//        aCon.addSubview(dMiniBtn)
        dMiniCon.addSubview(dMiniBtn)
        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        dMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
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
//        dText.leadingAnchor.constraint(equalTo: dMini.trailingAnchor, constant: 2).isActive = true
//        dText.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
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
//        eMini.backgroundColor = .ddmDarkColor
        eMini.backgroundColor = .ddmBlackDark
//        eMini.backgroundColor = .green
//        contentView.addSubview(eMini)
//        aCon.addSubview(eMini)
        eMiniCon.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
//        eMini.topAnchor.constraint(equalTo: dMini.topAnchor, constant: 0).isActive = true
//        eMini.leadingAnchor.constraint(equalTo: dText.trailingAnchor, constant: 20).isActive = true
        eMini.centerYAnchor.constraint(equalTo: eMiniCon.centerYAnchor).isActive = true
        eMini.centerXAnchor.constraint(equalTo: eMiniCon.centerXAnchor).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 28).isActive = true //26
        eMini.widthAnchor.constraint(equalToConstant: 28).isActive = true
        eMini.layer.cornerRadius = 14
//        eMini.layer.opacity = 0.4 //0.2
//        eMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
//        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate))
        eMiniBtn.tintColor = .white
//        eMiniBtn.tintColor = .green
//        contentView.addSubview(eMiniBtn)
//        aCon.addSubview(eMiniBtn)
        eMiniCon.addSubview(eMiniBtn)
        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        eMiniBtn.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eMiniBtn.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: -2).isActive = true //-2
        eMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
        eMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        eMiniBtn.isUserInteractionEnabled = true
//        eMiniBtn.layer.opacity = 0.5
//        eMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
//        let eText = UILabel()
        eText.textAlignment = .left
        eText.textColor = .white
        eText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(eText)
        aCon.addSubview(eText)
        eText.clipsToBounds = true
        eText.translatesAutoresizingMaskIntoConstraints = false
//        eText.leadingAnchor.constraint(equalTo: eMini.trailingAnchor, constant: 2).isActive = true
//        eText.centerYAnchor.constraint(equalTo: eMini.centerYAnchor).isActive = true
        eText.leadingAnchor.constraint(equalTo: eMiniCon.trailingAnchor, constant: 2).isActive = true
        eText.centerYAnchor.constraint(equalTo: eMiniCon.centerYAnchor).isActive = true
        eText.text = "-"
//        eText.layer.opacity = 0.5

        //test > inter-post connector lines
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aConnector.backgroundColor = .ddmDarkColor
        contentView.addSubview(aConnector)
        aConnector.clipsToBounds = true
        aConnector.translatesAutoresizingMaskIntoConstraints = false
        aConnector.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor, constant: 0).isActive = true
        aConnector.widthAnchor.constraint(equalToConstant: 3).isActive = true //default: 50
//        aConnector.bottomAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
        aConnector.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: 0).isActive = true
        aConnector.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 10).isActive = true
        aConnector.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        
        mediaArray.removeAll()
        
        //test > new method to store hidden asset
        hiddenAssetIdx = -1
        
        aGridNameText.text = "-"
        vBtn.image = nil
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
    }
    
    //test > destroy view to avoid timeobserver memory leak
    func destroyCell() {
        print("hcommentvc destroy cell")
        for e in aTestArray {
            //test > destroy inner content cell before removed
            if let a = e as? ContentCell {
                a.destroyCell()
            }
        }
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
    
    func configure(data: BaseData) {

        asyncConfigure(data: "")
        
        aUserNameText.text = "4hr . 324k views"
        
        //test > dynamic create ui for various data types in sequence
        let dataL = data.dataArray
        let dataCL = data.contentDataArray
        
        let photoSize = 28.0
        let photoLhsMargin = 20.0
        let usernameLhsMargin = 5.0
        let indentSize = photoSize + photoLhsMargin + usernameLhsMargin

        for cl in dataCL {
            let l = cl.dataType
//        for l in dataL {
            if(l == "t") {
                let aaText = UILabel()
                aaText.textAlignment = .left
                aaText.textColor = .white
                aaText.font = .systemFont(ofSize: 13)
                aaText.numberOfLines = 0
                aTest.addSubview(aaText)
                aaText.translatesAutoresizingMaskIntoConstraints = false
                if(aTestArray.isEmpty) {
                    aaText.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    aaText.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                aaText.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
                aaText.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
//                aaText.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
                aaText.text = data.dataTextString
                aTestArray.append(aaText)
            }
            else if(l == "p") {
                let cellWidth = self.frame.width
                let lhsMargin = indentSize
                let rhsMargin = 20.0
                let availableWidth = cellWidth - lhsMargin - rhsMargin
                
                let assetSize = CGSize(width: 3, height: 4) //4:3
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
//                let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: 330, height: 280))
                let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
                aTest.addSubview(contentCell)
                contentCell.translatesAutoresizingMaskIntoConstraints = false
                if(aTestArray.isEmpty) {
                    contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
//                contentCell.widthAnchor.constraint(equalToConstant: 330).isActive = true  //370
//                contentCell.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
                contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
                contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
                contentCell.layer.cornerRadius = 10 //5
                aTestArray.append(contentCell)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
//                contentCell.setState(p: data.p_s)
                contentCell.setState(p: cl.p_s)
                contentCell.aDelegate = self
            }
            else if(l == "p_s") {
                let cellWidth = self.frame.width
                let lhsMargin = indentSize
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
//                let contentCell = PostPhotoShotContentCell(frame: CGRect(x: 0, y: 0, width: 330, height: 320))
                let contentCell = PostPhotoShotContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
                aTest.addSubview(contentCell)
                contentCell.translatesAutoresizingMaskIntoConstraints = false
                if(aTestArray.isEmpty) {
                    contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
//                contentCell.widthAnchor.constraint(equalToConstant: 330).isActive = true  //370
//                contentCell.heightAnchor.constraint(equalToConstant: 320).isActive = true  //320
                contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
                contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //320
                contentCell.layer.cornerRadius = 10 //5
                aTestArray.append(contentCell)
                contentCell.setDescHeight(lHeight: descHeight, txt: data.dataTextString)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
//                contentCell.setState(p: data.p_s)
                contentCell.setState(p: cl.p_s)
                contentCell.aDelegate = self
            }
            else if(l == "v_l") {//loop videos
                let cellWidth = self.frame.width
                let lhsMargin = indentSize
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
                contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
//                contentCell.widthAnchor.constraint(equalToConstant: 220).isActive = true  //220
//                contentCell.heightAnchor.constraint(equalToConstant: 390).isActive = true  //390
                contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //220
                contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //390
                contentCell.layer.cornerRadius = 10 //5
                aTestArray.append(contentCell)
                contentCell.setDescHeight(lHeight: descHeight, txt: data.dataTextString)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
//                contentCell.setState(t: data.t_s)
                contentCell.setState(t: cl.t_s)
                contentCell.aDelegate = self
                
                mediaArray.append(contentCell)
            }
            else if(l == "v") { //vi
                let cellWidth = self.frame.width
                let lhsMargin = indentSize
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
                contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
//                contentCell.widthAnchor.constraint(equalToConstant: 220).isActive = true  //220
//                contentCell.heightAnchor.constraint(equalToConstant: 350).isActive = true  //350
                contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //220
                contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //350
                contentCell.layer.cornerRadius = 10 //5
                aTestArray.append(contentCell)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
//                contentCell.setState(t: data.t_s)
                contentCell.setState(t: cl.t_s)
                contentCell.aDelegate = self
                
                mediaArray.append(contentCell)
            }
            else if(l == "q") {
                //test 2 > new reusable view
                let cellWidth = self.frame.width
                let lhsMargin = indentSize
                let rhsMargin = 20.0
                let availableWidth = cellWidth - lhsMargin - rhsMargin
                
                let contentCell = PostQuoteContentCell(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 120.0))
//                let contentCell = PostQuoteContentCell()
                aTest.addSubview(contentCell)
                contentCell.translatesAutoresizingMaskIntoConstraints = false
                if(aTestArray.isEmpty) {
                    contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: indentSize).isActive = true
                contentCell.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
//                contentCell.heightAnchor.constraint(equalToConstant: 120).isActive = true  //350
                contentCell.layer.cornerRadius = 10 //5
                aTestArray.append(contentCell)
                contentCell.configure(data: "a", text: data.dataTextString)
                contentCell.aDelegate = self //test
                
                mediaArray.append(contentCell)
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
    
    @objc func onCommentClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.hListDidClickVcvComment(vc: self)
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.hListDidClickVcvClickUser()
    }
    @objc func onSingleClicked(gesture: UITapGestureRecognizer) {
        print("comment single clicked")
        aDelegate?.hListDidClickVcvClickPost()
    }
    @objc func onDoubleClicked(gesture: UITapGestureRecognizer) {
        print("comment double clicked")
        let aColor = bMiniBtn.tintColor
        if(aColor == .white) {
            reactOnLoveClick()
            
            let translation = gesture.location(in: self)
            let x = translation.x
            let y = translation.y
            
            let bigLove = UIImageView(frame: CGRect(x: x - 10.0, y: y - 10.0, width: 20, height: 20))
            bigLove.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
            bigLove.tintColor = .red
            contentView.addSubview(bigLove)
            
            UIView.animate(withDuration: 0.3, animations: {
                bigLove.frame = CGRect(x: x - 20.0, y: y - 20.0, width: 40, height: 40)
            }, completion: { _ in
    //            bigLove.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: {
                    bigLove.frame = CGRect(x: x - 5.0, y: y - 5.0, width: 10, height: 10)
                }, completion: { _ in
                    bigLove.removeFromSuperview()
                })
            })
        }
    }

    @objc func onLoveClicked(gesture: UITapGestureRecognizer) {
        reactOnLoveClick()
    }
    @objc func onBookmarkClicked(gesture: UITapGestureRecognizer) {
        reactOnBookmarkClick()
    }
    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
        print("comment share clicked")
        aDelegate?.hListDidClickVcvShare(vc: self)
    }
    
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
    
    //test* > hide & dehide cells
    func dehideCell() {
        //test 3 > new method to store hidden asset idx
        if(!aTestArray.isEmpty) {
            if(hiddenAssetIdx > -1 && hiddenAssetIdx < aTestArray.count) {
                if let a = aTestArray[hiddenAssetIdx] as? ContentCell{
                    a.dehideCell()
                }
            }
        }
    }
    //*
    
    //test 2 > new method to play/stop media with asset idx for multi-assets per cell
    func pauseMedia(aIdx: Int) {
        if(aIdx > -1) {
            if(!aTestArray.isEmpty && aIdx < aTestArray.count) {
                let asset = aTestArray[aIdx]
                if let a = asset as? MediaContentCell {
                    a.pauseMedia()
                }
            }
        }
    }
    func resumeMedia(aIdx: Int) {
        if(aIdx > -1) {
            if(!aTestArray.isEmpty && aIdx < aTestArray.count) {
                let asset = aTestArray[aIdx]
                if let a = asset as? MediaContentCell {
                    a.resumeMedia()
                }
            }
        }
    }
}

extension HCommentListViewCell: ContentCellDelegate {
    func contentCellIsScrollCarousel(isScroll: Bool){
        aDelegate?.hListIsScrollCarousel(isScroll: isScroll)
    }
    
    func contentCellCarouselIdx(cc: UIView, idx: Int){
        if let j = aTestArray.firstIndex(of: cc) {
            aDelegate?.hListCarouselIdx(vc: self, aIdx: j, idx: idx)
        }
    }
    
    func contentCellVideoStopTime(cc: UIView, ts: Double){
        if let j = aTestArray.firstIndex(of: cc) {
            aDelegate?.hListVideoStopTime(vc: self, aIdx: j, ts: ts)
        }
    }
    
    func contentCellDidClickVcvClickPhoto(cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aTest.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        //test 2 > new method to store hide asset
        if let j = aTestArray.firstIndex(of: cc) {
            print("comment cc hide photoA: \(j)")
            hiddenAssetIdx = j
        }
    }
    func contentCellDidClickVcvClickVideo(cc: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        let aTestFrame = aTest.frame.origin
        let ccFrame = cc.frame.origin
        
        let pointX1 = pointX + aTestFrame.x + ccFrame.x
        let pointY1 = pointY + aTestFrame.y + ccFrame.y
        aDelegate?.hListDidClickVcvClickVideo(vc: self, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
        
        //test 2 > new method to store hide asset
        if let j = aTestArray.firstIndex(of: cc) {
            print("comment cc hide videoA: \(j)")
            hiddenAssetIdx = j
        }
    }
    func contentCellDidDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat){
        
    }
    func contentCellDidClickSound(){
        
    }
    func contentCellDidClickUser(){
        
    }
    func contentCellDidClickPlace(){
        
    }
    func contentCellDidClickPost(){
        
    }
    func contentCellDidClickVcvClickPlay(cc: UIView, isPlay: Bool){
        if let j = aTestArray.firstIndex(of: cc) {
            print("comment cc playA: \(j), \(isPlay)")
            playingMediaAssetIdx = j
            
            aDelegate?.hListDidClickVcvClickPlay(vc: self, isPlay: isPlay)
        }
    }
}

