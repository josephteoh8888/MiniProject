//
//  GridVideoViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol GridViewCellDelegate : AnyObject {
    func gridViewClick(vc: UICollectionViewCell)
}
//test > grid viewcell for user panel
class GridVideoViewCell: UICollectionViewCell {
    static let identifier = "GridVideoViewCell"
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
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
        gifImage.layer.cornerRadius = 5
        contentView.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gifImage.isUserInteractionEnabled = true
        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
        
        //stats count
//        let playBtn = UIImageView()
//        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
////        playBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
//        playBtn.tintColor = .white
//        contentView.addSubview(playBtn)
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        playBtn.bottomAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: -5).isActive = true
//        playBtn.trailingAnchor.constraint(equalTo: gifImage.trailingAnchor, constant: -5).isActive = true
////                playBtn.leadingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
//        playBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //12
//        playBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
//
//        let aaText = UILabel()
//        aaText.textAlignment = .left
//        aaText.textColor = .white
////        aaText.font = .systemFont(ofSize: 12)
//        aaText.font = .boldSystemFont(ofSize: 10)
//        aaText.numberOfLines = 1
//        contentView.addSubview(aaText)
//        aaText.translatesAutoresizingMaskIntoConstraints = false
//        aaText.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
////        aaText.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: -2).isActive = true //0
//        aaText.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: 0).isActive = true //0
//        aaText.text = "313"
    }
    
    func hideCell() {
        gifImage.isHidden = true
    }

    func dehideCell() {
        gifImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("upv gridvideo prepare for reuse")
        
        let imageUrl = URL(string: "")
        gifImage.sd_setImage(with: imageUrl)
    }
    
    func configure(data: PostData) {
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        gifImage.sd_setImage(with: imageUrl)
    }
    
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.gridViewClick(vc: self)
    }
    
}
