//
//  HPhotoListAViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

class HPhotoListAViewCell: UICollectionViewCell {
    static let identifier = "HPhotoListViewCell"
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
    
//    var aBubbleArray = [PageBubbleIndicator]()
    
//    let aTestMusic = UIView()
//    var aTestMusicArray = [UIView]()
//    var player2: AVPlayer!
//    
    var musicConArray = [UIView]()
//    var mPlayArray = [UIImageView]()
//    var mPauseArray = [UIImageView]()
    
//    var photoConArray = [UIView]()
    
//    var p_s = 0
    
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
        
//        let aTest = UIView()
//        contentView.addSubview(aTest)
        aCon.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
//        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 0).isActive = true //10
//        let atapGR1 = UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked))
//        atapGR1.numberOfTapsRequired = 1
//        aTest.addGestureRecognizer(atapGR1)
//        let tapGR1 = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
//        tapGR1.numberOfTapsRequired = 2
//        aTest.addGestureRecognizer(tapGR1)
//        atapGR1.require(toFail: tapGR1) //enable double tap
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
//        contentView.addSubview(eUserCover)
        aCon.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 10).isActive = true //10
//        eUserCover.topAnchor.constraint(equalTo: bubbleBox.bottomAnchor, constant: 10).isActive = true //10
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
        aGridNameText.centerYAnchor.constraint(equalTo: aUserPhoto.centerYAnchor).isActive = true
//        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
//        aGridNameText.text = "Mic1809"
//        aGridNameText.text = "Michael Kins"
        aGridNameText.text = "-"
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .ddmGoldenYellowColor
//        vBtn.tintColor = .white //darkGray
//        contentView.addSubview(vBtn)
        aCon.addSubview(vBtn)
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
//        contentView.addSubview(photoText)
        aCon.addSubview(photoText)
        photoText.translatesAutoresizingMaskIntoConstraints = false
        photoText.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 10).isActive = true
        photoText.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
        photoText.trailingAnchor.constraint(equalTo: aCon.trailingAnchor, constant: -20).isActive = true //-30
//        photoText.text = data.dataTextString
        photoText.text = "-"
//        aTestArray.append(aaText)
        
//        let aUserNameText = UILabel()
        aUserNameText.textAlignment = .left
        aUserNameText.textColor = .white
        aUserNameText.font = .systemFont(ofSize: 12)
//        contentView.addSubview(aUserNameText)
        aCon.addSubview(aUserNameText)
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.topAnchor.constraint(equalTo: photoText.bottomAnchor, constant: 10).isActive = true
//        aUserNameText.topAnchor.constraint(equalTo: mBtn.bottomAnchor, constant: 10).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
        aUserNameText.text = "-"
        aUserNameText.layer.opacity = 0.3 //0.5
        
        //test > dynamic cell for comment
//        aCon.addSubview(aTestMusic)
//        aTestMusic.translatesAutoresizingMaskIntoConstraints = false
//        aTestMusic.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 0).isActive = true
//        aTestMusic.trailingAnchor.constraint(equalTo: aCon.trailingAnchor, constant: 0).isActive = true
//        aTestMusic.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 0).isActive = true
        
        //test 2 > design location 2
        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aBox)
        aCon.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
        aBox.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 10).isActive = true
//        aBox.topAnchor.constraint(equalTo: aTestMusic.bottomAnchor, constant: 10).isActive = true //20
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
        let bMiniCon = UIView()
        aCon.addSubview(bMiniCon)
        bMiniCon.translatesAutoresizingMaskIntoConstraints = false
        bMiniCon.bottomAnchor.constraint(equalTo: aCon.bottomAnchor, constant: 0).isActive = true
        bMiniCon.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 10).isActive = true
        bMiniCon.leadingAnchor.constraint(equalTo: aCon.leadingAnchor, constant: 20).isActive = true
        bMiniCon.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        bMiniCon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bMiniCon.isUserInteractionEnabled = true
        bMiniCon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
        let bMini = UIView()
        bMini.backgroundColor = .ddmDarkColor
//        contentView.addSubview(bMini)
//        aCon.addSubview(bMini)
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
//        aCon.addSubview(cMini)
        cMiniCon.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
        cMini.centerYAnchor.constraint(equalTo: cMiniCon.centerYAnchor).isActive = true
        cMini.centerXAnchor.constraint(equalTo: cMiniCon.centerXAnchor).isActive = true
        cMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cMini.layer.cornerRadius = 15
        cMini.layer.opacity = 0.4 //0.2
//        cMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
//        cMiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
        cMiniBtn.tintColor = .white
//        contentView.addSubview(cMiniBtn)
        cMiniCon.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        cMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true //16
//        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.layer.opacity = 0.5
//        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
//        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(cText)
        aCon.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.leadingAnchor.constraint(equalTo: cMini.trailingAnchor, constant: 2).isActive = true
        cText.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cText.text = "-"
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
        vBtn.image = nil
        aaText.text = "-"
        let imageUrl = URL(string: "")
        aUserPhoto.sd_setImage(with: imageUrl)
        
        bText.text = "0"
        cText.text = "0"
        dText.text = "0"
        eText.text = "0"
        
//        player2?.pause()
//        player2?.replaceCurrentItem(with: nil)
//        player2 = nil
//        
        musicConArray.removeAll()
//        mPlayArray.removeAll()
//        mPauseArray.removeAll()
        
//        photoConArray.removeAll()
        hideConArray.removeAll()
        
//        aBubbleArray.removeAll()
        
        for e in aTestArray {
            //test > destroy inner content cell before removed
            if let a = e as? ContentCell {
                a.destroyCell()
            }
            
            e.removeFromSuperview()
        }
        aTestArray.removeAll()
        
//        for e in aTestMusicArray {
//            e.removeFromSuperview()
//        }
//        aTestMusicArray.removeAll()
        
        for e in aTest2Array {
            e.removeFromSuperview()
        }
        aTest2Array.removeAll()
        
//        let gifUrl1 = URL(string: "")
//        gifImage1.sd_setImage(with: gifUrl1)
        
        aDataList.removeAll()
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
    
    func configure(data: PhotoData, width: CGFloat) {
        
        asyncConfigure(data: "")
        
        aUserNameText.text = "1.2m views . 3hr"
        aaText.text = "Iphone Factory A1"
        
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
            
            photoText.text = data.dataTextString
            
            let availableWidth = self.frame.width
            let bubbleHeight = 3.0
            let bubbleTopMargin = 10.0
            let totalBubbleH = bubbleHeight + bubbleTopMargin
//            let totalBubbleH = bubbleHeight + bubbleTopMargin + 40.0 //test for sound section

            let assetSize = CGSize(width: 3, height: 4) //4:3
            var cSize = CGSize(width: 0, height: 0)
            if(assetSize.width > assetSize.height) {
                //1 > landscape photo 4:3 w:h
                let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                let cHeight = availableWidth * aRatio.height / aRatio.width + totalBubbleH
                cSize = CGSize(width: availableWidth, height: cHeight)
            }
            else if (assetSize.width < assetSize.height){
                //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                let aRatio = CGSize(width: 5, height: 6) //aspect ratio 2:3, 3:4 
                let cWidth = availableWidth
                let cHeight = cWidth * aRatio.height / aRatio.width + totalBubbleH
                cSize = CGSize(width: cWidth, height: cHeight)
            } else {
                //square
                let cWidth = availableWidth
                cSize = CGSize(width: cWidth, height: cWidth + totalBubbleH)
            }
            
            //test 2 > reusable custom view
//                let contentCell = PostPhotoContentCell(frame: CGRect(x: 0, y: 0, width: 370, height: 280))
            let contentCell = ShotPhotoContentCell(frame: CGRect(x: 0, y: 0, width: cSize.width, height: cSize.height))
            aTest.addSubview(contentCell)
            contentCell.translatesAutoresizingMaskIntoConstraints = false
            if(aTestArray.isEmpty) {
                contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 0).isActive = true
            } else {
                let lastArrayE = aTestArray[aTestArray.count - 1]
                contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 0).isActive = true
            }
            contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 0).isActive = true
            contentCell.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: 0).isActive = true
//                contentCell.widthAnchor.constraint(equalToConstant: 370).isActive = true  //370
//                contentCell.heightAnchor.constraint(equalToConstant: 280).isActive = true  //280
            contentCell.widthAnchor.constraint(equalToConstant: cSize.width).isActive = true  //370
            contentCell.heightAnchor.constraint(equalToConstant: cSize.height).isActive = true  //280
            contentCell.layer.cornerRadius = 10 //5
            aTestArray.append(contentCell)
            contentCell.setBubbleHeight(lHeight: totalBubbleH)
            contentCell.redrawUI()
            contentCell.configure(data: "a")
            contentCell.setState(p: data.p_s)
            contentCell.aDelegate = self
            
            if(l == "m") {
                
                let lhsMargin = 20.0
                let rhsMargin = 20.0
                let soundTopMargin = 10.0
                let soundHeight = 30.0
                let soundWidth = availableWidth - lhsMargin - rhsMargin
                
                let contentCell = ShotSoundContentCell(frame: CGRect(x: 0, y: 0, width: soundWidth, height: soundHeight))
                aTest.addSubview(contentCell)
                contentCell.translatesAutoresizingMaskIntoConstraints = false
                if(aTestArray.isEmpty) {
                    contentCell.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    contentCell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: soundTopMargin).isActive = true //20
                }
                contentCell.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 20).isActive = true
//                contentCell.widthAnchor.constraint(equalToConstant: 220).isActive = true  //220
//                contentCell.heightAnchor.constraint(equalToConstant: 390).isActive = true  //390
                contentCell.widthAnchor.constraint(equalToConstant: soundWidth).isActive = true  //220
                contentCell.heightAnchor.constraint(equalToConstant: soundHeight).isActive = true  //390
//                contentCell.layer.cornerRadius = 10 //5
                aTestArray.append(contentCell)
                contentCell.redrawUI()
                contentCell.configure(data: "a")
                contentCell.aDelegate = self
                
                musicConArray.append(contentCell)
                
                //test > sound text
//                let audioContainer = UIView()
//                audioContainer.frame = CGRect(x: 0, y: 0, width: 5, height: 5) //150, 250
//                aTestMusic.addSubview(audioContainer)
//                audioContainer.translatesAutoresizingMaskIntoConstraints = false
//                audioContainer.widthAnchor.constraint(equalToConstant: 5).isActive = true //150, 370
//                audioContainer.heightAnchor.constraint(equalToConstant: 5).isActive = true //250, 280
//                audioContainer.topAnchor.constraint(equalTo: aTestMusic.topAnchor, constant: 10).isActive = true
//                audioContainer.leadingAnchor.constraint(equalTo: aTestMusic.leadingAnchor, constant: 25).isActive = true
//                audioContainer.clipsToBounds = true
//                audioContainer.layer.cornerRadius = 0
//                aTestMusicArray.append(audioContainer)
//                
//                musicConArray.append(audioContainer)
//                
//                let mBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
//        //        mBtn.tintColor = .black
//                mBtn.tintColor = .white
//        //        contentView.addSubview(mBtn)
//                aTestMusic.addSubview(mBtn)
//                mBtn.translatesAutoresizingMaskIntoConstraints = false
//                mBtn.leadingAnchor.constraint(equalTo: aTestMusic.leadingAnchor, constant: 25).isActive = true
////                mBtn.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 10).isActive = true
//                mBtn.topAnchor.constraint(equalTo: aTestMusic.topAnchor, constant: 10).isActive = true
//                mBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
//                mBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//                aTestMusicArray.append(mBtn)
//
//                let mText = UILabel()
//                mText.textAlignment = .left
//                mText.textColor = .white
//                mText.font = .boldSystemFont(ofSize: 12) //13
//        //        contentView.addSubview(mText)
//                aTestMusic.addSubview(mText)
//                mText.translatesAutoresizingMaskIntoConstraints = false
//                mText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
//                mText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
//                mText.text = "明知故犯 - HubertWu"
//                mText.isUserInteractionEnabled = true
//                mText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
//                mText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
//                aTestMusicArray.append(mText)
//                
//                let mPlayBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
////                let mPlayBtn = UIImageView(image: UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate))
//                mPlayBtn.tintColor = .white
//                aTestMusic.addSubview(mPlayBtn)
//                mPlayBtn.translatesAutoresizingMaskIntoConstraints = false
//                mPlayBtn.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
//                mPlayBtn.leadingAnchor.constraint(equalTo: mText.trailingAnchor, constant: 10).isActive = true //0
//                mPlayBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
//                mPlayBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//                mPlayBtn.isUserInteractionEnabled = true
//                mPlayBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeAudioClicked)))
//                mPlayBtn.isHidden = false
//                aTestMusicArray.append(mPlayBtn)
//                mPlayArray.append(mPlayBtn)
//                
//                let mPauseBtn = UIImageView(image: UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate))
////                let mPauseBtn = UIImageView(image: UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate))
//                mPauseBtn.tintColor = .white
//                aTestMusic.addSubview(mPauseBtn)
//                mPauseBtn.translatesAutoresizingMaskIntoConstraints = false
//                mPauseBtn.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
//                mPauseBtn.leadingAnchor.constraint(equalTo: mText.trailingAnchor, constant: 10).isActive = true //0
//                mPauseBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
//                mPauseBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//                mPauseBtn.isUserInteractionEnabled = true
//                mPauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseAudioClicked)))
//                mPauseBtn.isHidden = true
//                aTestMusicArray.append(mPauseBtn)
//                mPauseArray.append(mPauseBtn)
//                
//                //preload audio
//                let videoURL2 = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
//                let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
//                let asset2 = AVAsset(url: audioUrl)
//                let item2 = AVPlayerItem(asset: asset2)
//                player2 = AVPlayer(playerItem: item2)
//                let layer2 = AVPlayerLayer(player: player2)
//                layer2.frame = audioContainer.bounds
//                audioContainer.layer.addSublayer(layer2)
            }
            else if(l == "p") {
                //without music
//                photoText.text = data.dataTextString
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
        
//        if(!aTestMusicArray.isEmpty) {
//            let lastArrayE = aTestMusicArray[aTestMusicArray.count - 1]
//            lastArrayE.bottomAnchor.constraint(equalTo: aTestMusic.bottomAnchor, constant: 0).isActive = true
//        }
        
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
        print("photo single clicked")
        
        if(!aTestArray.isEmpty) {
            let pContainer = aTestArray[0]
            let pFrame = pContainer.frame.origin
            let aTestFrame = aTest.frame.origin

            let pointX = pFrame.x + aTestFrame.x
            let pointY = pFrame.y + aTestFrame.y
            aDelegate?.hListDidClickVcvClickPhoto(vc: self, pointX: pointX, pointY: pointY, view: pContainer, mode: PhotoTypes.P_SHOT_DETAIL)
        }
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
//            //test
//            hideCell(view: pContainer)
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
    
    func playAudio() {
//        player2?.seek(to: .zero)
//        player2?.play()
//        
//        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
//            mPlayArray[0].isHidden = true
//            mPauseArray[0].isHidden = false
//        }
        
        //test 2 > reusable view
        if(!musicConArray.isEmpty) {
            let vidC = musicConArray[0]
            if let a = vidC as? ShotSoundContentCell {
                a.playVideo()
            }
        }
    }
    func stopAudio() {
//        player2?.seek(to: .zero)
//        player2?.pause()
//        
//        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
//            mPlayArray[0].isHidden = false
//            mPauseArray[0].isHidden = true
//        }
        
        //test 2 > reusable view
        if(!musicConArray.isEmpty) {
            let vidC = musicConArray[0]
            if let a = vidC as? ShotSoundContentCell {
                a.stopVideo()
            }
        }
    }
    
    func pauseAudio() {
//        player2?.pause()
//        
//        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
//            mPlayArray[0].isHidden = false
//            mPauseArray[0].isHidden = true
//        }
        
        //test 2 > reusable view
        if(!musicConArray.isEmpty) {
            let vidC = musicConArray[0]
            if let a = vidC as? ShotSoundContentCell {
                a.pauseVideo()
            }
        }
    }
    
    func resumeAudio() {
//        player2?.play()
//        
//        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
//            mPlayArray[0].isHidden = true
//            mPauseArray[0].isHidden = false
//        }
        
        //test 2 > reusable view
        if(!musicConArray.isEmpty) {
            let vidC = musicConArray[0]
            if let a = vidC as? ShotSoundContentCell {
                a.resumeVideo()
            }
        }
    }
    
//    @objc func onResumeAudioClicked(gesture: UITapGestureRecognizer) {
//        print("resume audio clicked")
//        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
//            mPlayArray[0].isHidden = true
//            mPauseArray[0].isHidden = false
//        }
//        aDelegate?.hListDidClickVcvPlayAudio(vc: self)
//    }
//    
//    @objc func onPauseAudioClicked(gesture: UITapGestureRecognizer) {
//        print("pause audio clicked")
//        if(!mPlayArray.isEmpty && !mPauseArray.isEmpty) {
//            mPlayArray[0].isHidden = false
//            mPauseArray[0].isHidden = true
//        }
//        aDelegate?.hListDidClickVcvPlayAudio(vc: self)
//    }
}

//test > scroll view delegate for carousel of images
//extension HPhotoListAViewCell: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("HPhotoListAViewCell scrollview begin: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: true)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("HPhotoListAViewCell scrollview scroll: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: true)
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("HPhotoListAViewCell scrollview end: \(scrollView.contentOffset.y)")
//        
//        aDelegate?.hListIsScrollCarousel(isScroll: false)
//        
//        let xOffset = scrollView.contentOffset.x
//        let viewWidth = self.frame.width
//        let currentIndex = round(xOffset/viewWidth)
//        let tempCurrentIndex = Int(currentIndex)
//        print("Current item index: \(tempCurrentIndex)")
////        bubbleBox.setIndicatorSelected(index: tempCurrentIndex)
////        if(!aBubbleArray.isEmpty) {
////            aBubbleArray[0].setIndicatorSelected(index: tempCurrentIndex)
////        }
//        
//        //test > for carousel page
////        p_s = tempCurrentIndex
//        aDelegate?.hListCarouselIdx(vc: self, idx: tempCurrentIndex)
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("HPhotoListAViewCell scrollview end drag: \(scrollView.contentOffset.y)")
//        aDelegate?.hListIsScrollCarousel(isScroll: false)
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("HPhotoListAViewCell scrollview animation ended")
//
//    }
//}

extension HPhotoListAViewCell: ContentCellDelegate {
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
        let aColor = bMiniBtn.tintColor
        if(aColor == .white) {
            reactOnLoveClick()
            
            let bigLove = UIImageView(frame: CGRect(x: pointX - 16.0, y: pointY - 16.0, width: 32, height: 32))
            bigLove.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
            bigLove.tintColor = .red
            contentView.addSubview(bigLove)
            
            UIView.animate(withDuration: 0.3, animations: {
                bigLove.frame = CGRect(x: pointX - 35.0, y: pointY - 35.0, width: 70, height: 70)
            }, completion: { _ in
    //            bigLove.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: {
                    bigLove.frame = CGRect(x: pointX - 5.0, y: pointY - 5.0, width: 10, height: 10)
                }, completion: { _ in
                    bigLove.removeFromSuperview()
                })
            })
            print("photo content cell double clicked: \(pointX), \(pointY)")
        }
    }
    func contentCellDidClickSound(){
        aDelegate?.hListDidClickVcvClickSound()
    }
}

