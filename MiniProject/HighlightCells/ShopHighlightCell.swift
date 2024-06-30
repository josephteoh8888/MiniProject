//
//  ShopHighlightCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class ShopHighlightCell: HighlightCell {
//class ShopHighlightCell: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    let aTab3 = UIView()
    let scrollView1 = UIScrollView()
    
//    weak var aDelegate : HighlightCellDelegate?
    
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
        aHLightTitle.text = "Shop Best Sellers"
        
//        let aTab1 = UIView()
//                aTab1.backgroundColor = .yellow
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
        
//        let aTab2 = UIView()
//                aTab2.backgroundColor = .yellow
        aTab2.backgroundColor = .white
        aHLightRect1.addSubview(aTab2)
        aTab2.translatesAutoresizingMaskIntoConstraints = false
        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
        aTab2.layer.opacity = 0.5 //0.5
        aTab2.layer.cornerRadius = 1
        
//        aTab3.backgroundColor = .white
//        aHLightRect1.addSubview(aTab3)
//        aTab3.translatesAutoresizingMaskIntoConstraints = false
//        aTab3.trailingAnchor.constraint(equalTo: aTab2.leadingAnchor, constant: -5).isActive = true
//        aTab3.centerYAnchor.constraint(equalTo: aTab2.centerYAnchor).isActive = true
//        aTab3.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        aTab3.widthAnchor.constraint(equalToConstant: 7).isActive = true //5
//        aTab3.layer.opacity = 0.5
//        aTab3.layer.cornerRadius = 1
        
//                let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_swap")?.withRenderingMode(.alwaysTemplate))
//                rArrowBtn.tintColor = .white
//                aHLightSection.addSubview(rArrowBtn)
//                rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
//                rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -12).isActive = true //-10
//        //        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
//                rArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
//                rArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//                rArrowBtn.layer.opacity = 0.5
        
        let scrollViewWidth = viewWidth - 20.0*2
        let totalScrollWidth = scrollViewWidth * 2
        
//        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        scrollView1.heightAnchor.constraint(equalToConstant: 140).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 140)
        scrollView1.isPagingEnabled = true
        scrollView1.delegate = self
        
        let aScroll1 = UIView()
        scrollView1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 140).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aScroll2 = UIView()
        scrollView1.addSubview(aScroll2)
        aScroll2.translatesAutoresizingMaskIntoConstraints = false
        aScroll2.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll2.heightAnchor.constraint(equalToConstant: 140).isActive = true //60
        aScroll2.leadingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: 0).isActive = true
        aScroll2.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
        
        let aPhoto = SDAnimatedImageView()
        aScroll1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
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
        aScroll1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 5).isActive = true //20
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "Adidas Sneaker Limited Edition"
        
        let aHItemPrice = UILabel()
        aHItemPrice.textAlignment = .left
        aHItemPrice.textColor = .white
        aHItemPrice.font = .boldSystemFont(ofSize: 15)
        aScroll1.addSubview(aHItemPrice)
        aHItemPrice.translatesAutoresizingMaskIntoConstraints = false
        aHItemPrice.bottomAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 0).isActive = true //20
        aHItemPrice.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemPrice.text = "$999"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white
        aHSubDesc.font = .systemFont(ofSize: 11)
        aScroll1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "104 sold"
        aHSubDesc.layer.opacity = 0.4
        
        let aHActionBtn = UIView()
        aHActionBtn.backgroundColor = .ddmRedColor
        aScroll1.addSubview(aHActionBtn)
        aHActionBtn.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -10).isActive = true
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
        aHActionText.text = "Buy"
        
        let aPhoto1A = SDAnimatedImageView()
        aScroll1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aScroll1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 5).isActive = true //20
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Nike Sneaker Limited Edition"
        
        let aHItem1APrice = UILabel()
        aHItem1APrice.textAlignment = .left
        aHItem1APrice.textColor = .white
        aHItem1APrice.font = .boldSystemFont(ofSize: 15)
        aScroll1.addSubview(aHItem1APrice)
        aHItem1APrice.translatesAutoresizingMaskIntoConstraints = false
        aHItem1APrice.bottomAnchor.constraint(equalTo: aPhoto1A.bottomAnchor, constant: 0).isActive = true //20
        aHItem1APrice.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1APrice.text = "$899"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .white
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aScroll1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "82 sold"
        aHSubDesc1A.layer.opacity = 0.4
        
        let aHAction1ABtn = UIView()
        aHAction1ABtn.backgroundColor = .ddmRedColor
        aScroll1.addSubview(aHAction1ABtn)
        aHAction1ABtn.translatesAutoresizingMaskIntoConstraints = false
        aHAction1ABtn.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -10).isActive = true
        aHAction1ABtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        aHAction1ABtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aHAction1ABtn.bottomAnchor.constraint(equalTo: aHItem1APrice.bottomAnchor).isActive = true
        aHAction1ABtn.layer.cornerRadius = 5
        
        let aHAction1AText = UILabel()
        aHAction1AText.textAlignment = .center
        aHAction1AText.textColor = .white
        aHAction1AText.font = .boldSystemFont(ofSize: 13)
        aHAction1ABtn.addSubview(aHAction1AText)
        aHAction1AText.translatesAutoresizingMaskIntoConstraints = false
        aHAction1AText.centerXAnchor.constraint(equalTo: aHAction1ABtn.centerXAnchor).isActive = true
        aHAction1AText.centerYAnchor.constraint(equalTo: aHAction1ABtn.centerYAnchor).isActive = true
        aHAction1AText.text = "Buy"
        
        let aPhoto2 = SDAnimatedImageView()
        aScroll2.addSubview(aPhoto2)
        aPhoto2.translatesAutoresizingMaskIntoConstraints = false
        aPhoto2.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto2.leadingAnchor.constraint(equalTo: aScroll2.leadingAnchor, constant: 10).isActive = true
        aPhoto2.topAnchor.constraint(equalTo: aScroll2.topAnchor, constant: 0).isActive = true
//                aPhoto2.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto2.contentMode = .scaleAspectFill
        aPhoto2.layer.masksToBounds = true
        aPhoto2.layer.cornerRadius = 5
        aPhoto2.sd_setImage(with: imageUrl)
        
        let aHItem2Title = UILabel()
        aHItem2Title.textAlignment = .left
        aHItem2Title.textColor = .white
        aHItem2Title.font = .boldSystemFont(ofSize: 13) //13
        aScroll2.addSubview(aHItem2Title)
        aHItem2Title.translatesAutoresizingMaskIntoConstraints = false
        aHItem2Title.topAnchor.constraint(equalTo: aPhoto2.topAnchor, constant: 5).isActive = true //20
        aHItem2Title.leadingAnchor.constraint(equalTo: aPhoto2.trailingAnchor, constant: 10).isActive = true
        aHItem2Title.text = "Yonex Racket LZJ"
        
        let aHItem2Price = UILabel()
        aHItem2Price.textAlignment = .left
        aHItem2Price.textColor = .white
        aHItem2Price.font = .boldSystemFont(ofSize: 15)
        aScroll2.addSubview(aHItem2Price)
        aHItem2Price.translatesAutoresizingMaskIntoConstraints = false
        aHItem2Price.bottomAnchor.constraint(equalTo: aPhoto2.bottomAnchor, constant: 0).isActive = true //20
        aHItem2Price.leadingAnchor.constraint(equalTo: aPhoto2.trailingAnchor, constant: 10).isActive = true
        aHItem2Price.text = "$799"
        
        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .white
        aHSubDesc2.font = .systemFont(ofSize: 11)
        aScroll2.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.topAnchor.constraint(equalTo: aHItem2Title.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc2.leadingAnchor.constraint(equalTo: aPhoto2.trailingAnchor, constant: 10).isActive = true
        aHSubDesc2.text = "39 sold"
        aHSubDesc2.layer.opacity = 0.4
        
        let aHActionBtn2 = UIView()
        aHActionBtn2.backgroundColor = .ddmRedColor
        aScroll2.addSubview(aHActionBtn2)
        aHActionBtn2.translatesAutoresizingMaskIntoConstraints = false
        aHActionBtn2.trailingAnchor.constraint(equalTo: aScroll2.trailingAnchor, constant: -10).isActive = true
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
        aHActionText2.text = "Buy"
    }
    
    func getCurrentItemIndex(scrollView: UIScrollView) -> Int? {
        let contentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
        
        // Calculate the current item index based on the content offset and the scroll view's subviews
        for (index, subview) in scrollView.subviews.enumerated() {
            let subviewX = subview.frame.origin.x
            let subviewWidth = subview.frame.width
            
            if contentOffsetX >= subviewX && contentOffsetX < (subviewX + subviewWidth) {
                return index
            }
        }
        
        return nil // If the current item index cannot be determined
    }
}

extension ShopHighlightCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollview begin: \(scrollView.contentOffset.y)")
        
        delegate?.hcWillBeginDragging(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollview scroll: ")
        delegate?.hcScrollViewDidScroll(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let currentItemIndex = getCurrentItemIndex(scrollView: scrollView) {
            print("Current item index: \(currentItemIndex)")
            
            aTab1.layer.opacity = 0.2 //0.5
            aTab2.layer.opacity = 0.2 //0.5
            if(currentItemIndex == 0) {
                aTab2.layer.opacity = 0.5 //0.5
            } else if(currentItemIndex == 1) {
                aTab1.layer.opacity = 0.5 //0.5
            }
        } else {
            print("Unable to determine the current item index.")
        }
        
        delegate?.hcSrollViewDidEndDecelerating(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.hcScrollViewDidEndDragging(offsetY: scrollView.contentOffset.y, decelerate: decelerate)
    }
}
