//
//  CommentChainCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 15/08/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol CChainCellDelegate : AnyObject {
    func cChainDidClickComment()
    func cChainDidClickLove()
    func cChainDidClickShare()
    func cChainDidClickClickUser()
    func cChainDidClickClickPlace()
    func cChainDidClickClickSound()
    func cChainDidClickClickPost()
    func cChainDidClickClickPhoto(cell: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func cChainDidClickClickVideo(cell: UIView, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func cChainIsScrollCarousel(isScroll: Bool)
    
    //test > carousel photo scroll page
    func cChainCarouselIdx(cell: UIView, idx: Int)
    
    //test > click play sound
    func cChainDidClickPlayAudio(cell: UIView)
}

//test > custom cell for chaining comments
class CommentChainCell: UIView {
    let aCPost = UIView()

    let a2GridNameText = UILabel()
//    let a2Text = UILabel()
    let a2UserPhoto = SDAnimatedImageView()
    let vBtn = UIImageView()
    let a2UserNameText = UILabel()
    
    let b2MiniBtn = UIImageView()
    let d2MiniBtn = UIImageView()
    
    let b2Text = UILabel()
    let c2Text = UILabel()
    let d2Text = UILabel()
    let e2Text = UILabel()
    
    //test > dynamic method for various cells format
    let aTest = UIView()
    var aTestArray = [UIView]()
    
    let aConnector = UIView()
    
    weak var aDelegate : CChainCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

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
        
        self.addSubview(aCPost)
        aCPost.translatesAutoresizingMaskIntoConstraints = false
        aCPost.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        aCPost.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aCPost.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aCPost.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        aCPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
        
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleClicked))
        atapGR.numberOfTapsRequired = 1
        aCPost.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
        tapGR.numberOfTapsRequired = 2
        aCPost.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR) //enable double tap
        
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

//        let a2UserPhoto = SDAnimatedImageView()
        aCPost.addSubview(a2UserPhoto)
        a2UserPhoto.translatesAutoresizingMaskIntoConstraints = false
        a2UserPhoto.widthAnchor.constraint(equalToConstant: 28).isActive = true //36
        a2UserPhoto.heightAnchor.constraint(equalToConstant: 28).isActive = true
        a2UserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
        a2UserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
        a2UserPhoto.contentMode = .scaleAspectFill
        a2UserPhoto.layer.masksToBounds = true
        a2UserPhoto.layer.cornerRadius = 14
//        let image2Url = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        a2UserPhoto.sd_setImage(with: image2Url)
        a2UserPhoto.backgroundColor = .ddmDarkColor
        a2UserPhoto.isUserInteractionEnabled = true
        a2UserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
//        let a2GridNameText = UILabel()
        a2GridNameText.textAlignment = .left
        a2GridNameText.textColor = .white
        a2GridNameText.font = .boldSystemFont(ofSize: 13) //14
        aCPost.addSubview(a2GridNameText)
        a2GridNameText.translatesAutoresizingMaskIntoConstraints = false
        a2GridNameText.topAnchor.constraint(equalTo: a2UserPhoto.topAnchor).isActive = true
        a2GridNameText.leadingAnchor.constraint(equalTo: a2UserPhoto.trailingAnchor, constant: 5).isActive = true
//        a2GridNameText.text = "Mic1809"
//        a2GridNameText.text = "Michael Kins"
        a2GridNameText.text = "-"
        
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .white //darkGray
        aCPost.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: a2GridNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: a2GridNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true

//        let a2UserNameText = UILabel()
        a2UserNameText.textAlignment = .left
        a2UserNameText.textColor = .white
        a2UserNameText.font = .systemFont(ofSize: 12)
        aCPost.addSubview(a2UserNameText)
        a2UserNameText.translatesAutoresizingMaskIntoConstraints = false
        a2UserNameText.topAnchor.constraint(equalTo: a2GridNameText.bottomAnchor).isActive = true
        a2UserNameText.leadingAnchor.constraint(equalTo: a2GridNameText.leadingAnchor, constant: 0).isActive = true
        a2UserNameText.text = "-"
//        a2UserNameText.text = "@mic1809"
        a2UserNameText.layer.opacity = 0.3 //0.5
        
//        a2Text.textAlignment = .left
//        a2Text.textColor = .white
//        a2Text.font = .systemFont(ofSize: 14) //14 //13
//        a2Text.numberOfLines = 0
//        aCPost.addSubview(a2Text)
//        a2Text.translatesAutoresizingMaskIntoConstraints = false
//        a2Text.topAnchor.constraint(equalTo: a2UserPhoto.bottomAnchor, constant: 10).isActive = true
//        a2Text.leadingAnchor.constraint(equalTo: a2GridNameText.leadingAnchor, constant: 0).isActive = true
//        a2Text.trailingAnchor.constraint(equalTo: aCPost.trailingAnchor, constant: -20).isActive = true
//        a2Text.text = ""
        
        //test
        aCPost.addSubview(aTest)
        aTest.translatesAutoresizingMaskIntoConstraints = false
        aTest.leadingAnchor.constraint(equalTo: aCPost.leadingAnchor, constant: 0).isActive = true
        aTest.trailingAnchor.constraint(equalTo: aCPost.trailingAnchor, constant: 0).isActive = true
//        aTest.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 0).isActive = true
        aTest.topAnchor.constraint(equalTo: a2UserPhoto.bottomAnchor, constant: 0).isActive = true
//        aTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSingleClicked)))
        
        let b2Mini = UIView()
        b2Mini.backgroundColor = .ddmDarkColor
        aCPost.addSubview(b2Mini)
        b2Mini.translatesAutoresizingMaskIntoConstraints = false
        b2Mini.topAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 20).isActive = true //10
//        b2Mini.topAnchor.constraint(equalTo: a2Text.bottomAnchor, constant: 10).isActive = true
        b2Mini.leadingAnchor.constraint(equalTo: a2GridNameText.leadingAnchor, constant: 0).isActive = true
        b2Mini.bottomAnchor.constraint(equalTo: aCPost.bottomAnchor, constant: -10).isActive = true //-20
        b2Mini.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        b2Mini.widthAnchor.constraint(equalToConstant: 26).isActive = true
        b2Mini.layer.cornerRadius = 13
        b2Mini.layer.opacity = 0.4 //0.2
//        bMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))

//        let b2MiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        b2MiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
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
        b2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))

//        let b2Text = UILabel()
        b2Text.textAlignment = .left
        b2Text.textColor = .white
        b2Text.font = .boldSystemFont(ofSize: 10)
        aCPost.addSubview(b2Text)
        b2Text.clipsToBounds = true
        b2Text.translatesAutoresizingMaskIntoConstraints = false
        b2Text.leadingAnchor.constraint(equalTo: b2Mini.trailingAnchor, constant: 2).isActive = true
        b2Text.centerYAnchor.constraint(equalTo: b2Mini.centerYAnchor).isActive = true
        b2Text.text = "-"
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

//        let c2Text = UILabel()
        c2Text.textAlignment = .left
        c2Text.textColor = .white
        c2Text.font = .boldSystemFont(ofSize: 10)
        aCPost.addSubview(c2Text)
        c2Text.clipsToBounds = true
        c2Text.translatesAutoresizingMaskIntoConstraints = false
        c2Text.leadingAnchor.constraint(equalTo: c2Mini.trailingAnchor, constant: 2).isActive = true
        c2Text.centerYAnchor.constraint(equalTo: c2Mini.centerYAnchor).isActive = true
        c2Text.text = "-"
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

//        let d2MiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_round_repeat_on")?.withRenderingMode(.alwaysTemplate))
        d2MiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
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

//        let d2Text = UILabel()
        d2Text.textAlignment = .left
        d2Text.textColor = .white
        d2Text.font = .boldSystemFont(ofSize: 10)
        aCPost.addSubview(d2Text)
        d2Text.clipsToBounds = true
        d2Text.translatesAutoresizingMaskIntoConstraints = false
        d2Text.leadingAnchor.constraint(equalTo: d2Mini.trailingAnchor, constant: 2).isActive = true
        d2Text.centerYAnchor.constraint(equalTo: d2Mini.centerYAnchor).isActive = true
        d2Text.text = "-"
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
        e2MiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))

//        let e2Text = UILabel()
        e2Text.textAlignment = .left
        e2Text.textColor = .white
        e2Text.font = .boldSystemFont(ofSize: 10)
        aCPost.addSubview(e2Text)
        e2Text.clipsToBounds = true
        e2Text.translatesAutoresizingMaskIntoConstraints = false
        e2Text.leadingAnchor.constraint(equalTo: e2Mini.trailingAnchor, constant: 2).isActive = true
        e2Text.centerYAnchor.constraint(equalTo: e2Mini.centerYAnchor).isActive = true
        e2Text.text = "-"
//        e2Text.layer.opacity = 0.5
        
//        let aConnector = UIView()
        aConnector.backgroundColor = .ddmDarkColor
        aCPost.addSubview(aConnector)
        aConnector.clipsToBounds = true
        aConnector.translatesAutoresizingMaskIntoConstraints = false
        aConnector.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor, constant: 0).isActive = true
        aConnector.widthAnchor.constraint(equalToConstant: 3).isActive = true //default: 50
        aConnector.bottomAnchor.constraint(equalTo: aCPost.bottomAnchor, constant: 0).isActive = true
        aConnector.topAnchor.constraint(equalTo: e2UserCover.bottomAnchor, constant: 10).isActive = true
        aConnector.isHidden = false
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

                    self.a2GridNameText.text = "Michael Kins"
                    self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
                    
                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                    self.a2UserPhoto.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.a2GridNameText.text = "-"
                    self.vBtn.image = nil
                    
                    let imageUrl = URL(string: "")
                    self.a2UserPhoto.sd_setImage(with: imageUrl)
                    
                }
                break
            }
        }
    }
    //*
    
    func configure(data: BaseData) {
        
//        a2GridNameText.text = "Michael Kins"
        asyncConfigure(data: "")
        
        a2UserNameText.text = "2hr . 200k views"
        
        let dataL = data.dataArray
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
//                let gifUrl1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
                let gifUrl1 = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
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
//                gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20
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
//                aQPost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onQuotePostClicked)))

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
        }
        
        if(!aTestArray.isEmpty) {
            let lastArrayE = aTestArray[aTestArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aTest.bottomAnchor, constant: 0).isActive = true
        }
        
        //populate data count
        let dataC = data.dataCount
        if let loveC = dataC["love"] {
            b2Text.text = String(loveC)
        }
        if let commentC = dataC["comment"] {
            c2Text.text = String(commentC)
        }
        if let bookmarkC = dataC["bookmark"] {
            d2Text.text = String(bookmarkC)
        }
        if let shareC = dataC["share"] {
            e2Text.text = String(shareC)
        }
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.cChainDidClickClickUser()
    }
    
    @objc func onSingleClicked(gesture: UITapGestureRecognizer) {
        print("comment chain single clicked")
        aDelegate?.cChainDidClickClickPost()
    }
    @objc func onDoubleClicked(gesture: UITapGestureRecognizer) {
        print("comment chain double clicked")
        let aColor = b2MiniBtn.tintColor
        if(aColor == .white) {
            reactOnLoveClick()
        }
    }
    
    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
        print("comment chain share clicked")
    }
    
    @objc func onLoveClicked(gesture: UITapGestureRecognizer) {
        reactOnLoveClick()
    }
    @objc func onBookmarkClicked(gesture: UITapGestureRecognizer) {
        reactOnBookmarkClick()
    }
    
    func reactOnLoveClick() {
        let aColor = b2MiniBtn.tintColor
        if(aColor == .white) {
            b2MiniBtn.tintColor = .red
        } else {
            b2MiniBtn.tintColor = .white
        }
    }
    func reactOnBookmarkClick() {
        let aColor = d2MiniBtn.tintColor
        if(aColor == .white) {
            d2MiniBtn.tintColor = .ddmGoldenYellowColor
        } else {
            d2MiniBtn.tintColor = .white
        }
    }
    
    func hideConnector() {
        aConnector.isHidden = true
    }
}
