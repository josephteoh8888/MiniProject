//
//  ShareObjectScrollableView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 25/08/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol ShareObjectScrollableDelegate : AnyObject {
//    func didShareObjectClick()
    func didShareObjectClickCreate(type: String, objectType: String)
    func didShareObjectClickDelete()
    func didShareObjectClickClosePanel()
    func didShareObjectFinishClosePanel()
}
class ShareObjectScrollableView: PanelView, UIGestureRecognizerDelegate{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    var scrollablePanelHeight : CGFloat = 0.0 //300, 290
    var panelHeightCons: NSLayoutConstraint?
    
    weak var delegate : ShareObjectScrollableDelegate?
    
    var aView = UIView()
    
    var aVCV : UICollectionView?
    var aVDataList = [String]()
    
    var bVCV : UICollectionView?
    var bVDataList = [String]()
    
    var cVCV : UICollectionView?
    var cVDataList = [String]()
    
    var objectType = ""
    
    let mainPanel = UIView()
    let createPanel = UIView()
    var isCreateModeSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
//        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setupViews()
    }
    
    func setupViews() {
        self.addSubview(aView)
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        aView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aView.isUserInteractionEnabled = true
//        aView.layer.opacity = 0.1 //default : 0
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseShareObjectClicked)))
//        aView.backgroundColor = .ddmBlackOverlayColor
//        aView.layer.opacity = 0.3
        aView.backgroundColor = .black //test
        aView.layer.opacity = 0.4 //0.2
        
        let panelView = UIView()
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panelView.heightAnchor.constraint(equalToConstant: scrollablePanelHeight).isActive = true
        panelHeightCons = panelView.heightAnchor.constraint(equalToConstant: scrollablePanelHeight)
        panelHeightCons?.isActive = true
        panelTopCons = panelView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -scrollablePanelHeight)
        panelTopCons?.isActive = true
        
        let exitView = UIView()
        exitView.backgroundColor = .ddmDarkOverlayBlack
//        exitView.backgroundColor = .ddmDarkColor
        panelView.addSubview(exitView)
//        mainPanel.addSubview(exitView)
        exitView.translatesAutoresizingMaskIntoConstraints = false
//        exitView.bottomAnchor.constraint(equalTo: mainPanel.bottomAnchor, constant: -10).isActive = true
        exitView.bottomAnchor.constraint(equalTo: panelView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
//        exitView.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: -50).isActive = true
        exitView.heightAnchor.constraint(equalToConstant: 45).isActive = true //ori 60
        exitView.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
        exitView.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -20).isActive = true
//        exitView.layer.opacity = 0.2 //0.3
        exitView.layer.cornerRadius = 10
        exitView.isUserInteractionEnabled = true
        exitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitViewClicked)))
        
        let exitViewText = UILabel()
        exitViewText.textAlignment = .center
        exitViewText.textColor = .white
        exitViewText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(aSaveDraftText)
        exitView.addSubview(exitViewText)
        exitViewText.translatesAutoresizingMaskIntoConstraints = false
        exitViewText.centerXAnchor.constraint(equalTo: exitView.centerXAnchor).isActive = true
        exitViewText.centerYAnchor.constraint(equalTo: exitView.centerYAnchor).isActive = true
        exitViewText.text = "Cancel"
//        exitViewText.layer.opacity = 0.5
        
//        let mainPanel = UIView()
        panelView.addSubview(mainPanel)
        mainPanel.translatesAutoresizingMaskIntoConstraints = false
//        mainPanel.bottomAnchor.constraint(equalTo: panelView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        mainPanel.bottomAnchor.constraint(equalTo: exitView.topAnchor, constant: -10).isActive = true
        mainPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        mainPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
//        mainPanel.isHidden = true
        
        //test > horizontal vcv for sharing functions
//        aVDataList.append("sg") //send gift
//        aVDataList.append("f") //follow
//        aVDataList.append("rp")//report post
//        aVDataList.append("d") //dislike
//        aVDataList.append("de") //delete
//        aVDataList.append("sg") //send gift
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .horizontal
        gridLayout.minimumLineSpacing = 0 //default: 8 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        aVCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let aVCV = aVCV else {
            return
        }
        aVCV.register(VGridColumnViewCell.self, forCellWithReuseIdentifier: VGridColumnViewCell.identifier)
        aVCV.dataSource = self
        aVCV.delegate = self
        aVCV.showsHorizontalScrollIndicator = false
        aVCV.backgroundColor = .clear
//        panelView.addSubview(aVCV)
        mainPanel.addSubview(aVCV)
        aVCV.translatesAutoresizingMaskIntoConstraints = false
        aVCV.bottomAnchor.constraint(equalTo: mainPanel.bottomAnchor, constant: 0).isActive = true //aTabText, 20
//        aVCV.bottomAnchor.constraint(equalTo: exitView.topAnchor, constant: -10).isActive = true //aTabText, 20
        aVCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        aVCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        let height = 80.0
        aVCV.heightAnchor.constraint(equalToConstant: height).isActive = true
        aVCV.contentInsetAdjustmentBehavior = .never
        
        //test > horizontal vcv for sharing functions
//        bVDataList.append("sg")//send gift
//        bVDataList.append("sg") //send gift - **gift can be subscription rebate, money, app virtual gift, app pay per view etc
//        bVDataList.append("r")//repost
//        bVDataList.append("s")//share to
//        bVDataList.append("wa")//whatsapp
//        bVDataList.append("x")//x
//        bVDataList.append("c")//copy link
//        bVDataList.append("f") //follow
//        bVDataList.append("rp")//report post
        let bGridLayout = UICollectionViewFlowLayout()
        bGridLayout.scrollDirection = .horizontal
        bGridLayout.minimumLineSpacing = 0 //default: 8 => spacing between rows
        bGridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        bVCV = UICollectionView(frame: .zero, collectionViewLayout: bGridLayout)
        guard let bVCV = bVCV else {
            return
        }
        bVCV.register(VGridColumnViewCell.self, forCellWithReuseIdentifier: VGridColumnViewCell.identifier)
        bVCV.dataSource = self
        bVCV.delegate = self
        bVCV.showsHorizontalScrollIndicator = false
        bVCV.backgroundColor = .clear
//        panelView.addSubview(bVCV)
        mainPanel.addSubview(bVCV)
        bVCV.translatesAutoresizingMaskIntoConstraints = false
        bVCV.bottomAnchor.constraint(equalTo: aVCV.topAnchor, constant: -10).isActive = true //aTabText, 20
        bVCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        bVCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        let bHeight = 80.0
        bVCV.heightAnchor.constraint(equalToConstant: bHeight).isActive = true
        bVCV.contentInsetAdjustmentBehavior = .never
        bVCV.topAnchor.constraint(equalTo: mainPanel.topAnchor).isActive = true
        
        //test > create panel
        panelView.addSubview(createPanel)
        createPanel.translatesAutoresizingMaskIntoConstraints = false
        createPanel.bottomAnchor.constraint(equalTo: exitView.topAnchor, constant: -10).isActive = true
//        createPanel.topAnchor.constraint(equalTo: panelView.bottomAnchor, constant: -bottomInset).isActive = true
        createPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        createPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        createPanel.isHidden = true
        
        let cgridLayout = UICollectionViewFlowLayout()
        cgridLayout.scrollDirection = .horizontal
        cgridLayout.minimumLineSpacing = 0 //default: 8 => spacing between rows
        cgridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        cVCV = UICollectionView(frame: .zero, collectionViewLayout: cgridLayout)
        guard let cVCV = cVCV else {
            return
        }
        cVCV.register(VGridColumnViewCell.self, forCellWithReuseIdentifier: VGridColumnViewCell.identifier)
        cVCV.dataSource = self
        cVCV.delegate = self
        cVCV.showsHorizontalScrollIndicator = false
        cVCV.backgroundColor = .clear
//        panelView.addSubview(aVCV)
        createPanel.addSubview(cVCV)
        cVCV.translatesAutoresizingMaskIntoConstraints = false
        cVCV.bottomAnchor.constraint(equalTo: createPanel.bottomAnchor, constant: 0).isActive = true //aTabText, 20
//        cVCV.bottomAnchor.constraint(equalTo: exitView.topAnchor, constant: -10).isActive = true //aTabText, 20
        cVCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        cVCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        let cHeight = 80.0
        cVCV.heightAnchor.constraint(equalToConstant: cHeight).isActive = true
        cVCV.contentInsetAdjustmentBehavior = .never
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        createPanel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.bottomAnchor.constraint(equalTo: cVCV.topAnchor, constant: -10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackCreatePanelClicked)))
        aBtn.topAnchor.constraint(equalTo: createPanel.topAnchor, constant: 0).isActive = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        aBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let cText = UILabel()
        cText.textAlignment = .center
        cText.textColor = .white
        cText.font = .systemFont(ofSize: 13)
//        panel.addSubview(aSaveDraftText)
        createPanel.addSubview(cText)
        cText.translatesAutoresizingMaskIntoConstraints = false
//        cText.leadingAnchor.constraint(equalTo: aBtn.trailingAnchor).isActive = true
        cText.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        cText.centerXAnchor.constraint(equalTo: createPanel.centerXAnchor).isActive = true
        cText.text = "Create"
        cText.isHidden = true
        
        //test > vcv gesture simultaneous
//        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
//        panelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
//        vCV.addGestureRecognizer(panelPanGesture)
        
        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onShareObjectPanelPanGesture))
        panelView.addGestureRecognizer(aPanelPanGesture)
        
        //test > to make comment bg non-movable
        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onShareObjectBackgroundPanGesture))
        aView.addGestureRecognizer(bPanelPanGesture)
    }
    
    var isInitialized = false
    func initialize() {

        if(!isInitialized) {
            computeHeight()
            setupViews()
        }

        isInitialized = true
    }
    
    func setObjectType(t: String) {
        self.objectType = t
        if(t == "u") {
            aVDataList.append("rp")//report post
            aVDataList.append("d") //dislike
            
//            bVDataList.append("f")//follow
//            bVDataList.append("r")//repost
            bVDataList.append("sg")
            bVDataList.append("s")//share to
            bVDataList.append("c")//copy link
            
        } else if(t == "p") {
            aVDataList.append("rp")//report post
            aVDataList.append("d") //dislike
            
            bVDataList.append("cr")//use place to create
//            bVDataList.append("r")//repost
            bVDataList.append("s")//share to
            bVDataList.append("c")//copy link
//            bVDataList.append("b") //save
            
            cVDataList.append("cr_p")//copy link
            cVDataList.append("cr_post")//copy link
            cVDataList.append("cr_photo")//copy link
            cVDataList.append("cr_video")//copy link
        } else if(t == "s") {
            aVDataList.append("rp")//report post
            aVDataList.append("d") //dislike
            
            bVDataList.append("cr")//use place to create
//            bVDataList.append("r")//repost
            bVDataList.append("s")//share to
            bVDataList.append("c")//copy link
            
//            cVDataList.append("cr_post")//copy link
            cVDataList.append("cr_photo")//copy link
            cVDataList.append("cr_video")//copy link
        }
        
        aVCV?.reloadData()
        bVCV?.reloadData()
        cVCV?.reloadData()
    }
    
    //test
    let mainPanelTopMargin = 20.0
    let createPanelTopMargin = 10.0
    let iconHeight = 80.0
    let iconBottomMargin = 10.0
    let exitBtnHeight = 45.0
    let exitBtnBottomMargin = 10.0
    let backBtnHeight = 40.0
    let backBtnBottomMargin = 10.0
    func computeHeight() {
        if(isCreateModeSelected) {
            let totalHeight = createPanelTopMargin + iconHeight + iconBottomMargin +  backBtnHeight + backBtnBottomMargin + exitBtnHeight + exitBtnBottomMargin + safeAreaInsets.bottom
            scrollablePanelHeight = totalHeight
        } else {
            let numberOfRow = 2.0
            let totalHeight = mainPanelTopMargin + (iconHeight + iconBottomMargin) * numberOfRow + exitBtnHeight + exitBtnBottomMargin + safeAreaInsets.bottom
            print("totalH: \(totalHeight), \(safeAreaInsets.bottom)")
            
            scrollablePanelHeight = totalHeight
        }
    }
    func refreshModeUIChange() {
        if(isCreateModeSelected) {
            mainPanel.isHidden = true
            createPanel.isHidden = false
        } else {
            mainPanel.isHidden = false
            createPanel.isHidden = true
        }
        
        computeHeight()

        panelHeightCons?.constant = scrollablePanelHeight
        panelTopCons?.constant = -scrollablePanelHeight
    }
    @objc func onBackCreatePanelClicked(gesture: UITapGestureRecognizer) {
        if(isCreateModeSelected) {
            isCreateModeSelected = false
            refreshModeUIChange()
        }
    }
    
    @objc func onExitViewClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    @objc func onShareObjectPanelPanGesture(gesture: UIPanGestureRecognizer) {
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
                    
                    self.delegate?.didShareObjectClickClosePanel()
                }, completion: { _ in
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didShareObjectFinishClosePanel()
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
    
    //test > to make sharesheet bg non-movable
    @objc func onShareObjectBackgroundPanGesture(gesture: UIPanGestureRecognizer) {
        
    }
    
    @objc func onCloseShareObjectClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
                
                self.delegate?.didShareObjectClickClosePanel()
            }, completion: { _ in
                self.removeFromSuperview()

                //test > trigger finish close panel
                self.delegate?.didShareObjectFinishClosePanel()
            })
        } else {
            self.removeFromSuperview()
            
            //test > trigger finish close panel
            self.delegate?.didShareObjectFinishClosePanel()
        }
    }
}

extension ShareObjectScrollableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        print("userpanel collection: \(section)")
        return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("userpanel collection 2: \(indexPath)")
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
//        let widthPerItem = collectionView.frame.width / 3 - 40
//        return CGSize(width: widthPerItem - 8, height: 250)
//        return CGSize(width: widthPerItem, height: 160)
//        return CGSize(width: 175, height: 220)

        return CGSize(width: 70, height: collectionView.frame.height)
    }
}

extension ShareObjectScrollableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == aVCV {
            print("aVCV count")
            return aVDataList.count
        } else if collectionView == bVCV {
            print("bVCV count")
            return bVDataList.count
        } else if collectionView == cVCV {
            print("cVCV count")
            return cVDataList.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VGridColumnViewCell.identifier, for: indexPath) as! VGridColumnViewCell
//        cell.aDelegate = self
        
        //test > configure cell
        if collectionView == aVCV {
            cell.configure(data: aVDataList[indexPath.row])
        } 
        else if collectionView == bVCV {
            cell.configure(data: bVDataList[indexPath.row])
        }
        else if collectionView == cVCV {
            cell.configure(data: cVDataList[indexPath.row])
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == aVCV {
            print("vgrid a selected: \(aVDataList[indexPath.row])")
            
            //test 1 > close panel for more actions like delete item
//            self.removeFromSuperview()
//            delegate?.didShareObjectClickCreate(type: "p", objectType: objectType)
            
//            delegate?.didShareObjectClickCreate(type: "post", objectType: objectType)
//            delegate?.didShareObjectClickCreate(type: "video", objectType: objectType)
            delegate?.didShareObjectClickCreate(type: "photo", objectType: objectType)
            
        } else if collectionView == bVCV {
            print("vgrid b selected: \(bVDataList[indexPath.row])")
            let data = bVDataList[indexPath.row]
            if(data == "cr") {
                //test 2 > try create panel
                if(!isCreateModeSelected) {
                    isCreateModeSelected = true
                    refreshModeUIChange()
                }
            } else if(data == "r") {
                
            }

        } else if collectionView == cVCV {
            let data = cVDataList[indexPath.row]
            if(data == "cr_p") {
                self.removeFromSuperview()
                delegate?.didShareObjectClickCreate(type: "p", objectType: objectType)
            } else if(data == "cr_post") {
                self.removeFromSuperview()
                delegate?.didShareObjectClickCreate(type: "post", objectType: objectType)
            } else if(data == "cr_photo") {
                self.removeFromSuperview()
                delegate?.didShareObjectClickCreate(type: "photo", objectType: objectType)
            } else if(data == "cr_video") {
                self.removeFromSuperview()
                delegate?.didShareObjectClickCreate(type: "video", objectType: objectType)
            }
        }
     }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController: ShareObjectScrollableDelegate{

    func didShareObjectClickCreate(type: String, objectType: String){
        if(type == "p") {
            if(objectType == "p") {
                openPlaceCreatorPanel(objectType: "p", objectId: "", mode: "")
            }
            else if(objectType == "s") {
                openPlaceCreatorPanel(objectType: "s", objectId: "", mode: "")
            }
        }
        else if(type == "post") {
            if(objectType == "p") {
                openPostCreatorPanel(objectType: "p", objectId: "", mode: "")
            }
            else if(objectType == "s") {
                openPostCreatorPanel(objectType: "s", objectId: "", mode: "")
            }
        }
        else if(type == "video") {
            if(objectType == "p") {
                openVideoCreatorPanel(objectType: "p", objectId: "", mode: "")
            }
            else if(objectType == "s") {
                openVideoCreatorPanel(objectType: "s", objectId: "", mode: "")
            }
        }
        else if(type == "photo") {
            if(objectType == "p") {
                openPhotoCreatorPanel(objectType: "p", objectId: "", mode: "")
            }
            else if(objectType == "s") {
                openPhotoCreatorPanel(objectType: "s", objectId: "", mode: "")
            }
        }
    }
    func didShareObjectClickDelete(){
        
    }
    func didShareObjectClickClosePanel() {
        
    }
    func didShareObjectFinishClosePanel(){
        //test 1 > as not scrollable
//        backPage(isCurrentPageScrollable: false)
    }
}
