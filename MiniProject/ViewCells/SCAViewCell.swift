//
//  MeHistoryListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 20/07/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol SCViewCellDelegate : AnyObject {
    func didSCClickUser(id: String)
    func didSCClickPlace(id: String)
    func didSCClickSound(id: String, vc: SCViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func didSCClickComment()
    func didSCClickShare(vc: SCViewCell, id: String, dataType: String)
    func didSCClickRefresh()
}

class SCViewCell: UICollectionViewCell {
    func playVideo() {}
    func stopVideo() {}
    func pauseVideo() {}
    func resumeVideo() {}
    
    //test > destroy cell
    func destroyCell() {}
    func hideCell() {}
    func dehideCell() {}
}

class SCAViewCell: SCViewCell {
    
    static let identifier = "SCAViewCell"
    var gifImage = SDAnimatedImageView()
    
    weak var aDelegate : SCViewCellDelegate?
    
    //test > video
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
    let mImage = SDAnimatedImageView()
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
    
    //test > flash loader
    let fLoader = FlashLoader()
    let coverPhoto = SDAnimatedImageView()
    let playLine = UIView()
    let progressLine = UIView()
    var progressWidthCons: NSLayoutConstraint?
    
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
        //test
        aContainer.isHidden = true
        aContainer.backgroundColor = .ddmDarkBlack
        
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.clipsToBounds = true
//        gifImage.layer.cornerRadius = 10
//        aContainer.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
////        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
////        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
////        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
////        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        gifImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
//        gifImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50).isActive = true
//        gifImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        gifImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        aContainer.addSubview(videoContainer)
//        videoContainer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        videoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        videoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        videoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 10
        videoContainer.isHidden = true
//        videoContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
//        videoContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50).isActive = true
//        videoContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        videoContainer.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
        gifImage.layer.cornerRadius = 10
        aContainer.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        gifImage.layer.opacity = 0.7

//        let blurEffect = UIBlurEffect(style: .dark) //.light, .dark, extralight
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        aContainer.addSubview(blurEffectView)
        
        //cover photo
        let lhsMargin = 70.0
        let rhsMargin = 70.0
        let xWidth = self.frame.width - lhsMargin - rhsMargin
//        let coverPhoto = SDAnimatedImageView()
        coverPhoto.contentMode = .scaleAspectFill
        coverPhoto.clipsToBounds = true
        coverPhoto.layer.cornerRadius = 10
        aContainer.addSubview(coverPhoto)
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        coverPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -80).isActive = true
        coverPhoto.widthAnchor.constraint(equalToConstant: xWidth).isActive = true
        coverPhoto.heightAnchor.constraint(equalToConstant: xWidth).isActive = true
//        let imageUrl = URL(string:"https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        coverPhoto.sd_setImage(with: imageUrl)
        
        //test > flash loader for video loading
//        let fLoader = FlashLoader()
//        fLoader.setConfiguration(size: viewWidth - 20, lineWidth: 2, color: .white)
        aContainer.addSubview(fLoader)
        fLoader.translatesAutoresizingMaskIntoConstraints = false
//        fLoader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
//        fLoader.centerYAnchor.constraint(equalTo: bottomBox.centerYAnchor, constant: 0).isActive = true
        fLoader.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        fLoader.widthAnchor.constraint(equalToConstant: viewWidth - 20).isActive = true
        fLoader.bottomAnchor.constraint(equalTo: aContainer.bottomAnchor, constant: 0).isActive = true
        fLoader.leadingAnchor.constraint(equalTo: aContainer.leadingAnchor, constant: 10).isActive = true
        fLoader.trailingAnchor.constraint(equalTo: aContainer.trailingAnchor, constant: -10).isActive = true
//        fLoader.startAnimating()
        
        //video control buttons
//        contentView.addSubview(pauseVideoView)
        aContainer.addSubview(pauseVideoView)
        pauseVideoView.translatesAutoresizingMaskIntoConstraints = false
        pauseVideoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        pauseVideoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pauseVideoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        pauseVideoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pauseVideoView.isHidden = false
        //test > added double tap for love click shortcut
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onSingleTapped))
        atapGR.numberOfTapsRequired = 1
        pauseVideoView.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapped))
        tapGR.numberOfTapsRequired = 2
        pauseVideoView.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR)
        
//        //test semi-transparent info box
//        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
////        contentView.addSubview(aBox)
//        aContainer.addSubview(aBox)
//        aBox.clipsToBounds = true
//        aBox.translatesAutoresizingMaskIntoConstraints = false
//        aBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
////        aBox.bottomAnchor.constraint(equalTo: aNameText.topAnchor, constant: -10).isActive = true
//        aBox.bottomAnchor.constraint(equalTo: eMini.topAnchor, constant: -10).isActive = true
//        aBox.layer.cornerRadius = 10
//        aBox.layer.opacity = 0.3
//        aBox.isUserInteractionEnabled = true
//        aBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
//        aBox.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
//        aBox.isHidden = true
//        
//        //test > white location btn => simpler version
//        let bBox = UIView()
////        bBox.backgroundColor = .yellow //yellow
////        bBox.backgroundColor = .systemGreen
////        bBox.backgroundColor = .systemRed
////        bBox.backgroundColor = .systemBlue
////        contentView.addSubview(bBox)
//        aContainer.addSubview(bBox)
//        bBox.clipsToBounds = true
//        bBox.translatesAutoresizingMaskIntoConstraints = false
//        bBox.widthAnchor.constraint(equalToConstant: 18).isActive = true //20
//        bBox.heightAnchor.constraint(equalToConstant: 18).isActive = true
////        bBox.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
//        bBox.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 7).isActive = true //4
//        bBox.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 6).isActive = true
//        bBox.layer.cornerRadius = 5 //6
//        bBox.isHidden = true
//
//        let gridViewBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
////        let gridViewBtn = UIImageView(image: UIImage(named:"icon_round_location")?.withRenderingMode(.alwaysTemplate))
////        gridViewBtn.tintColor = .black
//        gridViewBtn.tintColor = .white
//        bBox.addSubview(gridViewBtn)
//        gridViewBtn.translatesAutoresizingMaskIntoConstraints = false
//        gridViewBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
//        gridViewBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
////        gridViewBtn.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
////        gridViewBtn.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 10).isActive = true //10
//        gridViewBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true//16
//        gridViewBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
//        
////        let aText = UILabel()
//        aText.textAlignment = .left
//        aText.textColor = .white
//        aText.font = .boldSystemFont(ofSize: 13)
////        contentView.addSubview(aText)
//        aContainer.addSubview(aText)
//        aText.clipsToBounds = true
//        aText.translatesAutoresizingMaskIntoConstraints = false
//        aText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 8).isActive = true //5
//        aText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -8).isActive = true
//        aText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
////        aText.leadingAnchor.constraint(equalTo: gridViewBtn.trailingAnchor, constant: 10).isActive = true //10
//        aText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
////        aText.text = "Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower Petronas Twin Tower"
//        aText.text = "-"
////        aText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
//        aText.numberOfLines = 2
//        aText.isHidden = true
        
        //test > pause/play btn at bottom RHS
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//        playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        aContainer.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.bottomAnchor.constraint(equalTo: aContainer.bottomAnchor, constant: -30).isActive = true //-30
//        playBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        playBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
        
//        let playLine = UIView()
        playLine.backgroundColor = .white
//        contentView.addSubview(aBox)
        aContainer.addSubview(playLine)
        playLine.clipsToBounds = true
        playLine.translatesAutoresizingMaskIntoConstraints = false
//        playLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true //15
        playLine.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 10).isActive = true
        playLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        playLine.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        playLine.layer.cornerRadius = 2
        playLine.layer.opacity = 0.3
//        playLine.isUserInteractionEnabled = true
//        playLine.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        playLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        progressLine.backgroundColor = .white
//        contentView.addSubview(aBox)
        aContainer.addSubview(progressLine)
        progressLine.clipsToBounds = true
        progressLine.translatesAutoresizingMaskIntoConstraints = false
        progressLine.leadingAnchor.constraint(equalTo: playLine.leadingAnchor, constant: 0).isActive = true
        progressLine.centerYAnchor.constraint(equalTo: playLine.centerYAnchor, constant: 0).isActive = true
        progressWidthCons = progressLine.widthAnchor.constraint(equalToConstant: 0)
        progressWidthCons?.isActive = true
        progressLine.layer.cornerRadius = 2
        progressLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        let vControlBtnC = UIView()
        aContainer.addSubview(vControlBtnC)
        vControlBtnC.translatesAutoresizingMaskIntoConstraints = false
        vControlBtnC.bottomAnchor.constraint(equalTo:  playBtn.topAnchor, constant: -30).isActive = true
        vControlBtnC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        vControlBtnC.heightAnchor.constraint(equalToConstant: 30).isActive = true //default 40
        vControlBtnC.widthAnchor.constraint(equalToConstant: 30).isActive = true
        vControlBtnC.isHidden = true
        
        let vControlBtnG = UIView()
        vControlBtnG.backgroundColor = .ddmBlackOverlayColor
        vControlBtnC.addSubview(vControlBtnG)
        vControlBtnG.translatesAutoresizingMaskIntoConstraints = false
        vControlBtnG.bottomAnchor.constraint(equalTo: vControlBtnC.bottomAnchor, constant: 0).isActive = true
        vControlBtnG.topAnchor.constraint(equalTo: vControlBtnC.topAnchor, constant: 0).isActive = true
        vControlBtnG.leadingAnchor.constraint(equalTo: vControlBtnC.leadingAnchor, constant: 0).isActive = true
        vControlBtnG.trailingAnchor.constraint(equalTo: vControlBtnC.trailingAnchor, constant: 0).isActive = true
        vControlBtnG.layer.cornerRadius = 15 //20
        vControlBtnG.layer.opacity = 0.3
        vControlBtnG.isHidden = true
        
        let vControlBtn = UIImageView()
        vControlBtn.image = UIImage(named:"icon_round_volume")?.withRenderingMode(.alwaysTemplate)
        vControlBtn.tintColor = .white
//        aContainer.addSubview(vControlBtn)
        vControlBtnC.addSubview(vControlBtn)
        vControlBtn.translatesAutoresizingMaskIntoConstraints = false
//        vControlBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -30).isActive = true //-30, -15
//        vControlBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        vControlBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        vControlBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        vControlBtn.centerXAnchor.constraint(equalTo: vControlBtnG.centerXAnchor).isActive = true
        vControlBtn.centerYAnchor.constraint(equalTo: vControlBtnG.centerYAnchor).isActive = true
        
        //test semi transparent love count button
        aContainer.addSubview(dMiniC)
        dMiniC.translatesAutoresizingMaskIntoConstraints = false
//        dMiniC.bottomAnchor.constraint(equalTo:  gifImage.bottomAnchor, constant: -30).isActive = true
        dMiniC.bottomAnchor.constraint(equalTo:  playBtn.topAnchor, constant: -30).isActive = true
        dMiniC.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
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
        
        aContainer.addSubview(cMiniC)
        cMiniC.translatesAutoresizingMaskIntoConstraints = false
        cMiniC.bottomAnchor.constraint(equalTo:  dMiniC.bottomAnchor, constant: 0).isActive = true
        cMiniC.leadingAnchor.constraint(equalTo: dMiniC.trailingAnchor, constant: 15).isActive = true
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
        
        aContainer.addSubview(cBMiniC)
        cBMiniC.translatesAutoresizingMaskIntoConstraints = false
        cBMiniC.bottomAnchor.constraint(equalTo:  dMiniC.bottomAnchor, constant: 0).isActive = true
        cBMiniC.leadingAnchor.constraint(equalTo: cMiniC.trailingAnchor, constant: 15).isActive = true
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
        
        aContainer.addSubview(bMiniC)
        bMiniC.translatesAutoresizingMaskIntoConstraints = false
        bMiniC.bottomAnchor.constraint(equalTo:  dMiniC.bottomAnchor, constant: 0).isActive = true
        bMiniC.leadingAnchor.constraint(equalTo: cBMiniC.trailingAnchor, constant: 15).isActive = true
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
        
//        let aTitleText = UILabel()
        aTitleText.textAlignment = .left
        aTitleText.textColor = .white
        aTitleText.font = .systemFont(ofSize: 14)
//        contentView.addSubview(aTitleText)
        aContainer.addSubview(aTitleText)
        aTitleText.translatesAutoresizingMaskIntoConstraints = false
//        aTitleText.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        aTitleText.bottomAnchor.constraint(equalTo: dMiniC.topAnchor, constant: -20).isActive = true
        aTitleText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        aTitleText.text = "-"
        aTitleText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        aTitleText.numberOfLines = 2
        
        let eMini = UIView()
        eMini.backgroundColor = .ddmBlackOverlayColor
//        eMini.backgroundColor = .white
//        contentView.addSubview(eMini)
        aContainer.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
        eMini.bottomAnchor.constraint(equalTo: aTitleText.topAnchor, constant: -5).isActive = true
        eMini.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
//        eMini.bottomAnchor.constraint(equalTo: dMini.topAnchor, constant: -25).isActive = true //-30
//        eMini.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eMini.layer.cornerRadius = 20
        eMini.layer.opacity = 0.3 //default 0.3

//        let eImage = SDAnimatedImageView()
        eImage.contentMode = .scaleAspectFill
        eImage.layer.masksToBounds = true
//        let eImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        eImage.sd_setImage(with: eImageUrl)
//        eImage.backgroundColor = .ddmDarkColor
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
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 15)
//        contentView.addSubview(aNameText)
        aContainer.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.bottomAnchor.constraint(equalTo: aTitleText.topAnchor, constant: -5).isActive = true
//        aNameText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: eMini.trailingAnchor, constant: 10).isActive = true //5
        aNameText.centerYAnchor.constraint(equalTo: eMini.centerYAnchor, constant: 0).isActive = true
        aNameText.text = "-"
        aNameText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        aNameText.isUserInteractionEnabled = true
        aNameText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("videocv prepare for reuse A")
        
        //test > clear id
        setId(id: "")
        setIds(uId: "", pId: "")
        
        //*test > remove time observer
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        //*
        
        aTitleText.text = "-"
        aNameText.text = "-"
//        mText.text = "-"
        vBtn.image = nil
        aText.text = "-"
        let eImageUrl = URL(string: "")
        eImage.sd_setImage(with: eImageUrl)
//        let mImageUrl = URL(string: "")
//        mImage.sd_setImage(with: mImageUrl)
        
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
        
        //test
        let cImageUrl = URL(string: "")
        coverPhoto.sd_setImage(with: cImageUrl)
        coverPhoto.isHidden = true
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
        aDelegate?.didSCClickRefresh()
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        print("click open user panel:")
        aDelegate?.didSCClickUser(id: userId) //""
    }
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        print("click open place panel:")
        aDelegate?.didSCClickPlace(id: placeId) //""
    }
    @objc func onCommentClicked(gesture: UITapGestureRecognizer) {
        print("click open comment panel:")
        aDelegate?.didSCClickComment()
    }
    @objc func onShareClicked(gesture: UITapGestureRecognizer) {
        print("click share panel:")
        aDelegate?.didSCClickShare(vc: self, id: id, dataType: "sound_v")
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
        
        if(vidPlayStatus == "play") {
            pauseVideo()
        } else {
            resumeVideo()
        }
    }

    //test > double tap to love a video
    @objc func onSingleTapped(gesture: UITapGestureRecognizer) {
        print("click single tapped video:")
    }
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
        let id = data //u1
        DataFetchManager.shared.fetchUserData2(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    let uData = UserData()
                    uData.setData(rData: l)
                    let l_ = uData.dataCode
                    
                    if(l_ == "a") {
                        self.aNameText.text = uData.dataTextString
                        
                        let eImageUrl = URL(string: uData.coverPhotoString)
                        self.eImage.sd_setImage(with: eImageUrl)
                        
                        if(uData.isAccountVerified) {
                            self.vBtn.image = UIImage(named:"icon_round_verified_b")?.withRenderingMode(.alwaysTemplate)
                        }
                        
                        //test > background image for sounds
                        self.gifImage.sd_setImage(with: eImageUrl)
                        self.gifImage.isHidden = false
                    }
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
    //*test > async fetch place profile
    func asyncConfigurePlace(data: String) {
        let id = data //p1
        DataFetchManager.shared.fetchPlaceData2(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    let pData = PlaceData()
                    pData.setData(rData: l)
                    let l_ = pData.dataCode
                    
                    if(l_ == "a") {
                        self.aText.text = pData.dataTextString
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.aText.text = "-"
                }
                break
            }
        }
    }
    //*
    func startFlashLoaderAnimation() {
        let vWidth = contentView.frame.size.width
        let vidConCornerRadius = 10.0
        fLoader.setConfiguration(size: vWidth - vidConCornerRadius * 2, lineWidth: 3, color: .white)
        fLoader.startAnimating()
    }
    func stopFlashLoaderAnimation() {
        fLoader.stopAnimating()
    }
    
    //test > async fetch asset
    //TODO: a warning text for error
    func asyncConfigureVideo(data: SoundData) {
        startFlashLoaderAnimation()
        
        let id = "a"
        DataFetchManager.shared.fetchDummyDataTimeDelay(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.stopFlashLoaderAnimation()
                    
                    //test 2 > try video without looper, use conventional avplayer
                    var videoURL = ""
                    if(data.dataCode == "a") {
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
                    self.totalDuration = d
                    
                    self.addTimeObserver()
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    
                    //seek to previously viewed state t_s
                    self.player?.seek(to: .zero)
//                    let seekTime = CMTime(seconds: self.t_s_, preferredTimescale: CMTimeScale(1000)) //1000
//                    self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    //test > autoplay video after video loaded
                    print("scviewcell : \(self.vidPlayStatus)")
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
    
    //test > set id for init
    var id = ""
    var userId = ""
    var placeId = ""
    func setId(id: String) {
        self.id = id
    }
    func setIds(uId: String, pId: String) {
        self.userId = uId
        self.placeId = pId
    }
    
    //test > configure cell
    func configure(data: SoundData) {
        
        setId(id: data.id)
        
        //test > change ui with data accordingly
        aSpinner.stopAnimating()
        gifImage.isHidden = true
        aContainer.isHidden = true
        aaText.isHidden = true
        errorText.isHidden = true
        errorRefreshBtn.isHidden = true
        
        coverPhoto.isHidden = true

        let dataText = data.dataTextString
        let coverPhotoString = data.coverPhotoString
        var videoURL = ""
        
        if(data.dataCode == "b") { // b - loading data
            aSpinner.startAnimating()
        } else if(data.dataCode == "c") { // c - no more data
//            aaText.text = dataText
            aaText.text = "End"
            aaText.isHidden = false
        } else if(data.dataCode == "d") { // d - empty data
//            aaText.text = dataText
            aaText.text = "No results"
            aaText.isHidden = false
        } else if(data.dataCode == "e") { // e - something went wrong
//            errorText.text = dataText
            errorText.text = "Something went wrong. Try again."
            errorText.isHidden = false
            errorRefreshBtn.isHidden = false
        }
        //*test > post suspended and not found
        else if(data.dataCode == "na") { // na - not found
            aaText.text = "Loop does not exist."
            aaText.isHidden = false
        }
        else if(data.dataCode == "us") { // us - suspended
            aaText.text = "Loop violated community rules."
            aaText.isHidden = false
        }
        else if(data.dataCode == "a") { // a - video play
            aContainer.isHidden = false
            
            let u = data.userId
            let p = data.placeId
//            let s = ""
            setIds(uId: u, pId: p)
            asyncConfigure(data: u) //get creator data, e.g. name
//            asyncConfigureSound(data: s)
            asyncConfigurePlace(data: p)
            
            aTitleText.text = dataText
//            aTitleText.text = "Happy"
      
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
            
//            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//            let imageUrl = URL(string:"https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
            let imageUrl = URL(string: coverPhotoString)
            coverPhoto.sd_setImage(with: imageUrl)
            coverPhoto.isHidden = false
//            gifImage.sd_setImage(with: imageUrl)
//            gifImage.isHidden = false
        }
        //test 3 > async load video
        asyncConfigureVideo(data: data)
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        playVideo()
    }
    
    var totalDuration = 0.0
    func getDuration(ofVideoAt videoURL: URL) -> Double {
        let asset = AVURLAsset(url: videoURL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if durationInSeconds.isNaN {
//            return nil
            return 0.0
        } else {
            return durationInSeconds
        }
    }
    
    var timeObserverToken: Any?
    func addTimeObserver() {
        print("addTimeObserver B: \(timeObserverToken), \(player)")
        
        //test > time observer
        let timeInterval = CMTime(seconds: 0.02, preferredTimescale: CMTimeScale(1000)) //0.01 sec intervalc
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {[weak self] time in
                
            let currentTime = time.seconds
            guard let s = self else {
                return
            }

//            print("Current time B: \(currentTime), \(s.totalDuration), \(s.playLine.frame.width)")
            let playLineWidth = s.playLine.frame.width
            if(s.totalDuration > 0.0) {
                let newVal = CGFloat((currentTime) / (s.totalDuration)) * (playLineWidth)
                print("Current time B: \(currentTime), \(s.totalDuration), \(newVal), \(s.playLine.frame.width)")
                self?.progressWidthCons?.constant = newVal
            } else {
                self?.progressWidthCons?.constant = 0.0
            }
        }
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
    
    override func playVideo() {
//        pauseVideoView.isHidden = false
//        playVideoView.isHidden = true
        
        player?.seek(to: .zero)
        player?.play()
        
//        vidPlayStatus = "play"
        //test
        reactOnPlayStatus(status: "play")
    }
    
    override func stopVideo() {
        player?.seek(to: .zero)
        player?.pause()
        
//        vidPlayStatus = "pause"
        print("cell stop video")
        //test
        reactOnPlayStatus(status: "pause")
    }
    
    override func pauseVideo() {
        player?.pause()
        
//        vidPlayStatus = "pause"
        //test
        reactOnPlayStatus(status: "pause")
    }
    
    override func resumeVideo() {
//        pauseVideoView.isHidden = false
//        playVideoView.isHidden = true

        player?.play()
        
//        vidPlayStatus = "play"
        //test
        reactOnPlayStatus(status: "play")
    }
    
    func reactOnPlayStatus(status: String) {
        vidPlayStatus = status
        if(status == "play") {
            playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        } else {
            playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
