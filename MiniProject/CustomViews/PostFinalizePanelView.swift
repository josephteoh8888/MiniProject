//
//  blank.swift
//  MiniProject
//
//  Created by Joseph Teoh on 05/04/2025.
//
import Foundation
import UIKit
import SDWebImage

class ObjectView: UIView {

    var id = -1
    
    func setId(id: Int) {
        self.id = id
    }
    
    func getId()  -> Int {
        return id
    }
}

