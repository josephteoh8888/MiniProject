//
//  ScrollablePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import GoogleMaps

class ScrollablePanelView: PanelView {

    var markerIdList = [String]()
    var mapTargetCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var mapTargetZoom : Float = 0.0
    
    //test > scrollableId for marker adding on map
    var scrollableId = -1
    
    func correctMapPadding() {}
    func setStateTarget(target: CLLocationCoordinate2D) {
    }
    func setStateZoom(zoom: Float) {
    }
    func getStateTarget() -> CLLocationCoordinate2D {
        return mapTargetCoordinates
    }
    func getStateZoom() -> Float {
        return mapTargetZoom
    }
    
    func close(isAnimated: Bool) {
        
    }
    
    //test > scrollableId for marker adding on map
    func setScrollableId(id: Int) {
        scrollableId = id
    }
    func getScrollableId() -> Int {
        return scrollableId
    }
}
