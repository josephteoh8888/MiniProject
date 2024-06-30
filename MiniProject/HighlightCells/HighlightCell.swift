//
//  HighlightCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

class HighlightCell: UIView {
//    weak var delegate : HighlightDelegate?
    weak var delegate : HighlightCellDelegate?
}

protocol HighlightCellDelegate : AnyObject {
    func hcWillBeginDragging(offsetY: CGFloat)
    func hcScrollViewDidScroll(offsetY: CGFloat)
    func hcSrollViewDidEndDecelerating(offsetY: CGFloat)
    func hcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool)
    
    func didHighlightClickUser(id: String)
    func didHighlightClickPlace(id: String)
    func didHighlightClickSound(id: String)
}
