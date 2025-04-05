//
//  Marker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol MarkerDelegate : AnyObject {
    func didClickExploreMarker(coord: CLLocationCoordinate2D, markerHeight: CGFloat, marker: ExploreMarker)
    func didStartClickExploreMarker(marker: ExploreMarker)
    func didClickUserMarker(marker: UserMarker, coord: CLLocationCoordinate2D)
    func didClickPlaceA(marker: PlaceAMarker, coord: CLLocationCoordinate2D)
    func didClickPlaceB(marker: PlaceBMarker, coord: CLLocationCoordinate2D)
    func didClickSoundMarker(marker: SoundMarker, coord: CLLocationCoordinate2D)
//    func didClickPostMarker(marker: PostMarker, coord: CLLocationCoordinate2D)
}
class Marker: QueueableView {
    var coordinateLocation : CLLocationCoordinate2D?

    func disappear() {}
    func reappear() {}
    func close() {}
    func changeSize(zoomLevel: CGFloat) {}

    var isInitialized = false
    var isOnScreen = false

    func changeOnScreen(withAnimation: Bool) {}
    func changeOffScreen(withAnimation: Bool) {}
    func changeInitializeOn(withAnimation: Bool){}
    func changeInitializeOff(withAnimation: Bool){}

    //test
    func initialize(withAnimation: Bool, changeSizeZoom: CGFloat){}
    func addLocation(coordinate : CLLocationCoordinate2D ) {}
    func changeLocation(coordinate : CLLocationCoordinate2D ) {}

    weak var delegate : MarkerDelegate?

    //test
    func animateFromVideoClose() {}
    func hideForShutter() {}
    func dehideForShutter() {}
    
    //test > variable size for post marker that has irregular shape
    var widthOriginOffset: CGFloat = 0.0
    func setScreenSizeLimit(width: CGFloat, height: CGFloat) {}
    
    func configure(data: String){}
}

class PlaceMarker: Marker {

}
class ExploreMarker: Marker {
    
}
