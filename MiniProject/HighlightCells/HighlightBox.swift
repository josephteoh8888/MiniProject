//
//  HighlightBox.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > another design for suggested user accounts
class DiscoverUserSizeLHighlightCell: HighlightCell {
//class DiscoverUserSizeLHighlightCell: UIView {
    
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
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Creators"
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 30
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "Vicky Chia"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "@vickych"
        aHSubDesc.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHItemTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        let aPhoto1A = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 30
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Micole Yan"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "@micoley"
        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrow1ABtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrow1ABtn.tintColor = .white
        aHLightRect1.addSubview(rArrow1ABtn)
        rArrow1ABtn.translatesAutoresizingMaskIntoConstraints = false
        rArrow1ABtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrow1ABtn.centerYAnchor.constraint(equalTo: aHItem1ATitle.centerYAnchor).isActive = true
        rArrow1ABtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.layer.opacity = 0.5
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickUser(id: "")
    }
}

class DiscoverUserSizeMHighlightCell: HighlightCell {
//class DiscoverUserSizeMHighlightCell: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    
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
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
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
//        aHLightTitle.text = "Related Creators"
//        aHLightTitle.text = "Suggested For You"
        aHLightTitle.text = "Discover More"
        
        aTab1.backgroundColor = .white
        aHLightRect1.addSubview(aTab1)
        aTab1.translatesAutoresizingMaskIntoConstraints = false
        aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -14).isActive = true //10
        aTab1.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
//                aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 10).isActive = true //10
//                aTab1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -4).isActive = true
        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
        aTab1.layer.opacity = 0.2 //0.5
        aTab1.layer.cornerRadius = 1
        
        aTab2.backgroundColor = .white
        aHLightRect1.addSubview(aTab2)
        aTab2.translatesAutoresizingMaskIntoConstraints = false
        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
        aTab2.layer.opacity = 0.5 //0.5
        aTab2.layer.cornerRadius = 1
        
        let scrollViewWidth = viewWidth - 20.0*2
//        let scrollViewWidth = 170.0
        let totalScrollWidth = scrollViewWidth * 2
        
        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-10
        scrollView1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 60)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self
        
        let aScroll1 = UIView()
        scrollView1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aScroll2 = UIView()
        scrollView1.addSubview(aScroll2)
        aScroll2.translatesAutoresizingMaskIntoConstraints = false
        aScroll2.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll2.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        aScroll2.leadingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: 0).isActive = true
        aScroll2.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
//        let aScroll3 = UIView()
//        scrollView1.addSubview(aScroll3)
//        aScroll3.translatesAutoresizingMaskIntoConstraints = false
//        aScroll3.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
//        aScroll3.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
//        aScroll3.leadingAnchor.constraint(equalTo: aScroll2.trailingAnchor, constant: 0).isActive = true
//        aScroll3.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aPhoto = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto)
        aScroll1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 30
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItemTitle)
        aScroll1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "Vicky Chia"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc)
        aScroll1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "@vickych"
        aHSubDesc.layer.opacity = 0.4

        let aPhoto1A = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto1A)
//        aScroll2.addSubview(aPhoto1A)
        aScroll1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aPhoto.leadingAnchor, constant: scrollViewWidth/2).isActive = true
//        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 0).isActive = true
//        aPhoto1A.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 30
        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto1A.sd_setImage(with: imageUrl2)

        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItem1ATitle)
//        aScroll2.addSubview(aHItem1ATitle)
        aScroll1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Micole Yan"

        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc1A)
//        aScroll2.addSubview(aHSubDesc1A)
        aScroll1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "@micoley"
        aHSubDesc1A.layer.opacity = 0.4
        
        let aPhoto1B = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto1A)
        aScroll2.addSubview(aPhoto1B)
        aPhoto1B.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1B.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1B.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        aPhoto1B.leadingAnchor.constraint(equalTo: aHItemTitle.trailingAnchor, constant: 30).isActive = true
//        aPhoto1B.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 0).isActive = true
        aPhoto1B.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto1B.topAnchor.constraint(equalTo: aScroll2.topAnchor, constant: 0).isActive = true
        aPhoto1B.contentMode = .scaleAspectFill
        aPhoto1B.layer.masksToBounds = true
        aPhoto1B.layer.cornerRadius = 30
        aPhoto1B.sd_setImage(with: imageUrl)

        let aHItem1BTitle = UILabel()
        aHItem1BTitle.textAlignment = .left
        aHItem1BTitle.textColor = .white
        aHItem1BTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItem1ATitle)
        aScroll2.addSubview(aHItem1BTitle)
        aHItem1BTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1BTitle.topAnchor.constraint(equalTo: aPhoto1B.topAnchor, constant: 10).isActive = true //5
        aHItem1BTitle.leadingAnchor.constraint(equalTo: aPhoto1B.trailingAnchor, constant: 10).isActive = true
        aHItem1BTitle.text = "PaulTan News"

        let aHSubDesc1B = UILabel()
        aHSubDesc1B.textAlignment = .left
        aHSubDesc1B.textColor = .white
        aHSubDesc1B.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc1A)
        aScroll2.addSubview(aHSubDesc1B)
        aHSubDesc1B.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1B.topAnchor.constraint(equalTo: aHItem1BTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1B.leadingAnchor.constraint(equalTo: aPhoto1B.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1B.text = "@paultanorg"
        aHSubDesc1B.layer.opacity = 0.4
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickUser(id: "")
    }
}

//test > suggested sounds
class DiscoverSoundSizeLHighlightCell: HighlightCell {
    
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
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Creators"
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "反對無效"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "MC 張天賦"
        aHSubDesc.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHItemTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        let aPhoto1A = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "我为何让你走"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "黎明 卫兰"
        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrow1ABtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrow1ABtn.tintColor = .white
        aHLightRect1.addSubview(rArrow1ABtn)
        rArrow1ABtn.translatesAutoresizingMaskIntoConstraints = false
        rArrow1ABtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrow1ABtn.centerYAnchor.constraint(equalTo: aHItem1ATitle.centerYAnchor).isActive = true
        rArrow1ABtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.layer.opacity = 0.5
    }
    
    @objc func onSoundClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickSound(id: "")
    }
}

class DiscoverSoundSizeMHighlightCell: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    
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
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
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
//        aHLightTitle.text = "Related Creators"
//        aHLightTitle.text = "Suggested For You"
        aHLightTitle.text = "Discover More"
        
        aTab1.backgroundColor = .white
        aHLightRect1.addSubview(aTab1)
        aTab1.translatesAutoresizingMaskIntoConstraints = false
        aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -14).isActive = true //10
        aTab1.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
//                aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 10).isActive = true //10
//                aTab1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -4).isActive = true
        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
        aTab1.layer.opacity = 0.2 //0.5
        aTab1.layer.cornerRadius = 1
        
        aTab2.backgroundColor = .white
        aHLightRect1.addSubview(aTab2)
        aTab2.translatesAutoresizingMaskIntoConstraints = false
        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
        aTab2.layer.opacity = 0.5 //0.5
        aTab2.layer.cornerRadius = 1
        
        let scrollViewWidth = viewWidth - 20.0*2
//        let scrollViewWidth = 170.0
        let totalScrollWidth = scrollViewWidth * 2
        
        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-10
        scrollView1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 60)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self
        
        let aScroll1 = UIView()
        scrollView1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aScroll2 = UIView()
        scrollView1.addSubview(aScroll2)
        aScroll2.translatesAutoresizingMaskIntoConstraints = false
        aScroll2.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll2.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        aScroll2.leadingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: 0).isActive = true
        aScroll2.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
//        let aScroll3 = UIView()
//        scrollView1.addSubview(aScroll3)
//        aScroll3.translatesAutoresizingMaskIntoConstraints = false
//        aScroll3.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
//        aScroll3.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
//        aScroll3.leadingAnchor.constraint(equalTo: aScroll2.trailingAnchor, constant: 0).isActive = true
//        aScroll3.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aPhoto = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto)
        aScroll1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItemTitle)
        aScroll1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "反對無效"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc)
        aScroll1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "MC 張天賦"
        aHSubDesc.layer.opacity = 0.4

        let aPhoto1A = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto1A)
//        aScroll2.addSubview(aPhoto1A)
        aScroll1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aPhoto.leadingAnchor, constant: scrollViewWidth/2).isActive = true
//        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 0).isActive = true
//        aPhoto1A.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto1A.sd_setImage(with: imageUrl2)

        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItem1ATitle)
//        aScroll2.addSubview(aHItem1ATitle)
        aScroll1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "我为何让你走"

        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc1A)
//        aScroll2.addSubview(aHSubDesc1A)
        aScroll1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "黎明 卫兰"
        aHSubDesc1A.layer.opacity = 0.4
        
        let aPhoto1B = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto1A)
        aScroll2.addSubview(aPhoto1B)
        aPhoto1B.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1B.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1B.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        aPhoto1B.leadingAnchor.constraint(equalTo: aHItemTitle.trailingAnchor, constant: 30).isActive = true
//        aPhoto1B.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 0).isActive = true
        aPhoto1B.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto1B.topAnchor.constraint(equalTo: aScroll2.topAnchor, constant: 0).isActive = true
        aPhoto1B.contentMode = .scaleAspectFill
        aPhoto1B.layer.masksToBounds = true
        aPhoto1B.layer.cornerRadius = 5
        aPhoto1B.sd_setImage(with: imageUrl)

        let aHItem1BTitle = UILabel()
        aHItem1BTitle.textAlignment = .left
        aHItem1BTitle.textColor = .white
        aHItem1BTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItem1ATitle)
        aScroll2.addSubview(aHItem1BTitle)
        aHItem1BTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1BTitle.topAnchor.constraint(equalTo: aPhoto1B.topAnchor, constant: 10).isActive = true //5
        aHItem1BTitle.leadingAnchor.constraint(equalTo: aPhoto1B.trailingAnchor, constant: 10).isActive = true
        aHItem1BTitle.text = "戀愛這命題"

        let aHSubDesc1B = UILabel()
        aHSubDesc1B.textAlignment = .left
        aHSubDesc1B.textColor = .white
        aHSubDesc1B.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc1A)
        aScroll2.addSubview(aHSubDesc1B)
        aHSubDesc1B.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1B.topAnchor.constraint(equalTo: aHItem1BTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1B.leadingAnchor.constraint(equalTo: aPhoto1B.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1B.text = "Gigi Yim 炎明熹"
        aHSubDesc1B.layer.opacity = 0.4
    }
    
    @objc func onSoundClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickSound(id: "")
    }
}

//test > suggested places
class DiscoverPlaceSizeLHighlightCell: HighlightCell {
    
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
//        aHLightRectBG.isUserInteractionEnabled = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Locations"
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "KL Tower"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "KL Ms"
        aHSubDesc.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHItemTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        let aPhoto1A = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Cafe Borfford"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "CB Team"
        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrow1ABtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrow1ABtn.tintColor = .white
        aHLightRect1.addSubview(rArrow1ABtn)
        rArrow1ABtn.translatesAutoresizingMaskIntoConstraints = false
        rArrow1ABtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrow1ABtn.centerYAnchor.constraint(equalTo: aHItem1ATitle.centerYAnchor).isActive = true
        rArrow1ABtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.layer.opacity = 0.5
    }
    
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickPlace(id: "")
    }
}

class DiscoverPlaceSizeMHighlightCell: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    
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
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
//        aHLightRectBG.isUserInteractionEnabled = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Related Creators"
//        aHLightTitle.text = "Suggested For You"
        aHLightTitle.text = "Discover More"
        
        aTab1.backgroundColor = .white
        aHLightRect1.addSubview(aTab1)
        aTab1.translatesAutoresizingMaskIntoConstraints = false
        aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -14).isActive = true //10
        aTab1.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
//                aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 10).isActive = true //10
//                aTab1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -4).isActive = true
        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
        aTab1.layer.opacity = 0.2 //0.5
        aTab1.layer.cornerRadius = 1
        
        aTab2.backgroundColor = .white
        aHLightRect1.addSubview(aTab2)
        aTab2.translatesAutoresizingMaskIntoConstraints = false
        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
        aTab2.layer.opacity = 0.5 //0.5
        aTab2.layer.cornerRadius = 1
        
        let scrollViewWidth = viewWidth - 20.0*2
//        let scrollViewWidth = 170.0
        let totalScrollWidth = scrollViewWidth * 2
        
        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-10
        scrollView1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 60)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self
        
        let aScroll1 = UIView()
        scrollView1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aScroll2 = UIView()
        scrollView1.addSubview(aScroll2)
        aScroll2.translatesAutoresizingMaskIntoConstraints = false
        aScroll2.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll2.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        aScroll2.leadingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: 0).isActive = true
        aScroll2.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
//        let aScroll3 = UIView()
//        scrollView1.addSubview(aScroll3)
//        aScroll3.translatesAutoresizingMaskIntoConstraints = false
//        aScroll3.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
//        aScroll3.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
//        aScroll3.leadingAnchor.constraint(equalTo: aScroll2.trailingAnchor, constant: 0).isActive = true
//        aScroll3.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aPhoto = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto)
        aScroll1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItemTitle)
        aScroll1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "KL Tower"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc)
        aScroll1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "DBKL"
        aHSubDesc.layer.opacity = 0.4

        let aPhoto1A = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto1A)
//        aScroll2.addSubview(aPhoto1A)
        aScroll1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aPhoto.leadingAnchor, constant: scrollViewWidth/2).isActive = true
//        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 0).isActive = true
//        aPhoto1A.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto1A.sd_setImage(with: imageUrl2)

        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItem1ATitle)
//        aScroll2.addSubview(aHItem1ATitle)
        aScroll1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Cafe Borfford"

        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc1A)
//        aScroll2.addSubview(aHSubDesc1A)
        aScroll1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "CB Team"
        aHSubDesc1A.layer.opacity = 0.4
        
        let aPhoto1B = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto1A)
        aScroll2.addSubview(aPhoto1B)
        aPhoto1B.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1B.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1B.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        aPhoto1B.leadingAnchor.constraint(equalTo: aHItemTitle.trailingAnchor, constant: 30).isActive = true
//        aPhoto1B.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 0).isActive = true
        aPhoto1B.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto1B.topAnchor.constraint(equalTo: aScroll2.topAnchor, constant: 0).isActive = true
        aPhoto1B.contentMode = .scaleAspectFill
        aPhoto1B.layer.masksToBounds = true
        aPhoto1B.layer.cornerRadius = 5
        aPhoto1B.sd_setImage(with: imageUrl)

        let aHItem1BTitle = UILabel()
        aHItem1BTitle.textAlignment = .left
        aHItem1BTitle.textColor = .white
        aHItem1BTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItem1ATitle)
        aScroll2.addSubview(aHItem1BTitle)
        aHItem1BTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1BTitle.topAnchor.constraint(equalTo: aPhoto1B.topAnchor, constant: 10).isActive = true //5
        aHItem1BTitle.leadingAnchor.constraint(equalTo: aPhoto1B.trailingAnchor, constant: 10).isActive = true
        aHItem1BTitle.text = "Sunway Lagoon Tambun"

        let aHSubDesc1B = UILabel()
        aHSubDesc1B.textAlignment = .left
        aHSubDesc1B.textColor = .white
        aHSubDesc1B.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc1A)
        aScroll2.addSubview(aHSubDesc1B)
        aHSubDesc1B.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1B.topAnchor.constraint(equalTo: aHItem1BTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1B.leadingAnchor.constraint(equalTo: aPhoto1B.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1B.text = "Sunway"
        aHSubDesc1B.layer.opacity = 0.4
    }
    
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickPlace(id: "")
    }
}

class LatestMultiLoopsSizeMHighlightCell: UIView {
    
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
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Latest Loops"
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
        aScroll1.heightAnchor.constraint(equalToConstant: 80).isActive = true //70
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
        aGrid.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true //4
        aGrid.heightAnchor.constraint(equalToConstant: 80).isActive = true //70
        aGrid.widthAnchor.constraint(equalToConstant: 60).isActive = true //50
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
        bGrid.heightAnchor.constraint(equalToConstant: 80).isActive = true //100
        bGrid.widthAnchor.constraint(equalToConstant: 60).isActive = true //75
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
        cGrid.heightAnchor.constraint(equalToConstant: 80).isActive = true //100
        cGrid.widthAnchor.constraint(equalToConstant: 60).isActive = true //75
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

//test > design for latest loop
class LatestLoopSizeMHighlightCell: UIView {
    
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
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Latest Loop"
//        aHLightTitle.isHidden = true
        
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
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
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
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
//        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aGrid.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -40).isActive = true
        aHItem1ATitle.text = "Bitcoin ‘Halving’ Cuts Supply of New Tokens in Threat to Miners"
//        aHItem1ATitle.numberOfLines = 2
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 12)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 5).isActive = true //0
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "105k"
        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.leadingAnchor.constraint(equalTo: aHSubDesc1A.trailingAnchor, constant: 5).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc1A.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        rArrowBtn.layer.opacity = 0.4
    }
}

class LatestMultiPhotosSizeMHighlightCell: UIView {
    
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
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Latest Shots"
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
        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        
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

class BaseLocationHighlightBox: UIView {
    
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
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
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
//        aHLightTitle.text = "Base"
        aHLightTitle.text = "Location"
        
        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true //60
        rGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
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
        aHSubDesc.font = .boldSystemFont(ofSize: 13)
//        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 0).isActive = true //10
//        aHSubDesc.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "Petronas Twin Tower"
//                aHSubDesc.layer.opacity = 0.7

//        let aHSubDescSymbol = UIImageView(image: UIImage(named:"icon_round_arrow_up")?.withRenderingMode(.alwaysTemplate))
//        aHSubDescSymbol.tintColor = .green
////        aHLightSection.addSubview(aHSubDescSymbol)
//        aHLightRect1.addSubview(aHSubDescSymbol)
//        aHSubDescSymbol.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDescSymbol.leadingAnchor.constraint(equalTo: aHSubDesc.trailingAnchor, constant: 0).isActive = true
//        aHSubDescSymbol.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
//        aHSubDescSymbol.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        aHSubDescSymbol.widthAnchor.constraint(equalToConstant: 28).isActive = true
////                aHSubDescSymbol.layer.opacity = 0.5

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
        aHSubDesc2.text = "Base"
        aHSubDesc2.layer.opacity = 0.4

        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.leadingAnchor.constraint(equalTo: aHSubDesc.trailingAnchor, constant: 10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

//test > design for bio or "about"
class AboutUserHighlightBox: UIView {
    
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
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
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
        aHLightTitle.text = "About"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
        aHSubDesc.text = "The latest financial news and market analysis, direct from Bloomberg TV."
//                aHSubDesc.layer.opacity = 0.7
        
        let linkBtn = UIImageView()
        linkBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
        linkBtn.tintColor = .white
        aHLightRect1.addSubview(linkBtn)
        linkBtn.translatesAutoresizingMaskIntoConstraints = false
        linkBtn.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 5).isActive = true //10
        linkBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        linkBtn.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        linkBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        linkBtn.layer.opacity = 0.4

        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .boldSystemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.centerYAnchor.constraint(equalTo: linkBtn.centerYAnchor).isActive = true
        aHSubDesc2.leadingAnchor.constraint(equalTo: linkBtn.trailingAnchor, constant: 10).isActive = true
//        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //10
//        aHSubDesc2.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHSubDesc2.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc2.text = "youtube.com/@courtneyryan"
        aHSubDesc2.layer.opacity = 0.4

        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

//test > design for music
class AboutSoundHighlightBox: UIView {
    
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
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
        playBtn.tintColor = .white
        aHLightRect1.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        playBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 12)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "00:29"
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .left
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "About"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
//        aHSubDesc.text = "The latest financial news and market analysis, direct from Bloomberg TV."
        aHSubDesc.text = "Listen full version"
//                aHSubDesc.layer.opacity = 0.7
        
        let linkBtn = UIImageView()
        linkBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
        linkBtn.tintColor = .white
        aHLightRect1.addSubview(linkBtn)
        linkBtn.translatesAutoresizingMaskIntoConstraints = false
        linkBtn.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 5).isActive = true //10
        linkBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        linkBtn.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        linkBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        linkBtn.layer.opacity = 0.4

        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .boldSystemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.centerYAnchor.constraint(equalTo: linkBtn.centerYAnchor).isActive = true
        aHSubDesc2.leadingAnchor.constraint(equalTo: linkBtn.trailingAnchor, constant: 10).isActive = true
//        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //10
//        aHSubDesc2.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHSubDesc2.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc2.text = "youtube.com/@courtneyryan"
        aHSubDesc2.layer.opacity = 0.4

        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
}

//test > design for no posts
class UserEmptyPostHighlightBox: UIView {
    
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
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
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
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "No Post Yet"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "This account has not posted any."
//                aHSubDesc.layer.opacity = 0.7
    }
}

class SoundEmptyPostHighlightBox: UIView {
    
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
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
//        playBtn.tintColor = .white
//        aHLightRect1.addSubview(playBtn)
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        playBtn.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        playBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        playBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        playBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .left
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 12)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "00:29"
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "No Post Yet"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHSubDesc.font = .boldSystemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
//        aHSubDesc.text = "The latest financial news and market analysis, direct from Bloomberg TV."
        aHSubDesc.text = "Create with this Sound"
//                aHSubDesc.layer.opacity = 0.7
    }
}

//test > design for private account
class UserPrivateAccountHighlightBox: UIView {
    
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
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let lockBtn = UIImageView()
        lockBtn.image = UIImage(named:"icon_round_lock")?.withRenderingMode(.alwaysTemplate)
        lockBtn.tintColor = .white
        aHLightRect1.addSubview(lockBtn)
        lockBtn.translatesAutoresizingMaskIntoConstraints = false
        lockBtn.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        lockBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        lockBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //18
        lockBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        lockBtn.layer.opacity = 0.4
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: lockBtn.trailingAnchor, constant: 10).isActive = true
//        aHLightTitle.centerYAnchor.constraint(equalTo: lockBtn.centerYAnchor, constant: 0).isActive = true
        aHLightTitle.bottomAnchor.constraint(equalTo: lockBtn.bottomAnchor, constant: 0).isActive = true
//        aHLightTitle.text = "This account is private"
        aHLightTitle.text = "Private Account"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightTitle.leadingAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
        aHSubDesc.text = "Follow to see @michelle posts"
//                aHSubDesc.layer.opacity = 0.7
    }
}
