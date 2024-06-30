//
//  PhotoPreviewPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol PhotoPreviewPanelDelegate : AnyObject {
    func didClickClosePhotoPreviewPanel()
}

class PhotoPreviewPanelView: PanelView{
    
    var panel = UIView()
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsUrl
        //.cachesDirectory is only for short term storage
    }()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelLeadingCons : CGFloat = 0.0
    weak var delegate : PhotoPreviewPanelDelegate?
    
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
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        panelLeadingCons?.isActive = true
        
        let pBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panel.addSubview(pBtn)
        pBtn.translatesAutoresizingMaskIntoConstraints = false
        pBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        pBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
        pBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        pBtn.layer.cornerRadius = 20
        pBtn.layer.opacity = 0.3
        pBtn.isUserInteractionEnabled = true
        pBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPhotoPreviewPanelClicked)))
        
        let pMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        pMiniBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(pMiniBtn)
        pMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        pMiniBtn.centerXAnchor.constraint(equalTo: pBtn.centerXAnchor).isActive = true
        pMiniBtn.centerYAnchor.constraint(equalTo: pBtn.centerYAnchor).isActive = true
        pMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        pMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //carousel of images
        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        let topMargin = 50.0 + topInset + 20.0
        scrollView.topAnchor.constraint(equalTo: pBtn.bottomAnchor, constant: 20).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true //0
        scrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        let contentWidth = viewWidth * 2
        scrollView.contentSize = CGSize(width: contentWidth, height: 400.0) //800, 280
        scrollView.isPagingEnabled = true //false
//        scrollView.delegate = self

//                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//            https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        var gifImage1 = SDAnimatedImageView()
        gifImage1.contentMode = .scaleAspectFill
        gifImage1.clipsToBounds = true
        gifImage1.sd_setImage(with: imageUrl)
//                gifImage1.layer.cornerRadius = 10 //5
        scrollView.addSubview(gifImage1)
        gifImage1.translatesAutoresizingMaskIntoConstraints = false
        gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
        gifImage1.heightAnchor.constraint(equalToConstant: 400.0).isActive = true //280
        gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        //test > click on photo
        gifImage1.isUserInteractionEnabled = true
//        gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20

        var gifImage2 = SDAnimatedImageView()
        gifImage2.contentMode = .scaleAspectFill
        gifImage2.clipsToBounds = true
        gifImage2.sd_setImage(with: gifUrl)
//                gifImage2.layer.cornerRadius = 10 //5
        scrollView.addSubview(gifImage2)
        gifImage2.translatesAutoresizingMaskIntoConstraints = false
        gifImage2.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
        gifImage2.heightAnchor.constraint(equalToConstant: 400.0).isActive = true //280
        gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 0).isActive = true //10
        
        //test > add bubble for multi images
        let bubbleBox = UIView()
        bubbleBox.backgroundColor = .clear
        panel.addSubview(bubbleBox)
        bubbleBox.translatesAutoresizingMaskIntoConstraints = false
        bubbleBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 7).isActive = true
        bubbleBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        bubbleBox.heightAnchor.constraint(equalToConstant: 3).isActive = true //30
        
        let aTab1 = UIView()
//                aTab1.backgroundColor = .white
        aTab1.backgroundColor = .yellow
        bubbleBox.addSubview(aTab1)
        aTab1.translatesAutoresizingMaskIntoConstraints = false
        aTab1.leadingAnchor.constraint(equalTo: bubbleBox.leadingAnchor, constant: 0).isActive = true //10
        aTab1.centerYAnchor.constraint(equalTo: bubbleBox.centerYAnchor).isActive = true
        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
//                aTab1.layer.opacity = 0.5 //0.5
        aTab1.layer.cornerRadius = 1
        
        let aTab2 = UIView()
        aTab2.backgroundColor = .white
        bubbleBox.addSubview(aTab2)
        aTab2.translatesAutoresizingMaskIntoConstraints = false
        aTab2.leadingAnchor.constraint(equalTo: aTab1.trailingAnchor, constant: 5).isActive = true
        aTab2.centerYAnchor.constraint(equalTo: bubbleBox.centerYAnchor).isActive = true
        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
        aTab2.layer.opacity = 0.2 //0.5
        aTab2.layer.cornerRadius = 1
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
        panel.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: bubbleBox.bottomAnchor, constant: 10).isActive = true //10
//        eUserCover.topAnchor.constraint(equalTo: pageText.bottomAnchor, constant: 10).isActive = true //10
        eUserCover.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true //20
        eUserCover.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.layer.cornerRadius = 20
        eUserCover.layer.opacity = 1.0 //default 0.3
        
        let aUserPhoto = SDAnimatedImageView()
        panel.addSubview(aUserPhoto)
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
        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkGreyColor
//        aUserPhoto.isUserInteractionEnabled = true
//        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))

        let aGridNameText = UILabel()
        aGridNameText.textAlignment = .left
        aGridNameText.textColor = .white
        aGridNameText.font = .boldSystemFont(ofSize: 14)
//        aGridNameText.font = .systemFont(ofSize: 14)
        panel.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
        aGridNameText.centerYAnchor.constraint(equalTo: aUserPhoto.centerYAnchor).isActive = true
//        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
        aGridNameText.text = "@Michelle8899"
//        aGridNameText.text = "Michael Kins"
//        aGridNameText.text = "-"
        
        //test > verified badge
        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .ddmGoldenYellowColor
//        vBtn.tintColor = .white //darkGray
        panel.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aGridNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aGridNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
        let photoText = UILabel()
        photoText.textAlignment = .left
        photoText.textColor = .white
        photoText.font = .systemFont(ofSize: 14)
        photoText.numberOfLines = 0
        panel.addSubview(photoText)
        photoText.translatesAutoresizingMaskIntoConstraints = false
        photoText.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 10).isActive = true
        photoText.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        photoText.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true //-30
//        photoText.text = data.dataTextString
        photoText.text = "caption"
//        aTestArray.append(aaText)
        
        //test 2 > design location 2
        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmDarkColor
        panel.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
//        aBox.leadingAnchor.constraint(equalTo: aText.leadingAnchor, constant: 0).isActive = true
        aBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
//        aBox.topAnchor.constraint(equalTo: photoText.bottomAnchor, constant: 20).isActive = true
        aBox.topAnchor.constraint(equalTo: photoText.bottomAnchor, constant: 20).isActive = true //20
        aBox.layer.cornerRadius = 5
        aBox.layer.opacity = 0.2 //0.3
//        aBox.isUserInteractionEnabled = true
//        aBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))

        let bBox = UIView()
        bBox.backgroundColor = .clear //yellow
        panel.addSubview(bBox)
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
        panel.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        aaText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        aaText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        aaText.text = "Location"
//        aaText.layer.opacity = 0.5
        
        //test > post performance count metrics
        let bMini = UIView()
        bMini.backgroundColor = .ddmDarkColor
        panel.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
//        bMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
//        bMini.topAnchor.constraint(equalTo: aUserNameText.bottomAnchor, constant: 10).isActive = true
        bMini.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 10).isActive = true
        bMini.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        bMini.heightAnchor.constraint(equalToConstant: 30).isActive = true //26
        bMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bMini.layer.cornerRadius = 15
        bMini.layer.opacity = 0.4 //0.2
//        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        bMiniBtn.tintColor = .white
//        bMiniBtn.tintColor = .red
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //16
        bMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        bMiniBtn.isUserInteractionEnabled = true
//        bMiniBtn.layer.opacity = 0.5
//        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 10)
        panel.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.leadingAnchor.constraint(equalTo: bMini.trailingAnchor, constant: 2).isActive = true
        bText.centerYAnchor.constraint(equalTo: bMini.centerYAnchor).isActive = true
        bText.text = ""
//        bText.layer.opacity = 0.5
        
        let cMini = UIView()
        cMini.backgroundColor = .ddmDarkColor
        panel.addSubview(cMini)
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
        panel.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        cMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true //16
//        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.layer.opacity = 0.5
//        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentBtnClicked)))
        
        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
        panel.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.leadingAnchor.constraint(equalTo: cMini.trailingAnchor, constant: 2).isActive = true
        cText.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cText.text = ""
//        cText.layer.opacity = 0.5
        
        let dMini = UIView()
        dMini.backgroundColor = .ddmDarkColor
        panel.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
//        dMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        dMini.topAnchor.constraint(equalTo: cMini.topAnchor, constant: 0).isActive = true
        dMini.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
        dMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dMini.layer.cornerRadius = 15
        dMini.layer.opacity = 0.4 //0.2
//        dMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat_on")?.withRenderingMode(.alwaysTemplate))
//        dMiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
        dMiniBtn.tintColor = .white
//        dMiniBtn.tintColor = .ddmGoldenYellowColor
        panel.addSubview(dMiniBtn)
        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //16
        dMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        dMiniBtn.isUserInteractionEnabled = true
//        dMiniBtn.layer.opacity = 0.5
//        dMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
        let dText = UILabel()
        dText.textAlignment = .left
        dText.textColor = .white
        dText.font = .boldSystemFont(ofSize: 10)
        panel.addSubview(dText)
        dText.clipsToBounds = true
        dText.translatesAutoresizingMaskIntoConstraints = false
        dText.leadingAnchor.constraint(equalTo: dMini.trailingAnchor, constant: 2).isActive = true
        dText.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dText.text = ""
//        dText.layer.opacity = 0.5
        
        let eMini = UIView()
        eMini.backgroundColor = .ddmDarkColor
//        eMini.backgroundColor = .green
        panel.addSubview(eMini)
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
        panel.addSubview(eMiniBtn)
        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        eMiniBtn.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eMiniBtn.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: -2).isActive = true //-2
        eMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //22
        eMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        eMiniBtn.isUserInteractionEnabled = true
        
        //test > gesture recognizer for dragging panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVPreviewPanelPanGesture))
        self.addGestureRecognizer(panelPanGesture)
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
    }
    
    @objc func onBackPhotoPreviewPanelClicked(gesture: UITapGestureRecognizer) {
        
        closePanel(isAnimated: true)
    }
    
    var direction = "na"
    @objc func onVPreviewPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            
            print("t1 onVPreviewPanelPanGesture begin: ")
            self.currentPanelLeadingCons = self.panelLeadingCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            //test > determine direction of scroll
//            print("t1 onVPreviewPanelPanGesture changed: \(x), \(self.soundPanelLeadingCons!.constant)")
            if(direction == "na") {
                if(abs(x) > abs(y)) {
                    direction = "x"
                } else {
                    direction = "y"
                }
            }
            if(direction == "x") {
                var newX = self.currentPanelLeadingCons + x
                if(newX < 0) {
                    newX = 0
                }
                self.panelLeadingCons?.constant = newX
            }
        } else if(gesture.state == .ended){
            
            print("t1 onVPreviewPanelPanGesture ended: ")
            if(self.panelLeadingCons!.constant - self.currentPanelLeadingCons < 75) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelLeadingCons?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            } else {
                closePanel(isAnimated: true)
            }
            
            //test > determine direction of scroll
            direction = "na"
        }
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelLeadingCons?.constant = self.frame.width
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                //move back to origin
                self.panelLeadingCons?.constant = 0
                self.delegate?.didClickClosePhotoPreviewPanel()
            })
        } else {
            self.removeFromSuperview()
            
            self.delegate?.didClickClosePhotoPreviewPanel()
        }
    }
}

extension PhotoFinalizePanelView: PhotoPreviewPanelDelegate{
    func didClickClosePhotoPreviewPanel() {

    }
}
