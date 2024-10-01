//
//  VCAViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

//test > uicollectionview for videopanel VC-videocollectionview
protocol VCViewCellDelegate : AnyObject {
    func didClickUser()
    func didClickPlace()
    func didClickSound()
    func didClickComment()
    func didClickShare(vc: VCViewCell)
    func didClickRefresh()
}

class VCViewCell: UICollectionViewCell {
    func playVideo() {}
    func stopVideo() {}
    func pauseVideo() {}
    func resumeVideo() {}
    
    //test > destroy cell
    func destroyCell() {}
}

class VCAViewCell: VCViewCell {
    
    static let identifier = "VCAViewCell"
    var gifImage = SDAnimatedImageView()
    
    weak var aDelegate : VCViewCellDelegate?
    
    //test > video
//    var playerLooper: AVPlayerLooper!
//    var queuePlayer: AVQueuePlayer!
    let videoContainer = UIView()
    //test > avplayer instead of looper
    var player: AVPlayer!
    
    let playBtn = UIImageView()
    let playVideoView = UIView()
    let pauseVideoView = UIView()
    
    var vidPlayStatus = ""
    
    //test > love btn
    let dMiniBtn = UIImageView()
    let cBMiniBtn = UIImageView()
    
    //test > add loading spinner
    var aSpinner = SpinLoader()
    let aContainer = UIView()
    let aaText = UILabel()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    let mBtn = UIImageView()
    let vBtn = UIImageView()
    let mText = UILabel()
    let aTitleText = UILabel()
    let aNameText = UILabel()
    let eImage = SDAnimatedImageView()
    let aText = UILabel()
    
    let bText = UILabel()
    let cText = UILabel()
    let dText = UILabel()
    let cBText = UILabel()
    let mMiniC = UIView()
    let bMiniC = UIView()
    let cMiniC = UIView()
    let cBMiniC = UIView()
    let dMiniC = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        contentView.backgroundColor = .black
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true

        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
//        contentView.addSubview(videoContainer)
        
        //test > add loading spinner
        contentView.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        aSpinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.startAnimating()
        
        //test > indicate when there is no more data
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.font = .systemFont(ofSize: 12)
        aaText.font = .systemFont(ofSize: 13)
        contentView.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        aaText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
//        aaText.layer.opacity = 0.5 //0.5
        aaText.text = ""
//        aaText.isHidden = true
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        contentView.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20).isActive = true
//        errorText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        errorText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        errorText.text = ""
        
        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        contentView.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 10).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniRefreshBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniRefreshBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniRefreshBtn)
        bMiniRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniRefreshBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniRefreshBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniRefreshBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniRefreshBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test > add another container for video and like buttons etc
        contentView.addSubview(aContainer)
        aContainer.translatesAutoresizingMaskIntoConstraints = false
        aContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        aContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        aContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        aContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        aContainer.clipsToBounds = true
        aContainer.layer.cornerRadius = 10
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
        gifImage.layer.cornerRadius = 10
//        contentView.addSubview(gifImage)
        aContainer.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        gifImage.isHidden = true
        
//        contentView.addSubview(videoContainer)
        aContainer.addSubview(videoContainer)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        videoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        videoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        videoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 10
//        videoContainer.isHidden = true
        
        //video control buttons
//        contentView.addSubview(pauseVideoView)
        aContainer.addSubview(pauseVideoView)
        pauseVideoView.translatesAutoresizingMaskIntoConstraints = false
        pauseVideoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        pauseVideoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pauseVideoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        pauseVideoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pauseVideoView.isHidden = false
//        pauseVideoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
        //test > added double tap for love click shortcut
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked))
        atapGR.numberOfTapsRequired = 1
        pauseVideoView.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapped))
        tapGR.numberOfTapsRequired = 2
        pauseVideoView.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR)
        
//        contentView.addSubview(playVideoView)
        aContainer.addSubview(playVideoView)
        playVideoView.translatesAutoresizingMaskIntoConstraints = false
        playVideoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        playVideoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        playVideoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        playVideoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        playVideoView.isHidden = true
        playVideoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
        
//        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
//        contentView.addSubview(playBtn)
        playVideoView.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
//        mBtn.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 150).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        playBtn.layer.opacity = 0.5
        playBtn.layer.shadowColor = UIColor.gray.cgColor
        playBtn.layer.shadowRadius = 3.0  //ori 3
        playBtn.layer.shadowOpacity = 0.5 //ori 1
        playBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
//        playBtn.isUserInteractionEnabled = true
//        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
//        playBtn.isHidden = true
        
        //test text design in video panel
//        let mBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        mBtn.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
//        mBtn.tintColor = .black
        mBtn.tintColor = .white
//        contentView.addSubview(mBtn)
        aContainer.addSubview(mBtn)
        mBtn.translatesAutoresizingMaskIntoConstraints = false
        mBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        mBtn.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        mBtn.bottomAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: -30).isActive = true
        mBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        mBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mBtn.layer.shadowColor = UIColor.gray.cgColor
        mBtn.layer.shadowRadius = 1.0  //ori 3
        mBtn.layer.shadowOpacity = 0.5 //ori 1
        mBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
//        let mText = UILabel()
        mText.textAlignment = .left
        mText.textColor = .white
        mText.font = .boldSystemFont(ofSize: 13)
//        contentView.addSubview(mText)
        aContainer.addSubview(mText)
        mText.translatesAutoresizingMaskIntoConstraints = false
        mText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
        mText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
        mText.text = "-"
        mText.isUserInteractionEnabled = true
        mText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        mText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
//        let aTitleText = UILabel()
        aTitleText.textAlignment = .left
        aTitleText.textColor = .white
        aTitleText.font = .systemFont(ofSize: 14)
//        contentView.addSubview(aTitleText)
        aContainer.addSubview(aTitleText)
        aTitleText.translatesAutoresizingMaskIntoConstraints = false
//        aTitleText.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        aTitleText.bottomAnchor.constraint(equalTo: mText.topAnchor, constant: -10).isActive = true
        aTitleText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        aTitleText.text = "-"
//        aTitleText.layer.shadowColor = UIColor.black.cgColor
//        aTitleText.layer.shadowRadius = 1.0  //ori 3
//        aTitleText.layer.shadowOpacity = 1.0 //ori 1
//        aTitleText.layer.shadowOffset = CGSize(width: 0, height: 0)
        aTitleText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        aTitleText.numberOfLines = 2
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 15)
//        contentView.addSubview(aNameText)
        aContainer.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
        aNameText.bottomAnchor.constraint(equalTo: aTitleText.topAnchor, constant: -5).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        aNameText.text = "-"
//        aNameText.text = "@Michelle8899 @Michelle8899 @Michelle8899 @Michelle8899 @Michelle8899"
//        aNameText.layer.shadowColor = UIColor.black.cgColor
//        aNameText.layer.shadowRadius = 1.0  //ori 3
//        aNameText.layer.shadowOpacity = 1.0 //ori 1
//        aNameText.layer.shadowOffset = CGSize(width: 0, height: 0)
        aNameText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified_b")?.withRenderingMode(.alwaysTemplate))
//        vBtn.image = UIImage(named:"icon_round_verified_b")?.withRenderingMode(.alwaysTemplate)
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
//        vBtn.tintColor = .ddmGoldenYellowColor
        vBtn.tintColor = .white //darkGray
        aContainer.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.layer.shadowColor = UIColor.gray.cgColor
        vBtn.layer.shadowRadius = 1.0  //ori 3
        vBtn.layer.shadowOpacity = 0.5 //ori 1
        vBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        //
        
        //test semi-transparent info box
        let aBox = UIView()
        aBox.backgroundColor = .ddmBlackOverlayColor
//        contentView.addSubview(aBox)
        aContainer.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
//        aBox.heightAnchor.constraint(equalToConstant: 35).isActive = true //default: 50
//        aBox.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        aBox.bottomAnchor.constraint(equalTo: aNameText.topAnchor, constant: -10).isActive = true
        aBox.layer.cornerRadius = 10
        aBox.layer.opacity = 0.3
        aBox.isUserInteractionEnabled = true
        aBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        aBox.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        //test > white location btn => simpler version
        let bBox = UIView()
//        bBox.backgroundColor = .yellow //yellow
//        bBox.backgroundColor = .systemGreen
//        bBox.backgroundColor = .systemRed
//        bBox.backgroundColor = .systemBlue
//        contentView.addSubview(bBox)
        aContainer.addSubview(bBox)
        bBox.clipsToBounds = true
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 18).isActive = true //20
        bBox.heightAnchor.constraint(equalToConstant: 18).isActive = true
//        bBox.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        bBox.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 7).isActive = true //4
        bBox.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 6).isActive = true
        bBox.layer.cornerRadius = 5 //6

        let gridViewBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
//        let gridViewBtn = UIImageView(image: UIImage(named:"icon_round_location")?.withRenderingMode(.alwaysTemplate))
//        gridViewBtn.tintColor = .black
        gridViewBtn.tintColor = .white
        bBox.addSubview(gridViewBtn)
        gridViewBtn.translatesAutoresizingMaskIntoConstraints = false
        gridViewBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        gridViewBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
//        gridViewBtn.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
//        gridViewBtn.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 10).isActive = true //10
        gridViewBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true//16
        gridViewBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
//        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
        aText.font = .boldSystemFont(ofSize: 13)
//        contentView.addSubview(aText)
        aContainer.addSubview(aText)
        aText.clipsToBounds = true
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 8).isActive = true //5
        aText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -8).isActive = true
        aText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
//        aText.leadingAnchor.constraint(equalTo: gridViewBtn.trailingAnchor, constant: 10).isActive = true //10
        aText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
//        aText.text = "Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower"
        aText.text = "-"
//        aText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        aText.numberOfLines = 2
        
        //test music btn
//        let mMiniC = UIView()
        aContainer.addSubview(mMiniC)
        mMiniC.translatesAutoresizingMaskIntoConstraints = false
        mMiniC.bottomAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: -30).isActive = true
        mMiniC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        mMiniC.heightAnchor.constraint(equalToConstant: 40).isActive = true //default 44
        mMiniC.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mMiniC.isUserInteractionEnabled = true
        mMiniC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        
        let mMini = UIView()
        mMini.backgroundColor = .ddmBlackOverlayColor
//        aContainer.addSubview(mMini)
        mMiniC.addSubview(mMini)
        mMini.translatesAutoresizingMaskIntoConstraints = false
        mMini.bottomAnchor.constraint(equalTo: mMiniC.bottomAnchor, constant: 0).isActive = true
        mMini.topAnchor.constraint(equalTo: mMiniC.topAnchor, constant: 0).isActive = true
        mMini.leadingAnchor.constraint(equalTo: mMiniC.leadingAnchor, constant: 0).isActive = true
        mMini.trailingAnchor.constraint(equalTo: mMiniC.trailingAnchor, constant: 0).isActive = true
//        mMini.bottomAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: -30).isActive = true
//        mMini.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
//        mMini.heightAnchor.constraint(equalToConstant: 40).isActive = true //default 44
//        mMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mMini.layer.cornerRadius = 20 //20
        mMini.layer.opacity = 0.3 //0.7
        
//        let mImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let mImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let mImage = SDAnimatedImageView()
        mImage.contentMode = .scaleAspectFill
        mImage.layer.masksToBounds = true
        mImage.sd_setImage(with: mImageUrl)
        mImage.backgroundColor = .ddmDarkGreyColor
//        contentView.addSubview(mImage)
//        aContainer.addSubview(mImage)
        mMiniC.addSubview(mImage)
        mImage.translatesAutoresizingMaskIntoConstraints = false
        mImage.centerXAnchor.constraint(equalTo: mMini.centerXAnchor).isActive = true
        mImage.centerYAnchor.constraint(equalTo: mMini.centerYAnchor).isActive = true
        mImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        mImage.widthAnchor.constraint(equalToConstant: 26).isActive = true
        mImage.layer.cornerRadius = 13 //13
        
        //test semi transparent love count button
        aContainer.addSubview(bMiniC)
        bMiniC.translatesAutoresizingMaskIntoConstraints = false
        bMiniC.bottomAnchor.constraint(equalTo:  mMiniC.topAnchor, constant: -30).isActive = true
        bMiniC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        bMiniC.heightAnchor.constraint(equalToConstant: 40).isActive = true //default 44
        bMiniC.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bMiniC.isUserInteractionEnabled = true
        bMiniC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
        let bMini = UIView()
        bMini.backgroundColor = .ddmBlackOverlayColor
//        contentView.addSubview(bMini)
//        aContainer.addSubview(bMini)
        bMiniC.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
        bMini.bottomAnchor.constraint(equalTo: bMiniC.bottomAnchor, constant: 0).isActive = true
        bMini.topAnchor.constraint(equalTo: bMiniC.topAnchor, constant: 0).isActive = true
        bMini.leadingAnchor.constraint(equalTo: bMiniC.leadingAnchor, constant: 0).isActive = true
        bMini.trailingAnchor.constraint(equalTo: bMiniC.trailingAnchor, constant: 0).isActive = true
        bMini.layer.cornerRadius = 20
        bMini.layer.opacity = 0.3
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
        bMiniBtn.tintColor = .white
//        contentView.addSubview(bMiniBtn)
//        aContainer.addSubview(bMiniBtn)
        bMiniC.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor, constant: -2).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.isUserInteractionEnabled = true
//        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareClicked)))
        
//        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(bText)
        aContainer.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.topAnchor.constraint(equalTo: bMini.bottomAnchor, constant: 2).isActive = true
        bText.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bText.text = "-"
//        bText.layer.shadowColor = UIColor.black.cgColor
//        bText.layer.shadowRadius = 2.0  //ori 3
//        bText.layer.shadowOpacity = 1.0 //ori 1
//        bText.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        aContainer.addSubview(cBMiniC)
        cBMiniC.translatesAutoresizingMaskIntoConstraints = false
        cBMiniC.bottomAnchor.constraint(equalTo:  bMiniC.topAnchor, constant: -30).isActive = true
        cBMiniC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        cBMiniC.heightAnchor.constraint(equalToConstant: 40).isActive = true //default 44
        cBMiniC.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cBMiniC.isUserInteractionEnabled = true
        cBMiniC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
        let cBMini = UIView()
        cBMini.backgroundColor = .ddmBlackOverlayColor
//        contentView.addSubview(cMini)
//        aContainer.addSubview(cBMini)
        cBMiniC.addSubview(cBMini)
        cBMini.translatesAutoresizingMaskIntoConstraints = false
        cBMini.bottomAnchor.constraint(equalTo: cBMiniC.bottomAnchor, constant: 0).isActive = true
        cBMini.topAnchor.constraint(equalTo: cBMiniC.topAnchor, constant: 0).isActive = true
        cBMini.leadingAnchor.constraint(equalTo: cBMiniC.leadingAnchor, constant: 0).isActive = true
        cBMini.trailingAnchor.constraint(equalTo: cBMiniC.trailingAnchor, constant: 0).isActive = true
        cBMini.layer.cornerRadius = 20
        cBMini.layer.opacity = 0.3
        
//        let cBMiniBtn = UIImageView(image: UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate))
        cBMiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
        cBMiniBtn.tintColor = .white
//        contentView.addSubview(cMiniBtn)
//        aContainer.addSubview(cBMiniBtn)
        cBMiniC.addSubview(cBMiniBtn)
        cBMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cBMiniBtn.centerXAnchor.constraint(equalTo: cBMini.centerXAnchor).isActive = true
        cBMiniBtn.centerYAnchor.constraint(equalTo: cBMini.centerYAnchor).isActive = true
        cBMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        cBMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        cBMiniBtn.isUserInteractionEnabled = true
//        cBMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
        
//        let cBText = UILabel()
        cBText.textAlignment = .left
        cBText.textColor = .white
        cBText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(cText)
        aContainer.addSubview(cBText)
        cBText.clipsToBounds = true
        cBText.translatesAutoresizingMaskIntoConstraints = false
        cBText.topAnchor.constraint(equalTo: cBMini.bottomAnchor, constant: 2).isActive = true
        cBText.centerXAnchor.constraint(equalTo: cBMini.centerXAnchor).isActive = true
        cBText.text = "-"
        
        aContainer.addSubview(cMiniC)
        cMiniC.translatesAutoresizingMaskIntoConstraints = false
        cMiniC.bottomAnchor.constraint(equalTo:  cBMiniC.topAnchor, constant: -30).isActive = true
        cMiniC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        cMiniC.heightAnchor.constraint(equalToConstant: 40).isActive = true //default 44
        cMiniC.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cMiniC.isUserInteractionEnabled = true
        cMiniC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
        let cMini = UIView()
        cMini.backgroundColor = .ddmBlackOverlayColor
//        contentView.addSubview(cMini)
//        aContainer.addSubview(cMini)
        cMiniC.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
        cMini.bottomAnchor.constraint(equalTo: cMiniC.bottomAnchor, constant: 0).isActive = true
        cMini.topAnchor.constraint(equalTo: cMiniC.topAnchor, constant: 0).isActive = true
        cMini.leadingAnchor.constraint(equalTo: cMiniC.leadingAnchor, constant: 0).isActive = true
        cMini.trailingAnchor.constraint(equalTo: cMiniC.trailingAnchor, constant: 0).isActive = true
        cMini.layer.cornerRadius = 20
        cMini.layer.opacity = 0.3
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
        cMiniBtn.tintColor = .white
//        contentView.addSubview(cMiniBtn)
//        aContainer.addSubview(cMiniBtn)
        cMiniC.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        cMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        cMiniBtn.isUserInteractionEnabled = true
//        cMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentClicked)))
        
//        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(cText)
        aContainer.addSubview(cText)
        cText.clipsToBounds = true
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.topAnchor.constraint(equalTo: cMini.bottomAnchor, constant: 2).isActive = true
        cText.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cText.text = "-"
//        cText.layer.shadowColor = UIColor.black.cgColor
//        cText.layer.shadowRadius = 2.0  //ori 3
//        cText.layer.shadowOpacity = 1.0 //ori 1
//        cText.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        aContainer.addSubview(dMiniC)
        dMiniC.translatesAutoresizingMaskIntoConstraints = false
        dMiniC.bottomAnchor.constraint(equalTo:  cMiniC.topAnchor, constant: -30).isActive = true
        dMiniC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        dMiniC.heightAnchor.constraint(equalToConstant: 40).isActive = true //default 44
        dMiniC.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dMiniC.isUserInteractionEnabled = true
        dMiniC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
        let dMini = UIView()
        dMini.backgroundColor = .ddmBlackOverlayColor
//        contentView.addSubview(dMini)
//        aContainer.addSubview(dMini)
        dMiniC.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
        dMini.bottomAnchor.constraint(equalTo: dMiniC.bottomAnchor, constant: 0).isActive = true
        dMini.topAnchor.constraint(equalTo: dMiniC.topAnchor, constant: 0).isActive = true
        dMini.leadingAnchor.constraint(equalTo: dMiniC.leadingAnchor, constant: 0).isActive = true
        dMini.trailingAnchor.constraint(equalTo: dMiniC.trailingAnchor, constant: 0).isActive = true
        dMini.layer.cornerRadius = 20
        dMini.layer.opacity = 0.3
        
//        let dMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        dMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        dMiniBtn.tintColor = .white
//        dMiniBtn.tintColor = .ddmAccentColor
//        contentView.addSubview(dMiniBtn)
//        aContainer.addSubview(dMiniBtn)
        dMiniC.addSubview(dMiniBtn)
        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        dMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        dMiniBtn.isUserInteractionEnabled = true
//        dMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoveClicked)))
        
//        let dText = UILabel()
        dText.textAlignment = .left
        dText.textColor = .white
        dText.font = .boldSystemFont(ofSize: 10)
//        contentView.addSubview(dText)
        aContainer.addSubview(dText)
        dText.clipsToBounds = true
        dText.translatesAutoresizingMaskIntoConstraints = false
        dText.topAnchor.constraint(equalTo: dMini.bottomAnchor, constant: 2).isActive = true
        dText.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dText.text = "-"
//        dText.layer.shadowColor = UIColor.black.cgColor
//        dText.layer.shadowRadius = 2.0  //ori 3
//        dText.layer.shadowOpacity = 1.0 //ori 1
//        dText.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        let eMini = UIView()
//        eMini.backgroundColor = .ddmBlackOverlayColor
        eMini.backgroundColor = .white
//        contentView.addSubview(eMini)
        aContainer.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
        eMini.bottomAnchor.constraint(equalTo: dMini.topAnchor, constant: -25).isActive = true //-30
        eMini.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 44).isActive = true
        eMini.widthAnchor.constraint(equalToConstant: 44).isActive = true
        eMini.layer.cornerRadius = 22
        eMini.layer.opacity = 1.0 //default 0.3

//        let eImage = SDAnimatedImageView()
        eImage.contentMode = .scaleAspectFill
        eImage.layer.masksToBounds = true
//        let eImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        eImage.sd_setImage(with: eImageUrl)
        eImage.backgroundColor = .ddmDarkColor
//        contentView.addSubview(eImage)
        aContainer.addSubview(eImage)
        eImage.translatesAutoresizingMaskIntoConstraints = false
        eImage.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eImage.centerYAnchor.constraint(equalTo: eMini.centerYAnchor).isActive = true
        eImage.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        eImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eImage.layer.cornerRadius = 20
        eImage.isUserInteractionEnabled = true
        eImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
        let eAddRing = UIView()
//        eAddRing.backgroundColor = .black
//        eAddRing.backgroundColor = .ddmAccentColor
        eAddRing.backgroundColor = .ddmDarkColor
//        eAddRing.backgroundColor = .white
//        eAddRing.backgroundColor = .ddmGoldenYellowColor
//        contentView.addSubview(eAddRing)
        aContainer.addSubview(eAddRing)
        eAddRing.translatesAutoresizingMaskIntoConstraints = false
        eAddRing.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eAddRing.topAnchor.constraint(equalTo: eMini.bottomAnchor, constant: -10).isActive = true //-7
        eAddRing.heightAnchor.constraint(equalToConstant: 16).isActive = true //14
        eAddRing.widthAnchor.constraint(equalToConstant: 16).isActive = true //20
        eAddRing.layer.cornerRadius = 8
//        eAddRing.isHidden = true

        let eAddBtn = UIImageView(image: UIImage(named:"icon_round_add_circle")?.withRenderingMode(.alwaysTemplate))
//        eAddBtn.tintColor = .yellow
        eAddBtn.tintColor = .white
//        eAddBtn.tintColor = .ddmBlackOverlayColor
//        eAddBtn.tintColor = .ddmGoldenYellowColor
//        eAddBtn.tintColor = .black
        eAddRing.addSubview(eAddBtn)
//        aContainer.addSubview(eAddBtn)
        eAddBtn.translatesAutoresizingMaskIntoConstraints = false
        eAddBtn.centerXAnchor.constraint(equalTo: eAddRing.centerXAnchor).isActive = true
        eAddBtn.centerYAnchor.constraint(equalTo: eAddRing.centerYAnchor).isActive = true
        eAddBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //22
        eAddBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test dynamic caption/subtitle
//        let sBox = UIView()
        sBox.backgroundColor = .ddmBlackOverlayColor
//        sBox.backgroundColor = .yellow
//        contentView.addSubview(sBox)
        aContainer.addSubview(sBox)
        sBox.clipsToBounds = true
        sBox.translatesAutoresizingMaskIntoConstraints = false
        sBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
//        sBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 150).isActive = true
//        sBox.heightAnchor.constraint(equalToConstant: 35).isActive = true //default: 50
//        sBox.widthAnchor.constraint(equalToConstant: 35).isActive = true //default: 50
        sBox.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        sBox.bottomAnchor.constraint(equalTo: aBox.topAnchor, constant: -10).isActive = true
        sBox.layer.cornerRadius = 10
        sBox.layer.opacity = 0.3
        sBox.isHidden = true

//        let sText = UILabel()
        sText.textAlignment = .left
        sText.textColor = .white
//        sText.textColor = .ddmBlackOverlayColor
        sText.font = .boldSystemFont(ofSize: 14) //15
//        contentView.addSubview(sText)
        aContainer.addSubview(sText)
        sText.clipsToBounds = true
        sText.translatesAutoresizingMaskIntoConstraints = false
        sText.topAnchor.constraint(equalTo: sBox.topAnchor, constant: 10).isActive = true //5
        sText.bottomAnchor.constraint(equalTo: sBox.bottomAnchor, constant: -10).isActive = true //-5
        sText.leadingAnchor.constraint(equalTo: sBox.leadingAnchor, constant: 10).isActive = true
        sText.trailingAnchor.constraint(equalTo: sBox.trailingAnchor, constant: -10).isActive = true
        sText.text = ""
        sText.numberOfLines = 0
//        sText.lineBreakMode = .byWordWrapping
        
        //test > carousel of images > tested OK
//        let scrollView = UIScrollView()
//        aContainer.addSubview(scrollView)
//        scrollView.backgroundColor = .clear
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.bottomAnchor.constraint(equalTo: sBox.topAnchor, constant: -10).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: aContainer.leadingAnchor, constant: 0).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: aContainer.trailingAnchor, constant: 0).isActive = true
//        scrollView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        scrollView.showsHorizontalScrollIndicator = false
////        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight - 150)
////        scrollView.delegate = self
//        scrollView.alwaysBounceHorizontal = true
//        scrollView.contentSize = CGSize(width: 670, height: 120)
//
//        let aHLight1 = UIView()
//        aHLight1.backgroundColor = .ddmBlackOverlayColor
////        panelView.addSubview(aHLight1)
//        scrollView.addSubview(aHLight1)
//        aHLight1.translatesAutoresizingMaskIntoConstraints = false
////        aHLight1.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        aHLight1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
//        aHLight1.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        aHLight1.heightAnchor.constraint(equalToConstant: 80).isActive = true //30
////        aHLight1.topAnchor.constraint(equalTo: aBioText.bottomAnchor, constant: 20).isActive = true
//        aHLight1.bottomAnchor.constraint(equalTo: sBox.topAnchor, constant: -10).isActive = true
//        aHLight1.layer.cornerRadius = 10
//        aHLight1.layer.opacity = 0.3
//
//        let aHLight2 = UIView()
//        aHLight2.backgroundColor = .ddmBlackOverlayColor
////        panelView.addSubview(aHLight2)
//        scrollView.addSubview(aHLight2)
//        aHLight2.translatesAutoresizingMaskIntoConstraints = false
//        aHLight2.leadingAnchor.constraint(equalTo: aHLight1.trailingAnchor, constant: 10).isActive = true
//        aHLight2.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        aHLight2.heightAnchor.constraint(equalToConstant: 80).isActive = true //30
//        aHLight2.bottomAnchor.constraint(equalTo: sBox.topAnchor, constant: -10).isActive = true
//        aHLight2.layer.cornerRadius = 10
//        aHLight2.layer.opacity = 0.3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("videocv prepare for reuse A")
        
        //*test > remove time observer
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        //*
        
        aTitleText.text = "-"
        aNameText.text = "-"
        mText.text = "-"
        vBtn.image = nil
        aText.text = "-"
        let eImageUrl = URL(string: "")
        eImage.sd_setImage(with: eImageUrl)
        
        bText.text = "0"
        cText.text = "0"
        dText.text = "0"
        cBText.text = "0"
        
        aSpinner.stopAnimating()
        
        let imageUrl = URL(string: "")
        gifImage.sd_setImage(with: imageUrl)
        gifImage.isHidden = true
        aContainer.isHidden = true
        aaText.isHidden = true
        aaText.text = ""
        errorText.isHidden = true
        errorText.text = ""
        errorRefreshBtn.isHidden = true
    }
    
    //test > destroy view to avoid timeobserver memory leak
    override func destroyCell() {
        print("vcAviewcell destroy cell")
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
//        print("click open user panel:")
        aDelegate?.didClickRefresh()
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        print("click open user panel:")
        aDelegate?.didClickUser()
    }
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        print("click open place panel:")
        aDelegate?.didClickPlace()
    }
    @objc func onSoundClicked(gesture: UITapGestureRecognizer) {
        print("click open sound panel:")
        aDelegate?.didClickSound()
    }
    @objc func onCommentClicked(gesture: UITapGestureRecognizer) {
        print("click open comment panel:")
        aDelegate?.didClickComment()
    }
    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
        print("click share panel:")
        aDelegate?.didClickShare(vc: self)
    }
    @objc func onLoveClicked(gesture: UITapGestureRecognizer) {
        print("click love panel:")
        reactOnLoveClick()
    }
    @objc func onBookmarkClicked(gesture: UITapGestureRecognizer) {
        print("click bookmark panel:")
        reactOnBookmarkClick()
    }
    
    @objc func onPauseVideoClicked(gesture: UITapGestureRecognizer) {
        print("click pause video:")

        pauseVideoView.isHidden = true
        playVideoView.isHidden = false
        pauseVideo()
    }
    @objc func onResumeVideoClicked(gesture: UITapGestureRecognizer) {
        print("click resume video:")

        pauseVideoView.isHidden = false
        playVideoView.isHidden = true
        resumeVideo()
    }
    //test > double tap to love a video
    @objc func onDoubleTapped(gesture: UITapGestureRecognizer) {
        print("click double tapped video:")
        
        let aColor = dMiniBtn.tintColor
        if(aColor == .white) {
            reactOnLoveClick()
            
            let translation = gesture.location(in: self)
            let x = translation.x
            let y = translation.y
            
            let bigLove = UIImageView(frame: CGRect(x: x - 16.0, y: y - 16.0, width: 32, height: 32))
            bigLove.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
            bigLove.tintColor = .red
            aContainer.addSubview(bigLove)
            
            UIView.animate(withDuration: 0.3, animations: {
                bigLove.frame = CGRect(x: x - 35.0, y: y - 35.0, width: 70, height: 70)
            }, completion: { _ in
    //            bigLove.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: {
                    bigLove.frame = CGRect(x: x - 5.0, y: y - 5.0, width: 10, height: 10)
                }, completion: { _ in
                    bigLove.removeFromSuperview()
                })
            })
            print("video double clicked: \(x), \(y)")
        }
    }

    func reactOnLoveClick() {
        let aColor = dMiniBtn.tintColor
        if(aColor == .white) {
            dMiniBtn.tintColor = .red //ddmAccentColor
        } else {
            dMiniBtn.tintColor = .white
        }
        
        //method 2
        updateResult()
    }
    func reactOnBookmarkClick() {
        let aColor = cBMiniBtn.tintColor
        if(aColor == .white) {
            cBMiniBtn.tintColor = .ddmGoldenYellowColor //ddmAccentColor
        } else {
            cBMiniBtn.tintColor = .white
        }
        
    }
    
    var searchTimer: Timer?
    func updateResult() {
        //Invalidate and Reinitialise
        self.searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] (timer) in
            print("love async timer")
            //update dataset
        })
    }
    
    //*test > async fetch user profile, name, follow status etc
    func asyncConfigure(data: String) {
        let id = "u"
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    self.aNameText.text = "Michael Kins"
                    self.vBtn.image = UIImage(named:"icon_round_verified_b")?.withRenderingMode(.alwaysTemplate)
                    
                    let eImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
                    self.eImage.sd_setImage(with: eImageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.aNameText.text = "-"
                    self.vBtn.image = nil
                    
                    let eImageUrl = URL(string: "")
                    self.eImage.sd_setImage(with: eImageUrl)
                    
                }
                break
            }
        }
    }
    //*
    
    //test > async fetch asset
    //TODO: add a horizontal flashing loader for loading video & a warning text for error
    func asyncConfigureVideo(data: VideoData) {
        
        let id = "s"
        DataFetchManager.shared.fetchSoundData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test 2 > try video without looper, use conventional avplayer
                    var videoURL = ""
                    if(data.dataType == "a") {
                        videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
                    }

                    let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
                    
                    if(self.player != nil && self.player.currentItem != nil) {
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    }
                    
                    let item2 = AVPlayerItem(url: url)
                    self.player = AVPlayer(playerItem: item2)
                    let layer2 = AVPlayerLayer(player: self.player)
                    layer2.frame = self.contentView.bounds //videoContainer.bounds will have problem as vc is not displayed yet
                    layer2.videoGravity = .resizeAspectFill
                    self.videoContainer.layer.addSublayer(layer2)
                    
                    //test > get duration of video 2
                    let d = self.getDuration(ofVideoAt: url)
                    
                    self.addTimeObserver()
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    
                    //seek to previously viewed state t_s
                    self.player?.seek(to: .zero)
//                    let seekTime = CMTime(seconds: self.t_s_, preferredTimescale: CMTimeScale(1000)) //1000
//                    self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    //test > autoplay video after video loaded
                    if(self.vidPlayStatus == "play") {
                        self.resumeVideo()
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    //error handling e.g. refetch button
                }
                break
            }
        }
    }
    
    //test > configure cell
    func configure(data: VideoData) {
        
        //test > change ui with data accordingly
        aSpinner.stopAnimating()
        gifImage.isHidden = true
        aContainer.isHidden = true
        aaText.isHidden = true
        errorText.isHidden = true
        errorRefreshBtn.isHidden = true

        let dataText = data.dataTextString
        var videoURL = ""
        
        if(data.dataType == "b") { // b - loading data
            aSpinner.startAnimating()
        } else if(data.dataType == "c") { // c - no more data
            aaText.text = dataText
            aaText.isHidden = false
        } else if(data.dataType == "d") { // d - empty data
            aaText.text = dataText
            aaText.isHidden = false
        } else if(data.dataType == "e") { // e - something went wrong
            errorText.text = dataText
            errorText.isHidden = false
            errorRefreshBtn.isHidden = false
        }
        //*test > post suspended and not found
        else if(data.dataType == "na") { // na - not found
            aaText.text = "Loop does not exist."
            aaText.isHidden = false
        }
        else if(data.dataType == "us") { // us - suspended
            aaText.text = "Loop violated community rules."
            aaText.isHidden = false
        }
        else if(data.dataType == "a") { // a - video play
            aContainer.isHidden = false
            
            asyncConfigure(data: "") //get creator data, e.g. name
            
            aTitleText.text = dataText
            aText.text = "Suntec City Hall 1B"
            mText.text = "明知故犯 - HubertWu 明知故犯 - HubertWu 明知故犯 - HubertWu 明知故犯 - HubertWu"
            
            //populate data count
            let dataC = data.dataCount
            if let loveC = dataC["love"] {
                dText.text = String(loveC)
            }
            if let commentC = dataC["comment"] {
                cText.text = String(commentC)
            }
            if let bookmarkC = dataC["bookmark"] {
                cBText.text = String(bookmarkC)
            }
            if let shareC = dataC["share"] {
                bText.text = String(shareC)
            }
            
            //avplayer with loop
    //        video urls: temp_video_1.mp4, temp_video_2.mp4, temp_video_3.mp4, temp_video_4.mp4
//            videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
            
//            let imageUrl = URL(string: "")
            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            gifImage.sd_setImage(with: imageUrl)
            gifImage.isHidden = false
        }

        //ori => tested OK
//        let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
//        self.queuePlayer = AVQueuePlayer()
//        let playerView = AVPlayerLayer(player: queuePlayer)
//        let playerItem = AVPlayerItem(url: url)
//        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
//        playerView.frame = contentView.bounds
//        playerView.videoGravity = .resizeAspectFill
//        videoContainer.layer.addSublayer(playerView)
//
//        pauseVideoView.isHidden = false
//        playVideoView.isHidden = true
//
//        stopVideo()
//        print("dummy configure: \(data)")
//
//        //test > get duration of video 2
//        let d = getDuration(ofVideoAt: url)
//        print("vcviewcell duration: \(d)")
//
//        //test > TimeObserver for progresslistener
//        addTimeObserver()
        
        //test 2 > try video without looper, use conventional avplayer
//        let url = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL)
//        
//        if(self.player != nil && self.player.currentItem != nil) {
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
//        }
//        
//        let item2 = AVPlayerItem(url: url)
//        self.player = AVPlayer(playerItem: item2)
//        let layer2 = AVPlayerLayer(player: self.player)
//        layer2.frame = contentView.bounds //videoContainer.bounds will have problem as vc is not displayed yet
//        layer2.videoGravity = .resizeAspectFill
//        self.videoContainer.layer.addSublayer(layer2)
//        
//        self.addTimeObserver()
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        //test 3 > async load video
        asyncConfigureVideo(data: data)
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        playVideo()
    }
    
    func getDuration(ofVideoAt videoURL: URL) -> Double? {
        let asset = AVURLAsset(url: videoURL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if durationInSeconds.isNaN {
            return nil
        } else {
            return durationInSeconds
        }
    }
    
    //***test > add time observer for progresslistener
    var timeObserverToken: Any?
    let sBox = UIView()
    let sText = UILabel()
//    let sText = UIOutlinedLabel()
    func addTimeObserver() {
        print("addTimeObserver A: \(timeObserverToken), \(player)")
        
        //test > time observer
        let timeInterval = CMTime(seconds: 0.02, preferredTimescale: CMTimeScale(1000)) //0.01 sec intervalc
//        timeObserverToken = queuePlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {[weak self] time in
        //test > new method
//        if let tokenV = timeObserverToken {
//            //check if token exists
//        } else {
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {[weak self] time in
                    
                let currentTime = time.seconds
                print("Current time A: \(currentTime)")
                    
                // Update UI with current time
                if(currentTime < 0.0) {
                    self?.sText.text = ""
                } else if(currentTime < 1.0) {
    //                self?.sText.text = "LOL....Hahaha✅"
                    self?.sText.text = "馬克宏稱挺台海"
                } else if(currentTime < 2.0) {
    //                self?.sText.text = "😈😈Oopss!!! OMG we gotta GO!!"
                    self?.sText.text = "被爆料阻援烏"
                } else if(currentTime < 3.0) {
                    self?.sText.text = "Bye for now Cya🤖"
    //                self?.sText.text = "｜宋國誠｜桑普｜"
    //                self?.sText.text = ""
                } else if(currentTime < 4.0) {
                    self?.sText.text = "LOL✌️....Hahaha LOL✌️....Hahaha LOL✌️....Hahaha LOL✌️....Hahaha LOL✌️....Hahaha LOL✌️....Hahaha LOL✌️....Hahaha"
    //                self?.sText.text = "總統沒什麼好道歉的"
                } else if(currentTime < 5.0) {
    //                self?.sText.text = "🤡Oopss!!! OMG we gotta GO!!"
                    self?.sText.text = "質疑馬克宏阻擋歐盟援助20億!!"
                } else if(currentTime < 6.0) {
    //                self?.sText.text = "😻Bye for now Cya"
    //                self?.sText.text = "另外印度有媒體12日爆料"
                    self?.sText.text = ""
                } else if(currentTime < 7.0) {
    //                self?.sText.text = "LOL..👻..Hahaha"
                    self?.sText.text = "百萬發砲彈給烏克蘭的進度"
                } else {
    //                self?.sText.text = "💩"
                    self?.sText.text = "#馬克宏 #范德賴恩 #新聞大破解"
                }
                
                if(self?.sText.text == "") {
                    self?.sBox.isHidden = true
                } else {
                    self?.sBox.isHidden = false
                }
            }
//        }
    }
    
    func removeTimeObserverVideo() {
        //remove video observer
        if let tokenV = timeObserverToken {
            player?.removeTimeObserver(tokenV)
            timeObserverToken = nil
        }
        
        //test > for looping
        if(player != nil && player.currentItem != nil) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }

    //example of srt file, start and end time => hours, minutes, seconds, and milliseconds
//    1
//    00:00:10,000 --> 00:00:15,000
//    Welcome to our video on the benefits of exercise.
//
//    2
//    00:00:16,000 --> 00:00:20,000
//    Regular exercise can improve your physical and mental health.
//
//    3
//    00:00:21,000 --> 00:00:25,000
//    It can also help you maintain a healthy weight and reduce your risk of chronic diseases.
//
//    4
//    00:00:26,000 --> 00:00:30,000
//    So, make sure to incorporate exercise into your daily routine.
//
//    5
//    00:00:31,000 --> 00:00:35,000
//    Thanks for watching!
    //****
    
    override func playVideo() {
        pauseVideoView.isHidden = false
        playVideoView.isHidden = true
        
//        queuePlayer.seek(to: .zero)
//        queuePlayer.play()
        
        player?.seek(to: .zero)
        player?.play()
        
        vidPlayStatus = "play"
    }
    
    override func stopVideo() {
        
//        queuePlayer.seek(to: .zero)
//        queuePlayer.pause()
        
        player?.seek(to: .zero)
        player?.pause()
        
        vidPlayStatus = "pause"
        
        print("cell stop video")
    }
    
    override func pauseVideo() {
        
//        queuePlayer.pause()
        player?.pause()
        
        vidPlayStatus = "pause"
    }
    
    override func resumeVideo() {
        pauseVideoView.isHidden = false
        playVideoView.isHidden = true
        
//        queuePlayer.play()
        player?.play()
        
        vidPlayStatus = "play"
    }
}
