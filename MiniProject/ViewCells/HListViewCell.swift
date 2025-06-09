//
//  HListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HListCellDelegate : AnyObject {
    func hListDidClickVcvComment(vc: UICollectionViewCell, id: String, dataType: String)
    func hListDidClickVcvLove()
    func hListDidClickVcvShare(vc: UICollectionViewCell, id: String, dataType: String)
    func hListDidClickVcvClickUser(id: String)
    func hListDidClickVcvClickPlace(id: String)
    func hListDidClickVcvClickSound(id: String)
    func hListDidClickVcvClickPost(id: String, dataType: String)
    func hListDidClickVcvClickPhoto(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func hListDidClickVcvClickVideo(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func hListDidClickVcvSortComment()
    func hListIsScrollCarousel(isScroll: Bool)
    
    //test > carousel photo scroll page
    func hListCarouselIdx(vc: UICollectionViewCell, aIdx: Int, idx: Int)
    
    //test > video stop time
    func hListVideoStopTime(vc: UICollectionViewCell, aIdx: Int, ts: Double)
    
    //test > click play sound
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell)
    
    func hListDidClickVcvClickPlay(vc: UICollectionViewCell, isPlay: Bool)
    
    //test > reload item for resizing
    func hListResize(vc: UICollectionViewCell)
}

//test > horizontal list viewcell for sound panel
class HListViewCell: UICollectionViewCell {
    static let identifier = "HListViewCell"
    var gifImage = SDAnimatedImageView()
    
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
        let aResult = UIView()
        aResult.backgroundColor = .ddmDarkColor
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true //20
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        aResult.layer.cornerRadius = 10
        aResult.layer.opacity = 0.3 //0.3
        ////////////////////
        ///
//        let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        var gifImage = SDAnimatedImageView()
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: gifUrl)
//        gifImage.layer.cornerRadius = 5 //5
//        contentView.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
//        gifImage.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 24
//        gifImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        gifImage.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
//        gifImage.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
    }
}
