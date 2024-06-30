//
//  BookHighlightCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class BookHighlightCell: UIView {
    
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
        aHLightTitle.text = "Ticket Sale"
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
        
        //item 1
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 5).isActive = true //20
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "BTS Concert Live Tour 2023"
        
        let aHItemPrice = UILabel()
        aHItemPrice.textAlignment = .left
        aHItemPrice.textColor = .white
        aHItemPrice.font = .boldSystemFont(ofSize: 15)
        aHLightRect1.addSubview(aHItemPrice)
        aHItemPrice.translatesAutoresizingMaskIntoConstraints = false
        aHItemPrice.bottomAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 0).isActive = true //20
        aHItemPrice.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemPrice.text = "$299"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "113k sold"
        aHSubDesc.layer.opacity = 0.4
        
        let aHActionBtn = UIView()
        aHActionBtn.backgroundColor = .ddmRedColor
        aHLightRect1.addSubview(aHActionBtn)
        aHActionBtn.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHActionBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHActionBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aHActionBtn.bottomAnchor.constraint(equalTo: aHItemPrice.bottomAnchor).isActive = true
        aHActionBtn.layer.cornerRadius = 5
        
        let aHActionText = UILabel()
        aHActionText.textAlignment = .center
        aHActionText.textColor = .white
        aHActionText.font = .boldSystemFont(ofSize: 13)
        aHActionBtn.addSubview(aHActionText)
        aHActionText.translatesAutoresizingMaskIntoConstraints = false
        aHActionText.centerXAnchor.constraint(equalTo: aHActionBtn.centerXAnchor).isActive = true
        aHActionText.centerYAnchor.constraint(equalTo: aHActionBtn.centerYAnchor).isActive = true
        aHActionText.text = "Book"
        
        //item 2
        let aPhoto2 = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto2)
        aPhoto2.translatesAutoresizingMaskIntoConstraints = false
        aPhoto2.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto2.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto2.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto2.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto2.contentMode = .scaleAspectFill
        aPhoto2.layer.masksToBounds = true
        aPhoto2.layer.cornerRadius = 5
        aPhoto2.sd_setImage(with: imageUrl)
        
        let aHItem2Title = UILabel()
        aHItem2Title.textAlignment = .left
        aHItem2Title.textColor = .white
        aHItem2Title.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem2Title)
        aHItem2Title.translatesAutoresizingMaskIntoConstraints = false
        aHItem2Title.topAnchor.constraint(equalTo: aPhoto2.topAnchor, constant: 5).isActive = true //20
        aHItem2Title.leadingAnchor.constraint(equalTo: aPhoto2.trailingAnchor, constant: 10).isActive = true
        aHItem2Title.text = "BlackPink World 2023"
        
        let aHItem2Price = UILabel()
        aHItem2Price.textAlignment = .left
        aHItem2Price.textColor = .white
        aHItem2Price.font = .boldSystemFont(ofSize: 15)
        aHLightRect1.addSubview(aHItem2Price)
        aHItem2Price.translatesAutoresizingMaskIntoConstraints = false
        aHItem2Price.bottomAnchor.constraint(equalTo: aPhoto2.bottomAnchor, constant: 0).isActive = true //20
        aHItem2Price.leadingAnchor.constraint(equalTo: aPhoto2.trailingAnchor, constant: 10).isActive = true
        aHItem2Price.text = "$499"
        
        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.topAnchor.constraint(equalTo: aHItem2Title.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc2.leadingAnchor.constraint(equalTo: aPhoto2.trailingAnchor, constant: 10).isActive = true
        aHSubDesc2.text = "92k sold"
        aHSubDesc2.layer.opacity = 0.4
        
        let aHActionBtn2 = UIView()
        aHActionBtn2.backgroundColor = .ddmRedColor
        aHLightRect1.addSubview(aHActionBtn2)
        aHActionBtn2.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHActionBtn2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHActionBtn2.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aHActionBtn2.bottomAnchor.constraint(equalTo: aHItem2Price.bottomAnchor).isActive = true
        aHActionBtn2.layer.cornerRadius = 5
        
        let aHActionText2 = UILabel()
        aHActionText2.textAlignment = .center
        aHActionText2.textColor = .white
        aHActionText2.font = .boldSystemFont(ofSize: 13)
        aHActionBtn2.addSubview(aHActionText2)
        aHActionText2.translatesAutoresizingMaskIntoConstraints = false
        aHActionText2.centerXAnchor.constraint(equalTo: aHActionBtn2.centerXAnchor).isActive = true
        aHActionText2.centerYAnchor.constraint(equalTo: aHActionBtn2.centerYAnchor).isActive = true
        aHActionText2.text = "Book"
    }
}
