//
//  PhotoDetailPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PhotoDetailPanelDelegate : AnyObject {
    func didClickPhotoDetailPanelVcvClickPost() //try
    func didClickPhotoDetailPanelVcvClickUser() //try
    func didClickPhotoDetailClosePanel()
    func didClickPhotoDetailPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
}

class PhotoDetailPanelView: PanelView {
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelLeadingCons : CGFloat = 0.0
    var panel = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aStickyHeader = UIView()
    var photoCV : UICollectionView?
//    var vcDataList = [PhotoData]()
    var vcDataList = [BaseData]()
    
    var isScrollViewAtTop = true
    var scrollViewInitialY : CGFloat = 0.0
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    weak var delegate : PhotoDetailPanelDelegate?
    
    var postHeight = 0.0
    var stickyH1TopCons: NSLayoutConstraint?
    var stickyH2TopCons: NSLayoutConstraint?
    
    //test
    var hideCellIndex = -1
    //test > record which cell video is playing
    var currentPlayingVidIndex = -1
    //test > for video autoplay when user opens
    var isFeedDisplayed = false
    
    //test > track comment scrollable view
    var pageList = [PanelView]()
    
    let bottomBox = UIView()
    
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
        //test 1 > list view of videos
        panel.backgroundColor = .ddmBlackOverlayColor
//        soundPanel.backgroundColor = .blue
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
//        soundPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
//        soundPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        //test
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        panelLeadingCons?.isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10 //20
//        let videoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let photoCV = photoCV else {
            return
        }
        photoCV.register(HCommentListViewCell.self, forCellWithReuseIdentifier: HCommentListViewCell.identifier)
//        photoCV.register(HPhotoListViewCell.self, forCellWithReuseIdentifier: HPhotoListViewCell.identifier)
        photoCV.register(HPhotoListBViewCell.self, forCellWithReuseIdentifier: HPhotoListBViewCell.identifier)
//        photoCV.isPagingEnabled = true
        photoCV.dataSource = self
        photoCV.delegate = self
        photoCV.showsVerticalScrollIndicator = false //false
//        photoCV.backgroundColor = .blue
        photoCV.backgroundColor = .clear
        panel.addSubview(photoCV)
        photoCV.translatesAutoresizingMaskIntoConstraints = false
        photoCV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        photoCV.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
//        photoCV.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        photoCV.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        photoCV.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        photoCV.contentInsetAdjustmentBehavior = .never
        //test
        photoCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        //test > top spinner
        photoCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.topAnchor.constraint(equalTo: postCV.topAnchor, constant: CGFloat(-35)).isActive = true
        aSpinner.topAnchor.constraint(equalTo: photoCV.topAnchor, constant: CGFloat(35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: photoCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > add footer ***
        photoCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
        //test > sticky header
        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
//        aStickyHeader.layer.opacity = 0.3
        aStickyHeader.isUserInteractionEnabled = true
        aStickyHeader.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStickyHeaderClicked)))
        aStickyHeader.clipsToBounds = true
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        aStickyHeader.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let stickyHLight = UIView()
//        stickyHLight.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(stickyHLight)
        stickyHLight.translatesAutoresizingMaskIntoConstraints = false
        stickyHLight.centerXAnchor.constraint(equalTo: aStickyHeader.centerXAnchor, constant: 0).isActive = true
        stickyHLight.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        stickyH1TopCons = stickyHLight.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0)
        stickyH1TopCons?.isActive = true
        
        let aTabText = UILabel()
        aTabText.textAlignment = .center
        aTabText.textColor = .white
        aTabText.font = .boldSystemFont(ofSize: 15) //default 14
        aTabText.text = "Shot"
        stickyHLight.addSubview(aTabText)
        aTabText.translatesAutoresizingMaskIntoConstraints = false
        aTabText.leadingAnchor.constraint(equalTo: stickyHLight.leadingAnchor, constant: 0).isActive = true
        aTabText.trailingAnchor.constraint(equalTo: stickyHLight.trailingAnchor, constant: 0).isActive = true
        aTabText.centerYAnchor.constraint(equalTo: stickyHLight.centerYAnchor).isActive = true
        
        let stickyHLight2 = UIView()
//        stickyHLight.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(stickyHLight2)
        stickyHLight2.translatesAutoresizingMaskIntoConstraints = false
        stickyHLight2.centerXAnchor.constraint(equalTo: aStickyHeader.centerXAnchor, constant: 0).isActive = true
        stickyHLight2.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        stickyH2TopCons = stickyHLight2.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50)
        stickyH2TopCons?.isActive = true
        
        let aTabText2 = UILabel()
        aTabText2.textAlignment = .center
        aTabText2.textColor = .white
        aTabText2.font = .boldSystemFont(ofSize: 13) //default 14
        aTabText2.text = "358 Comments"
        stickyHLight2.addSubview(aTabText2)
        aTabText2.translatesAutoresizingMaskIntoConstraints = false
        aTabText2.leadingAnchor.constraint(equalTo: stickyHLight2.leadingAnchor, constant: 0).isActive = true
        aTabText2.centerYAnchor.constraint(equalTo: stickyHLight2.centerYAnchor).isActive = true
        
        let aTabText2Btn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
//            aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        aTabText2Btn.tintColor = .white
        stickyHLight2.addSubview(aTabText2Btn)
        aTabText2Btn.translatesAutoresizingMaskIntoConstraints = false
        aTabText2Btn.leadingAnchor.constraint(equalTo: aTabText2.trailingAnchor).isActive = true
        aTabText2Btn.trailingAnchor.constraint(equalTo: stickyHLight2.trailingAnchor, constant: 0).isActive = true
        aTabText2Btn.centerYAnchor.constraint(equalTo: aTabText2.centerYAnchor).isActive = true
        aTabText2Btn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        aTabText2Btn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test bottom comment box => fake edittext
//        let bottomBox = UIView()
//        bottomBox.backgroundColor = .black
        bottomBox.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(bottomBox)
        bottomBox.clipsToBounds = true
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        bottomBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        bottomBox.heightAnchor.constraint(equalToConstant: 94).isActive = true //default: 50
        bottomBox.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        bottomBox.isUserInteractionEnabled = true
//        bottomBox.isHidden = true
        
        let aaView = UIView()
//        aaView.backgroundColor = .ddmDarkColor
        aaView.backgroundColor = .ddmBlackOverlayColor
        bottomBox.addSubview(aaView)
        aaView.translatesAutoresizingMaskIntoConstraints = false
        aaView.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 10).isActive = true
        aaView.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        aaView.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: -10).isActive = true //-10
        aaView.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 15).isActive = true
        aaView.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15).isActive = true
//        aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15)
//        aaViewTrailingCons?.isActive = true
        aaView.layer.cornerRadius = 10
        
        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 13)
        bottomBox.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
//        bText.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 20).isActive = true //15
        bText.leadingAnchor.constraint(equalTo: aaView.leadingAnchor, constant: 10).isActive = true //15
        bText.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -60).isActive = true
//        bText.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 15).isActive = true
        bText.centerYAnchor.constraint(equalTo: aaView.centerYAnchor, constant: 0).isActive = true
//        bText.text = "Reply to @michaelkins..."
        bText.text = "Add comment..."
        bText.layer.opacity = 0.5

        let bTextBtn = UIImageView()
        bTextBtn.image = UIImage(named:"icon_round_send")?.withRenderingMode(.alwaysTemplate)
        bTextBtn.tintColor = .white
        bTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(bTextBtn)
        bTextBtn.translatesAutoresizingMaskIntoConstraints = false
//        bTextBtn.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15).isActive = true
        bTextBtn.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10).isActive = true
        bTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        bTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bTextBtn.isHidden = true
        
        let lTextBtn = UIImageView()
        lTextBtn.image = UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate)
        lTextBtn.tintColor = .white
        lTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(lTextBtn)
        lTextBtn.translatesAutoresizingMaskIntoConstraints = false
//        lTextBtn.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15).isActive = true
        lTextBtn.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10).isActive = true
        lTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        lTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        lTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        lTextBtn.isHidden = false

        let mTextBtn = UIImageView()
        mTextBtn.image = UIImage(named:"icon_round_emoji")?.withRenderingMode(.alwaysTemplate)
        mTextBtn.tintColor = .white
        mTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(mTextBtn)
        mTextBtn.translatesAutoresizingMaskIntoConstraints = false
        mTextBtn.trailingAnchor.constraint(equalTo: lTextBtn.leadingAnchor, constant: -10).isActive = true
        mTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        mTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        mTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        mTextBtn.isHidden = false

        let nTextBtn = UIImageView()
        nTextBtn.image = UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate)
        nTextBtn.tintColor = .white
        nTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(nTextBtn)
        nTextBtn.translatesAutoresizingMaskIntoConstraints = false
        nTextBtn.trailingAnchor.constraint(equalTo: mTextBtn.leadingAnchor, constant: -10).isActive = true
        nTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        nTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        nTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        nTextBtn.isHidden = false
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        self.addGestureRecognizer(panelPanGesture)
    }
    
    @objc func onBackPanelClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
        
//        bSpinner.startAnimating()
    }
    
    @objc func onStickyHeaderClicked(gesture: UITapGestureRecognizer) {
        print("sticky header clicked")
        
        //test
        photoCV?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    var direction = "na"
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            
            print("t1 onPanelPanGesture begin: ")
            self.currentPanelLeadingCons = self.panelLeadingCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            //test > determine direction of scroll
//            print("t1 onSoundPanelPanGesture changed: \(x), \(self.soundPanelLeadingCons!.constant)")
            if(direction == "na") {
                if(abs(x) > abs(y)) {
                    direction = "x"
                } else {
                    direction = "y"
                }
            }
            if(direction == "x") {
                var newX = self.currentPanelLeadingCons + x
                if(newX < 0) {
                    newX = 0
                }
                self.panelLeadingCons?.constant = newX
            }
        } else if(gesture.state == .ended){
            
            print("t1 onPanelPanGesture ended: ")
            if(self.panelLeadingCons!.constant - self.currentPanelLeadingCons < 75) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelLeadingCons?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            } else {
                closePanel(isAnimated: true)
            }
            
            //test > determine direction of scroll
            direction = "na"
        }
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
//            self.asyncFetchFeed(id: "comment_feed")
            self.asyncFetchPost(id: "post")
        }
        
        isInitialized = true
        
        print("pdpv init")
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelLeadingCons?.constant = self.frame.width
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                //move back to origin
                self.panelLeadingCons?.constant = 0
                self.delegate?.didClickPhotoDetailClosePanel()
            })
        } else {
            self.removeFromSuperview()
            self.delegate?.didClickPhotoDetailClosePanel()
        }
    }
    
    //helper function: top and bottom margin to accomodate spinners while fetching data
    func adjustContentInset(topInset: CGFloat, bottomInset: CGFloat) {
        self.photoCV?.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    func adjustContentOffset(x: CGFloat, y: CGFloat, animated: Bool) {
        self.photoCV?.setContentOffset(CGPoint(x: x, y: y), animated: true)
    }
    
    //*test > remove one comment
    var selectedItemIdx = -1
    func removeData(idxToRemove: Int) {
        if(!vcDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < vcDataList.count) {
                if(idxToRemove == 0) {
                    var indexPaths = [IndexPath]()
                    var i = 0
                    for _ in vcDataList {
                        let idx = IndexPath(item: i, section: 0)
                        indexPaths.append(idx)
                        i += 1
                    }
                    vcDataList.removeAll()
                    self.photoCV?.deleteItems(at: indexPaths)
                } else {
                    var indexPaths = [IndexPath]()
                    let idx = IndexPath(item: idxToRemove, section: 0)
                    indexPaths.append(idx)
                    
                    vcDataList.remove(at: idxToRemove)
                    self.photoCV?.deleteItems(at: indexPaths)
                }
            
                unselectItemData()
                
                //test
                if(vcDataList.isEmpty) {
                    //entire post is deleted
                    self.setFooterAaText(text: "Shot no longer exists.")
                    self.configureFooterUI(data: "na")
//                    self.aaText.text = "Shot no longer exists."
                }
                else if(vcDataList.count == 1) {
                    //no more comments
                    self.setFooterAaText(text: "No comments yet.")
                    self.configureFooterUI(data: "na")
//                    self.aaText.text = "No comments yet."
                }
            }
        }
    }
//    func removeDataSet(idxToRemove: [Int]) {
//        if(!vDataList.isEmpty) {
//            var indexPaths = [IndexPath]()
//            for i in idxToRemove {
//                vDataList.remove(at: i)
//
//                let idx = IndexPath(item: i, section: 0)
//                indexPaths.append(idx)
//            }
//            self.vCV?.deleteItems(at: indexPaths)
//        }
//    }
    func unselectItemData() {
        selectedItemIdx = -1
    }
    //*
    
    //test > fetch post before comments
    func asyncFetchPost(id: String) {
        aSpinner.startAnimating()
        
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test 2 > new append method
//                    let postData = PostData()
                    let postData = PhotoData()
                    postData.setDataType(data: "a") //"b"
                    postData.setData(data: "a")
                    postData.setTextString(data: "a")
                    self.vcDataList.append(postData)
                    self.photoCV?.reloadData()
                    
                    self.aSpinner.stopAnimating()

                    self.asyncFetchFeed(id: "comment_feed")
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        print("pdp asyncfetch")
        dataFetchState = "start"
        bSpinner.startAnimating()
        
        let id_ = "post"
        let isPaginate = false
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    self.dataFetchState = "end"
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vcDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
//                        let photoData = PhotoData()
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        self.vcDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.photoCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        self.setFooterAaText(text: "No comments yet.")
                        self.configureFooterUI(data: "na")
//                        self.aaText.text = "No comments yet."
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("pdp api fail")
                    self?.bSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    func asyncPaginateFetchFeed(id: String) {
        print("pdpv asyncpaginate")
        bSpinner.startAnimating()
        
        pageNumber += 1
        
        let id_ = "post"
        let isPaginate = true
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l), \(l.isEmpty)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    if(l.isEmpty) {
                        self.dataPaginateStatus = "end"
                    }
                    //test
                    self.bSpinner.stopAnimating()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vcDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
//                        let photoData = PhotoData()
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        self.vcDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.photoCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("pdp api fail")
                    self?.bSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        if(self.vcDataList.count > 1) {
            let dataCount = self.vcDataList.count
            var indexPaths = [IndexPath]()
            let endIndex = dataCount - 1
            for i in 1...endIndex { //loop from 1 to endindex
                let idx = IndexPath(item: i, section: 0)
                indexPaths.append(idx)
            }
            self.vcDataList.removeSubrange(1..<endIndex + 1) //remove element from 1 to endindex
            self.photoCV?.deleteItems(at: indexPaths)
        }
        configureFooterUI(data: "")
        
        dataFetchState = ""
        dataPaginateStatus = ""
        self.asyncFetchFeed(id: "comment_feed")
    }
    
    //test > footer error handling for refresh feed
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error refresh clicked")
        refreshFetchData()
    }
    
    var footerState = ""
    var footerAaText = ""
    func setFooterAaText(text: String) {
        footerAaText = text
    }
    func configureFooterUI(data: String) {
        aaText.text = ""
        errorText.text = ""
        errorRefreshBtn.isHidden = true
        
        if(data == "end") {
            aaText.text = "End"
        }
        else if(data == "e") {
            errorText.text = "Unable to load comments. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            aaText.text = footerAaText
            //removed, text to be customized at panelview level
        }
        
        footerState = data
    }
    
    //test > sticky header title animation when scroll up and down
    var isStickyCommentTitleDisplayed = false
    func stickyCommentTitleAnimateDisplay() {
        //title appear
        if(isStickyCommentTitleDisplayed == false) {
            UIView.animate(withDuration: 0.2, animations: {
                self.stickyH1TopCons?.constant = -50.0
                self.stickyH2TopCons?.constant = 0.0
                self.layoutIfNeeded()

                self.isStickyCommentTitleDisplayed = true
            })
        }
    }
    func stickyCommentTitleAnimateHide() {
        //title hide
        if(isStickyCommentTitleDisplayed == true) {
            UIView.animate(withDuration: 0.2, animations: {
                self.stickyH1TopCons?.constant = 0.0
                self.stickyH2TopCons?.constant = 50.0
                self.layoutIfNeeded()

                self.isStickyCommentTitleDisplayed = false
            })
        }
    }
    
    //test > share sheet
    func openShareSheet() {
        let sharePanel = ShareSheetScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(sharePanel)
        sharePanel.translatesAutoresizingMaskIntoConstraints = false
        sharePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sharePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        sharePanel.delegate = self
        
        //test > track comment scrollable view
        pageList.append(sharePanel)
    }
    
    //test > add comment panel
    func openComment() {
        let commentPanel = CommentScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        self.addSubview(commentPanel)
        panel.insertSubview(commentPanel, belowSubview: bottomBox)
        commentPanel.translatesAutoresizingMaskIntoConstraints = false
        commentPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        commentPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        commentPanel.delegate = self
        commentPanel.initialize()
        commentPanel.setBackgroundDark()
        
//        bottomBox.isHidden = false
        
        //test > track comment scrollable view
        pageList.append(commentPanel)
    }
    
    //test > stop current video for closing
    func pauseCurrentAudio() {
        guard let a = self.photoCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
//            guard let b = currentVc as? HPhotoListAViewCell else {
//                return
//            }
//            b.pauseAudio()
            if let b = currentVc as? HPhotoListBViewCell {
                b.pauseAudio()
            } else if let b1 = currentVc as? HCommentListViewCell {
//                b.resumeVideo()
            } else {

            }
            
            //test > new method to play sound, not automatic scroll and play
            currentPlayingVidIndex = -1
        }
    }
    //test > resume current video
    func resumeCurrentAudio() {
        guard let a = self.photoCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
//            guard let b = currentVc as? HPhotoListAViewCell else {
//                return
//            }
            if let b = currentVc as? HPhotoListBViewCell {
                b.resumeAudio()
            } else if let b1 = currentVc as? HCommentListViewCell {
//                b.resumeVideo()
            } else {

            }
        }
    }
    //test > dehide cell
    func dehideCell() {
        guard let a = self.photoCV else {
            return
        }

        let idxPath = IndexPath(item: hideCellIndex, section: 0)
        let currentVc = a.cellForItem(at: idxPath)
//        guard let b = currentVc as? HPhotoListBViewCell else {
//            return
//        }
//        b.dehideCell()
        if let b = currentVc as? HPhotoListBViewCell {
            b.dehideCell()
        } else if let b1 = currentVc as? HCommentListViewCell {
            b1.dehideCell()
        } else {

        }
        
        hideCellIndex = -1
    }
    
    //test
    override func resumeActiveState() {
        print("photodetailpanelview resume active")
//        resumeCurrentAudio()
//        
//        //test > dehide cell
//        dehideCell()
        
        //test > only resume video if no comment scrollable view/any other view
        if(pageList.isEmpty) {
            resumeCurrentAudio()
            
            //test > dehide cell
            dehideCell()
        }
        else {
            //dehide cell for commment view
            if let c = pageList[pageList.count - 1] as? CommentScrollableView {
                c.dehideCell()
            }
        }
    }
    
    //test > check for intersected dummy view with video while user scroll
    func getIntersectedIdx() -> Int {
        var intersectedIdx = -1
        if let v = photoCV {
            print("sfvideo ppv start \(v.visibleCells)")
            for cell in v.visibleCells {
                guard let indexPath = v.indexPath(for: cell) else {
                    continue
                }
//                guard let b = cell as? HPhotoListAViewCell else {
//                    return -1
//                }

                if let b = cell as? HPhotoListBViewCell {
                    let cellRect = v.convert(cell.frame, to: self)
                    let aTestRect = b.aTest.frame

                    if(!b.musicConArray.isEmpty) {
                        let vidC = b.musicConArray[0]
                        let vidCFrame = vidC.frame
                        let convertedVidCOriginY = cellRect.origin.y + aTestRect.origin.y + vidCFrame.origin.y
                        let convertedVidCRect = CGRect(x: 0, y: convertedVidCOriginY, width: vidCFrame.size.width, height: vidCFrame.size.height)
                        let dummyView = CGRect(x: 0, y: 100, width: self.frame.width, height: 400) //y:200, h:300
    //                    let dV = UIView(frame: dummyView)
    //                    dV.backgroundColor = .blue
    //                    self.addSubview(dV)
                        
                        let isIntersect = dummyView.intersects(convertedVidCRect)
                        let intersectArea = dummyView.intersection(convertedVidCRect)

                        print("sfvideo x ppv 3.0 collectionView index: \(indexPath), \(isIntersect), \(intersectArea)")
                        
                        //test > play video if intersect
                        if(isIntersect) {
                            intersectedIdx = indexPath.item
                        }
                    }
                }
                else if let c = cell as? HCommentListViewCell {
                    
                } else {
                    return -1
                }
            }
        }

        return intersectedIdx
    }
    
    //test > react to intersected video
    func reactToIntersectedAudio(intersectedIdx: Int) {
        guard let a = photoCV else {
            return
        }
        if(intersectedIdx > -1) {
            if(currentPlayingVidIndex > -1) {
                if(currentPlayingVidIndex != intersectedIdx) {
                    let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                    let idxPath = IndexPath(item: intersectedIdx, section: 0)
                    let prevVc = a.cellForItem(at: prevIdxPath)
                    let currentVc = a.cellForItem(at: idxPath)
//                    guard let b = prevVc as? HPhotoListAViewCell else {
//                        return
//                    }
//                    guard let c = currentVc as? HPhotoListAViewCell else {
//                        return
//                    }
//                    b.pauseAudio()
                    
                    //test > new method to play sound, not automatic scroll and play
//                    currentPlayingVidIndex = -1
                    
                    print("reactintersect photo A")
                    
                    //test 2 > include HCommentListViewCell
                    if let b = prevVc as? HPhotoListBViewCell {
                        b.pauseAudio()
                    } else if let b1 = prevVc as? HCommentListViewCell {

                    }
                    
                    if let c = currentVc as? HPhotoListBViewCell {

                    } else if let c1 = currentVc as? HCommentListViewCell {

                    }
                    
                    currentPlayingVidIndex = -1
                }
            } else {
                let idxPath = IndexPath(item: intersectedIdx, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                
                print("reactintersect photo B")
            }
        } else {
            //if intersectedIdx == -1, all video should pause/stop
            if(currentPlayingVidIndex > -1) {
                let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
//                guard let b = currentVc as? HPhotoListAViewCell else {
//                    return
//                }
//                b.pauseAudio()
//                currentPlayingVidIndex = -1
                
                //test 2 > include HCommentListViewCell
                if let b = currentVc as? HPhotoListBViewCell {
                    b.pauseAudio()
                    currentPlayingVidIndex = -1
                } else if let b1 = currentVc as? HCommentListViewCell {
                    
                }
                
                print("reactintersect photo B")
            }
        }
    }
}

extension PhotoDetailPanelView: UICollectionViewDelegateFlowLayout {
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let size = CGSize(width: textWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("postpanel collection 2: \(indexPath)")
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        if(indexPath.item == 0) {
            
            let text = vcDataList[indexPath.row].dataTextString
            let dataL = vcDataList[indexPath.row].dataArray
            
//            let xText = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀."
            let statText = "1.2m views . 3hr"
            var contentHeight = 0.0
            for l in dataL {
                if(l == "m") {
                    let pTopMargin = 0.0
                    let pContentHeight = 400.0 //280.0
                    let tTopMargin = 10.0
//                    let tText = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀."
                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
    //                let pHeight = pTopMargin + pContentHeight
                    let pBubbleTopMargin = 7.0
                    let pBubbleHeight = 3.0
                    let soundTopMargin = 10.0
                    let soundHeight = 16.0
                    let pHeight = pTopMargin + pContentHeight + pBubbleTopMargin + pBubbleHeight + tTopMargin + tContentHeight + soundTopMargin + soundHeight
                    contentHeight += pHeight
                }
                else if(l == "p") {
                    
                    let pTopMargin = 0.0
                    let pContentHeight = 400.0 //280.0
                    let tTopMargin = 10.0
//                    let tText = "Nice food, nice environment! Worth a visit. \nSo good!"
                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
    //                let pHeight = pTopMargin + pContentHeight
                    let pBubbleTopMargin = 7.0
                    let pBubbleHeight = 3.0
                    let pHeight = pTopMargin + pContentHeight + pBubbleTopMargin + pBubbleHeight + tTopMargin + tContentHeight
                    contentHeight += pHeight
                }
                else if(l == "q") {

                }
                else if(l == "c") {

                }
            }
            
            let userPhotoHeight = 40.0
            let userPhotoTopMargin = 10.0 //10
            let statTopMargin = 10.0 //number of views
            let statContentHeight = estimateHeight(text: statText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 12)
            let actionBtnTopMargin = 10.0
            let actionBtnHeight = 30.0
            let frameBottomMargin = 20.0 //10
            let locationTopMargin = 10.0
            let locationHeight = estimateHeight(text: "Petronas", textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) + 10
            let sortCommentBtnTopMargin = 30.0
            let sortCommentBtnHeight = 26.0

            let miscHeight = userPhotoHeight + userPhotoTopMargin + statTopMargin + statContentHeight + actionBtnTopMargin + actionBtnHeight + locationHeight + locationTopMargin + frameBottomMargin + sortCommentBtnTopMargin + sortCommentBtnHeight
            let totalHeight = contentHeight + miscHeight
            
            postHeight = totalHeight
            
            return CGSize(width: collectionView.frame.width, height: totalHeight)
            
        } else {
            
            let text = vcDataList[indexPath.row].dataTextString
            let dataL = vcDataList[indexPath.row].dataArray
            var contentHeight = 0.0
            for l in dataL {
                if(l == "t") {
                    let tTopMargin = 20.0
                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 53.0 - 30.0, fontSize: 13)
                    let tHeight = tTopMargin + tContentHeight
                    contentHeight += tHeight
                }
                else if(l == "p") {
                    let pTopMargin = 20.0
                    let pContentHeight = 280.0
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "p_s") {
                    let pTopMargin = 20.0
                    let pContentHeight = 280.0
                    let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += pHeight
                }
                else if(l == "v") {
                    let vTopMargin = 20.0
                    let vContentHeight = 350.0 //250
                    let vHeight = vTopMargin + vContentHeight
                    contentHeight += vHeight
                }
                else if(l == "v_l") {
                    let vTopMargin = 20.0
                    let vContentHeight = 350.0 //250
                    let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += vHeight
                }
                else if(l == "q") {
                    let qTopMargin = 20.0
                    let qUserPhotoHeight = 28.0
                    let qUserPhotoTopMargin = 10.0 //10
                    let qContentTopMargin = 10.0
                    let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
                    let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 53.0 - 20.0, fontSize: 13)
                    let qFrameBottomMargin = 20.0 //10
                    let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qContentTopMargin + qContentHeight + qFrameBottomMargin
                    contentHeight += qHeight
                }
                else if(l == "c") {

                }
            }
            
            let dataCh = vcDataList[indexPath.row].xChainDataArray
            for l in dataCh {
                let xText = l.dataTextString
                let xDataL = l.dataArray
                var yContentHeight = 0.0
                for y in xDataL {
                    if(y == "t") {
                        let xContentTopMargin = 20.0
                        let xContentHeight = estimateHeight(text: xText, textWidth: collectionView.frame.width - 53.0 - 20.0, fontSize: 13)
                        let xHeight = xContentTopMargin + xContentHeight
                        yContentHeight += xHeight
                    }
                    else if(y == "p") {
                        let pTopMargin = 20.0
                        let pContentHeight = 280.0
                        let pHeight = pTopMargin + pContentHeight
                        yContentHeight += pHeight
                    }
                    else if(y == "q") {
                        let qTopMargin = 20.0
                        let qUserPhotoHeight = 28.0
                        let qUserPhotoTopMargin = 10.0 //10
                        let qContentTopMargin = 10.0
                        let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
                        let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 53.0 - 20.0, fontSize: 13)
                        let qFrameBottomMargin = 20.0 //10
                        let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qContentTopMargin + qContentHeight + qFrameBottomMargin
                        yContentHeight += qHeight
                    }
                }
                let cUserPhotoHeight = 28.0
                let cUserPhotoTopMargin = 10.0 //10
                let cActionBtnTopMargin = 20.0
                let cActionBtnHeight = 26.0
                let cFrameBottomMargin = 10.0 //10
                let cHeight = cUserPhotoHeight + cUserPhotoTopMargin + yContentHeight + cActionBtnTopMargin + cActionBtnHeight + cFrameBottomMargin
                contentHeight += cHeight
            }
            
            let userPhotoHeight = 28.0
            let userPhotoTopMargin = 10.0 //10
            let actionBtnTopMargin = 20.0
            let actionBtnHeight = 26.0
            let frameBottomMargin = 20.0 //10
            let miscHeight = userPhotoHeight + userPhotoTopMargin + actionBtnTopMargin + actionBtnHeight + frameBottomMargin
            let totalHeight = contentHeight + miscHeight
            
            return CGSize(width: collectionView.frame.width, height: totalHeight)
        }
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("pdp footer reuse")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            header.addSubview(headerView)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
//            footer.addSubview(footerView)
            
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
//            footerView.backgroundColor = .ddmDarkColor
//            footerView.backgroundColor = .blue
            footer.addSubview(footerView)
//            footerView.isHidden = true

            aaText.textAlignment = .left
            aaText.textColor = .white
            aaText.font = .systemFont(ofSize: 12)
            footerView.addSubview(aaText)
            aaText.clipsToBounds = true
            aaText.translatesAutoresizingMaskIntoConstraints = false
//            aaText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            aaText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            aaText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            aaText.layer.opacity = 0.5
//            if(dataPaginateStatus == "end") {
//                aaText.text = "End"
//            } else {
//                aaText.text = ""
//            }
            
            bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
            footer.addSubview(bSpinner)
            bSpinner.translatesAutoresizingMaskIntoConstraints = false
//            bSpinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
            bSpinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
            bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            bSpinner.isHidden = true
            
            //test > error handling
            errorText.textAlignment = .center //left
            errorText.textColor = .white
            errorText.font = .systemFont(ofSize: 13)
            footerView.addSubview(errorText)
            errorText.clipsToBounds = true
            errorText.translatesAutoresizingMaskIntoConstraints = false
//            errorText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            errorText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            errorText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            errorText.text = ""
            
            errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
            footerView.addSubview(errorRefreshBtn)
            errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
            errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            errorRefreshBtn.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 10).isActive = true
            errorRefreshBtn.layer.cornerRadius = 20
            errorRefreshBtn.isUserInteractionEnabled = true
            errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
            errorRefreshBtn.isHidden = true
            
            let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
    //        bMiniBtn.tintColor = .black
            bMiniBtn.tintColor = .white
            errorRefreshBtn.addSubview(bMiniBtn)
            bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
            bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
            bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
            bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
            bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            configureFooterUI(data: footerState)
            
            return footer
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("postpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vcDataList.count - 1 {
            print("pdp willdisplay: \(indexPath.row)")

            //test 2 > added a check for dataFetchState == "end" to avoid fetch paginate when init()
            if(dataFetchState == "end") {
                if(dataPaginateStatus != "end") {
                    if(pageNumber >= 3) {
                        asyncPaginateFetchFeed(id: "comment_feed_end")
                    } else {
                        asyncPaginateFetchFeed(id: "comment_feed")
                    }
                }
            }
        }
        
        //test > for video autoplay when user opens
        if(!isFeedDisplayed) {
            if(indexPath.row == 0) {
                if let c = cell as? HPhotoListBViewCell {
//                    asyncAutoplay(id: "search_term")
                }

                isFeedDisplayed = true
            }
        }
    }
}

extension PhotoDetailPanelView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("p scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        scrollViewInitialY = scrollOffsetY
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("p scrollview scroll: \(scrollView.contentOffset.y)")

        let scrollOffsetY = scrollView.contentOffset.y
        let y = scrollViewInitialY - scrollOffsetY
        
//        if(y < 0) {
//            //pullup y
//        } else {
//
//        }

        //test > change title to comments when scrolled to comment section
        if(scrollOffsetY < postHeight) {
            stickyCommentTitleAnimateHide()
        } else {
            stickyCommentTitleAnimateDisplay()
        }
        print("p scrollview scroll: \(isStickyCommentTitleDisplayed), \(scrollView.contentOffset.y)")
        
        //test > react to intersected index
        reactToIntersectedAudio(intersectedIdx: getIntersectedIdx())
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("p scrollview end: \(scrollView.contentOffset.y)")
        
        //test
        let scrollOffsetY = scrollView.contentOffset.y
        if(scrollOffsetY == 0) {
            isScrollViewAtTop = true
        } else {
            isScrollViewAtTop = false
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("p scrollview end drag: \(scrollView.contentOffset.y)")
        
        //test
        let scrollOffsetY = scrollView.contentOffset.y
        
        //test > refresh dataset
        if(isScrollViewAtTop) {
            if(scrollOffsetY < -80) {

//                self.asyncFetchFeed(id: "comment_feed")
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        print("p scrollview animation ended")
        
        //test > reset contentInset to origin of y = 0
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50))
    }
}

extension PhotoDetailPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //test
        if(indexPath.item == 0) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPhotoListViewCell.identifier, for: indexPath) as! HPhotoListViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPhotoListBViewCell.identifier, for: indexPath) as! HPhotoListBViewCell
            cell.aDelegate = self
            
            //test > configure cell
            cell.configure(data: vcDataList[indexPath.row], width: self.frame.width)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCommentListViewCell.identifier, for: indexPath) as! HCommentListViewCell
            
            cell.aDelegate = self
            
            //test > configure cell
            let data = vcDataList[indexPath.row]
            cell.configure(data: data)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

     }
}

extension PhotoDetailPanelView: HListCellDelegate {
    func hListDidClickVcvComment(vc: UICollectionViewCell) {
        print("PostDetailPanelView comment clicked")
//        photoCV?.setContentOffset(CGPoint(x: 0.0, y: postHeight), animated: true)
        
        if let b = vc as? HPhotoListBViewCell {
            photoCV?.setContentOffset(CGPoint(x: 0.0, y: postHeight), animated: true)
        } else if let b1 = vc as? HCommentListViewCell {
            openComment()
        }
    }
    func hListDidClickVcvLove() {
        print("PostDetailPanelView love clicked")
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell) {
        print("PostDetailPanelView share clicked")
//        openShareSheet()
        
        if let a = photoCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let selectedIndexPath = a.indexPath(for: cell)
                    openShareSheet()
                    
                    if let c = selectedIndexPath {
                        selectedItemIdx = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickUser(){
        print("PostDetailPanelView user clicked")
        delegate?.didClickPhotoDetailPanelVcvClickUser()
    }
    func hListDidClickVcvClickPlace(){
//        delegate?.didClickPostPanelVcvClickPlace()
    }
    func hListDidClickVcvClickSound(){
//        delegate?.didClickPostPanelVcvClickSound()
    }
    func hListDidClickVcvClickPost() {
        print("PostDetailPanelView post clicked")
//        openPostDetail()
        delegate?.didClickPhotoDetailPanelVcvClickPost()
    }
    func hListDidClickVcvClickPhoto(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        pauseCurrentAudio()
        
        if let a = photoCV {

            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    //already converted cell origin to self, no need to add margin of scrollview
                    delegate?.didClickPhotoDetailPanelVcvClickPhoto(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickVideo(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
    }
    
    func hListDidClickVcvSortComment(){
        
    }
    
    func hListIsScrollCarousel(isScroll: Bool) {
        
    }
    
    func hListCarouselIdx(vc: UICollectionViewCell, idx: Int) {
        if let a = photoCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                print("sfphoto idx: \(cell == vc), \(indexPath)")
                
                if(cell == vc) {
                    vcDataList[indexPath.row].p_s = idx
                    break
                }
            }
        }
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, ts: Double){
        
    }
    
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        if let a = photoCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    print("sfphoto play audio: \(cell == vc), \(indexPath)")
                    let intersectedIdx = indexPath.row
                    if(currentPlayingVidIndex > -1) {
                        if(currentPlayingVidIndex != intersectedIdx) {
                            let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                            let idxPath = IndexPath(item: intersectedIdx, section: 0)
                            let prevVc = a.cellForItem(at: prevIdxPath)
                            let currentVc = a.cellForItem(at: idxPath)
//                            guard let b = prevVc as? HPhotoListAViewCell else {
//                                return
//                            }
//                            guard let c = currentVc as? HPhotoListAViewCell else {
//                                return
//                            }
                            
                            if let b = prevVc as? HPhotoListBViewCell {
                                b.pauseAudio()
                            } else if let b1 = prevVc as? HCommentListViewCell {

                            }
                            
                            if let c = currentVc as? HPhotoListBViewCell {
                                c.resumeAudio()
                            } else if let c1 = currentVc as? HCommentListViewCell {

                            }
                            currentPlayingVidIndex = intersectedIdx
                            
                            print("reactintersect photo play AA")
                        } else {
                            let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                            let prevVc = a.cellForItem(at: prevIdxPath)
//                            guard let b = prevVc as? HPhotoListAViewCell else {
//                                return
//                            }
                            if let b = prevVc as? HPhotoListBViewCell {
                                b.pauseAudio()
                            } else if let b1 = prevVc as? HCommentListViewCell {

                            }

                            currentPlayingVidIndex = -1
                        }
                    } else {
                        let idxPath = IndexPath(item: intersectedIdx, section: 0)
                        let currentVc = a.cellForItem(at: idxPath)
//                        guard let b = currentVc as? HPhotoListAViewCell else {
//                            return
//                        }
                        if let b = currentVc as? HPhotoListBViewCell {
                            b.resumeAudio()
                        } else if let b1 = currentVc as? HCommentListViewCell {

                        }

                        currentPlayingVidIndex = intersectedIdx
                        
                        print("reactintersect photo play BB")
                    }
                    
                    break
                }
            }
        }
    }
}

extension PhotoDetailPanelView: ShareSheetScrollableDelegate{
    func didShareSheetClick(){
        //test > for deleting item
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist e \(a.selectedItemIdx)")
                    let idx = a.selectedItemIdx
                    a.removeData(idxToRemove: idx)
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist f")
                }
            } else {
                removeData(idxToRemove: selectedItemIdx)
            }
        } else {

        }
    }
    func didShareSheetClickClosePanel(){
        
    }
    func didShareSheetFinishClosePanel(){
        //test > remove scrollable view from pagelist
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist c")
                    a.unselectItemData()
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist d")
                }
            } else {
//                resumeCurrentVideo()
                
//                if(!self.feedList.isEmpty) {
//                    let feed = feedList[currentIndex]
//                    feed.unselectItemData()
//                }
                unselectItemData()
            }
        } else {
//            resumeCurrentVideo()
        }
    }
}

extension PhotoDetailPanelView: CommentScrollableDelegate{
    func didCClickUser(){
//        delegate?.didClickUser()
        delegate?.didClickPhotoDetailPanelVcvClickUser()
    }
    func didCClickPlace(){
//        delegate?.didClickPlace()
//        delegate?.didClickPhotoPanelVcvClickPlace()
    }
    func didCClickSound(){
//        delegate?.didClickSound()
//        delegate?.didClickPhotoPanelVcvClickSound()
    }
    func didCClickClosePanel(){
//        bottomBox.isHidden = true
    }
    func didCFinishClosePanel() {
//        resumeCurrentAudio()
        
        //test > remove comment scrollable view from pagelist
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist a")
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist b")
                }
            } else {
//                resumeCurrentVideo()
            }
        } else {
//            resumeCurrentVideo()
        }
    }
    func didCClickComment(){

    }
    func didCClickShare(){
        //test
        openShareSheet()
    }
    func didCClickPost(){
        delegate?.didClickPhotoDetailPanelVcvClickPost()
    }
    func didCClickClickPhoto(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didClickPhotoDetailPanelVcvClickPhoto(pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClickVideo(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
    }
}

extension ViewController: PhotoDetailPanelDelegate{
    func didClickPhotoDetailPanelVcvClickPost() {
        openPostDetailPanel()
    }
    func didClickPhotoDetailPanelVcvClickUser() {
        //test
        openUserPanel()
    }
    func didClickPhotoDetailClosePanel() {
        backPage(isCurrentPageScrollable: false)
    }
    func didClickPhotoDetailPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2

        if(mode == PhotoTypes.P_SHOT_DETAIL) {
            openPhotoDetailPanel()
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
}
