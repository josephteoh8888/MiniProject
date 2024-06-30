//
//  MeCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol MeCellDelegate : AnyObject {
    
    func didMeCellClickUser()
    func didMeCellClickSignout()
}

class MultiPhotosMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Shots"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
//        let vImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        let imageUrl2 = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aGrid.widthAnchor.constraint(equalToConstant: 70).isActive = true //40
//        aGrid.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aGrid.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //30
        aGrid.layer.cornerRadius = 5 //10

        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 5 //10
        gifImage.sd_setImage(with: imageUrl2) //temp disable picture
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
        
        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 4).isActive = true
        bGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true //100
        bGrid.widthAnchor.constraint(equalToConstant: 70).isActive = true //75
        bGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        bGrid.layer.cornerRadius = 5 //10

        let gifImage1 = SDAnimatedImageView()
        gifImage1.contentMode = .scaleAspectFill
        gifImage1.layer.masksToBounds = true
        gifImage1.layer.cornerRadius = 5 //10
        gifImage1.sd_setImage(with: imageUrl) //temp disable picture
        bGrid.addSubview(gifImage1)
        gifImage1.translatesAutoresizingMaskIntoConstraints = false
        gifImage1.topAnchor.constraint(equalTo: bGrid.topAnchor).isActive = true
        gifImage1.leadingAnchor.constraint(equalTo: bGrid.leadingAnchor).isActive = true
        gifImage1.bottomAnchor.constraint(equalTo: bGrid.bottomAnchor).isActive = true
        gifImage1.trailingAnchor.constraint(equalTo: bGrid.trailingAnchor).isActive = true

        let cGrid = UIView()
        cGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(cGrid)
        cGrid.translatesAutoresizingMaskIntoConstraints = false
        cGrid.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 4).isActive = true
        cGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true //100
        cGrid.widthAnchor.constraint(equalToConstant: 70).isActive = true //75
        cGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
//        cGrid.bottomAnchor.constraint(equalTo: aPanelView.bottomAnchor).isActive = true //
        cGrid.layer.cornerRadius = 5 //10

        let gifImage2 = SDAnimatedImageView()
        gifImage2.contentMode = .scaleAspectFill
        gifImage2.layer.masksToBounds = true
        gifImage2.layer.cornerRadius = 5 //10
        gifImage2.sd_setImage(with: imageUrl2) //temp disable picture
        cGrid.addSubview(gifImage2)
        gifImage2.translatesAutoresizingMaskIntoConstraints = false
        gifImage2.topAnchor.constraint(equalTo: cGrid.topAnchor).isActive = true
        gifImage2.leadingAnchor.constraint(equalTo: cGrid.leadingAnchor).isActive = true
        gifImage2.bottomAnchor.constraint(equalTo: cGrid.bottomAnchor).isActive = true
        gifImage2.trailingAnchor.constraint(equalTo: cGrid.trailingAnchor).isActive = true
    }
}

class MultiLoopsMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Loops"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 90).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let vImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 90).isActive = true //60
        aGrid.widthAnchor.constraint(equalToConstant: 70).isActive = true //40
//        aGrid.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aGrid.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //30
        aGrid.layer.cornerRadius = 5 //10

        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 5 //10
        gifImage.sd_setImage(with: vImageUrl) //temp disable picture
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
        
        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 4).isActive = true
        bGrid.heightAnchor.constraint(equalToConstant: 90).isActive = true //100
        bGrid.widthAnchor.constraint(equalToConstant: 70).isActive = true //75
        bGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        bGrid.layer.cornerRadius = 5 //10

        let gifImage1 = SDAnimatedImageView()
        gifImage1.contentMode = .scaleAspectFill
        gifImage1.layer.masksToBounds = true
        gifImage1.layer.cornerRadius = 5 //10
        gifImage1.sd_setImage(with: imageUrl) //temp disable picture
        bGrid.addSubview(gifImage1)
        gifImage1.translatesAutoresizingMaskIntoConstraints = false
        gifImage1.topAnchor.constraint(equalTo: bGrid.topAnchor).isActive = true
        gifImage1.leadingAnchor.constraint(equalTo: bGrid.leadingAnchor).isActive = true
        gifImage1.bottomAnchor.constraint(equalTo: bGrid.bottomAnchor).isActive = true
        gifImage1.trailingAnchor.constraint(equalTo: bGrid.trailingAnchor).isActive = true

        let cGrid = UIView()
        cGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(cGrid)
        cGrid.translatesAutoresizingMaskIntoConstraints = false
        cGrid.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 4).isActive = true
        cGrid.heightAnchor.constraint(equalToConstant: 90).isActive = true //100
        cGrid.widthAnchor.constraint(equalToConstant: 70).isActive = true //75
        cGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
//        cGrid.bottomAnchor.constraint(equalTo: aPanelView.bottomAnchor).isActive = true //
        cGrid.layer.cornerRadius = 5 //10

        let gifImage2 = SDAnimatedImageView()
        gifImage2.contentMode = .scaleAspectFill
        gifImage2.layer.masksToBounds = true
        gifImage2.layer.cornerRadius = 5 //10
        gifImage2.sd_setImage(with: imageUrl2) //temp disable picture
        cGrid.addSubview(gifImage2)
        gifImage2.translatesAutoresizingMaskIntoConstraints = false
        gifImage2.topAnchor.constraint(equalTo: cGrid.topAnchor).isActive = true
        gifImage2.leadingAnchor.constraint(equalTo: cGrid.leadingAnchor).isActive = true
        gifImage2.bottomAnchor.constraint(equalTo: cGrid.bottomAnchor).isActive = true
        gifImage2.trailingAnchor.constraint(equalTo: cGrid.trailingAnchor).isActive = true
    }
}

class MultiPostsMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Posts"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 50).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -10).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true //60
        aGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true //40
//        aGrid.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aGrid.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //30
        aGrid.layer.cornerRadius = 5 //10

        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 5 //10
        gifImage.sd_setImage(with: imageUrl) //temp disable picture
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
//        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aHItem1ATitle.trailingAnchor.constraint(equalTo: aGrid.leadingAnchor, constant: -20).isActive = true
        aHItem1ATitle.text = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        aHItem1ATitle.numberOfLines = 3
    }
}

class MultiCommentsMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Comments"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 50).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
//        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aHItem1ATitle.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -10).isActive = true
        aHItem1ATitle.text = "Nice food, nice environment! Worth a visit."
        aHItem1ATitle.numberOfLines = 3
    }
}

class HistoryMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "History"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

class LikeMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Likes"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

class BookmarkMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Bookmarks"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

class AccountMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Account Settings"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        let notifiedBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        notifiedBox.backgroundColor = .red
        aHLightRect1.addSubview(notifiedBox)
        notifiedBox.translatesAutoresizingMaskIntoConstraints = false
        notifiedBox.centerYAnchor.constraint(equalTo: rArrowBtn.centerYAnchor, constant: 0).isActive = true
        notifiedBox.trailingAnchor.constraint(equalTo: rArrowBtn.leadingAnchor, constant: 0).isActive = true
        notifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        notifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        notifiedBox.layer.cornerRadius = 5
    }
}

class EditProfileMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Edit Profile"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
//        let notifiedBox = UIView()
////        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        notifiedBox.backgroundColor = .red
//        aHLightRect1.addSubview(notifiedBox)
//        notifiedBox.translatesAutoresizingMaskIntoConstraints = false
//        notifiedBox.centerYAnchor.constraint(equalTo: rArrowBtn.centerYAnchor, constant: 0).isActive = true
//        notifiedBox.trailingAnchor.constraint(equalTo: rArrowBtn.leadingAnchor, constant: 0).isActive = true
//        notifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
//        notifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        notifiedBox.layer.cornerRadius = 5
    }
}

class FollowingMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Followings"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

class FollowerMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Followers"
        aHLightTitle.text = "Followers & Followings"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

class BaseMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Base"
//        aHLightTitle.isHidden = true
//        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true //60
        rGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
//        rGridBG.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true //5
//        rGridBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        rGridBG.layer.cornerRadius = 5 //20
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
        rGridBG.sd_setImage(with: imageUrl)
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .boldSystemFont(ofSize: 13)
//        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 0).isActive = true //10
//        aHSubDesc.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "Petronas Twin Tower"
        
        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 0).isActive = true //5
        aHSubDesc2.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        aHSubDesc2.text = "87k saves"
        aHSubDesc2.text = "Malaysia"
        aHSubDesc2.layer.opacity = 0.4
    }
}

class LocationMeCell: UIView {
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Locations"
//        aHLightTitle.isHidden = true
//        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true //60
        rGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
//        rGridBG.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true //5
//        rGridBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        rGridBG.layer.cornerRadius = 5 //20
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
        rGridBG.sd_setImage(with: imageUrl)
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
//        aHSubDesc.font = .boldSystemFont(ofSize: 13)
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 0).isActive = true //10
//        aHSubDesc.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "DinoDreamTgX"
        
        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 0).isActive = true //5
        aHSubDesc2.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        aHSubDesc2.text = "87k saves"
        aHSubDesc2.text = "United States"
        aHSubDesc2.layer.opacity = 0.4
    }
}

class ProfileMeCell: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    weak var aDelegate : MeCellDelegate?
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
//        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileClicked)))
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .left
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Locations"
////        aHLightTitle.isHidden = true
////        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 100).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 100).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 50
        aPhoto.sd_setImage(with: imageUrl)
        
        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 16)
        aHLightRect1.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true
//        aNameText.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aNameText.centerYAnchor.constraint(equalTo: aPhoto.centerYAnchor, constant: -15).isActive = true //0
//        aNameText.numberOfLines = 0
        aNameText.text = "Michelle Lee"
//        aNameText.text = ""
        
        let aFollowAText = UILabel()
        aFollowAText.textAlignment = .center
//        aFollowAText.textColor = .white
        aFollowAText.textColor = .ddmDarkGrayColor
        aFollowAText.font = .boldSystemFont(ofSize: 13) //default 14
//        aPanelView.addSubview(aFollowAText)
        aHLightRect1.addSubview(aFollowAText)
        aFollowAText.translatesAutoresizingMaskIntoConstraints = false
        aFollowAText.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor, constant: 0).isActive = true //20
//        aFollowAText.trailingAnchor.constraint(equalTo: aFollowA.trailingAnchor, constant: -15).isActive = true
        aFollowAText.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 10).isActive = true //20
        aFollowAText.text = "Profile" //Go to Profile
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.leadingAnchor.constraint(equalTo: aFollowAText.trailingAnchor, constant: 3).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aFollowAText.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        rArrowBtn.layer.opacity = 0.5
    }
    
    @objc func onProfileClicked(gesture: UITapGestureRecognizer) {
        
        aDelegate?.didMeCellClickUser()
    }
}

class SignoutMeCell: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    weak var aDelegate : MeCellDelegate?
    
//    let aSpinner = SpinLoader()
    
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
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .red
        aHLightTitle.font = .systemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Followers"
        aHLightTitle.text = "Sign Out"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
//        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        rArrowBtn.tintColor = .white
//        aHLightRect1.addSubview(rArrowBtn)
//        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
//        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
////        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
//        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        aHLightRect1.addSubview(aSpinner)
//        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
//        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: 0).isActive = true  //0
//        aSpinner.leadingAnchor.constraint(equalTo: aHLightTitle.trailingAnchor, constant: 10).isActive = true
//        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        
        aDelegate?.didMeCellClickSignout()
    }
}
