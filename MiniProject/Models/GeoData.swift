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

//for simulating firestore fetch geopoints
class GeoDataset {
    var geoCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var geohashL3 = ""
    var docId = ""
    
    func setGeoCoord(coord: CLLocationCoordinate2D) {
        geoCoord = coord
    }
    
    func getGeoCoord() -> CLLocationCoordinate2D{
        return geoCoord
    }
    
    func setGeohashL3(L3: String) {
        geohashL3 = L3
    }
    
    func getGeohashL3() -> String{
        return geohashL3
    }
    
    func setDocId(id: String) {
        docId = id
    }
    
    func getDocId() -> String{
        return docId
    }
}
