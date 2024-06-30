//
//  GeoData.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import GoogleMaps

class GeoData {
    var geoCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var geoType = ""
    
    func setGeoCoord(coord: CLLocationCoordinate2D) {
        geoCoord = coord
    }
    
    func getGeoCoord() -> CLLocationCoordinate2D{
        return geoCoord
    }
    
    func setGeoType(type: String) {
        geoType = type
    }
    
    func getGeoType() -> String{
        return geoType
    }
}
