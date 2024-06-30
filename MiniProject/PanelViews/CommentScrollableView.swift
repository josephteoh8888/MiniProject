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
//        aView.layer.opacity = 0.2 //default : 0
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseCommentClicked)))
//        aView.backgroundColor = .black //ddmBlackOverlayColor
        aView.backgroundColor = .clear
        
        var panelView = UIView()
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
        
        //test* > arrow down to exit comment
//        let aBtn = UIView()
////        aBtn.backgroundColor = .ddmDarkColor //test to remove color
//        panelView.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 10).isActive = true
//    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 10).isActive = true
//        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
////        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseClicked)))
//
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
////        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .white
//        panelView.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true //26
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
        //*
        
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
    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didCClickPlace()
    }
    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didCClickUser()
    }
    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didCClickSound()
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
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        
        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(100))
        
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.vDataList.removeAll() //test > refresh dataset
                    
                    //test 1 > append all data fetched
//                    self.vDataList.append(contentsOf: l)
                    
                    //test 2 > new append method
                    for i in l {
//                        self.vDataList.append(self.getMessage(data: i))
                        
//                        let postData = PostData()
//                        postData.setDataType(data: i)
//                        postData.setData(data: i)
//                        postData.setTextString(data: i)
//                        self.vDataList.append(postData)
                        
                        let commentData = CommentData()
                        commentData.setDataType(data: i)
                        commentData.setData(data: i)
                        commentData.setTextString(data: i)
                        self.vDataList.append(commentData)
                    }
                    self.vCV?.reloadData()
                    
                    //test
                    self.aSpinner.stopAnimating()
                    
                    //test > animate cv back to y = 0 by contentOffset then only adjust contentInset after animate
                    self.adjustContentOffset(x: 0, y: 0, animated: true)
                    
                    self.dataFetchState = "end"
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func asyncPaginateFetchFeed(id: String) {
        bSpinner.startAnimating()
        
        pageNumber += 1
        
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
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
                    
                    //test 1 > append all data fetched
//                    self.vDataList.append(contentsOf: l)
                    
                    //test 2 > new append method
                    for i in l {
//                        self.vDataList.append(self.getMessage(data: i))
                        
//                        let postData = PostData()
//                        postData.setDataType(data: i)
//                        postData.setData(data: i)
//                        postData.setTextString(data: i)
//                        self.vDataList.append(postData)
                        
                        let commentData = CommentData()
                        commentData.setDataType(data: i)
                        commentData.setData(data: i)
                        commentData.setTextString(data: i)
                        self.vDataList.append(commentData)
                    }
                    self.vCV?.reloadData()
                    
                    //test
                    self.bSpinner.stopAnimating()
//                    self.bSpinner.isHidden = true

                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    //temp solution -> to be deleted
//    func getMessage(data: String) -> String {
//        var s = ""
//        if(data == "a") {
//            s = "Nice food, nice environment! Worth a visit. \n\nSo Good."
//        }
//        else if(data == "b") {
//            s = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
//        }
//        else {
//            s = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
//        }
//        return s
//    }
}

extension CommentScrollableView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                  layout collectionViewLayout: UICollectionViewLayout,
//                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("commentpanel collection: \(section)")
//        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0) //default: 50
//    }
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let size = CGSize(width: textWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height
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
                let cUserPhotoHeight = 28.0
                let cUserPhotoTopMargin = 20.0 //10
                let cContentTopMargin = 10.0
                let cText = "Worth a visit."
                let cContentHeight = estimateHeight(text: cText, textWidth: collectionView.frame.width - 58.0 - 20.0, fontSize: 14)
                let cActionBtnTopMargin = 10.0
                let cActionBtnHeight = 26.0
                let cHeight = cUserPhotoHeight + cUserPhotoTopMargin + cContentTopMargin + cContentHeight + cActionBtnTopMargin + cActionBtnHeight
                contentHeight += cHeight
            }
        }
        
        let userPhotoHeight = 28.0
        let userPhotoTopMargin = 10.0 //10
        let actionBtnTopMargin = 20.0
        let actionBtnHeight = 26.0
        let frameBottomMargin = 20.0 //10
//        let locationTopMargin = 20.0
//        let locationHeight = estimateHeight(text: "Petronas", textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) + 10
        let miscHeight = userPhotoHeight + userPhotoTopMargin + actionBtnTopMargin + actionBtnHeight + frameBottomMargin
        let totalHeight = contentHeight + miscHeight
        
//        let text = "Nice food, nice environment! Worth a visit"
//        let text = vDataList[indexPath.row]
        
//        let photoHeight = 28.0 //24
//        let photoTopMargin = 10.0
//        let textTopMargin = 10.0
//        let textHeight = estimateHeight(text: text, textWidth: viewWidth - 30.0 - 50.0)
//        let gifImageTopMargin = 10.0
//        let gifImageHeight = 150.0
//        let actionBtnTopMargin = 20.0
//        let actionBtnHeight = 26.0
//        let frameBottomMargin = 10.0
//        let totalHeight = photoTopMargin + photoHeight + textTopMargin + textHeight + actionBtnTopMargin + actionBtnHeight + frameBottomMargin
//        let totalHeight = photoTopMargin + photoHeight + textTopMargin + textHeight + gifImageTopMargin + gifImageHeight + actionBtnTopMargin + actionBtnHeight + frameBottomMargin
//        print("textheight: \(textHeight), \(totalHeight)")
        
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
            
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
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
            aaText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            aaText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            aaText.layer.opacity = 0.5
            if(dataPaginateStatus == "end") {
                aaText.text = "End"
            } else {
                aaText.text = ""
            }
            
            bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
            footer.addSubview(bSpinner)
            bSpinner.translatesAutoresizingMaskIntoConstraints = false
            bSpinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            bSpinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
            bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            bSpinner.isHidden = true
            
            return footer
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("commentpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 50)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vDataList.count - 1 {
            print("commentpanel willdisplay: \(indexPath.row)")

            if(dataPaginateStatus != "end") {
                if(pageNumber >= 3) {
//                    asyncPaginateFetchFeed(id: "post_feed_end")
                    asyncPaginateFetchFeed(id: "comment_feed_end")
                } else {
//                    asyncPaginateFetchFeed(id: "post_feed")
                    asyncPaginateFetchFeed(id: "comment_feed")
                }

            }
        }
    }
}
//test > try scrollview listener
extension CommentScrollableView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //UI inside panel
        print("scrollview begin: \(scrollView.contentOffset.y)")
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
//        cell.aDelegate = self
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

