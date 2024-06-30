//
//  MapZoomView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol MapZoomDelegate : AnyObject {
    func didStart(mzv: MapZoomView)
    func didMove(zoomDelta: CGFloat, directionY: CGFloat, mzv: MapZoomView)
    func didEnd(mzv: MapZoomView)
}

class MapZoomView: UIView {
    
    let solidView = UIView()
    weak var delegate : MapZoomDelegate?
    
    var e1X: CGFloat = 0, e1Y: CGFloat = 0, e2X: CGFloat = 0, e2Y: CGFloat = 0;
    var minZoomLevel: CGFloat = 2 //default: 3
    var maxZoomLevel: CGFloat = 20
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    var maxWidth: CGFloat = 0
    var minWidth: CGFloat = 0
    var aOrientation: Int = 0 // orientation 0 is LHS
    
    //test > determine direction of touch
    var prevLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    //test
    var mapZoomWidthAnchor : NSLayoutConstraint?
    
    //test > internal parameter for map zooming
    //for gradient slope formula
    var mapZoomLevel0: Float = 0
    var mapTarget0 = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var initialMapZoomLevel: Float = 0
    var isMapZoomDirectionUp = true
    var isMapZoomDirectionChanged = false
    
    var isCollided = false
    var collidedTarget = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func zoomLevelDifference() -> CGFloat {
        return maxZoomLevel - minZoomLevel
    }
    
    func setConfiguration(minWidth: CGFloat, maxWidth: CGFloat, orientation: Int) {
        // orientation 0 is LHS
        // orientation 1 is RHS
        
        self.maxWidth = maxWidth
        self.minWidth = minWidth
        aOrientation = orientation
        
        if(orientation == 0) {
            x = 0
            y = 0
        } else {
            x = maxWidth
            y = 0
        }
    }
    
    var isZoomWidthFull = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            mapZoomWidthAnchor?.constant = maxWidth //test
            isZoomWidthFull = false //test
            
            let coordinates = touch.location(in: self)
            print("MapZoomer: touches began - \(coordinates.x)")
            x = coordinates.x
            y = coordinates.y
            
            e1X = x
            e1Y = y
            
            //test > touch direction determine
            prevLocation = coordinates
        }
        
        isMapZoomDirectionChanged = false //reset direction changed
//        isMapZoomDirectionUp = true
        
        delegate?.didStart(mzv: self)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first{
            
            mapZoomWidthAnchor?.constant = maxWidth //test
            
            let coordinates = touch.location(in: self)
            
            let zoomerPlaneHeight = self.bounds.height
            let zoomerPlaneWidth = self.bounds.width

            x = coordinates.x
            y = coordinates.y
            
            //test > to solve zoomview jittering issue
            if(!isZoomWidthFull) {
                if(x > maxWidth/2) {
                    isZoomWidthFull = true
                } else {
                    //zero out x, do not draw() zoomview if zoom width is not full width
                    if(aOrientation == 0) {
                        x = 0
                    } else {
                        x = maxWidth
                    }
                }
            }
            
            e2X = x
            e2Y = y
            
            let dx = e2X - e1X
            let dy = e2Y - e1Y
            
            let zoomDelta = dy/zoomerPlaneHeight * zoomLevelDifference()
//            print("MapZoomer: touches moved - \(coordinates.x), \(zoomerPlaneWidth), \(zoomDelta)")
            print("MapZoomer: touches moved - \(coordinates.x), \(zoomerPlaneWidth)")
            
            let directionY = coordinates.y - prevLocation.y
//            if(directionY > 0) {
//                isMapZoomDirectionChanged = true
//            }

            delegate?.didMove(zoomDelta: zoomDelta, directionY: directionY, mzv: self)
            
            if(directionY < 0) {
                isMapZoomDirectionUp = true
            } else if(directionY > 0) {
                isMapZoomDirectionUp = false
                isMapZoomDirectionChanged = true
            } else {
                //no change in directionY
            }
            
            prevLocation = coordinates
            
            self.setNeedsDisplay()
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("MapZoomer: touches ended - ")
        
        mapZoomWidthAnchor?.constant = self.minWidth //test
        
        if(aOrientation == 0) {
            x = 0
        } else {
            x = maxWidth
        }

        y = 0
        
        self.setNeedsDisplay()
        
        delegate?.didEnd(mzv: self)
        super.touchesEnded(touches, with: event)
    }
    
    override func draw(_ rect: CGRect) {
        // Get a path to define and traverse
        let path = UIBezierPath()
        let width = self.frame.size.width
        let height = self.frame.size.height

        if(aOrientation == 0) {
            //LHS
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addQuadCurve(to: CGPoint(x: x/2, y: y/2), controlPoint: CGPoint(x: x/4, y: y/4)) // 30...15
            path.addQuadCurve(to: CGPoint(x: x/2, y: y+(height-y)/4), controlPoint: CGPoint(x: x, y: y)) // 30...60
            path.addQuadCurve(to: CGPoint(x: x/4, y: y+(height-y)/2), controlPoint: CGPoint(x: x/3, y: y+(height-y)/3)) // 15...20
            path.addQuadCurve(to: CGPoint(x: 0, y: bounds.size.height), controlPoint: CGPoint(x: x/4, y: y+(height-y)/2)) // 0...15
        } else {
            //RHS
            path.move(to: CGPoint(x: width, y: 0.0)) // 360
            path.addQuadCurve(to: CGPoint(x: width - (width - x)/2, y: y/2), controlPoint: CGPoint(x: width - (width - x)/4, y: y/4)) // should be 360 - 30 = 330...360 - 15 = 345 if x = 360
            path.addQuadCurve(to: CGPoint(x: width - (width - x)/2, y: y+(height-y)/4), controlPoint: CGPoint(x: width - (width - x), y: y)) // should be 360 - 30 = 330...360 - 60 = 300 if x = 360
            path.addQuadCurve(to: CGPoint(x: width - (width - x)/4, y: y+(height-y)/2), controlPoint: CGPoint(x: width - (width - x)/3, y: y+(height-y)/3)) // should be 360 - 15 = 345...360 - 20 = 340 if x = 360
            path.addQuadCurve(to: CGPoint(x: width, y: bounds.size.height), controlPoint: CGPoint(x: width - (width - x)/4, y: y+(height-y)/2)) // 360...240
        }
    
//        // close path join to origin
        path.close()
        UIColor(red: (20/255.0), green: (20/255.0), blue: (20/255.0), alpha: 0.25).setFill()
        path.fill()
    }
}

//test > new trials on map zoom by interpolation
extension ViewController: MapZoomDelegate{
    
    func didStart(mzv: MapZoomView) {
        print("mapzoomdelegate didstart:")
        
        guard let zoom = mapView?.camera.zoom else {
            return
        }
        guard let target = mapView?.camera.target else {
            return
        }
        isMapZooming = true

        //set up initial condition when touch starts
        mzv.initialMapZoomLevel = zoom
        mzv.mapTarget0 = target
        mzv.mapZoomLevel0 = zoom
        print("zoom start: \(zoom), \(target)")
        
        //test > fix a target if collided particle is found
        if(isCollided) {
            mzv.isCollided = true //decouple from vc's iscollided
            mzv.collidedTarget = collidedCoordinates
        } else {
            mzv.isCollided = false
        }
        
        //test > remove pulsewave without removing from array, but by pulsating
        stopPulseWave()
        dequeueObject()
    }
    
    func didMove(zoomDelta: CGFloat, directionY:CGFloat, mzv: MapZoomView) {
        guard let target = mapView?.camera.target else {
            return
        }
        var newZoom = mzv.initialMapZoomLevel + Float(zoomDelta)
        if (newZoom > 20) {
            newZoom = 20
        }
        if (newZoom < 2) { //default: 3
            newZoom = 2
        }
        
        //***IMPROVEMENT: to do list
        //1) > solution for variable thresholdZoom, not just at z = 4
//        let zoom0 :Float = 2.0
//        let dz: Float = Float((finalLat - 0.0)/(80.0 - 0.0))
//        var thresholdZoom: Float = dz*(4.0 - zoom0) + zoom0
        
        //2) > gradual move from x to lat 0 at z = 2.0(min zoom)
        //test > another slope for 0 < z < 2(imaginary zoom limit of 0)
//        var newZoomUp = mzv.initialMapZoomLevel + Float(zoomDelta)
//        if(newZoomUp <= 0.0) {
//            newZoomUp = 0.0
//        }
//        let dZoomUp = (newZoomUp - newZoom)/(0.0 - newZoom) //use imaginary zoom level of 0.0
//        newLat = mzv.mapTarget0.latitude + ( Double(dZoomUp) * (0.0 - mzv.mapTarget0.latitude) )
        //******
        
        //test 2 > map zoom with margin adjustment
        //method 3
        if(directionY < 0) {
            //zoom up
            if(!mzv.isMapZoomDirectionUp) {
                print("zoom -ve dir change \(directionY)")
                mzv.mapTarget0 = target
                mzv.mapZoomLevel0 = newZoom
            }
            
            var newLat = target.latitude
            var newLng = target.longitude
            if(newZoom >= 4.0) {
                //test > new gradient slope for 80 < lat < 85
                let dZoom = (newZoom - mzv.mapZoomLevel0)/(4.0 - mzv.mapZoomLevel0)
                if(target.latitude > 80) {
                    newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (80.0 - mzv.mapTarget0.latitude))
                } else if (target.latitude < -80) {
                    newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (-80.0 - mzv.mapTarget0.latitude))
                }
            } else {
                if(mzv.isMapZoomDirectionUp) {
                    if(mzv.mapZoomLevel0 >= 4 && newZoom < 4) {
                        mzv.mapTarget0 = target
                        mzv.mapZoomLevel0 = newZoom
                    }
                }
                
                let dZoom = (newZoom - mzv.mapZoomLevel0)/(2.0 - mzv.mapZoomLevel0)
                newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (0.0 - mzv.mapTarget0.latitude))
                print("zoom new lat: \(dZoom), \(newZoom), \(mzv.mapZoomLevel0), \(newLat), \(mzv.mapTarget0.latitude)")
                
                //test > stabilize map at origin lat 0 when zoom 2
                if(newZoom == 2.0) {
                    //method 1
                    newLat = 0.0
                }
            }
            let geo = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
            mapView?.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: newZoom))
            
        } else if(directionY > 0){
            //zoom down
            if(mzv.isMapZoomDirectionUp) {
                print("zoom +ve dir change \(directionY)")
                mzv.mapTarget0 = target
                mzv.mapZoomLevel0 = newZoom
            }
            
            let collideLat = mzv.collidedTarget.latitude //test > real collided particle
            let collideLng = mzv.collidedTarget.longitude //test > real collided particle
            var newLat = target.latitude
            var newLng = target.longitude
            
            if(newZoom >= 4.0) {
                if(mzv.isCollided) {
                
                    //threshold zoom cut off
                    if(!mzv.isMapZoomDirectionUp) {
                        if(mzv.mapZoomLevel0 < 4 && newZoom >= 4) {
                            mzv.mapTarget0 = target
                            mzv.mapZoomLevel0 = newZoom
                        }
                    }
                    
                    newLat = collideLat
                    newLng = collideLng
                    
                    let dZoom = (newZoom - mzv.mapZoomLevel0)/(20.0 - mzv.mapZoomLevel0)
                    if(collideLat > 80 || collideLat < -80) {
                        newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (collideLat - mzv.mapTarget0.latitude))
                    } else {
                        //collided lat within map boundaries
                    }
                } else {
                    //no collision, within boundary, use current map location(target) for zooming
                }
            } else {
                if(mzv.isCollided) {
                    let dZoom = (newZoom - mzv.mapZoomLevel0)/(4.0 - mzv.mapZoomLevel0)
                    newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (collideLat - mzv.mapTarget0.latitude))
                    newLng = mzv.mapTarget0.longitude + (Double(dZoom) * (collideLng - mzv.mapTarget0.longitude))
                    
                    //new method to avoid white margin if collidedLat > 80
                    if(collideLat > 80.0) {
                        newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (80.0 - mzv.mapTarget0.latitude))
                    } else if(collideLat < -80.0) {
                        newLat = mzv.mapTarget0.latitude + (Double(dZoom) * (-80.0 - mzv.mapTarget0.latitude))
                    }
                } else {
                    //no collision, within boundary, use current map location(target) for zooming
                }
            }
            let geo = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
            mapView?.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: newZoom))

        }
        
        //increase the frame refresh rate for markers to avoid jagging
        if(isMapZooming) {
            
            //test 1 > change opacity while map-zooming
            for entry in markerList {
                entry.changeSize(zoomLevel: CGFloat(newZoom))
            }
            
            mapRefreshObjectsProjectionPoints(withAnimation: true)
            mapCheckCollisionPoints(withAnimation: true)
        }
        
        //test > mapzoom heatmap
        let newZoomInt = Int(round(newZoom))
        if(newZoomInt != heatmapMapZoom) {
            refreshHeatmap(mapZoom: newZoomInt)
        }
    }
    
    func didEnd(mzv: MapZoomView) {
        print("mapzoomdelegate didend:")
        
        isMapZooming = false
        
        guard let zoom = mapView?.camera.zoom else {
            return
        }
        guard let target = mapView?.camera.target else {
            return
        }
        print("zoom end: \(zoom), \(target)")
        
        //test > smooth spring effect after map zoom
        if(mzv.isMapZoomDirectionUp) {
            if(zoom < 2.5) {
                mapAdjustMargin(lat: 0)
            } else {
                mapAnimate(withSpringEffect: true)
            }
        }
    }
}
