//
//  MultiSelectedCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import PhotosUI
import Photos

protocol MultiSelectedCellDelegate : AnyObject {
    func didClickMultiSelectedCell(cell: MultiSelectedCell, gridIdx: Int)
}

//for selected cells in camera video and photo roll
class MultiSelectedCell: UIView {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
//    let gifImage1 = SDAnimatedImageView()
    let gifImage1 = UIImageView()
    weak var aDelegate : MultiSelectedCellDelegate?
    
    var gridAssetIdx = -1
    
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
        
        let pConBg = UIView()
//        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
//        pConBg.layer.cornerRadius = 10
        pConBg.isUserInteractionEnabled = true
        pConBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))
        
        pConBg.addSubview(gifImage1)
        gifImage1.contentMode = .scaleAspectFill
        gifImage1.clipsToBounds = true
        gifImage1.translatesAutoresizingMaskIntoConstraints = false
        gifImage1.widthAnchor.constraint(equalToConstant: viewWidth - 10).isActive = true //180
        gifImage1.heightAnchor.constraint(equalToConstant: viewHeight - 10).isActive = true //280
        gifImage1.centerXAnchor.constraint(equalTo: pConBg.centerXAnchor, constant: 0).isActive = true
        gifImage1.centerYAnchor.constraint(equalTo: pConBg.centerYAnchor, constant: 0).isActive = true
        gifImage1.layer.cornerRadius = 5
        
        let eAddRing = UIView()
        eAddRing.backgroundColor = .ddmDarkColor
        pConBg.addSubview(eAddRing)
        eAddRing.translatesAutoresizingMaskIntoConstraints = false
        eAddRing.trailingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: -2).isActive = true
        eAddRing.topAnchor.constraint(equalTo: gifImage1.topAnchor, constant: 2).isActive = true //-7
        eAddRing.heightAnchor.constraint(equalToConstant: 12).isActive = true //14
        eAddRing.widthAnchor.constraint(equalToConstant: 12).isActive = true //20
        eAddRing.layer.cornerRadius = 6
        eAddRing.layer.opacity = 0.7

        let eAddBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        eAddBtn.tintColor = .white
        eAddRing.addSubview(eAddBtn)
        eAddBtn.translatesAutoresizingMaskIntoConstraints = false
        eAddBtn.centerXAnchor.constraint(equalTo: eAddRing.centerXAnchor).isActive = true
        eAddBtn.centerYAnchor.constraint(equalTo: eAddRing.centerYAnchor).isActive = true
        eAddBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true //22
        eAddBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    func configure(url: URL) {
        gifImage1.sd_setImage(with: url)
    }
    
//    func configure(img: UIImage) {
//        gifImage1.image = img
//    }
    
    func configure(with m: PHAsset) {
        PHCachingImageManager.default().requestImage(for: m, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (photo, _) in
            self.gifImage1.image = photo
        }
    }
    
    func setGridIdx(idx: Int) {
        gridAssetIdx = idx
    }
    
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didClickMultiSelectedCell(cell: self, gridIdx: gridAssetIdx)
    }
}

