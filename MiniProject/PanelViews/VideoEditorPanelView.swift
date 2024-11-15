//
//  VideoEditorPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

import Photos

//test > **INSPIRED BY IG EDITOR
protocol VideoEditorPanelDelegate : AnyObject {
    func didInitializeVideoEditor()
    func didClickFinishVideoEditor()
    func didClickNextVideoEditor()
    func didPromptExitVideoEditor()
    func didDenyExitVideoEditor()
    func didClickAddVideoClip()
}

//class VideoEditorPanelView: PanelView, UIGestureRecognizerDelegate{
class VideoEditorPanelView: PanelView{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    let videoContainer = UIView()
    
    let playVideoView = UIView()
    let pauseVideoView = UIView()
    let playBtn = UIImageView()
    let pauseBtn = UIImageView()
    
    var videoAsset: AVAsset?
    var playerLayer : AVPlayerLayer?
    
    weak var delegate : VideoEditorPanelDelegate?
    
    var isVideoEditorInitialized = false
    
    //test > progress
    var progressCenterXCons: NSLayoutConstraint?
    
    //test > varied video preview width and height
    var videoWidthLayoutConstraint: NSLayoutConstraint?
    var videoHeightLayoutConstraint: NSLayoutConstraint?
    var videoTopLayoutConstraint: NSLayoutConstraint?
    let maxVidPanel = UIView()
    let maxVPauseBtn = UIImageView()
    let maxVPlayBtn = UIImageView()
    
    //test
    var player: AVPlayer!
    
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsUrl
        //.cachesDirectory is only for short term storage
    }()

//    var videoPlayStatus = ""
    var videoPlayStatus = "stop"
    let timelineScrollView = UIScrollView()

    let audioScrollFrame = UIView()
    let audioScrollBase = UIView()
    var audioScrollLeadingCons: NSLayoutConstraint?
    var audioScrollTrailingCons: NSLayoutConstraint?
    let audioMiniText = UILabel()
    var audioClipList = [AudioClip]()
    let audioMiniBtn = UIImageView()
    
    var vcList = [VideoClip]()
    
    var currentWidth = 0.0
    
    let audioContainer = UIView()
    var player2: AVPlayer!
    let bSection = UIView()
    
    let mainBtnContainer = UIView()
    let vcBtnContainer = UIView()
    let acBtnContainer = UIView()
    let scBtnContainer = UIView()
    let timePlayText = UILabel()
    let timeDurationText = UILabel()
    
    var selectedVcIndex = -1
    var selectedAcIndex = -1
    var selectedScIndex = -1
    
    var scList = [SubtitleClip]()
    let sText = UILabel()
    let sBox = UIView()
    var sBoxWidthLayoutConstraint: NSLayoutConstraint?
    var sBoxTrailingLayoutConstraint: NSLayoutConstraint?
    
    let videoProcessProgressPanel = UIView()
    let semiTransparentSpinner = SpinLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
        panelTopCons?.isActive = true
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        let topInsetMargin = panel.safeAreaInsets.top + 10
        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVideoEditorPanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let width = 180.0
        let height = width * 16 / 9
        panel.addSubview(audioContainer)
        audioContainer.translatesAutoresizingMaskIntoConstraints = false
        audioContainer.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 0).isActive = true
        audioContainer.widthAnchor.constraint(equalToConstant: width).isActive = true
        audioContainer.heightAnchor.constraint(equalToConstant: height).isActive = true
        audioContainer.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        audioContainer.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 0).isActive = true
//        audioContainer.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 0).isActive = true
//        audioContainer.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 0).isActive = true
//        audioContainer.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: 0).isActive = true
        audioContainer.clipsToBounds = true
        audioContainer.layer.cornerRadius = 10
        audioContainer.backgroundColor = .black
        
//        panel.addSubview(videoContainer)
//        videoContainer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        videoContainer.translatesAutoresizingMaskIntoConstraints = false
////        videoContainer.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 0).isActive = true
//        videoContainer.topAnchor.constraint(equalTo: audioContainer.topAnchor, constant: 0).isActive = true
//        videoWidthLayoutConstraint = videoContainer.widthAnchor.constraint(equalToConstant: width)
//        videoWidthLayoutConstraint?.isActive = true
//        videoHeightLayoutConstraint = videoContainer.heightAnchor.constraint(equalToConstant: height)
//        videoHeightLayoutConstraint?.isActive = true
//        videoContainer.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        videoContainer.clipsToBounds = true
//        videoContainer.layer.cornerRadius = 10
//        videoContainer.backgroundColor = .black
        
        pauseBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        pauseBtn.tintColor = .white
        panel.addSubview(pauseBtn)
        pauseBtn.translatesAutoresizingMaskIntoConstraints = false
        pauseBtn.topAnchor.constraint(equalTo: audioContainer.bottomAnchor, constant: 10).isActive = true //10
        pauseBtn.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        pauseBtn.isHidden = false
        pauseBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pauseBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pauseBtn.isUserInteractionEnabled = true
        pauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
        pauseBtn.isHidden = true
        
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        panel.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.topAnchor.constraint(equalTo: audioContainer.bottomAnchor, constant: 10).isActive = true //10
        playBtn.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        playBtn.isHidden = true
        playBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
        
        let aNext = UIView()
        aNext.backgroundColor = .yellow
    //        aFollow.backgroundColor = .ddmGoldenYellowColor
        panel.addSubview(aNext)
        aNext.translatesAutoresizingMaskIntoConstraints = false
        aNext.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aNext.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aNext.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aNext.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        aNext.layer.cornerRadius = 15
        aNext.isUserInteractionEnabled = true
        aNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoEditorNextClicked)))
//        aNext.isHidden = true
        
        let aNextMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right_next")?.withRenderingMode(.alwaysTemplate))
        aNextMiniBtn.tintColor = .black
        panel.addSubview(aNextMiniBtn)
        aNextMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aNextMiniBtn.centerXAnchor.constraint(equalTo: aNext.centerXAnchor).isActive = true
        aNextMiniBtn.centerYAnchor.constraint(equalTo: aNext.centerYAnchor).isActive = true
        aNextMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aNextMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let timePlayText = UILabel()
        timePlayText.textAlignment = .left
        timePlayText.textColor = .white
        timePlayText.font = .systemFont(ofSize: 10)
        panel.addSubview(timePlayText)
        timePlayText.translatesAutoresizingMaskIntoConstraints = false
        timePlayText.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        timePlayText.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        timePlayText.text = "00:00"
        
        let timeDivider = UILabel()
        timeDivider.textAlignment = .left
        timeDivider.textColor = .white
        timeDivider.font = .systemFont(ofSize: 10)
        panel.addSubview(timeDivider)
        timeDivider.translatesAutoresizingMaskIntoConstraints = false
        timeDivider.leadingAnchor.constraint(equalTo: timePlayText.trailingAnchor, constant: 2).isActive = true
        timeDivider.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        timeDivider.text = "/"
        
        timeDurationText.textAlignment = .left
        timeDurationText.textColor = .white
        timeDurationText.font = .systemFont(ofSize: 10)
        panel.addSubview(timeDurationText)
        timeDurationText.translatesAutoresizingMaskIntoConstraints = false
        timeDurationText.leadingAnchor.constraint(equalTo: timeDivider.trailingAnchor, constant: 2).isActive = true
        timeDurationText.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        timeDurationText.text = "00:00"
        
        //test > list out files
        createDirectoryForDraft() //create draft folder
        checkFilesInFolder()
        
        
        //test > timeline videoframes
//        let bSection = UIView()
        panel.addSubview(bSection)
//        bSection.backgroundColor = .black
        bSection.translatesAutoresizingMaskIntoConstraints = false
        bSection.topAnchor.constraint(equalTo: playBtn.bottomAnchor, constant: 20).isActive = true
        bSection.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true //-50
        bSection.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        bSection.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        
//        let timelinePanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTimelinePanGesture))
//        bSection.addGestureRecognizer(timelinePanGesture)
        
        //test > pinch to scale timeline
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onTimelinePinchGesture2))
        bSection.addGestureRecognizer(pinchRecognizer)
        
        //test 3 > timeline with uiscrollview, smooth scrolling
//        let timelineScrollView = UIScrollView()
        bSection.addSubview(timelineScrollView)
//        timelineScrollView.backgroundColor = .black
//        timelineScrollView.backgroundColor = .ddmBlackOverlayColor
//        timelineScrollView.backgroundColor = .ddmDarkColor
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
//        timelineScrollView.heightAnchor.constraint(equalToConstant: 200).isActive = true //ori 60
        timelineScrollView.bottomAnchor.constraint(equalTo: bSection.bottomAnchor, constant: -120).isActive = true
        timelineScrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        timelineScrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        timelineScrollView.topAnchor.constraint(equalTo: bSection.topAnchor, constant: 0).isActive = true
        timelineScrollView.showsHorizontalScrollIndicator = false
        timelineScrollView.alwaysBounceHorizontal = true //test
        let offset = viewWidth/2
        timelineScrollView.contentInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
//        timelineScrollView.contentSize = CGSize(width: videoFrameWidth - 150, height: 50)
        let pinchRecognizer1 = UIPinchGestureRecognizer(target: self, action: #selector(onTimelinePinchGesture2))
        timelineScrollView.addGestureRecognizer(pinchRecognizer1)
        timelineScrollView.delegate = self
        let contentOffset = CGPoint(x: -offset, y: 0)
        timelineScrollView.setContentOffset(contentOffset, animated: false)
        timelineScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTimelineClicked)))
        
        //test > add time scale
        timeScaleStackView.axis = .horizontal
        timeScaleStackView.distribution = .fillEqually
        timelineScrollView.addSubview(timeScaleStackView)
        timeScaleStackView.translatesAutoresizingMaskIntoConstraints = false
        timeScaleStackView.topAnchor.constraint(equalTo: timelineScrollView.topAnchor, constant: 4).isActive = true
//        timeScaleStackView.leadingAnchor.constraint(equalTo: tBox.leadingAnchor, constant: 0).isActive = true
        timeScaleStackView.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: 0).isActive = true
        timeScaleWidthCons = timeScaleStackView.widthAnchor.constraint(equalToConstant: 0.0)
        timeScaleWidthCons?.isActive = true
//        timeScaleStackView.widthAnchor.constraint(equalToConstant: videoFrameWidth).isActive = true
        timeScaleStackView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let timelineSectionDivider = UIView()
        bSection.addSubview(timelineSectionDivider)
        timelineSectionDivider.backgroundColor = .ddmDarkColor
        timelineSectionDivider.translatesAutoresizingMaskIntoConstraints = false
        timelineSectionDivider.topAnchor.constraint(equalTo: timelineScrollView.topAnchor, constant: 0).isActive = true
        timelineSectionDivider.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        timelineSectionDivider.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        timelineSectionDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
//        test > audio frames
        timelineScrollView.addSubview(audioScrollFrame)
        audioScrollFrame.backgroundColor = .ddmDarkColor
        audioScrollFrame.translatesAutoresizingMaskIntoConstraints = false
        audioScrollFrame.topAnchor.constraint(equalTo: timelineScrollView.topAnchor, constant: 120).isActive = true
        audioScrollLeadingCons = audioScrollFrame.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor)
        audioScrollTrailingCons = audioScrollFrame.trailingAnchor.constraint(equalTo: timelineScrollView.trailingAnchor)
//        audioScrollLeadingCons?.isActive = true
//        audioScrollTrailingCons?.isActive = true
        audioScrollFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        audioScrollFrame.widthAnchor.constraint(equalToConstant: 50).isActive = true
        audioScrollFrame.layer.cornerRadius = 10
        audioScrollFrame.isUserInteractionEnabled = true
        audioScrollFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectAudioClicked)))
        
//        let audioScrollBase = UIView()
        audioScrollBase.backgroundColor = .ddmGoldenYellowColor
        timelineScrollView.insertSubview(audioScrollBase, belowSubview: audioScrollFrame)
        audioScrollBase.translatesAutoresizingMaskIntoConstraints = false
//        audioScrollBase.heightAnchor.constraint(equalToConstant: 54).isActive = true //50
        audioScrollBase.leadingAnchor.constraint(equalTo: audioScrollFrame.leadingAnchor, constant: -2).isActive = true
        audioScrollBase.trailingAnchor.constraint(equalTo: audioScrollFrame.trailingAnchor, constant: 2).isActive = true
        audioScrollBase.topAnchor.constraint(equalTo: audioScrollFrame.topAnchor, constant: -2).isActive = true
        audioScrollBase.bottomAnchor.constraint(equalTo: audioScrollFrame.bottomAnchor, constant: 2).isActive = true
//        audioScrollBase.centerYAnchor.constraint(equalTo: audioScrollFrame.centerYAnchor, constant: 0).isActive = true
        audioScrollBase.layer.cornerRadius = 10
        audioScrollBase.isHidden = true
        

//        let audioMiniBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        audioMiniBtn.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
        audioMiniBtn.tintColor = .white
        audioScrollFrame.addSubview(audioMiniBtn)
        audioMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        audioMiniBtn.leadingAnchor.constraint(equalTo: audioScrollFrame.leadingAnchor, constant: 5).isActive = true
        audioMiniBtn.centerYAnchor.constraint(equalTo: audioScrollFrame.centerYAnchor).isActive = true
        audioMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        audioMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let audioMiniText = UILabel()
        audioMiniText.textAlignment = .left
        audioMiniText.textColor = .white
        audioMiniText.font = .boldSystemFont(ofSize: 10)
        audioScrollFrame.addSubview(audioMiniText)
        audioMiniText.translatesAutoresizingMaskIntoConstraints = false
        audioMiniText.leadingAnchor.constraint(equalTo: audioMiniBtn.trailingAnchor, constant: 5).isActive = true
        audioMiniText.centerYAnchor.constraint(equalTo: audioScrollFrame.centerYAnchor).isActive = true
        audioMiniText.trailingAnchor.constraint(equalTo: audioScrollFrame.trailingAnchor, constant: -10).isActive = true
        audioMiniText.text = "Tap to Add Sound"
        
        
        //tools panel
        //test > various functionality for video edit
//        let mainBtnContainer = UIView()
        panel.addSubview(mainBtnContainer)
        mainBtnContainer.translatesAutoresizingMaskIntoConstraints = false
        mainBtnContainer.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        mainBtnContainer.heightAnchor.constraint(equalToConstant: 90).isActive = true //120
        mainBtnContainer.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
//        mainBtnContainer.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        mainBtnContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
//        mainBtnContainer.isHidden = true
        
        //test > timeline center
        let timelineCenterLine = UIView()
        panel.addSubview(timelineCenterLine)
        timelineCenterLine.backgroundColor = .white
        timelineCenterLine.translatesAutoresizingMaskIntoConstraints = false
//        timelineCenterLine.bottomAnchor.constraint(equalTo: timelineScrollView.bottomAnchor, constant: -50).isActive = true
        timelineCenterLine.bottomAnchor.constraint(equalTo: mainBtnContainer.topAnchor, constant: -10).isActive = true
        timelineCenterLine.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
        timelineCenterLine.widthAnchor.constraint(equalToConstant: 2).isActive = true //1
        timelineCenterLine.topAnchor.constraint(equalTo: timeScaleStackView.bottomAnchor, constant: 30).isActive = true
        timelineCenterLine.layer.shadowColor = UIColor.black.cgColor
        timelineCenterLine.layer.shadowRadius = 1.0  //ori 3
        timelineCenterLine.layer.shadowOpacity = 1.0 //ori 1
        timelineCenterLine.layer.shadowOffset = CGSize(width: 0, height: 0)

        let eGrid = UIView() //edit vc
        eGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(eGrid)
        mainBtnContainer.addSubview(eGrid)
        eGrid.translatesAutoresizingMaskIntoConstraints = false
        eGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        eGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true //50
        eGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        eGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        eGrid.topAnchor.constraint(equalTo: mainBtnContainer.topAnchor, constant: 10).isActive = true
        eGrid.layer.cornerRadius = 20 //10
        eGrid.isUserInteractionEnabled = true
        eGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAPhotoClicked)))
        
        let eMiniBtn = UIImageView(image: UIImage(named:"icon_round_content_cut")?.withRenderingMode(.alwaysTemplate))
        eMiniBtn.tintColor = .white
        mainBtnContainer.addSubview(eMiniBtn)
        eMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        eMiniBtn.centerXAnchor.constraint(equalTo: eGrid.centerXAnchor).isActive = true
        eMiniBtn.centerYAnchor.constraint(equalTo: eGrid.centerYAnchor).isActive = true
        eMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        eMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let eMiniText = UILabel()
        eMiniText.textAlignment = .center
        eMiniText.textColor = .white
        eMiniText.font = .boldSystemFont(ofSize: 10)
        mainBtnContainer.addSubview(eMiniText)
        eMiniText.translatesAutoresizingMaskIntoConstraints = false
        eMiniText.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 2).isActive = true
        eMiniText.centerXAnchor.constraint(equalTo: eGrid.centerXAnchor).isActive = true
        eMiniText.text = "Edit"
        
//        let eFGrid = UIView() //reorder vc
//        eFGrid.backgroundColor = .ddmDarkColor
////        panel.addSubview(eGrid)
//        mainBtnContainer.addSubview(eFGrid)
//        eFGrid.translatesAutoresizingMaskIntoConstraints = false
//        eFGrid.leadingAnchor.constraint(equalTo: eGrid.trailingAnchor, constant: 20).isActive = true
//        eFGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true //50
//        eFGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
////        eFGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
//        eFGrid.topAnchor.constraint(equalTo: mainBtnContainer.topAnchor, constant: 10).isActive = true
//        eFGrid.layer.cornerRadius = 20 //10
//        eFGrid.isUserInteractionEnabled = true
//        eFGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAAPhotoClicked)))
//
//        let eFMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        eFMiniBtn.tintColor = .white
//        mainBtnContainer.addSubview(eFMiniBtn)
//        eFMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        eFMiniBtn.centerXAnchor.constraint(equalTo: eFGrid.centerXAnchor).isActive = true
//        eFMiniBtn.centerYAnchor.constraint(equalTo: eFGrid.centerYAnchor).isActive = true
//        eFMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        eFMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let eFMiniText = UILabel()
//        eFMiniText.textAlignment = .center
//        eFMiniText.textColor = .white
//        eFMiniText.font = .boldSystemFont(ofSize: 10)
//        mainBtnContainer.addSubview(eFMiniText)
//        eFMiniText.translatesAutoresizingMaskIntoConstraints = false
//        eFMiniText.topAnchor.constraint(equalTo: eFGrid.bottomAnchor, constant: 2).isActive = true
//        eFMiniText.centerXAnchor.constraint(equalTo: eFGrid.centerXAnchor).isActive = true
//        eFMiniText.text = "Reorder"

        let fGrid = UIView() //add vc
        fGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(fGrid)
        mainBtnContainer.addSubview(fGrid)
        fGrid.translatesAutoresizingMaskIntoConstraints = false
//        fGrid.leadingAnchor.constraint(equalTo: eFGrid.trailingAnchor, constant: 20).isActive = true
        fGrid.leadingAnchor.constraint(equalTo: eGrid.trailingAnchor, constant: 20).isActive = true
        fGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        fGrid.topAnchor.constraint(equalTo: eGrid.topAnchor, constant: 0).isActive = true
        fGrid.topAnchor.constraint(equalTo: mainBtnContainer.topAnchor, constant: 10).isActive = true
        fGrid.layer.cornerRadius = 20 //10
        fGrid.isUserInteractionEnabled = true
        fGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBPhotoClicked)))
        
        let fMiniBtn = UIImageView(image: UIImage(named:"icon_round_add_v")?.withRenderingMode(.alwaysTemplate))
        fMiniBtn.tintColor = .white
        mainBtnContainer.addSubview(fMiniBtn)
        fMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        fMiniBtn.centerXAnchor.constraint(equalTo: fGrid.centerXAnchor).isActive = true
        fMiniBtn.centerYAnchor.constraint(equalTo: fGrid.centerYAnchor).isActive = true
        fMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        fMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let fMiniText = UILabel()
        fMiniText.textAlignment = .center
        fMiniText.textColor = .white
        fMiniText.font = .boldSystemFont(ofSize: 10)
        mainBtnContainer.addSubview(fMiniText)
        fMiniText.translatesAutoresizingMaskIntoConstraints = false
        fMiniText.topAnchor.constraint(equalTo: fGrid.bottomAnchor, constant: 2).isActive = true
        fMiniText.centerXAnchor.constraint(equalTo: fGrid.centerXAnchor).isActive = true
        fMiniText.text = "Add Clip"
        
        let gGrid = UIView() //add audio
        gGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(gGrid)
        mainBtnContainer.addSubview(gGrid)
        gGrid.translatesAutoresizingMaskIntoConstraints = false
        gGrid.leadingAnchor.constraint(equalTo: fGrid.trailingAnchor, constant: 20).isActive = true
        gGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        gGrid.topAnchor.constraint(equalTo: fGrid.topAnchor, constant: 0).isActive = true
        gGrid.topAnchor.constraint(equalTo: mainBtnContainer.topAnchor, constant: 10).isActive = true
        gGrid.layer.cornerRadius = 20 //10
        gGrid.isUserInteractionEnabled = true
        gGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCPhotoClicked)))
        
        let gMiniBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        gMiniBtn.tintColor = .white
        mainBtnContainer.addSubview(gMiniBtn)
        gMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        gMiniBtn.centerXAnchor.constraint(equalTo: gGrid.centerXAnchor).isActive = true
        gMiniBtn.centerYAnchor.constraint(equalTo: gGrid.centerYAnchor).isActive = true
        gMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        gMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let gMiniText = UILabel()
        gMiniText.textAlignment = .center
        gMiniText.textColor = .white
        gMiniText.font = .boldSystemFont(ofSize: 10)
        mainBtnContainer.addSubview(gMiniText)
        gMiniText.translatesAutoresizingMaskIntoConstraints = false
        gMiniText.topAnchor.constraint(equalTo: gGrid.bottomAnchor, constant: 2).isActive = true
        gMiniText.centerXAnchor.constraint(equalTo: gGrid.centerXAnchor).isActive = true
        gMiniText.text = "Add Sound"
        
        let hGrid = UIView() //add audio
        hGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(gGrid)
        mainBtnContainer.addSubview(hGrid)
        hGrid.translatesAutoresizingMaskIntoConstraints = false
        hGrid.leadingAnchor.constraint(equalTo: gGrid.trailingAnchor, constant: 20).isActive = true
        hGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        hGrid.topAnchor.constraint(equalTo: fGrid.topAnchor, constant: 0).isActive = true
        hGrid.topAnchor.constraint(equalTo: mainBtnContainer.topAnchor, constant: 10).isActive = true
        hGrid.layer.cornerRadius = 20 //10
        hGrid.isUserInteractionEnabled = true
        hGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDPhotoClicked)))
        
//        let hMiniBtn = UIImageView(image: UIImage(named:"icon_round_cc")?.withRenderingMode(.alwaysTemplate))
        let hMiniBtn = UIImageView(image: UIImage(named:"icon_round_type")?.withRenderingMode(.alwaysTemplate))
        hMiniBtn.tintColor = .white
        mainBtnContainer.addSubview(hMiniBtn)
        hMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        hMiniBtn.centerXAnchor.constraint(equalTo: hGrid.centerXAnchor).isActive = true
        hMiniBtn.centerYAnchor.constraint(equalTo: hGrid.centerYAnchor).isActive = true
        hMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        hMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let hMiniText = UILabel()
        hMiniText.textAlignment = .center
        hMiniText.textColor = .white
        hMiniText.font = .boldSystemFont(ofSize: 10)
        mainBtnContainer.addSubview(hMiniText)
        hMiniText.translatesAutoresizingMaskIntoConstraints = false
        hMiniText.topAnchor.constraint(equalTo: hGrid.bottomAnchor, constant: 2).isActive = true
        hMiniText.centerXAnchor.constraint(equalTo: hGrid.centerXAnchor).isActive = true
        hMiniText.text = "Subtitle"
        
//        let vcBtnContainer = UIView()
        panel.addSubview(vcBtnContainer)
        vcBtnContainer.translatesAutoresizingMaskIntoConstraints = false
        vcBtnContainer.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        vcBtnContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        vcBtnContainer.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        vcBtnContainer.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        vcBtnContainer.isHidden = true
        
        let backVcGrid = UIView() //edit vc
        backVcGrid.backgroundColor = .ddmDarkColor
        vcBtnContainer.addSubview(backVcGrid)
        backVcGrid.translatesAutoresizingMaskIntoConstraints = false
        backVcGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        backVcGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backVcGrid.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        backVcGrid.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
        backVcGrid.topAnchor.constraint(equalTo: vcBtnContainer.topAnchor, constant: 10).isActive = true
        backVcGrid.layer.cornerRadius = 10
        backVcGrid.isUserInteractionEnabled = true
        backVcGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVcClicked)))
        
        let backVcMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        backVcMiniBtn.tintColor = .white
        vcBtnContainer.addSubview(backVcMiniBtn)
        backVcMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        backVcMiniBtn.centerXAnchor.constraint(equalTo: backVcGrid.centerXAnchor).isActive = true
        backVcMiniBtn.centerYAnchor.constraint(equalTo: backVcGrid.centerYAnchor).isActive = true
        backVcMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backVcMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let sGrid = UIView() //split vc
        sGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(eGrid)
        vcBtnContainer.addSubview(sGrid)
        sGrid.translatesAutoresizingMaskIntoConstraints = false
        sGrid.leadingAnchor.constraint(equalTo: backVcGrid.trailingAnchor, constant: 40).isActive = true //20
        sGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        sGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        sGrid.topAnchor.constraint(equalTo: vcBtnContainer.topAnchor, constant: 10).isActive = true
        sGrid.layer.cornerRadius = 20 //10
        sGrid.isUserInteractionEnabled = true
        sGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSPhotoClicked)))
        
        let sMiniBtn = UIImageView(image: UIImage(named:"icon_round_split")?.withRenderingMode(.alwaysTemplate))
        sMiniBtn.tintColor = .white
        vcBtnContainer.addSubview(sMiniBtn)
        sMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        sMiniBtn.centerXAnchor.constraint(equalTo: sGrid.centerXAnchor).isActive = true
        sMiniBtn.centerYAnchor.constraint(equalTo: sGrid.centerYAnchor).isActive = true
        sMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let sMiniText = UILabel()
        sMiniText.textAlignment = .center
        sMiniText.textColor = .white
        sMiniText.font = .boldSystemFont(ofSize: 10)
        vcBtnContainer.addSubview(sMiniText)
        sMiniText.translatesAutoresizingMaskIntoConstraints = false
        sMiniText.topAnchor.constraint(equalTo: sGrid.bottomAnchor, constant: 2).isActive = true
        sMiniText.centerXAnchor.constraint(equalTo: sGrid.centerXAnchor).isActive = true
        sMiniText.text = "Split"
        
        let tGrid = UIView() //replace vc
        tGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(eGrid)
        vcBtnContainer.addSubview(tGrid)
        tGrid.translatesAutoresizingMaskIntoConstraints = false
        tGrid.leadingAnchor.constraint(equalTo: sGrid.trailingAnchor, constant: 20).isActive = true
        tGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        tGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        tGrid.topAnchor.constraint(equalTo: vcBtnContainer.topAnchor, constant: 10).isActive = true
        tGrid.layer.cornerRadius = 20 //10
        tGrid.isUserInteractionEnabled = true
        tGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTPhotoClicked)))
        
        let tMiniBtn = UIImageView(image: UIImage(named:"icon_round_swap")?.withRenderingMode(.alwaysTemplate))
        tMiniBtn.tintColor = .white
        vcBtnContainer.addSubview(tMiniBtn)
        tMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        tMiniBtn.centerXAnchor.constraint(equalTo: tGrid.centerXAnchor).isActive = true
        tMiniBtn.centerYAnchor.constraint(equalTo: tGrid.centerYAnchor).isActive = true
        tMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let tMiniText = UILabel()
        tMiniText.textAlignment = .center
        tMiniText.textColor = .white
        tMiniText.font = .boldSystemFont(ofSize: 10)
        vcBtnContainer.addSubview(tMiniText)
        tMiniText.translatesAutoresizingMaskIntoConstraints = false
        tMiniText.topAnchor.constraint(equalTo: tGrid.bottomAnchor, constant: 2).isActive = true
        tMiniText.centerXAnchor.constraint(equalTo: tGrid.centerXAnchor).isActive = true
        tMiniText.text = "Replace"
        
        let uGrid = UIView() //copy vc
        uGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(eGrid)
        vcBtnContainer.addSubview(uGrid)
        uGrid.translatesAutoresizingMaskIntoConstraints = false
        uGrid.leadingAnchor.constraint(equalTo: tGrid.trailingAnchor, constant: 20).isActive = true
        uGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        uGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        uGrid.topAnchor.constraint(equalTo: vcBtnContainer.topAnchor, constant: 10).isActive = true
        uGrid.layer.cornerRadius = 20 //10
        uGrid.isUserInteractionEnabled = true
        uGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUPhotoClicked)))
        
        let uMiniBtn = UIImageView(image: UIImage(named:"icon_round_content_copy")?.withRenderingMode(.alwaysTemplate))
        uMiniBtn.tintColor = .white
        vcBtnContainer.addSubview(uMiniBtn)
        uMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        uMiniBtn.centerXAnchor.constraint(equalTo: uGrid.centerXAnchor).isActive = true
        uMiniBtn.centerYAnchor.constraint(equalTo: uGrid.centerYAnchor).isActive = true
        uMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        uMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let uMiniText = UILabel()
        uMiniText.textAlignment = .center
        uMiniText.textColor = .white
        uMiniText.font = .boldSystemFont(ofSize: 10)
        vcBtnContainer.addSubview(uMiniText)
        uMiniText.translatesAutoresizingMaskIntoConstraints = false
        uMiniText.topAnchor.constraint(equalTo: uGrid.bottomAnchor, constant: 2).isActive = true
        uMiniText.centerXAnchor.constraint(equalTo: uGrid.centerXAnchor).isActive = true
        uMiniText.text = "Copy"
        
        let vGrid = UIView() //delete vc
//        vGrid.backgroundColor = .ddmDarkColor
        vGrid.backgroundColor = .red
//        panel.addSubview(eGrid)
        vcBtnContainer.addSubview(vGrid)
        vGrid.translatesAutoresizingMaskIntoConstraints = false
//        vGrid.leadingAnchor.constraint(equalTo: uGrid.trailingAnchor, constant: 20).isActive = true
        vGrid.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        vGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        vGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        vGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        vGrid.topAnchor.constraint(equalTo: vcBtnContainer.topAnchor, constant: 10).isActive = true
        vGrid.layer.cornerRadius = 20 //10
        vGrid.layer.opacity = 0.5
        vGrid.isUserInteractionEnabled = true
        vGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVPhotoClicked)))
        
        let vMiniBtn = UIImageView(image: UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate))
        vMiniBtn.tintColor = .white
        vcBtnContainer.addSubview(vMiniBtn)
        vMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        vMiniBtn.centerXAnchor.constraint(equalTo: vGrid.centerXAnchor).isActive = true
        vMiniBtn.centerYAnchor.constraint(equalTo: vGrid.centerYAnchor).isActive = true
        vMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        vMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let vMiniText = UILabel()
        vMiniText.textAlignment = .center
        vMiniText.textColor = .white
        vMiniText.font = .boldSystemFont(ofSize: 10)
        vcBtnContainer.addSubview(vMiniText)
        vMiniText.translatesAutoresizingMaskIntoConstraints = false
        vMiniText.topAnchor.constraint(equalTo: vGrid.bottomAnchor, constant: 2).isActive = true
        vMiniText.centerXAnchor.constraint(equalTo: vGrid.centerXAnchor).isActive = true
        vMiniText.text = "Delete"
        
        //audio tools panel
//        let acBtnContainer = UIView()
        panel.addSubview(acBtnContainer)
        acBtnContainer.translatesAutoresizingMaskIntoConstraints = false
        acBtnContainer.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        acBtnContainer.heightAnchor.constraint(equalToConstant: 90).isActive = true //120
        acBtnContainer.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
//        acBtnContainer.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        acBtnContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        acBtnContainer.isHidden = true
        
        let backAcGrid = UIView() //edit ac
        backAcGrid.backgroundColor = .ddmDarkColor
        acBtnContainer.addSubview(backAcGrid)
        backAcGrid.translatesAutoresizingMaskIntoConstraints = false
        backAcGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        backAcGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backAcGrid.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        backAcGrid.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
        backAcGrid.topAnchor.constraint(equalTo: acBtnContainer.topAnchor, constant: 10).isActive = true
        backAcGrid.layer.cornerRadius = 10
        backAcGrid.isUserInteractionEnabled = true
        backAcGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackAcClicked)))
        
        let backAcMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        backAcMiniBtn.tintColor = .white
        acBtnContainer.addSubview(backAcMiniBtn)
        backAcMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        backAcMiniBtn.centerXAnchor.constraint(equalTo: backAcGrid.centerXAnchor).isActive = true
        backAcMiniBtn.centerYAnchor.constraint(equalTo: backAcGrid.centerYAnchor).isActive = true
        backAcMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backAcMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let acSGrid = UIView() //split vc
        acSGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(eGrid)
        acBtnContainer.addSubview(acSGrid)
        acSGrid.translatesAutoresizingMaskIntoConstraints = false
        acSGrid.leadingAnchor.constraint(equalTo: backAcGrid.trailingAnchor, constant: 40).isActive = true //20
        acSGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        acSGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        acSGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        acSGrid.topAnchor.constraint(equalTo: vcBtnContainer.topAnchor, constant: 10).isActive = true
        acSGrid.layer.cornerRadius = 20 //10
        acSGrid.isUserInteractionEnabled = true
        acSGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSPhotoClicked)))
        
        let acSMiniBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        acSMiniBtn.tintColor = .white
        acBtnContainer.addSubview(acSMiniBtn)
        acSMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        acSMiniBtn.centerXAnchor.constraint(equalTo: acSGrid.centerXAnchor).isActive = true
        acSMiniBtn.centerYAnchor.constraint(equalTo: acSGrid.centerYAnchor).isActive = true
        acSMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        acSMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let acSMiniText = UILabel()
        acSMiniText.textAlignment = .center
        acSMiniText.textColor = .white
        acSMiniText.font = .boldSystemFont(ofSize: 10)
        acBtnContainer.addSubview(acSMiniText)
        acSMiniText.translatesAutoresizingMaskIntoConstraints = false
        acSMiniText.topAnchor.constraint(equalTo: acSGrid.bottomAnchor, constant: 2).isActive = true
        acSMiniText.centerXAnchor.constraint(equalTo: acSGrid.centerXAnchor).isActive = true
        acSMiniText.text = "Edit"
        
        let acVGrid = UIView() //delete vc
//        acVGrid.backgroundColor = .ddmDarkColor
        acVGrid.backgroundColor = .red
//        panel.addSubview(acVGrid)
        acBtnContainer.addSubview(acVGrid)
        acVGrid.translatesAutoresizingMaskIntoConstraints = false
//        acVGrid.leadingAnchor.constraint(equalTo: uGrid.trailingAnchor, constant: 20).isActive = true
        acVGrid.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        acVGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        acVGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        acVGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        acVGrid.topAnchor.constraint(equalTo: acBtnContainer.topAnchor, constant: 10).isActive = true
        acVGrid.layer.cornerRadius = 20 //10
        acVGrid.layer.opacity = 0.5
        acVGrid.isUserInteractionEnabled = true
        acVGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAcVPhotoClicked)))
        
        let acVMiniBtn = UIImageView(image: UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate))
        acVMiniBtn.tintColor = .white
        acBtnContainer.addSubview(acVMiniBtn)
        acVMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        acVMiniBtn.centerXAnchor.constraint(equalTo: acVGrid.centerXAnchor).isActive = true
        acVMiniBtn.centerYAnchor.constraint(equalTo: acVGrid.centerYAnchor).isActive = true
        acVMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        acVMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let acVMiniText = UILabel()
        acVMiniText.textAlignment = .center
        acVMiniText.textColor = .white
        acVMiniText.font = .boldSystemFont(ofSize: 10)
        acBtnContainer.addSubview(acVMiniText)
        acVMiniText.translatesAutoresizingMaskIntoConstraints = false
        acVMiniText.topAnchor.constraint(equalTo: acVGrid.bottomAnchor, constant: 2).isActive = true
        acVMiniText.centerXAnchor.constraint(equalTo: acVGrid.centerXAnchor).isActive = true
        acVMiniText.text = "Delete"
        
        //subtitle tools panel
        panel.addSubview(scBtnContainer)
        scBtnContainer.translatesAutoresizingMaskIntoConstraints = false
        scBtnContainer.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        scBtnContainer.heightAnchor.constraint(equalToConstant: 90).isActive = true //120
        scBtnContainer.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
//        scBtnContainer.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        scBtnContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scBtnContainer.isHidden = true
        
        let backScGrid = UIView() //edit ac
        backScGrid.backgroundColor = .ddmDarkColor
        scBtnContainer.addSubview(backScGrid)
        backScGrid.translatesAutoresizingMaskIntoConstraints = false
        backScGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        backScGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backScGrid.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        backScGrid.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
        backScGrid.topAnchor.constraint(equalTo: scBtnContainer.topAnchor, constant: 10).isActive = true
        backScGrid.layer.cornerRadius = 10
        backScGrid.isUserInteractionEnabled = true
        backScGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackScClicked)))
        
        let backScMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        backScMiniBtn.tintColor = .white
        scBtnContainer.addSubview(backScMiniBtn)
        backScMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        backScMiniBtn.centerXAnchor.constraint(equalTo: backScGrid.centerXAnchor).isActive = true
        backScMiniBtn.centerYAnchor.constraint(equalTo: backScGrid.centerYAnchor).isActive = true
        backScMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backScMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let scSGrid = UIView() //split vc
        scSGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(eGrid)
        scBtnContainer.addSubview(scSGrid)
        scSGrid.translatesAutoresizingMaskIntoConstraints = false
        scSGrid.leadingAnchor.constraint(equalTo: backScGrid.trailingAnchor, constant: 40).isActive = true //20
        scSGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scSGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        scSGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        scSGrid.topAnchor.constraint(equalTo: scBtnContainer.topAnchor, constant: 10).isActive = true
        scSGrid.layer.cornerRadius = 20 //10
        scSGrid.isUserInteractionEnabled = true
        scSGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSCPhotoClicked)))
        
        let scSMiniBtn = UIImageView(image: UIImage(named:"icon_round_type")?.withRenderingMode(.alwaysTemplate))
        scSMiniBtn.tintColor = .white
        scBtnContainer.addSubview(scSMiniBtn)
        scSMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        scSMiniBtn.centerXAnchor.constraint(equalTo: scSGrid.centerXAnchor).isActive = true
        scSMiniBtn.centerYAnchor.constraint(equalTo: scSGrid.centerYAnchor).isActive = true
        scSMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        scSMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let scSMiniText = UILabel()
        scSMiniText.textAlignment = .center
        scSMiniText.textColor = .white
        scSMiniText.font = .boldSystemFont(ofSize: 10)
        scBtnContainer.addSubview(scSMiniText)
        scSMiniText.translatesAutoresizingMaskIntoConstraints = false
        scSMiniText.topAnchor.constraint(equalTo: scSGrid.bottomAnchor, constant: 2).isActive = true
        scSMiniText.centerXAnchor.constraint(equalTo: scSGrid.centerXAnchor).isActive = true
        scSMiniText.text = "Edit"
        
        let scVGrid = UIView() //delete vc
//        scVGrid.backgroundColor = .ddmDarkColor
        scVGrid.backgroundColor = .red
//        panel.addSubview(scVGrid)
        scBtnContainer.addSubview(scVGrid)
        scVGrid.translatesAutoresizingMaskIntoConstraints = false
//        scVGrid.leadingAnchor.constraint(equalTo: uGrid.trailingAnchor, constant: 20).isActive = true
        scVGrid.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        scVGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scVGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        scVGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        scVGrid.topAnchor.constraint(equalTo: scBtnContainer.topAnchor, constant: 10).isActive = true
        scVGrid.layer.cornerRadius = 20 //10
        scVGrid.layer.opacity = 0.5
        scVGrid.isUserInteractionEnabled = true
        scVGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onScVPhotoClicked)))
        
        let scVMiniBtn = UIImageView(image: UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate))
        scVMiniBtn.tintColor = .white
        scBtnContainer.addSubview(scVMiniBtn)
        scVMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        scVMiniBtn.centerXAnchor.constraint(equalTo: scVGrid.centerXAnchor).isActive = true
        scVMiniBtn.centerYAnchor.constraint(equalTo: scVGrid.centerYAnchor).isActive = true
        scVMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        scVMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let scVMiniText = UILabel()
        scVMiniText.textAlignment = .center
        scVMiniText.textColor = .white
        scVMiniText.font = .boldSystemFont(ofSize: 10)
        scBtnContainer.addSubview(scVMiniText)
        scVMiniText.translatesAutoresizingMaskIntoConstraints = false
        scVMiniText.topAnchor.constraint(equalTo: scVGrid.bottomAnchor, constant: 2).isActive = true
        scVMiniText.centerXAnchor.constraint(equalTo: scVGrid.centerXAnchor).isActive = true
        scVMiniText.text = "Delete"
        
        
        //test > preview GIF and thumbnail for compressed video
//        let gifImage = SDAnimatedImageView()
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.layer.masksToBounds = true
//        gifImage.sd_setImage(with: getGifOutputURL())
//        panel.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
////        gifImage.leadingAnchor.constraint(equalTo: eGrid.leadingAnchor).isActive = true
////        gifImage.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        gifImage.leadingAnchor.constraint(equalTo: gGrid.trailingAnchor, constant: 20).isActive = true
//        gifImage.topAnchor.constraint(equalTo: gGrid.topAnchor, constant: 0).isActive = true
//        gifImage.heightAnchor.constraint(equalToConstant: 90).isActive = true //ori 30
//        gifImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        gifImage.layer.cornerRadius = 10
//
//        let thumbImage = SDAnimatedImageView()
//        thumbImage.contentMode = .scaleAspectFill
//        thumbImage.layer.masksToBounds = true
//        thumbImage.sd_setImage(with: getCoverImageOutputURL())
//        panel.addSubview(thumbImage)
//        thumbImage.translatesAutoresizingMaskIntoConstraints = false
////        thumbImage.leadingAnchor.constraint(equalTo: gifImage.trailingAnchor, constant: 20).isActive = true
////        thumbImage.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        thumbImage.leadingAnchor.constraint(equalTo: gifImage.trailingAnchor, constant: 20).isActive = true
//        thumbImage.topAnchor.constraint(equalTo: gifImage.topAnchor, constant: 0).isActive = true
//        thumbImage.heightAnchor.constraint(equalToConstant: 90).isActive = true //ori 30
//        thumbImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        thumbImage.layer.cornerRadius = 10
        
        //test > put video container on top for resizing
        panel.addSubview(videoContainer)
        videoContainer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
//        videoContainer.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 0).isActive = true
//        videoContainer.topAnchor.constraint(equalTo: audioContainer.topAnchor, constant: 0).isActive = true
        videoTopLayoutConstraint = videoContainer.topAnchor.constraint(equalTo: audioContainer.topAnchor, constant: 0)
        videoTopLayoutConstraint?.isActive = true
        videoWidthLayoutConstraint = videoContainer.widthAnchor.constraint(equalToConstant: width)
        videoWidthLayoutConstraint?.isActive = true
        videoHeightLayoutConstraint = videoContainer.heightAnchor.constraint(equalToConstant: height)
        videoHeightLayoutConstraint?.isActive = true
        videoContainer.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
        videoContainer.clipsToBounds = true
        videoContainer.layer.cornerRadius = 10
        videoContainer.backgroundColor = .black
        videoContainer.isUserInteractionEnabled = true
        videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMinimizeVideoClicked)))
        
        let maxVBtn = UIView() //delete vc
        maxVBtn.backgroundColor = .ddmDarkColor
//        minVBtn.backgroundColor = .red
        panel.addSubview(maxVBtn)
        maxVBtn.translatesAutoresizingMaskIntoConstraints = false
//        minVBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
        maxVBtn.leadingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: 5).isActive = true
        maxVBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        maxVBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        minVBtn.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 5).isActive = true
        maxVBtn.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 0).isActive = true
        maxVBtn.layer.cornerRadius = 5 //10
        maxVBtn.layer.opacity = 0.5
        maxVBtn.isUserInteractionEnabled = true
        maxVBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMinimizeVideoClicked)))

        let maxVBtnImage = UIImageView()
        maxVBtnImage.image = UIImage(named:"icon_round_vid_open")?.withRenderingMode(.alwaysTemplate)
        maxVBtnImage.tintColor = .white
        panel.addSubview(maxVBtnImage)
        maxVBtnImage.translatesAutoresizingMaskIntoConstraints = false
        maxVBtnImage.centerYAnchor.constraint(equalTo: maxVBtn.centerYAnchor).isActive = true
        maxVBtnImage.centerXAnchor.constraint(equalTo: maxVBtn.centerXAnchor).isActive = true
        maxVBtnImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        maxVBtnImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        //**test > subtitle
//        let sBox = UIView()
        sBox.backgroundColor = .ddmDarkColor
        panel.addSubview(sBox)
        sBox.clipsToBounds = true
        sBox.translatesAutoresizingMaskIntoConstraints = false
        sBox.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 15).isActive = true
        sBoxTrailingLayoutConstraint = sBox.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -15)
        sBoxTrailingLayoutConstraint?.isActive = true
        sBoxWidthLayoutConstraint = sBox.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        sBoxWidthLayoutConstraint?.isActive = false
        sBox.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -10).isActive = true
        sBox.layer.cornerRadius = 5 //10
        sBox.layer.opacity = 0.3
        sBox.isHidden = true
        
//        let sText = UILabel()
        sText.textAlignment = .left
        sText.textColor = .white
//        sText.textColor = .ddmBlackOverlayColor
        sText.font = .systemFont(ofSize: 10) //14
//        contentView.addSubview(sText)
        panel.addSubview(sText)
        sText.clipsToBounds = true
        sText.translatesAutoresizingMaskIntoConstraints = false
//        sText.topAnchor.constraint(equalTo: sBox.topAnchor, constant: 10).isActive = true //5
//        sText.bottomAnchor.constraint(equalTo: sBox.bottomAnchor, constant: -10).isActive = true //-5
//        sText.leadingAnchor.constraint(equalTo: subMiniBtn.trailingAnchor, constant: 10).isActive = true
        sText.leadingAnchor.constraint(equalTo: sBox.leadingAnchor, constant: 10).isActive = true
        sText.trailingAnchor.constraint(equalTo: sBox.trailingAnchor, constant: -10).isActive = true
//        sText.centerYAnchor.constraint(equalTo: sBox.centerYAnchor, constant: 0).isActive = true
        sText.topAnchor.constraint(equalTo: sBox.topAnchor, constant: 10).isActive = true //5
        sText.bottomAnchor.constraint(equalTo: sBox.bottomAnchor, constant: -10).isActive = true //-5
        sText.text = ""
        sText.numberOfLines = 1
        //**
        
//        let maxVidPanel = UIView()
        maxVidPanel.backgroundColor = .ddmBlackOverlayColor
        panel.insertSubview(maxVidPanel, belowSubview: videoContainer)
        maxVidPanel.translatesAutoresizingMaskIntoConstraints = false
        maxVidPanel.layer.masksToBounds = true
        maxVidPanel.layer.cornerRadius = 10 //10
        maxVidPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        maxVidPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        maxVidPanel.isHidden = true

        let progressBaseline = UIView()
        maxVidPanel.addSubview(progressBaseline)
        progressBaseline.translatesAutoresizingMaskIntoConstraints = false
        progressBaseline.centerYAnchor.constraint(equalTo: maxVidPanel.bottomAnchor, constant: -70).isActive = true
        progressBaseline.centerXAnchor.constraint(equalTo: maxVidPanel.centerXAnchor).isActive = true
        progressBaseline.widthAnchor.constraint(equalToConstant: viewWidth - 120).isActive = true
        progressBaseline.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressBaseline.backgroundColor = .white
        progressBaseline.layer.opacity = 0.3
        progressBaseline.layer.cornerRadius = 2

        let progress = UIView()
        maxVidPanel.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.centerYAnchor.constraint(equalTo: progressBaseline.centerYAnchor, constant: 0).isActive = true
        progress.leadingAnchor.constraint(equalTo: progressBaseline.leadingAnchor, constant: 0).isActive = true
        progressCenterXCons = progress.widthAnchor.constraint(equalToConstant: 0)
        progressCenterXCons?.isActive = true
        progress.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progress.layer.cornerRadius = 2
        progress.backgroundColor = .white
        
        let minVBtn = UIView() //delete vc
//        minVBtn.backgroundColor = .ddmDarkColor
//        minVBtn.backgroundColor = .red
        maxVidPanel.addSubview(minVBtn)
        minVBtn.translatesAutoresizingMaskIntoConstraints = false
//        minVBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -5).isActive = true
        minVBtn.centerYAnchor.constraint(equalTo: progressBaseline.centerYAnchor, constant: 0).isActive = true
        minVBtn.trailingAnchor.constraint(equalTo: maxVidPanel.trailingAnchor, constant: -10).isActive = true
        minVBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        minVBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        minVBtn.layer.cornerRadius = 5 //10
//        minVBtn.layer.opacity = 0.1
        minVBtn.isUserInteractionEnabled = true
        minVBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMinimizeVideoClicked)))

        let minVBtnImage = UIImageView()
        minVBtnImage.image = UIImage(named:"icon_round_vid_close")?.withRenderingMode(.alwaysTemplate)
        minVBtnImage.tintColor = .white
        maxVidPanel.addSubview(minVBtnImage)
        minVBtnImage.translatesAutoresizingMaskIntoConstraints = false
        minVBtnImage.centerYAnchor.constraint(equalTo: minVBtn.centerYAnchor).isActive = true
        minVBtnImage.centerXAnchor.constraint(equalTo: minVBtn.centerXAnchor).isActive = true
        minVBtnImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        minVBtnImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        maxVPauseBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        maxVPauseBtn.tintColor = .white
        maxVidPanel.addSubview(maxVPauseBtn)
        maxVPauseBtn.translatesAutoresizingMaskIntoConstraints = false
        maxVPauseBtn.centerYAnchor.constraint(equalTo: progressBaseline.centerYAnchor, constant: 0).isActive = true
        maxVPauseBtn.leadingAnchor.constraint(equalTo: maxVidPanel.leadingAnchor, constant: 10).isActive = true
        maxVPauseBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maxVPauseBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        maxVPauseBtn.isUserInteractionEnabled = true
        maxVPauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
        maxVPauseBtn.isHidden = true
        
        maxVPlayBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        maxVPlayBtn.tintColor = .white
        maxVidPanel.addSubview(maxVPlayBtn)
        maxVPlayBtn.translatesAutoresizingMaskIntoConstraints = false
        maxVPlayBtn.centerYAnchor.constraint(equalTo: progressBaseline.centerYAnchor, constant: 0).isActive = true
        maxVPlayBtn.leadingAnchor.constraint(equalTo: maxVidPanel.leadingAnchor, constant: 10).isActive = true
        maxVPlayBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maxVPlayBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        maxVPlayBtn.isUserInteractionEnabled = true
        maxVPlayBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
        
        //test** > text box for subtitle
        blocker.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(blocker)
        blocker.translatesAutoresizingMaskIntoConstraints = false
        blocker.topAnchor.constraint(equalTo: audioContainer.bottomAnchor, constant: 0).isActive = true
        blocker.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        blocker.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        blocker.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        blocker.isHidden = true
        
//        let bTimePlayText = UILabel()
        bTimePlayText.textAlignment = .left
        bTimePlayText.textColor = .white
        bTimePlayText.font = .systemFont(ofSize: 10)
        blocker.addSubview(bTimePlayText)
        bTimePlayText.translatesAutoresizingMaskIntoConstraints = false
        bTimePlayText.topAnchor.constraint(equalTo: blocker.topAnchor, constant: 20).isActive = true
        bTimePlayText.centerXAnchor.constraint(equalTo: blocker.centerXAnchor, constant: 0).isActive = true
        bTimePlayText.text = ""
        bTimePlayText.isHidden = true
        
        //test > real textview edittext for comment
        panel.addSubview(aView)
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        aView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aView.isUserInteractionEnabled = true
        aView.isHidden = true
        aView.backgroundColor = .clear
        aView.layer.opacity = 0.1 //0.2
//        let cPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextNextClicked))
//        aView.addGestureRecognizer(cPanelPanGesture)
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextBackClicked)))
        
//        textPanel.backgroundColor = .ddmBlackOverlayColor
        textPanel.backgroundColor = .black
        panel.addSubview(textPanel)
        textPanel.translatesAutoresizingMaskIntoConstraints = false
//        textPanel.topAnchor.constraint(equalTo: panel.topAnchor, constant: 100).isActive = true
//        textPanel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        textPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        textPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        textPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        textPanel.layer.cornerRadius = 0
        textPanel.isHidden = true
        
        let aTextOK = UIView()
        aTextOK.backgroundColor = .yellow
        textPanel.addSubview(aTextOK)
        aTextOK.translatesAutoresizingMaskIntoConstraints = false
        aTextOK.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aTextOK.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aTextOK.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aTextOK.centerYAnchor.constraint(equalTo: textPanel.centerYAnchor, constant: 0).isActive = true
        aTextOK.layer.cornerRadius = 15
        aTextOK.isUserInteractionEnabled = true
        aTextOK.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextNextClicked)))
        
        let aTextOKMiniBtn = UIImageView(image: UIImage(named:"icon_round_done")?.withRenderingMode(.alwaysTemplate))
        aTextOKMiniBtn.tintColor = .black
        textPanel.addSubview(aTextOKMiniBtn)
        aTextOKMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aTextOKMiniBtn.centerXAnchor.constraint(equalTo: aTextOK.centerXAnchor).isActive = true
        aTextOKMiniBtn.centerYAnchor.constraint(equalTo: aTextOK.centerYAnchor).isActive = true
        aTextOKMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aTextOKMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        aaView.backgroundColor = .ddmDarkColor
        textPanel.addSubview(aaView)
        aaView.translatesAutoresizingMaskIntoConstraints = false
        aaView.leadingAnchor.constraint(equalTo: textPanel.leadingAnchor, constant: 20).isActive = true //15
        aaView.topAnchor.constraint(equalTo: textPanel.topAnchor, constant: 10).isActive = true
        aaView.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -10).isActive = true //-10
        aaView.trailingAnchor.constraint(equalTo: aTextOK.leadingAnchor, constant: -10).isActive = true
        aaView.layer.cornerRadius = 10
        
        aTextBox.textAlignment = .left
        aTextBox.textColor = .white
        aTextBox.backgroundColor = .clear
        aTextBox.font = .systemFont(ofSize: 13)
        textPanel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
        aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: -4).isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: aaView.leadingAnchor, constant: 10).isActive = true
        aTextBox.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10).isActive = true
        aTextBox.topAnchor.constraint(equalTo: aaView.topAnchor, constant: 4).isActive = true
        aTextBox.heightAnchor.constraint(equalToConstant: 70).isActive = true //36
        aTextBox.text = ""
//        aTextBox.delegate = self
        aTextBox.tintColor = .yellow
        
        //test > process video progress
//        let videoProcessProgressPanel = UIView()
        panel.addSubview(videoProcessProgressPanel)
        videoProcessProgressPanel.translatesAutoresizingMaskIntoConstraints = false
        videoProcessProgressPanel.topAnchor.constraint(equalTo: panel.topAnchor).isActive = true
        videoProcessProgressPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
        videoProcessProgressPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor).isActive = true
        videoProcessProgressPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        videoProcessProgressPanel.isHidden = true
        
        let videoProcessProgressBG = UIView()
        videoProcessProgressPanel.addSubview(videoProcessProgressBG)
        videoProcessProgressBG.backgroundColor = .ddmBlackOverlayColor
        videoProcessProgressBG.layer.opacity = 0.5
        videoProcessProgressBG.translatesAutoresizingMaskIntoConstraints = false
        videoProcessProgressBG.topAnchor.constraint(equalTo: videoProcessProgressPanel.topAnchor).isActive = true
        videoProcessProgressBG.leadingAnchor.constraint(equalTo: videoProcessProgressPanel.leadingAnchor).isActive = true
        videoProcessProgressBG.bottomAnchor.constraint(equalTo: videoProcessProgressPanel.bottomAnchor).isActive = true
        videoProcessProgressBG.trailingAnchor.constraint(equalTo: videoProcessProgressPanel.trailingAnchor).isActive = true
        
        let semiTransparentBg = UIView()
        videoProcessProgressPanel.addSubview(semiTransparentBg)
        semiTransparentBg.backgroundColor = .ddmDarkColor
        semiTransparentBg.translatesAutoresizingMaskIntoConstraints = false
        semiTransparentBg.centerYAnchor.constraint(equalTo: videoProcessProgressPanel.centerYAnchor).isActive = true
        semiTransparentBg.centerXAnchor.constraint(equalTo: videoProcessProgressPanel.centerXAnchor).isActive = true
        semiTransparentBg.heightAnchor.constraint(equalToConstant: 100).isActive = true
        semiTransparentBg.widthAnchor.constraint(equalToConstant: 100).isActive = true
        semiTransparentBg.layer.cornerRadius = 10
        
        semiTransparentBg.addSubview(semiTransparentSpinner)
        semiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        semiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
        semiTransparentSpinner.centerYAnchor.constraint(equalTo: semiTransparentBg.centerYAnchor, constant: -10).isActive = true
        semiTransparentSpinner.centerXAnchor.constraint(equalTo: semiTransparentBg.centerXAnchor).isActive = true
        semiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        semiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        semiTransparentSpinner.startAnimating()
        
        let vProcessText = UILabel()
        vProcessText.textAlignment = .left
        vProcessText.textColor = .white
        vProcessText.font = .systemFont(ofSize: 10)
        semiTransparentBg.addSubview(vProcessText)
        vProcessText.translatesAutoresizingMaskIntoConstraints = false
        vProcessText.topAnchor.constraint(equalTo: semiTransparentSpinner.bottomAnchor, constant: 5).isActive = true
        vProcessText.centerXAnchor.constraint(equalTo: semiTransparentBg.centerXAnchor, constant: 0).isActive = true
        vProcessText.text = "20%"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //**
    }
    
    //test** > text box for subtitle
    let blocker = UIView()
    let textPanel = UIView()
    let aView = UIView()
    let aaView = UIView()
    let aTextBox = UITextView()
    let bTimePlayText = UILabel()
    var aaViewBottomCons: NSLayoutConstraint?
    var isKeyboardUp = false
    var currentFirstResponder : UITextView?
    
    func setFirstResponder(textView: UITextView) {
        currentFirstResponder = textView
        textView.becomeFirstResponder()
    }
    func resignResponder() {
        self.endEditing(true)
        currentFirstResponder = nil
//
        isKeyboardUp = false
        
        textPanel.isHidden = true
        aView.isHidden = true
        blocker.isHidden = true
    }
    @objc func onKeyboardWillChange(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            guard let firstResponder = self.currentFirstResponder else {
                return
            }
            if(firstResponder == aTextBox) {
                print("currentfirstresponder true \(keyboardSize.height) ")
                
                textPanel.isHidden = false
                aView.isHidden = false
                blocker.isHidden = false
                
                let margin = keyboardSize.height
                if(!isKeyboardUp) {
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut],
                        animations: {
                        self.textPanel.transform = CGAffineTransform(translationX: 0, y: -margin)
                    }, completion: { finished in
                    })
                } else {
                    self.textPanel.transform = CGAffineTransform(translationX: 0, y: -margin)
                }
                
                isKeyboardUp = true
            }
        }
    }
    @objc func onTextNextClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        
        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
        
        guard let b = aTextBox.text else {
            return
        }
        
        if(selectedScIndex > -1) {
            if(!scList.isEmpty) {
                scList[selectedScIndex].subString = b
                scList[selectedScIndex].scText.text = b
                
                if(currentATime > scList[selectedScIndex].t_s && currentATime < scList[selectedScIndex].t_e) {
                    sText.text = b
                }
                
                aTextBox.text = ""
            }
        } else {
            var endT = currentATime + 1.0
            if(endT >= totalVDuration) {
                endT = totalVDuration
            }
            print("videditor 1: \(currentATime), \(endT)")
            if(scInsertIndex > -1) {
                if(scInsertIndex < scList.count) {
                    let c = scList[scInsertIndex]
                    let ts = c.t_s
                    
                    if(endT >= ts) {
                        endT = ts
                    }
                }
                print("addsub: \(currentATime), \(endT)")
                addSubtitleClip(subtitleStr: b, tStart: currentATime, tEnd: endT, isIndex: true, xIndex: scInsertIndex)
            } else {
                addSubtitleClip(subtitleStr: b, tStart: currentATime, tEnd: endT, isIndex: false, xIndex: 0)
            }
            sText.text = b
            
            aTextBox.text = ""
        }
        
        
        if(sText.text == "") {
            sBox.isHidden = true
        } else {
            sBox.isHidden = false
        }

    }
    @objc func onTextBackClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        
        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
        aTextBox.text = ""
    }
    //**
    
    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
        //test > select vc for edit
        var i = 0
        var totalPFW = 0.0
        let offX = viewWidth/2
        let currentX = timelineScrollView.contentOffset.x + offX
        
        for _ in vcList {
            totalPFW = totalPFW + vcList[i].pFrameWidth
            if(currentX < totalPFW) {
                print("aphoto: \(i)")
                break
            }
            
            if(i + 1 < vcList.count) {
                i += 1
            }
        }
        
        if(vcList.count > 0) {
            if(!vcList[i].isVcSelected) {
                vcList[i].selectVideoClip()
                selectedVcIndex = i
            }
            
            refreshVcBtnUIChange()
        }
    }
    @objc func onAAPhotoClicked(gesture: UITapGestureRecognizer) {
        
    }
    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
        //test > add vc
        delegate?.didClickAddVideoClip()
    }
    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
        
        if(audioClipList.isEmpty) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)

            //add audio
            addAudioClip(strAUrl: "")
            player2.volume = 1.0 //mute
            audioMiniText.text = "Wildson ft. Astyn Turr - One on One"
            
            //test > detect when audio finish playing => stop video player too
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
        }
    }
    var scInsertIndex = -1
    @objc func onDPhotoClicked(gesture: UITapGestureRecognizer) {
        //test 1
//        setFirstResponder(textView: aTextBox)
        
        //test 2 > check whether current time already has subtitle
        scInsertIndex = -1
        if(scList.isEmpty) {
            setFirstResponder(textView: aTextBox)
        } else {
            for i in 0..<scList.count {
                if(currentATime < scList[i].t_e) {
                    if(currentATime > scList[i].t_s) {
                        //sub already exists
                        print("sub A \(i)")
                    } else {
                        print("sub B \(i)")
                        scInsertIndex = i
                        setFirstResponder(textView: aTextBox)
                    }
                    break
                } else {
                    if(i == scList.count - 1) {
                        print("sub C \(i)")
                        setFirstResponder(textView: aTextBox)
                    }
                }
            }
        }
    }
    @objc func onBackVcClicked(gesture: UITapGestureRecognizer) {
        
        selectedVcIndex = -1
        for vc in vcList {
            vc.unselectVideoClip()
        }
        
        refreshVcBtnUIChange()
    }
    
    @objc func onSPhotoClicked(gesture: UITapGestureRecognizer) {
        //split
        print("split vc : \(lastPlayingVcCT)")
        
        if(selectedVcIndex > -1) {
            let strVUrl = vcList[selectedVcIndex].strVUrl
            let p = vcList[selectedVcIndex].t_e
            cutVideoClipTime(i: selectedVcIndex, t_e: lastPlayingVcCT)
            addVideoClip(strVUrl: strVUrl, isResized: true, tStart: lastPlayingVcCT, tEnd: p, isIndex: true, xIndex: selectedVcIndex + 1, isToOffset: false)
            
            vcList[selectedVcIndex].unselectVideoClip()
            selectedVcIndex = -1
            
            refreshVcBtnUIChange()
        }
    }
    @objc func onTPhotoClicked(gesture: UITapGestureRecognizer) {
        //replace
        let x = selectedVcIndex
        removeVideoClip(i: selectedVcIndex)
        
        let newStrVurl = "file:///var/mobile/Media/DCIM/103APPLE/IMG_3858.MOV"
        addVideoClip(strVUrl: newStrVurl, index: x, toOffset: false)
    }
    @objc func onUPhotoClicked(gesture: UITapGestureRecognizer) {
        //copy
        let strVUrl = vcList[selectedVcIndex].strVUrl
        addVideoClip(strVUrl: strVUrl, index: selectedVcIndex + 1, toOffset: true)
        
        //unselect
        if(selectedVcIndex > -1) {
            selectedVcIndex = -1
            for vc in vcList {
                vc.unselectVideoClip()
            }
            
            refreshVcBtnUIChange()
        }
    }
    @objc func onVPhotoClicked(gesture: UITapGestureRecognizer) {
        //delete
        removeVideoClip(i: selectedVcIndex)
    }
    @objc func onSelectAudioClicked(gesture: UITapGestureRecognizer) {
        
        if(selectedVcIndex > -1) {
            selectedVcIndex = -1
            for vc in vcList {
                vc.unselectVideoClip()
            }
            
            refreshVcBtnUIChange()
        }
        
        if(!scList.isEmpty) {
            for sc in scList {
                sc.unselectSubtitleClip()
            }
            selectedScIndex = -1
        }
        refreshScBtnUIChange()
        
        //test 2 > select audio clip
        if(audioClipList.isEmpty) {
 
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)

            //add audio
            addAudioClip(strAUrl: "")
            player2.volume = 1.0 //mute
            audioMiniText.text = "Wildson ft. Astyn Turr - One on One"
            
            //test > detect when audio finish playing => stop video player too
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
            
        } else {
            if(audioClipList[0].isAcSelected) {
                audioScrollBase.isHidden = true
                audioClipList[0].unselectAudioClip()
                selectedAcIndex = -1
            } else {
                audioScrollBase.isHidden = false
                audioClipList[0].selectAudioClip()
                selectedAcIndex = 0
            }
        }
        
        refreshAcBtnUIChange()
    }
    func refreshAcBtnUIChange() {
        if(selectedAcIndex > -1) {
            mainBtnContainer.isHidden = true
            acBtnContainer.isHidden = false
        } else {
            mainBtnContainer.isHidden = false
            acBtnContainer.isHidden = true
        }
    }
    
    func refreshVcBtnUIChange() {
        if(selectedVcIndex > -1) {
            mainBtnContainer.isHidden = true
            vcBtnContainer.isHidden = false
        } else {
            mainBtnContainer.isHidden = false
            vcBtnContainer.isHidden = true
        }
    }
    func refreshScBtnUIChange() {
        if(selectedScIndex > -1) {
            mainBtnContainer.isHidden = true
            scBtnContainer.isHidden = false
        } else {
            mainBtnContainer.isHidden = false
            scBtnContainer.isHidden = true
        }
    }
    @objc func onBackAcClicked(gesture: UITapGestureRecognizer) {
        
        if(!audioClipList.isEmpty) {
            audioScrollBase.isHidden = true
            audioClipList[0].unselectAudioClip()
            selectedAcIndex = -1
        }
        refreshAcBtnUIChange()
    }
    @objc func onAcVPhotoClicked(gesture: UITapGestureRecognizer) {
        
        if(!audioClipList.isEmpty) {
            audioScrollBase.isHidden = true
            audioClipList[0].unselectAudioClip()
            selectedAcIndex = -1
        }
        refreshAcBtnUIChange()
        
        //delete
        if(!audioClipList.isEmpty) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)

            //remove audio
            removeAudioClip()
            player2.volume = 0.0 //mute
            audioMiniText.text = "Tap to Add Sound"
            
            //test > detect when audio finish playing => stop video player too
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
        }
    }

    @objc func onTimelineClicked(gesture: UITapGestureRecognizer) {
        //unselect video
        selectedVcIndex = -1
        for vc in vcList {
            vc.unselectVideoClip()
        }
        
        refreshVcBtnUIChange()
        
        //unselect audio
        if(!audioClipList.isEmpty) {
            audioScrollBase.isHidden = true
            audioClipList[0].unselectAudioClip()
            selectedAcIndex = -1
        }
        refreshAcBtnUIChange()
        
        if(!scList.isEmpty) {
            for sc in scList {
                sc.unselectSubtitleClip()
            }
            selectedScIndex = -1
        }
        refreshScBtnUIChange()
    }
    
    @objc func onTCFrameClicked(gesture: UITapGestureRecognizer) {
        print("tc frame clicked, \(UIScreen.main.scale)")
        if let tappedView = gesture.view {
            //unselect audio
            if(!audioClipList.isEmpty) {
                audioScrollBase.isHidden = true
                audioClipList[0].unselectAudioClip()
                selectedAcIndex = -1
            }
            refreshAcBtnUIChange()
            
            if(!scList.isEmpty) {
                for sc in scList {
                    sc.unselectSubtitleClip()
                }
                selectedScIndex = -1
            }
            refreshScBtnUIChange()
            
            //select/unselect video
            selectedVcIndex = -1
            
            var i = 0
            for vc in vcList {
                if vc.pFrame == tappedView {
                    print("Tapped view: \(tappedView)")
                    if(vc.isVcSelected) {
                        vc.unselectVideoClip()
                        print("tc A")
                    } else {
                        vc.selectVideoClip()
                        selectedVcIndex = i
//                        print("tc B")
                        
                        //test 2 > scroll timeline to selected vc
                        var totalPFW = 0.0
                        for i in 0...selectedVcIndex {
                            totalPFW = totalPFW + vcList[i].pFrameWidth
                        }
                        let w = totalPFW - vcList[selectedVcIndex].pFrameWidth
                        let offX = viewWidth/2
                        let currentX = timelineScrollView.contentOffset.x + offX
                        print("tc B: \(currentX), \(totalPFW), \(w)")
                        
                        if(currentX > totalPFW) {
                            let desiredOffset = CGPoint(x: -offX + totalPFW - 1.0, y: 0)
                            timelineScrollView.setContentOffset(desiredOffset, animated: true)
                        } else {
                            if(currentX > w) {

                            } else {
                                let desiredOffset = CGPoint(x: -offX + w, y: 0)
                                timelineScrollView.setContentOffset(desiredOffset, animated: true)
                            }
                        }
                    }
                } else {
                    vc.unselectVideoClip()
                    print("tc C")
                }
                
                i += 1
            }
            
            refreshVcBtnUIChange()
        }
    }
    
    @objc func onSCFrameClicked(gesture: UITapGestureRecognizer) {
        print("sc frame clicked, \(UIScreen.main.scale)")
        
        if(selectedVcIndex > -1) {
            selectedVcIndex = -1
            for vc in vcList {
                vc.unselectVideoClip()
            }
            
            refreshVcBtnUIChange()
        }
        //unselect audio
        if(!audioClipList.isEmpty) {
            audioScrollBase.isHidden = true
            audioClipList[0].unselectAudioClip()
            selectedAcIndex = -1
        }
        refreshAcBtnUIChange()
        
        if let tappedView = gesture.view {
            var i = 0
            
            selectedScIndex = -1
            
            for sc in scList {
                if sc.pFrame == tappedView {
                    if(sc.isScSelected) {
                        sc.unselectSubtitleClip()
                    } else {
                        sc.selectSubtitleClip()
                        selectedScIndex = i
                    }
                } else {
                    sc.unselectSubtitleClip()
                    print("sc C")
                }
                
                i += 1
            }
            
            refreshScBtnUIChange()
        }
    }
    
    @objc func onBackScClicked(gesture: UITapGestureRecognizer) {
        if(!scList.isEmpty) {
            for sc in scList {
                sc.unselectSubtitleClip()
            }
            selectedScIndex = -1
        }
        refreshScBtnUIChange()
    }
    @objc func onScVPhotoClicked(gesture: UITapGestureRecognizer) {
        removeSubtitleClip(i: selectedScIndex)
    }
    @objc func onSCPhotoClicked(gesture: UITapGestureRecognizer) {
        //edit sc text
        aTextBox.text = scList[selectedScIndex].subString
        setFirstResponder(textView: aTextBox)
    }
    
    //test > initialization state => !!already exist in layoutsubview
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            preloadAudioTimeObserver()
        }
        isInitialized = true
    }
    
    //test > audio addtimeobserver when initialized
    //mute it
    func preloadAudioTimeObserver() {
        let videoURL2 = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
        let url2 = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
//        let url2 = URL(fileURLWithPath: "file:///var/mobile/Media/DCIM/103APPLE/IMG_3836.MOV")
        let asset2 = AVAsset(url: url2)
        let item2 = AVPlayerItem(asset: asset2)
        player2 = AVPlayer(playerItem: item2)
//        player2 = AVPlayer()
        let layer2 = AVPlayerLayer(player: player2)
        layer2.frame = audioContainer.bounds
        audioContainer.layer.addSublayer(layer2)
        
        let d = getDuration(ofVideoAt: url2)
        print("audio d: \(d)")
        
        let seekTime = CMTime(seconds: 30.0, preferredTimescale: CMTimeScale(1000)) //1000
        item2.forwardPlaybackEndTime = seekTime
        addTimeObserverAudio2()
        
        //test > detect when audio finish playing => stop video player too
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
        
        //mute audio
        player2.volume = 0.0
    }
    
    func preloadVideo(videoUrl: URL) {
//        let asset = AVAsset(url: videoUrl)
//        let item = AVPlayerItem(asset: asset)
//        itemList.append(item)

//        player = AVPlayer(playerItem: itemList[0])
        player = AVPlayer()
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = videoContainer.bounds
        playerView.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerView)
        playerLayer = playerView
        
        addTimeObserverVideo()
    }
    
    func preloadVideo(strVUrl: String) {
        print("audio v: \(totalVDuration)")
//        let asset = AVAsset(url: videoUrl)
//        let item = AVPlayerItem(asset: asset)
//        itemList.append(item)

//        player = AVPlayer(playerItem: itemList[0])
        player = AVPlayer()
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = videoContainer.bounds
        playerView.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerView)
        playerLayer = playerView
        
        addTimeObserverVideo()
        
        addVideoClip(strVUrl: strVUrl)
    }
    
    //test > subtitle list
    func addSubtitleClip(subtitleStr: String, tStart: CGFloat, tEnd: CGFloat, isIndex: Bool, xIndex: Int) {
        let a = SubtitleClip()
        a.subString = subtitleStr
        
        var i = 0
        if(isIndex) {
            i = xIndex
            scList.insert(a, at: i)
        } else {
            scList.append(a)
            i = scList.count - 1
        }
        
        a.t_s = tStart
        a.t_e = tEnd
        
        timelineScrollView.addSubview(scList[i].tBox)
        scList[i].tBox.translatesAutoresizingMaskIntoConstraints = false
        scList[i].tBox.topAnchor.constraint(equalTo: audioScrollFrame.bottomAnchor, constant: 15).isActive = true
        scList[i].tBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        scList[i].tBoxWidthCons = scList[i].tBox.widthAnchor.constraint(equalToConstant: 0) //videoFrameWidth
//        scList[i].tBoxWidthCons?.isActive = true
        scList[i].tBox.isUserInteractionEnabled = false //to prevent click conflict with tframe for vc select
//        scList[i].tBox.backgroundColor = .ddmDarkColor
        
        timelineScrollView.addSubview(scList[i].pFrame)
        scList[i].pFrame.translatesAutoresizingMaskIntoConstraints = false
        scList[i].pFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true //50
        scList[i].pFrame.centerYAnchor.constraint(equalTo: scList[i].tBox.centerYAnchor, constant: 0).isActive = true //ori
        scList[i].pFrameLeadingCons = scList[i].pFrame.leadingAnchor.constraint(equalTo: scList[i].tBox.leadingAnchor, constant: 0)
        scList[i].pFrameLeadingCons?.isActive = true
        scList[i].pFrameTrailingCons = scList[i].pFrame.trailingAnchor.constraint(equalTo: scList[i].tBox.trailingAnchor, constant: 0)
        scList[i].pFrameTrailingCons?.isActive = true
        scList[i].pFrame.clipsToBounds = true
        scList[i].pFrame.layer.cornerRadius = 10
//        scList[i].pFrame.backgroundColor = .ddmDarkColor
//        scList[i].pFrame.backgroundColor = .ddmAccentColor
        scList[i].pFrame.backgroundColor = .electricBlueColor
        scList[i].pFrame.isUserInteractionEnabled = true
        scList[i].pFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSCFrameClicked)))
        
//        let scText = UILabel()
        scList[i].scText.textAlignment = .left
        scList[i].scText.textColor = .ddmBlackOverlayColor
        scList[i].scText.font = .systemFont(ofSize: 10) //15
//        panel.addSubview(scList[i].scText)
        timelineScrollView.addSubview(scList[i].scText)
        scList[i].scText.clipsToBounds = true
        scList[i].scText.translatesAutoresizingMaskIntoConstraints = false
        scList[i].scText.centerYAnchor.constraint(equalTo: scList[i].pFrame.centerYAnchor).isActive = true //5
        scList[i].scText.leadingAnchor.constraint(equalTo: scList[i].pFrame.leadingAnchor, constant: 5).isActive = true
        scList[i].scText.trailingAnchor.constraint(equalTo: scList[i].pFrame.trailingAnchor, constant: -5).isActive = true
        scList[i].scText.text = subtitleStr
        
        let aBox = UIView()
        timelineScrollView.addSubview(aBox)
//        aBox.backgroundColor = .ddmDarkColor
        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.topAnchor.constraint(equalTo: scList[i].pFrame.topAnchor, constant: 5).isActive = true
        aBox.bottomAnchor.constraint(equalTo: scList[i].pFrame.bottomAnchor, constant: -5).isActive = true
        aBox.leadingAnchor.constraint(equalTo: scList[i].pFrame.leadingAnchor).isActive = true
        aBox.widthAnchor.constraint(equalToConstant: 1).isActive = true
        aBox.layer.cornerRadius = 0
        
        let zBox = UIView()
        timelineScrollView.addSubview(zBox)
//        zBox.backgroundColor = .ddmDarkColor
        zBox.backgroundColor = .ddmBlackOverlayColor
        zBox.translatesAutoresizingMaskIntoConstraints = false
        zBox.topAnchor.constraint(equalTo: scList[i].pFrame.topAnchor, constant: 5).isActive = true
        zBox.bottomAnchor.constraint(equalTo: scList[i].pFrame.bottomAnchor, constant: -5).isActive = true
        zBox.trailingAnchor.constraint(equalTo: scList[i].pFrame.trailingAnchor).isActive = true
        zBox.widthAnchor.constraint(equalToConstant: 1).isActive = true
        zBox.layer.cornerRadius = 0
        
        scList[i].pBase.backgroundColor = .ddmGoldenYellowColor
        timelineScrollView.insertSubview(scList[i].pBase, belowSubview: scList[i].pFrame)
//        timelineScrollView.insertSubview(scList[i].pBase, belowSubview: scList[i].tBox)
        scList[i].pBase.translatesAutoresizingMaskIntoConstraints = false
        scList[i].pBase.heightAnchor.constraint(equalToConstant: 54).isActive = true //50
        scList[i].pBase.leadingAnchor.constraint(equalTo: scList[i].pFrame.leadingAnchor, constant: -20).isActive = true
        scList[i].pBase.trailingAnchor.constraint(equalTo: scList[i].pFrame.trailingAnchor, constant: 20).isActive = true
        scList[i].pBase.centerYAnchor.constraint(equalTo: scList[i].pFrame.centerYAnchor, constant: 0).isActive = true
        scList[i].pBase.isHidden = true
        scList[i].pBase.layer.cornerRadius = 10
        
        bSection.addSubview(scList[i].sAView)
        scList[i].sAView.translatesAutoresizingMaskIntoConstraints = false
//        scList[i].sAView.trailingAnchor.constraint(equalTo: scList[i].tBox.leadingAnchor, constant: 1).isActive = true
        scList[i].sAView.trailingAnchor.constraint(equalTo: scList[i].pFrame.leadingAnchor, constant: 1).isActive = true
        scList[i].sAView.bottomAnchor.constraint(equalTo: scList[i].pBase.bottomAnchor, constant: 0).isActive = true
        scList[i].sAView.topAnchor.constraint(equalTo: scList[i].pBase.topAnchor, constant: 0).isActive = true
        scList[i].sAView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        scList[i].sAView.layer.cornerRadius = 5 //0
        scList[i].sAView.backgroundColor = .ddmGoldenYellowColor
        let sAPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onSubSAViewPanGesture))
        scList[i].sAView.addGestureRecognizer(sAPanGesture)
        scList[i].sAView.isHidden = true
        
        bSection.addSubview(scList[i].sBView)
        scList[i].sBView.translatesAutoresizingMaskIntoConstraints = false
//        scList[i].sBView.leadingAnchor.constraint(equalTo: scList[i].tBox.trailingAnchor, constant: -1).isActive = true
        scList[i].sBView.leadingAnchor.constraint(equalTo: scList[i].pFrame.trailingAnchor, constant: -1).isActive = true
        scList[i].sBView.bottomAnchor.constraint(equalTo: scList[i].pBase.bottomAnchor, constant: 0).isActive = true
        scList[i].sBView.topAnchor.constraint(equalTo: scList[i].pBase.topAnchor, constant: 0).isActive = true
        scList[i].sBView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        scList[i].sBView.layer.cornerRadius = 5 //0
        scList[i].sBView.backgroundColor = .ddmGoldenYellowColor
        let sBPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onSubSBViewPanGesture))
        scList[i].sBView.addGestureRecognizer(sBPanGesture)
        scList[i].sBView.isHidden = true
        
        let sABox = UIView()
        scList[i].sAView.addSubview(sABox)
        sABox.backgroundColor = .ddmDarkColor
//        sABox.backgroundColor = .ddmBlackOverlayColor
        sABox.translatesAutoresizingMaskIntoConstraints = false
        sABox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sABox.centerXAnchor.constraint(equalTo: scList[i].sAView.centerXAnchor, constant: 0).isActive = true
        sABox.centerYAnchor.constraint(equalTo: scList[i].sAView.centerYAnchor, constant: 0).isActive = true
        sABox.widthAnchor.constraint(equalToConstant: 2).isActive = true
        sABox.layer.cornerRadius = 1
        
        let sBBox = UIView()
        scList[i].sBView.addSubview(sBBox)
        sBBox.backgroundColor = .ddmDarkColor
//        sBBox.backgroundColor = .ddmBlackOverlayColor
        sBBox.translatesAutoresizingMaskIntoConstraints = false
        sBBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sBBox.centerXAnchor.constraint(equalTo: scList[i].sBView.centerXAnchor, constant: 0).isActive = true
        sBBox.centerYAnchor.constraint(equalTo: scList[i].sBView.centerYAnchor, constant: 0).isActive = true
        sBBox.widthAnchor.constraint(equalToConstant: 2).isActive = true
        sBBox.layer.cornerRadius = 1
        
        let xLead = (a.t_s * totalVPFrameWidth)/totalVDuration
        let xTrail = (a.t_e * totalVPFrameWidth)/totalVDuration
        print("videditor subtitle: \(a.t_s), \(tStart), \(xLead), \(xTrail), \(totalVPFrameWidth)")
        scList[i].tBoxLeadingCons = scList[i].tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: xLead)
        scList[i].tBoxLeadingCons?.isActive = true
        scList[i].tBoxTrailingCons = scList[i].tBox.trailingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: xTrail)
        scList[i].tBoxTrailingCons?.isActive = true
    }
    
    func removeSubtitleClip(i: Int){
        
        if(i > -1) {
            scList[i].tBox.removeFromSuperview()
            scList[i].tcFrame.removeFromSuperview()
            scList[i].pFrame.removeFromSuperview()
            scList[i].pBase.removeFromSuperview()
            scList[i].sAView.removeFromSuperview()
            scList[i].sBView.removeFromSuperview()
            
            scList.remove(at: i)
            
            selectedScIndex = -1
            refreshScBtnUIChange()
            
            showHideSubtitle()
        }
    }
    
    @objc func onSubSAViewPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            let b = scList[selectedScIndex]
            b.currentTboxLeadingCons = b.tBoxLeadingCons!.constant
        }
        else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            let b = scList[selectedScIndex]
            var xP = b.currentTboxLeadingCons + x
            
            if(selectedScIndex > 0) {
                let c = scList[selectedScIndex - 1]
                let lP = c.tBoxTrailingCons!.constant
                
                if(xP <= lP) {
                    xP = lP
                }
            } else {
                if(xP <= 0) {
                    xP = 0
                }
            }
            b.tBoxLeadingCons?.constant = xP
            
            b.t_s = (xP * totalVDuration)/totalVPFrameWidth //test
            print("subA \(b.t_s)")
        }
        else if(gesture.state == .ended){
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            let b = scList[selectedScIndex]
            var xP = b.currentTboxLeadingCons + x

            if(selectedScIndex > 0) {
                let c = scList[selectedScIndex - 1]
                let lP = c.tBoxTrailingCons!.constant
                
                if(xP <= lP) {
                    xP = lP
                }
            } else {
                if(xP <= 0) {
                    xP = 0
                }
            }
            b.tBoxLeadingCons?.constant = xP
            
            b.t_s = (xP * totalVDuration)/totalVPFrameWidth //test
            print("subA \(b.t_s)")
        }
    }
    @objc func onSubSBViewPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            let b = scList[selectedScIndex]
            b.currentTboxTrailingCons = b.tBoxTrailingCons!.constant
        }
        else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            let b = scList[selectedScIndex]
            var xP = b.currentTboxTrailingCons + x
            
            if(selectedScIndex + 1 < scList.count) {
                let c = scList[selectedScIndex + 1]
                let lP = c.tBoxLeadingCons!.constant
                
                if(xP >= lP) {
                    xP = lP
                }
//                b.tBoxTrailingCons?.constant = xP
            } else {
                if(xP >= totalVPFrameWidth) {
                    xP = totalVPFrameWidth
                }
//                b.tBoxTrailingCons?.constant = xP
            }
            b.tBoxTrailingCons?.constant = xP
            
            b.t_e = (xP * totalVDuration)/totalVPFrameWidth //test
            print("subB \(b.t_e)")
        }
        else if(gesture.state == .ended){
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            let b = scList[selectedScIndex]
            var xP = b.currentTboxTrailingCons + x
            
            if(selectedScIndex + 1 < scList.count) {
                let c = scList[selectedScIndex + 1]
                let lP = c.tBoxLeadingCons!.constant
//                print("subB \(lP)")
                
                if(xP >= lP) {
                    xP = lP
                }
//                b.tBoxTrailingCons?.constant = xP
            } else {
                if(xP >= totalVPFrameWidth) {
                    xP = totalVPFrameWidth
                }
//                b.tBoxTrailingCons?.constant = xP
            }
            b.tBoxTrailingCons?.constant = xP
            
            b.t_e = (xP * totalVDuration)/totalVPFrameWidth //test
            print("subB \(b.t_e)")
        }
    }
    
    //test > audio list
    func addAudioClip(strAUrl: String) {
        let a = AudioClip()
        
//        let audioUrl = URL(fileURLWithPath: strAUrl)
//        a.strAUrl = strAUrl
        
        let videoURL2 = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
        let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
        a.strAUrl = videoURL2
        
        audioClipList.append(a)
        
        //set up avplayer to play audio
        let asset = AVURLAsset(url: audioUrl)
        let item = AVPlayerItem(asset: asset)
        player2.replaceCurrentItem(with: item)
        
        let offset = viewWidth/2
        let desiredOffset = CGPoint(x: -offset, y: 0)
        timelineScrollView.setContentOffset(desiredOffset, animated: true)
        
        //test > shorten audio duration to fit video
        let seekTimeA = CMTime(seconds: totalVDuration, preferredTimescale: CMTimeScale(1000)) //1000
        if let a = player2.currentItem {
            a.forwardPlaybackEndTime = seekTimeA
        }
    }
    
    func removeAudioClip() {
        let videoURL2 = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
        let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
        
        //remove audio
        audioClipList.remove(at: audioClipList.count - 1)
        
        //reset to no audio added
        let asset = AVURLAsset(url: audioUrl)
        let item = AVPlayerItem(asset: asset)
        player2.replaceCurrentItem(with: item)
        
        let offset = viewWidth/2
        let desiredOffset = CGPoint(x: -offset, y: 0)
        timelineScrollView.setContentOffset(desiredOffset, animated: true)
        
//        let seekTime = CMTime(seconds: 30.0, preferredTimescale: CMTimeScale(1000)) //1000
        let seekTime = CMTime(seconds: totalVDuration, preferredTimescale: CMTimeScale(1000)) //1000
        item.forwardPlaybackEndTime = seekTime
    }
    
    //test > videoclip list
    var totalVDuration = 0.0
    var totalVPFrameWidth = 0.0
    
    func addVideoClip(strVUrl: String) {
        addVideoClip(strVUrl: strVUrl, isResized: false, tStart: 0.0, tEnd: 0.0, isIndex: false, xIndex: 0, isToOffset: true)
    }
    
    func addVideoClip(strVUrl: String, index: Int, toOffset: Bool) {
        addVideoClip(strVUrl: strVUrl, isResized: false, tStart: 0.0, tEnd: 0.0, isIndex: true, xIndex: index, isToOffset: toOffset)
    }
    
    func addVideoClip(strVUrl: String, isResized: Bool, tStart: CGFloat, tEnd: CGFloat, isIndex: Bool, xIndex: Int, isToOffset: Bool) {
        
        let a = VideoClip()
        
        let videoUrl = URL(fileURLWithPath: strVUrl)
//        let videoUrl = getOverlayVideoOutputURL()
//        let videoUrl = getVideoOutputURL()
        a.strVUrl = strVUrl
        
        var i = 0
        if(isIndex) {
            i = xIndex
            vcList.insert(a, at: i)
        } else {
            vcList.append(a)
            i = vcList.count - 1
        }
        let d = getDuration(ofVideoAt: videoUrl)
        a.t0_s = 0.0
        a.t0_e = d
        a.d = d
        
        if(isResized) {
            a.t_s = tStart
            a.t_e = tEnd
        } else {
            a.t_s = 0.0
            a.t_e = d
        }

        //set up avplayer to show video
        let asset = AVURLAsset(url: videoUrl)
        let item = AVPlayerItem(asset: asset)
        a.playerItem = item
        player.replaceCurrentItem(with: item)
        
        //test
        lastPlayingVcIndex = i
        
        //set up UI for timeline video frame scrollview
        timelineScrollView.addSubview(vcList[i].tBox)
        vcList[i].tBox.translatesAutoresizingMaskIntoConstraints = false
        vcList[i].tBox.topAnchor.constraint(equalTo: timelineScrollView.topAnchor, constant: 50).isActive = true
        vcList[i].tBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        vcList[i].tBoxWidthCons = vcList[i].tBox.widthAnchor.constraint(equalToConstant: 0) //videoFrameWidth
        vcList[i].tBoxWidthCons?.isActive = true
        vcList[i].tBox.isUserInteractionEnabled = false //to prevent click conflict with tframe for vc select
        
        //test > indicator for reference purpose only
//        let indBox = UIView()
//        timelineScrollView.addSubview(indBox)
//        indBox.backgroundColor = .yellow
//        indBox.translatesAutoresizingMaskIntoConstraints = false
//        let c = Double(i) * 10.0 + 10.0
//        indBox.topAnchor.constraint(equalTo: vcList[i].tBox.bottomAnchor, constant: c).isActive = true
//        indBox.leadingAnchor.constraint(equalTo: vcList[i].tBox.leadingAnchor).isActive = true
//        indBox.trailingAnchor.constraint(equalTo: vcList[i].tBox.trailingAnchor).isActive = true
//        indBox.heightAnchor.constraint(equalToConstant: 4).isActive = true
//        indBox.layer.cornerRadius = 0
        
        timelineScrollView.addSubview(vcList[i].pFrame)
        vcList[i].pFrame.translatesAutoresizingMaskIntoConstraints = false
        vcList[i].pFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true //50
        vcList[i].pFrame.centerYAnchor.constraint(equalTo: vcList[i].tBox.centerYAnchor, constant: 0).isActive = true //ori
        vcList[i].pFrameLeadingCons = vcList[i].pFrame.leadingAnchor.constraint(equalTo: vcList[i].tBox.leadingAnchor, constant: 0)
        vcList[i].pFrameLeadingCons?.isActive = true
        vcList[i].pFrameTrailingCons = vcList[i].pFrame.trailingAnchor.constraint(equalTo: vcList[i].tBox.trailingAnchor, constant: 0)
        vcList[i].pFrameTrailingCons?.isActive = true
        vcList[i].pFrame.clipsToBounds = true
        vcList[i].pFrame.layer.cornerRadius = 10
        vcList[i].pFrame.isUserInteractionEnabled = true
        vcList[i].pFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTCFrameClicked)))
        
        let aBox = UIView()
        timelineScrollView.addSubview(aBox)
//        aBox.backgroundColor = .ddmDarkColor
        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.topAnchor.constraint(equalTo: vcList[i].pFrame.topAnchor, constant: 5).isActive = true
        aBox.bottomAnchor.constraint(equalTo: vcList[i].pFrame.bottomAnchor, constant: -5).isActive = true
        aBox.leadingAnchor.constraint(equalTo: vcList[i].pFrame.leadingAnchor).isActive = true
        aBox.widthAnchor.constraint(equalToConstant: 1).isActive = true
        aBox.layer.cornerRadius = 0
        
        let zBox = UIView()
        timelineScrollView.addSubview(zBox)
//        zBox.backgroundColor = .ddmDarkColor
        zBox.backgroundColor = .ddmBlackOverlayColor
        zBox.translatesAutoresizingMaskIntoConstraints = false
        zBox.topAnchor.constraint(equalTo: vcList[i].pFrame.topAnchor, constant: 5).isActive = true
        zBox.bottomAnchor.constraint(equalTo: vcList[i].pFrame.bottomAnchor, constant: -5).isActive = true
        zBox.trailingAnchor.constraint(equalTo: vcList[i].pFrame.trailingAnchor).isActive = true
        zBox.widthAnchor.constraint(equalToConstant: 1).isActive = true
        zBox.layer.cornerRadius = 0
        
//        vcList[i].pBase.backgroundColor = .white
        vcList[i].pBase.backgroundColor = .ddmGoldenYellowColor
        timelineScrollView.insertSubview(vcList[i].pBase, belowSubview: vcList[i].pFrame)
        vcList[i].pBase.translatesAutoresizingMaskIntoConstraints = false
        vcList[i].pBase.heightAnchor.constraint(equalToConstant: 54).isActive = true //50
        vcList[i].pBase.leadingAnchor.constraint(equalTo: vcList[i].pFrame.leadingAnchor, constant: -20).isActive = true
        vcList[i].pBase.trailingAnchor.constraint(equalTo: vcList[i].pFrame.trailingAnchor, constant: 20).isActive = true
        vcList[i].pBase.centerYAnchor.constraint(equalTo: vcList[i].pFrame.centerYAnchor, constant: 0).isActive = true
        vcList[i].pBase.isHidden = true
        vcList[i].pBase.layer.cornerRadius = 10
        
        vcList[i].pFrame.addSubview(vcList[i].tcFrame)
//        vcList[i].tcFrame.backgroundColor = .green //ddmDarkColor
        vcList[i].tcFrame.backgroundColor = .ddmDarkColor
        vcList[i].tcFrame.translatesAutoresizingMaskIntoConstraints = false
        vcList[i].tcFrame.centerYAnchor.constraint(equalTo: vcList[i].tBox.centerYAnchor, constant: 0).isActive = true //ori
        vcList[i].tcFrame.leadingAnchor.constraint(equalTo: vcList[i].tBox.leadingAnchor, constant: 0).isActive = true
        vcList[i].tcFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true
        vcList[i].tcFrame.trailingAnchor.constraint(equalTo: vcList[i].tBox.trailingAnchor, constant: 0).isActive = true
        
//        let tADivider = UIView()
//        bSection.addSubview(tADivider)
//        tADivider.backgroundColor = .white
//        tADivider.translatesAutoresizingMaskIntoConstraints = false
//        tADivider.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        tADivider.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        tADivider.centerXAnchor.constraint(equalTo: vcList[i].pFrame.leadingAnchor, constant: 0).isActive = true
//        tADivider.centerYAnchor.constraint(equalTo: vcList[i].pFrame.centerYAnchor, constant: 0).isActive = true
//        tADivider.layer.cornerRadius = 2
//
//        let tADDot = UIView()
//        tADivider.addSubview(tADDot)
//        tADDot.backgroundColor = .ddmDarkColor
//        tADDot.translatesAutoresizingMaskIntoConstraints = false
//        tADDot.heightAnchor.constraint(equalToConstant: 4).isActive = true
//        tADDot.widthAnchor.constraint(equalToConstant: 4).isActive = true
//        tADDot.centerXAnchor.constraint(equalTo: tADivider.centerXAnchor, constant: 0).isActive = true
//        tADDot.centerYAnchor.constraint(equalTo: tADivider.centerYAnchor, constant: 0).isActive = true
//        tADDot.layer.cornerRadius = 2
        
        bSection.addSubview(vcList[i].sAView)
        vcList[i].sAView.translatesAutoresizingMaskIntoConstraints = false
//        vcList[i].sAView.trailingAnchor.constraint(equalTo: vcList[i].pFrame.leadingAnchor, constant: 0).isActive = true
        vcList[i].sAView.trailingAnchor.constraint(equalTo: vcList[i].pFrame.leadingAnchor, constant: 1).isActive = true
        vcList[i].sAView.bottomAnchor.constraint(equalTo: vcList[i].pBase.bottomAnchor, constant: 0).isActive = true
        vcList[i].sAView.topAnchor.constraint(equalTo: vcList[i].pBase.topAnchor, constant: 0).isActive = true
//        vcList[i].sAView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        vcList[i].sAView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        vcList[i].sAView.layer.cornerRadius = 5 //0
//        vcList[i].sAView.backgroundColor = .white
        vcList[i].sAView.backgroundColor = .ddmGoldenYellowColor
        let sAPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onSAViewPanGesture))
        vcList[i].sAView.addGestureRecognizer(sAPanGesture)
        vcList[i].sAView.isHidden = true
        
        bSection.addSubview(vcList[i].sBView)
        vcList[i].sBView.translatesAutoresizingMaskIntoConstraints = false
//        vcList[i].sBView.leadingAnchor.constraint(equalTo: vcList[i].pFrame.trailingAnchor, constant: 0).isActive = true
        vcList[i].sBView.leadingAnchor.constraint(equalTo: vcList[i].pFrame.trailingAnchor, constant: -1).isActive = true
        vcList[i].sBView.bottomAnchor.constraint(equalTo: vcList[i].pBase.bottomAnchor, constant: 0).isActive = true
        vcList[i].sBView.topAnchor.constraint(equalTo: vcList[i].pBase.topAnchor, constant: 0).isActive = true
//        vcList[i].sBView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        vcList[i].sBView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        vcList[i].sBView.layer.cornerRadius = 5 //0
//        vcList[i].sBView.backgroundColor = .white
        vcList[i].sBView.backgroundColor = .ddmGoldenYellowColor
        let sBPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onSBViewPanGesture))
        vcList[i].sBView.addGestureRecognizer(sBPanGesture)
        vcList[i].sBView.isHidden = true
        
        let sABox = UIView()
        vcList[i].sAView.addSubview(sABox)
        sABox.backgroundColor = .ddmDarkColor
//        sABox.backgroundColor = .ddmBlackOverlayColor
        sABox.translatesAutoresizingMaskIntoConstraints = false
        sABox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sABox.centerXAnchor.constraint(equalTo: vcList[i].sAView.centerXAnchor, constant: 0).isActive = true
        sABox.centerYAnchor.constraint(equalTo: vcList[i].sAView.centerYAnchor, constant: 0).isActive = true
        sABox.widthAnchor.constraint(equalToConstant: 2).isActive = true
        sABox.layer.cornerRadius = 1
        
        let sBBox = UIView()
        vcList[i].sBView.addSubview(sBBox)
        sBBox.backgroundColor = .ddmDarkColor
//        sBBox.backgroundColor = .ddmBlackOverlayColor
        sBBox.translatesAutoresizingMaskIntoConstraints = false
        sBBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sBBox.centerXAnchor.constraint(equalTo: vcList[i].sBView.centerXAnchor, constant: 0).isActive = true
        sBBox.centerYAnchor.constraint(equalTo: vcList[i].sBView.centerYAnchor, constant: 0).isActive = true
        sBBox.widthAnchor.constraint(equalToConstant: 2).isActive = true
        sBBox.layer.cornerRadius = 1
        
        //test > add video frames UI
        let nFrames = Int(ceil(d)) //round up number of frames to integer
        for y in 0..<nFrames {
            let tFrame = UIImageView()
            tFrame.contentMode = .scaleAspectFill
            tFrame.layer.masksToBounds = true
            vcList[i].tcFrame.addSubview(tFrame)
            tFrame.translatesAutoresizingMaskIntoConstraints = false
            tFrame.topAnchor.constraint(equalTo: vcList[i].tcFrame.topAnchor).isActive = true
            let x = CGFloat(y) * 50.0
            tFrame.leadingAnchor.constraint(equalTo: vcList[i].tcFrame.leadingAnchor, constant: x).isActive = true
            tFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true //ori 90
            tFrame.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        //update playable video length
        let dx = d/CGFloat(nFrames)*(CGFloat(nFrames) * 50.0)
        vcList[i].p0FrameWidth = dx
        vcList[i].tBoxWidthCons?.constant = dx //to be examined
        
        let xLead = (vcList[i].t_s * vcList[i].p0FrameWidth)/vcList[i].d
        let xTrail = (vcList[i].t_e * vcList[i].p0FrameWidth)/vcList[i].d - vcList[i].p0FrameWidth
        vcList[i].pFrameLeadingCons?.constant = xLead
        vcList[i].pFrameTrailingCons?.constant = xTrail
        vcList[i].pFrameWidth = dx - xLead + xTrail
        print("xlead, xtrail: \(xLead), \(xTrail), \(vcList[i].pFrameWidth)")
        //test
        if(vcList.count > 1) {
            //test > add video clip to last clip
            if(i - 1 >= 0) {
                let z = vcList[i - 1]
                z.currentPFrameTrailingCons = z.pFrameTrailingCons!.constant
                vcList[i].tBoxLeadingCons = vcList[i].tBox.leadingAnchor.constraint(equalTo: z.tBox.trailingAnchor, constant: z.currentPFrameTrailingCons - xLead)
            } else {
                vcList[i].tBoxLeadingCons = vcList[i].tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: 0 - xLead)
            }

            //test > shift vc[i+1] backwards
            if(i < vcList.count - 1) {
                print("+1: \(i)")
                vcList[i].currentPFrameTrailingCons = vcList[i].pFrameTrailingCons!.constant
                vcList[i + 1].tBoxLeadingCons?.isActive = false
                vcList[i + 1].tBoxLeadingCons = vcList[i + 1].tBox.leadingAnchor.constraint(equalTo: vcList[i].tBox.trailingAnchor, constant: vcList[i].currentPFrameTrailingCons - 0)
                vcList[i + 1].tBoxLeadingCons?.isActive = true
            }
        } else {
            vcList[i].tBoxLeadingCons = vcList[i].tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: 0 - xLead)
        }
        vcList[i].tBoxLeadingCons?.isActive = true
        
        var totalPFrameWidth = 0.0
        var totalDuration = 0.0
        var totalX = 0.0
        var xI = 0
        for l in vcList {
            totalPFrameWidth = totalPFrameWidth + l.pFrameWidth
            totalDuration = totalDuration + (l.t_e - l.t_s)
            if(xI < i) {
                totalX = totalX + l.pFrameWidth
            }
            xI += 1
        }
        totalVPFrameWidth = totalPFrameWidth
        totalVDuration = totalDuration
        timelineScrollView.contentSize = CGSize(width: totalPFrameWidth, height: 50)
        
        let offset = viewWidth/2
        let ff = totalX
        let desiredOffset = CGPoint(x: -offset + ff, y: 0)
        if(isToOffset) {
            timelineScrollView.setContentOffset(desiredOffset, animated: true)
        }

        //test > extract video frames
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 200, height: 200) //small size to reduce memory
        
        var times = [CMTime]()
        for y in 0..<nFrames { //assuming 1 frame = 1 sec => to be amended
            times.append(CMTimeMake(value: Int64(y), timescale: 1))
        }
        
        let timeValues = times.map { NSValue(time: $0) }
        generator.generateCGImagesAsynchronously(forTimes: timeValues) { (time, image, actualTime, result, error) in
            if let image = image {
                self.vcList[i].fImages.append(image)
                print("getvideoframes success: \(self.vcList[i].fImages.count), \(time.seconds), \(time.value)")

                //wait until all images are extracted
                if(self.vcList[i].fImages.count == times.count) {
                    DispatchQueue.main.async {
                        self.asyncRefreshVideoFrameImages(i: i)
                    }
                }
            } else {
//                print("Error generating frame at time \(time): \(error)")
            }
        }
        
        //test > shorten audio duration to fit video
        let seekTimeA = CMTime(seconds: totalVDuration, preferredTimescale: CMTimeScale(1000)) //1000
        if let a = player2.currentItem {
            a.forwardPlaybackEndTime = seekTimeA
        }
        
        timeDurationText.text = convertSecondsToMinutesAndSeconds(seconds: totalVDuration)
        
        //test > refresh timescale
        initTimeScale2()
        
        //test > change audioscrollframe size
        audioScrollFrame.isHidden = false
        
        audioScrollLeadingCons?.isActive = false
        audioScrollTrailingCons?.isActive = false
        audioScrollLeadingCons = audioScrollFrame.leadingAnchor.constraint(equalTo: vcList[0].pFrame.leadingAnchor)
        audioScrollTrailingCons = audioScrollFrame.trailingAnchor.constraint(equalTo: vcList[vcList.count - 1].pFrame.trailingAnchor)
        audioScrollLeadingCons?.isActive = true
        audioScrollTrailingCons?.isActive = true
    }
    
    func removeVideoClip(i: Int){
        
        if(i > -1) {
            vcList[i].tBox.removeFromSuperview()
            vcList[i].tcFrame.removeFromSuperview()
            vcList[i].pFrame.removeFromSuperview()
            vcList[i].pBase.removeFromSuperview()
            vcList[i].sAView.removeFromSuperview()
            vcList[i].sBView.removeFromSuperview()
            
            vcList.remove(at: i)
            
            //test > shift vc[i+1] backwards
            if(vcList.count > 1) {
                if(i >= 1) {
                    print("remove A \(i)")
                    if(i < vcList.count) {
                        let z = vcList[i - 1]
                        vcList[i].tBoxLeadingCons?.isActive = false
                        let xLead = vcList[i].pFrameLeadingCons!.constant
                        z.currentPFrameTrailingCons = z.pFrameTrailingCons!.constant
                        vcList[i].tBoxLeadingCons = vcList[i].tBox.leadingAnchor.constraint(equalTo: z.tBox.trailingAnchor, constant: z.currentPFrameTrailingCons - xLead)
                        vcList[i].tBoxLeadingCons?.isActive = true
                    }

                } else {
                    print("remove B \(i)")
                    let xLead = vcList[i].pFrameLeadingCons!.constant
                    vcList[i].tBoxLeadingCons?.isActive = false
                    vcList[i].tBoxLeadingCons = vcList[i].tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: 0 - xLead)
                    vcList[i].tBoxLeadingCons?.isActive = true
                }
            } else {
                if(i >= 1) {
                    print("remove C \(i)")
                    vcList[0].tBoxLeadingCons?.isActive = false
                    let xLead = vcList[0].pFrameLeadingCons!.constant
                    vcList[0].tBoxLeadingCons = vcList[0].tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: 0 - xLead)
                    vcList[0].tBoxLeadingCons?.isActive = true
                } else {
                    print("remove D \(i)")
                    
                    if(vcList.count > 0) {
                        vcList[0].tBoxLeadingCons?.isActive = false
                        let xLead = vcList[0].pFrameLeadingCons!.constant
                        vcList[0].tBoxLeadingCons = vcList[0].tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: 0 - xLead)
                        vcList[0].tBoxLeadingCons?.isActive = true
                    }
                }
            }

            //test > recompute size
            var totalPFrameWidth = 0.0
            var totalDuration = 0.0
            for l in vcList {
                totalPFrameWidth = totalPFrameWidth + l.pFrameWidth
                totalDuration = totalDuration + (l.t_e - l.t_s)
            }
            totalVPFrameWidth = totalPFrameWidth
            totalVDuration = totalDuration
            timelineScrollView.contentSize = CGSize(width: totalPFrameWidth, height: 50)
            
            //test > shorten audio duration to fit video
            let seekTimeA = CMTime(seconds: totalVDuration, preferredTimescale: CMTimeScale(1000)) //1000
            if let a = player2.currentItem {
                a.forwardPlaybackEndTime = seekTimeA
            }
            
            timeDurationText.text = convertSecondsToMinutesAndSeconds(seconds: totalVDuration)
            
            //test > refresh timescale
            initTimeScale2()
            
            //test > unselect
            selectedVcIndex = -1
            refreshVcBtnUIChange()
            
            //test > remove audio frame
            if(vcList.isEmpty) {
                audioScrollFrame.isHidden = true
            } else {
                audioScrollFrame.isHidden = false
                
                audioScrollLeadingCons?.isActive = false
                audioScrollTrailingCons?.isActive = false
                audioScrollLeadingCons = audioScrollFrame.leadingAnchor.constraint(equalTo: vcList[0].pFrame.leadingAnchor)
                audioScrollTrailingCons = audioScrollFrame.trailingAnchor.constraint(equalTo: vcList[vcList.count - 1].pFrame.trailingAnchor)
                audioScrollLeadingCons?.isActive = true
                audioScrollTrailingCons?.isActive = true
            }

        }
    }
    
    func cutVideoClipTime(i: Int, t_e: CGFloat) {
        vcList[i].currentPFrameTrailingCons = vcList[i].pFrameTrailingCons!.constant
        
        let xTrail = (t_e * vcList[i].p0FrameWidth)/vcList[i].d - vcList[i].p0FrameWidth
        vcList[i].pFrameTrailingCons?.constant = xTrail
        
        vcList[i].pFrameWidth = vcList[i].pFrameWidth - vcList[i].currentPFrameTrailingCons + xTrail
        
        vcList[i].t_e = t_e
        let seekTime = CMTime(seconds: vcList[i].t_e, preferredTimescale: CMTimeScale(1000)) //1000
        if let a = vcList[i].playerItem {
            a.forwardPlaybackEndTime = seekTime
        }
    }
    
    func asyncRefreshVideoFrameImages(i: Int) {
        let s = vcList[i].tcFrame.subviews
        for y in 0..<s.count {
            if let a = s[y] as? UIImageView {
                if(i < vcList[i].fImages.count) {
                    a.image = UIImage(cgImage: vcList[i].fImages[y])
                }
            }
        }
    }

    @objc func onSAViewPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            if(selectedVcIndex >= 0) {
                let b = vcList[selectedVcIndex]
                b.currentPFrameLeadingCons = b.pFrameLeadingCons!.constant
                b.currentTboxLeadingCons = b.tBoxLeadingCons!.constant
                
                //mm > for vc 2
                if(selectedVcIndex > 0) {
                    let m = vcList[0] //1st video clip
                    let n = vcList[selectedVcIndex - 1] //last video clip
                    m.currentTboxLeadingCons = m.tBoxLeadingCons!.constant
                    n.currentPFrameTrailingCons = n.pFrameTrailingCons!.constant
                    
                    b.tBoxLeadingCons?.isActive = false
                    var totalPFrameWidth = 0.0
                    for i in 0...selectedVcIndex-1 {
                        totalPFrameWidth = totalPFrameWidth + vcList[i].pFrameWidth
                    }
                    let s = totalPFrameWidth - b.currentPFrameLeadingCons
                    b.tBoxLeadingCons = b.tBox.leadingAnchor.constraint(equalTo: timelineScrollView.leadingAnchor, constant: s)
                    b.tBoxLeadingCons?.isActive = true
                }
            }
        }
        else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            if(selectedVcIndex >= 0) {
                let b = vcList[selectedVcIndex]
                var xP = b.currentPFrameLeadingCons + x
                if(xP <= 0) {
                    xP = 0
                }
                b.pFrameLeadingCons?.constant = xP
                
                //mm > for vc 2
                if(selectedVcIndex > 0) {
                    let m = vcList[0] //1st video clip
                    let sP = m.currentTboxLeadingCons + x
                    if(xP <= 0) {
                    } else {
                        m.tBoxLeadingCons?.constant = sP
                    }
                }
                
                //test > adjust video start time
                b.t_s = (xP * (b.d))/(b.p0FrameWidth) //test
                let seekTime = CMTime(seconds: b.t_s, preferredTimescale: CMTimeScale(1000))
                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)

            }
        }
        else if(gesture.state == .ended){
            let translation = gesture.translation(in: self)
            let x = translation.x

            if(selectedVcIndex >= 0) {
                let b = vcList[selectedVcIndex]
                var xP = b.currentPFrameLeadingCons + x
                var z = b.currentTboxLeadingCons - x
                if(xP <= 0) {
                    xP = 0
                    z = 0
                    b.pFrameWidth = b.pFrameWidth + b.currentPFrameLeadingCons
                } else {
                    b.pFrameWidth = b.pFrameWidth - x
                }
                b.pFrameLeadingCons?.constant = xP
                
                //mm > for vc 2
                if(selectedVcIndex > 0) {
                    let m = vcList[0] //1st video clip
                    let n = vcList[selectedVcIndex - 1] //last video clip
                    if(xP <= 0) {
                        z = 0 + n.currentPFrameTrailingCons
                    }
                    b.tBoxLeadingCons?.isActive = false
                    b.tBoxLeadingCons = b.tBox.leadingAnchor.constraint(equalTo: n.tBox.trailingAnchor, constant: z)
                    b.tBoxLeadingCons?.isActive = true
                    
                    m.tBoxLeadingCons?.constant = m.currentTboxLeadingCons
                } else {
                    b.tBoxLeadingCons?.constant = z
                }
                
                var totalPFrameWidth = 0.0
                var totalDuration = 0.0
                var i = 0
                var totalOffset = 0.0
                for l in vcList {
                    totalPFrameWidth = totalPFrameWidth + l.pFrameWidth
                    totalDuration = totalDuration + (l.t_e - l.t_s)
                    
                    if(i < selectedVcIndex) {
                        totalOffset = totalOffset + l.pFrameWidth
                    }
                    i += 1
                }
                totalVDuration = totalDuration
                totalVPFrameWidth = totalPFrameWidth
                timelineScrollView.contentSize = CGSize(width: totalPFrameWidth, height: 50)
                
                //test > scroll timeline to adjust
                let offset = viewWidth/2
                let desiredOffset = CGPoint(x: -offset + totalOffset, y: 0)
                timelineScrollView.setContentOffset(desiredOffset, animated: true)
                
                //test > adjust video start time
                b.t_s = (xP * (b.d))/(b.p0FrameWidth) //test
                let seekTime = CMTime(seconds: b.t_s, preferredTimescale: CMTimeScale(1000))
                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                
                //test > shorten audio duration to fit video
                let seekTimeA = CMTime(seconds: totalVDuration, preferredTimescale: CMTimeScale(1000)) //1000
                if let a = player2.currentItem {
                    a.forwardPlaybackEndTime = seekTimeA
                }
                
                timeDurationText.text = convertSecondsToMinutesAndSeconds(seconds: totalVDuration)
            }
        }
    }
    @objc func onSBViewPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            if(selectedVcIndex >= 0) {
                let b = vcList[selectedVcIndex]
                b.currentPFrameTrailingCons = b.pFrameTrailingCons!.constant
                
                if(selectedVcIndex + 1 < vcList.count) {
                    let c = vcList[selectedVcIndex + 1]
                    c.currentTboxLeadingCons = c.tBoxLeadingCons!.constant
                    c.currentPFrameLeadingCons = c.pFrameLeadingCons!.constant
                }
                
                //**test > clear endtime
                let eT = CMTime(seconds: b.d, preferredTimescale: CMTimeScale(1000)) //1000
                b.playerItem?.forwardPlaybackEndTime = eT
                //**
            }
        }
        else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            print("sB change \(selectedVcIndex), \(x)")
            
            if(selectedVcIndex >= 0) {
                let b = vcList[selectedVcIndex]
                var xP = b.currentPFrameTrailingCons + x
                if(xP >= 0) {
                    xP = 0
                }
                b.pFrameTrailingCons?.constant = xP
//                print("sB change \(xP)")
                
                if(selectedVcIndex + 1 < vcList.count) {
                    let c = vcList[selectedVcIndex + 1]
                    var sP = c.currentTboxLeadingCons + x
                    if(xP >= 0) {
                        sP = 0 - c.currentPFrameLeadingCons
                    }
                    c.tBoxLeadingCons?.constant = sP
                }
                
                //test > adjust video end time
                b.t_e = ((b.p0FrameWidth + xP) * (b.d))/(b.p0FrameWidth) //test
                let seekTime = CMTime(seconds: b.t_e, preferredTimescale: CMTimeScale(1000)) //1000
                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            }
        }
        else if(gesture.state == .ended){
            let translation = gesture.translation(in: self)
            let x = translation.x
            
            if(selectedVcIndex >= 0) {
                let b = vcList[selectedVcIndex]
                var xP = b.currentPFrameTrailingCons + x
                if(xP >= 0) {
                    xP = 0
                    b.pFrameWidth = b.pFrameWidth - b.currentPFrameTrailingCons
                } else {
                    b.pFrameWidth = b.pFrameWidth + x
                }
                b.pFrameTrailingCons?.constant = xP
                
                if(selectedVcIndex + 1 < vcList.count) {
                    let c = vcList[selectedVcIndex + 1]
                    var sP = c.currentTboxLeadingCons + x
                    if(xP >= 0) {
                        sP = 0 - c.currentPFrameLeadingCons
                    }
                    c.tBoxLeadingCons?.constant = sP
                }
                
                var totalPFrameWidth = 0.0
                var totalDuration = 0.0
                var i = 0
                var totalOffset = 0.0
                for l in vcList {
                    totalPFrameWidth = totalPFrameWidth + l.pFrameWidth
                    totalDuration = totalDuration + (l.t_e - l.t_s)
                    
                    if(i <= selectedVcIndex) {
                        totalOffset = totalOffset + l.pFrameWidth
                    }
                    i += 1
                }
                totalVDuration = totalDuration
                totalVPFrameWidth = totalPFrameWidth
                timelineScrollView.contentSize = CGSize(width: totalPFrameWidth, height: 50)
                
                //test > scroll timeline to adjust
                let offset = viewWidth/2
                let desiredOffset = CGPoint(x: -offset + totalOffset, y: 0)
                timelineScrollView.setContentOffset(desiredOffset, animated: true)
                
                //test > adjust video end time
                b.t_e = ((b.p0FrameWidth + xP) * (b.d))/(b.p0FrameWidth) //test
                let seekTime = CMTime(seconds: b.t_e, preferredTimescale: CMTimeScale(1000)) //1000
                player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                b.playerItem?.forwardPlaybackEndTime = seekTime
                
                //test > shorten audio duration to fit video
                let seekTimeA = CMTime(seconds: totalVDuration, preferredTimescale: CMTimeScale(1000)) //1000
                if let a = player2.currentItem {
                    a.forwardPlaybackEndTime = seekTimeA
                }
                
                timeDurationText.text = convertSecondsToMinutesAndSeconds(seconds: totalVDuration)
            }
        }
    }
    
    //test** => time duration formatter
    func convertSecondsToMinutesAndSeconds(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        let formattedDuration = formatter.string(from: seconds)
        return formattedDuration ?? ""
    }
    //**
    
    func showHideSubtitle() {
        //**test > subtitle
        for i in 0..<scList.count {
            if(currentATime < scList[i].t_s) {
                if(i != 0) {
                    let c = scList[i - 1]
                    if(currentATime < c.t_e) {
                        sText.text = c.subString
                        break
                    } else {
                        sText.text = ""
                        break
                    }
                } else {
                    sText.text = ""
                    break
                }
            } else {
                if(i == scList.count - 1) {
                    print("aaa")
                    if(currentATime < scList[i].t_e) {
                        sText.text = scList[i].subString
                        break
                    } else {
                        sText.text = ""
                        break
                    }
                }
            }
        }
        
        if(sText.text == "") {
            sBox.isHidden = true
        } else {
            sBox.isHidden = false
        }
        //**
    }
    
    //***test > add time observer for progresslistener
    var timeObserverTokenAudio: Any?
    var timeObserverTokenVideo: Any?
    var lastPlayingVcIndex = 0 //test
    var lastPlayingVcCT = 0.0 //test
    var currentATime = 0.0 //test
    func addTimeObserverAudio2() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
        timeObserverTokenAudio = player2?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
            [weak self] time in
            
            let currentT = time.seconds
            guard let s = self else {
                return
            }

            print("observe audioT:\(currentT), \(s.lastPlayingVcIndex)")
            
            //**test > subtitle
            for i in 0..<s.scList.count {
                if(currentT < s.scList[i].t_s) {
                    if(i != 0) {
                        let c = s.scList[i - 1]
                        if(currentT < c.t_e) {
                            s.sText.text = c.subString
                            break
                        } else {
                            s.sText.text = ""
                            break
                        }
                    } else {
                        s.sText.text = ""
                        break
                    }
                } else {
                    if(i == s.scList.count - 1) {
                        print("aaa")
                        if(currentT < s.scList[i].t_e) {
                            s.sText.text = s.scList[i].subString
                            break
                        } else {
                            s.sText.text = ""
                            break
                        }
                    }
                }
            }

            if(s.sText.text == "") {
                s.sBox.isHidden = true
            } else {
                s.sBox.isHidden = false
            }
            //**
            
            //test > show time play
//            s.currentATime = currentT
            s.timePlayText.text = s.convertSecondsToMinutesAndSeconds(seconds: currentT)
            s.bTimePlayText.text = s.timePlayText.text
            
            let newVal = CGFloat((currentT) / (s.totalVDuration)) * (s.viewWidth - 120)
            print("audio d x: \(newVal), \(s.totalVDuration)")
            self?.progressCenterXCons?.constant = newVal

            //test > video change when audio play simultaneously
            if(s.videoPlayStatus == "playing") {
                
                let x = CGFloat((currentT) / (s.totalVDuration)) * (s.totalVPFrameWidth)
                let offX = s.viewWidth/2
                let contentOffset = CGPoint(x: x - offX, y: 0)
                s.timelineScrollView.setContentOffset(contentOffset, animated: false)
                
                //test
                var cumT = 0.0
                for i in 0..<s.vcList.count {
                    cumT = cumT + (s.vcList[i].t_e - s.vcList[i].t_s)
                    if(currentT <= cumT) {
                        if(s.player.currentItem != s.vcList[i].playerItem) {
                            s.player.replaceCurrentItem(with: s.vcList[i].playerItem)
                            let seekTime = CMTime(seconds: s.vcList[i].t_s, preferredTimescale: CMTimeScale(1000))
                            s.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                            
                            //test > to prevent video stop while transition to next video
                            s.player?.play()
                            
                            //test > change speed
//                            if(i == 1) {
//                                s.player?.rate = 2.0
//                            } else {
//                                s.player?.rate = 1.0
//                            }
                            
                            //test > lastPlayingVcIndex
                            s.lastPlayingVcIndex = i
                        }

                        break
                    }
                }
            }
        }
    }
    func addTimeObserverVideo() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(1000))
        timeObserverTokenVideo = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
            [weak self] time in
            
            let currentT = time.seconds
            guard let s = self else {
                return
            }
            print("observe videoT:\(currentT)")
            
            print("audio v x: \(s.totalVDuration)")
        }
    }
    func removeTimeObserverAudio() {
        // Remove observer when view controller is deallocated
        if let token = timeObserverTokenAudio {
            player2?.removeTimeObserver(token)
            timeObserverTokenAudio = nil
        }
        //remove video observer
        if let tokenV = timeObserverTokenVideo {
            player?.removeTimeObserver(tokenV)
            timeObserverTokenVideo = nil
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player2.currentItem)
    }
    
    let timeScaleStackView = UIStackView()
    var timeScaleWidthCons: NSLayoutConstraint?
    func initTimeScale2() {
        
        for t in timeScaleStackView.arrangedSubviews {
            t.removeFromSuperview()
        }

        let roundUpSec = Int(ceil(totalVDuration))
        
        //test 2 > use stackview and distribute equally by frames
        for i in 0..<roundUpSec {
            let label = UILabel()
            label.text = "\(i)"
            timeScaleStackView.addArrangedSubview(label)
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white //.ddmDarkColor
        }
        
//        timeScaleWidthCons?.constant = totalVPFrameWidth
        timeScaleWidthCons?.constant = CGFloat(roundUpSec) * 50.0 //50px/s
    }
    
    
    func getDuration(ofVideoAt videoURL: URL) -> Double {
        let asset = AVURLAsset(url: videoURL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if durationInSeconds.isNaN {
            return 0.0
        } else {
            return durationInSeconds
        }
    }
    
    func playVideo() {
        pauseBtn.isHidden = false //test
        playBtn.isHidden = true //test
        maxVPauseBtn.isHidden = false //test
        maxVPlayBtn.isHidden = true //test

        player?.seek(to: .zero)
        player?.play()
        
        videoPlayStatus = "playing"
        
        //test
        player2?.seek(to: .zero)
        player2?.play()
    }
    
    func stopVideo() {
        pauseBtn.isHidden = true //test
        playBtn.isHidden = false //test
        maxVPauseBtn.isHidden = true //test
        maxVPlayBtn.isHidden = false //test
        
        player?.seek(to: .zero)
        player?.pause()
        
        videoPlayStatus = "stop"
        
        //test
        player2?.seek(to: .zero)
        player2?.pause()
    }
    
    func pauseVideo() {
        pauseBtn.isHidden = true //test
        playBtn.isHidden = false //test
        maxVPauseBtn.isHidden = true //test
        maxVPlayBtn.isHidden = false //test
        
        player?.pause()
        
        videoPlayStatus = "stop"
        
        //test
        player2?.pause()
    }
    
    func resumeVideo() {
        pauseBtn.isHidden = false //test
        playBtn.isHidden = true //test
        maxVPauseBtn.isHidden = false //test
        maxVPlayBtn.isHidden = true //test
        
        player?.play()
        
        videoPlayStatus = "playing"
        
        //test
        player2?.play()
    }
    
    @objc func onTimelinePinchGesture2(gesture: UIPinchGestureRecognizer) {
        if(gesture.state == .began) {
            let scale = gesture.scale
            print("pinchscale1 begin: \(scale)")
//            currentWidth = videoFrameWidth
//            videoFrameWidth = currentWidth * scale
//            timelineScrollView.contentSize = CGSize(width: videoFrameWidth, height: 50)
////            t1ScrollWidthCons?.constant = videoFrameWidth
//            tBoxWidthCons?.constant = videoFrameWidth
        }
        else if(gesture.state == .changed) {
            let scale = gesture.scale
            print("pinchscale1 change: \(scale)")
//            videoFrameWidth = currentWidth * scale
//            timelineScrollView.contentSize = CGSize(width: videoFrameWidth, height: 50)
////            t1ScrollWidthCons?.constant = videoFrameWidth
//            tBoxWidthCons?.constant = videoFrameWidth
//
//            //test > vary number of frames when stretched
//            let nFrames = Int(ceil(videoFrameWidth / 50))
//            let s = dd / CGFloat(nFrames)
//            print("pinchscale1 video duration n: \(nFrames), \(s)")
        }
        else if(gesture.state == .ended){
            let scale = gesture.scale
            print("pinchscale1 end: \(scale)")
//            videoFrameWidth = currentWidth * scale
//            timelineScrollView.contentSize = CGSize(width: videoFrameWidth, height: 50)
////            t1ScrollWidthCons?.constant = videoFrameWidth
//            tBoxWidthCons?.constant = videoFrameWidth
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("videoeditor layoutsubview: \(videoContainer.bounds)")

        //test > initialize video editor
        if(!isVideoEditorInitialized) {
            isVideoEditorInitialized = true

            delegate?.didInitializeVideoEditor()
        }
    }
    
    @objc func onBackVideoEditorPanelClicked(gesture: UITapGestureRecognizer) {
//        closeVideoEditorPanel(isAnimated: true)
        
        openExitVideoEditorPromptMsg()
        
//        delegate?.didPromptExitVideoEditor()
    }
    
    @objc func onPauseVideoClicked(gesture: UITapGestureRecognizer) {

        pauseVideo()
    }
    @objc func onResumeVideoClicked(gesture: UITapGestureRecognizer) {
        
        resumeVideo()

    }
    
    @objc func onVideoEditorNextClicked(gesture: UITapGestureRecognizer) {
        
        //test > concat videos
        pauseVideo()

        //**clear gifimage cache first
        SDImageCache.shared.removeImage(forKey: getGifOutputURL().description, withCompletion: nil)
        SDImageCache.shared.removeImage(forKey: getCoverImageOutputURL().description, withCompletion: nil)
        //**

        videoProcessProgressPanel.isHidden = false
        concatenateVideos(vcList: vcList)
        
        //test > check video size
//        let videoAsset = AVURLAsset(url: self.getOverlayVideoOutputURL())
//        let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
//        print("getvideosize: \(videoAssetTrack.naturalSize.width), \(videoAssetTrack.naturalSize.height), \(videoAssetTrack.estimatedDataRate), \(videoAssetTrack.nominalFrameRate)")
    }
    
    @objc func onMinimizeVideoClicked(gesture: UITapGestureRecognizer) {
        
        if(maxVidPanel.isHidden) {
            videoWidthLayoutConstraint?.constant = viewWidth
            videoHeightLayoutConstraint?.constant = viewHeight - 94
            videoTopLayoutConstraint?.isActive = false
            videoTopLayoutConstraint = videoContainer.topAnchor.constraint(equalTo: panel.topAnchor, constant: 0)
            videoTopLayoutConstraint?.isActive = true

            let x = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight - 94)
            playerLayer?.frame = x
            
            maxVidPanel.isHidden = false
            sText.font = .boldSystemFont(ofSize: 14) //15
            sBoxTrailingLayoutConstraint?.isActive = false
            sBoxWidthLayoutConstraint?.isActive = true
            sText.numberOfLines = 0
        } else {
            let width = 180.0
            let height = width * 16 / 9
    //        vPreviewContainer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight - 94)
            videoWidthLayoutConstraint?.constant = width
            videoHeightLayoutConstraint?.constant = height
            videoTopLayoutConstraint?.isActive = false
            videoTopLayoutConstraint = videoContainer.topAnchor.constraint(equalTo: audioContainer.topAnchor, constant: 0)
            videoTopLayoutConstraint?.isActive = true
            
            let x = CGRect(x: 0, y: 0, width: width, height: height)
    //        let x = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight - 94)
            playerLayer?.frame = x
            
            maxVidPanel.isHidden = true
            sText.font = .systemFont(ofSize: 10) //14
            sBoxTrailingLayoutConstraint?.isActive = true
            sBoxWidthLayoutConstraint?.isActive = false
            sText.numberOfLines = 1
        }
    }
    
    func concatenateVideos(vcList: [VideoClip]) {
        let mixComposition = AVMutableComposition()
        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var currentTime = CMTime.zero
        for vc in vcList {
            let videoUrl = URL(fileURLWithPath: vc.strVUrl)
            let videoAsset = AVURLAsset(url: videoUrl)
            let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
            let audioAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0]
            
            compositionAddVideo?.preferredTransform = videoAssetTrack.preferredTransform
            print("concat video size: \(videoAssetTrack.naturalSize.width), \(videoAssetTrack.naturalSize.height)")

            do {
                let ts = CMTime(seconds: vc.t_s, preferredTimescale: CMTimeScale(1000))
                let te = CMTime(seconds: vc.t_e, preferredTimescale: CMTimeScale(1000))

                let td = CMTimeSubtract(te, ts)
                
                try compositionAddVideo?.insertTimeRange(CMTimeRangeMake(start: ts,duration: td), of: videoAssetTrack, at: currentTime)
                try compositionAddAudio?.insertTimeRange(CMTimeRangeMake(start: ts,duration: td), of: audioAssetTrack, at: currentTime)
                
                currentTime = CMTimeAdd(currentTime, td)
                print("concat start: \(te), \(currentTime)")
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        //**test > concat song as sound - remove if want to retain original video sound
//        let videoURL2 = audioClipList[0].strAUrl
//        let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
//        let audioAsset = AVURLAsset(url: audioUrl)
//        let audioAssetTrack: AVAssetTrack = audioAsset.tracks(withMediaType: AVMediaType.audio)[0]
//        do {
//            try compositionAddAudio?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero,duration: currentTime), of: audioAssetTrack, at: CMTime.zero)
//        }
//        catch {
//            print(error.localizedDescription)
//        }
        //**
        
        try? FileManager.default.removeItem(at: getVideoOutputURL())
//        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPreset1280x720){
        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality){
//        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality){
            exporter.outputURL = getVideoOutputURL()
            exporter.outputFileType = AVFileType.mp4
//            exporter.videoComposition = videoComposition
            exporter.exportAsynchronously {
                switch exporter.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    guard let compressedData = try? Data(contentsOf: self.getVideoOutputURL()) else {
                        return
                    }
                    print("concatenateVideos2 complete: \(Double(Double(compressedData.count)/1048576))mb")
                    //update UI on main thread
                    DispatchQueue.main.async {
                        
                        self.videoProcessProgressPanel.isHidden = true
                        
                        //test > move to nest step
//                        self.delegate?.didClickNextVideoEditor()
                        
                        //test > produce gif for cover image
//                        self.produceGifFromVideo(videoUrl: self.getVideoOutputURL())
                        
                        //test > check file size
//                        self.getVideoFileSize(videoUrl: self.getVideoOutputURL())
                        
                        //test > shrink file size
//                        self.shrinkVideoSize(videoUrl: self.getVideoOutputURL())
                        
//                        let videoAsset = AVURLAsset(url: self.getVideoOutputURL())
//                        let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
//                        print("getvideosize: \(videoAssetTrack.naturalSize.width), \(videoAssetTrack.naturalSize.height), \(videoAssetTrack.estimatedDataRate), \(videoAssetTrack.nominalFrameRate)")
                        
                        //test > use avwriter
                        self.compressVideoWithAvWriter(videoUrl: self.getVideoOutputURL())
                    }
                case .failed:
                    print("concatenateVideos2 fail")
                    break
                case .cancelled:
                    print("concatenateVideos2 cancel")
                    break
                }
            }
        }
    }
    
    var cVideoReader: AVAssetReader?
    let group = DispatchGroup()
    func compressVideoWithAvWriter(videoUrl: URL) {
        let asset = AVAsset(url: videoUrl)

        // Create video track reader
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            // No video track found
            return
        }
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
            // No audio track found
            return
        }

        // Create video writer settings
        let targetSize = CGSize(width: 1280, height: 720)
//        let targetSize = CGSize(width: 1920, height: 1080)
//        let targetSize = CGSize(width: 500, height: 500)
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: targetSize.width,
            AVVideoHeightKey: targetSize.height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 2300000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
            ]
        ]
//        AVVideoProfileLevelH264High40
        let audioSettings: [String : Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: NSNumber(value: 2),
            AVSampleRateKey: NSNumber(value: 44100),
            AVEncoderBitRateKey: NSNumber(value: 128000)
        ]

        // Create video writer input
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
//        videoWriterInput.expectsMediaDataInRealTime = false
        videoWriterInput.transform = videoTrack.preferredTransform // fix output video orientation
        let audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)

        // Create video writer
        try? FileManager.default.removeItem(at: getOverlayVideoOutputURL())
        guard let videoWriter = try? AVAssetWriter(outputURL: getOverlayVideoOutputURL(), fileType: .mp4) else {
            // Failed to create asset writer
            return
        }

        // Add video writer input to video writer
        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
        } else {
            // Failed to add video writer input
            return
        }
        if videoWriter.canAdd(audioWriterInput) {
            videoWriter.add(audioWriterInput)
        } else {
            // Failed to add audio writer input
            return
        }

        // Create video track reader output
//        let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
//        let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: readerSettings)
        let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack,
                                                        outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA])
        let audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack,
                                                        outputSettings: [AVFormatIDKey: kAudioFormatLinearPCM])
        
        // Create video track reader
        guard let videoReader = try? AVAssetReader(asset: asset) else {
            // Failed to create asset reader
            return
        }
        
        //test
        cVideoReader = videoReader

        // Add video track reader output to video track reader
//        if videoReader.canAdd(videoReaderOutput) {
//            videoReader.add(videoReaderOutput)
//        } else {
//            // Failed to add video track reader output
//            return
//        }
        guard let aVideoReader = cVideoReader else {
            return
        }
        if aVideoReader.canAdd(videoReaderOutput) {
            cVideoReader?.add(videoReaderOutput)
        } else {
            // Failed to add video track reader output
            return
        }
        if aVideoReader.canAdd(audioReaderOutput) {
            cVideoReader?.add(audioReaderOutput)
        } else {
            // Failed to add audio track reader output
            return
        }

        // Start video writer
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: CMTime.zero)

        // Start video track reader
//        videoReader.startReading()
        cVideoReader?.startReading()
        
        //test > dispatch group
        group.enter()

        var i = 0
        // Write video samples to video writer input
        let videoProcessingQueue = DispatchQueue(label: "videoProcessingQueue")
        videoWriterInput.requestMediaDataWhenReady(on: videoProcessingQueue) {
            while videoWriterInput.isReadyForMoreMediaData {
                if let sampleBuffer = videoReaderOutput.copyNextSampleBuffer() {
                    print("reader sample: \(i)")
                    videoWriterInput.append(sampleBuffer)
                    i += 1
                } else {
                    // No more samples to write, finish writing
                    videoWriterInput.markAsFinished()
//                    videoWriter.finishWriting {
//                        guard let compressedData = try? Data(contentsOf: self.getOverlayVideoOutputURL()) else {
//                            return
//                        }
//                        print("avwriter finish \(Double(Double(compressedData.count)/1048576))mb")
//                    }
                    self.group.leave()
                    break
                }
            }
        }
        group.enter()
        var j = 0
        audioWriterInput.requestMediaDataWhenReady(on: videoProcessingQueue) {
            while audioWriterInput.isReadyForMoreMediaData {
                if let sampleBuffer = audioReaderOutput.copyNextSampleBuffer() {
                    print("reader sample: \(j)")
                    audioWriterInput.append(sampleBuffer)
                    j += 1
                } else {
                    // No more samples to write, finish writing
                    audioWriterInput.markAsFinished()
//                    videoWriter.finishWriting {
//                        guard let compressedData = try? Data(contentsOf: self.getOverlayVideoOutputURL()) else {
//                            return
//                        }
//                        print("avwriter finish \(Double(Double(compressedData.count)/1048576))mb")
//                    }
                    self.group.leave()
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            switch videoWriter.status {
            case .writing, .completed:
                videoWriter.finishWriting {
                    
                    guard let compressedData = try? Data(contentsOf: self.getOverlayVideoOutputURL()) else {
                        return
                    }
                    print("avwriter group finish \(Double(Double(compressedData.count)/1048576))mb")

                    //test > copy to video album
//                    self.copyVideoToAlbum(videoURL: self.getOverlayVideoOutputURL())
                    
                    //test > go to next step
                    DispatchQueue.main.async {
                        self.delegate?.didClickNextVideoEditor()
                    }
                }
            default:
                print("**")
            }
        }
    }
    
    func copyVideoToAlbum(videoURL: URL) {
        //test 2 > copy from ddm-demo
        PHPhotoLibrary.shared().performChanges({
//            PHAssetCreationRequest.creationRequestForAssetFromImage //for image
            PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: videoURL) //for video
        }) { (saved, error) in
            DispatchQueue.main.async {
                if saved {
                    print("Video SAVED!")
                } else {
                    print("video error \(error)")
                }
            }
        }
    }
    
    //check video file size > couple with shrink to 1280x720(but failed)
    func getVideoFileSize(videoUrl: URL) {
        let videoAsset = AVURLAsset(url: videoUrl)
        let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
        print("getvideosize: \(videoAssetTrack.naturalSize.width), \(videoAssetTrack.naturalSize.height), \(videoAssetTrack.estimatedDataRate), \(videoAssetTrack.nominalFrameRate)")
    }
    
    ////produce GIF from video
    func produceGifFromVideo(videoUrl: URL) {
        
        let asset = AVURLAsset(url: videoUrl)
        guard let reader = try? AVAssetReader(asset: asset) else {
            return
        }
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            return
        }
    //        let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
    
        //to get transformed rotation degree
        let transform = videoTrack.preferredTransform
        let radians = atan2(transform.b, transform.a)
        let degrees = (radians * 180.0) / .pi
    
        let videoSize = videoTrack.naturalSize
    //        let resultingSize: CGSize = {
    //            return CGSize(width: videoSize.width, height: videoSize.height)
    //        }()
    
        let cappedResolution: CGFloat = 320.0 //ori 240...200(200 is too blur and small)
    
        let videoWidth = abs(videoSize.width)
        let videoHeight = abs(videoSize.height)
        let aspectRatio = videoWidth / videoHeight
    
        let resultingSize: CGSize = {
    
            if videoWidth > videoHeight {
                let cappedWidth = round(min(cappedResolution, videoWidth))
                return CGSize(width: cappedWidth, height: round(cappedWidth / aspectRatio))
            } else {
                let cappedHeight = round(min(cappedResolution, videoHeight))
                print("gifVideo resulting size: \(cappedHeight), \(round(cappedHeight * aspectRatio))")
                return CGSize(width: round(cappedHeight * aspectRatio), height: cappedHeight)
            }
        }()
    
//        let duration: CGFloat = CGFloat(asset.duration.seconds)
        let duration: CGFloat = CGFloat(2)
        let nominalFrameRate = CGFloat(videoTrack.nominalFrameRate)
        let nominalTotalFrames = Int(round(duration * nominalFrameRate))
        let desiredFrameRate: CGFloat = 5.0 //ori 30, 15
    
        print("gifVideo: \(duration), \(nominalFrameRate), \(nominalTotalFrames)")
    
        let framesToRemove: [Int] = {
            // Ensure the actual/nominal frame rate isn't already lower than the desired, in which case don't even worry about it
            if desiredFrameRate < nominalFrameRate {
                let percentageOfFramesToRemove = 1.0 - (desiredFrameRate / nominalFrameRate)
                let totalFramesToRemove = Int(round(CGFloat(nominalTotalFrames) * percentageOfFramesToRemove))
    
                // We should remove a frame every `frameRemovalInterval` frames…
                // Since we can't remove e.g.: the 3.7th frame, round that up to 4, and we'd remove the 4th frame, then the 7.4th -> 7th, etc.
                let frameRemovalInterval = CGFloat(nominalTotalFrames) / CGFloat(totalFramesToRemove)
                var framesToRemove: [Int] = []
    
                var sum: CGFloat = 0.0
    
                while sum <= CGFloat(nominalTotalFrames) {
                    sum += frameRemovalInterval
                    let roundedFrameToRemove = Int(round(sum))
                    framesToRemove.append(roundedFrameToRemove)
                }
    
                return framesToRemove
            } else {
                return []
            }
        }()
    
        let totalFrames = nominalTotalFrames - framesToRemove.count
    
        let outputSettings: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: resultingSize.width,
            kCVPixelBufferHeightKey as String: resultingSize.height
        ]
    
        let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: outputSettings)
    
        reader.add(readerOutput)
        reader.startReading()
    
        var sample: CMSampleBuffer? = readerOutput.copyNextSampleBuffer()
    
        let delayBetweenFrames: CGFloat = 1.0 / min(desiredFrameRate, nominalFrameRate)
    
        print("gifVideo Nominal total frames: \(nominalTotalFrames), totalFramesUsed: \(totalFrames), totalFramesToRemove: \(framesToRemove.count), nominalFrameRate: \(nominalFrameRate), delayBetweenFrames: \(delayBetweenFrames)")
    
        let fileProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0
            ]
        ]
    
        let frameProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime: delayBetweenFrames
            ]
        ]
    
        //remove previous file first
        try? FileManager.default.removeItem(at: getGifOutputURL())
    
        guard let destination = CGImageDestinationCreateWithURL(getGifOutputURL() as CFURL, UTType.gif.identifier as CFString, totalFrames, nil) else {
            return
        }
    
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
    
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
    
        var framesCompleted = 0
        var currentFrameIndex = 0
    
        while (sample != nil) {
            //**test > break while loop
            if nominalTotalFrames == framesCompleted {
                print("gifvideo break ")
                break
            }
            //**
            
            currentFrameIndex += 1
    
            if framesToRemove.contains(currentFrameIndex) {
                sample = readerOutput.copyNextSampleBuffer()
                continue
            }
    
            if let newSample = sample {
                //loop through video and extract frame as image, then integrate images into GIF file
                // Create it as an optional and manually nil it out every time it's finished otherwise weird Swift bug where memory will balloon enormously (see https://twitter.com/ChristianSelig/status/1241572433095770114)
    //                var cgImage: CGImage? = self.cgImageFromSampleBuffer(newSample, degrees)
                var cgImage: CGImage? = self.cgImageFromSampleBuffer(newSample, rotationDegree: degrees)
    
                operationQueue.addOperation {
                    framesCompleted += 1
    
                    if let cgImage = cgImage {
    //                        CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
    
                        if(framesCompleted <= totalFrames) {
                            CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
                        }
                    }
    
                    cgImage = nil
    
                    let progress = CGFloat(framesCompleted) / CGFloat(totalFrames)
    
                    // GIF progress is a little fudged so it works with downloading progress reports
                    let progressToReport = Int(progress * 100.0)
                    print("gifvideo % \(progressToReport), \(framesCompleted), \(totalFrames)")
                }
            }
    
            sample = readerOutput.copyNextSampleBuffer()
        }
    
        operationQueue.waitUntilAllOperationsAreFinished()
    
        print("gifVideo finalizing: \(framesCompleted), \(totalFrames)")
        let didCreateGIF = CGImageDestinationFinalize(destination)
    
        guard didCreateGIF else {
            return
        }
    
        print("gifVideo completed")
        DispatchQueue.main.async {
//            print("gifVideo completed")
//            self.delegate?.didClickNextVideoEditor()
            self.produceCoverImageFromVideo(videoUrl: videoUrl)
        }
    }
    
    private func cgImageFromSampleBuffer(_ buffer: CMSampleBuffer, rotationDegree: CGFloat) -> CGImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
    
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
    
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
    
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
    
        print("gifVideo image: \(width), \(height)")
    
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else { return nil }
    
        let image = context.makeImage()
    //
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
    //        return image
    
    //        let newImage = createMatchingBackingDataWithImage(imageRef: image)
    //        return newImage
    
        if(rotationDegree == 0.0) {
    //            let image = context.makeImage()
    //            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            return image
        } else {
            let newImage = createMatchingBackingDataWithImage(imageRef: image, rotationDegree: rotationDegree)
            return newImage
        }
    }
    
    //test to flip, transform CGImage
    func createMatchingBackingDataWithImage(imageRef: CGImage?, rotationDegree: CGFloat) -> CGImage? {
        var orientedImage: CGImage?
    
        if let imageRef = imageRef {
            let originalWidth = imageRef.width
            let originalHeight = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = imageRef.bytesPerRow
    
            let colorSpace = imageRef.colorSpace
            let bitmapInfo = imageRef.bitmapInfo
    
            var degreesToRotate: Double
            var swapWidthHeight: Bool
            var mirrored: Bool
    
            if(rotationDegree == 90.0) {
                degreesToRotate = -90.0 //negative is clockwise, positive is counterclockwise
                swapWidthHeight = true
            } else if (rotationDegree == -90.0) {
                degreesToRotate = 90.0 //negative is clockwise, positive is counterclockwise
                swapWidthHeight = true
            } else {
                degreesToRotate = Double(rotationDegree)
                swapWidthHeight = false
            }
    
            //****Need to test for landscape
    //            swapWidthHeight = true
            mirrored = false
    
    //            switch orienation {
    //            case .up:
    //                degreesToRotate = 0.0
    //                swapWidthHeight = false
    //                mirrored = false
    //                break
    //            case .upMirrored:
    //                degreesToRotate = 0.0
    //                swapWidthHeight = false
    //                mirrored = true
    //                break
    //            case .right:
    //                degreesToRotate = 90.0
    //                swapWidthHeight = true
    //                mirrored = false
    //                break
    //            case .rightMirrored:
    //                degreesToRotate = 90.0
    //                swapWidthHeight = true
    //                mirrored = true
    //                break
    //            case .down:
    //                degreesToRotate = 180.0
    //                swapWidthHeight = false
    //                mirrored = false
    //                break
    //            case .downMirrored:
    //                degreesToRotate = 180.0
    //                swapWidthHeight = false
    //                mirrored = true
    //                break
    //            case .left:
    //                degreesToRotate = -90.0
    //                swapWidthHeight = true
    //                mirrored = false
    //                break
    //            case .leftMirrored:
    //                degreesToRotate = -90.0
    //                swapWidthHeight = true
    //                mirrored = true
    //                break
    //            }
            let radians = degreesToRotate * Double.pi / 180
    
            var width: Int
            var height: Int
            if swapWidthHeight {
                width = originalHeight
                height = originalWidth
            } else {
                width = originalWidth
                height = originalHeight
            }
    
            if let contextRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue) {
    
                contextRef.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
                if mirrored {
                    contextRef.scaleBy(x: -1.0, y: 1.0)
                }
                contextRef.rotate(by: CGFloat(radians))
                if swapWidthHeight {
                    contextRef.translateBy(x: -CGFloat(height) / 2.0, y: -CGFloat(width) / 2.0)
                } else {
                    contextRef.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
                }
                contextRef.draw(imageRef, in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))
    
                orientedImage = contextRef.makeImage()
            }
        }
    
        return orientedImage
    }
    
    //produce cover thumbnail from video
    //ori: generateThumbnail()
    //    func produceCoverImageFromVideo(videoUrl: URL) -> UIImage? {
    func produceCoverImageFromVideo(videoUrl: URL) {
        do {
            //generate image from image generator
            let asset = AVURLAsset(url: videoUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
    
            // Swift 4.2
            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
    
            //remove previous version
            try? FileManager.default.removeItem(at: getCoverImageOutputURL())
    
            do {
                print("generate thumbnail trying")
                try UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.90)?.write(to: getCoverImageOutputURL(), options: .atomic)
            } catch {
                print(error)
            }
    
            print("generate thumbnail done")
    //            return UIImage(cgImage: cgImage)

            DispatchQueue.main.async {
                self.delegate?.didClickNextVideoEditor()
            }
        } catch {
            print(error.localizedDescription)
    //            return nil
        }
    }
    
//    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
////        guard let videoAsset = videoAsset else {
////            return
////        }
////        compressVideo(inputAVAsset: videoAsset) { exportSession in
////            print("video compress done")
////        }
//
//    }
//
//    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
//
//        //test 1 > redo video preview
////        configureVideoPreview()
//
//        //test 2 > remove cover image file
////        try? FileManager.default.removeItem(at: getCoverImageOutputURL())
//
//        //test 3 > remove compressed video file
////        try? FileManager.default.removeItem(at: getVideoOutputURL())
//
//        //test 4 > try remove cache for gif
////        SDImageCache.shared.removeImage(forKey: getGifOutputURL().description, withCompletion: nil)
//
//        //test 5 > try remove cache for cover image
////        SDImageCache.shared.removeImage(forKey: getCoverImageOutputURL().description, withCompletion: nil)
//
//        //test 6 > double speed
////        player?.rate = 2.0
//
//
//    }
//    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
//        //test 1 > watermark with raw av video asset
////        guard let videoAsset = videoAsset else {
////            return
////        }
////        addWatermarkToVideo(videoAsset: videoAsset)
//
//        //test 2 > watermark with outputfile
////        addWatermarkToVideo(outputFileURL: getVideoOutputURL())
//
//        //test 3 > split audio
////        splitAudio(videoAsset: videoAsset)
//
//        //test 4 > merge video and audio files
////        mergeVideoAudioTracks(videoAsset: videoAsset, inputAudioUrl: getSplitAudioOutputURL())
//
//        //test 5 > produce gif from compressed video
////        produceGifFromVideo(videoUrl: getVideoOutputURL())
//
//        //test 6 > produce cover image from compressed video
////        produceCoverImageFromVideo(videoUrl: getVideoOutputURL())
//
//        //test 7 > try overlay
////        overlayLayerOnVideo(videoUrl: getVideoOutputURL())
//
//        //test 8 > try varied video preview size
////        print("video change size")
////        let width = 350.0
////        let height = width * 16 / 9
////        videoWidthLayoutConstraint?.constant = width
////        videoHeightLayoutConstraint?.constant = height
////
////        playerLayer?.frame = CGRect(x: 0, y: 0, width: width, height: height)
//
//        //test 9 > try blur out effect => failed, video inverted again
////        blurOutEffectOnVideo(videoUrl: getVideoOutputURL())
//
//
//        //test > remove video clip
////        removeVideoClip(i: selectedVcIndex)
//
//    }
    
    func closeVideoEditorPanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
//                self.panelLeadingCons?.constant = self.frame.width
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.stopVideo()
                
                //test > remove time observer
//                self.removeTimeObserver()
                self.removeTimeObserverAudio()
                
                self.removeFromSuperview()
                
                //move back to origin
                self.delegate?.didClickFinishVideoEditor()
            })
        } else {
            self.stopVideo()
            
            //test > remove time observer
//            self.removeTimeObserver()
            self.removeTimeObserverAudio()
            
            self.removeFromSuperview()
            
            //move back to origin
            self.delegate?.didClickFinishVideoEditor()
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {

        print("video finish playing")
//        pauseVideo()
        
//        stopVideo()
        playVideo()
    }

    // sample m4a
    //https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media
    //https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2F8w4Y4tvmJYSvmIiviXUHUZGrpEj2%2Fmusic%2F0Ro0CtVDNFxekdCVulYk%2Faudio%2F0%2Fshort_0_iGzXde9RSPtRMbQoAze4g.m4a?alt=media
    //https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FUsdriQjjd3cR8TqAS26Nw8hb5w12%2Fmusic%2F0lzaAfeVESUBVaQFYYEG%2Faudio%2F0%2Fshort_0_mtRm3sWvGb9FNPrbLSYpU.m4a?alt=media
    
    //test > check preferred transform of video
    func getVideoPreferredTransform(video: AVAsset) {
        print("getVideoPreferredTransform: \(video.duration), \(video.tracks(withMediaType: AVMediaType.video)[0].preferredTransform)")
    }
    
    func openExitVideoEditorPromptMsg() {
        let exitVideoPanel = ExitVideoEditorMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(exitVideoPanel)
        exitVideoPanel.translatesAutoresizingMaskIntoConstraints = false
        exitVideoPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        exitVideoPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        exitVideoPanel.delegate = self
    }
    
    //test > file management for draft files
    //ori: tempStorageURL()
//    func getVideoOutputURL() -> URL? {
    func getVideoOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILE_OUTPUT_NAME)
        return url
    }
    func getSplitAudioOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.SPLIT_AUDIO_FILE_OUTPUT_NAME)
        
        return url
    }
    func getGifOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_GIF_FILE_OUTPUT_NAME)
        
        return url
    }
    func getCoverImageOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_COVER_IMAGE_FILE_OUTPUT_NAME)
        
        return url
    }
    func getOverlayVideoOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_OVERLAY_VIDEO_FILE_OUTPUT_NAME)
        return url
    }
    func getBlurOutVideoOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_BLUROUT_VIDEO_FILE_OUTPUT_NAME)
        return url
    }
    
    func createDirectoryForDraft() {
        let dataPath = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
    
        if !fileManager.fileExists(atPath: dataPath.path) {
            do {
                try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                print("createDirectoryForDraft ")
            } catch {
                print("createDirectoryForDraft error \(error.localizedDescription)")
            }
        } else {
            print("createDirectoryForDraft already exist")
        }
    }
    
    func checkFilesInFolder() {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            let count = fileURLs.count
            print("draft files total: \(count)")

        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
}

extension VideoEditorPanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("videdit scrollview begin: \(scrollView.contentOffset.x)")
        let x = scrollView.contentOffset.x
        
        //test
        pauseVideo()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("videdit scrollview scroll: \(scrollView.contentOffset.x), \(totalVDuration), \(totalVPFrameWidth)")
        let x = scrollView.contentOffset.x + viewWidth/2
//        let currentT = x * totalVDuration/totalVPFrameWidth
//        currentATime = currentT
        
        var currentT = 0.0
        if(totalVPFrameWidth > 0) {
            currentT = x * totalVDuration/totalVPFrameWidth
            currentATime = currentT
        }
        
        //test > general solution
        if(videoPlayStatus == "stop") {
            var cumT = 0.0
            for i in 0..<vcList.count {
                let cTi = currentT - cumT + vcList[i].t_s
                cumT = cumT + (vcList[i].t_e - vcList[i].t_s)
                print("vctimescroll A': \(cumT), \(currentT)")
                if(currentT <= cumT) {
                    print("vctimescroll A: \(cumT), \(currentT)")
                    if(player.currentItem != vcList[i].playerItem) {
                        print("vctimescroll A+: \(cumT), \(currentT)")
                        player.replaceCurrentItem(with: vcList[i].playerItem)
                        
                        //test
                        lastPlayingVcIndex = i
                    }
                    //test
                    lastPlayingVcCT = cTi
                    
                    let seekTime = CMTime(seconds: cTi, preferredTimescale: CMTimeScale(1000)) //1000
                    player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    let seekTimeA = CMTime(seconds: currentT, preferredTimescale: CMTimeScale(1000)) //1000
                    player2?.seek(to: seekTimeA, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    break
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("videdit scrollview end decelerate: \(scrollView.contentOffset.x)")
        let x = scrollView.contentOffset.x + viewWidth/2
        let currentT = x * totalVDuration/totalVPFrameWidth
        currentATime = currentT
        
        //test > general solution
        if(videoPlayStatus == "stop") {
            var cumT = 0.0
            for i in 0..<vcList.count {
                let cTi = currentT - cumT + vcList[i].t_s
                cumT = cumT + (vcList[i].t_e - vcList[i].t_s)
                print("vctimescroll B': \(cumT), \(currentT)")
                if(currentT <= cumT) {
                    print("vctimescroll B: \(cumT), \(currentT)")
                    if(player.currentItem != vcList[i].playerItem) {
                        print("vctimescroll B+: \(cumT), \(currentT)")
                        player.replaceCurrentItem(with: vcList[i].playerItem)
                        
                        //test
                        lastPlayingVcIndex = i
                    }
                    //test
                    lastPlayingVcCT = cTi
                    
                    let seekTime = CMTime(seconds: cTi, preferredTimescale: CMTimeScale(1000)) //1000
                    player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    let seekTimeA = CMTime(seconds: currentT, preferredTimescale: CMTimeScale(1000)) //1000
                    player2?.seek(to: seekTimeA, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    
                    break
                }
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("videdit scrollview end drag: \(scrollView.contentOffset.x)")
    }
}

extension VideoEditorPanelView: ExitVideoEditorMsgDelegate{
    func didSVDClickProceed() {
        closeVideoEditorPanel(isAnimated: true)
    }
    func didSVDClickDeny() {
        delegate?.didDenyExitVideoEditor()
    }
    func didSVDInitialize() {
        delegate?.didPromptExitVideoEditor()
    }
}

extension VideoCreatorConsolePanelView: VideoEditorPanelDelegate{
    func didInitializeVideoEditor() {
        //test > turn off camera
//        self.session?.stopRunning()
    }
    func didClickFinishVideoEditor() {
        backPage()
        
        //test > resume camera
//        self.session?.startRunning()
    }
    
    func didClickNextVideoEditor() {
        openVideoFinalize()
    }
    
    func didPromptExitVideoEditor() {
        //test > resume camera
//        DispatchQueue.main.async {
//            self.session?.startRunning()
//        }
    }
    
    func didDenyExitVideoEditor() {
        //test > turn off camera
//        self.session?.stopRunning()
    }
    
    func didClickAddVideoClip() {
        openCameraRoll()
    }
}

//
//Video Creator archive for future use case
//protocol VideoCreatorPanelDelegate : AnyObject {
//    func didInitializeVideoCreator()
//    func didClickFinishVideoCreator()
//
//    //test
//    func didVideoCreatorClickLocationSelectScrollable()
//}
//
//class VideoCreatorConsolePanelView: CreatorPanelView{
////class VideoCreatorConsolePanelView: PanelView{
//
//    var panel = UIView()
//    var currentPanelTopCons : CGFloat = 0.0
//    var panelTopCons: NSLayoutConstraint?
//
//    let aStickyHeader = UIView()
//
//    var viewHeight: CGFloat = 0
//    var viewWidth: CGFloat = 0
//
//    var session: AVCaptureSession?
//    let previewLayer = AVCaptureVideoPreviewLayer()
//    let output = AVCaptureMovieFileOutput()
//
//    var isCameraInitialized = false
//
//    let pauseRecordingBtn = UIView()
//    let startRecordingBtn = UIView()
//
//    //test page transition => track user journey in creating short video
//    var pageList = [PanelView]()
//
//    weak var delegate : VideoCreatorPanelDelegate?
//
//    let camMiniError = UIView()
//    let micMiniError = UIView()
//    let lhsMiniError = UIView()
//    let lhsMiniAdd = UIView()
//
//    private let fileManager = FileManager.default
//    private lazy var mainDirectoryUrl: URL = {
//        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            return documentsUrl
//        //.cachesDirectory is only for short term storage
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        viewWidth = frame.width
//        viewHeight = frame.height
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setupViews()
//    }
//
//    func setupViews() {
//        panel.backgroundColor = .ddmBlackOverlayColor
//        self.addSubview(panel)
//        panel.translatesAutoresizingMaskIntoConstraints = false
//        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
////        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
////        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
//        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        panel.layer.masksToBounds = true
//        panel.layer.cornerRadius = 10 //10
//        //test
//        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
////        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
////        panelLeadingCons?.isActive = true
//        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
//        panelTopCons?.isActive = true
//
//        let aBtn = UIView()
////        aBtn.backgroundColor = .ddmDarkColor
//        aBtn.backgroundColor = .clear
//        panel.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
////        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
////        let topInsetMargin = panel.safeAreaInsets.top + 10
////        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
//        aBtn.layer.cornerRadius = 20
////        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVideoCreatorPanelClicked)))
//
////        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .white
////        aStickyHeader.addSubview(bMiniBtn)
//        panel.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//
//        //test > camera preview layer
//        let cameraView = UIView()
//        let cameraHeight = viewWidth * 16 / 9
//        cameraView.frame = CGRect(x: 0 , y: 0, width: viewWidth, height: cameraHeight)
////        self.addSubview(cameraView)
//        panel.addSubview(cameraView)
//        cameraView.translatesAutoresizingMaskIntoConstraints = false
//        cameraView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
//        cameraView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //ori: 40
//        cameraView.heightAnchor.constraint(equalToConstant: cameraHeight).isActive = true
//        cameraView.layer.addSublayer(previewLayer)
//        cameraView.layer.cornerRadius = 20
//        cameraView.layer.masksToBounds = true
//        previewLayer.frame = cameraView.bounds
//
//        let cameraRing = RingView()
//        panel.addSubview(cameraRing)
//        cameraRing.translatesAutoresizingMaskIntoConstraints = false
//        cameraRing.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -30).isActive = true
//        cameraRing.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor, constant: 0).isActive = true
//        cameraRing.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 40
//        cameraRing.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        cameraRing.changeLineWidth(width: 5)
//        cameraRing.changeStrokeColor(color: UIColor.white)
//        cameraRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRecordCameraClicked)))
//
//        startRecordingBtn.backgroundColor = .white //yellow
//        panel.addSubview(startRecordingBtn)
//        startRecordingBtn.translatesAutoresizingMaskIntoConstraints = false
//        startRecordingBtn.centerYAnchor.constraint(equalTo: cameraRing.centerYAnchor).isActive = true
//        startRecordingBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        startRecordingBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        startRecordingBtn.centerXAnchor.constraint(equalTo: cameraRing.centerXAnchor).isActive = true
////        startRecordingBtn.layer.opacity = 0.5
//        startRecordingBtn.layer.cornerRadius = 25
//        startRecordingBtn.isUserInteractionEnabled = false
//        startRecordingBtn.isHidden = false
//
//        pauseRecordingBtn.backgroundColor = .yellow //white
//        panel.addSubview(pauseRecordingBtn)
//        pauseRecordingBtn.translatesAutoresizingMaskIntoConstraints = false
//        pauseRecordingBtn.centerYAnchor.constraint(equalTo: cameraRing.centerYAnchor).isActive = true
//        pauseRecordingBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        pauseRecordingBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        pauseRecordingBtn.centerXAnchor.constraint(equalTo: cameraRing.centerXAnchor).isActive = true
////        pauseRecordingBtn.layer.opacity = 0.5
//        pauseRecordingBtn.layer.cornerRadius = 5
//        pauseRecordingBtn.isUserInteractionEnabled = false
//        pauseRecordingBtn.isHidden = true
//
//        //**test > error getting camera
////        let camMiniError = UIView()
//        camMiniError.backgroundColor = .red
//        panel.addSubview(camMiniError)
//        camMiniError.translatesAutoresizingMaskIntoConstraints = false
////        camMiniError.leadingAnchor.constraint(equalTo: cameraRing.trailingAnchor, constant: -10).isActive = true
////        camMiniError.bottomAnchor.constraint(equalTo: cameraRing.topAnchor, constant: 10).isActive = true
//        camMiniError.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        camMiniError.centerYAnchor.constraint(equalTo: panel.centerYAnchor, constant: -20).isActive = true
//        camMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        camMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        camMiniError.layer.cornerRadius = 10
////        camMiniError.isHidden = true
//
//        let camBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
//        camBtn.tintColor = .white
//        camMiniError.addSubview(camBtn)
//        camBtn.translatesAutoresizingMaskIntoConstraints = false
//        camBtn.centerXAnchor.constraint(equalTo: camMiniError.centerXAnchor).isActive = true
//        camBtn.centerYAnchor.constraint(equalTo: camMiniError.centerYAnchor).isActive = true
//        camBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
//        camBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
//
////        let camMiniError = UIView()
//        micMiniError.backgroundColor = .red
//        panel.addSubview(micMiniError)
//        micMiniError.translatesAutoresizingMaskIntoConstraints = false
//        micMiniError.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        micMiniError.centerYAnchor.constraint(equalTo: panel.centerYAnchor, constant: -20).isActive = true
//        micMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        micMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        micMiniError.layer.cornerRadius = 10
////        micMiniError.isHidden = true
//
//        let micBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
//        micBtn.tintColor = .white
//        micMiniError.addSubview(micBtn)
//        micBtn.translatesAutoresizingMaskIntoConstraints = false
//        micBtn.centerXAnchor.constraint(equalTo: micMiniError.centerXAnchor).isActive = true
//        micBtn.centerYAnchor.constraint(equalTo: micMiniError.centerYAnchor).isActive = true
//        micBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
//        micBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
//        //**
//
//        let lhsBtn = UIView()
//        lhsBtn.backgroundColor = .ddmBlackOverlayColor
//        lhsBtn.layer.opacity = 0.3
//        lhsBtn.layer.cornerRadius = 15
//        panel.addSubview(lhsBtn)
//        lhsBtn.translatesAutoresizingMaskIntoConstraints = false
//        lhsBtn.centerYAnchor.constraint(equalTo: cameraRing.centerYAnchor).isActive = true
//        lhsBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        lhsBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
////        lhsBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 30).isActive = true
//        lhsBtn.trailingAnchor.constraint(equalTo: cameraRing.leadingAnchor, constant: -70).isActive = true
//        lhsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenCameraRollClicked)))
//
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        var gifImage = SDAnimatedImageView()
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.layer.cornerRadius = 15
//        panel.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
//        gifImage.topAnchor.constraint(equalTo: lhsBtn.topAnchor).isActive = true
//        gifImage.leadingAnchor.constraint(equalTo: lhsBtn.leadingAnchor).isActive = true
//        gifImage.bottomAnchor.constraint(equalTo: lhsBtn.bottomAnchor).isActive = true
//        gifImage.trailingAnchor.constraint(equalTo: lhsBtn.trailingAnchor).isActive = true
//
//        //**test > error getting video/photo album
////        let lhsMiniError = UIView()
//        lhsMiniError.backgroundColor = .red
//        panel.addSubview(lhsMiniError)
//        lhsMiniError.translatesAutoresizingMaskIntoConstraints = false
//        lhsMiniError.leadingAnchor.constraint(equalTo: lhsBtn.trailingAnchor, constant: -10).isActive = true
//        lhsMiniError.bottomAnchor.constraint(equalTo: lhsBtn.topAnchor, constant: 10).isActive = true
//        lhsMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        lhsMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        lhsMiniError.layer.cornerRadius = 10
////        lhsMiniError.isHidden = true
//
//        let aBBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
//        aBBtn.tintColor = .white
//        lhsMiniError.addSubview(aBBtn)
//        aBBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBBtn.centerXAnchor.constraint(equalTo: lhsMiniError.centerXAnchor).isActive = true
//        aBBtn.centerYAnchor.constraint(equalTo: lhsMiniError.centerYAnchor).isActive = true
//        aBBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
//        aBBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
//        //**
//
//        lhsMiniAdd.backgroundColor = .ddmDarkColor //.white
//        panel.addSubview(lhsMiniAdd)
//        lhsMiniAdd.translatesAutoresizingMaskIntoConstraints = false
//        lhsMiniAdd.leadingAnchor.constraint(equalTo: lhsBtn.trailingAnchor, constant: -10).isActive = true
//        lhsMiniAdd.bottomAnchor.constraint(equalTo: lhsBtn.topAnchor, constant: 10).isActive = true
//        lhsMiniAdd.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        lhsMiniAdd.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        lhsMiniAdd.layer.cornerRadius = 8
//
//        let lhsAddBtn = UIImageView(image: UIImage(named:"icon_round_add_circle")?.withRenderingMode(.alwaysTemplate))
//        lhsAddBtn.tintColor = .white //.ddmBlackOverlayColor
//        lhsMiniAdd.addSubview(lhsAddBtn)
//        lhsAddBtn.translatesAutoresizingMaskIntoConstraints = false
//        lhsAddBtn.centerXAnchor.constraint(equalTo: lhsMiniAdd.centerXAnchor).isActive = true
//        lhsAddBtn.centerYAnchor.constraint(equalTo: lhsMiniAdd.centerYAnchor).isActive = true
//        lhsAddBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
//        lhsAddBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let rhsBtn = UIView()
//        rhsBtn.backgroundColor = .ddmBlackOverlayColor
//        rhsBtn.layer.opacity = 0.3
//        rhsBtn.layer.cornerRadius = 25
//        panel.addSubview(rhsBtn)
//        rhsBtn.translatesAutoresizingMaskIntoConstraints = false
//        rhsBtn.centerYAnchor.constraint(equalTo: cameraRing.centerYAnchor).isActive = true
//        rhsBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        rhsBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        rhsBtn.leadingAnchor.constraint(equalTo: cameraRing.trailingAnchor, constant: 70).isActive = true
////        rhsBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
//        rhsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenReverseCameraClicked)))
//
//        let rhsBtnIcon = UIImageView(image: UIImage(named:"icon_round_swap")?.withRenderingMode(.alwaysTemplate))
//        rhsBtnIcon.tintColor = .white
//        panel.addSubview(rhsBtnIcon)
//        rhsBtnIcon.translatesAutoresizingMaskIntoConstraints = false
//        rhsBtnIcon.centerXAnchor.constraint(equalTo: rhsBtn.centerXAnchor).isActive = true
//        rhsBtnIcon.centerYAnchor.constraint(equalTo: rhsBtn.centerYAnchor).isActive = true
//        rhsBtnIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
//        rhsBtnIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
//
//        //test > add record time
//        let tBox = UIView()
//        tBox.backgroundColor = .ddmDarkColor
////        aStickyHeader.addSubview(aBtn)
//        panel.addSubview(tBox)
//        tBox.translatesAutoresizingMaskIntoConstraints = false
//        tBox.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 40
//        tBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        tBox.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
////        tBox.bottomAnchor.constraint(equalTo: cameraRing.topAnchor, constant: -20).isActive = true
//        tBox.bottomAnchor.constraint(equalTo: cameraView.topAnchor, constant: -10).isActive = true
//        tBox.layer.cornerRadius = 5
//        tBox.layer.opacity = 0.3
//
//        let tText = UILabel()
//        tText.textAlignment = .center
//        tText.textColor = .white
//        tText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(tText)
//        tText.translatesAutoresizingMaskIntoConstraints = false
//        tText.centerXAnchor.constraint(equalTo: tBox.centerXAnchor, constant: 0).isActive = true
//        tText.centerYAnchor.constraint(equalTo: tBox.centerYAnchor, constant: 0).isActive = true
//        tText.text = "00:00"
//        tText.layer.opacity = 1.0
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print("videocreator layoutsubview")
//
//        if(!isCameraInitialized) {
//            checkForCameraPermission()
//            checkForMicPermission()
//
//            if(isCamPermissionNotDetermined || isMicPermissionNotDetermined) {
//                openCameraErrorPromptMsg()
//            }
//
//            checkCameraRollPermission(isToOpen: true) //test
//
//            isCameraInitialized = true
//        }
//    }
//
//    @objc func onBackVideoCreatorPanelClicked(gesture: UITapGestureRecognizer) {
//
//        closeVideoCreatorPanel(isAnimated: true)
//    }
//
//    @objc func onOpenCameraRollClicked() {
//
//        openCameraRoll() //**
//
//        //test to turn off camera
////        session?.removeInput(videoDeviceInput!) //test
////        self.session?.stopRunning()
//
//        //test 3 > try delete all temp files
////        deleteTempFiles()
//
//        //test > get storage permission
////        openStorageErrorPromptMsg()
//
//        //test > check permission first before opening camera roll
////        let a = checkCameraRollPermission()
////        if a {
////            self.openCameraRoll()
////        } else {
////            self.openStorageErrorPromptMsg()
////        }
//    }
//
//    @objc func onOpenReverseCameraClicked() {
//
//        //test to restart camera
////        self.session?.startRunning()
//
//        //test 2 > switch camera position
////        switchCamera()
//
//        let a = checkForCameraPermission()
////        let b = checkForMicPermission()
//        if a {
//            switchCamera()
//        } else {
//            openCameraErrorPromptMsg()
//        }
//    }
//
//    @objc func onRecordCameraClicked() {
//
//        //test 1 > check temp files
////        print("record camera click: \(tempURL())")
////        checkFilesInTemp()
//
//        //test 2 > try recording video
////        startRecording()//**
//
//        //test 3 > try delete all temp files
////        deleteTempFiles()
//
//        //test > get camera permission
////        openCameraErrorPromptMsg()
//
//        let a = checkForCameraPermission()
//        let b = checkForMicPermission()
//        if a && b {
//            //can start recording
//        } else {
//            openCameraErrorPromptMsg()
//        }
//    }
//
//    //test
//    func openAppIOSPublicSetting() {
//        //direct user off app to IOS public app setting
//        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//            return
//        }
//
//        if UIApplication.shared.canOpenURL(settingsUrl) {
//            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                print("Settings opened: \(success)")
//            })
//        }
//    }
//
//    func closeVideoCreatorPanel(isAnimated: Bool) {
//        if(isAnimated) {
//            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
//                self.panelTopCons?.constant = 0
//                self.layoutIfNeeded()
//            }, completion: { _ in
//                self.session?.stopRunning() //test to turn off camera
//
//                self.removeFromSuperview()
//                self.delegate?.didClickFinishVideoCreator()
//            })
//        } else {
//            self.session?.stopRunning() //test to turn off camera
//
//            self.removeFromSuperview()
//            self.delegate?.didClickFinishVideoCreator()
//        }
//    }
//
//    //*** Copy from Maps Demo & Snap app
//    var isCamPermissionNotDetermined = false
//    var isMicPermissionNotDetermined = false
//    var isStoragePermissionNotDetermined = false
//    func checkForCameraPermission() -> Bool {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//
//        case .notDetermined:
//            camMiniError.isHidden = false
//
//            //test
////            isPermissionNotDetermined = true
//            isCamPermissionNotDetermined = true
//            return false
//        case .restricted:
//            camMiniError.isHidden = false
//            isCamPermissionNotDetermined = false
////            break
//            return false
//        case .denied:
//            camMiniError.isHidden = false
//            isCamPermissionNotDetermined = false
////            break
//            return false
//        case .authorized:
//            camMiniError.isHidden = true
//            isCamPermissionNotDetermined = false
//            //async is needed for faster camera UI, otherwise it waits for camera to slowly activate
//            DispatchQueue.main.async {
//                self.setupCamera()
//            }
//            return true
//        @unknown default:
//            camMiniError.isHidden = false
//            isCamPermissionNotDetermined = false
////            break
//            return false
//        }
//    }
//    func checkForMicPermission() -> Bool {
//        switch AVCaptureDevice.authorizationStatus(for: .audio) {
//
//        case .notDetermined:
//            print("mic permission not determined")
//            micMiniError.isHidden = false
//
//            //test
////            isPermissionNotDetermined = true
//            isMicPermissionNotDetermined = true
//            return false
//        case .restricted:
//            print("mic permission restricted")
//            //error msg for mic
//            micMiniError.isHidden = false
//            isMicPermissionNotDetermined = false
////            break
//            return false
//        case .denied:
//            print("mic permission denied")
//            //error msg for mic
//            micMiniError.isHidden = false
//            isMicPermissionNotDetermined = false
////            break
//            return false
//        case .authorized:
//            print("mic permission authorized")
//            micMiniError.isHidden = true
//            isMicPermissionNotDetermined = false
////            break
//            return true
//        @unknown default:
//            micMiniError.isHidden = false
//            isMicPermissionNotDetermined = false
////            break
//            return false
//        }
//    }
//
//    //test > check storage permission
//    func checkCameraRollPermission(isToOpen: Bool) -> Bool {
//
//        //test 2 > check access status without requesting
////        if PHPhotoLibrary.authorizationStatus() == .authorized {
////            print("camrollStatus: Full access")
////            self.lhsMiniError.isHidden = true
////            return true
////        } else {
////            print("camrollStatus: Restricted or Denied")
////            self.lhsMiniError.isHidden = false
////            return false
////        }
//
//        switch PHPhotoLibrary.authorizationStatus() {
//
//        case .notDetermined:
//            print("storage permission not determined")
//            lhsMiniError.isHidden = false
//            lhsMiniAdd.isHidden = true
//
//            //test
//            isStoragePermissionNotDetermined = true
//            return false
//        case .restricted:
//            print("storage permission restricted")
//            //error msg for mic
//            lhsMiniError.isHidden = false
//            lhsMiniAdd.isHidden = true
//
//            isStoragePermissionNotDetermined = false
////            break
//            return false
//        case .limited:
//            print("storage permission limited")
//            //error msg for mic
//            lhsMiniError.isHidden = false
//            lhsMiniAdd.isHidden = true
//
//            isStoragePermissionNotDetermined = false
////            break
//            return false
//        case .denied:
//            print("storage permission denied")
//            //error msg for mic
//            lhsMiniError.isHidden = false
//            lhsMiniAdd.isHidden = true
//
//            isStoragePermissionNotDetermined = false
////            break
//            return false
//        case .authorized:
//            print("storage permission authorized")
//            lhsMiniError.isHidden = true
//            lhsMiniAdd.isHidden = false
//
//            isStoragePermissionNotDetermined = false
//
//            //test => open video album directly
//            if(isToOpen) {
//                openCameraRoll()
//            }
//
////            break
//            return true
//        @unknown default:
//            lhsMiniError.isHidden = false
//            lhsMiniAdd.isHidden = true
//
//            isStoragePermissionNotDetermined = false
////            break
//            return false
//        }
//    }
//
//    //test > request access
//    func requestCamAccess() {
//        if(isCamPermissionNotDetermined) {
//            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//                if granted {
//                    print("getcampermis cam: granted")
//
//                    DispatchQueue.main.async {
//                        self?.camMiniError.isHidden = true
//                        self?.isCamPermissionNotDetermined = false
//                        self?.setupCamera()
//
//                        //test
//                        self?.requestMicPermission()
//                    }
//                } else {
//                    // User denied camera permission
//                    print("getcampermis cam: deny")
//                }
//            }
//        } else {
//            openAppIOSPublicSetting()
//        }
//    }
//
//    func requestMicPermission() {
//        if(isMicPermissionNotDetermined) {
//            AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
//                if granted {
//                    print("getmicpermis cam: granted")
//                    DispatchQueue.main.async {
//                        self?.micMiniError.isHidden = true
//                        self?.isMicPermissionNotDetermined = false
//                    }
//                } else {
//                    print("getmicpermis cam: deny")
//                }
//            }
//        } else {
//            openAppIOSPublicSetting()
//        }
//    }
//
//    func requestStoragePermission() {
//        if(isStoragePermissionNotDetermined) {
//
//            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
//
//                // Handle restricted or denied state
//                if status == .restricted || status == .denied {
//                    print("photoStatus: Restricted or Denied")
//                }
//
//                // Handle limited state
//                if status == .limited {
//                    print("photoStatus: Limited")
//                }
//
//                // Handle authorized state
//                if status == .authorized {
//                    print("photoStatus: Full access")
//                    self?.openCameraRoll()
//                }
//            }
//        } else {
//            openAppIOSPublicSetting()
//        }
//    }
//
//    var videoDeviceInput : AVCaptureDeviceInput?
//    var currentCaptureDevice : AVCaptureDevice?
//    var frontDefaultCaptureDevice : AVCaptureDevice?
//    var backDefaultCaptureDevice : AVCaptureDevice?
//    var micDefaultCaptureDevice : AVCaptureDevice?
//    func setupCamera() {
//        //test > scan for capture devices availability
//        //.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera, .builtInTripleCamera, .builtInTelephotoCamera, .builtInDualWideCamera, .builtInUltraWideCamera], mediaType: .video, position: .unspecified)
//
//        for device in deviceDiscoverySession.devices {
//            //2 = front
//            //1 = back
//            //0 = unspecified
//            print("capture device \(device.position), \(device.deviceType)")
//            if device.position == .back {
//                backDefaultCaptureDevice = device
//            } else if device.position == .front {
//                frontDefaultCaptureDevice = device
//            }
//        }
//
//        //test > add inputs and output to session, default to FRONT camera
//        if let dDevice = frontDefaultCaptureDevice {
//            do {
//                let session = AVCaptureSession()
//
//                let camInput = try AVCaptureDeviceInput(device: dDevice)
//                if session.canAddInput(camInput) {
//                    session.addInput(camInput)
//                }
//
//                //test > add mic as input for sound ON
//                if let micDevice = AVCaptureDevice.default(for: .audio) {
//                    let micInput = try AVCaptureDeviceInput(device: micDevice)
//                    if session.canAddInput(micInput) {
//                        print("added mic input")
//                        session.addInput(micInput)
//                    }
//                }
//                //
//
//                if session.canAddOutput(output) {
//                    session.addOutput(output)
//
//                    //test > add connection to output here instead of at recording
//                    addConnectionToOutput()
//                }
//
//                previewLayer.videoGravity = .resizeAspectFill
//                previewLayer.session = session
//
//                session.startRunning()
//                self.session = session
//
//                //test > for switching camera input
//                currentCaptureDevice = frontDefaultCaptureDevice
//                videoDeviceInput = camInput
//            }
//            catch {
//                print(error)
//            }
//        }
//
//        //test > if default front camera is damaged, default to back camera or error msg
//    }
//
//    func addConnectionToOutput() {
//        //test > add connection to output here instead of at recording
//        let connection = output.connection(with: AVMediaType.video)
//
//        if (connection?.isVideoOrientationSupported)! {
////                connection?.videoOrientation = currentVideoOrientation()
//        }
//
//        if (connection?.isVideoStabilizationSupported)! {
//            connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
//        }
//        //
//    }
//
//    func switchCamera() {
//        session?.removeInput(videoDeviceInput!)
//
//        if let captureDevice = currentCaptureDevice {
//            if(captureDevice.position == .front) {
//                if let dDevice = backDefaultCaptureDevice {
//                    do {
//                        let input = try AVCaptureDeviceInput(device: dDevice)
//                        guard let session = session else {
//                            return
//                        }
//                        if session.canAddInput(input) {
//                            session.addInput(input)
//                        }
//
//                        //test > for switching camera input
//                        currentCaptureDevice = backDefaultCaptureDevice
//                        videoDeviceInput = input
//
//                        print("switched camera back")
//                    }
//                    catch {
//                        print(error)
//                    }
//                }
//            } else {
//                if let dDevice = frontDefaultCaptureDevice {
//                    do {
//                        let input = try AVCaptureDeviceInput(device: dDevice)
//                        guard let session = session else {
//                            return
//                        }
//                        if session.canAddInput(input) {
//                            session.addInput(input)
//                        }
//
//                        //test > for switching camera input
//                        currentCaptureDevice = frontDefaultCaptureDevice
//                        videoDeviceInput = input
//
//                        print("switched camera front")
//                    }
//                    catch {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
//
//    func resumeCamera() {
//
//        if let captureDevice = currentCaptureDevice {
//            do {
//                let input = try AVCaptureDeviceInput(device: captureDevice)
//                guard let session = session else {
//                    return
//                }
//                if session.canAddInput(input) {
//                    session.addInput(input)
//                }
//
//                //test > for switching camera input
//                videoDeviceInput = input
//
//                session.startRunning()
//                print("resume camera")
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
//
//    var outputURL: URL!
//    func startRecording() {
//        if output.isRecording == false {
//            print("start recording")
//
//            //addConnectionToOutput() //originally was added here, but when start record, camera blinks
//
//            outputURL = tempURL()
//            output.startRecording(to: outputURL, recordingDelegate: self)
//        }
//        else {
//            print("stop recording")
//            stopRecording()
//        }
//
//        changeUIRecording()
//    }
//
//    func stopRecording() {
//       if output.isRecording == true {
//           output.stopRecording()
//        }
//    }
//
//    func changeUIRecording() {
//        if output.isRecording == false {
//            startRecordingBtn.isHidden = true
//            pauseRecordingBtn.isHidden = false
//        } else {
//            startRecordingBtn.isHidden = false
//            pauseRecordingBtn.isHidden = true
//        }
//    }
//
//    func openCameraRoll() {
//        let cameraRollPanel = CameraVideoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(cameraRollPanel)
//        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
//        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        cameraRollPanel.delegate = self
//
//        pageList.append(cameraRollPanel)
//    }
//
////    func openVideoEditor(video: AVAsset) {
////        let videoEditorPanel = VideoEditorPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
////        panel.addSubview(videoEditorPanel)
////        videoEditorPanel.translatesAutoresizingMaskIntoConstraints = false
////        videoEditorPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
////        videoEditorPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
////        videoEditorPanel.delegate = self
////        videoEditorPanel.startVideoPreview(video: video)
////
////        pageList.append(videoEditorPanel)
////    }
//
//    //test > open video preview with url
//    func openVideoEditor(videoUrl: URL) {
//        let videoEditorPanel = VideoEditorPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(videoEditorPanel)
//        videoEditorPanel.translatesAutoresizingMaskIntoConstraints = false
//        videoEditorPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        videoEditorPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        videoEditorPanel.delegate = self
////        videoEditorPanel.startVideoPreview(videoUrl: videoUrl)
//        videoEditorPanel.initialize()
//        videoEditorPanel.preloadVideo(videoUrl: videoUrl)
//
//        pageList.append(videoEditorPanel)
//    }
//
//    func openVideoEditor(strVUrl: String) {
//        let videoEditorPanel = VideoEditorPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(videoEditorPanel)
//        videoEditorPanel.translatesAutoresizingMaskIntoConstraints = false
//        videoEditorPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        videoEditorPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        videoEditorPanel.delegate = self
//        videoEditorPanel.initialize()
////        videoEditorPanel.preloadVideo(videoUrl: videoUrl)
//        videoEditorPanel.preloadVideo(strVUrl: strVUrl)
//
//        pageList.append(videoEditorPanel)
//    }
//
//    //test > open finalizing video for caption and uploading
//    func openVideoFinalize() {
//        let videoFinalizePanel = VideoFinalizePanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(videoFinalizePanel)
//        videoFinalizePanel.translatesAutoresizingMaskIntoConstraints = false
//        videoFinalizePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        videoFinalizePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        videoFinalizePanel.delegate = self
//
//        pageList.append(videoFinalizePanel)
//    }
//
//    //test > get user permission to access location, camera, storage
//    func openLocationErrorPromptMsg() {
//        let locationPanel = GetLocationMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(locationPanel)
//        locationPanel.translatesAutoresizingMaskIntoConstraints = false
//        locationPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        locationPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
////        locationPanel.delegate = self
//    }
//    func openStorageErrorPromptMsg() {
//        let sPanel = GetStorageMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(sPanel)
//        sPanel.translatesAutoresizingMaskIntoConstraints = false
//        sPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        sPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        sPanel.delegate = self
//    }
//    func openCameraErrorPromptMsg() {
//        let sPanel = GetCameraMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(sPanel)
//        sPanel.translatesAutoresizingMaskIntoConstraints = false
//        sPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        sPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        sPanel.delegate = self
//    }
//
//    func backPage() {
//        if(!pageList.isEmpty) {
//            pageList.remove(at: pageList.count - 1)
//
//            //test > restart session when exit camera roll
//            if(pageList.isEmpty) {
////                self.session?.startRunning()
////                resumeCamera()
//            }
//        }
//    }
//
//    func backPage(at: Int) { //test
//        if(!pageList.isEmpty) {
//            pageList.remove(at: at)
//        }
//    }
//
//    //test > for location select
//    override func showLocationSelected() {
//        if(!pageList.isEmpty) {
//            let a = pageList[pageList.count - 1] as? VideoFinalizePanelView
//            a?.showLocationSelected(l: mapPinString)
//            print("showLocationSelected \(a)")
//        }
//
//    }
//
//
//    //file management for recording video
//    //temp file for recorded video
//    func tempURL() -> URL? {
//        let directory = NSTemporaryDirectory() as NSString
//
//        if directory != "" {
//            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
//            return URL(fileURLWithPath: path)
//        }
//
//        return nil
//    }
//
//    func checkFilesInTemp() {
//        let directory = NSTemporaryDirectory() as NSString
//        let directoryUrl = URL(fileURLWithPath: directory as String)
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
//
//            let count = fileURLs.count
//            print("temp files total: \(count)")
//
//            for url in fileURLs {
//                guard let compressedData = try? Data(contentsOf: url) else {
//                    return
//                }
//                print("temp file size 1: \(compressedData.count)")
//                print("temp file size: \(Double(Double(compressedData.count)/1048576))mb")
//            }
//
//        } catch {
//            print("Error while enumerating temp files \(directoryUrl.path): \(error.localizedDescription)")
//        }
//    }
//
//    func deleteTempFiles() {
//        let directory = NSTemporaryDirectory() as NSString
//        let directoryUrl = URL(fileURLWithPath: directory as String)
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
//
//            for url in fileURLs {
//                try? FileManager.default.removeItem(at: url)
//            }
//
//            print("temp files deleted")
//            checkFilesInTemp()
//        } catch {
//            print("Error while deleting temp files \(directoryUrl.path): \(error.localizedDescription)")
//        }
//    }
//}
//
//extension VideoCreatorConsolePanelView: CameraVideoRollPanelDelegate{
//    func didInitializeCameraVideoRoll() {
//        //test to turn off camera
////        session?.removeInput(videoDeviceInput!) //test
////        self.session?.stopRunning()
//    }
//    func didClickFinishCameraVideoRoll() {
//        backPage()
//
//        //test > recheck cameraroll permission and update UI
//        checkCameraRollPermission(isToOpen: false)
//    }
//    func didClickVideoSelect(video: PHAsset, cameraRollPanel: CameraVideoRollPanelView) {
////        openVideoEditor()
//
//        //test > convert PHAsset to AVAsset
//        PHCachingImageManager.default().requestAVAsset(forVideo: video, options: nil) { [weak self] (video, _, _) in
//
//            if let avVid = video
//            {
//                DispatchQueue.main.async {
//                    //test 1 > open with video asset => tested OK
////                    self?.openVideoEditor(video: avVid)
//
//                    //test 2 > open with url => tested OK
//                    //try get url from avasset
//                    if let strURL = (video as? AVURLAsset)?.url.absoluteString {
//                        print("VIDEO URL: ", strURL)
//
//                        if let s = self {
//                            print("openvideoeditor: \(s.pageList)")
//
//                            //test 1
////                            if (s.pageList.isEmpty) {
////                                s.openVideoEditor(strVUrl: strURL)
////                            } else {
////                                if let c = s.pageList[s.pageList.count - 1] as? VideoEditorPanelView {
////                                    c.addVideoClip(strVUrl: strURL)
////                                } else {
////                                    s.openVideoEditor(strVUrl: strURL)
////                                }
////                            }
////
//
//                            //test 2
//                            if (s.pageList.count > 1) {
//                                if let c = s.pageList[s.pageList.count - 1] as? CameraVideoRollPanelView {
//                                    c.removeFromSuperview()
//                                    s.backPage()
//
//                                    if let c = s.pageList[s.pageList.count - 1] as? VideoEditorPanelView {
//                                        c.addVideoClip(strVUrl: strURL)
//                                    }
//                                }
//                            } else {
//                                if let c = s.pageList[s.pageList.count - 1] as? CameraVideoRollPanelView {
//                                    s.openVideoEditor(strVUrl: strURL)
//                                }
//                            }
//
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension VideoCreatorConsolePanelView: AVCaptureFileOutputRecordingDelegate {
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//
////        session?.stopRunning() //have to restart camera session when back from video editor
//
//        if (error != nil) {
//            print("Error recording movie: \(error!.localizedDescription)")
//        } else {
//            let videoRecordedUrl = outputURL! as URL
//            print("Success recording movie: \(videoRecordedUrl)")
//
//            openVideoEditor(videoUrl: videoRecordedUrl)
//        }
//
//        //test > check number of temp files after recording
//        checkFilesInTemp()
//    }
//
//}
//
////test
//extension VideoCreatorConsolePanelView: GetCameraMsgDelegate{
//
//    func didGCClickProceed() {
//        //test > request cam access
////        if(isCamPermissionNotDetermined) {
////            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
////                if granted {
////                    print("getcampermis cam: granted")
////
////                    DispatchQueue.main.async {
////                        self?.setupCamera()
////                    }
////                } else {
////                    // User denied camera permission
////                    print("getcampermis cam: deny")
////                }
////            }
////        } else {
////            openAppIOSPublicSetting()
////        }
//
//        //test 2
//        requestCamAccess()
//    }
//    func didGCClickDeny() {
//
//    }
//}
//
////test
//extension VideoCreatorConsolePanelView: GetStorageMsgDelegate{
//
//    func didGSClickProceed() {
//
//    }
//    func didGSClickDeny() {
//
//    }
//}
//
//extension ViewController: VideoCreatorPanelDelegate{
//    func didInitializeVideoCreator() {
//
//    }
//
//    func didClickFinishVideoCreator() {
//        //test 1 > as not scrollable
//        backPage(isCurrentPageScrollable: false)
//
//        //test 2 > as scrollable
////        backPage(isCurrentPageScrollable: true)
//    }
//
//    func didVideoCreatorClickLocationSelectScrollable() {
//        openLocationSelectScrollablePanel()
//    }
//}

//**************Video processing function START***********
//
//test > copy from ddm-demo
//    var assetWriter:AVAssetWriter?
//    var assetReader:AVAssetReader?
////    let bitrate:NSNumber = NSNumber(value:250000)
//    let bitrate:NSNumber = NSNumber(value:1600000) //ori: 1000000
//    func compressFile(urlToCompress: AVAsset, completion:@escaping (URL)->Void){
//        //video file to make the asset
//
//        var audioFinished = false
//        var videoFinished = false
//
//        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
//            let url = documentsDirectoryURL.appendingPathComponent("temp_output_video_writer.mp4")
////        let url = documentsDirectoryURL.appendingPathComponent("temp_output_video_writer.mov")
//        try? FileManager.default.removeItem(at: url)
//
//        let outputURL = tempVideoWriterURL()
//
////            let asset = AVAsset(url: urlToCompress)
//
//        //create asset reader
//        do{
////                assetReader = try AVAssetReader(asset: asset)
//            assetReader = try AVAssetReader(asset: urlToCompress)
//        } catch{
//            assetReader = nil
//        }
//
//        guard let reader = assetReader else{
//            fatalError("Could not initalize asset reader probably failed its try catch")
//        }
//
//        let videoTrack = urlToCompress.tracks(withMediaType: AVMediaType.video).first!
//        let audioTrack = urlToCompress.tracks(withMediaType: AVMediaType.audio).first!
//
//        print("compressFile video size: \(videoTrack.naturalSize.width), \(videoTrack.naturalSize.height)")
//
//        let videoReaderSettings: [String:Any] =  [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32ARGB ]
//
//        // ADJUST BIT RATE OF VIDEO HERE
//
//        let videoSettings:[String:Any] = [
//            AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey:self.bitrate],
//            AVVideoCodecKey: AVVideoCodecType.h264,
//            AVVideoHeightKey: videoTrack.naturalSize.height,
//            AVVideoWidthKey: videoTrack.naturalSize.width
////            AVVideoHeightKey: 1280.0,
////            AVVideoWidthKey: 720.0
//        ]
//
//        let audioOutputSettingsDict: [String : Any] = [
//                    AVFormatIDKey: kAudioFormatLinearPCM,
//                    AVSampleRateKey: 44100
//        ]
//
//        let assetReaderVideoOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderSettings)
////        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)
//        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: audioOutputSettingsDict)
//
//        if reader.canAdd(assetReaderVideoOutput){
//            reader.add(assetReaderVideoOutput)
//        }else{
//            fatalError("Couldn't add video output reader")
//        }
//
//        if reader.canAdd(assetReaderAudioOutput){
//            reader.add(assetReaderAudioOutput)
//        }else{
//            fatalError("Couldn't add audio output reader")
//        }
//
//        //android bitrate 60000, sample rate 44100, dual channel
//        let audioInputSettingsDict: [String:Any] = [AVFormatIDKey : kAudioFormatMPEG4AAC,
//                                           AVNumberOfChannelsKey : 2,
//                                           AVSampleRateKey : 44100.0,
//                                           AVEncoderBitRateKey: 128000 // he uses 250000 in his code via self.bitRate
//        ]
//
////        let audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)
//        let audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioInputSettingsDict)
//        let videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
//        videoInput.transform = videoTrack.preferredTransform
//        //we need to add samples to the video input
//
//        let videoInputQueue = DispatchQueue(label: "videoQueue")
//        let audioInputQueue = DispatchQueue(label: "audioQueue")
//
//        do{
////            assetWriter = try AVAssetWriter(outputURL: outputURL!, fileType: AVFileType.mov)
//                assetWriter = try AVAssetWriter(outputURL: outputURL!, fileType: AVFileType.mp4)
//        }catch{
//            assetWriter = nil
//        }
//        guard let writer = assetWriter else{
//            fatalError("assetWriter was nil")
//        }
//
//        writer.shouldOptimizeForNetworkUse = true
//        writer.add(videoInput)
//        writer.add(audioInput)
//
//
//        writer.startWriting()
//        reader.startReading()
//        writer.startSession(atSourceTime: CMTime.zero)
//
//
//        let closeWriter:()->Void = {
//            if (audioFinished && videoFinished){
//                self.assetWriter?.finishWriting(completionHandler: {
//
////                        self.checkFileSize(sizeUrl: (self.assetWriter?.outputURL)!, message: "The file size of the compressed file is: ")
//
//                    completion((self.assetWriter?.outputURL)!)
//
//                })
//
//                self.assetReader?.cancelReading()
//
//            }
//        }
//
//
//        audioInput.requestMediaDataWhenReady(on: audioInputQueue) {
//            while(audioInput.isReadyForMoreMediaData){
//                let sample = assetReaderAudioOutput.copyNextSampleBuffer()
//                if (sample != nil){
//                    audioInput.append(sample!)
//                }else{
//                    audioInput.markAsFinished()
//                    DispatchQueue.main.async {
//                        audioFinished = true
//                        closeWriter()
//                    }
//                    break;
//                }
//            }
//        }
//
//        videoInput.requestMediaDataWhenReady(on: videoInputQueue) {
//            //request data here
//
//            while(videoInput.isReadyForMoreMediaData){
//                let sample = assetReaderVideoOutput.copyNextSampleBuffer()
//                if (sample != nil){
//                    videoInput.append(sample!)
//                }else{
//                    videoInput.markAsFinished()
//                    DispatchQueue.main.async {
//                        videoFinished = true
//                        closeWriter()
//                    }
//                    break;
//                }
//            }
//
//        }
//    }
//
//-tested OK
//test > video processing
//compress video using exportSession (not customizable)
//func compressVideo(inputAVAsset: AVAsset, handler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
//
//    let length = Float(inputAVAsset.duration.value) / Float(inputAVAsset.duration.timescale)
//    print("video length: \(length) seconds, \(Float(inputAVAsset.duration.value)), \(Float(inputAVAsset.duration.timescale))")
//
//    //AVAssetExportPresetMediumQuality - smaller size ut blurry
//    guard let exportSession = AVAssetExportSession(asset: inputAVAsset, presetName: AVAssetExportPresetHighestQuality) else {
//        handler(nil)
//        return
//    }
//
//    //remove previous file first
//    try? FileManager.default.removeItem(at: getVideoOutputURL())
//
//    //crop video with custom starttime and endtime
//    let startTime = CMTime(seconds: Double(0), preferredTimescale: 1000) //ori: 1
//    let endTime = CMTime(seconds: Double(1), preferredTimescale: 1000) //ori : 3
//    let timeRange = CMTimeRange(start: startTime, end: endTime)
//    exportSession.timeRange = timeRange
//    exportSession.outputURL = getVideoOutputURL()
//    exportSession.outputFileType = .mp4
//
//    //start exporting
//    exportSession.exportAsynchronously {
//        handler(exportSession)
//    }
//}
//
////split audio from video - to make sound
//func splitAudio(videoAsset: AVAsset) {
//
//    //get only audio track from video
//    let mixComposition = AVMutableComposition()
//    let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//    let audioVideoTrack:AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0]
//    do{
//        try audioCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioVideoTrack, at: CMTime.zero)
//    } catch{
//        print(error)
//    }
//
//    //remove previous file first
//    try? FileManager.default.removeItem(at: getSplitAudioOutputURL())
//
//    //start exporting
//    if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetPassthrough) {
//
//        exporter.outputURL = getSplitAudioOutputURL()
//        exporter.outputFileType = AVFileType.m4a
//        exporter.exportAsynchronously {
//            switch exporter.status {
//            case .unknown:
//                break
//            case .waiting:
//                break
//            case .exporting:
//                break
//            case .completed:
//                guard let compressedData = try? Data(contentsOf: self.getSplitAudioOutputURL()) else {
//                    return
//                }
//                print("outputURL file size 1: \(compressedData.count)")
//                print("outputURL file size: \(Double(Double(compressedData.count)/1048576))mb")
//
//            case .failed:
//                break
//            case .cancelled:
//                break
//            }
//        }
//    }
//}
//
////merge audio with video file
//func mergeVideoAudioTracks(videoAsset: AVAsset, inputAudioUrl: URL) {
//
//    //prepare video and audio tracks for processing
////        let videoAsset = AVURLAsset(url: inputVideoUrl)
//    let audioAsset = AVURLAsset(url: inputAudioUrl)
//
//    let mixComposition = AVMutableComposition()
//    var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
//    var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
//
//    let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
//    let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//
//    let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
//    let audioAssetTrack: AVAssetTrack = audioAsset.tracks(withMediaType: AVMediaType.audio)[0]
//
//    compositionAddVideo?.preferredTransform = videoAssetTrack.preferredTransform
//    mutableCompositionVideoTrack.append(compositionAddVideo!)
//    mutableCompositionAudioTrack.append(compositionAddAudio!)
//
//    //match timing, duration of video and audio tracks
//    //-to be customized further, as audio file could be shorter or longer than video
//    do {
//       try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,duration: videoAssetTrack.timeRange.duration), of: videoAssetTrack, at: CMTime.zero)
//
//       try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,duration: videoAssetTrack.timeRange.duration), of: audioAssetTrack, at: CMTime.zero)
//    }
//    catch {
//           print(error.localizedDescription)
//    }
//
//    //remove previous file first
//    try? FileManager.default.removeItem(at: getVideoOutputURL())
//
//    if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality) {
//        exporter.outputURL = getVideoOutputURL()
//        exporter.outputFileType = AVFileType.mp4
//        exporter.exportAsynchronously {
//            switch exporter.status {
//            case .unknown:
//                break
//            case .waiting:
//                break
//            case .exporting:
//                break
//            case .completed:
//                guard let compressedData = try? Data(contentsOf: self.getVideoOutputURL()) else {
//                    return
//                }
//                print("merge outputURL file size 1: \(compressedData.count)")
//                print("merge outputURL file size: \(Double(Double(compressedData.count)/1048576))mb")
//
//            case .failed:
//                break
//            case .cancelled:
//                break
//            }
//        }
//    }
//}
//
////produce GIF from video
//func produceGifFromVideo(videoUrl: URL) {
//
//    let asset = AVURLAsset(url: videoUrl)
//    guard let reader = try? AVAssetReader(asset: asset) else {
//        return
//    }
//    guard let videoTrack = asset.tracks(withMediaType: .video).first else {
//        return
//    }
////        let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
//
//    //to get transformed rotation degree
//    let transform = videoTrack.preferredTransform
//    let radians = atan2(transform.b, transform.a)
//    let degrees = (radians * 180.0) / .pi
//
//    let videoSize = videoTrack.naturalSize
////        let resultingSize: CGSize = {
////            return CGSize(width: videoSize.width, height: videoSize.height)
////        }()
//
//    let cappedResolution: CGFloat = 320.0 //ori 240...200(200 is too blur and small)
//
//    let videoWidth = abs(videoSize.width)
//    let videoHeight = abs(videoSize.height)
//    let aspectRatio = videoWidth / videoHeight
//
//    let resultingSize: CGSize = {
//
//        if videoWidth > videoHeight {
//            let cappedWidth = round(min(cappedResolution, videoWidth))
//            return CGSize(width: cappedWidth, height: round(cappedWidth / aspectRatio))
//        } else {
//            let cappedHeight = round(min(cappedResolution, videoHeight))
//            print("gifVideo resulting size: \(cappedHeight), \(round(cappedHeight * aspectRatio))")
//            return CGSize(width: round(cappedHeight * aspectRatio), height: cappedHeight)
//        }
//    }()
//
//    let duration: CGFloat = CGFloat(asset.duration.seconds)
//    let nominalFrameRate = CGFloat(videoTrack.nominalFrameRate)
//    let nominalTotalFrames = Int(round(duration * nominalFrameRate))
//    let desiredFrameRate: CGFloat = 5.0 //ori 30, 15
//
//    print("gifVideo: \(duration), \(nominalFrameRate), \(nominalTotalFrames)")
//
//    let framesToRemove: [Int] = {
//        // Ensure the actual/nominal frame rate isn't already lower than the desired, in which case don't even worry about it
//        if desiredFrameRate < nominalFrameRate {
//            let percentageOfFramesToRemove = 1.0 - (desiredFrameRate / nominalFrameRate)
//            let totalFramesToRemove = Int(round(CGFloat(nominalTotalFrames) * percentageOfFramesToRemove))
//
//            // We should remove a frame every `frameRemovalInterval` frames…
//            // Since we can't remove e.g.: the 3.7th frame, round that up to 4, and we'd remove the 4th frame, then the 7.4th -> 7th, etc.
//            let frameRemovalInterval = CGFloat(nominalTotalFrames) / CGFloat(totalFramesToRemove)
//            var framesToRemove: [Int] = []
//
//            var sum: CGFloat = 0.0
//
//            while sum <= CGFloat(nominalTotalFrames) {
//                sum += frameRemovalInterval
//                let roundedFrameToRemove = Int(round(sum))
//                framesToRemove.append(roundedFrameToRemove)
//            }
//
//            return framesToRemove
//        } else {
//            return []
//        }
//    }()
//
//    let totalFrames = nominalTotalFrames - framesToRemove.count
//
//    let outputSettings: [String: Any] = [
//        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
//        kCVPixelBufferWidthKey as String: resultingSize.width,
//        kCVPixelBufferHeightKey as String: resultingSize.height
//    ]
//
//    let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: outputSettings)
//
//    reader.add(readerOutput)
//    reader.startReading()
//
//    var sample: CMSampleBuffer? = readerOutput.copyNextSampleBuffer()
//
//    let delayBetweenFrames: CGFloat = 1.0 / min(desiredFrameRate, nominalFrameRate)
//
//    print("gifVideo Nominal total frames: \(nominalTotalFrames), totalFramesUsed: \(totalFrames), totalFramesToRemove: \(framesToRemove.count), nominalFrameRate: \(nominalFrameRate), delayBetweenFrames: \(delayBetweenFrames)")
//
//    let fileProperties: [String: Any] = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFLoopCount as String: 0
//        ]
//    ]
//
//    let frameProperties: [String: Any] = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFDelayTime: delayBetweenFrames
//        ]
//    ]
//
//    //remove previous file first
//    try? FileManager.default.removeItem(at: getGifOutputURL())
//
//    guard let destination = CGImageDestinationCreateWithURL(getGifOutputURL() as CFURL, UTType.gif.identifier as CFString, totalFrames, nil) else {
//        return
//    }
//
//    CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
//
//    let operationQueue = OperationQueue()
//    operationQueue.maxConcurrentOperationCount = 1
//
//    var framesCompleted = 0
//    var currentFrameIndex = 0
//
//    while (sample != nil) {
//        currentFrameIndex += 1
//
//        if framesToRemove.contains(currentFrameIndex) {
//            sample = readerOutput.copyNextSampleBuffer()
//            continue
//        }
//
//        if let newSample = sample {
//            //loop through video and extract frame as image, then integrate images into GIF file
//            // Create it as an optional and manually nil it out every time it's finished otherwise weird Swift bug where memory will balloon enormously (see https://twitter.com/ChristianSelig/status/1241572433095770114)
////                var cgImage: CGImage? = self.cgImageFromSampleBuffer(newSample, degrees)
//            var cgImage: CGImage? = self.cgImageFromSampleBuffer(newSample, rotationDegree: degrees)
//
//            operationQueue.addOperation {
//                framesCompleted += 1
//
//                if let cgImage = cgImage {
////                        CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
//
//                    if(framesCompleted <= totalFrames) {
//                        CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
//                    }
//                }
//
//                cgImage = nil
//
//                let progress = CGFloat(framesCompleted) / CGFloat(totalFrames)
//
//                // GIF progress is a little fudged so it works with downloading progress reports
//                let progressToReport = Int(progress * 100.0)
//                print("gifvideo % \(progressToReport)")
//            }
//        }
//
//        sample = readerOutput.copyNextSampleBuffer()
//    }
//
//    operationQueue.waitUntilAllOperationsAreFinished()
//
//    print("gifVideo finalizing: \(framesCompleted), \(totalFrames)")
//    let didCreateGIF = CGImageDestinationFinalize(destination)
//
//    guard didCreateGIF else {
//        return
//    }
//
//    print("gifVideo completed")
////        DispatchQueue.main.async {
////            print("gifVideo completed")
////        }
//}
//
//private func cgImageFromSampleBuffer(_ buffer: CMSampleBuffer, rotationDegree: CGFloat) -> CGImage? {
//    guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
//        return nil
//    }
//
//    CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
//
//    let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
//    let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
//
//    let width = CVPixelBufferGetWidth(pixelBuffer)
//    let height = CVPixelBufferGetHeight(pixelBuffer)
//
//    print("gifVideo image: \(width), \(height)")
//
//    guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else { return nil }
//
//    let image = context.makeImage()
////
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
////        return image
//
////        let newImage = createMatchingBackingDataWithImage(imageRef: image)
////        return newImage
//
//    if(rotationDegree == 0.0) {
////            let image = context.makeImage()
////            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
//        return image
//    } else {
//        let newImage = createMatchingBackingDataWithImage(imageRef: image, rotationDegree: rotationDegree)
//        return newImage
//    }
//
//}
//
////test to flip, transform CGImage
//func createMatchingBackingDataWithImage(imageRef: CGImage?, rotationDegree: CGFloat) -> CGImage? {
//    var orientedImage: CGImage?
//
//    if let imageRef = imageRef {
//        let originalWidth = imageRef.width
//        let originalHeight = imageRef.height
//        let bitsPerComponent = imageRef.bitsPerComponent
//        let bytesPerRow = imageRef.bytesPerRow
//
//        let colorSpace = imageRef.colorSpace
//        let bitmapInfo = imageRef.bitmapInfo
//
//        var degreesToRotate: Double
//        var swapWidthHeight: Bool
//        var mirrored: Bool
//
//        if(rotationDegree == 90.0) {
//            degreesToRotate = -90.0 //negative is clockwise, positive is counterclockwise
//            swapWidthHeight = true
//        } else if (rotationDegree == -90.0) {
//            degreesToRotate = 90.0 //negative is clockwise, positive is counterclockwise
//            swapWidthHeight = true
//        } else {
//            degreesToRotate = Double(rotationDegree)
//            swapWidthHeight = false
//        }
//
//        //****Need to test for landscape
////            swapWidthHeight = true
//        mirrored = false
//
//
////            switch orienation {
////            case .up:
////                degreesToRotate = 0.0
////                swapWidthHeight = false
////                mirrored = false
////                break
////            case .upMirrored:
////                degreesToRotate = 0.0
////                swapWidthHeight = false
////                mirrored = true
////                break
////            case .right:
////                degreesToRotate = 90.0
////                swapWidthHeight = true
////                mirrored = false
////                break
////            case .rightMirrored:
////                degreesToRotate = 90.0
////                swapWidthHeight = true
////                mirrored = true
////                break
////            case .down:
////                degreesToRotate = 180.0
////                swapWidthHeight = false
////                mirrored = false
////                break
////            case .downMirrored:
////                degreesToRotate = 180.0
////                swapWidthHeight = false
////                mirrored = true
////                break
////            case .left:
////                degreesToRotate = -90.0
////                swapWidthHeight = true
////                mirrored = false
////                break
////            case .leftMirrored:
////                degreesToRotate = -90.0
////                swapWidthHeight = true
////                mirrored = true
////                break
////            }
//        let radians = degreesToRotate * Double.pi / 180
//
//        var width: Int
//        var height: Int
//        if swapWidthHeight {
//            width = originalHeight
//            height = originalWidth
//        } else {
//            width = originalWidth
//            height = originalHeight
//        }
//
//        if let contextRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue) {
//
//            contextRef.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
//            if mirrored {
//                contextRef.scaleBy(x: -1.0, y: 1.0)
//            }
//            contextRef.rotate(by: CGFloat(radians))
//            if swapWidthHeight {
//                contextRef.translateBy(x: -CGFloat(height) / 2.0, y: -CGFloat(width) / 2.0)
//            } else {
//                contextRef.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
//            }
//            contextRef.draw(imageRef, in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))
//
//            orientedImage = contextRef.makeImage()
//        }
//    }
//
//    return orientedImage
//}
//
////produce cover thumbnail from video
////ori: generateThumbnail()
////    func produceCoverImageFromVideo(videoUrl: URL) -> UIImage? {
//func produceCoverImageFromVideo(videoUrl: URL) {
//    do {
//        //generate image from image generator
//        let asset = AVURLAsset(url: videoUrl)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        imageGenerator.appliesPreferredTrackTransform = true
//
//        // Swift 4.2
//        let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
//
//        //remove previous version
//        try? FileManager.default.removeItem(at: getCoverImageOutputURL())
//
//        do {
//            print("generate thumbnail trying")
//            try UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.90)?.write(to: getCoverImageOutputURL(), options: .atomic)
//        } catch {
//            print(error)
//        }
//
//        print("generate thumbnail done")
////            return UIImage(cgImage: cgImage)
//    } catch {
//        print(error.localizedDescription)
////            return nil
//    }
//}
//**************Video processing function END***********


//test > **ORIGINAL
//protocol VideoEditorPanelDelegate : AnyObject {
//    func didInitializeVideoEditor()
//    func didClickFinishVideoEditor()
//    func didClickNextVideoEditor()
//    func didPromptExitVideoEditor()
//    func didDenyExitVideoEditor()
//}
//
//class VideoEditorPanelView: PanelView{
//
//    var viewHeight: CGFloat = 0
//    var viewWidth: CGFloat = 0
//
//    var panel = UIView()
//    var currentPanelTopCons : CGFloat = 0.0
//    var panelTopCons: NSLayoutConstraint?
//
//    let videoContainer = UIView()
//    var player: AVPlayer?
//
//    let playVideoView = UIView()
//    let pauseVideoView = UIView()
//    let playBtn = UIImageView()
//    let pauseBtn = UIImageView()
//
//    var videoAsset: AVAsset?
//    var playerLayer : AVPlayerLayer?
//
//    weak var delegate : VideoEditorPanelDelegate?
//
//    var isVideoEditorInitialized = false
//
//    //test > progress
//    var progressCenterXCons: NSLayoutConstraint?
//
//    //test > varied video preview width and height
//    var videoWidthLayoutConstraint: NSLayoutConstraint?
//    var videoHeightLayoutConstraint: NSLayoutConstraint?
//
//    private let fileManager = FileManager.default
//    private lazy var mainDirectoryUrl: URL = {
//        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            return documentsUrl
//        //.cachesDirectory is only for short term storage
//    }()
//
//    var timelineXCons: NSLayoutConstraint?
//    var currentTimelineXCons : CGFloat = 0.0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        viewWidth = frame.width
//        viewHeight = frame.height
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setupViews()
//    }
//
//    func setupViews() {
//        panel.backgroundColor = .ddmBlackOverlayColor
//        self.addSubview(panel)
//        panel.translatesAutoresizingMaskIntoConstraints = false
//        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        panel.layer.masksToBounds = true
//        panel.layer.cornerRadius = 10 //10
//        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
//        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
//        panelTopCons?.isActive = true
//
//        let aBtn = UIView()
////        aBtn.backgroundColor = .ddmDarkColor
//        panel.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
////        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
////        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
////        let topInsetMargin = panel.safeAreaInsets.top + 10
//        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
//        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVideoEditorPanelClicked)))
//
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .white
////        aStickyHeader.addSubview(bMiniBtn)
//        panel.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//
//        panel.addSubview(videoContainer)
//        let width = 150.0
//        let height = width * 16 / 9
//        videoContainer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        videoContainer.translatesAutoresizingMaskIntoConstraints = false
//        videoContainer.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 30).isActive = true
//        videoWidthLayoutConstraint = videoContainer.widthAnchor.constraint(equalToConstant: width)
//        videoWidthLayoutConstraint?.isActive = true
//        videoHeightLayoutConstraint = videoContainer.heightAnchor.constraint(equalToConstant: height)
//        videoHeightLayoutConstraint?.isActive = true
////        videoContainer.widthAnchor.constraint(equalToConstant: width).isActive = true
////        videoContainer.heightAnchor.constraint(equalToConstant: height).isActive = true
//        videoContainer.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        videoContainer.clipsToBounds = true
//        videoContainer.layer.cornerRadius = 10
//        videoContainer.backgroundColor = .black
//
//        pauseBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
//        pauseBtn.tintColor = .white
//        panel.addSubview(pauseBtn)
//        pauseBtn.translatesAutoresizingMaskIntoConstraints = false
//        pauseBtn.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 10).isActive = true
//        pauseBtn.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        pauseBtn.isHidden = false
//        pauseBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        pauseBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        pauseBtn.isUserInteractionEnabled = true
//        pauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideoClicked)))
//
//        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//        playBtn.tintColor = .white
//        panel.addSubview(playBtn)
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        playBtn.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 10).isActive = true
//        playBtn.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        playBtn.isHidden = true
//        playBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        playBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        playBtn.isUserInteractionEnabled = true
//        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeVideoClicked)))
//
//
//        //test > simple progress slider
//        let progress = UIView()
//        panel.addSubview(progress)
//        progress.translatesAutoresizingMaskIntoConstraints = false
//        progress.topAnchor.constraint(equalTo: playBtn.bottomAnchor, constant: 10).isActive = true
//        progressCenterXCons = progress.centerXAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 0)
//        progressCenterXCons?.isActive = true
//        progress.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        progress.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        progress.layer.cornerRadius = 5
//        progress.backgroundColor = .white
//
//
//        //test > various functionality for video edit
//        let eGrid = UIView()
//        eGrid.backgroundColor = .red
//        panel.addSubview(eGrid)
//        eGrid.translatesAutoresizingMaskIntoConstraints = false
//        eGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        eGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        eGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        eGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
//        eGrid.layer.cornerRadius = 10
//        eGrid.isUserInteractionEnabled = true
//        eGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAPhotoClicked)))
//
//        let fGrid = UIView()
//        fGrid.backgroundColor = .blue
//        panel.addSubview(fGrid)
//        fGrid.translatesAutoresizingMaskIntoConstraints = false
//        fGrid.leadingAnchor.constraint(equalTo: eGrid.trailingAnchor, constant: 20).isActive = true
//        fGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        fGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        fGrid.topAnchor.constraint(equalTo: eGrid.topAnchor, constant: 0).isActive = true
//        fGrid.layer.cornerRadius = 10
//        fGrid.isUserInteractionEnabled = true
//        fGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBPhotoClicked)))
//
//        let gGrid = UIView()
//        gGrid.backgroundColor = .yellow
//        panel.addSubview(gGrid)
//        gGrid.translatesAutoresizingMaskIntoConstraints = false
//        gGrid.leadingAnchor.constraint(equalTo: fGrid.trailingAnchor, constant: 20).isActive = true
//        gGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        gGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        gGrid.topAnchor.constraint(equalTo: fGrid.topAnchor, constant: 0).isActive = true
//        gGrid.layer.cornerRadius = 10
//        gGrid.isUserInteractionEnabled = true
//        gGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCPhotoClicked)))
//
//        //test > preview GIF and thumbnail for compressed video
//        let gifImage = SDAnimatedImageView()
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.layer.masksToBounds = true
//        gifImage.sd_setImage(with: getGifOutputURL())
//        panel.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
////        gifImage.leadingAnchor.constraint(equalTo: eGrid.leadingAnchor).isActive = true
////        gifImage.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        gifImage.leadingAnchor.constraint(equalTo: gGrid.trailingAnchor, constant: 20).isActive = true
//        gifImage.topAnchor.constraint(equalTo: gGrid.topAnchor, constant: 0).isActive = true
//        gifImage.heightAnchor.constraint(equalToConstant: 90).isActive = true //ori 30
//        gifImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        gifImage.layer.cornerRadius = 10
//
//        let thumbImage = SDAnimatedImageView()
//        thumbImage.contentMode = .scaleAspectFill
//        thumbImage.layer.masksToBounds = true
//        thumbImage.sd_setImage(with: getCoverImageOutputURL())
//        panel.addSubview(thumbImage)
//        thumbImage.translatesAutoresizingMaskIntoConstraints = false
////        thumbImage.leadingAnchor.constraint(equalTo: gifImage.trailingAnchor, constant: 20).isActive = true
////        thumbImage.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        thumbImage.leadingAnchor.constraint(equalTo: gifImage.trailingAnchor, constant: 20).isActive = true
//        thumbImage.topAnchor.constraint(equalTo: gifImage.topAnchor, constant: 0).isActive = true
//        thumbImage.heightAnchor.constraint(equalToConstant: 90).isActive = true //ori 30
//        thumbImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        thumbImage.layer.cornerRadius = 10
//
//        let aNext = UIView()
//        aNext.backgroundColor = .yellow
//    //        aFollow.backgroundColor = .ddmGoldenYellowColor
//        panel.addSubview(aNext)
//        aNext.translatesAutoresizingMaskIntoConstraints = false
//        aNext.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
//        aNext.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aNext.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
//        aNext.layer.cornerRadius = 10
//        aNext.isUserInteractionEnabled = true
//        aNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoEditorNextClicked)))
//
//        let aNextText = UILabel()
//        aNextText.textAlignment = .center
//        aNextText.textColor = .black
//        aNextText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aNextText)
//        aNextText.translatesAutoresizingMaskIntoConstraints = false
////        aNextText.centerXAnchor.constraint(equalTo: aNext.centerXAnchor).isActive = true
//        aNextText.centerYAnchor.constraint(equalTo: aNext.centerYAnchor).isActive = true
//        aNextText.leadingAnchor.constraint(equalTo: aNext.leadingAnchor, constant: 25).isActive = true //15
//        aNextText.trailingAnchor.constraint(equalTo: aNext.trailingAnchor, constant: -25).isActive = true
//        aNextText.text = "Next"
//
//        //test > list out files
//        createDirectoryForDraft() //create draft folder
//        checkFilesInFolder()
//
//
//        //test > timeline videoframes
//        let timelineBoxView = UIView()
//        panel.addSubview(timelineBoxView)
//        timelineBoxView.backgroundColor = .blue
//        timelineBoxView.translatesAutoresizingMaskIntoConstraints = false
//        timelineBoxView.heightAnchor.constraint(equalToConstant: 150).isActive = true //ori 60
//        timelineXCons = timelineBoxView.leadingAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0)
//        timelineXCons?.isActive = true
////        timelineBoxView.leadingAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        timelineBoxView.widthAnchor.constraint(equalToConstant: 400).isActive = true
//        timelineBoxView.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//
//        let timelinePanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTimelinePanGesture))
//        self.addGestureRecognizer(timelinePanGesture)
//
//        let tabScrollView = UIScrollView()
////        panel.addSubview(tabScrollView)
//        timelineBoxView.addSubview(tabScrollView)
////        tabScrollView.backgroundColor = .blue
//        tabScrollView.backgroundColor = .clear
//        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
//        tabScrollView.heightAnchor.constraint(equalToConstant: 50).isActive = true //ori 60
//        tabScrollView.widthAnchor.constraint(equalToConstant: 200).isActive = true
////        tabScrollView.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
////        tabScrollView.leadingAnchor.constraint(equalTo: eGrid.leadingAnchor, constant: 0).isActive = true
//        tabScrollView.topAnchor.constraint(equalTo: timelineBoxView.topAnchor, constant: 0).isActive = true
//        tabScrollView.leadingAnchor.constraint(equalTo: timelineBoxView.leadingAnchor, constant: 0).isActive = true
//        tabScrollView.showsHorizontalScrollIndicator = false
//        tabScrollView.alwaysBounceHorizontal = true //test
////        tabScrollView.bounces = false
//
////        let t1Frame = SDAnimatedImageView()
//        t1Frame.contentMode = .scaleAspectFill
//        t1Frame.layer.masksToBounds = true
////        t1Frame.sd_setImage(with: getCoverImageOutputURL())
////        panel.addSubview(t1Frame)
//        tabScrollView.addSubview(t1Frame)
//        t1Frame.translatesAutoresizingMaskIntoConstraints = false
////        t1Frame.leadingAnchor.constraint(equalTo: eGrid.leadingAnchor, constant: 0).isActive = true
////        t1Frame.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        t1Frame.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
//        t1Frame.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor).isActive = true
//        t1Frame.heightAnchor.constraint(equalToConstant: 50).isActive = true //ori 90
//        t1Frame.widthAnchor.constraint(equalToConstant: 50).isActive = true
////        t1Frame.layer.cornerRadius = 10
//
////        let t2Frame = SDAnimatedImageView()
//        t2Frame.contentMode = .scaleAspectFill
//        t2Frame.layer.masksToBounds = true
////        t1Frame.sd_setImage(with: getCoverImageOutputURL())
////        panel.addSubview(t2Frame)
//        tabScrollView.addSubview(t2Frame)
//        t2Frame.translatesAutoresizingMaskIntoConstraints = false
////        t2Frame.leadingAnchor.constraint(equalTo: t1Frame.trailingAnchor, constant: 0).isActive = true
////        t2Frame.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        t2Frame.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
//        t2Frame.leadingAnchor.constraint(equalTo: t1Frame.trailingAnchor).isActive = true
//        t2Frame.heightAnchor.constraint(equalToConstant: 50).isActive = true //ori 90
//        t2Frame.widthAnchor.constraint(equalToConstant: 50).isActive = true
////        t2Frame.layer.cornerRadius = 10
//
////        let t3Frame = SDAnimatedImageView()
//        t3Frame.contentMode = .scaleAspectFill
//        t3Frame.layer.masksToBounds = true
////        t3Frame.sd_setImage(with: getCoverImageOutputURL())
////        panel.addSubview(t3Frame)
//        tabScrollView.addSubview(t3Frame)
//        t3Frame.translatesAutoresizingMaskIntoConstraints = false
////        t3Frame.leadingAnchor.constraint(equalTo: t2Frame.trailingAnchor, constant: 0).isActive = true
////        t3Frame.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//        t3Frame.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
//        t3Frame.leadingAnchor.constraint(equalTo: t2Frame.trailingAnchor).isActive = true
//        t3Frame.heightAnchor.constraint(equalToConstant: 50).isActive = true //ori 90
//        t3Frame.widthAnchor.constraint(equalToConstant: 50).isActive = true
////        t3Frame.layer.cornerRadius = 10
//
//        let timelineCenterLine = UIView()
//        panel.addSubview(timelineCenterLine)
//        timelineCenterLine.backgroundColor = .white
//        timelineCenterLine.translatesAutoresizingMaskIntoConstraints = false
//        timelineCenterLine.heightAnchor.constraint(equalToConstant: 300).isActive = true //ori 60
//        timelineCenterLine.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        timelineCenterLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        timelineCenterLine.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 10).isActive = true
//    }
//
//    var dd = 0.0
//    @objc func onTimelinePanGesture(gesture: UIPanGestureRecognizer) {
//        if(gesture.state == .began) {
//            print("timeline onPan start: ")
//            currentTimelineXCons = timelineXCons!.constant
//
//            //test > pause video when pan on timeline
//            pauseVideo()
//
//        } else if(gesture.state == .changed) {
//            let translation = gesture.translation(in: self)
//            let x = translation.x
//            let y = translation.y
//
//            let yy = currentTimelineXCons + x
////            timelineXCons?.constant = currentTimelineXCons + x
//            print("timeline onPan change: \(yy)")
//
//            if(yy >= 0) {
//                timelineXCons?.constant = 0
//            } else {
//                if(yy <= -150) {
//                    timelineXCons?.constant = -150
//                } else {
//                    timelineXCons?.constant = yy
//
//                    let cT = (yy * (-dd))/150
////                    let seekTime = CMTime(seconds: 0.1, preferredTimescale: 1)
//                    let seekTime = CMTime(seconds: cT, preferredTimescale: 1)
//                    player?.seek(to: seekTime)
//                }
//            }
//
//        } else if(gesture.state == .ended){
//
//            print("timeline onPan end: ")
//        }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print("videoeditor layoutsubview: \(videoContainer.bounds)")
//
//        //test > initialize video editor
//        if(!isVideoEditorInitialized) {
//            isVideoEditorInitialized = true
//
//            delegate?.didInitializeVideoEditor()
//        }
//    }
//
//    @objc func onBackVideoEditorPanelClicked(gesture: UITapGestureRecognizer) {
////        closeVideoEditorPanel(isAnimated: true)
//
//        openExitVideoEditorPromptMsg()
//
////        delegate?.didPromptExitVideoEditor()
//    }
//
//    @objc func onPauseVideoClicked(gesture: UITapGestureRecognizer) {
//
////        pauseBtn.isHidden = true
////        playBtn.isHidden = false
//        pauseVideo()
//    }
//    @objc func onResumeVideoClicked(gesture: UITapGestureRecognizer) {
//
////        pauseBtn.isHidden = false
////        playBtn.isHidden = true
//        resumeVideo()
//    }
//
//    @objc func onVideoEditorNextClicked(gesture: UITapGestureRecognizer) {
//
//        pauseVideo()
//
//        //test > finalize video for uploading
//        delegate?.didClickNextVideoEditor()
//    }
//
//    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
//        guard let videoAsset = videoAsset else {
//            return
//        }
//        compressVideo(inputAVAsset: videoAsset) { exportSession in
//            print("video compress done")
//        }
//    }
//
//    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
//
//        //test 1 > redo video preview
//        configureVideoPreview()
//
//        //test 2 > remove cover image file
////        try? FileManager.default.removeItem(at: getCoverImageOutputURL())
//
//        //test 3 > remove compressed video file
////        try? FileManager.default.removeItem(at: getVideoOutputURL())
//
//        //test 4 > try remove cache for gif
////        SDImageCache.shared.removeImage(forKey: getGifOutputURL().description, withCompletion: nil)
//
//        //test 5 > try remove cache for cover image
////        SDImageCache.shared.removeImage(forKey: getCoverImageOutputURL().description, withCompletion: nil)
//    }
//    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
//        //test 1 > watermark with raw av video asset
////        guard let videoAsset = videoAsset else {
////            return
////        }
////        addWatermarkToVideo(videoAsset: videoAsset)
//
//        //test 2 > watermark with outputfile
////        addWatermarkToVideo(outputFileURL: getVideoOutputURL())
//
//        //test 3 > split audio
////        splitAudio(videoAsset: videoAsset)
//
//        //test 4 > merge video and audio files
////        mergeVideoAudioTracks(videoAsset: videoAsset, inputAudioUrl: getSplitAudioOutputURL())
//
//        //test 5 > produce gif from compressed video
////        produceGifFromVideo(videoUrl: getVideoOutputURL())
//
//        //test 6 > produce cover image from compressed video
////        produceCoverImageFromVideo(videoUrl: getVideoOutputURL())
//
//        //test 7 > try overlay
////        overlayLayerOnVideo(videoUrl: getVideoOutputURL())
//
//        //test 8 > try varied video preview size
////        print("video change size")
////        let width = 350.0
////        let height = width * 16 / 9
////        videoWidthLayoutConstraint?.constant = width
////        videoHeightLayoutConstraint?.constant = height
////
////        playerLayer?.frame = CGRect(x: 0, y: 0, width: width, height: height)
//
//
//        //test 9 > try blur out effect => failed, video inverted again
////        blurOutEffectOnVideo(videoUrl: getVideoOutputURL())
//    }
//
//    func closeVideoEditorPanel(isAnimated: Bool) {
//        if(isAnimated) {
//            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
////                self.panelLeadingCons?.constant = self.frame.width
//                self.panelTopCons?.constant = 0
//                self.layoutIfNeeded()
//            }, completion: { _ in
//                self.stopVideo()
//
//                //test > remove time observer
//                self.removeTimeObserver()
//
//                self.removeFromSuperview()
//
//                //move back to origin
//                self.delegate?.didClickFinishVideoEditor()
//            })
//        } else {
//            self.stopVideo()
//
//            //test > remove time observer
//            self.removeTimeObserver()
//
//            self.removeFromSuperview()
//
//            //move back to origin
//            self.delegate?.didClickFinishVideoEditor()
//        }
//    }
//
//    func configureVideoPreview() {
//
//        //test > remove player layer
//        stopVideo()
//        playerLayer?.removeFromSuperlayer()
//        playerLayer?.player = nil
//
//        //test ** try replaceCurrentItem for avPlayer
//        //TODO:
//
//        //test 2 > try to view edited output video file
////        player = AVPlayer(url: getVideoOutputURL())
//
//        //test 3 > try to preview split audio
////        player = AVPlayer(url: getSplitAudioOutputURL())
//
//        //test 4 > try to preview overlayed video
////        player = AVPlayer(url: getOverlayVideoOutputURL())
//
//        //test 5 > try to preview blurout video
//        player = AVPlayer(url: getBlurOutVideoOutputURL())
//
//        let playerView = AVPlayerLayer()
//        playerView.player = player
//        playerView.frame = videoContainer.bounds
//        playerView.videoGravity = .resizeAspectFill
//        videoContainer.layer.addSublayer(playerView)
//
//        playVideo()
//
//        //test
//        playerLayer = playerView
//
//    }
//
//    func startVideoPreview(video: AVAsset) {
//        //test
//        videoAsset = video
//
//        let playerItem = AVPlayerItem(asset: video)
//        player = AVPlayer(playerItem: playerItem)
//        let playerView = AVPlayerLayer()
//        playerView.player = player
//        playerView.frame = videoContainer.bounds
//        playerView.videoGravity = .resizeAspectFill
//        videoContainer.layer.addSublayer(playerView)
//
//        playVideo()
//
//        //test
//        playerLayer = playerView
//
//        //test > check preferred transform of video
//        getVideoPreferredTransform(video: video)
//
//    }
//
//    func startVideoPreview(videoUrl: URL) {
//
//        player = AVPlayer(url: videoUrl)
//        let playerView = AVPlayerLayer()
//        playerView.player = player
//        playerView.frame = videoContainer.bounds
//        playerView.videoGravity = .resizeAspectFill
//        videoContainer.layer.addSublayer(playerView)
//
//        playVideo()
//
//        //test
//        playerLayer = playerView
//
//
//        //test > get duration of video 1
////        if let player = player {
////            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
//////            let d = playerItem.duration
////            print("video duration: \(duration)")
////        }
//
//        //test > get duration of video 2
//        let d = getDuration(ofVideoAt: videoUrl)
//        dd = getDuration(ofVideoAt: videoUrl) //test
////        print("video duration: \(d)")
//
//        //test > time observer for progresslistener
//        addTimeObserver(d : d)
//
//        //test > get video frames for timeline
//        getVideoFrameImageFromVideo(videoUrl: videoUrl)
//    }
//
//    func getDuration(ofVideoAt videoURL: URL) -> Double {
//        let asset = AVURLAsset(url: videoURL)
//        let duration = asset.duration
//        let durationInSeconds = CMTimeGetSeconds(duration)
//
//        if durationInSeconds.isNaN {
//            return 0.0
//        } else {
//            return durationInSeconds
//        }
//    }
//
//    //***test > add time observer for progresslistener
//    var timeObserverToken: Any?
//    func addTimeObserver(d : Double) {
//        //test > time observer
//        let timeInterval = CMTime(seconds: 0.02, preferredTimescale: CMTimeScale(1000)) //0.01 sec intervalc
//        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {
//            [weak self] time in
//            let currentTime = time.seconds
//            print("Current time video edit: \(currentTime)")
//
//            // Update UI with current time
//            let newVal = CGFloat((currentTime - 0) / (d - 0)) * 250.0
//            self?.progressCenterXCons?.constant = newVal
//
//            //test > timeline auto move
//            let newVal2 = CGFloat((currentTime - 0) / (0 - d)) * 150.0
//            self?.timelineXCons?.constant = newVal2
//        }
//    }
//    func removeTimeObserver() {
//        // Remove observer when view controller is deallocated
//        if let token = timeObserverToken {
//            player?.removeTimeObserver(token)
//            timeObserverToken = nil
//        }
//    }
//
//    let t1Frame = UIImageView()
//    let t2Frame = UIImageView()
//    let t3Frame = UIImageView()
//    func getVideoFrameImageFromVideo(videoUrl: URL) {
//        //get frames from image generator
//        let asset = AVURLAsset(url: videoUrl)
//        let generator = AVAssetImageGenerator(asset: asset)
//        generator.appliesPreferredTrackTransform = true
//
//        let times = [
//            CMTimeMake(value: 0, timescale: 1),
//            CMTimeMake(value: 1, timescale: 1),
//            CMTimeMake(value: 2, timescale: 1)
//        ]
//        let timeValues = times.map { NSValue(time: $0) }
//
//        generator.generateCGImagesAsynchronously(forTimes: timeValues) { (time, image, actualTime, result, error) in
//            if let image = image {
//                // Add the image to your timeline view
////                let imageView = UIImageView(image: UIImage(cgImage: image))
//                // Add the imageView to your timeline view
//                print("get video frames success: \(time.seconds), \(time.value)")
//                DispatchQueue.main.async {
//                    if(time.value == 0) {
//                        self.t1Frame.image = UIImage(cgImage: image)
//                    } else if(time.value == 1) {
//                        self.t2Frame.image = UIImage(cgImage: image)
//                    } else if(time.value == 2) {
//                        self.t3Frame.image = UIImage(cgImage: image)
//                    }
//                }
//
//            } else {
//                print("Error generating frame at time \(time): \(error)")
//            }
//        }
//    }
//    //****
//
//    //test > check preferred transform of video
//    func getVideoPreferredTransform(video: AVAsset) {
//        print("getVideoPreferredTransform: \(video.duration), \(video.tracks(withMediaType: AVMediaType.video)[0].preferredTransform)")
//    }
//
//    func playVideo() {
//        pauseBtn.isHidden = false //test
//        playBtn.isHidden = true //test
//
//        player?.seek(to: .zero)
//        player?.play()
//    }
//
//    func stopVideo() {
//        pauseBtn.isHidden = true //test
//        playBtn.isHidden = false //test
//
//        player?.seek(to: .zero)
//        player?.pause()
//    }
//
//    func pauseVideo() {
//        pauseBtn.isHidden = true //test
//        playBtn.isHidden = false //test
//
//        player?.pause()
//    }
//
//    func resumeVideo() {
//        pauseBtn.isHidden = false //test
//        playBtn.isHidden = true //test
//
//        player?.play()
//    }
//
//    func openExitVideoEditorPromptMsg() {
//        let exitVideoPanel = ExitVideoEditorMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        panel.addSubview(exitVideoPanel)
//        exitVideoPanel.translatesAutoresizingMaskIntoConstraints = false
//        exitVideoPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
//        exitVideoPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        exitVideoPanel.delegate = self
//    }
//
//    //test > file management for draft files
//    //ori: tempStorageURL()
////    func getVideoOutputURL() -> URL? {
//    func getVideoOutputURL() -> URL {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
////        let url = documentsURL.appendingPathComponent("temp_output_video.mp4")
//        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILE_OUTPUT_NAME)
//        return url
//    }
//    func getSplitAudioOutputURL() -> URL {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.SPLIT_AUDIO_FILE_OUTPUT_NAME)
//
//        return url
//    }
//    func getGifOutputURL() -> URL {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_GIF_FILE_OUTPUT_NAME)
//
//        return url
//    }
//    func getCoverImageOutputURL() -> URL {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_COVER_IMAGE_FILE_OUTPUT_NAME)
//
//        return url
//    }
//    func getOverlayVideoOutputURL() -> URL {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_OVERLAY_VIDEO_FILE_OUTPUT_NAME)
//        return url
//    }
//    func getBlurOutVideoOutputURL() -> URL {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_BLUROUT_VIDEO_FILE_OUTPUT_NAME)
//        return url
//    }
//
//    func createDirectoryForDraft() {
//        let dataPath = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//
//        if !fileManager.fileExists(atPath: dataPath.path) {
//            do {
//                try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
//                print("createDirectoryForDraft ")
//            } catch {
//                print("createDirectoryForDraft error \(error.localizedDescription)")
//            }
//        } else {
//            print("createDirectoryForDraft already exist")
//        }
//    }
//
//    func checkFilesInFolder() {
//        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//
//            let count = fileURLs.count
//            print("draft files total: \(count)")
//
//        } catch {
//            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//        }
//    }
//
//
//    //test > video processing
//    //compress video using exportSession (not customizable)
//    func compressVideo(inputAVAsset: AVAsset, handler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
//
//        let length = Float(inputAVAsset.duration.value) / Float(inputAVAsset.duration.timescale)
//        print("video length: \(length) seconds, \(Float(inputAVAsset.duration.value)), \(Float(inputAVAsset.duration.timescale))")
//
//        //AVAssetExportPresetMediumQuality - smaller size ut blurry
//        guard let exportSession = AVAssetExportSession(asset: inputAVAsset, presetName: AVAssetExportPresetHighestQuality) else {
//            handler(nil)
//            return
//        }
//
//        //remove previous file first
//        try? FileManager.default.removeItem(at: getVideoOutputURL())
//
//        //crop video with custom starttime and endtime
//        let startTime = CMTime(seconds: Double(0), preferredTimescale: 1000) //ori: 1
//        let endTime = CMTime(seconds: Double(1), preferredTimescale: 1000) //ori : 3
//        let timeRange = CMTimeRange(start: startTime, end: endTime)
//        exportSession.timeRange = timeRange
//        exportSession.outputURL = getVideoOutputURL()
//        exportSession.outputFileType = .mp4
//
//        //start exporting
//        exportSession.exportAsynchronously {
//            handler(exportSession)
//        }
//    }
//
//    //split audio from video - to make sound
//    func splitAudio(videoAsset: AVAsset) {
//
//        //get only audio track from video
//        let mixComposition = AVMutableComposition()
//        let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        let audioVideoTrack:AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0]
//        do{
//            try audioCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioVideoTrack, at: CMTime.zero)
//        } catch{
//            print(error)
//        }
//
//        //remove previous file first
//        try? FileManager.default.removeItem(at: getSplitAudioOutputURL())
//
//        //start exporting
//        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetPassthrough) {
//
//            exporter.outputURL = getSplitAudioOutputURL()
//            exporter.outputFileType = AVFileType.m4a
//            exporter.exportAsynchronously {
//                switch exporter.status {
//                case .unknown:
//                    break
//                case .waiting:
//                    break
//                case .exporting:
//                    break
//                case .completed:
//                    guard let compressedData = try? Data(contentsOf: self.getSplitAudioOutputURL()) else {
//                        return
//                    }
//                    print("outputURL file size 1: \(compressedData.count)")
//                    print("outputURL file size: \(Double(Double(compressedData.count)/1048576))mb")
//
//                case .failed:
//                    break
//                case .cancelled:
//                    break
//                }
//            }
//        }
//    }
//
//    //merge audio with video file
//    func mergeVideoAudioTracks(videoAsset: AVAsset, inputAudioUrl: URL) {
//
//        //prepare video and audio tracks for processing
////        let videoAsset = AVURLAsset(url: inputVideoUrl)
//        let audioAsset = AVURLAsset(url: inputAudioUrl)
//
//        let mixComposition = AVMutableComposition()
//        var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
//        var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
//
//        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
//        let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
//
//        let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
//        let audioAssetTrack: AVAssetTrack = audioAsset.tracks(withMediaType: AVMediaType.audio)[0]
//
//        compositionAddVideo?.preferredTransform = videoAssetTrack.preferredTransform
//        mutableCompositionVideoTrack.append(compositionAddVideo!)
//        mutableCompositionAudioTrack.append(compositionAddAudio!)
//
//        //match timing, duration of video and audio tracks
//        //-to be customized further, as audio file could be shorter or longer than video
//        do {
//           try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,duration: videoAssetTrack.timeRange.duration), of: videoAssetTrack, at: CMTime.zero)
//
//           try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,duration: videoAssetTrack.timeRange.duration), of: audioAssetTrack, at: CMTime.zero)
//        }
//        catch {
//               print(error.localizedDescription)
//        }
//
//        //remove previous file first
//        try? FileManager.default.removeItem(at: getVideoOutputURL())
//
//        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality) {
//            exporter.outputURL = getVideoOutputURL()
//            exporter.outputFileType = AVFileType.mp4
//            exporter.exportAsynchronously {
//                switch exporter.status {
//                case .unknown:
//                    break
//                case .waiting:
//                    break
//                case .exporting:
//                    break
//                case .completed:
//                    guard let compressedData = try? Data(contentsOf: self.getVideoOutputURL()) else {
//                        return
//                    }
//                    print("merge outputURL file size 1: \(compressedData.count)")
//                    print("merge outputURL file size: \(Double(Double(compressedData.count)/1048576))mb")
//
//                case .failed:
//                    break
//                case .cancelled:
//                    break
//                }
//            }
//        }
//    }
//
//    //test > blur out effect => from chatgpt -> but may end up inverted like in overlay text
////    func blurOutEffectOnVideo(videoUrl: URL) {
////        let videoComposition = AVMutableVideoComposition()
////        let videoAsset = AVURLAsset(url: videoUrl)
////        let clipVideoTrack:AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
////
////        let composition = AVMutableComposition()
////        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
////
////        let maskLayer = CALayer()
////        maskLayer.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
////        maskLayer.backgroundColor = UIColor.black.cgColor
////
////        let blurFilter = CIFilter(name: "CIGaussianBlur")!
////        blurFilter.setValue(10, forKey: kCIInputRadiusKey)
////
////        let videoSize = videoAsset.tracks(withMediaType: AVMediaType.video)[0].naturalSize
////        let parentLayer = CALayer()
////        let videoLayer = CALayer()
////        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
////        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
////        parentLayer.addSublayer(videoLayer)
////
////        let filterLayer = CALayer()
////        filterLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
////        filterLayer.backgroundColor = UIColor.clear.cgColor
////        filterLayer.filters = [blurFilter]
////
////        filterLayer.mask = maskLayer
////
////        parentLayer.addSublayer(filterLayer)
////
////        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
////        let transform = CGAffineTransform(translationX: 0, y: 0)
////        videoLayerInstruction.setTransform(transform, at: CMTime.zero)
////
////        let videoComposition = AVMutableVideoComposition()
////        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
////        videoComposition.renderSize = CGSize(width: videoSize.width, height: videoSize.height)
////        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
////
////        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
////        exportSession.videoComposition = videoComposition
////        exportSession.outputURL = getBlurOutVideoOutputURL()
////        exportSession.outputFileType = .mp4
////
////        exportSession.exportAsynchronously(completionHandler: {
////            // Handle export completion
////            switch exportSession.status {
////            case .unknown:
////                break
////            case .waiting:
////                break
////            case .exporting:
////                break
////            case .completed:
////                guard let compressedData = try? Data(contentsOf: self.getVideoOutputURL()) else {
////                    return
////                }
////                print("blurout outputURL file size 1: \(compressedData.count)")
////                print("blurout outputURL file size: \(Double(Double(compressedData.count)/1048576))mb")
////
////            case .failed:
////                break
////            case .cancelled:
////                break
////            }
////        })
////    }
//    //test 2 > blur out effect => video also inverted :-( => problem in video composition
//    func blurOutEffectOnVideo(videoUrl: URL) {
//        let mixComposition = AVMutableComposition()
//        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
//        let videoAsset = AVURLAsset(url: videoUrl)
//        let clipVideoTrack:AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
//        do{
//            try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: clipVideoTrack, at: CMTime.zero)
//        } catch{
//            print(error)
//        }
//        compositionVideoTrack?.preferredTransform = videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform
//
//        let maskLayer = CALayer()
//        maskLayer.frame = CGRect(x: 300, y: 300, width: 200, height: 200)
//        maskLayer.backgroundColor = UIColor.black.cgColor
//
//        let blurFilter = CIFilter(name: "CIGaussianBlur")!
//        blurFilter.setValue(10, forKey: kCIInputRadiusKey)
//
//        let videoSize = videoAsset.tracks(withMediaType: AVMediaType.video)[0].naturalSize
//        let parentLayer = CALayer()
//        let videoLayer = CALayer()
//        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//        parentLayer.addSublayer(videoLayer)
//
//        let filterLayer = CALayer()
//        filterLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//        filterLayer.backgroundColor = UIColor.clear.cgColor
//        filterLayer.filters = [blurFilter]
//
//        filterLayer.mask = maskLayer
//        parentLayer.addSublayer(filterLayer)
//
//        //prepare composition instruction
//        let videoComp = AVMutableVideoComposition()
//        videoComp.renderSize = videoSize
////        videoComp.renderSize = CGSize(width: videoSize.height, height: videoSize.width) //test
//        videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30) //30fps?
//        videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
//
//        let instruction = AVMutableVideoCompositionInstruction()
//        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mixComposition.duration)
//        let videoTrack = mixComposition.tracks(withMediaType: AVMediaType.video)[0]
//        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
//
//        //test transform => can invert, but not perfectly aligned
////        let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2)
////        let t2 = t1.rotated(by: .pi / 2)
////        let finalTransform = t2
////        layerInstruction.setTransform(finalTransform, at: CMTime.zero)
//
//        //test > transform
////        let t1 = CGAffineTransform(rotationAngle: .pi/2)
////        let t1a = t1.translatedBy(x: videoSize.height, y: 0) //translate does not help
////        layerInstruction.setTransform(t1a, at: CMTime.zero)
//
//        instruction.layerInstructions = [layerInstruction]
//        videoComp.instructions = [instruction]
//
//        //remove previous file first
//        try? FileManager.default.removeItem(at: getBlurOutVideoOutputURL())
//
//        //export overlayed video
//        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) {
//            exporter.outputURL = getBlurOutVideoOutputURL()
//            exporter.outputFileType = .mp4
//            exporter.videoComposition = videoComp
//            exporter.exportAsynchronously {
//                switch exporter.status {
//                case .unknown:
//                    break
//                case .waiting:
//                    break
//                case .exporting:
//                    break
//                case .completed:
//                    guard let compressedData = try? Data(contentsOf: self.getBlurOutVideoOutputURL()) else {
//                        return
//                    }
////                    print("overlay video export 1: \(compressedData.count)")
//                    print("blur video export success: \(Double(Double(compressedData.count)/1048576))mb")
//                case .failed:
//                    break
//                case .cancelled:
//                    break
//                @unknown default:
//                    print("blur video export fatal")
//                }
//            }
//        }
//    }
//
//
//    //test > overlay text/objects on video => not successful
//    func overlayLayerOnVideo(videoUrl: URL) {
//
//        //composition allows merge or remove tracks, speed up or slow down
//        let mixComposition = AVMutableComposition()
//        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
//        let videoAsset = AVURLAsset(url: videoUrl)
//        let clipVideoTrack:AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
//        do{
//            try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: clipVideoTrack, at: CMTime.zero)
//        } catch{
//            print(error)
//        }
//        compositionVideoTrack?.preferredTransform = videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform
//
//        //add title layer
//        let titleLayer = CATextLayer()
//        titleLayer.backgroundColor = UIColor.black.cgColor //clear
//        titleLayer.string = "DanDan"
//        titleLayer.font = "Helvetica" as CFTypeRef
//        titleLayer.fontSize = 30
//        titleLayer.alignmentMode = CATextLayerAlignmentMode.right
//        titleLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
//        titleLayer.foregroundColor = UIColor.white.cgColor
//
//        //sort layer
//        let videoSize = videoAsset.tracks(withMediaType: AVMediaType.video)[0].naturalSize
//        print("overlay video size: \(videoSize)")
//        let parentLayer = CALayer()
//        let videoLayer = CALayer()
//        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
////        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.height, height: videoSize.width) //test
////        titleLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//        parentLayer.addSublayer(videoLayer)
//        parentLayer.addSublayer(titleLayer)
//
//        //prepare composition instruction
//        let videoComp = AVMutableVideoComposition()
//        videoComp.renderSize = videoSize
////        videoComp.renderSize = CGSize(width: videoSize.height, height: videoSize.width) //test
//        videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30) //30fps?
//        videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
//
//        let instruction = AVMutableVideoCompositionInstruction()
//        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mixComposition.duration)
//        let videoTrack = mixComposition.tracks(withMediaType: AVMediaType.video)[0]
//        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
//
//        //test > transform
//        let t1 = CGAffineTransform(rotationAngle: .pi/2)
//        let t1a = t1.translatedBy(x: videoSize.height, y: 0) //translate does not help
//        layerInstruction.setTransform(t1a, at: CMTime.zero)
//
//        instruction.layerInstructions = [layerInstruction]
//        videoComp.instructions = [instruction]
//
//        //remove previous file first
//        try? FileManager.default.removeItem(at: getOverlayVideoOutputURL())
//
//        //export overlayed video
//        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) {
//            exporter.outputURL = getOverlayVideoOutputURL()
//            exporter.outputFileType = .mp4
//            exporter.videoComposition = videoComp
//            exporter.exportAsynchronously {
//                switch exporter.status {
//                case .unknown:
//                    break
//                case .waiting:
//                    break
//                case .exporting:
//                    break
//                case .completed:
//                    guard let compressedData = try? Data(contentsOf: self.getOverlayVideoOutputURL()) else {
//                        return
//                    }
////                    print("overlay video export 1: \(compressedData.count)")
//                    print("overlay video export success: \(Double(Double(compressedData.count)/1048576))mb")
//                case .failed:
//                    break
//                case .cancelled:
//                    break
//                @unknown default:
//                    print("overlay video export fatal")
//                }
//            }
//        }
//    }
//
//    //produce GIF from video
//    func produceGifFromVideo(videoUrl: URL) {
//
//        let asset = AVURLAsset(url: videoUrl)
//        guard let reader = try? AVAssetReader(asset: asset) else {
//            return
//        }
//        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
//            return
//        }
////        let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
//
//        //to get transformed rotation degree
//        let transform = videoTrack.preferredTransform
//        let radians = atan2(transform.b, transform.a)
//        let degrees = (radians * 180.0) / .pi
//
//        let videoSize = videoTrack.naturalSize
////        let resultingSize: CGSize = {
////            return CGSize(width: videoSize.width, height: videoSize.height)
////        }()
//
//        let cappedResolution: CGFloat = 320.0 //ori 240...200(200 is too blur and small)
//
//        let videoWidth = abs(videoSize.width)
//        let videoHeight = abs(videoSize.height)
//        let aspectRatio = videoWidth / videoHeight
//
//        let resultingSize: CGSize = {
//
//            if videoWidth > videoHeight {
//                let cappedWidth = round(min(cappedResolution, videoWidth))
//                return CGSize(width: cappedWidth, height: round(cappedWidth / aspectRatio))
//            } else {
//                let cappedHeight = round(min(cappedResolution, videoHeight))
//                print("gifVideo resulting size: \(cappedHeight), \(round(cappedHeight * aspectRatio))")
//                return CGSize(width: round(cappedHeight * aspectRatio), height: cappedHeight)
//            }
//        }()
//
//        let duration: CGFloat = CGFloat(asset.duration.seconds)
//        let nominalFrameRate = CGFloat(videoTrack.nominalFrameRate)
//        let nominalTotalFrames = Int(round(duration * nominalFrameRate))
//        let desiredFrameRate: CGFloat = 5.0 //ori 30, 15
//
//        print("gifVideo: \(duration), \(nominalFrameRate), \(nominalTotalFrames)")
//
//        let framesToRemove: [Int] = {
//            // Ensure the actual/nominal frame rate isn't already lower than the desired, in which case don't even worry about it
//            if desiredFrameRate < nominalFrameRate {
//                let percentageOfFramesToRemove = 1.0 - (desiredFrameRate / nominalFrameRate)
//                let totalFramesToRemove = Int(round(CGFloat(nominalTotalFrames) * percentageOfFramesToRemove))
//
//                // We should remove a frame every `frameRemovalInterval` frames…
//                // Since we can't remove e.g.: the 3.7th frame, round that up to 4, and we'd remove the 4th frame, then the 7.4th -> 7th, etc.
//                let frameRemovalInterval = CGFloat(nominalTotalFrames) / CGFloat(totalFramesToRemove)
//                var framesToRemove: [Int] = []
//
//                var sum: CGFloat = 0.0
//
//                while sum <= CGFloat(nominalTotalFrames) {
//                    sum += frameRemovalInterval
//                    let roundedFrameToRemove = Int(round(sum))
//                    framesToRemove.append(roundedFrameToRemove)
//                }
//
//                return framesToRemove
//            } else {
//                return []
//            }
//        }()
//
//        let totalFrames = nominalTotalFrames - framesToRemove.count
//
//        let outputSettings: [String: Any] = [
//            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
//            kCVPixelBufferWidthKey as String: resultingSize.width,
//            kCVPixelBufferHeightKey as String: resultingSize.height
//        ]
//
//        let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: outputSettings)
//
//        reader.add(readerOutput)
//        reader.startReading()
//
//        var sample: CMSampleBuffer? = readerOutput.copyNextSampleBuffer()
//
//        let delayBetweenFrames: CGFloat = 1.0 / min(desiredFrameRate, nominalFrameRate)
//
//        print("gifVideo Nominal total frames: \(nominalTotalFrames), totalFramesUsed: \(totalFrames), totalFramesToRemove: \(framesToRemove.count), nominalFrameRate: \(nominalFrameRate), delayBetweenFrames: \(delayBetweenFrames)")
//
//        let fileProperties: [String: Any] = [
//            kCGImagePropertyGIFDictionary as String: [
//                kCGImagePropertyGIFLoopCount as String: 0
//            ]
//        ]
//
//        let frameProperties: [String: Any] = [
//            kCGImagePropertyGIFDictionary as String: [
//                kCGImagePropertyGIFDelayTime: delayBetweenFrames
//            ]
//        ]
//
//        //remove previous file first
//        try? FileManager.default.removeItem(at: getGifOutputURL())
//
//        guard let destination = CGImageDestinationCreateWithURL(getGifOutputURL() as CFURL, UTType.gif.identifier as CFString, totalFrames, nil) else {
//            return
//        }
//
//        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
//
//        let operationQueue = OperationQueue()
//        operationQueue.maxConcurrentOperationCount = 1
//
//        var framesCompleted = 0
//        var currentFrameIndex = 0
//
//        while (sample != nil) {
//            currentFrameIndex += 1
//
//            if framesToRemove.contains(currentFrameIndex) {
//                sample = readerOutput.copyNextSampleBuffer()
//                continue
//            }
//
//            if let newSample = sample {
//                //loop through video and extract frame as image, then integrate images into GIF file
//                // Create it as an optional and manually nil it out every time it's finished otherwise weird Swift bug where memory will balloon enormously (see https://twitter.com/ChristianSelig/status/1241572433095770114)
////                var cgImage: CGImage? = self.cgImageFromSampleBuffer(newSample, degrees)
//                var cgImage: CGImage? = self.cgImageFromSampleBuffer(newSample, rotationDegree: degrees)
//
//                operationQueue.addOperation {
//                    framesCompleted += 1
//
//                    if let cgImage = cgImage {
////                        CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
//
//                        if(framesCompleted <= totalFrames) {
//                            CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
//                        }
//                    }
//
//                    cgImage = nil
//
//                    let progress = CGFloat(framesCompleted) / CGFloat(totalFrames)
//
//                    // GIF progress is a little fudged so it works with downloading progress reports
//                    let progressToReport = Int(progress * 100.0)
//                    print("gifvideo % \(progressToReport)")
//                }
//            }
//
//            sample = readerOutput.copyNextSampleBuffer()
//        }
//
//        operationQueue.waitUntilAllOperationsAreFinished()
//
//        print("gifVideo finalizing: \(framesCompleted), \(totalFrames)")
//        let didCreateGIF = CGImageDestinationFinalize(destination)
//
//        guard didCreateGIF else {
//            return
//        }
//
//        print("gifVideo completed")
////        DispatchQueue.main.async {
////            print("gifVideo completed")
////        }
//    }
//
//    private func cgImageFromSampleBuffer(_ buffer: CMSampleBuffer, rotationDegree: CGFloat) -> CGImage? {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
//            return nil
//        }
//
//        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
//
//        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
//        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
//
//        let width = CVPixelBufferGetWidth(pixelBuffer)
//        let height = CVPixelBufferGetHeight(pixelBuffer)
//
//        print("gifVideo image: \(width), \(height)")
//
//        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else { return nil }
//
//        let image = context.makeImage()
////
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
////        return image
//
////        let newImage = createMatchingBackingDataWithImage(imageRef: image)
////        return newImage
//
//        if(rotationDegree == 0.0) {
////            let image = context.makeImage()
////            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
//            return image
//        } else {
//            let newImage = createMatchingBackingDataWithImage(imageRef: image, rotationDegree: rotationDegree)
//            return newImage
//        }
//
//    }
//
//    //test to flip, transform CGImage
//    func createMatchingBackingDataWithImage(imageRef: CGImage?, rotationDegree: CGFloat) -> CGImage? {
//        var orientedImage: CGImage?
//
//        if let imageRef = imageRef {
//            let originalWidth = imageRef.width
//            let originalHeight = imageRef.height
//            let bitsPerComponent = imageRef.bitsPerComponent
//            let bytesPerRow = imageRef.bytesPerRow
//
//            let colorSpace = imageRef.colorSpace
//            let bitmapInfo = imageRef.bitmapInfo
//
//            var degreesToRotate: Double
//            var swapWidthHeight: Bool
//            var mirrored: Bool
//
//            if(rotationDegree == 90.0) {
//                degreesToRotate = -90.0 //negative is clockwise, positive is counterclockwise
//                swapWidthHeight = true
//            } else if (rotationDegree == -90.0) {
//                degreesToRotate = 90.0 //negative is clockwise, positive is counterclockwise
//                swapWidthHeight = true
//            } else {
//                degreesToRotate = Double(rotationDegree)
//                swapWidthHeight = false
//            }
//
//            //****Need to test for landscape
////            swapWidthHeight = true
//            mirrored = false
//
//
////            switch orienation {
////            case .up:
////                degreesToRotate = 0.0
////                swapWidthHeight = false
////                mirrored = false
////                break
////            case .upMirrored:
////                degreesToRotate = 0.0
////                swapWidthHeight = false
////                mirrored = true
////                break
////            case .right:
////                degreesToRotate = 90.0
////                swapWidthHeight = true
////                mirrored = false
////                break
////            case .rightMirrored:
////                degreesToRotate = 90.0
////                swapWidthHeight = true
////                mirrored = true
////                break
////            case .down:
////                degreesToRotate = 180.0
////                swapWidthHeight = false
////                mirrored = false
////                break
////            case .downMirrored:
////                degreesToRotate = 180.0
////                swapWidthHeight = false
////                mirrored = true
////                break
////            case .left:
////                degreesToRotate = -90.0
////                swapWidthHeight = true
////                mirrored = false
////                break
////            case .leftMirrored:
////                degreesToRotate = -90.0
////                swapWidthHeight = true
////                mirrored = true
////                break
////            }
//            let radians = degreesToRotate * Double.pi / 180
//
//            var width: Int
//            var height: Int
//            if swapWidthHeight {
//                width = originalHeight
//                height = originalWidth
//            } else {
//                width = originalWidth
//                height = originalHeight
//            }
//
//            if let contextRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue) {
//
//                contextRef.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
//                if mirrored {
//                    contextRef.scaleBy(x: -1.0, y: 1.0)
//                }
//                contextRef.rotate(by: CGFloat(radians))
//                if swapWidthHeight {
//                    contextRef.translateBy(x: -CGFloat(height) / 2.0, y: -CGFloat(width) / 2.0)
//                } else {
//                    contextRef.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
//                }
//                contextRef.draw(imageRef, in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))
//
//                orientedImage = contextRef.makeImage()
//            }
//        }
//
//        return orientedImage
//    }
//
//    //produce cover thumbnail from video
//    //ori: generateThumbnail()
////    func produceCoverImageFromVideo(videoUrl: URL) -> UIImage? {
//    func produceCoverImageFromVideo(videoUrl: URL) {
//        do {
//            //generate image from image generator
//            let asset = AVURLAsset(url: videoUrl)
//            let imageGenerator = AVAssetImageGenerator(asset: asset)
//            imageGenerator.appliesPreferredTrackTransform = true
//
//            // Swift 4.2
//            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
//
//            //remove previous version
//            try? FileManager.default.removeItem(at: getCoverImageOutputURL())
//
//            do {
//                print("generate thumbnail trying")
//                try UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.90)?.write(to: getCoverImageOutputURL(), options: .atomic)
//            } catch {
//                print(error)
//            }
//
//            print("generate thumbnail done")
////            return UIImage(cgImage: cgImage)
//        } catch {
//            print(error.localizedDescription)
////            return nil
//        }
//    }
//
//
//    //original code copied from mapsdemo app
//    //add watermark to video
////    func addWatermarkToVideo(outputFileURL: URL) {
//////    func addWatermarkToVideo(videoAsset: AVAsset) {
////        let videoAsset = AVURLAsset(url: outputFileURL)
////        let mixComposition = AVMutableComposition()
////        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
////        let clipVideoTrack:AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
////        do{
////            try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: clipVideoTrack, at: CMTime.zero)
////        } catch{
////            print(error)
////        }
//////            compositionVideoTrack?.preferredTransform = videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform
////        print("video orientation: \(videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform)")
////
////        //-add watermark
////        let myImage = UIImage(named: "aero")
////        let aLayer = CALayer()
////        aLayer.contents = myImage?.cgImage
////        aLayer.frame = CGRect(x: 5, y: 25, width: 100, height: 57)
////        aLayer.opacity = 0.65
////
////        let titleLayer = CATextLayer()
////        titleLayer.backgroundColor = UIColor.clear.cgColor
////        titleLayer.string = "DanDanMap"
////        titleLayer.font = "Helvetica" as CFTypeRef
////        titleLayer.fontSize = 20
////        titleLayer.alignmentMode = CATextLayerAlignmentMode.right
////        titleLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 57)
////        titleLayer.foregroundColor = UIColor.red.cgColor
//////            parentLayer.addSublayer(titleLayer)
////
////        //-sort layer
////        let videoSize = videoAsset.tracks(withMediaType: AVMediaType.video)[0].naturalSize
////        let parentLayer = CALayer()
////        let videoLayer = CALayer()
////        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
////        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//////            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.height, height: videoSize.width)
//////            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.height, height: videoSize.width)
////        parentLayer.addSublayer(videoLayer)
////        parentLayer.addSublayer(aLayer)
////        parentLayer.addSublayer(titleLayer)
////
////        //-instructions
////        let videoComp = AVMutableVideoComposition()
////        videoComp.renderSize = videoSize
////        videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30)
////        videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
////
////        let instruction = AVMutableVideoCompositionInstruction()
////        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mixComposition.duration)
////        let videoTrack = mixComposition.tracks(withMediaType: AVMediaType.video)[0]
////        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
////
////        /////transform method 1
////        print("video orientation: \(videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform)")
////        print("video size: \(videoSize), \(UIScreen.main.bounds)")
////        print("trans y: \(-(videoSize.width - videoSize.height) / 2)")
//////            let t1 = CGAffineTransform(translationX: videoSize.height, y: -(videoSize.width - videoSize.height) / 2)
////        let t1 = CGAffineTransform(translationX: videoSize.height, y: 0)
//////            let t1 = CGAffineTransform(scaleX: 1, y: 1)
////        let ta: CGAffineTransform = t1.scaledBy(x: 1, y: 1)
////        let t2: CGAffineTransform = ta.rotated(by: .pi/2)
//////            let t2: CGAffineTransform = t1.rotated(by: .pi/2)
////        let finalTransform: CGAffineTransform = t2
////        layerInstruction.setTransform(finalTransform, at: CMTime.zero)
////
////        /////transform method 2
//////            let scaleToFitRatio = UIScreen.main.bounds.width / videoSize.height
//////            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
//////            layerInstruction.setTransform(videoAsset.tracks(withMediaType: AVMediaType.video)[0].preferredTransform.concatenating(scaleFactor), at: CMTime.zero)
////
////        instruction.layerInstructions = [layerInstruction]
////        videoComp.instructions = [instruction]
////
////        //test > remove previous file first
////        try? FileManager.default.removeItem(at: getVideoOutputURL())
////
////        //-export
//////        let watermarkedURL = tempURL()
//////        let watermarkedURL1 = watermarkedURL! as URL
////        if let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality) {
//////            exporter.outputURL = watermarkedURL1
////            exporter.outputURL = getVideoOutputURL()
////            exporter.outputFileType = .mp4
////            exporter.videoComposition = videoComp
////            exporter.exportAsynchronously {
////                switch exporter.status {
////                case .unknown:
////                    break
////                case .waiting:
////                    break
////                case .exporting:
////                    break
////                case .completed:
//////                    guard let compressedData = try? Data(contentsOf: watermarkedURL1) else {
////                    guard let compressedData = try? Data(contentsOf: self.getVideoOutputURL()) else {
////                        return
////                    }
////                    print("postwatermark file size 1: \(compressedData.count)")
////                    print("postwatermark file size: \(Double(Double(compressedData.count)/1048576))mb")
////
////                    DispatchQueue.main.async {
////                        //play watermarked video
//////                        let playerItem = AVPlayerItem(url: watermarkedURL1)
//////                        avPlayer.replaceCurrentItem(with: playerItem)
//////                        avPlayer.play()
//////                        self.view.addSubview(videoView)
////                    }
////
////                    //save video to photo album
//////                        if error == nil {
//////                            UISaveVideoAtPathToSavedPhotosAlbum(videoRecorded.path, nil, nil, nil)
//////                        }
////
////                case .failed:
////                    break
////                case .cancelled:
////                    break
////                }
////            }
////        }
////    }
//}
//
//extension VideoCreatorConsolePanelView: VideoEditorPanelDelegate{
//    func didInitializeVideoEditor() {
//        //test > turn off camera
//        self.session?.stopRunning()
//    }
//    func didClickFinishVideoEditor() {
//        backPage()
//
//        //test > resume camera
////        self.session?.startRunning()
//    }
//
//    func didClickNextVideoEditor() {
//        openVideoFinalize()
//    }
//
//    func didPromptExitVideoEditor() {
//        //test > resume camera
//        DispatchQueue.main.async {
//            self.session?.startRunning()
//        }
//    }
//
//    func didDenyExitVideoEditor() {
//        //test > turn off camera
//        self.session?.stopRunning()
//    }
//}

