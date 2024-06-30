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
}
class CameraVideoRollPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var aView = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
//    var scrollablePanelHeight : CGFloat = 500.0
    
//    var vDataList = [String]()
    var vDataList = [PHAsset]()
    var isCameraRollInitialized = false
    var vCV : UICollectionView?
    
    weak var delegate : CameraVideoRollPanelDelegate?
    
    let pMiniError = UIView()
    var panelView = UIView()
    
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
        aView.backgroundColor = .clear
        
//        var panelView = UIView()
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panelView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
        panelTopCons?.isActive = true
        
        //test > sticky header
//        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
//        panelView.addSubview(aStickyHeader)
//        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
//        aStickyHeader.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
//        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
//        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        aStickyHeader.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
//        aStickyHeader.isHidden = true

        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panelView.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 50).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
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
        
        //test > uicollectionview for user videos
//        vDataList.append("a")
//        vDataList.append("a")
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
//        gridLayout.minimumLineSpacing = 20 //default: 8 => spacing between rows
        gridLayout.minimumLineSpacing = 8 //default: 8 => spacing between rows
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
        vCV.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 20).isActive = true
        vCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never

        //**test > error getting video/photo album
//        let lhsMiniError = UIView()
        pMiniError.backgroundColor = .red
        panelView.addSubview(pMiniError)
        pMiniError.translatesAutoresizingMaskIntoConstraints = false
        pMiniError.centerXAnchor.constraint(equalTo: panelView.centerXAnchor, constant: 0).isActive = true
        pMiniError.centerYAnchor.constraint(equalTo: panelView.centerYAnchor, constant: -20).isActive = true
        pMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pMiniError.layer.cornerRadius = 10
        
        let aBBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        aBBtn.tintColor = .white
        pMiniError.addSubview(aBBtn)
        aBBtn.translatesAutoresizingMaskIntoConstraints = false
        aBBtn.centerXAnchor.constraint(equalTo: pMiniError.centerXAnchor).isActive = true
        aBBtn.centerYAnchor.constraint(equalTo: pMiniError.centerYAnchor).isActive = true
        aBBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        aBBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        //**
        
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
    
    @objc func onCameraRollPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            self.currentPanelTopCons = self.panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
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
                    self.panelTopCons?.constant = -self.viewHeight
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            }
        }
    }
    
    //test
    var isStoragePermissionNotDetermined = false
    func openStorageErrorPromptMsg() {
        let sPanel = GetStorageMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panelView.addSubview(sPanel)
        sPanel.translatesAutoresizingMaskIntoConstraints = false
        sPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        sPanel.delegate = self
    }
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
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
//
//            // Handle restricted or denied state
//            if status == .restricted || status == .denied {
//                print("Status: Restricted or Denied")
//            }
//
//            // Handle limited state
//            if status == .limited {
//                self?.retrieveVideoFilesFromCameraRoll()
////                self?.fetchVideoCollection()
//                print("Status: Limited")
//            }
//
//            // Handle authorized state
//            if status == .authorized {
//                self?.retrieveVideoFilesFromCameraRoll()
////                self?.fetchVideoCollection()
//                print("Status: Full access")
//            }
//        }
        
        //test 2 > use authorizationstatus instead
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            print("storage permission not determined")
            pMiniError.isHidden = false
            isStoragePermissionNotDetermined = true
            
            openStorageErrorPromptMsg()
        case .restricted:
            print("storage permission restricted")
            pMiniError.isHidden = false
            isStoragePermissionNotDetermined = false
            
            openStorageErrorPromptMsg()
        case .limited:
            print("storage permission limited")
            pMiniError.isHidden = false
            isStoragePermissionNotDetermined = false
            
            openStorageErrorPromptMsg()
        case .denied:
            print("storage permission denied")
            pMiniError.isHidden = false
            isStoragePermissionNotDetermined = false
            
            openStorageErrorPromptMsg()
        case .authorized:
            print("storage permission authorized")
            pMiniError.isHidden = true
            isStoragePermissionNotDetermined = false
            
            self.retrieveVideoFilesFromCameraRoll()
        @unknown default:
            pMiniError.isHidden = false
            isStoragePermissionNotDetermined = false
            
            openStorageErrorPromptMsg()
            break
        }
    }
    
    func retrieveVideoFilesFromCameraRoll() {
        let option = PHFetchOptions()
//        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let sort = NSSortDescriptor(key: "modificationDate", ascending: false)
        option.sortDescriptors = [sort]
        
        // Fetch all video assets from the Photos Library as fetch results
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: option)
        
        // Loop through all fetched results
        fetchResults.enumerateObjects({ [weak self] (object, count, stop) in
            
            // Add video object to our video array
            self?.vDataList.append(object)
//            self?.vDataList.append("a")
            print("fetchVideos success \(object), \(count)")
        })
        
        // Reload the table view on the main thread
        DispatchQueue.main.async {
            self.vCV?.reloadData()
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
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
//        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
//        let widthPerItem = collectionView.frame.width / 3 - 40
//        return CGSize(width: widthPerItem - 8, height: 250)
//        return CGSize(width: widthPerItem, height: 160)
        let widthPerItem = (collectionView.frame.width - 20 * 2 - 2 * 8)/3 //8 between columns
        return CGSize(width: widthPerItem, height: 180) //default: 110, 160
    }
}

extension CameraVideoRollPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridVideoRollViewCell.identifier, for: indexPath) as! GridVideoRollViewCell
        
//        cell.aDelegate = self
        let model = vDataList[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridVideoRollViewCell.identifier, for: indexPath) as! GridVideoRollViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")

        //test > trigger finish close panel
//        self.removeFromSuperview()
//        self.delegate?.didClickFinishCameraVideoRoll()

        let model = vDataList[indexPath.row]
        delegate?.didClickVideoSelect(video: model)
        
     }
}

extension VideoCreatorConsolePanelView: CameraVideoRollPanelDelegate{
    func didInitializeCameraVideoRoll() {
        //test to turn off camera
//        session?.removeInput(videoDeviceInput!) //test
//        self.session?.stopRunning()
    }
    func didClickFinishCameraVideoRoll() {
        backPage()
        
        //test > recheck cameraroll permission and update UI
        checkCameraRollPermission(isToOpen: false)
    }
    func didClickVideoSelect(video: PHAsset) {
//        openVideoEditor()
        
        //test > convert PHAsset to AVAsset
        PHCachingImageManager.default().requestAVAsset(forVideo: video, options: nil) { [weak self] (video, _, _) in

            if let avVid = video
            {
                DispatchQueue.main.async {
                    //test 1 > open with video asset => tested OK
//                    self?.openVideoEditor(video: avVid)
                    
                    //test 2 > open with url => tested OK
                    //try get url from avasset
                    if let strURL = (video as? AVURLAsset)?.url.absoluteString {
                        print("VIDEO URL: ", strURL)
                        
                        if let s = self {
                            print("openvideoeditor: \(s.pageList)")
                            
                            //test 1
//                            if (s.pageList.isEmpty) {
//                                s.openVideoEditor(strVUrl: strURL)
//                            } else {
//                                if let c = s.pageList[s.pageList.count - 1] as? VideoEditorPanelView {
//                                    c.addVideoClip(strVUrl: strURL)
//                                } else {
//                                    s.openVideoEditor(strVUrl: strURL)
//                                }
//                            }
//
                            
                            //test 2
                            if (s.pageList.count > 1) {
                                if let c = s.pageList[s.pageList.count - 1] as? CameraVideoRollPanelView {
                                    c.removeFromSuperview()
                                    s.backPage()
                                    
                                    if let c = s.pageList[s.pageList.count - 1] as? VideoEditorPanelView {
                                        c.addVideoClip(strVUrl: strURL)
                                    }
                                }
                            } else {
                                if let c = s.pageList[s.pageList.count - 1] as? CameraVideoRollPanelView {
                                    s.openVideoEditor(strVUrl: strURL)
                                }
                            }

                        }
                    }
                }
            }
        }
    }
}

extension CameraVideoRollPanelView: GetStorageMsgDelegate{

    func didGSClickProceed() {
        
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
                    self?.pMiniError.isHidden = true
                    self?.isStoragePermissionNotDetermined = false
                    self?.retrieveVideoFilesFromCameraRoll()
                }
            }
        } else {
            openAppIOSPublicSetting()
        }
    }
    func didGSClickDeny() {

    }
}
