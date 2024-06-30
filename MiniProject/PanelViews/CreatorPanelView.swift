//
//  CreatorPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import GoogleMaps

class CreatorPanelView: PanelView {
    var mapPinCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var mapPinString = "a"
    
    func setPinCoordinates(target: CLLocationCoordinate2D) {
    }
    func getPinCoordinates() -> CLLocationCoordinate2D {
        return mapPinCoordinates
    }
    
    func setPinString(i: String) {
        mapPinString = i
    }
    func getPinString() -> String {
        return mapPinString
    }
    
    func showLocationSelected() {
        
    }
}
