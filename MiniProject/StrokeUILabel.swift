//
//  StrokeUILabel.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation
import UIKit

class UIOutlinedLabel: UILabel {

    var outlineWidth: CGFloat = 2
    var outlineColor: UIColor = UIColor.black

    override func drawText(in rect: CGRect) {

        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.strokeWidth : -1 * outlineWidth,
        ] as [NSAttributedString.Key : Any]

        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
