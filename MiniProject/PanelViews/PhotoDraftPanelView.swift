//
//  PhotoDraftPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PhotoDraftPanelDelegate : AnyObject {
    func didClickClosePhotoDraftPanel()
}

class PhotoDraftPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var panel = UIView()
    var vDataList = [String]()
    
    var vCV : UICollectionView?
    var isScrollViewAtTop = true
    var scrollViewInitialY : CGFloat = 0.0
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    
    let aStickyHeader = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
//    var panelLeadingCons: NSLayoutConstraint?
//    var currentPanelLeadingCons : CGFloat = 0.0
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    weak var delegate : PhotoDraftPanelDelegate?
    
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
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
//        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
//        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        //test
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        let gap = viewHeight - 0 //150
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -gap)
        panelTopCons?.isActive = true
        panel.heightAnchor.constraint(equalToConstant: gap).isActive = true
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.topAnchor.constraint(equalTo: panel.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        panel.addSubview(bMiniBtn)
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
        panelTitleText.text = "Shot Drafts"
        panel.addSubview(panelTitleText)
        panelTitleText.translatesAutoresizingMaskIntoConstraints = false
//        panelTitleText.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        panelTitleText.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        panelTitleText.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
        panelTitleText.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
        panelTitleText.isUserInteractionEnabled = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10 //20
//        let videoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let vCV = vCV else {
            return
        }
        vCV.register(HListViewCell.self, forCellWithReuseIdentifier: HListViewCell.identifier)
//        vCV.isPagingEnabled = true
        vCV.dataSource = self
        vCV.delegate = self
        vCV.showsVerticalScrollIndicator = false
//        vCV.backgroundColor = .blue
        vCV.backgroundColor = .clear
        panel.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
//        vCV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
//        vCV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        vCV.topAnchor.constraint(equalTo: panelTitleText.bottomAnchor, constant: 20).isActive = true //test
        vCV.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        let vcvPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        vcvPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        vCV.addGestureRecognizer(vcvPanGesture)
        
        //test > add footer ***
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        panel.addGestureRecognizer(panelPanGesture)
    }
    
    @objc func onBackPanelClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
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
                    self.delegate?.didClickClosePhotoDraftPanel()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    let gap = self.viewHeight - 0 //150
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
    
//    var direction = "na"
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {
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
                    self.delegate?.didClickClosePhotoDraftPanel()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    let gap = self.viewHeight - 0 //150
                    self.panelTopCons?.constant = -gap
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
            
            //start fetch data
            self.asyncFetchFeed(id: "post_feed")
        }
        
        isInitialized = true
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didClickClosePhotoDraftPanel()
            })
        } else {
            self.removeFromSuperview()
            self.delegate?.didClickClosePhotoDraftPanel()
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
    func refreshFetchData() {
        //clear data
        dataFetchState = ""
        
        dataPaginateStatus = ""
        pageNumber = 0
        
        //fetch new data
        asyncFetchFeed(id: "post_feed")
    }
    
    func asyncFetchFeed(id: String) {

        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
//        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(50))
//        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(120)) //50 bottominset
        
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
                    
                    self.vDataList.append(contentsOf: l)
                    self.vCV?.reloadData()
                    
                    //test
                    self.aSpinner.stopAnimating()
                    
                    //test > animate cv back to y = 0 by contentOffset then only adjust contentInset after animate
//                    self.adjustContentOffset(x: 0, y: 0, animated: true)
                    
                    self.dataFetchState = "end"
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }

    var dataPaginateStatus = "" //test
    var pageNumber = 0
    func asyncPaginateFetchFeed(id: String) {
        bSpinner.startAnimating()
        
        pageNumber += 1
        dataPaginateStatus = "start"
        
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
//                        self.footerView.isHidden = false
//                        self.aaText.text = "- End -"
                        self.dataPaginateStatus = "end"
                    } else {
                        self.dataPaginateStatus = ""
                    }
                    
                    self.vDataList.append(contentsOf: l)
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
}

extension PhotoDraftPanelView: UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: collectionView.frame.width - 30, height: 150)
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
        print("postpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 50)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vDataList.count - 1 {
            print("postpanel willdisplay: \(indexPath.row)")
            //            pageNumber += 1
            //            fetchNextPage()
            
            //test > spinner at bottom
//            bSpinner.startAnimating()
            
            //test > paginate fetch
//            asyncPaginateFetchFeed(id: "post_feed")
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

extension PhotoDraftPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HListViewCell.identifier, for: indexPath) as! HListViewCell
//        cell.aDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HListViewCell.identifier, for: indexPath) as! HListViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")
        
//        delegate?.didClickVcvSoundItem(pointX: originInRootView.x, pointY: originInRootView.y, view: cell)

     }
}

extension PhotoDraftPanelView: UICollectionViewDelegate {
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
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
}

extension ViewController: PhotoDraftPanelDelegate{
    func didClickClosePhotoDraftPanel() {
        
//        backPage(isCurrentPageScrollable: false)
    }
}


