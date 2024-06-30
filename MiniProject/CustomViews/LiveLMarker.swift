//
//  LiveLMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

class LiveLMarker: Marker {
    
    let box = UIView()
    var viewSize: CGFloat = 0
    
    let dot = UIView()
    let adot = UIView()
    var dotWidthLayoutConstraint: NSLayoutConstraint?
    var dotHeightLayoutConstraint: NSLayoutConstraint?
    var aDotWidthLayoutConstraint: NSLayoutConstraint?
    var aDotHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        viewSize = frame.width
        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }
    
    func setupViews() {

        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        box.addSubview(dot) //test
        dot.backgroundColor = .white
//        markerRing.backgroundColor = .black
        dot.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        dot.layer.cornerRadius = (16)/2
        dot.translatesAutoresizingMaskIntoConstraints = false
//        dot.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        dot.centerYAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: 0).isActive = true
        dot.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dot.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dotWidthLayoutConstraint = dot.widthAnchor.constraint(equalToConstant: 16)
        dotWidthLayoutConstraint?.isActive = true
        dotHeightLayoutConstraint = dot.heightAnchor.constraint(equalToConstant: 16)
        dotHeightLayoutConstraint?.isActive = true

//        let adot = UIView()
        box.addSubview(adot) //test
        adot.backgroundColor = .ddmAccentColor
//        adot.backgroundColor = .lightBlueColor
        adot.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        adot.layer.cornerRadius = (10)/2
        adot.translatesAutoresizingMaskIntoConstraints = false
        adot.centerXAnchor.constraint(equalTo: dot.centerXAnchor).isActive = true
        adot.centerYAnchor.constraint(equalTo: dot.centerYAnchor).isActive = true
//        adot.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        adot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        aDotWidthLayoutConstraint = adot.widthAnchor.constraint(equalToConstant: 10)
        aDotWidthLayoutConstraint?.isActive = true
        aDotHeightLayoutConstraint = adot.heightAnchor.constraint(equalToConstant: 10)
        aDotHeightLayoutConstraint?.isActive = true
    }
    
    override func addLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }

    override func changeLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }
    
    override func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
//        changeSize(zoomLevel: changeSizeZoom, duringInitialization: true)
        initialize(withAnimation: withAnimation)
    }
    func initialize(withAnimation: Bool) {
        //test 2 > fade in when initialized
        isInitialized = true

        isOnScreen = true //test
    }
    
    override func close() {
        self.removeFromSuperview()
    }
    
    override func disappear() {

        //test
        UIView.animate(withDuration: 0.2,
            animations: {
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.layer.opacity = 0.0
            },
            completion: { _ in

            })
    }

    override func reappear() {
        //test
        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], //default delay 0.5
            animations: {
                self.box.transform = CGAffineTransform.identity //test
                self.layer.opacity = 1.0
            },
            completion: { _ in

            })
    }
}
