//
//  GridVideoViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > grid viewcell for user panel
class GridVideoViewCell: UICollectionViewCell {
    static let identifier = "GridVideoViewCell"
    var gifImage = SDAnimatedImageView()
    
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
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
        gifImage.sd_setImage(with: imageUrl)
//        gifImage.layer.cornerRadius = 10
        gifImage.layer.cornerRadius = 5
        contentView.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
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
//        aSpinner.startAnimating()
        gifImage.isHidden = true
    }
//
    func dehideCell() {
//        aSpinner.stopAnimating()
        gifImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("upv gridvideo prepare for reuse")
    }
    
    func configure(data: PostData) {
        if(data.isGridHidden) {
            gifImage.isHidden = true
        } else{
            gifImage.isHidden = false
        }
    }
}
