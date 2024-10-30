//
//  GridPhotoRollViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import Photos

protocol GridAssetDelegate : AnyObject {
    func gridAssetCellDidClickAsset(vc: UICollectionViewCell)
}

class GridPhotoRollViewCell: UICollectionViewCell {
    static let identifier = "GridPhotoRollViewCell"
    var gifImage = SDAnimatedImageView()
    
    //test
    var photoImage = UIImageView()
    weak var aDelegate : GridAssetDelegate?
    
    let selector = UIView()
    let aSelectorNumber = UILabel()
    
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
        contentView.addSubview(photoImage)
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoImage.layer.cornerRadius = 5
        photoImage.backgroundColor = .ddmDarkColor
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoSelectClicked)))
        
//        let selector = UIView()
        selector.backgroundColor = .yellow
        contentView.addSubview(selector)
        selector.translatesAutoresizingMaskIntoConstraints = false
//        selector.leadingAnchor.constraint(equalTo: photoImage.leadingAnchor, constant: 20).isActive = true
        selector.trailingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: -5).isActive = true
        selector.topAnchor.constraint(equalTo: photoImage.topAnchor, constant: 5).isActive = true //10
        selector.heightAnchor.constraint(equalToConstant: 20).isActive = true
        selector.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selector.layer.cornerRadius = 10
//        selector.layer.opacity = 0.5
//        selector.layer.borderWidth = 1.0 //2
//        selector.layer.borderColor = UIColor.white.cgColor //default
        selector.isHidden = true
        
//        let aSelectorNumber = UILabel()
        aSelectorNumber.textAlignment = .center
//        aSelectorNumber.textColor = .white
        aSelectorNumber.textColor = .black
        aSelectorNumber.font = .boldSystemFont(ofSize: 11) //12
//        aSelectorNumber.font = .systemFont(ofSize: 12)
        selector.addSubview(aSelectorNumber)
        aSelectorNumber.translatesAutoresizingMaskIntoConstraints = false
        aSelectorNumber.centerXAnchor.constraint(equalTo: selector.centerXAnchor, constant: 0).isActive = true
        aSelectorNumber.centerYAnchor.constraint(equalTo: selector.centerYAnchor, constant: 0).isActive = true
        aSelectorNumber.text = ""
    }

    @objc func onVideoSelectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.gridAssetCellDidClickAsset(vc: self)
    }
    
    func refreshSelectorOrder(gridAsset: GridAssetData) {
        if(gridAsset.selectedOrder > -1) {
            self.selector.isHidden = false
            let order = gridAsset.selectedOrder + 1
            self.aSelectorNumber.text = String(order)
        }
        else {
            selector.isHidden = true
            self.aSelectorNumber.text = ""
        }
    }
    
//    func configure(with model: PHAsset) {
//        PHCachingImageManager.default().requestImage(for: model, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (photo, _) in
//            self.photoImage.image = photo
//        }
//    }
    
    //test 2 > new data model for asset to include selection order
    func configure(with gridAsset: GridAssetData) {
        if let m = gridAsset.model {
            PHCachingImageManager.default().requestImage(for: m, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (photo, _) in
                self.photoImage.image = photo
                
                if(gridAsset.selectedOrder > -1) {
                    self.selector.isHidden = false
                    let order = gridAsset.selectedOrder + 1
                    self.aSelectorNumber.text = String(order)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImage.image = nil
        
        self.selector.isHidden = true
        self.aSelectorNumber.text = ""
    }
}

