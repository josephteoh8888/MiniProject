//
//  MeBookmarkListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 20/07/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

class SCBViewCell: SCViewCell {
    
    static let identifier = "SCBViewCell"
    var gifImage = SDAnimatedImageView()
    
    let videoContainer = UIView()
    //test > avplayer instead of looper
    var player: AVPlayer!
    
    let playBtn = UIImageView()
    let playVideoView = UIView()
    let pauseVideoView = UIView()
    
    var vidPlayStatus = ""
    
    //test > add loading spinner
    var aSpinner = SpinLoader()
    let aContainer = UIView()
    let aaText = UILabel()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    //test > flash loader
    let fLoader = FlashLoader()
    
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
//        aaText.layer.opacity = 0.5
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
        aContainer.isHidden = true
        aContainer.backgroundColor = .ddmDarkBlack
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.layer.cornerRadius = 10
////        contentView.addSubview(gifImage)
//        aContainer.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
//        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
////        gifImage.isHidden = true
        
//        contentView.addSubview(videoContainer)
        aContainer.addSubview(videoContainer)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        videoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        videoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        videoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 10
        videoContainer.isHidden = true
        
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
        
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
        gifImage.layer.cornerRadius = 10
        aContainer.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        aContainer.addSubview(blurEffectView)
        
        //cover photo
        let lhsMargin = 70.0
        let rhsMargin = 70.0
        let xWidth = self.frame.width - lhsMargin - rhsMargin
        let coverPhoto = SDAnimatedImageView()
        coverPhoto.contentMode = .scaleAspectFill
        coverPhoto.clipsToBounds = true
        coverPhoto.layer.cornerRadius = 10
        aContainer.addSubview(coverPhoto)
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        coverPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -80).isActive = true
        coverPhoto.widthAnchor.constraint(equalToConstant: xWidth).isActive = true
        coverPhoto.heightAnchor.constraint(equalToConstant: xWidth).isActive = true
        let imageUrl = URL(string:"https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        coverPhoto.sd_setImage(with: imageUrl)
        
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
        
        //test > added double tap for love click shortcut
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked))
//        atapGR.numberOfTapsRequired = 1
//        pauseVideoView.addGestureRecognizer(atapGR)
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapped))
//        tapGR.numberOfTapsRequired = 2
//        pauseVideoView.addGestureRecognizer(tapGR)
//        atapGR.require(toFail: tapGR)
        
        //test > pause/play btn at bottom RHS
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//        playBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        aContainer.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true //-30
//        playBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        playBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
        
        let playLine = UIView()
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("videocv prepare for reuse B")
        
        //test > clear id
        setId(id: "")
        
        //*test > remove time observer
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        vidPlayStatus = ""
        //*
        
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
        print("vcBviewcell destroy cell")
        removeTimeObserverVideo()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
//        aDelegate?.didClickRefresh()
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
    func asyncConfigureVideo(data: SoundData) {
        
        startFlashLoaderAnimation()
        
        let id = "a_"
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
    
    //test > set id for init
    var id = ""
    func setId(id: String) {
        self.id = id
    }
    
    func configure(data: SoundData) {
        
        setId(id: data.id)
        
        //test > change ui with data accordingly
        aSpinner.stopAnimating()
        gifImage.isHidden = true
        aContainer.isHidden = true
        aaText.isHidden = true
        errorText.isHidden = true
        errorRefreshBtn.isHidden = true
        
        let dataText = data.dataTextString
        
        //test > change ui with data accordingly
        if(data.dataCode == "b") { // b - loading data
            aSpinner.startAnimating()
        } else if(data.dataCode == "c") { // c - no more data
            aaText.text = dataText
            aaText.isHidden = false
        } else if(data.dataCode == "d") { // d - empty data
            aaText.text = dataText
            aaText.isHidden = false
        } else if(data.dataCode == "e") { // e - something went wrong
            errorText.text = dataText
            errorText.isHidden = false
            errorRefreshBtn.isHidden = false
        }
        //*test > post suspended and not found
        else if(data.dataCode == "na") { // na - not found
            aaText.text = "Video does not exist."
            aaText.isHidden = false
        }
        else if(data.dataCode == "us") { // us - suspended
            aaText.text = "Video violated community rules."
            aaText.isHidden = false
        }
        else if(data.dataCode == "a") { // a - video play
            aContainer.isHidden = false
            
            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            gifImage.sd_setImage(with: imageUrl)
            gifImage.isHidden = false
        }
        
        //avplayer with loop
//        video urls: temp_video_1.mp4, temp_video_2.mp4, temp_video_3.mp4, temp_video_4.mp4
//        let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
        
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
    
    var timeObserverToken: Any?
    func addTimeObserver() {
        print("addTimeObserver B: \(timeObserverToken), \(player)")
        
        //test > time observer
        let timeInterval = CMTime(seconds: 0.02, preferredTimescale: CMTimeScale(1000)) //0.01 sec intervalc
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {[weak self] time in
                
            let currentTime = time.seconds
            print("Current time B: \(currentTime)")
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
