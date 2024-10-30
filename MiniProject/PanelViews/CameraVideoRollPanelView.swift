//
//  CameraVideoRollPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import PhotosUI
import Photos

protocol CameraVideoRollPanelDelegate : AnyObject {
    func didInitializeCameraVideoRoll()
    func didClickFinishCameraVideoRoll()
    func didClickVideoSelect(video: PHAsset)
    func didClickMultiVideoSelect(urls: [String])
}
class CameraVideoRollPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var aView = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
//    var scrollablePanelHeight : CGFloat = 500.0
    
//    var vDataList = [PHAsset]()
    var vDataList = [GridAssetData]()
    var isCameraRollInitialized = false
    var vCV : UICollectionView?
    
    weak var delegate : CameraVideoRollPanelDelegate?
    
    let pMiniError = UIView()
    var panelView = UIView()
    let aLoggedOutBox = UIView()
    
    var isMultiSelect = false
//    var multiSelectDataList = [URL]()
    var multiSelectDataList = [String]()
    var selectedGridAssetDataList = [Int]()
    let multiToolPanel = UIView()
    let coverBottomCon = UIView()
    let scrollView = UIScrollView()
    var photoViewList = [MultiSelectedCell]()
    let sPhotoSize = 60.0
    
    let gLineSpacingHeight = 4.0
    let gLhsMargin = 20.0
    let gRhsMargin = 20.0
    
    var isScrollViewAtTop = true
    
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
        self.addSubview(aView)
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        aView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aView.isUserInteractionEnabled = true
//        aView.layer.opacity = 0.1 //default : 0
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseCameraRollClicked)))
//        aView.backgroundColor = .ddmBlackOverlayColor
//        aView.backgroundColor = .clear
        //test
        aView.backgroundColor = .black
        aView.layer.opacity = 0.3 //0.2
        
//        var panelView = UIView()
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
//        panelTopCons = panelView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
        let gap = viewHeight - 100 //150
        panelTopCons = panelView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -gap)
        panelTopCons?.isActive = true
        panelView.heightAnchor.constraint(equalToConstant: gap).isActive = true
        
//        panelTopCons?.isActive = true

        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panelView.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 50).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseCameraRollClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        panelView.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let panelTitleText = UILabel()
        panelTitleText.textAlignment = .center
        panelTitleText.textColor = .white
//        panelTitleText.font = .systemFont(ofSize: 14) //default 14
        panelTitleText.font = .boldSystemFont(ofSize: 13) //default 14
        panelTitleText.text = "Select Video"
        panelView.addSubview(panelTitleText)
        panelTitleText.translatesAutoresizingMaskIntoConstraints = false
//        panelTitleText.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        panelTitleText.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        panelTitleText.centerXAnchor.constraint(equalTo: panelView.centerXAnchor, constant: 0).isActive = true
        panelTitleText.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 20).isActive = true
        panelTitleText.isUserInteractionEnabled = true
//        panelTitleText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentTitleClicked)))
        
        //test > uicollectionview for user videos
//        vDataList.append("a")
//        vDataList.append("a")
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
//        gridLayout.minimumLineSpacing = 20 //default: 8 => spacing between rows
        gridLayout.minimumLineSpacing = gLineSpacingHeight //default: 8 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
//        let vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }
        vCV.register(GridVideoRollViewCell.self, forCellWithReuseIdentifier: GridVideoRollViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
//        vCV.showsVerticalScrollIndicator = false
//        vCV.backgroundColor = .blue
        vCV.backgroundColor = .clear
        panelView.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
//        vCV.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 20).isActive = true
        vCV.topAnchor.constraint(equalTo: panelTitleText.bottomAnchor, constant: 20).isActive = true //test
        vCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        let vcvPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        vcvPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        vCV.addGestureRecognizer(vcvPanGesture)

//        //**test > error getting video/photo album
////        let lhsMiniError = UIView()
//        pMiniError.backgroundColor = .red
//        panelView.addSubview(pMiniError)
//        pMiniError.translatesAutoresizingMaskIntoConstraints = false
//        pMiniError.centerXAnchor.constraint(equalTo: panelView.centerXAnchor, constant: 0).isActive = true
//        pMiniError.centerYAnchor.constraint(equalTo: panelView.centerYAnchor, constant: -20).isActive = true
//        pMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        pMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        pMiniError.layer.cornerRadius = 10
//        
//        let aBBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
//        aBBtn.tintColor = .white
//        pMiniError.addSubview(aBBtn)
//        aBBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBBtn.centerXAnchor.constraint(equalTo: pMiniError.centerXAnchor).isActive = true
//        aBBtn.centerYAnchor.constraint(equalTo: pMiniError.centerYAnchor).isActive = true
//        aBBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
//        aBBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
//        //**
        
        //test 2 > access video/photo album
//        let aLoggedOutBox = UIView()
        panelView.addSubview(aLoggedOutBox)
        aLoggedOutBox.translatesAutoresizingMaskIntoConstraints = false
//        aLoggedOutBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedOutBox.centerYAnchor.constraint(equalTo: panelView.centerYAnchor, constant: -60).isActive = true //-90
        aLoggedOutBox.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        aLoggedOutBox.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        aLoggedOutBox.isHidden = false
//        aLoggedOutBox.isHidden = true
        
        let gTitleText = UILabel()
        gTitleText.textAlignment = .center
        gTitleText.textColor = .white
//        gTitleText.textColor = .ddmBlackOverlayColor
        gTitleText.font = .boldSystemFont(ofSize: 16)
        aLoggedOutBox.addSubview(gTitleText)
        gTitleText.translatesAutoresizingMaskIntoConstraints = false
//        gTitleText.centerYAnchor.constraint(equalTo: gBox.centerYAnchor).isActive = true
        gTitleText.topAnchor.constraint(equalTo: aLoggedOutBox.topAnchor, constant: 0).isActive = true
//        gTitleText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -10).isActive = true
        gTitleText.leadingAnchor.constraint(equalTo: aLoggedOutBox.leadingAnchor, constant: 20).isActive = true
        gTitleText.trailingAnchor.constraint(equalTo: aLoggedOutBox.trailingAnchor, constant: -20).isActive = true
        gTitleText.numberOfLines = 0
        gTitleText.text = "MiniApp wants to access your storage"
        
        let aLoginText = UILabel()
        aLoginText.textAlignment = .center
//        aLoginText.textColor = .white
        aLoginText.textColor = .ddmDarkGrayColor
//        aLoginText.font = .boldSystemFont(ofSize: 13)
        aLoginText.font = .systemFont(ofSize: 13)
        aLoggedOutBox.addSubview(aLoginText)
        aLoginText.translatesAutoresizingMaskIntoConstraints = false
        aLoginText.topAnchor.constraint(equalTo: gTitleText.bottomAnchor, constant: 10).isActive = true
//        aLoginText.centerXAnchor.constraint(equalTo: gTitleText.centerXAnchor, constant: 0).isActive = true
        aLoginText.leadingAnchor.constraint(equalTo: aLoggedOutBox.leadingAnchor, constant: 60).isActive = true
        aLoginText.trailingAnchor.constraint(equalTo: aLoggedOutBox.trailingAnchor, constant: -60).isActive = true
        aLoginText.numberOfLines = 0
        aLoginText.text = "So that you can import from your photo and video album" //default: Around You
        
        let aFollow = UIView()
        aFollow.backgroundColor = .yellow
        aLoggedOutBox.addSubview(aFollow)
        aFollow.translatesAutoresizingMaskIntoConstraints = false
//        aFollow.leadingAnchor.constraint(equalTo: aLoggedOutBox.leadingAnchor, constant: 100).isActive = true
//        aFollow.trailingAnchor.constraint(equalTo: aLoggedOutBox.trailingAnchor, constant: -100).isActive = true
        aFollow.centerXAnchor.constraint(equalTo: aLoggedOutBox.centerXAnchor).isActive = true
        aFollow.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        aFollow.topAnchor.constraint(equalTo: aLoginText.bottomAnchor, constant: 20).isActive = true
        aFollow.bottomAnchor.constraint(equalTo: aLoggedOutBox.bottomAnchor, constant: 0).isActive = true
        aFollow.layer.cornerRadius = 10
        aFollow.isUserInteractionEnabled = true
        aFollow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))

        let aFollowText = UILabel()
        aFollowText.textAlignment = .center
        aFollowText.textColor = .black
        aFollowText.font = .boldSystemFont(ofSize: 13) //default 14
        aFollow.addSubview(aFollowText)
        aFollowText.translatesAutoresizingMaskIntoConstraints = false
//        aFollowText.centerXAnchor.constraint(equalTo: aFollow.centerXAnchor).isActive = true
        aFollowText.leadingAnchor.constraint(equalTo: aFollow.leadingAnchor, constant: 60).isActive = true
        aFollowText.trailingAnchor.constraint(equalTo: aFollow.trailingAnchor, constant: -60).isActive = true
        aFollowText.centerYAnchor.constraint(equalTo: aFollow.centerYAnchor).isActive = true
        aFollowText.text = "Allow"
        
        //**test > tools panel for multi selection
//        let coverBottomCon = UIView()
        coverBottomCon.backgroundColor = .ddmBlackOverlayColor
        panelView.addSubview(coverBottomCon)
        coverBottomCon.translatesAutoresizingMaskIntoConstraints = false
        coverBottomCon.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        coverBottomCon.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        coverBottomCon.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        coverBottomCon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        coverBottomCon.isHidden = true
        
//        let multiToolPanel = UIView()
        multiToolPanel.backgroundColor = .ddmBlackOverlayColor //black
//        multiToolPanel.backgroundColor = .black //black
        panelView.addSubview(multiToolPanel)
        multiToolPanel.translatesAutoresizingMaskIntoConstraints = false
//        multiToolPanel.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
//        multiToolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomInset).isActive = true
        multiToolPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        multiToolPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        multiToolPanel.layer.cornerRadius = 0
        multiToolPanel.heightAnchor.constraint(equalToConstant: 60).isActive = true //90
        multiToolPanel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        multiToolPanel.isHidden = true
        
        let aUpload = UIView()
        aUpload.backgroundColor = .yellow
//        panel.addSubview(aUpload)
        multiToolPanel.addSubview(aUpload)
        aUpload.translatesAutoresizingMaskIntoConstraints = false
        aUpload.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
//        aUpload.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
//        aUpload.topAnchor.constraint(equalTo: multiToolPanel.topAnchor, constant: 20).isActive = true
        aUpload.trailingAnchor.constraint(equalTo: multiToolPanel.trailingAnchor, constant: -20).isActive = true
        aUpload.centerYAnchor.constraint(equalTo: multiToolPanel.centerYAnchor).isActive = true
        aUpload.layer.cornerRadius = 10
        aUpload.isUserInteractionEnabled = true
        aUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCameraRollMultiSelectNextClicked)))

        let aUploadText = UILabel()
        aUploadText.textAlignment = .center
        aUploadText.textColor = .black
        aUploadText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aUploadText)
        aUpload.addSubview(aUploadText)
        aUploadText.translatesAutoresizingMaskIntoConstraints = false
//        aUploadText.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
        aUploadText.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
        aUploadText.leadingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: 15).isActive = true
        aUploadText.trailingAnchor.constraint(equalTo: aUpload.trailingAnchor, constant: -15).isActive = true
        aUploadText.text = "Next"
        
//        let scrollView = UIScrollView()
        multiToolPanel.addSubview(scrollView)
        scrollView.backgroundColor = .clear
//        scrollView.backgroundColor = .ddmDarkColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.topAnchor.constraint(equalTo: multiToolPanel.topAnchor, constant: 20).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: multiToolPanel.leadingAnchor, constant: 0).isActive = true //0
        scrollView.trailingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: -10).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 60).isActive = true  //sPhotoSize
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        
        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onCameraRollPanelPanGesture))
        panelView.addGestureRecognizer(aPanelPanGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("cameraroll layoutsubview")
        
        if(!isCameraRollInitialized) {
            checkCameraRollPermission()
            isCameraRollInitialized = true
            
            //test > trigger initialize camera roll
            self.delegate?.didInitializeCameraVideoRoll()
        }
    }
    
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
        if(isStoragePermissionNotDetermined) {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                        
                // Handle restricted or denied state
                if status == .restricted || status == .denied {
                    print("photoStatus: Restricted or Denied")
                }
                
                // Handle limited state
                if status == .limited {
                    print("photoStatus: Limited")
                }
                
                // Handle authorized state
                if status == .authorized {
                    print("photoStatus: Full access")
                    self?.aLoggedOutBox.isHidden = true
                    self?.isStoragePermissionNotDetermined = false
                    self?.retrieveVideoFilesFromCameraRoll()
                }
            }
        } else {
            openAppIOSPublicSetting()
        }
    }
    
    @objc func onCloseCameraRollClicked(gesture: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            
            //test > trigger finish close panel
            self.delegate?.didClickFinishCameraVideoRoll()
        })
    }
    
    @objc func onCameraRollMultiSelectNextClicked(gesture: UITapGestureRecognizer) {
        
        self.delegate?.didClickMultiVideoSelect(urls: multiSelectDataList)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    @objc func onCameraRollPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            self.currentPanelTopCons = self.panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
//            let x = translation.x
            let y = translation.y
            if(y > 0) {
                self.panelTopCons?.constant = self.currentPanelTopCons + y
            }
        } else if(gesture.state == .ended){
            print("commentpanel: \(self.currentPanelTopCons - self.panelTopCons!.constant)")
            if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didClickFinishCameraVideoRoll()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    let gap = self.viewHeight - 100 //150
                    self.panelTopCons?.constant = -gap
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            print("onPan began top constraint: ")
            currentPanelTopCons = panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)
            
            print("onPan changed: \(x), \(y)")
            if(y > 0) {
                if(isScrollViewAtTop) {
                    panelTopCons?.constant = currentPanelTopCons + y
                }
            } else {
                //test
                isScrollViewAtTop = false
            }

        } else if(gesture.state == .ended){
            print("onPan end:")
            if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didClickFinishCameraVideoRoll()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    let gap = self.viewHeight - 100 //150
                    self.panelTopCons?.constant = -gap
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    //test
    var isStoragePermissionNotDetermined = false
    func openAppIOSPublicSetting() {
        //direct user off app to IOS public app setting
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    func checkCameraRollPermission() {
        
        //test 2 > use authorizationstatus instead
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            print("storage permission not determined")
            aLoggedOutBox.isHidden = false
            isStoragePermissionNotDetermined = true
        case .restricted:
            print("storage permission restricted")
            aLoggedOutBox.isHidden = false
            isStoragePermissionNotDetermined = false
        case .limited:
            print("storage permission limited")
            aLoggedOutBox.isHidden = false
            isStoragePermissionNotDetermined = false
        case .denied:
            print("storage permission denied")
            aLoggedOutBox.isHidden = false
            isStoragePermissionNotDetermined = false
        case .authorized:
            print("storage permission authorized")
            aLoggedOutBox.isHidden = true
            isStoragePermissionNotDetermined = false
            self.retrieveVideoFilesFromCameraRoll()
            
        @unknown default:
            aLoggedOutBox.isHidden = false
            isStoragePermissionNotDetermined = false
            break
        }
    }
    
    func retrieveVideoFilesFromCameraRoll() {
        let option = PHFetchOptions()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
//        let sort = NSSortDescriptor(key: "modificationDate", ascending: false)
        option.sortDescriptors = [sort]
        
        // Fetch all video assets from the Photos Library as fetch results
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: option)
        
        // Loop through all fetched results
        fetchResults.enumerateObjects({ [weak self] (object, count, stop) in
            
            // Add video object to our video array
//            self?.vDataList.append(object)
            print("fetchVideos success \(object), \(count)")
            
            //test 2 > new grid asset method
            let aData = GridAssetData()
            aData.setModel(data: object)
            self?.vDataList.append(aData)
        })
        
        asyncReloadData(id: "post_feed")
    }
    
    //test > set camera roll to be multi or single selection
    func setMultiSelection() {
        isMultiSelect = true
    }
    
    //test > add a time delay to load all images (avoid flicker when loading images)
    func asyncReloadData(id: String) {
        
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.vCV?.reloadData()
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    //test > refresh grid selected order
    func refreshGridSelectedOrder() {
        var n = 0
        for i in selectedGridAssetDataList {
            let data = vDataList[i]
            print("Asset URL x: \(i), \(n)")
            data.setSelectedOrder(i: n)
            
            let vc = vCV?.cellForItem(at: IndexPath(item: i, section: 0))
            guard let b = vc as? GridVideoRollViewCell else {
                return
            }
            b.refreshSelectorOrder(gridAsset: data)
            
            n += 1
        }
    }
}

extension CameraVideoRollPanelView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("userpanel collection: \(section)")
        return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 50.0, right: 20.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("cameraroll collection 2: \(indexPath)")
        
        let widthPerItem = (collectionView.frame.width - gLhsMargin - gRhsMargin - gLineSpacingHeight * 2) / 3
        let heightPerItem = widthPerItem * 3 / 2
        return CGSize(width: widthPerItem, height: heightPerItem) //test
    }
}

//test > try scrollview listener
extension CameraVideoRollPanelView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollview end: \(scrollView.contentOffset.y)")
        
        //test
        if(scrollView.contentOffset.y == 0) {
            isScrollViewAtTop = true
        } else {
            isScrollViewAtTop = false
        }
        print("scrollview end: \(scrollView.contentOffset.y), \(isScrollViewAtTop)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
        if(!decelerate) {
            
            //test
            if(scrollView.contentOffset.y == 0) {
                isScrollViewAtTop = true
            } else {
                isScrollViewAtTop = false
            }
            print("scrollview end drag check: \(isScrollViewAtTop)")
        }
    }
    
    //test > footer
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
}

extension CameraVideoRollPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridVideoRollViewCell.identifier, for: indexPath) as! GridVideoRollViewCell
        
        cell.aDelegate = self
        let model = vDataList[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridVideoRollViewCell.identifier, for: indexPath) as! GridVideoRollViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")

//        let model = vDataList[indexPath.row]
//        delegate?.didClickVideoSelect(video: model, cameraRollPanel: self)
        
     }
}

extension CameraVideoRollPanelView: GridAssetDelegate {
    func gridAssetCellDidClickAsset(vc: UICollectionViewCell){
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let idxPath = a.indexPath(for: cell)
                    guard let indexPath = idxPath else {
                        return
                    }
                    
                    let data = vDataList[indexPath.row]
                    let selectOrder = data.selectedOrder
                    guard let model = data.model else {
                        return
                    }
                    
                    if(isMultiSelect) {
                        if let gridAsset = vc as? GridVideoRollViewCell {
                            PHCachingImageManager.default().requestAVAsset(forVideo: model, options: nil) { [weak self] (video, _, _) in
                                
                                guard let self = self else {
                                    return
                                }
                                
                                if let avVid = video {
                                    DispatchQueue.main.async {
                                        if let strURL = (video as? AVURLAsset)?.url.absoluteString {
                                            if(selectOrder == -1) {
                                                
                                                //test 2 > use custom cell
                                                let customCell = MultiSelectedCell(frame: CGRect(x: 0, y: 0, width: self.sPhotoSize, height: self.sPhotoSize))
                                                self.scrollView.addSubview(customCell)
                                                customCell.translatesAutoresizingMaskIntoConstraints = false
                                                if(self.photoViewList.isEmpty) {
                                                    customCell.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
                                                } else {
                                                    let lastArrayE = self.photoViewList[self.photoViewList.count - 1]
                                                    customCell.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                                                }
                                                customCell.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: 0).isActive = true
                                                customCell.widthAnchor.constraint(equalToConstant: self.sPhotoSize).isActive = true
                                                customCell.heightAnchor.constraint(equalToConstant: self.sPhotoSize).isActive = true
                                                customCell.redrawUI()
    //                                            customCell.configure(url: url)
                                                customCell.configure(with: model)
                                                customCell.aDelegate = self
                                                customCell.setGridIdx(idx: indexPath.row)
                                                
                                                self.photoViewList.append(customCell)
                                                self.multiSelectDataList.append(strURL)
                                                self.selectedGridAssetDataList.append(indexPath.row)
                                                
                                                //test > show order number in cell
                                                data.setSelectedOrder(i: self.selectedGridAssetDataList.count - 1)
                                                gridAsset.refreshSelectorOrder(gridAsset: data)
                                            } else {
                                                if let index = self.multiSelectDataList.firstIndex(of: strURL) {
                                                    self.photoViewList[index].removeFromSuperview()
                                                    self.photoViewList.remove(at: index)
                                                    if(index < self.photoViewList.count) {
                                                        if(index > 0) {
                                                            self.photoViewList[index].leadingAnchor.constraint(equalTo: self.photoViewList[index - 1].trailingAnchor, constant: 0).isActive = true
                                                        } else {
                                                            self.photoViewList[index].leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
                                                        }
                                                    }

                                                    self.multiSelectDataList.remove(at: index)
                                                    
                                                    //test > show order number in cell
                                                    data.setSelectedOrder(i: -1)
                                                    gridAsset.refreshSelectorOrder(gridAsset: data)
                                                    
                                                    if let gridIndex = self.selectedGridAssetDataList.firstIndex(of: indexPath.row) {
                                                        self.selectedGridAssetDataList.remove(at: gridIndex)
                                                    }
                                                    
                                                    self.refreshGridSelectedOrder()
                                                }
                                            }
                                            print("Asset vid URL[]: \(self.multiSelectDataList)")
                                            
                                            if(!self.photoViewList.isEmpty) {
                                                self.multiToolPanel.isHidden = false
                                                self.coverBottomCon.isHidden = false
                                            }
                                            else {
                                                self.multiToolPanel.isHidden = true
                                                self.coverBottomCon.isHidden = true
                                            }

                                            let contentWidth = self.sPhotoSize * CGFloat(self.photoViewList.count) + 20.0
                                            self.scrollView.contentSize = CGSize(width: contentWidth, height: self.sPhotoSize)
                                            
                                            //test > scroll to last selected photo
                                            let frame = self.scrollView.frame.size.width
                                            let cSize = self.scrollView.contentSize.width
                                            let diff = cSize - frame
                                            if(diff > 0) {
                                                self.scrollView.setContentOffset(CGPoint(x: diff, y: 0), animated: true)
                                            } else {
                                                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
//                        delegate?.didClickVideoSelect(video: model)
//                        
//                        UIView.animate(withDuration: 0.2, animations: {
//                            self.panelTopCons?.constant = 0
//                            self.layoutIfNeeded()
//                        }, completion: { _ in
//                            self.removeFromSuperview()
//                        })
                        
                        //test > convert PHAsset to AVAsset
                        PHCachingImageManager.default().requestAVAsset(forVideo: model, options: nil) { [weak self] (video, _, _) in
                            
                            guard let self = self else {
                                return
                            }
                            
                            if let avVid = video
                            {
                                DispatchQueue.main.async {
                                    if let strURL = (video as? AVURLAsset)?.url.absoluteString {
                                        self.multiSelectDataList.append(strURL)
                                        
                                        self.delegate?.didClickMultiVideoSelect(urls: self.multiSelectDataList)
                                        
                                        UIView.animate(withDuration: 0.2, animations: {
                                            self.panelTopCons?.constant = 0
                                            self.layoutIfNeeded()
                                        }, completion: { _ in
                                            self.removeFromSuperview()
                                            self.delegate?.didClickFinishCameraVideoRoll()
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                }
            }
        }
    }
}

extension CameraVideoRollPanelView: MultiSelectedCellDelegate {
    func didClickMultiSelectedCell(cell: MultiSelectedCell, gridIdx: Int){
        if(isMultiSelect) {
            if let index = self.photoViewList.firstIndex(of: cell) {
                print("MultiSelectedCell clicked \(index)")
                self.photoViewList[index].removeFromSuperview()
                self.photoViewList.remove(at: index)
                if(index < self.photoViewList.count) {
                    if(index > 0) {
                        self.photoViewList[index].leadingAnchor.constraint(equalTo: self.photoViewList[index - 1].trailingAnchor, constant: 0).isActive = true
                    } else {
                        self.photoViewList[index].leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
                    }
                }

                self.multiSelectDataList.remove(at: index)
                
                //test > show order number in cell
                let data = vDataList[gridIdx]
                data.setSelectedOrder(i: -1)
                let vc = vCV?.cellForItem(at: IndexPath(item: gridIdx, section: 0))
                guard let b = vc as? GridVideoRollViewCell else {
                    return
                }
                b.refreshSelectorOrder(gridAsset: data)

                self.selectedGridAssetDataList.remove(at: index)
                
                self.refreshGridSelectedOrder()
            }
            
            if(!self.photoViewList.isEmpty) {
                self.multiToolPanel.isHidden = false
                self.coverBottomCon.isHidden = false
            }
            else {
                self.multiToolPanel.isHidden = true
                self.coverBottomCon.isHidden = true
            }

            let contentWidth = self.sPhotoSize * CGFloat(self.photoViewList.count) + 20.0
            self.scrollView.contentSize = CGSize(width: contentWidth, height: self.sPhotoSize)
            
            //test > scroll to last selected photo
            let frame = self.scrollView.frame.size.width
            let cSize = self.scrollView.contentSize.width
            let diff = cSize - frame
            if(diff > 0) {
                self.scrollView.setContentOffset(CGPoint(x: diff, y: 0), animated: true)
            } else {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
}


