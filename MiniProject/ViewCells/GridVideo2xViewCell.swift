//
//  GridVideo2xViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > grid viewcell for place panel
class GridVideo2xViewCell: UICollectionViewCell {
    static let identifier = "GridVideo2xViewCell"
    var gifImage = SDAnimatedImageView()
    
    weak var aDelegate : GridViewCellDelegate?
    
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
        self.backgroundColor = .ddmDarkColor
        self.layer.cornerRadius = 5
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
        gifImage.layer.cornerRadius = 5 //10
        contentView.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gifImage.isUserInteractionEnabled = true
        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGifImageClicked)))
        
        //test > add loading spinner
//        contentView.addSubview(aSpinner)
//        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
//        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        aSpinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        aSpinner.startAnimating()
    }
    
//    @objc func onGifImageClicked(gesture: UITapGestureRecognizer) {
//        startAnimateSpinner()
//    }
//
    func hideCell() {
        gifImage.isHidden = true
    }

    func dehideCell() {
        gifImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("upv gridvideo2x prepare for reuse")
        
        let imageUrl = URL(string: "")
        gifImage.sd_setImage(with: imageUrl)
    }
    
    func configure(data: PostData) {
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage.sd_setImage(with: imageUrl)
    }
    
    @objc func onGifImageClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.gridViewClick(vc: self)
    }
}
