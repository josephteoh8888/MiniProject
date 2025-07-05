//
//  MeHistoryListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 20/07/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

//test > uicollectionview for videopanel VC-videocollectionview
protocol SCViewCellDelegate : AnyObject {
    func didSCClickUser(id: String)
    func didSCClickPlace(id: String)
    func didSCClickSound(id: String, vc: SCViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func didSCClickComment()
    func didSCClickShare(vc: SCViewCell, id: String, dataType: String)
    func didSCClickRefresh()
}

class SCViewCell: UICollectionViewCell {
    func playVideo() {}
    func stopVideo() {}
    func pauseVideo() {}
    func resumeVideo() {}
    
    //test > destroy cell
    func destroyCell() {}
    func hideCell() {}
    func dehideCell() {}
}
