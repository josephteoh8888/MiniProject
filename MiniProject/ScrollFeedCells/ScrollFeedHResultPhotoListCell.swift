//
//  ScrollFeedHResultPhotoListCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class ScrollFeedHResultPhotoListCell: ScrollFeedHResultListCell {
    
    //test
    var hideCellIndex = -1
    
    let gLineSpacingHeight = 20.0
    let gLhsMargin = 20.0
    let gRhsMargin = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }
    
    func setupViews() {
        //move to redrawUI()
    }
    
    override func scrollToTop() {
        vCV?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    override func initialize() {
        if(!isInitialized) {
            redrawUI()
        }
        isInitialized = true
    }
    
    func redrawUI() {
        
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
        gridLayout.minimumLineSpacing = 20 //try 20 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }

        vCV.register(GridPhoto2xViewCell.self, forCellWithReuseIdentifier: GridPhoto2xViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
        vCV.showsVerticalScrollIndicator = false
//        vCV.backgroundColor = .blue
        vCV.backgroundColor = .clear
//        vCV.isPagingEnabled = true
        self.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
        vCV.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        vCV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        vCV.alwaysBounceVertical = true
//        vCV.isScrollEnabled = false
        
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        vCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0) //bottom 50
        
        //test > top spinner
        vCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: vCV.topAnchor, constant: CGFloat(35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: vCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    //test > make viewcell image reappear after video panel closes
    func dehideCell(){
        if(hideCellIndex > -1) {
            let vc = vCV?.cellForItem(at: IndexPath(item: hideCellIndex, section: 0))
            guard let b = vc as? GridPhoto2xViewCell else {
                return
            }
            b.dehideCell()
            hideCellIndex = -1
        }
    }
    
    func hideCellAt(itemIndex: Int) {
        print("upv scroll3xphoto hide \(itemIndex)")
        let vc = vCV?.cellForItem(at: IndexPath(item: itemIndex, section: 0))
        guard let b = vc as? GridPhoto2xViewCell else {
            return
        }
        b.hideCell()
        hideCellIndex = itemIndex
    }
    
    override func setShowVerticalScroll(isShowVertical: Bool) {
        vCV?.showsVerticalScrollIndicator = isShowVertical
    }
    
    //test > footer error handling for refresh feed
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error refresh clicked")
        aDelegate?.sfcDidClickVcvRefresh()
    }
    
    override func configureFooterUI(data: String) {
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

extension ScrollFeedHResultPhotoListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        print("placepanel collection: \(section)")
        //margin between sections
//        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
        return UIEdgeInsets(top: 15.0, left: 20.0, bottom: 0.0, right: 20.0)
    }
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        let size = CGSize(width: textWidth, height: 1000) //1000 height is dummy
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("placepanel collection 2: \(indexPath)")
//        let lay = collectionViewLayout as! UICollectionViewFlowLayout
//        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
//        
//        return CGSize(width: 175, height: 175)
        
        let widthPerItem = (collectionView.frame.width - gLhsMargin - gRhsMargin - gLineSpacingHeight) / 2
//        let heightPerItem = widthPerItem
        let descHeight = 60.0 //70
        let heightPerItem = widthPerItem + descHeight
        return CGSize(width: widthPerItem, height: heightPerItem) //test
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vDataList.count - 1 {
            print("feedhresultlistcell willdisplay: \(indexPath.row)")
            
            //test
            if(dataPaginateStatus != "end") {
                print("feedhresultlistcell paginate async")
                aDelegate?.sfcAsyncPaginateFeed(cell: self)
            }
        }
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
}

//test > try scrollview listener
extension ScrollFeedHResultPhotoListCell: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollview begin: \(scrollView.contentOffset.y)")
        
        //test > vcv pan vs collectionview scroll
//        isScrollActive = true
        aDelegate?.sfcWillBeginDragging(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("xx scrollview scroll: \(scrollView.contentOffset.y)")
        aDelegate?.sfcScrollViewDidScroll(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollview end: \(scrollView.contentOffset.y)")
        aDelegate?.sfcSrollViewDidEndDecelerating(offsetY: scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
        aDelegate?.sfcScrollViewDidEndDragging(offsetY: scrollView.contentOffset.y, decelerate: decelerate)
    }
}

extension ScrollFeedHResultPhotoListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPhoto2xViewCell.identifier, for: indexPath) as! GridPhoto2xViewCell
        cell.aDelegate = self
        //test > configure cell
        cell.configure(data: vDataList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPhoto2xViewCell.identifier, for: indexPath) as! GridPhoto2xViewCell
        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")

//        aDelegate?.sfcDidClickVcvClickPhoto(pointX: originInRootView.x, pointY: originInRootView.y, view: cell, mode: PhotoTypes.P_SHOT)
//        hideCellAt(itemIndex: indexPath.row)
     }

}

extension ScrollFeedHResultPhotoListCell: GridViewCellDelegate {
    func gridViewClick(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        print("gridviewclick")
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    if let indexPath = visibleIndexPath {
                        //ori
//                        aDelegate?.sfcDidClickVcvClickPhoto(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
//                        hideCellAt(itemIndex: indexPath.row)
                        
                        //test 2 > override mode of phototype
                        let o_mode = PhotoTypes.P_SHOT_DETAIL
                        aDelegate?.sfcDidClickVcvClickPhoto(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: o_mode)
                        hideCellAt(itemIndex: indexPath.row)
                        
                        //test > additional delegate
                        bDelegate?.didScrollFeedHResultResignKeyboard()
                    }
                    
                    break
                }
            }
        }
    }
    func gridViewClickUser(id: String){
        //test > additional delegate
        bDelegate?.didScrollFeedHResultResignKeyboard()
        
        aDelegate?.sfcDidClickVcvClickUser(id: id)
    }
}

