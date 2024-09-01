//
//  CommentScrollableView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol CommentScrollableDelegate : AnyObject {
    func didCClickUser()
    func didCClickPlace()
    func didCClickSound()
    func didCClickClosePanel()
    func didCFinishClosePanel()
    func didCClickComment()
    func didCClickPost()
    func didCClickShare()
    func didCClickClickPhoto(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func didCClickClickVideo(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
}
class CommentScrollableView: PanelView, UIGestureRecognizerDelegate{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    weak var delegate : CommentScrollableDelegate?
    var scrollablePanelHeight : CGFloat = 600.0 //500
    
    var aView = UIView()
//    var vDataList = [String]()
//    var vDataList = [PostData]()
    var vDataList = [CommentData]()
    var vCV : UICollectionView?
    
    var isScrollViewAtTop = true
    
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    //test
    var hideCellIndex = -1
    
    //test
    let panelView = UIView()
    
    //test > record which cell video is playing
    var currentPlayingVidIndex = -1
    
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
//        aView.layer.opacity = 0.4 //default : 0
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseCommentClicked)))
//        aView.backgroundColor = .black //ddmBlackOverlayColor
        aView.backgroundColor = .clear
        
//        let panelView = UIView()
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelView.heightAnchor.constraint(equalToConstant: scrollablePanelHeight).isActive = true
        panelTopCons = panelView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -scrollablePanelHeight) //default: 0
        panelTopCons?.isActive = true
        
        //test > connection to other panels
//        let eGrid = UIView()
//        eGrid.backgroundColor = .red
//        panelView.addSubview(eGrid)
//        eGrid.translatesAutoresizingMaskIntoConstraints = false
//        eGrid.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        eGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        eGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        eGrid.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 20).isActive = true
//        eGrid.layer.cornerRadius = 10
//        eGrid.isUserInteractionEnabled = true
//        eGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAPhotoClicked)))
//
//        let fGrid = UIView()
//        fGrid.backgroundColor = .blue
//        panelView.addSubview(fGrid)
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
//        panelView.addSubview(gGrid)
//        gGrid.translatesAutoresizingMaskIntoConstraints = false
//        gGrid.leadingAnchor.constraint(equalTo: fGrid.trailingAnchor, constant: 20).isActive = true
//        gGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        gGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        gGrid.topAnchor.constraint(equalTo: fGrid.topAnchor, constant: 0).isActive = true
//        gGrid.layer.cornerRadius = 10
//        gGrid.isUserInteractionEnabled = true
//        gGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCPhotoClicked)))
        
        let commentTitleText = UILabel()
        commentTitleText.textAlignment = .center
        commentTitleText.textColor = .white
//        commentTitleText.font = .systemFont(ofSize: 14) //default 14
        commentTitleText.font = .boldSystemFont(ofSize: 13) //default 14
        commentTitleText.text = "2037 Comments"
        panelView.addSubview(commentTitleText)
        commentTitleText.translatesAutoresizingMaskIntoConstraints = false
//        commentTitleText.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        commentTitleText.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        commentTitleText.centerXAnchor.constraint(equalTo: panelView.centerXAnchor, constant: 0).isActive = true
        commentTitleText.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 20).isActive = true
        
        let commentTitleBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
//            aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        commentTitleBtn.tintColor = .white
        panelView.addSubview(commentTitleBtn)
        commentTitleBtn.translatesAutoresizingMaskIntoConstraints = false
        commentTitleBtn.leadingAnchor.constraint(equalTo: commentTitleText.trailingAnchor).isActive = true
        commentTitleBtn.centerYAnchor.constraint(equalTo: commentTitleText.centerYAnchor).isActive = true
        commentTitleBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        commentTitleBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test * > select order
//        let l1Tab = UIView()
////        aBox.backgroundColor = .ddmBlackOverlayColor
//        l1Tab.backgroundColor = .ddmDarkColor
//        panelView.addSubview(l1Tab)
//        l1Tab.clipsToBounds = true
//        l1Tab.translatesAutoresizingMaskIntoConstraints = false
//        l1Tab.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        l1Tab.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
//        l1Tab.topAnchor.constraint(equalTo: commentTitleText.bottomAnchor, constant: 10).isActive = true
////        l1Tab.centerYAnchor.constraint(equalTo: commentTitleText.centerYAnchor, constant: 0).isActive = true
//        l1Tab.layer.cornerRadius = 5
////        l1Tab.layer.opacity = 0.2 //0.3
//
//        let l1TabText = UILabel()
//        l1TabText.textAlignment = .left
//        l1TabText.textColor = .white
////        l1TabText.textColor = .ddmDarkColor
//        l1TabText.font = .boldSystemFont(ofSize: 12)
////        l1TabText.font = .systemFont(ofSize: 12)
//        l1Tab.addSubview(l1TabText)
//        l1TabText.clipsToBounds = true
//        l1TabText.translatesAutoresizingMaskIntoConstraints = false
//        l1TabText.centerYAnchor.constraint(equalTo: l1Tab.centerYAnchor).isActive = true
////        l1TabText.topAnchor.constraint(equalTo: l1Tab.topAnchor, constant: 5).isActive = true
////        l1TabText.bottomAnchor.constraint(equalTo: l1Tab.bottomAnchor, constant: -5).isActive = true
//        l1TabText.leadingAnchor.constraint(equalTo: l1Tab.leadingAnchor, constant: 7).isActive = true //10
////        l1TabText.trailingAnchor.constraint(equalTo: l1Tab.trailingAnchor, constant: -5).isActive = true
//        l1TabText.text = "Auto"
//        l1TabText.layer.opacity = 0.5
//
//        let l1TabArrowBtn = UIImageView()
////        l1TabArrowBtn.image = UIImage(named:"icon_arrow_down")?.withRenderingMode(.alwaysTemplate)
//        l1TabArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
//        l1TabArrowBtn.tintColor = .white
////        self.view.addSubview(arrowBtn)
//        l1Tab.addSubview(l1TabArrowBtn)
//        l1TabArrowBtn.translatesAutoresizingMaskIntoConstraints = false
//        l1TabArrowBtn.leadingAnchor.constraint(equalTo: l1TabText.trailingAnchor, constant: 0).isActive = true
//        l1TabArrowBtn.trailingAnchor.constraint(equalTo: l1Tab.trailingAnchor, constant: 0).isActive = true //-5
//        l1TabArrowBtn.centerYAnchor.constraint(equalTo: l1TabText.centerYAnchor).isActive = true
//        l1TabArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 26
//        l1TabArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        l1TabArrowBtn.layer.opacity = 0.5
        //*
        
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
        let vLayout = UICollectionViewFlowLayout()
        vLayout.scrollDirection = .vertical
        vLayout.minimumLineSpacing = 10 //0 //default: 8 => spacing between rows
        vLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        vCV = UICollectionView(frame: .zero, collectionViewLayout: vLayout)
        guard let vCV = vCV else {
            return
        }
        vCV.register(HCommentListViewCell.self, forCellWithReuseIdentifier: HCommentListViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
//        vCV.showsVerticalScrollIndicator = false
//        vCV.backgroundColor = .blue
        vCV.backgroundColor = .clear
        panelView.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
//        vCV.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 20).isActive = true
        vCV.topAnchor.constraint(equalTo: commentTitleText.bottomAnchor, constant: 20).isActive = true
//        vCV.topAnchor.constraint(equalTo: l1Tab.bottomAnchor, constant: 20).isActive = true
        vCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        
        //test > top spinner
        vCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: vCV.topAnchor, constant: CGFloat(-35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: vCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > add footer ***
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
        //test > vcv gesture simultaneous
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        panelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        vCV.addGestureRecognizer(panelPanGesture)
        
        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onCommentPanelPanGesture))
        panelView.addGestureRecognizer(aPanelPanGesture)
        
        //test > to make comment bg non-movable
        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onCommentBackgroundPanGesture))
        aView.addGestureRecognizer(bPanelPanGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            print("onPan began top constraint: ")
            
            self.currentPanelTopCons = self.panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)
            
            print("onPan changed: \(x), \(y)")
            
            //y > 0 means downwards
            if(y > 0) {
                if(isScrollViewAtTop) {
                    self.panelTopCons?.constant = self.currentPanelTopCons + y
                }
            }
            else {
                //test
                isScrollViewAtTop = false
            }

        } else if(gesture.state == .ended){
            print("onPan end:")
            if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = 0
                    self.layoutIfNeeded()
                    
                    self.delegate?.didCClickClosePanel()
                }, completion: { _ in
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didCFinishClosePanel()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = -self.scrollablePanelHeight
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            }
        }
    }
    
    @objc func onCloseCommentClicked(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = 0
            self.layoutIfNeeded()
            
            self.delegate?.didCClickClosePanel()
        }, completion: { _ in
            self.removeFromSuperview()
            
            //test > trigger finish close panel
            self.delegate?.didCFinishClosePanel()
        })
    }

    @objc func onCommentPanelPanGesture(gesture: UIPanGestureRecognizer) {
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
                    
                    self.delegate?.didCClickClosePanel()
                }, completion: { _ in
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didCFinishClosePanel()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = -self.scrollablePanelHeight
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            }
        }
    }
    
    //test > to make comment bg non-movable
    @objc func onCommentBackgroundPanGesture(gesture: UIPanGestureRecognizer) {
        
    }
    
    //test > customize background color and opacity
    func setBackgroundDark() {
        aView.layer.opacity = 0.4 //default : 0
        aView.backgroundColor = .black //ddmBlackOverlayColor
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
//            self.asyncFetchFeed(id: "post_feed")
            self.asyncFetchFeed(id: "comment_feed")
        }
        
        isInitialized = true
    }
    //helper function: top and bottom margin to accomodate spinners while fetching data
    func adjustContentInset(topInset: CGFloat, bottomInset: CGFloat) {
        self.vCV?.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    func adjustContentOffset(x: CGFloat, y: CGFloat, animated: Bool) {
        self.vCV?.setContentOffset(CGPoint(x: x, y: y), animated: true)
    }
    
    //*test > remove one comment
    var selectedItemIdx = -1
    func removeData(idxToRemove: Int) {
        if(!vDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < vDataList.count) {
                var indexPaths = [IndexPath]()
                let idx = IndexPath(item: idxToRemove, section: 0)
                indexPaths.append(idx)
                
                vDataList.remove(at: idxToRemove)
                self.vCV?.deleteItems(at: indexPaths)
                
                unselectItemData()
                
                //test
                if(vDataList.isEmpty) {
                    self.configureFooterUI(data: "na")
                    self.aaText.text = "No comments yet."
                }
            }
        }
    }

    func unselectItemData() {
        selectedItemIdx = -1
    }
    //*
    
    //**test > remove one chain comment
    func removeChainData() {
        if(!vDataList.isEmpty) {
            let commentA = vDataList[0]
            let chainData = commentA.xChainDataArray
            if(!commentA.xChainDataArray.isEmpty) {
                vDataList[0].xChainDataArray.remove(at: chainData.count - 1)
            }
            
            var indexPaths = [IndexPath]()
            let idx = IndexPath(item: 0, section: 0)
            indexPaths.append(idx)
            self.vCV?.reloadItems(at: indexPaths)
        }
    }
    //**
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        //test 
        self.vDataList.removeAll() //test > refresh dataset
        self.vCV?.reloadData()
        
        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(100))
        
        let id_ = "comment"
        let isPaginate = false
        DataFetchManager.shared.fetchCommentFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
//                    self.vDataList.removeAll() //test > refresh dataset
 
                    //test
                    self.aSpinner.stopAnimating()
                    
                    //test 2 > new append method
                    for i in l {
                        let commentData = CommentData()
                        commentData.setDataType(data: i)
                        commentData.setData(data: i)
                        commentData.setTextString(data: i)
                        self.vDataList.append(commentData)
                    }
                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
//                    let dataCount = self.vDataList.count
//                    var indexPaths = [IndexPath]()
//                    var j = 1
//                    for i in l {
//                        let commentData = CommentData()
//                        commentData.setDataType(data: i)
//                        commentData.setData(data: i)
//                        commentData.setTextString(data: i)
//                        self.vDataList.append(commentData)
//
//                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
//                        indexPaths.append(idx)
//                        j += 1
//
//                        print("ppv asyncfetch reload \(idx)")
//                    }
//                    self.vCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test > animate cv back to y = 0 by contentOffset then only adjust contentInset after animate
                    self.adjustContentOffset(x: 0, y: 0, animated: true)
                    
                    self.dataFetchState = "end"
                    
                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "na")
                        self.aaText.text = "No comments yet."
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    self?.aSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    func asyncPaginateFetchFeed(id: String) {
        bSpinner.startAnimating()
        
        pageNumber += 1
        
        let id_ = "comment"
        let isPaginate = true
        DataFetchManager.shared.fetchCommentFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l), \(l.isEmpty)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    if(l.isEmpty) {
                        self.dataPaginateStatus = "end"
                    }
                    
                    //test
                    self.bSpinner.stopAnimating()
                    
                    //test 1 > append all data fetched
//                    self.vDataList.append(contentsOf: l)
                    
                    //test 2 > new append method
//                    for i in l {
//                        let commentData = CommentData()
//                        commentData.setDataType(data: i)
//                        commentData.setData(data: i)
//                        commentData.setTextString(data: i)
//                        self.vDataList.append(commentData)
//                    }
//                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        let commentData = CommentData()
                        commentData.setDataType(data: i)
                        commentData.setData(data: i)
                        commentData.setTextString(data: i)
                        self.vDataList.append(commentData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.vCV?.insertItems(at: indexPaths)
                    //*

                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    self?.bSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        configureFooterUI(data: "")
        
        dataPaginateStatus = ""
        self.asyncFetchFeed(id: "comment_feed")
    }
    
    //test > footer error handling for refresh feed
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error refresh clicked")
        refreshFetchData()
    }
    
    //test > dehide cell
    func dehideCell() {
        guard let a = self.vCV else {
            return
        }

        let idxPath = IndexPath(item: hideCellIndex, section: 0)
        let currentVc = a.cellForItem(at: idxPath)
        guard let b = currentVc as? HCommentListViewCell else {
            return
        }
        b.dehideCell()
        
        hideCellIndex = -1
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
            errorText.text = "Something went wrong. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            aaText.text = footerAaText
            //removed, text to be customized at panelview level
        }
        
        footerState = data
    }
    
    //test > resume current video
    func resumeCurrentVideo() {
        guard let a = self.vCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            if let b = currentVc as? HCommentListViewCell {
                b.resumeVideo()
            }
        }
    }

    //test > pause current video for closing
    func pauseCurrentVideo() {
        guard let a = self.vCV else {
            return
        }
        if(currentPlayingVidIndex > -1) {
            let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            if let b = currentVc as? HCommentListViewCell {
                b.pauseVideo()
            }
        }
    }
    
    //test > check for intersected dummy view with video while user scroll
    func getIntersectedIdx() -> Int {
//        let aVc = feedList[currentIndex]
        var intersectedIdx = -1
//        print("comment scroll intersected start")
        if let v = vCV {
            print("sfvideo ppv start \(v.visibleCells)")
            for cell in v.visibleCells {
                guard let indexPath = v.indexPath(for: cell) else {
                    continue
                }
                guard let b = cell as? HCommentListViewCell else {
                    return -1
                }

//                print("comment scroll intersected in \(panelView.frame.origin.y)")
                let cellRect = v.convert(b.frame, to: self)
                let aTestRect = b.aTest.frame
                
                if(!b.vidConArray.isEmpty) {
                    let vidC = b.vidConArray[0]
                    let vidCFrame = vidC.frame
                    let convertedVidCOriginY = vidCFrame.origin.y + aTestRect.origin.y + cellRect.origin.y
                    let convertedVidCRect = CGRect(x: 0, y: convertedVidCOriginY, width: vidCFrame.size.width, height: vidCFrame.size.height)
                    
                    let cY = v.convert(vidCFrame, to: v)
                    print("comment scroll intersected in: \(convertedVidCOriginY), \(vidCFrame.origin.y), \(cY)")
                    
                    //size can be changed
                    let dummyTopMargin = 70.0
                    let panelRectY = panelView.frame.origin.y
                    let vCvRectY = v.frame.origin.y
                    let dummyOriginY = panelRectY + vCvRectY + dummyTopMargin
                    let dummyView = CGRect(x: 0, y: dummyOriginY, width: self.frame.width, height: 200)
//                    let dummyView = CGRect(x: 0, y: dummyOriginY, width: 20, height: 200)
//                    let dV = UIView(frame: dummyView)
//                    dV.backgroundColor = .blue
//                    self.addSubview(dV)
                    
//                    print("comment scroll intersected inner: \(dummyOriginY)")
                    
                    let isIntersect = dummyView.intersects(convertedVidCRect)
                    let intersectArea = dummyView.intersection(convertedVidCRect)

                    print("sfvideo x ppv 3.0 collectionView index: \(indexPath), \(isIntersect), \(intersectArea)")
                    
                    //test > play video if intersect
                    if(isIntersect) {
                        intersectedIdx = indexPath.item
                    }
                }
            }
        }
        print("comment scroll intersected: \(intersectedIdx)")
        return intersectedIdx
    }
    
    //test > react to intersected video
    func reactToIntersectedVideo(intersectedIdx: Int) {
        guard let a = vCV else {
            return
        }
        
        print("comment reactToIntersectedVideo: \(intersectedIdx), \(currentPlayingVidIndex)")
        if(intersectedIdx > -1) {
            if(currentPlayingVidIndex > -1) {
                if(currentPlayingVidIndex != intersectedIdx) {
                    let prevIdxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                    let idxPath = IndexPath(item: intersectedIdx, section: 0)
                    let prevVc = a.cellForItem(at: prevIdxPath)
                    let currentVc = a.cellForItem(at: idxPath)
                    
                    //test 2 > include HCommentListViewCell
                    if let b1 = prevVc as? HCommentListViewCell {
                        b1.pauseVideo()
                    }
                    
                    if let c1 = currentVc as? HCommentListViewCell {
                        //*test > to be disabled if autoplay turn off
                        c1.resumeVideo()
                        currentPlayingVidIndex = intersectedIdx
                    }
                    print("comment reactToIntersectedVideo A")
                }
            } else {
                let idxPath = IndexPath(item: intersectedIdx, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                
                if let b1 = currentVc as? HCommentListViewCell {
                    //*test > to be disabled if autoplay turn off
                    b1.resumeVideo()
                    currentPlayingVidIndex = intersectedIdx
                }
                
                print("comment reactToIntersectedVideo B")
            }
        } else {
            //if intersectedIdx == -1, all video should pause/stop
            if(currentPlayingVidIndex > -1) {
                let idxPath = IndexPath(item: currentPlayingVidIndex, section: 0)
                let currentVc = a.cellForItem(at: idxPath)
                
                //test 2 > include HCommentListViewCell
                if let b1 = currentVc as? HCommentListViewCell {
                    b1.pauseVideo()
                    currentPlayingVidIndex = -1
                }
                
                print("comment reactToIntersectedVideo C")
            }
        }
    }
}

extension CommentScrollableView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                  layout collectionViewLayout: UICollectionViewLayout,
//                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("commentpanel collection: \(section)")
//        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0) //default: 50
//    }
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        if(text == "") {
            return 0
        }
        else {
            let size = CGSize(width: textWidth, height: 1000)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return estimatedFrame.height
        }
    }

    //test > to comment out
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("commentpanel collection 2: \(indexPath)")
        print("commenttxt 1 \(indexPath)")
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
        let text = vDataList[indexPath.row].dataTextString
        let dataL = vDataList[indexPath.row].dataArray
        var contentHeight = 0.0
        
        let photoSize = 28.0
        let photoLhsMargin = 20.0
        let usernameLhsMargin = 5.0
        let indentSize = photoSize + photoLhsMargin + usernameLhsMargin
        
        for l in dataL {
            if(l == "t") {
                let tTopMargin = 20.0
                let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 53.0 - 30.0, fontSize: 13)
                let tHeight = tTopMargin + tContentHeight
                contentHeight += tHeight
            }
            else if(l == "p") {
                let cellWidth = collectionView.frame.width
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
//                let pContentHeight = 280.0
                let pContentHeight = cSize.height
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
//                let pContentHeight = 280.0
                let pContentHeight = cSize.height
//                let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
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
//                let vContentHeight = 350.0 //250
                let vContentHeight = cSize.height
                let vHeight = vTopMargin + vContentHeight
                contentHeight += vHeight
            }
            else if(l == "v_l") {
                let cellWidth = collectionView.frame.width
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
//                let vContentHeight = 350.0 //250
                let vContentHeight = cSize.height
                let vHeight = vTopMargin + vContentHeight
//                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
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
        }
        
        let dataCh = vDataList[indexPath.row].xChainDataArray
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
                else if(y == "p_s") {
                    let pTopMargin = 20.0
                    let pContentHeight = 280.0
                    let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += pHeight
                }
                else if(y == "v") {
                    let vTopMargin = 20.0
                    let vContentHeight = 350.0 //250
                    let vHeight = vTopMargin + vContentHeight
                    contentHeight += vHeight
                }
                else if(y == "v_l") {
                    let vTopMargin = 20.0
                    let vContentHeight = 350.0 //250
                    let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += vHeight
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
        
//        return CGSize(width: collectionView.frame.width, height: 80)
        return CGSize(width: collectionView.frame.width, height: totalHeight)
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("commentpanel footer reuse")
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
        print("commentpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 100)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vDataList.count - 1 {
            print("commentpanel willdisplay: \(indexPath.row)")

            if(dataPaginateStatus != "end") {
                if(pageNumber >= 3) {
                    asyncPaginateFetchFeed(id: "comment_feed_end")
                } else {
                    asyncPaginateFetchFeed(id: "comment_feed")
                }

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("commentpanel didEndDisplaying: \(indexPath.row)")
    }
}
//test > try scrollview listener
extension CommentScrollableView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //UI inside panel
        print("scrollview begin: \(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //test > react to intersected index
        reactToIntersectedVideo(intersectedIdx: getIntersectedIdx())
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
//        if(!decelerate) {
//            //test
//            if(scrollView.contentOffset.y == 0) {
//                isScrollViewAtTop = true
//            } else {
//                isScrollViewAtTop = false
//            }
//            print("scrollview end drag check: \(isScrollViewAtTop)")
//        }
        
        //test
        let scrollOffsetY = scrollView.contentOffset.y
        
        //test > refresh dataset
        if(isScrollViewAtTop) {
            if(scrollOffsetY < -80) {
                //test > clear data for regenerate feed => not great
//                vcDataList.removeAll()
//                postCV?.reloadData()
                //**
                
//                self.asyncFetchFeed(id: "post_feed")
                self.asyncFetchFeed(id: "comment_feed")
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        print("scrollview animation ended")
        
        //test > reset contentInset to origin of y = 0
//        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50))
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(100))
    }
}
extension CommentScrollableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCommentListViewCell.identifier, for: indexPath) as! HCommentListViewCell
        cell.aDelegate = self
        print("commenttxt 2 \(indexPath)")
        
        //test > configure cell
        cell.configure(data: vDataList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCommentListViewCell.identifier, for: indexPath) as! HCommentListViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")
        
     }
}

extension CommentScrollableView: HListCellDelegate {
    func hListDidClickVcvComment(vc: UICollectionViewCell){
        //temp solution: to be diverted to comment section of post detail
        delegate?.didCClickPost()
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvLove(){
        
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell){
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let selectedIndexPath = a.indexPath(for: cell)
                    delegate?.didCClickShare()
                    
                    if let c = selectedIndexPath {
                        selectedItemIdx = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickUser(){
        delegate?.didCClickUser()
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvClickPlace(){
        delegate?.didCClickPlace()
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvClickSound(){
        delegate?.didCClickSound()
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvClickPost(){
        delegate?.didCClickPost()
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvClickPhoto(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickClickPhoto(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvClickVideo(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickClickVideo(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
        
        //test > try pause video when go comment
        pauseCurrentVideo()
    }
    func hListDidClickVcvSortComment(){}
    func hListIsScrollCarousel(isScroll: Bool){}
    
    //test > carousel photo scroll page
    func hListCarouselIdx(vc: UICollectionViewCell, idx: Int){}
    
    func hListVideoStopTime(vc: UICollectionViewCell, ts: Double){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    vDataList[indexPath.row].t_s = ts
                    
                    break
                }
            }
        }
    }
    
    //test > click play sound
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){}
}

