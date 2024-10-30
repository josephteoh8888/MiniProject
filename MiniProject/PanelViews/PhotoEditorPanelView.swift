////
////  VideoCameraPanelView.swift
////  MiniProject
////
////  Created by Joseph Teoh on 30/06/2024.
////
//
//import Foundation
//import UIKit
//import SDWebImage
//import AVFoundation
//import PhotosUI
//import Photos
//
////test > archive video camera for future use case
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
