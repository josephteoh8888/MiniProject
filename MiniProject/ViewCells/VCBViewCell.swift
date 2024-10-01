//
//  VCBViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

class VCBViewCell: VCViewCell {
    
    static let identifier = "VCBViewCell"
    var gifImage = SDAnimatedImageView()
    
//    var playerLooper: AVPlayerLooper!
//    var queuePlayer: AVQueuePlayer!
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
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
        gifImage.sd_setImage(with: imageUrl)
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
        pauseVideoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
        
        //test > added double tap for love click shortcut
//        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked))
//        atapGR.numberOfTapsRequired = 1
//        pauseVideoView.addGestureRecognizer(atapGR)
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapped))
//        tapGR.numberOfTapsRequired = 2
//        pauseVideoView.addGestureRecognizer(tapGR)
//        atapGR.require(toFail: tapGR)
        
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
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("videocv prepare for reuse B")
        
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
//        aDelegate?.didClickPauseVideo()

        pauseVideoView.isHidden = true
        playVideoView.isHidden = false
        pauseVideo()
    }
    @objc func onResumeVideoClicked(gesture: UITapGestureRecognizer) {
        print("click resume video:")
//        aDelegate?.didClickResumeVideo()

        pauseVideoView.isHidden = false
        playVideoView.isHidden = true
        resumeVideo()
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
    
    //test > async fetch asset
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
    
    func configure(data: VideoData) {
        //test > change ui with data accordingly
        aSpinner.stopAnimating()
        gifImage.isHidden = true
        aContainer.isHidden = true
        aaText.isHidden = true
        errorText.isHidden = true
        errorRefreshBtn.isHidden = true
        
        let dataText = data.dataTextString
        
        //test > change ui with data accordingly
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
            aaText.text = "Video does not exist."
            aaText.isHidden = false
        }
        else if(data.dataType == "us") { // us - suspended
            aaText.text = "Video violated community rules."
            aaText.isHidden = false
        }
        else if(data.dataType == "a") { // a - video play
            aContainer.isHidden = false
            
            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            gifImage.sd_setImage(with: imageUrl)
            gifImage.isHidden = false
        }
        
        //avplayer with loop
//        video urls: temp_video_1.mp4, temp_video_2.mp4, temp_video_3.mp4, temp_video_4.mp4
        let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
//        let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
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
////        playVideo()
//        print("dummy configure: \(data)")
//
//        //test > get duration of video 2
//        let d = getDuration(ofVideoAt: url)
//        print("vcviewcell duration: \(d)")
//
//        //test > TimeObserver for progresslistener
//        addTimeObserver()
        
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
        pauseVideoView.isHidden = false
        playVideoView.isHidden = true
        
//        queuePlayer.seek(to: .zero)
//        queuePlayer.play()
        player?.seek(to: .zero)
        player?.play()
        
        vidPlayStatus = "play"
        
        print("vcBviewcell play")
    }
    
    override func stopVideo() {
//        pauseVideoView.isHidden = false
//        playVideoView.isHidden = true
        
//        queuePlayer.seek(to: .zero)
//        queuePlayer.pause()
        player?.seek(to: .zero)
        player?.pause()
        
        vidPlayStatus = "pause"
    }
    
    override func pauseVideo() {
//        pauseVideoView.isHidden = true
//        playVideoView.isHidden = false
        
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
        
        print("vcBviewcell resume")
    }
}
