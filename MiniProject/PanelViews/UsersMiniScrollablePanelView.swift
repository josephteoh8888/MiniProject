//
//  UsersMiniScrollablePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol UsersMiniScrollablePanelDelegate : AnyObject {
    func didClickCloseUsersMiniScrollablePanel()

    //test > map padding
    func didChangeMapPaddingUsersMini(y: CGFloat)
    func didStartMapChangeUsersMini()
    func didFinishMapChangeUsersMini()
    
    //test > initialize
    func didFinishInitializeUsersMini(pv: UsersMiniScrollablePanelView)
    
    func didUsersMiniClickUser()
}

class UsersMiniScrollablePanelView: ScrollablePanelView, UIGestureRecognizerDelegate{
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var panelView = UIView()
    
    //test > new
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    let PANEL_MODE_HALF: String = "half"
    let PANEL_MODE_EMPTY: String = "empty"
    let PANEL_MODE_FULL: String = "full"
    var scrollablePanelHeight : CGFloat = 400.0 //default: 300 in iphone 6s, 400 in iphone 11
    var halfModeMapPadding : CGFloat = 200.0 //260, default: 210 in iphone 6s, 310 in iphone 11
    
    var currentPanelMode = ""
    
    weak var delegate : UsersMiniScrollablePanelDelegate?
    
    let aStickyHeader = UIView()
    var scrollViewInitialY : CGFloat = 0.0
    var isScrollViewAtTop = true
    
    var currentMapPaddingBottom: CGFloat = 0
    
    let pillBtn = UIView()
    var vDataList = [String]()
    
    var vcvTopCons: NSLayoutConstraint?
    var vcvBottomCons: NSLayoutConstraint?
    
    var vCV : UICollectionView?
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    let initialVcTopMargin : CGFloat = 30.0 //30.0
    
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
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        //test
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        pillBtn.backgroundColor = .ddmDarkColor
        panelView.addSubview(pillBtn)
        pillBtn.translatesAutoresizingMaskIntoConstraints = false
        pillBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        pillBtn.heightAnchor.constraint(equalToConstant: 6).isActive = true
        pillBtn.centerXAnchor.constraint(equalTo: panelView.centerXAnchor).isActive = true
        pillBtn.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 10).isActive = true
        pillBtn.layer.cornerRadius = 3
        
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
//        gridLayout.minimumLineSpacing = 0 //default: 8 => spacing between rows
        gridLayout.minimumLineSpacing = 10 //default: 20 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
//        let vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }
        vCV.register(HUsersListViewCell.self, forCellWithReuseIdentifier: HUsersListViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
        vCV.backgroundColor = .clear
        panelView.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
//        vCV.topAnchor.constraint(equalTo: pillBtn.bottomAnchor, constant: 90).isActive = true //20
        vcvTopCons = vCV.topAnchor.constraint(equalTo: pillBtn.bottomAnchor, constant: initialVcTopMargin) //default: 30
        vcvTopCons?.isActive = true
        vCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
//        vCV.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        let d = self.scrollablePanelHeight - self.frame.height
//        let d = -100.0
        print("usersmini d: \(d)")
        vcvBottomCons = vCV.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: d)
        vcvBottomCons?.isActive = true
        vCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        panelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        vCV.addGestureRecognizer(panelPanGesture)
        
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
        
        //test > sticky header
        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        panelView.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        aStickyHeader.isHidden = true

        let aBtn = UIView()
    //        aBtn.backgroundColor = .ddmBlackOverlayColor
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
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        aStickyHeader.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test > gesture recognizer for dragging place panel
        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        self.addGestureRecognizer(bPanelPanGesture)
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
            
            //test 2 > scroll down even at half mode
            currentPanelTopCons = panelTopCons!.constant
            
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)
            
            print("placesmini onPan changed: \(x), \(y), \(isScrollViewAtTop), \(currentPanelMode)")
            
            //test 2 > scroll down even at half mode
            if(y > 0) {
                
//                if(self.currentPanelMode == self.PANEL_MODE_FULL) {
                    if(isScrollViewAtTop) {
                        panelTopCons?.constant = currentPanelTopCons + y
                        
                        //test > change map height
                        if(panelTopCons!.constant < -scrollablePanelHeight) {
                            print("onPan place 1: ")
                            delegate?.didChangeMapPaddingUsersMini(y: halfModeMapPadding)
                        } else {
                            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                                if(currentMapPaddingBottom - y < 0) {
                                    print("onPan place 2: \(y), \(currentMapPaddingBottom)")
                                    delegate?.didChangeMapPaddingUsersMini(y: 0)
                                } else {
                                    print("onPan place 3: \(y), \(currentMapPaddingBottom)")
                                    delegate?.didChangeMapPaddingUsersMini(y: currentMapPaddingBottom - y)

                                    //test marker disappear trigger
                                    delegate?.didStartMapChangeUsersMini()
                                }
                            } else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
                                let gapY = panelTopCons!.constant + scrollablePanelHeight
                                if(currentMapPaddingBottom - gapY < 0) {
                                    print("onPan place 5: \(gapY), \(currentMapPaddingBottom)")
                                    delegate?.didChangeMapPaddingUsersMini(y: 0)
                                } else {
                                    print("onPan place 6: \(gapY), \(currentMapPaddingBottom)")
                                    delegate?.didChangeMapPaddingUsersMini(y: currentMapPaddingBottom - gapY)

                                    //test marker disappear trigger
                                    delegate?.didStartMapChangeUsersMini()
                                }
                            }
                        }
            //
                        change(scrollLevel: getScrollLevel())
                    }
//                }
                print("miniplace vc y > 0")
            } else {
                //test
                isScrollViewAtTop = false
                print("miniplace vc y < 0")
            }
        } else if(gesture.state == .ended){
            
            //test 2 > scroll down even at half mode
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.currentPanelTopCons - self.panelTopCons!.constant > 75) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.frame.height
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_FULL)
                        
                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()

                        //test > change isScrollViewAtTop when mode change
//                        self.isScrollViewAtTop = false
                    })
                    
                    //test
                    self.delegate?.didFinishMapChangeUsersMini()
                } else if (self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                    close(isAnimated: true)
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.scrollablePanelHeight
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_HALF)
                        
                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()
                        
                    }, completion: { finished in
                    })
                    
                    //test
                    self.delegate?.didFinishMapChangeUsersMini()
                }
                
            } else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
                if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.scrollablePanelHeight
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_HALF)

                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()
                        
                        //test > change isScrollViewAtTop when mode change
//                        self.isScrollViewAtTop = false
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: { //default 0.2
                        self.panelTopCons?.constant = -self.frame.height
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_FULL)

                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()
                    })
                }
                
                //test
                self.delegate?.didFinishMapChangeUsersMini()
            }
        }
    }
    
    func change(scrollLevel: CGFloat) {
        
//        var newVcvTopCons = 30.0
        var newVcvTopCons = initialVcTopMargin + (80 - initialVcTopMargin)*scrollLevel
        vcvTopCons?.constant = newVcvTopCons
        
        //test > vcv bottom cons
        let d = self.scrollablePanelHeight - self.frame.height
        var newVcvBottomCons = d
        newVcvBottomCons = d + (0 - d)*scrollLevel
        print("placesmini change: \(newVcvBottomCons)")
        vcvBottomCons?.constant = newVcvBottomCons
        
        if(scrollLevel >= 1) {
            pillBtn.layer.opacity = Float(0.0)
            aStickyHeader.isHidden = false
        } else {
            pillBtn.layer.opacity = Float(1.0)
            aStickyHeader.isHidden = true
        }
    }
    
    func getScrollLevel() -> CGFloat {
        var scrollLevel = (self.scrollablePanelHeight + self.panelTopCons!.constant)/(self.scrollablePanelHeight - self.frame.height)
        if(scrollLevel < 0) {
            scrollLevel = 0
        }
        return scrollLevel
    }
    
    override func setStateTarget(target: CLLocationCoordinate2D) {
        mapTargetCoordinates = target
    }
    override func setStateZoom(zoom: Float) {
        mapTargetZoom = zoom
    }
    override func getStateTarget() -> CLLocationCoordinate2D {
        return mapTargetCoordinates
    }
    override func getStateZoom() -> Float {
        return mapTargetZoom
    }
    override func correctMapPadding() {
        print("correctMapPadding:")
        delegate?.didChangeMapPaddingUsersMini(y: halfModeMapPadding)
    }
    
    var isInitialized = false
    func initialize() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = -self.scrollablePanelHeight
            
            self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_HALF) //test

        }, completion: { _ in
            print("usersmini panel init complete")
            
            //test > initialize and inform VC
            self.delegate?.didFinishInitializeUsersMini(pv: self)
        })
        
        //test > async fetch data
        if(!isInitialized) {
            self.asyncFetchFeed(id: "post_feed")
        }
        
        isInitialized = true
    }
    
    override func close(isAnimated: Bool) {
        print("close correctMapPadding: ")
        //test
        delegate?.didStartMapChangeUsersMini()
        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_EMPTY) //test
        
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0
                
                self.change(scrollLevel: self.getScrollLevel())
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.delegate?.didClickCloseUsersMiniScrollablePanel()
                self.removeFromSuperview()
            })
        } else {
            self.delegate?.didClickCloseUsersMiniScrollablePanel()
            self.removeFromSuperview()
        }
    }
    
    //scroll down to half mode
    @objc func onCloseClicked(gesture: UITapGestureRecognizer) {
        print("onCloseClick: ")
        
        UIView.animate(withDuration: 0.2, animations: {
            //test > programatically scroll to original half mode
            self.panelTopCons?.constant = -self.scrollablePanelHeight
            self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_HALF)

            let scrollLevel = 0.0
            self.change(scrollLevel: scrollLevel)
            
            self.superview?.layoutIfNeeded()
        }, completion: { finished in

        })
    }
    
    func changeUsersMiniPanelMode(panelMode : String) {
        print("change correctMapPadding: \(panelMode)")
        if(panelMode == PANEL_MODE_EMPTY) {
            currentMapPaddingBottom = 0
            delegate?.didChangeMapPaddingUsersMini(y: 0)
        } else {
            currentMapPaddingBottom = halfModeMapPadding
            delegate?.didChangeMapPaddingUsersMini(y: halfModeMapPadding)
        }
        currentPanelMode = panelMode
    }
    
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {

        if(gesture.state == .began) {
            print("onPan start: ")
            currentPanelTopCons = panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            let velocity = gesture.velocity(in: self)
            
            //test > put a limit to how high panel can be scrolled
            if(y < 0) {
                if(panelTopCons!.constant <= -self.frame.height) {
                    self.panelTopCons?.constant = -self.frame.height
                } else {
                    panelTopCons?.constant = currentPanelTopCons + y
                }
            } else {
                panelTopCons?.constant = currentPanelTopCons + y
            }
            
            //test > change map height
            if(panelTopCons!.constant < -scrollablePanelHeight) {
                print("onPan place 1: ")
                delegate?.didChangeMapPaddingUsersMini(y: halfModeMapPadding)
            } else {
                if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                    if(currentMapPaddingBottom - y < 0) {
                        print("onPan place 2: \(y), \(currentMapPaddingBottom)")
                        delegate?.didChangeMapPaddingUsersMini(y: 0)
                    } else {
                        print("onPan place 3: \(y), \(currentMapPaddingBottom)")
                        delegate?.didChangeMapPaddingUsersMini(y: currentMapPaddingBottom - y)

                        //test marker disappear trigger
                        delegate?.didStartMapChangeUsersMini()
                    }
                } else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
                    let gapY = panelTopCons!.constant + scrollablePanelHeight
                    if(currentMapPaddingBottom - gapY < 0) {
                        print("onPan place 5: \(gapY), \(currentMapPaddingBottom)")
                        delegate?.didChangeMapPaddingUsersMini(y: 0)
                    } else {
                        print("onPan place 6: \(gapY), \(currentMapPaddingBottom)")
                        delegate?.didChangeMapPaddingUsersMini(y: currentMapPaddingBottom - gapY)

                        //test marker disappear trigger
                        delegate?.didStartMapChangeUsersMini()
                    }
                }
            }
//
            change(scrollLevel: getScrollLevel())
            
        } else if(gesture.state == .ended){
            print("onPan end: ")
            
            //test > swipe up and go fullscreen
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.currentPanelTopCons - self.panelTopCons!.constant > 75) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.frame.height
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_FULL)
                        
                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()

                    })
                    
                    //test
                    self.delegate?.didFinishMapChangeUsersMini()
                } else if (self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                    close(isAnimated: true)
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.scrollablePanelHeight
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_HALF)
                        
                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()
                        
                    }, completion: { finished in
                    })
                    
                    //test
                    self.delegate?.didFinishMapChangeUsersMini()
                }
                
            } else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
                if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.scrollablePanelHeight
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_HALF)
                        
                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()
                        
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.panelTopCons?.constant = -self.frame.height
                        self.changeUsersMiniPanelMode(panelMode: self.PANEL_MODE_FULL)
                        
                        self.change(scrollLevel: self.getScrollLevel())
                        self.superview?.layoutIfNeeded()
                        
                    })
                }
                
                //test
                self.delegate?.didFinishMapChangeUsersMini()
            }
        }
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
        
        self.vDataList.removeAll() //test > refresh dataset
        self.vCV?.reloadData()
        
        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(50))
        
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.aSpinner.stopAnimating()
                    
                    //test 2 > reload entire dataset
                    for i in l {
                        self.vDataList.append(i)
                    }
                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
//                    let dataCount = self.vDataList.count
//                    var indexPaths = [IndexPath]()
//                    var j = 1
//                    for i in l {
//                        self.vDataList.append(i)
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
                        self.aaText.text = "No results."
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
                    
                    //test
                    self.bSpinner.stopAnimating()
                    
                    let dataCount = self.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        self.vDataList.append(i)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1

                        print("ppv asyncfetch reload \(idx)")
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
        self.asyncFetchFeed(id: "post_feed")
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
            errorText.text = "Something went wrong. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            aaText.text = footerAaText
            //removed, text to be customized at panelview level
        }
        
        footerState = data
    }
}

//test > try scrollview listener
extension UsersMiniScrollablePanelView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //UI inside panel
        print("scrollview begin: \(scrollView.contentOffset.y)")
        scrollViewInitialY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollViewInitialY - scrollView.contentOffset.y
        print("scrollview scroll: \(y), \(scrollViewInitialY)")

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

        print("p scrollview animation ended")
        
        //test > reset contentInset to origin of y = 0
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50))
    }
}

extension UsersMiniScrollablePanelView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                  layout collectionViewLayout: UICollectionViewLayout,
//                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("placepanel collection: \(section)")
////        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
//        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 100.0, right: 0.0)
//    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("placepanel collection 2: \(indexPath)")
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
//        let widthPerItem = collectionView.frame.width / 3 - 40
//        return CGSize(width: widthPerItem - 8, height: 250)
//        return CGSize(width: widthPerItem, height: 160)
        return CGSize(width: collectionView.frame.width, height: 150)
//        return CGSize(width: collectionView.frame.width - 40, height: 150)
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("postpanel footer reuse")
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
        if indexPath.row == vDataList.count - 1 {
            print("postpanel willdisplay: \(indexPath.row)")

            if(dataPaginateStatus != "end") {
                if(pageNumber >= 3) {
                    asyncPaginateFetchFeed(id: "post_feed_end")
                } else {
                    asyncPaginateFetchFeed(id: "post_feed")
                }

            }
        }
    }
}

extension UsersMiniScrollablePanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HUsersListViewCell.identifier, for: indexPath) as! HUsersListViewCell
        cell.aDelegate = self
        cell.configure(data: vDataList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HUsersListViewCell.identifier, for: indexPath) as! HUsersListViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")
        
//        delegate?.didClickVcvSoundItem(pointX: originInRootView.x, pointY: originInRootView.y, view: cell)

     }
}

extension ViewController: UsersMiniScrollablePanelDelegate{
    func didClickCloseUsersMiniScrollablePanel() {
        
        //test > reappear video when back from place panel
        backPage(isCurrentPageScrollable: true)
    }

    //test > map padding
    func didChangeMapPaddingUsersMini(y: CGFloat) {
        changeMapPadding(padding: y)
        
        //test > try move redView of collision check according to map padding
        //-ve as y direction is inverse
        redViewTopCons?.constant = -y
    }
    func didStartMapChangeUsersMini() {
        mapDisappearMarkers()
    }
    func didFinishMapChangeUsersMini() {
        mapReappearMarkers()
    }
    
    //test > initialize
    func didFinishInitializeUsersMini(pv: UsersMiniScrollablePanelView) {
        showUsersMiniPoints(pv: pv)
    }
    
    func didUsersMiniClickUser(){
        openUserPanel()
    }
}
