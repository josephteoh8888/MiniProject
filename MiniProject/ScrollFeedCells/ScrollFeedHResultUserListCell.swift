//
//  ScrollFeedHResultUserListCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class ScrollFeedHResultUserListCell: ScrollFeedHResultListCell {
    
    //test > vcv pan vs collectionview scroll
//    weak var aDelegate : ScrollFeedCellDelegate?
//    var vDataList = [String]()
    
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
        gridLayout.minimumLineSpacing = 10 //try 20 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }

        vCV.register(HResultUserListViewCell.self, forCellWithReuseIdentifier: HResultUserListViewCell.identifier)
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
    
    override func setShowVerticalScroll(isShowVertical: Bool) {
        vCV?.showsVerticalScrollIndicator = isShowVertical
    }
}

extension ScrollFeedHResultUserListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        print("placepanel collection: \(section)")
        //margin between sections
        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
//        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 100.0, right: 0.0)
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
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
//        return CGSize(width: collectionView.frame.width, height: 150)
        
        let userPhotoHeight = 40.0
        let userPhotoTopMargin = 10.0 //10
        let frameBottomMargin = 10.0 //10
        let bioText = "I am just a normal girl"
        let bioContentHeight = estimateHeight(text: bioText, textWidth: collectionView.frame.width - 58.0 - 20.0, fontSize: 14)
        let bioContentTopMargin = 10.0
        
        let miscHeight = userPhotoHeight + userPhotoTopMargin + frameBottomMargin
        let contentHeight = bioContentHeight + bioContentTopMargin
        let totalHeight = contentHeight + miscHeight
        
        return CGSize(width: collectionView.frame.width, height: totalHeight)
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
}

//test > try scrollview listener
extension ScrollFeedHResultUserListCell: UICollectionViewDelegate {
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

extension ScrollFeedHResultUserListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HResultUserListViewCell.identifier, for: indexPath) as! HResultUserListViewCell
//        cell.aDelegate = self
        //test > configure cell
//        cell.configure(data: vDataList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     }

}

