//
//  LocationPinMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

class LocationPinMarker: Marker {
    
    var viewSize: CGFloat = 0
    var ovalWidthLayoutConstraint: NSLayoutConstraint?
    var ovalHeightLayoutConstraint: NSLayoutConstraint?
    
    var ovalBase = OvalView()
    
    var pinBottomLayoutConstraint: NSLayoutConstraint?
    
    let box = UIView()
    
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
        
        let lSelectMarker = UIImageView()
        lSelectMarker.image = UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate)
        lSelectMarker.tintColor = .white
//        self.view.addSubview(lSelectMarker)
//        self.addSubview(lSelectMarker)
        box.addSubview(lSelectMarker)
        lSelectMarker.translatesAutoresizingMaskIntoConstraints = false
//        lSelectMarker.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        lSelectMarker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pinBottomLayoutConstraint = lSelectMarker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        pinBottomLayoutConstraint?.isActive = true
        lSelectMarker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lSelectMarker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lSelectMarker.heightAnchor.constraint(equalToConstant: 30).isActive = true //70
        lSelectMarker.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lSelectMarker.layer.shadowColor = UIColor.ddmBlackOverlayColor.cgColor
        lSelectMarker.layer.shadowRadius = 3.0  //ori 3
        lSelectMarker.layer.shadowOpacity = 0.5 //ori 1
        lSelectMarker.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
//        lSelectMarker.isHidden = true
        
//        let ovalBase = OvalView()
//        self.view.addSubview(ovalBase)
//        self.addSubview(ovalBase)
        box.addSubview(ovalBase)
        ovalBase.translatesAutoresizingMaskIntoConstraints = false
        ovalWidthLayoutConstraint = ovalBase.widthAnchor.constraint(equalToConstant: 26)
        ovalWidthLayoutConstraint?.isActive = true
        ovalHeightLayoutConstraint = ovalBase.heightAnchor.constraint(equalToConstant: 8)
        ovalHeightLayoutConstraint?.isActive = true
        ovalBase.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ovalBase.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        ovalBase.layer.opacity = 0.6 //default: 0.2

    }
    
    func hoverPin() {
        //test > with animation
        UIView.animate(withDuration: 0.2, animations: {
//            self.panelTopCons?.constant = -self.scrollablePanelHeight
            self.pinBottomLayoutConstraint?.constant = -15
            self.layoutIfNeeded()
        }, completion: { _ in
        })
        
        //test > without anim
//        pinBottomLayoutConstraint?.constant = -15
    }
    
    func dehoverPin() {
        //test > with animation
        UIView.animate(withDuration: 0.2, animations: {
//            self.panelTopCons?.constant = -self.scrollablePanelHeight
            self.pinBottomLayoutConstraint?.constant = 0
            self.layoutIfNeeded()
        }, completion: { _ in
        })
        
        //test > without anim
//        pinBottomLayoutConstraint?.constant = 0
    }
    
    override func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
        changeSize(zoomLevel: changeSizeZoom, duringInitialization: true) //test
        initialize(withAnimation: withAnimation)
    }
    func initialize(withAnimation: Bool) {
        //test 2 > fade in when initialized
        isInitialized = true

        isOnScreen = true //test
    }
    
    override func addLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }
    
    override func changeLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
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
    
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        //just set frame sizes
        let newSize = viewSize
        self.frame.size.height = newSize
        self.frame.size.width = newSize
        self.widthOriginOffset = newSize //test => adjust origin for map projection
    }
}
