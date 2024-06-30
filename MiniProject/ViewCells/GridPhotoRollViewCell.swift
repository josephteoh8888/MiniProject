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

class GridPhotoRollViewCell: UICollectionViewCell {
    static let identifier = "GridPhotoRollViewCell"
    var gifImage = SDAnimatedImageView()
    
    //test
    var photoImage = UIImageView()
//    weak var aDelegate : GridViewCellDelegate?
    
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
//        contentView.addSubview(videoContainer)
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.layer.cornerRadius = 5
//        contentView.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
//        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        contentView.addSubview(photoImage)
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoImage.layer.cornerRadius = 5
//        videoImage.isUserInteractionEnabled = true
//        videoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoSelectClicked)))
    }
//
//    @objc func onVideoSelectClicked(gesture: UITapGestureRecognizer) {
//
//    }
    
    func configure(with model: PHAsset) {
        PHCachingImageManager.default().requestImage(for: model, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (photo, _) in
            self.photoImage.image = photo
        }
    }
}

