//
//  GridVideoRollViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import Photos

//protocol GridVideoRollViewCellDelegate : AnyObject {
//    func didClickVideoSelect()
//}
//test > grid viewcell for user panel
class GridVideoRollViewCell: UICollectionViewCell {
    static let identifier = "GridVideoRollViewCell"
    var gifImage = SDAnimatedImageView()
    let dMiniText = UILabel()
    
    //test
    var videoImage = UIImageView()
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

//        videoImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        videoImage.layer.cornerRadius = 20
        contentView.addSubview(videoImage)
        videoImage.contentMode = .scaleAspectFill
        videoImage.clipsToBounds = true
        videoImage.translatesAutoresizingMaskIntoConstraints = false
        videoImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        videoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        videoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        videoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        videoImage.layer.cornerRadius = 5
//        videoImage.isUserInteractionEnabled = true
//        videoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoSelectClicked)))
        
//        let dMiniText = UILabel()
        dMiniText.textAlignment = .left
        dMiniText.textColor = .white
        dMiniText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(dMiniText)
        dMiniText.translatesAutoresizingMaskIntoConstraints = false
        dMiniText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        dMiniText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        dMiniText.text = "00:00"
    }
//
//    @objc func onVideoSelectClicked(gesture: UITapGestureRecognizer) {
//
//    }
    
    func configure(with model: PHAsset) {
        PHCachingImageManager.default().requestImage(for: model, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (photo, _) in
            self.videoImage.image = photo
            
//            print("gridvideo: \(self.getVideoDuration(for: model))")
            if let t = self.getVideoDuration(for: model) {
                self.dMiniText.text = self.convertSecondsToMinutesAndSeconds(seconds: t)
            }
        }
    }

    func getVideoDuration(for asset: PHAsset) -> TimeInterval? {
        guard asset.mediaType == .video else {
            return nil // Return nil if the asset is not a video
        }

        let duration = asset.duration
        return duration
    }
    
    //helper function => time duration formatter in 00:00 format
    func convertSecondsToMinutesAndSeconds(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        let formattedDuration = formatter.string(from: seconds)
        return formattedDuration ?? ""
    }
}
