//
//  CameraPhotoRollPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import PhotosUI
import Photos

protocol CameraPhotoRollPanelDelegate : AnyObject {
    func didInitializeCameraPhotoRoll()
    func didClickFinishCameraPhotoRoll()
    func didClickPhotoSelect(photo: PHAsset)
    func didClickMultiPhotoSelect(urls: [URL])
}
class CameraPhotoRollPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var aView = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    var vDataList = [PHAsset]()
    var isCameraRollInitialized = false
    var vCV : UICollectionView?
    
    weak var delegate : CameraPhotoRollPanelDelegate?
    
    let pMiniError = UIView()
    var panelView = UIView()
    
    var isMultiSelect = false
    var multiSelectDataList = [URL]()
    let multiToolPanel = UIView()
    let scrollView = UIScrollView()
    var photoViewList = [SDAnimatedImageView]()
    
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
        vCV.register(GridPhotoRollViewCell.self, forCellWithReuseIdentifier: GridPhotoRollViewCell.identifier)
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
        
        //**test > tools panel for multi selection
//        let multiToolPanel = UIView()
        multiToolPanel.backgroundColor = .ddmBlackOverlayColor //black
//        multiToolPanel.backgroundColor = .black //black
        panelView.addSubview(multiToolPanel)
        multiToolPanel.translatesAutoresizingMaskIntoConstraints = false
        multiToolPanel.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
//        multiToolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomInset).isActive = true
        multiToolPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        multiToolPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        multiToolPanel.layer.cornerRadius = 0
        multiToolPanel.heightAnchor.constraint(equalToConstant: 120).isActive = true //60
        multiToolPanel.isHidden = true
        
        let aUpload = UIView()
        aUpload.backgroundColor = .yellow
//        panel.addSubview(aUpload)
        multiToolPanel.addSubview(aUpload)
        aUpload.translatesAutoresizingMaskIntoConstraints = false
        aUpload.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aUpload.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aUpload.topAnchor.constraint(equalTo: multiToolPanel.topAnchor, constant: 20).isActive = true
        aUpload.trailingAnchor.constraint(equalTo: multiToolPanel.trailingAnchor, constant: -20).isActive = true
//        aUpload.centerYAnchor.constraint(equalTo: stack2.centerYAnchor).isActive = true
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
        scrollView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
//        let contentWidth = viewWidth * 2
//        scrollView.contentSize = CGSize(width: contentWidth, height: 400.0) //800, 280
//        scrollView.isPagingEnabled = true //false
//        scrollView.delegate = self

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
            self.delegate?.didInitializeCameraPhotoRoll()
        }
    }
    
    @objc func onCloseCameraRollClicked(gesture: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            
            //test > trigger finish close panel
            self.delegate?.didClickFinishCameraPhotoRoll()
        })
    }
    
    @objc func onCameraRollMultiSelectNextClicked(gesture: UITapGestureRecognizer) {
        
        self.delegate?.didClickMultiPhotoSelect(urls: multiSelectDataList)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            
            //test > trigger finish close panel
//            self.delegate?.didClickFinishCameraPhotoRoll()
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
                    self.delegate?.didClickFinishCameraPhotoRoll()
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
//                self?.retrievePhotoFilesFromCameraRoll()
//                print("Status: Limited")
//            }
//
//            // Handle authorized state
//            if status == .authorized {
//                self?.retrievePhotoFilesFromCameraRoll()
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
            isStoragePermissionNotDetermined = false
            pMiniError.isHidden = false
            
            openStorageErrorPromptMsg()
        case .limited:
            print("storage permission limited")
            isStoragePermissionNotDetermined = false
            pMiniError.isHidden = false
            
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
            
            self.retrievePhotoFilesFromCameraRoll()
        @unknown default:
            pMiniError.isHidden = false
            isStoragePermissionNotDetermined = false
            
            openStorageErrorPromptMsg()
            break
        }
    }
    
    func retrievePhotoFilesFromCameraRoll() {
        let option = PHFetchOptions()
//        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let sort = NSSortDescriptor(key: "modificationDate", ascending: false)
        option.sortDescriptors = [sort]
        
        // Fetch all video assets from the Photos Library as fetch results
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: option)
        
        // Loop through all fetched results
        fetchResults.enumerateObjects({ [weak self] (object, count, stop) in
            
            // Add video object to our video array
            self?.vDataList.append(object)
            print("fetchVideos success \(object), \(count)")
        })
        
        // Reload the table view on the main thread
        DispatchQueue.main.async {
            self.vCV?.reloadData()
        }
    }
    
    //test > set camera roll to be multi or single selection
    func setMultiSelection() {
        isMultiSelect = true
        multiToolPanel.isHidden = false
    }
}

extension CameraPhotoRollPanelView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("userpanel collection: \(section)")
        return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 150.0, right: 20.0) //bottom 50
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
        return CGSize(width: widthPerItem, height: widthPerItem) //default: 110, 160
    }
}

extension CameraPhotoRollPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPhotoRollViewCell.identifier, for: indexPath) as! GridPhotoRollViewCell
        
//        cell.aDelegate = self
        let model = vDataList[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPhotoRollViewCell.identifier, for: indexPath) as! GridPhotoRollViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")

        let model = vDataList[indexPath.row]
        
        if(isMultiSelect) {
            
            let options = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            
            model.requestContentEditingInput(with: options) { (input, _) in
                if let url = input?.fullSizeImageURL {
                    DispatchQueue.main.async {
                        if(!self.multiSelectDataList.contains(url)) {
                            
                            let gifImage1 = SDAnimatedImageView()
                            gifImage1.contentMode = .scaleAspectFill
                            gifImage1.clipsToBounds = true
                            gifImage1.sd_setImage(with: url)
                            self.scrollView.addSubview(gifImage1)
                            gifImage1.translatesAutoresizingMaskIntoConstraints = false
                            gifImage1.widthAnchor.constraint(equalToConstant: 60).isActive = true //180
                            gifImage1.heightAnchor.constraint(equalToConstant: 60.0).isActive = true //280
                            gifImage1.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
                            gifImage1.layer.cornerRadius = 5
                            
                            if(self.photoViewList.isEmpty) {
                                gifImage1.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
                            } else {
                                gifImage1.leadingAnchor.constraint(equalTo: self.photoViewList[self.photoViewList.count - 1].trailingAnchor, constant: 20).isActive = true
                            }
                            
                            self.photoViewList.append(gifImage1)
                            self.multiSelectDataList.append(url)
                        } else {
                            if let index = self.multiSelectDataList.firstIndex(of: url) {
                                self.photoViewList[index].removeFromSuperview()
                                self.photoViewList.remove(at: index)
                                if(index < self.photoViewList.count) {
                                    if(index > 0) {
                                        self.photoViewList[index].leadingAnchor.constraint(equalTo: self.photoViewList[index - 1].trailingAnchor, constant: 20).isActive = true
                                    } else {
                                        self.photoViewList[index].leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
                                    }
                                }

                                self.multiSelectDataList.remove(at: index)
                            }
                        }
                        print("Asset URL[]: \(self.multiSelectDataList)")
                        
                        let contentWidth = 60.0 * CGFloat(self.photoViewList.count) + 20.0 + CGFloat(self.photoViewList.count - 1) * 20.0
                        self.scrollView.contentSize = CGSize(width: contentWidth, height: 60.0) //800, 280
                    }
                }
            }
        } else {
            delegate?.didClickPhotoSelect(photo: model)
        }
     }
}

extension CameraPhotoRollPanelView: GetStorageMsgDelegate{

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
                    self?.retrievePhotoFilesFromCameraRoll()
                }
            }
        } else {
            openAppIOSPublicSetting()
        }
    }
    func didGSClickDeny() {

    }
}

