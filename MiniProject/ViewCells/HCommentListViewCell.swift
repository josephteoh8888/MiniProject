//
//  HCommentListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > horizontal list viewcell for comment
class HCommentListViewCell: UICollectionViewCell {
    static let identifier = "HCommentListViewCell"
    
    let aGridNameText = UILabel()
    let aText = UILabel()
    
    let bMiniBtn = UIImageView()
    let dMiniBtn = UIImageView()
    
    //test > dynamic method for various cells format
    let aTest = UIView()
    var aTestArray = [UIView]()
    let aTest2 = UIView()
    var aTest2Array = [UIView]()
    let aConnector = UIView()
    
    let bText = UILabel()
    let cText = UILabel()
    let dText = UILabel()
    let eText = UILabel()
    
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
        aResult.backgroundColor = .ddmDarkColor
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
        aResult.layer.opacity = 0.1 //0.3
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
        aResult.addGestureRecognizer(atapGR)
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
        contentView.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        eUserCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        eUserCover.heightAnchor.constraint(equalToConstant: 28).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: 28).isActive = true
        eUserCover.layer.cornerRadius = 14
        eUserCover.layer.opacity = 1.0 //default 0.3
        
        let aUserPhoto = SDAnimatedImageView()
        contentView.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 28).isActive = true //24
        aUserPhoto.heightAnchor.constraint(equalToConstant: 28).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 14
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkGreyColor
        
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
        contentView.addSubview(aGridNameText)
        aGridNameText.translatesAutoresizingMaskIntoConstraints = false
//        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
//        aGridNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 5).isActive = true
//        aGridNameText.bottomAnchor.constraint(equalTo: eUserCover.bottomAnchor).isActive = true
        aGridNameText.topAnchor.constraint(equalTo: aUserPhoto.topAnchor).isActive = true
        aGridNameText.leadingAnchor.constraint(equalTo: eUserCover.trailingAnchor, constant: 5).isActive = true
//        aGridNameText.text = "Michael Gerber"
        
        //test > verified badge
        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
        vBtn.tintColor = .yellow
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
        aUserNameText.layer.opacity = 0.3 //0.5

        contentView.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 0).isActive = true
        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
        
////        let aText = UILabel()
//        aText.textAlignment = .left
//        aText.textColor = .white
//        aText.font = .systemFont(ofSize: 13)
//        contentView.addSubview(aText)
//        aText.numberOfLines = 0
//        aText.translatesAutoresizingMaskIntoConstraints = false
////        aText.topAnchor.constraint(equalTo: aUserPhoto.bottomAnchor, constant: 10).isActive = true
//        aText.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 10).isActive = true
////        aText.leadingAnchor.constraint(equalTo: aUserPhoto.leadingAnchor, constant: 0).isActive = true
//        aText.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
//        aText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
////        aText.text = "Nice food, nice environment! Worth a visit."
//        aText.text = "-"
        
//        var gifImage1 = SDAnimatedImageView()
//        gifImage1.contentMode = .scaleAspectFill
//        gifImage1.clipsToBounds = true
//        let gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        gifImage1.sd_setImage(with: gifUrl1)
//        gifImage1.layer.cornerRadius = 10 //5
//        contentView.addSubview(gifImage1)
//        gifImage1.translatesAutoresizingMaskIntoConstraints = false
//        gifImage1.widthAnchor.constraint(equalToConstant: 100).isActive = true //ori: 24
//        gifImage1.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        gifImage1.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 10).isActive = true
//        gifImage1.leadingAnchor.constraint(equalTo: aGridNameText.leadingAnchor, constant: 0).isActive = true
        
        //test > post performance count metrics
        let bMini = UIView()
        bMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
//        bMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
//        bMini.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 20).isActive = true
        bMini.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true
//        bMini.topAnchor.constraint(equalTo: gifImage1.bottomAnchor, constant: 20).isActive = true
//        bMini.leadingAnchor.constraint(equalTo: aText.leadingAnchor, constant: 0).isActive = true
        bMini.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
        bMini.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
        bMini.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bMini.layer.cornerRadius = 13
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
        bMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        bMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
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
        bText.text = "478"
//        bText.layer.opacity = 0.5
        
        let cMini = UIView()
        cMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
//        cMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        cMini.topAnchor.constraint(equalTo: bMini.topAnchor, constant: 0).isActive = true
        cMini.leadingAnchor.constraint(equalTo: bText.trailingAnchor, constant: 20).isActive = true
        cMini.heightAnchor.constraint(equalToConstant: 26).isActive = true //30
        cMini.widthAnchor.constraint(equalToConstant: 26).isActive = true
        cMini.layer.cornerRadius = 13
        cMini.layer.opacity = 0.4 //0.2
//        cMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
//        cMiniBtn.image = UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate)
        cMiniBtn.tintColor = .white
        contentView.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //16
        cMiniBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //16
        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.layer.opacity = 0.5
//        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
//        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.leadingAnchor.constraint(equalTo: cMini.trailingAnchor, constant: 2).isActive = true
        cText.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cText.text = "1309"
//        cText.layer.opacity = 0.5
        
        let dMini = UIView()
        dMini.backgroundColor = .ddmDarkColor
        contentView.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
//        dMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        dMini.topAnchor.constraint(equalTo: cMini.topAnchor, constant: 0).isActive = true
        dMini.leadingAnchor.constraint(equalTo: cText.trailingAnchor, constant: 20).isActive = true
        dMini.heightAnchor.constraint(equalToConstant: 26).isActive = true
        dMini.widthAnchor.constraint(equalToConstant: 26).isActive = true
        dMini.layer.cornerRadius = 13
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
        dMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //16
        dMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
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
        dText.text = "512"
//        dText.layer.opacity = 0.5
        
        let eMini = UIView()
        eMini.backgroundColor = .ddmDarkColor
//        eMini.backgroundColor = .green
        contentView.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
//        eMini.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        eMini.topAnchor.constraint(equalTo: dMini.topAnchor, constant: 0).isActive = true
        eMini.leadingAnchor.constraint(equalTo: dText.trailingAnchor, constant: 20).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 26).isActive = true
        eMini.widthAnchor.constraint(equalToConstant: 26).isActive = true
        eMini.layer.cornerRadius = 13
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
        eMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //22
        eMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        eMiniBtn.isUserInteractionEnabled = true
//        eMiniBtn.layer.opacity = 0.5
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
        eText.text = "18.3K"
//        eText.layer.opacity = 0.5
        
        //test > dynamic cell for comment
        contentView.addSubview(aTest2)
        aTest2.translatesAutoresizingMaskIntoConstraints = false
        aTest2.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 0).isActive = true
        aTest2.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: 0).isActive = true
        aTest2.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 10).isActive = true
        
        //test > inter-post connector lines
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aConnector.backgroundColor = .ddmDarkColor
        contentView.addSubview(aConnector)
        aConnector.clipsToBounds = true
        aConnector.translatesAutoresizingMaskIntoConstraints = false
        aConnector.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor, constant: 0).isActive = true
        aConnector.widthAnchor.constraint(equalToConstant: 3).isActive = true //default: 50
        aConnector.bottomAnchor.constraint(equalTo: aTest2.topAnchor, constant: 0).isActive = true
        aConnector.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 10).isActive = true
//        aConnector.layer.opacity = 0.5
        aConnector.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        
        aGridNameText.text = "-"
//        aText.text = "-"
        
        for e in aTestArray {
            e.removeFromSuperview()
        }
        aTestArray.removeAll()
        
        for e in aTest2Array {
            e.removeFromSuperview()
        }
        aTest2Array.removeAll()
        
        aConnector.isHidden = true
    }
    
//    func configure(data: String) {
//        aGridNameText.text = "Michael Gerber"
//        aText.text = data
//    }
    
    func configure(data: BaseData) {
//    func configure(data: PostData) {
        aGridNameText.text = "Michael Gerber"
        
        //test > dynamic create ui for various data types in sequence
        let dataL = data.dataArray
        var count = 0
        for l in dataL {
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
                aaText.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
                aaText.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true //-30
//                aaText.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
                aaText.text = data.dataTextString
                aTestArray.append(aaText)
            }
            else if(l == "p") {
                //single image
                let gifImage1 = SDAnimatedImageView()
                gifImage1.contentMode = .scaleAspectFill
                gifImage1.clipsToBounds = true
                let gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
                gifImage1.sd_setImage(with: gifUrl1)
                gifImage1.layer.cornerRadius = 10 //5
                aTest.addSubview(gifImage1)
                gifImage1.translatesAutoresizingMaskIntoConstraints = false
                gifImage1.widthAnchor.constraint(equalToConstant: 180).isActive = true //150
                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
                if(aTestArray.isEmpty) {
                    gifImage1.topAnchor.constraint(equalTo: aTest.topAnchor, constant: 20).isActive = true
                } else {
                    let lastArrayE = aTestArray[aTestArray.count - 1]
                    gifImage1.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true
                }
                gifImage1.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
                aTestArray.append(gifImage1)
                gifImage1.isUserInteractionEnabled = true
                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20
                
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
//                scrollView.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 0).isActive = true
//                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: 0).isActive = true
//                scrollView.heightAnchor.constraint(equalToConstant: 280).isActive = true  //250
//                scrollView.showsHorizontalScrollIndicator = false
//                scrollView.alwaysBounceHorizontal = true
//                scrollView.contentSize = CGSize(width: 720, height: 280) //720, 250
//        //        scrollView.contentSize = CGSize(width: 360, height: 280)
////                scrollView.delegate = self
//                aTestArray.append(scrollView)
//
//                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//
//                var gifImage1 = SDAnimatedImageView()
//                gifImage1.contentMode = .scaleAspectFill
//                gifImage1.clipsToBounds = true
//                gifImage1.sd_setImage(with: gifUrl)
//                gifImage1.layer.cornerRadius = 10 //5
//                scrollView.addSubview(gifImage1)
//                gifImage1.translatesAutoresizingMaskIntoConstraints = false
//                gifImage1.widthAnchor.constraint(equalToConstant: 180).isActive = true //150
//                gifImage1.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
//                gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 53).isActive = true
//
//                var gifImage2 = SDAnimatedImageView()
//                gifImage2.contentMode = .scaleAspectFill
//                gifImage2.clipsToBounds = true
//                gifImage2.sd_setImage(with: gifUrl)
//                gifImage2.layer.cornerRadius = 10 //5
//                scrollView.addSubview(gifImage2)
//                gifImage2.translatesAutoresizingMaskIntoConstraints = false
//                gifImage2.widthAnchor.constraint(equalToConstant: 180).isActive = true //150
//                gifImage2.heightAnchor.constraint(equalToConstant: 280).isActive = true //250
//                gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//                gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 10).isActive = true
            }
            else if(l == "q") {
                let aQPost = UIView()
                aQPost.backgroundColor = .ddmDarkColor //.ddmDarkColor
                aTest.addSubview(aQPost)
                aQPost.translatesAutoresizingMaskIntoConstraints = false
                aQPost.leadingAnchor.constraint(equalTo: aTest.leadingAnchor, constant: 53).isActive = true
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
                qGridNameText.font = .boldSystemFont(ofSize: 13)
                aQPost.addSubview(qGridNameText)
                qGridNameText.translatesAutoresizingMaskIntoConstraints = false
                qGridNameText.centerYAnchor.constraint(equalTo: qUserPhoto.centerYAnchor).isActive = true
                qGridNameText.leadingAnchor.constraint(equalTo: qUserPhoto.trailingAnchor, constant: 10).isActive = true
                qGridNameText.text = "Maryland Jen"

                let qText = UILabel()
                qText.textAlignment = .left
                qText.textColor = .white
                qText.font = .systemFont(ofSize: 13)
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
                
                let e2UserCover = UIView()
                e2UserCover.backgroundColor = .clear
                aCPost.addSubview(e2UserCover)
                e2UserCover.translatesAutoresizingMaskIntoConstraints = false
                e2UserCover.topAnchor.constraint(equalTo: aCPost.topAnchor, constant: 10).isActive = true //20
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
                b2Mini.bottomAnchor.constraint(equalTo: aCPost.bottomAnchor, constant: -10).isActive = true //-20
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
        //        c2Mini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
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
//                c2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
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
                d2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
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
                
                let aConnector = UIView()
                aConnector.backgroundColor = .ddmDarkColor
                aCPost.addSubview(aConnector)
                aConnector.clipsToBounds = true
                aConnector.translatesAutoresizingMaskIntoConstraints = false
                aConnector.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor, constant: 0).isActive = true
                aConnector.widthAnchor.constraint(equalToConstant: 3).isActive = true //default: 50
                aConnector.bottomAnchor.constraint(equalTo: aCPost.bottomAnchor, constant: 0).isActive = true
                aConnector.topAnchor.constraint(equalTo: e2UserCover.bottomAnchor, constant: 10).isActive = true
                aConnector.isHidden = false
                
                if(count == dataL.count - 1) {
                    aConnector.isHidden = true
                }
            }
            
            count += 1
        }
        
        if(dataL.contains("c")) {
            aConnector.isHidden = false
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
    
    @objc func onSingleClicked(gesture: UITapGestureRecognizer) {
        print("comment single clicked")
    }
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        print("comment photo clicked")
    }
    @objc func onQuotePostClicked(gesture: UITapGestureRecognizer) {
        print("comment quote clicked")
    }
    @objc func onLoveClicked(gesture: UITapGestureRecognizer) {
        reactOnLoveClick()
    }
    @objc func onBookmarkClicked(gesture: UITapGestureRecognizer) {
        reactOnBookmarkClick()
    }
    
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
}
