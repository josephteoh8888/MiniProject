//
//  JobHighlightCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class JobHighlightCell: UIView {
    
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
        aHLightTitle.text = "Jobs Hiring"
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//                let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
        
        //test > version 2
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
//                aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 5).isActive = true //20
//                aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHItemTitle.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        aHItemTitle.text = "Senior Electrical Engineer"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "$50K - $70K"
        aHSubDesc.layer.opacity = 0.4
        
        let aHItemLocationBox = UIView()
        aHItemLocationBox.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aHItemLocationBox)
        aHItemLocationBox.clipsToBounds = true
        aHItemLocationBox.translatesAutoresizingMaskIntoConstraints = false
        aHItemLocationBox.heightAnchor.constraint(equalToConstant: 22).isActive = true //default: 50
        aHItemLocationBox.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //20
        aHItemLocationBox.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHItemLocationBox.layer.cornerRadius = 5
        aHItemLocationBox.layer.opacity = 0.5
        
        let objectSymbol = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        objectSymbol.tintColor = .white
        aHLightRect1.addSubview(objectSymbol)
        objectSymbol.translatesAutoresizingMaskIntoConstraints = false
//                objectSymbol.topAnchor.constraint(equalTo: aPhotoB.topAnchor, constant: 10).isActive = true
        objectSymbol.leadingAnchor.constraint(equalTo: aHItemLocationBox.leadingAnchor, constant: 5).isActive = true
//        objectSymbol.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        objectSymbol.centerYAnchor.constraint(equalTo: aHItemLocationBox.centerYAnchor).isActive = true
        objectSymbol.heightAnchor.constraint(equalToConstant: 12).isActive = true //18
        objectSymbol.widthAnchor.constraint(equalToConstant: 12).isActive = true
        objectSymbol.layer.opacity = 0.5
        
        let aHItemLocation = UILabel()
        aHItemLocation.textAlignment = .left
        aHItemLocation.textColor = .white
//                aHItemLocation.font = .systemFont(ofSize: 11) //13
        aHItemLocation.font = .boldSystemFont(ofSize: 11) //13
        aHLightRect1.addSubview(aHItemLocation)
        aHItemLocation.translatesAutoresizingMaskIntoConstraints = false
//                aHItemLocation.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //20
        //                aHItemLocation.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHItemLocation.centerYAnchor.constraint(equalTo: aHItemLocationBox.centerYAnchor, constant: 0).isActive = true //20
//                aHItemLocation.leadingAnchor.constraint(equalTo: aHItemLocationBox.leadingAnchor, constant: 10).isActive = true
        aHItemLocation.leadingAnchor.constraint(equalTo: objectSymbol.trailingAnchor, constant: 3).isActive = true
        aHItemLocation.trailingAnchor.constraint(equalTo: aHItemLocationBox.trailingAnchor, constant: -10).isActive = true
        aHItemLocation.text = "Georgetown, Penang"
        aHItemLocation.layer.opacity = 0.5
        
        let aHActionBtn = UIView()
        aHActionBtn.backgroundColor = .ddmRedColor
        aHLightRect1.addSubview(aHActionBtn)
        aHActionBtn.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHActionBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHActionBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
//                aHActionBtn.bottomAnchor.constraint(equalTo: aHItemLocation.bottomAnchor).isActive = true
        aHActionBtn.bottomAnchor.constraint(equalTo: aHItemLocationBox.bottomAnchor).isActive = true
        aHActionBtn.layer.cornerRadius = 5
        
        let aHActionText = UILabel()
        aHActionText.textAlignment = .center
        aHActionText.textColor = .white
        aHActionText.font = .boldSystemFont(ofSize: 13)
        aHActionBtn.addSubview(aHActionText)
        aHActionText.translatesAutoresizingMaskIntoConstraints = false
        aHActionText.centerXAnchor.constraint(equalTo: aHActionBtn.centerXAnchor).isActive = true
        aHActionText.centerYAnchor.constraint(equalTo: aHActionBtn.centerYAnchor).isActive = true
        aHActionText.text = "Apply"
        
        let aHItem2Title = UILabel()
        aHItem2Title.textAlignment = .left
        aHItem2Title.textColor = .white
        aHItem2Title.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem2Title)
        aHItem2Title.translatesAutoresizingMaskIntoConstraints = false
//                aHItem2Title.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 5).isActive = true //20
//                aHItem2Title.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItem2Title.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//                aHItem2Title.topAnchor.constraint(equalTo: aHItemLocation.bottomAnchor, constant: 20).isActive = true
        aHItem2Title.topAnchor.constraint(equalTo: aHItemLocationBox.bottomAnchor, constant: 20).isActive = true
        aHItem2Title.text = "Customer Service Specialist"
        
        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.topAnchor.constraint(equalTo: aHItem2Title.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc2.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc2.text = "$13K - $15K"
        aHSubDesc2.layer.opacity = 0.4
        
        let aHItem2LocationBox = UIView()
        aHItem2LocationBox.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aHItem2LocationBox)
        aHItem2LocationBox.clipsToBounds = true
        aHItem2LocationBox.translatesAutoresizingMaskIntoConstraints = false
        aHItem2LocationBox.heightAnchor.constraint(equalToConstant: 22).isActive = true //default: 50
        aHItem2LocationBox.topAnchor.constraint(equalTo: aHSubDesc2.bottomAnchor, constant: 10).isActive = true //20
        aHItem2LocationBox.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHItem2LocationBox.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHItem2LocationBox.layer.cornerRadius = 5
        aHItem2LocationBox.layer.opacity = 0.5
        
        let object2Symbol = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        object2Symbol.tintColor = .white
        aHLightRect1.addSubview(object2Symbol)
        object2Symbol.translatesAutoresizingMaskIntoConstraints = false
//                objectSymbol.topAnchor.constraint(equalTo: aPhotoB.topAnchor, constant: 10).isActive = true
        object2Symbol.leadingAnchor.constraint(equalTo: aHItem2LocationBox.leadingAnchor, constant: 5).isActive = true
//        object2Symbol.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        object2Symbol.centerYAnchor.constraint(equalTo: aHItem2LocationBox.centerYAnchor).isActive = true
        object2Symbol.heightAnchor.constraint(equalToConstant: 12).isActive = true //18
        object2Symbol.widthAnchor.constraint(equalToConstant: 12).isActive = true
        object2Symbol.layer.opacity = 0.5
        
        let aHItem2Location = UILabel()
        aHItem2Location.textAlignment = .left
        aHItem2Location.textColor = .white
//                aHItem2Location.font = .systemFont(ofSize: 11) //13
        aHItem2Location.font = .boldSystemFont(ofSize: 11) //13
        aHLightRect1.addSubview(aHItem2Location)
        aHItem2Location.translatesAutoresizingMaskIntoConstraints = false
        aHItem2Location.centerYAnchor.constraint(equalTo: aHItem2LocationBox.centerYAnchor, constant: 0).isActive = true //20
        aHItem2Location.leadingAnchor.constraint(equalTo: object2Symbol.trailingAnchor, constant: 3).isActive = true
        aHItem2Location.trailingAnchor.constraint(equalTo: aHItem2LocationBox.trailingAnchor, constant: -10).isActive = true
        aHItem2Location.text = "Remote Location"
        aHItem2Location.layer.opacity = 0.5
        
        let aHActionBtn2 = UIView()
        aHActionBtn2.backgroundColor = .ddmRedColor
        aHLightRect1.addSubview(aHActionBtn2)
        aHActionBtn2.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHActionBtn2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHActionBtn2.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
//                aHActionBtn2.bottomAnchor.constraint(equalTo: aHItem2Location.bottomAnchor).isActive = true
        aHActionBtn2.bottomAnchor.constraint(equalTo: aHItem2LocationBox.bottomAnchor).isActive = true
        aHActionBtn2.layer.cornerRadius = 5
        
        let aHActionText2 = UILabel()
        aHActionText2.textAlignment = .center
        aHActionText2.textColor = .white
        aHActionText2.font = .boldSystemFont(ofSize: 13)
        aHActionBtn2.addSubview(aHActionText2)
        aHActionText2.translatesAutoresizingMaskIntoConstraints = false
        aHActionText2.centerXAnchor.constraint(equalTo: aHActionBtn2.centerXAnchor).isActive = true
        aHActionText2.centerYAnchor.constraint(equalTo: aHActionBtn2.centerYAnchor).isActive = true
        aHActionText2.text = "Apply"
    }
}

//test > size M for highlight cell at half mode
class JobSizeMHighlightCell: UIView {
    
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
        aHLightTitle.text = "Jobs Hiring"
        
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
        scrollView1.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 70)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self
        
        let aScroll1 = UIView()
        scrollView1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aScroll2 = UIView()
        scrollView1.addSubview(aScroll2)
        aScroll2.translatesAutoresizingMaskIntoConstraints = false
        aScroll2.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll2.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aScroll2.leadingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: 0).isActive = true
        aScroll2.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aScroll1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
//                aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 5).isActive = true //20
//                aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aHItemTitle.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
        aHItemTitle.text = "Senior Electrical Engineer"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aScroll1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "$50K - $70K"
        aHSubDesc.layer.opacity = 0.4
        
        let aHItemLocationBox = UIView()
        aHItemLocationBox.backgroundColor = .ddmDarkColor
        aScroll1.addSubview(aHItemLocationBox)
        aHItemLocationBox.clipsToBounds = true
        aHItemLocationBox.translatesAutoresizingMaskIntoConstraints = false
        aHItemLocationBox.heightAnchor.constraint(equalToConstant: 22).isActive = true //default: 50
        aHItemLocationBox.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //20
        aHItemLocationBox.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aHItemLocationBox.layer.cornerRadius = 5
        aHItemLocationBox.layer.opacity = 0.5
        
        let objectSymbol = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        objectSymbol.tintColor = .white
        aScroll1.addSubview(objectSymbol)
        objectSymbol.translatesAutoresizingMaskIntoConstraints = false
//                objectSymbol.topAnchor.constraint(equalTo: aPhotoB.topAnchor, constant: 10).isActive = true
        objectSymbol.leadingAnchor.constraint(equalTo: aHItemLocationBox.leadingAnchor, constant: 5).isActive = true
//        objectSymbol.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        objectSymbol.centerYAnchor.constraint(equalTo: aHItemLocationBox.centerYAnchor).isActive = true
        objectSymbol.heightAnchor.constraint(equalToConstant: 12).isActive = true //18
        objectSymbol.widthAnchor.constraint(equalToConstant: 12).isActive = true
        objectSymbol.layer.opacity = 0.5
        
        let aHItemLocation = UILabel()
        aHItemLocation.textAlignment = .left
        aHItemLocation.textColor = .white
//                aHItemLocation.font = .systemFont(ofSize: 11) //13
        aHItemLocation.font = .boldSystemFont(ofSize: 11) //13
        aScroll1.addSubview(aHItemLocation)
        aHItemLocation.translatesAutoresizingMaskIntoConstraints = false
        aHItemLocation.centerYAnchor.constraint(equalTo: aHItemLocationBox.centerYAnchor, constant: 0).isActive = true //20
        aHItemLocation.leadingAnchor.constraint(equalTo: objectSymbol.trailingAnchor, constant: 3).isActive = true
        aHItemLocation.trailingAnchor.constraint(equalTo: aHItemLocationBox.trailingAnchor, constant: -10).isActive = true
        aHItemLocation.text = "Georgetown, Penang"
        aHItemLocation.layer.opacity = 0.5
        
        let aHActionBtn = UIView()
        aHActionBtn.backgroundColor = .ddmRedColor
        aScroll1.addSubview(aHActionBtn)
        aHActionBtn.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -10).isActive = true
        aHActionBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHActionBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
//                aHActionBtn.bottomAnchor.constraint(equalTo: aHItemLocation.bottomAnchor).isActive = true
        aHActionBtn.bottomAnchor.constraint(equalTo: aHItemLocationBox.bottomAnchor).isActive = true
        aHActionBtn.layer.cornerRadius = 5
        
        let aHActionText = UILabel()
        aHActionText.textAlignment = .center
        aHActionText.textColor = .white
        aHActionText.font = .boldSystemFont(ofSize: 13)
        aHActionBtn.addSubview(aHActionText)
        aHActionText.translatesAutoresizingMaskIntoConstraints = false
        aHActionText.centerXAnchor.constraint(equalTo: aHActionBtn.centerXAnchor).isActive = true
        aHActionText.centerYAnchor.constraint(equalTo: aHActionBtn.centerYAnchor).isActive = true
        aHActionText.text = "Apply"
        
        let aHItem2Title = UILabel()
        aHItem2Title.textAlignment = .left
        aHItem2Title.textColor = .white
        aHItem2Title.font = .boldSystemFont(ofSize: 13) //13
        aScroll2.addSubview(aHItem2Title)
        aHItem2Title.translatesAutoresizingMaskIntoConstraints = false
//                aHItem2Title.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 5).isActive = true //20
//                aHItem2Title.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItem2Title.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
//                aHItem2Title.topAnchor.constraint(equalTo: aHItemLocation.bottomAnchor, constant: 20).isActive = true
        aHItem2Title.topAnchor.constraint(equalTo: aScroll2.topAnchor, constant: 0).isActive = true
        aHItem2Title.text = "Customer Service Specialist"
        
        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
        aScroll2.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.topAnchor.constraint(equalTo: aHItem2Title.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc2.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aHSubDesc2.text = "$13K - $15K"
        aHSubDesc2.layer.opacity = 0.4
        
        let aHItem2LocationBox = UIView()
        aHItem2LocationBox.backgroundColor = .ddmDarkColor
        aScroll2.addSubview(aHItem2LocationBox)
        aHItem2LocationBox.clipsToBounds = true
        aHItem2LocationBox.translatesAutoresizingMaskIntoConstraints = false
        aHItem2LocationBox.heightAnchor.constraint(equalToConstant: 22).isActive = true //default: 50
        aHItem2LocationBox.topAnchor.constraint(equalTo: aHSubDesc2.bottomAnchor, constant: 10).isActive = true //20
        aHItem2LocationBox.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
//        aHItem2LocationBox.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHItem2LocationBox.layer.cornerRadius = 5
        aHItem2LocationBox.layer.opacity = 0.5
        
        let object2Symbol = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        object2Symbol.tintColor = .white
        aScroll2.addSubview(object2Symbol)
        object2Symbol.translatesAutoresizingMaskIntoConstraints = false
//                objectSymbol.topAnchor.constraint(equalTo: aPhotoB.topAnchor, constant: 10).isActive = true
        object2Symbol.leadingAnchor.constraint(equalTo: aHItem2LocationBox.leadingAnchor, constant: 5).isActive = true
//        object2Symbol.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        object2Symbol.centerYAnchor.constraint(equalTo: aHItem2LocationBox.centerYAnchor).isActive = true
        object2Symbol.heightAnchor.constraint(equalToConstant: 12).isActive = true //18
        object2Symbol.widthAnchor.constraint(equalToConstant: 12).isActive = true
        object2Symbol.layer.opacity = 0.5
        
        let aHItem2Location = UILabel()
        aHItem2Location.textAlignment = .left
        aHItem2Location.textColor = .white
//                aHItem2Location.font = .systemFont(ofSize: 11) //13
        aHItem2Location.font = .boldSystemFont(ofSize: 11) //13
        aScroll2.addSubview(aHItem2Location)
        aHItem2Location.translatesAutoresizingMaskIntoConstraints = false
        aHItem2Location.centerYAnchor.constraint(equalTo: aHItem2LocationBox.centerYAnchor, constant: 0).isActive = true //20
        aHItem2Location.leadingAnchor.constraint(equalTo: object2Symbol.trailingAnchor, constant: 3).isActive = true
        aHItem2Location.trailingAnchor.constraint(equalTo: aHItem2LocationBox.trailingAnchor, constant: -10).isActive = true
        aHItem2Location.text = "Remote Location"
        aHItem2Location.layer.opacity = 0.5
        
        let aHActionBtn2 = UIView()
        aHActionBtn2.backgroundColor = .ddmRedColor
        aScroll2.addSubview(aHActionBtn2)
        aHActionBtn2.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn2.trailingAnchor.constraint(equalTo: aScroll2.trailingAnchor, constant: -10).isActive = true
        aHActionBtn2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHActionBtn2.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
//                aHActionBtn2.bottomAnchor.constraint(equalTo: aHItem2Location.bottomAnchor).isActive = true
        aHActionBtn2.bottomAnchor.constraint(equalTo: aHItem2LocationBox.bottomAnchor).isActive = true
        aHActionBtn2.layer.cornerRadius = 5
        
        let aHActionText2 = UILabel()
        aHActionText2.textAlignment = .center
        aHActionText2.textColor = .white
        aHActionText2.font = .boldSystemFont(ofSize: 13)
        aHActionBtn2.addSubview(aHActionText2)
        aHActionText2.translatesAutoresizingMaskIntoConstraints = false
        aHActionText2.centerXAnchor.constraint(equalTo: aHActionBtn2.centerXAnchor).isActive = true
        aHActionText2.centerYAnchor.constraint(equalTo: aHActionBtn2.centerYAnchor).isActive = true
        aHActionText2.text = "Apply"
    }
}
