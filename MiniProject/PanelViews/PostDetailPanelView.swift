//
//  PostDetailPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PostDetailPanelDelegate : AnyObject {
    func didClickPostDetailPanelVcvClickPost() //try
    func didClickPostDetailPanelVcvClickUser() //try
    func didClickPostDetailClosePanel()
    func didClickPostDetailPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
    func didClickPostDetailPanelVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
}
class PostDetailPanelView: PanelView {
    
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelLeadingCons : CGFloat = 0.0
    var panel = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aStickyHeader = UIView()
    var postCV : UICollectionView?
//    var vcDataList = [String]()
    var vcDataList = [PostData]()
    
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
    
    weak var delegate : PostDetailPanelDelegate?
    
    var postHeight = 0.0
    var stickyH1TopCons: NSLayoutConstraint?
    var stickyH2TopCons: NSLayoutConstraint?
    
    //test > for video autoplay when user opens
    var isFeedDisplayed = false
    //test > record which cell video is playing
    var currentPlayingVidIndex = -1
    //test
    var hideCellIndex = -1
    
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
        
        //test > try uicollectionview
//        let postData = PostData()
//        postData.setDataType(data: "b")
//        postData.setData(data: "b")
//        postData.setTextString(data: "b")
//        vcDataList.append(postData)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10 //20
//        let videoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        postCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let postCV = postCV else {
            return
        }
        postCV.register(HCommentListViewCell.self, forCellWithReuseIdentifier: HCommentListViewCell.identifier)
        postCV.register(HPostListBViewCell.self, forCellWithReuseIdentifier: HPostListBViewCell.identifier)
//        postCV.isPagingEnabled = true
        postCV.dataSource = self
        postCV.delegate = self
        postCV.showsVerticalScrollIndicator = false //false
//        postCV.backgroundColor = .blue
        postCV.backgroundColor = .clear
        panel.addSubview(postCV)
        postCV.translatesAutoresizingMaskIntoConstraints = false
        postCV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        postCV.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
//        postCV.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        postCV.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        postCV.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        postCV.contentInsetAdjustmentBehavior = .never
        //test
        postCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        //test > top spinner
        postCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.topAnchor.constraint(equalTo: postCV.topAnchor, constant: CGFloat(-35)).isActive = true
        aSpinner.topAnchor.constraint(equalTo: postCV.topAnchor, constant: CGFloat(35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: postCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > add footer ***
        postCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
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
        aTabText.text = "Post"
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
        aTabText2.text = "1309 Comments"
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
        postCV?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
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
                self.delegate?.didClickPostDetailClosePanel()
            })
        } else {
            self.removeFromSuperview()
            self.delegate?.didClickPostDetailClosePanel()
        }
    }
    
    //helper function: top and bottom margin to accomodate spinners while fetching data
    func adjustContentInset(topInset: CGFloat, bottomInset: CGFloat) {
        self.postCV?.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    func adjustContentOffset(x: CGFloat, y: CGFloat, animated: Bool) {
        self.postCV?.setContentOffset(CGPoint(x: x, y: y), animated: true)
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
                    self.postCV?.deleteItems(at: indexPaths)
                } else {
                    var indexPaths = [IndexPath]()
                    let idx = IndexPath(item: idxToRemove, section: 0)
                    indexPaths.append(idx)
                    
                    vcDataList.remove(at: idxToRemove)
                    self.postCV?.deleteItems(at: indexPaths)
                }
                
                unselectItemData()
                
                //test
                if(vcDataList.isEmpty) {
                    //entire post is deleted
                    self.setFooterAaText(text: "Post no longer exists.")
                    self.configureFooterUI(data: "na")
//                    self.aaText.text = "Post no longer exists."
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
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test 1
                    let postData = PostData()
                    postData.setDataType(data: "d") //"b"
                    postData.setData(data: "d")
                    postData.setTextString(data: "d")
                    self.vcDataList.append(postData)
                    self.postCV?.reloadData()
                    
                    //test 2 > new append method
//                    var indexPaths = [IndexPath]()
//                    
//                    let postData = PostData()
//                    postData.setDataType(data: "d") //"b"
//                    postData.setData(data: "d")
//                    postData.setTextString(data: "d")
//                    self.vcDataList.append(postData)
//                    
//                    let idx = IndexPath(item: 0, section: 0)
//                    indexPaths.append(idx)
//                    self.postCV?.insertItems(at: indexPaths)
                    
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
        print("pdpv asyncfetch")
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
                    print("pdpv api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test
                    self.bSpinner.stopAnimating()
                    
                    self.dataFetchState = "end"
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vcDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        self.vcDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.postCV?.insertItems(at: indexPaths)
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
                    print("pdpv fail fetch \(error)")
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
                    print("pdpv api success \(id), \(l), \(l.isEmpty)")
                    
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
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        self.vcDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.postCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("pdpv api fail")
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
            self.postCV?.deleteItems(at: indexPaths)
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
    func pauseCurrentVideo() {
        guard let a = self.postCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)

            if let b = currentVc as? HPostListBViewCell {
                b.pauseVideo()
            } else if let b1 = currentVc as? HCommentListViewCell {

            }
        }
    }
    //test > resume current video
    func resumeCurrentVideo() {
        guard let a = self.postCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            
            if let b = currentVc as? HPostListBViewCell {
                b.resumeVideo()
            } else if let b1 = currentVc as? HCommentListViewCell {
//                b.resumeVideo()
            } else {

            }
        }
    }
    func dehideCurrentCell() {
        guard let a = self.postCV else {
            return
        }

        let idxPath = IndexPath(item: hideCellIndex, section: 0)
        let currentVc = a.cellForItem(at: idxPath)

        if let b = currentVc as? HPostListBViewCell {
            b.dehideCell()
            hideCellIndex = -1
        } else if let b1 = currentVc as? HCommentListViewCell {
            b1.dehideCell()
            hideCellIndex = -1
        } else {

        }
    }

    //test
    override func resumeActiveState() {
        print("postdetailpanelview resume active")
        
        //test > only resume video if no comment scrollable view/any other view
        if(pageList.isEmpty) {
            resumeCurrentVideo()

            //test > dehide cell
            dehideCurrentCell()
        }
        else {
            //dehide cell for commment view
            if let c = pageList[pageList.count - 1] as? CommentScrollableView {
                c.resumeCurrentVideo()
                c.dehideCell()
            }
        }
    }
    
    //test > check for intersected dummy view with video while user scroll
    func getIntersectedIdx() -> Int {
        var intersectedIdx = -1
        if let v = postCV {
            print("sfvideo postdetail start \(v.visibleCells)")
            for cell in v.visibleCells {
                guard let indexPath = v.indexPath(for: cell) else {
                    continue
                }
//                guard let b = cell as? HPostListBViewCell else {
//                    return -1
//                }

                if let b = cell as? HPostListBViewCell {
                    let cellRect = v.convert(cell.frame, to: self)
                    let aTestRect = b.aTest.frame

                    if(!b.vidConArray.isEmpty) {
                        let vidC = b.vidConArray[0]
                        let vidCFrame = vidC.frame
                        let convertedVidCOriginY = cellRect.origin.y + aTestRect.origin.y + vidCFrame.origin.y
                        let convertedVidCRect = CGRect(x: 0, y: convertedVidCOriginY, width: vidCFrame.size.width, height: vidCFrame.size.height)
                        let dummyView = CGRect(x: 0, y: 200, width: self.frame.width, height: 300) //150
//                        let dV = UIView(frame: dummyView)
//                        dV.backgroundColor = .blue
//                        self.addSubview(dV)
                        
                        let isIntersect = dummyView.intersects(convertedVidCRect)
                        let intersectArea = dummyView.intersection(convertedVidCRect)

                        print("postdetail 3.0 collectionView index: \(indexPath), \(isIntersect), \(intersectArea)")
                        
                        //test > play video if intersect
                        if(isIntersect) {
                            intersectedIdx = indexPath.item
                        }
                    }
                }
                else if let c = cell as? HCommentListViewCell {
                    let cellRect = v.convert(cell.frame, to: self)
                    let aTestRect = c.aTest.frame

                    if(!c.vidConArray.isEmpty) {
                        let vidC = c.vidConArray[0]
                        let vidCFrame = vidC.frame
                        let convertedVidCOriginY = cellRect.origin.y + aTestRect.origin.y + vidCFrame.origin.y
                        let convertedVidCRect = CGRect(x: 0, y: convertedVidCOriginY, width: vidCFrame.size.width, height: vidCFrame.size.height)
                        let dummyView = CGRect(x: 0, y: 200, width: self.frame.width, height: 300) //150
//                        let dV = UIView(frame: dummyView)
//                        dV.backgroundColor = .blue
//                        self.addSubview(dV)
                        
                        let isIntersect = dummyView.intersects(convertedVidCRect)
                        let intersectArea = dummyView.intersection(convertedVidCRect)

                        print("postdetail 3.0 collectionView index: \(indexPath), \(isIntersect), \(intersectArea)")
                        
                        //test > play video if intersect
                        if(isIntersect) {
                            intersectedIdx = indexPath.item
                        }
                    }
                } else {
                    return -1
                }
            }
        }
        
        return intersectedIdx
    }
    
    //test > react to intersected video
    func reactToIntersectedVideo(intersectedIdx: Int) {
        guard let a = postCV else {
            return
        }
        
        print("postdetail reactToIntersectedVideo: \(intersectedIdx), \(currentPlayingVidIndex)")
        if(intersectedIdx > -1) {
            if(currentPlayingVidIndex > -1) {
                if(currentPlayingVidIndex != intersectedIdx) {
                    let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                    let idxPath = IndexPath(item: intersectedIdx, section: 0)
                    let prevVc = a.cellForItem(at: prevIdxPath)
                    let currentVc = a.cellForItem(at: idxPath)
                    
                    //test 2 > include HCommentListViewCell
                    if let b = prevVc as? HPostListBViewCell {
                        b.pauseVideo()
                        currentPlayingVidIndex = -1
                    } else if let b1 = prevVc as? HCommentListViewCell {
                        b1.pauseVideo()
                        currentPlayingVidIndex = -1
                    }
                    
                    if let c = currentVc as? HPostListBViewCell {
                        c.resumeVideo()
                        currentPlayingVidIndex = intersectedIdx
                    } else if let c1 = currentVc as? HCommentListViewCell {
//                        c1.resumeVideo()
//                        currentPlayingVidIndex = intersectedIdx
                    }
                    
                    print("postdetail reactToIntersectedVideo A")
                }
            } else {
                let idxPath = IndexPath(item: intersectedIdx, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                
                //test 2 > include HCommentListViewCell
                if let b = currentVc as? HPostListBViewCell {
                    print("postdetail reactToIntersectedVideo B1")
                    b.resumeVideo()
                    currentPlayingVidIndex = intersectedIdx
                } else if let b1 = currentVc as? HCommentListViewCell {
//                    b1.resumeVideo()
//                    currentPlayingVidIndex = intersectedIdx
                }
                
                print("postdetail reactToIntersectedVideo B")
            }
        } else {
            //if intersectedIdx == -1, all video should pause/stop
            if(currentPlayingVidIndex > -1) {
                let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                
                //test 2 > include HCommentListViewCell
                if let b = currentVc as? HPostListBViewCell {
                    b.pauseVideo()
                    currentPlayingVidIndex = -1
                } else if let b1 = currentVc as? HCommentListViewCell {
                    b1.pauseVideo()
                    currentPlayingVidIndex = -1
                }
                
                print("postdetail reactToIntersectedVideo C")
            }
        }
    }
    
    //test > add a timer before checking intersected video index
    func asyncAutoplay(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("asyncLayoutVc post detail api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }

                    self.reactToIntersectedVideo(intersectedIdx: self.getIntersectedIdx())
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
}

extension PostDetailPanelView: UICollectionViewDelegateFlowLayout {
    
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
            
            var contentHeight = 0.0
            for l in dataL {
                if(l == "t") {
                    let tTopMargin = 20.0
                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 30.0, fontSize: 14)
                    let tHeight = tTopMargin + tContentHeight
                    contentHeight += tHeight
                }
                else if(l == "p") {
                    let cellWidth = collectionView.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 4, height: 3)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth)
                    }
                    
                    let pTopMargin = 20.0
                    let pContentHeight = cSize.height //280
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "p_s") {
                    let cellWidth = self.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 4, height: 3)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                    }
                    
                    let pTopMargin = 20.0
                    let pContentHeight = cSize.height //280
                    let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += pHeight
                }
                else if(l == "v") {
                    let cellWidth = self.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth)
                    }
                    
                    let vTopMargin = 20.0
                    let vContentHeight = cSize.height //350
                    let vHeight = vTopMargin + vContentHeight
                    contentHeight += vHeight
                }
                else if(l == "v_l") {
                    let cellWidth = collectionView.frame.width
                    let lhsMargin = 20.0
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                    }
                    
                    let vTopMargin = 20.0
                    let vContentHeight = cSize.height //350
                    let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += vHeight
                }
                else if(l == "q") {
                    let qTopMargin = 20.0
                    let qUserPhotoHeight = 28.0
                    let qUserPhotoTopMargin = 10.0 //10
                    let qContentTopMargin = 10.0
                    let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
                    let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                    let qFrameBottomMargin = 20.0 //10
                    let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qContentTopMargin + qContentHeight + qFrameBottomMargin
                    contentHeight += qHeight
                } else if(l == "c") {
//                    let sortCommentBtnTopMargin = 30.0
//                    let sortCommentBtnHeight = 26.0
//                    let sHeight = sortCommentBtnTopMargin + sortCommentBtnHeight
//                    contentHeight += sHeight
                }
            }
            
            let userPhotoHeight = 40.0
            let userPhotoTopMargin = 20.0 //10
            let actionBtnTopMargin = 10.0
            let actionBtnHeight = 30.0
            let sortCommentBtnTopMargin = 30.0
            let sortCommentBtnHeight = 26.0
            let frameBottomMargin = 20.0 //10
            let locationTopMargin = 20.0
            let locationHeight = estimateHeight(text: "Petronas", textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) + 10
            let miscHeight = userPhotoHeight + userPhotoTopMargin + actionBtnTopMargin + actionBtnHeight + sortCommentBtnTopMargin + sortCommentBtnHeight + locationHeight + locationTopMargin + frameBottomMargin
//            let totalHeight = contentHeight + miscHeight
            let totalHeight = contentHeight + miscHeight
            
            postHeight = totalHeight
            
            return CGSize(width: collectionView.frame.width, height: totalHeight)
            
        } else {
            
            let text = vcDataList[indexPath.row].dataTextString
            let dataL = vcDataList[indexPath.row].dataArray
            var contentHeight = 0.0
            
            let photoSize = 28.0
            let photoLhsMargin = 20.0
            let usernameLhsMargin = 5.0
            let indentSize = photoSize + photoLhsMargin + usernameLhsMargin
            
            for l in dataL {
                if(l == "t") {
                    let tTopMargin = 20.0
                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - indentSize - 30.0, fontSize: 13)
                    let tHeight = tTopMargin + tContentHeight
                    contentHeight += tHeight
                }
                else if(l == "p") {
                    let cellWidth = self.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4) //4:3
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth)
                    }
                    
                    let pTopMargin = 20.0
                    let pContentHeight = cSize.height //280
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "p_s") {
                    let cellWidth = self.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 4, height: 3)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                    }
                    
                    let pTopMargin = 20.0
                    let pContentHeight = cSize.height //280
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "v") {
                    let cellWidth = self.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth)
                    }
                    
                    let vTopMargin = 20.0
                    let vContentHeight = cSize.height //350
                    let vHeight = vTopMargin + vContentHeight
                    contentHeight += vHeight
                }
                else if(l == "v_l") {
                    let cellWidth = self.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                    }
                    
                    let vTopMargin = 20.0
                    let vContentHeight = cSize.height //350
                    let vHeight = vTopMargin + vContentHeight
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
        
        print("pdpv footer reuse")
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
//            footerView.backgroundColor = .blue //blue
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
            
            //test > save footer state
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
            print("pdpv willdisplay: \(indexPath.row)")

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
                if let c = cell as? HPostListBViewCell {
                    asyncAutoplay(id: "search_term")
                }

                isFeedDisplayed = true
            }
        }
    }
}

extension PostDetailPanelView: UICollectionViewDelegate {
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
        reactToIntersectedVideo(intersectedIdx: getIntersectedIdx())
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

extension PostDetailPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //test
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPostListBViewCell.identifier, for: indexPath) as! HPostListBViewCell
            cell.aDelegate = self
            
            //test > configure cell
            cell.configure(data: vcDataList[indexPath.row])
            
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

extension PostDetailPanelView: HListCellDelegate {
    func hListDidClickVcvComment(vc: UICollectionViewCell) {
        print("PostDetailPanelView comment clicked")
//        postCV?.setContentOffset(CGPoint(x: 0.0, y: postHeight), animated: true)
        if let b = vc as? HPostListBViewCell {
            postCV?.setContentOffset(CGPoint(x: 0.0, y: postHeight), animated: true)
        } else if let b1 = vc as? HCommentListViewCell {
            openComment()
            
            pauseCurrentVideo()
        }
    }
    func hListDidClickVcvLove() {
        print("PostDetailPanelView love clicked")
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell) {
        print("PostDetailPanelView share clicked")
//        openShareSheet()
        
        pauseCurrentVideo()
        
        if let a = postCV {
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
        delegate?.didClickPostDetailPanelVcvClickUser()
        
        pauseCurrentVideo()
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
        delegate?.didClickPostDetailPanelVcvClickPost()
        
        //test
        pauseCurrentVideo()
    }
    func hListDidClickVcvClickPhoto(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        pauseCurrentVideo()
        
        if let a = postCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    delegate?.didClickPostDetailPanelVcvClickPhoto(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickVideo(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        pauseCurrentVideo()
        
        if let a = postCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    delegate?.didClickPostDetailPanelVcvClickVideo(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    
    func hListDidClickVcvSortComment(){
        
    }
    
    func hListIsScrollCarousel(isScroll: Bool) {
        
    }
    
    func hListCarouselIdx(vc: UICollectionViewCell, idx: Int) {
        
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, ts: Double){
        if let a = postCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    vcDataList[indexPath.row].t_s = ts
                    
                    break
                }
            }
        }
    }
    
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        
    }
}

extension PostDetailPanelView: ShareSheetScrollableDelegate{
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
                resumeCurrentVideo()
                
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

extension PostDetailPanelView: CommentScrollableDelegate{
    func didCClickUser(){
//        delegate?.didClickUser()
        delegate?.didClickPostDetailPanelVcvClickUser()
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
                resumeCurrentVideo()
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
        delegate?.didClickPostDetailPanelVcvClickPost()
    }
    func didCClickClickPhoto(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didClickPostDetailPanelVcvClickPhoto(pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClickVideo(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
    }
}

extension ViewController: PostDetailPanelDelegate{
    func didClickPostDetailPanelVcvClickPost() {
        openPostDetailPanel()
    }
    func didClickPostDetailPanelVcvClickUser() {
        //test
        openUserPanel()
    }
    func didClickPostDetailClosePanel() {
        backPage(isCurrentPageScrollable: false)
    }
    func didClickPostDetailPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2

        if(mode == PhotoTypes.P_SHOT_DETAIL) {
            openPhotoDetailPanel()
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
    func didClickPostDetailPanelVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2

        //test 1 > for video only
        var dataset = [String]()
//        dataset.append("a")
        dataset.append("a")
        self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: view, originatorViewType: OriginatorTypes.UIVIEW, id: 0, originatorViewId: "", preterminedDatasets: dataset, mode: mode)
    }
}
