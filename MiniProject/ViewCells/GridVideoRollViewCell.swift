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

//test > grid viewcell for user panel
class GridVideoRollViewCell: UICollectionViewCell {
    static let identifier = "GridVideoRollViewCell"
    var gifImage = SDAnimatedImageView()
    let dMiniText = UILabel()
    
    //test
    var videoImage = UIImageView()
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
        videoImage.backgroundColor = .ddmDarkColor
        videoImage.isUserInteractionEnabled = true
        videoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoSelectClicked)))
        
//        let dMiniText = UILabel()
        dMiniText.textAlignment = .left
        dMiniText.textColor = .white
        dMiniText.font = .boldSystemFont(ofSize: 10)
        contentView.addSubview(dMiniText)
        dMiniText.translatesAutoresizingMaskIntoConstraints = false
        dMiniText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        dMiniText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        dMiniText.text = "00:00"
        
//        let selector = UIView()
        selector.backgroundColor = .yellow
        contentView.addSubview(selector)
        selector.translatesAutoresizingMaskIntoConstraints = false
//        selector.leadingAnchor.constraint(equalTo: photoImage.leadingAnchor, constant: 20).isActive = true
        selector.trailingAnchor.constraint(equalTo: videoImage.trailingAnchor, constant: -5).isActive = true
        selector.topAnchor.constraint(equalTo: videoImage.topAnchor, constant: 5).isActive = true //10
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
//            self.videoImage.image = photo
//            
////            print("gridvideo: \(self.getVideoDuration(for: model))")
//            if let t = self.getVideoDuration(for: model) {
//                self.dMiniText.text = self.convertSecondsToMinutesAndSeconds(seconds: t)
//            }
//        }
//    }
    
    //test 2 > new data model for asset to include selection order
    func configure(with gridAsset: GridAssetData) {
        if let m = gridAsset.model {
            PHCachingImageManager.default().requestImage(for: m, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (photo, _) in
                self.videoImage.image = photo
                
    //            print("gridvideo: \(self.getVideoDuration(for: model))")
                if let t = self.getVideoDuration(for: m) {
                    self.dMiniText.text = self.convertSecondsToMinutesAndSeconds(seconds: t)
                }
                
                if(gridAsset.selectedOrder > -1) {
                    self.selector.isHidden = false
                    let order = gridAsset.selectedOrder + 1
                    self.aSelectorNumber.text = String(order)
                }
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.videoImage.image = nil
        
        self.selector.isHidden = true
        self.aSelectorNumber.text = ""
    }
}
