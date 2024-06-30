//
//  QueueableView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class QueueableView: UIView {

    var id = -1
    
    func setId(id: Int) {
        self.id = id
    }
    
    func getId()  -> Int {
        return id
    }
    
    //test > marker id
    var markerId = ""

    func setMarkerId(markerId : String){
        self.markerId = markerId
    }
    func getMarkerId() -> String{
        return markerId
    }
}
