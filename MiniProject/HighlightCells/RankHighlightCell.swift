//
//  RankHighlightCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class RankHighlightCell: UIView {
    
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
        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 60).isActive = true //50
        rGridBG.widthAnchor.constraint(equalToConstant: 60).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //5
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
//        rGridBG.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true //5
//        rGridBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        rGridBG.layer.cornerRadius = 5 //20
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
        rGridBG.sd_setImage(with: imageUrl)

        let rText = UILabel()
        rText.textAlignment = .left
        rText.textColor = .white
        rText.font = .boldSystemFont(ofSize: 13) //13
//        aHLightSection.addSubview(rText)
        aHLightRect1.addSubview(rText)
        rText.translatesAutoresizingMaskIntoConstraints = false
        rText.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//        rText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: 0).isActive = true
//                rText.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true
        rText.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 5).isActive = true //20
        rText.text = "Top US 100 Hits Weekly "

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .boldSystemFont(ofSize: 15)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rText.bottomAnchor, constant: 5).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "#11"
//                aHSubDesc.layer.opacity = 0.7

        let aHSubDescSymbol = UIImageView(image: UIImage(named:"icon_round_arrow_up")?.withRenderingMode(.alwaysTemplate))
        aHSubDescSymbol.tintColor = .green
//        aHLightSection.addSubview(aHSubDescSymbol)
        aHLightRect1.addSubview(aHSubDescSymbol)
        aHSubDescSymbol.translatesAutoresizingMaskIntoConstraints = false
        aHSubDescSymbol.leadingAnchor.constraint(equalTo: aHSubDesc.trailingAnchor, constant: 0).isActive = true
        aHSubDescSymbol.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDescSymbol.heightAnchor.constraint(equalToConstant: 28).isActive = true
        aHSubDescSymbol.widthAnchor.constraint(equalToConstant: 28).isActive = true
//                aHSubDescSymbol.layer.opacity = 0.5

        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.leadingAnchor.constraint(equalTo: aHSubDescSymbol.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc2.text = "923k streams"
        aHSubDesc2.layer.opacity = 0.4

        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: rText.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

class RankSizeMHighlightCell: UIView {
    
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
        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
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
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Top US 100 Hits Weekly "
        
        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 60).isActive = true //50
        rGridBG.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        rGridBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //5
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true //5
//        rGridBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        rGridBG.layer.cornerRadius = 5 //20
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
        rGridBG.sd_setImage(with: imageUrl)

//        let rText = UILabel()
//        rText.textAlignment = .left
//        rText.textColor = .white
//        rText.font = .boldSystemFont(ofSize: 13) //13
////        aHLightSection.addSubview(rText)
//        aHLightRect1.addSubview(rText)
//        rText.translatesAutoresizingMaskIntoConstraints = false
//        rText.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
////        rText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: 0).isActive = true
////                rText.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true
//        rText.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 5).isActive = true //20
//        rText.text = "Top US 100 Hits Weekly "

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .boldSystemFont(ofSize: 15)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc.topAnchor.constraint(equalTo: rText.bottomAnchor, constant: 5).isActive = true //20
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 10).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "#11"
//                aHSubDesc.layer.opacity = 0.7

        let aHSubDescSymbol = UIImageView(image: UIImage(named:"icon_round_arrow_up")?.withRenderingMode(.alwaysTemplate))
        aHSubDescSymbol.tintColor = .green
//        aHLightSection.addSubview(aHSubDescSymbol)
        aHLightRect1.addSubview(aHSubDescSymbol)
        aHSubDescSymbol.translatesAutoresizingMaskIntoConstraints = false
        aHSubDescSymbol.leadingAnchor.constraint(equalTo: aHSubDesc.trailingAnchor, constant: 0).isActive = true
        aHSubDescSymbol.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDescSymbol.heightAnchor.constraint(equalToConstant: 28).isActive = true
        aHSubDescSymbol.widthAnchor.constraint(equalToConstant: 28).isActive = true
//                aHSubDescSymbol.layer.opacity = 0.5

        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 5).isActive = true //20
        aHSubDesc2.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc2.text = "923k streams"
        aHSubDesc2.layer.opacity = 0.4

        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}
