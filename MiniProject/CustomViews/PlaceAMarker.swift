//
//  PlaceAMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

//protocol PlaceADelegate : AnyObject {
protocol PlaceADelegate : MarkerDelegate {
//    func didClickPlaceA(marker: PlaceAMarker, coord: CLLocationCoordinate2D)
}
class PlaceAMarker: PlaceMarker {
    var markerRing = UIView()
    var viewSize: CGFloat = 0
    var gifImage = SDAnimatedImageView()
//    var coordinateLocation : CLLocationCoordinate2D?
    var gifWidthLayoutConstraint: NSLayoutConstraint?
    var gifHeightLayoutConstraint: NSLayoutConstraint?
    
    var triangle = TriangleView()
//    var triangle = RightTriangleView()
    var triWidthLayoutConstraint: NSLayoutConstraint?
    var triHeightLayoutConstraint: NSLayoutConstraint?
    
    var markerWidthLayoutConstraint: NSLayoutConstraint?
    var markerHeightLayoutConstraint: NSLayoutConstraint?
    
    let box = UIView()
    
//    weak var delegate : PlaceADelegate?
    
//    var isInitialized = false
//    var isOnScreen = false
    
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
        
//        self.backgroundColor = .blue
        
//        let ovalBase = OvalView()
//        self.addSubview(ovalBase)
//        ovalBase.translatesAutoresizingMaskIntoConstraints = false
//        ovalBase.heightAnchor.constraint(equalToConstant: 16).isActive = true //default: 7
//        ovalBase.widthAnchor.constraint(equalToConstant: 40).isActive = true //default: 14
//        ovalBase.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        ovalBase.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
//        ovalBase.layer.opacity = 1.0
        
        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        box.leadingAnchor.constraint(equalTo: markerRing.leadingAnchor).isActive = true
//        box.topAnchor.constraint(equalTo: markerRing.topAnchor).isActive = true
//        box.bottomAnchor.constraint(equalTo: triangle.bottomAnchor).isActive = true
//        box.trailingAnchor.constraint(equalTo: markerRing.trailingAnchor).isActive = true
        
//        self.addSubview(markerRing)
        box.addSubview(markerRing) //test
        markerRing.backgroundColor = .white
//        markerRing.backgroundColor = .yellow
//        markerRing.backgroundColor = .black
        markerRing.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        markerRing.layer.cornerRadius = (viewSize)/2
        markerRing.translatesAutoresizingMaskIntoConstraints = false
        markerRing.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        markerRing.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        markerHeightLayoutConstraint = markerRing.heightAnchor.constraint(equalToConstant: viewSize)
        markerHeightLayoutConstraint?.isActive = true
        markerWidthLayoutConstraint = markerRing.widthAnchor.constraint(equalToConstant: viewSize)
        markerWidthLayoutConstraint?.isActive = true
//        markerRing.isUserInteractionEnabled = true
//        markerRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onInfoWindowClicked)))
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        guard let imageUrl = imageUrl else {
            return
        }

        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
//        gifImage.layer.cornerRadius = 8
        gifImage.layer.cornerRadius = (viewSize - 8)/2
        gifImage.sd_setImage(with: imageUrl)
        gifImage.backgroundColor = .ddmDarkGreyColor //as background
        markerRing.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        gifImage.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
//        gifImage.heightAnchor.constraint(equalToConstant: viewSize - 8).isActive = true
//        gifImage.widthAnchor.constraint(equalToConstant: viewSize - 8).isActive = true
        gifHeightLayoutConstraint = gifImage.heightAnchor.constraint(equalToConstant: viewSize - 8)
        gifHeightLayoutConstraint?.isActive = true
        gifWidthLayoutConstraint = gifImage.widthAnchor.constraint(equalToConstant: viewSize - 8)
        gifWidthLayoutConstraint?.isActive = true
        gifImage.isUserInteractionEnabled = true
        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onInfoWindowClicked)))
        
        box.addSubview(triangle)//test
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.topAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: -2).isActive = true
        triangle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        triHeightLayoutConstraint = triangle.heightAnchor.constraint(equalToConstant: 7)
        triHeightLayoutConstraint?.isActive = true
        triWidthLayoutConstraint = triangle.widthAnchor.constraint(equalToConstant: 14)
        triWidthLayoutConstraint?.isActive = true
//        triangle.changeFillColor(color: .yellow)
        
        //test > human marker
//        let rect = UIView()
//        box.insertSubview(rect, belowSubview: markerRing)
//        rect.translatesAutoresizingMaskIntoConstraints = false
//        rect.leadingAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        rect.topAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
//        rect.trailingAnchor.constraint(equalTo: markerRing.trailingAnchor).isActive = true
//        rect.bottomAnchor.constraint(equalTo: markerRing.bottomAnchor).isActive = true
//        rect.backgroundColor = .white
        
//        box.addSubview(triangle)//test
//        box.insertSubview(triangle, belowSubview: markerRing)
//        triangle.translatesAutoresizingMaskIntoConstraints = false
//        triangle.bottomAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: 0).isActive = true
//        triangle.leadingAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        triHeightLayoutConstraint = triangle.heightAnchor.constraint(equalToConstant: 44)
//        triHeightLayoutConstraint?.isActive = true
//        triWidthLayoutConstraint = triangle.widthAnchor.constraint(equalToConstant: 32)
//        triWidthLayoutConstraint?.isActive = true
        
        //test 1 > tap marker itself to trigger click event
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
        
        //test > add yellow arrow for selectable marker
        //may make it animate up and down
//        var selectedArrow = TriangleView()
//        box.addSubview(selectedArrow)//test
//        selectedArrow.translatesAutoresizingMaskIntoConstraints = false
//        selectedArrow.bottomAnchor.constraint(equalTo: markerRing.topAnchor, constant: -5).isActive = true
//        selectedArrow.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
//        selectedArrow.heightAnchor.constraint(equalToConstant: 7).isActive = true //7
//        selectedArrow.widthAnchor.constraint(equalToConstant: 14).isActive = true //14
//        selectedArrow.changeFillColor(color:UIColor.yellow)
////        selectedArrow.changeFillColor(color:UIColor.green)
//        selectedArrow.layer.shadowColor = UIColor.ddmBlackOverlayColor.cgColor
//        selectedArrow.layer.shadowRadius = 3.0  //ori 3
//        selectedArrow.layer.shadowOpacity = 0.5 //ori 1
//        selectedArrow.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
        //test > yellow arrow as pin
//        let selectedArrow = UIImageView()
//        selectedArrow.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
//        selectedArrow.tintColor = .yellow
////        selectedArrow.backgroundColor = .red
//        box.addSubview(selectedArrow)
//        selectedArrow.translatesAutoresizingMaskIntoConstraints = false
//        selectedArrow.bottomAnchor.constraint(equalTo: markerRing.topAnchor, constant: 10).isActive = true
//        selectedArrow.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
//        selectedArrow.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
//        selectedArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        selectedArrow.layer.shadowColor = UIColor.ddmBlackOverlayColor.cgColor
//        selectedArrow.layer.shadowRadius = 3.0  //ori 3
//        selectedArrow.layer.shadowOpacity = 0.5 //ori 1
//        selectedArrow.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
    }
    override func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
//        changeSize(zoomLevel: changeSizeZoom)
        changeSize(zoomLevel: changeSizeZoom, duringInitialization: true)
        initialize(withAnimation: withAnimation)
    }
    func initialize(withAnimation: Bool) {
        //test 2 > fade in when initialized
        isInitialized = true
        
        if(withAnimation) {
            self.layer.opacity = 0.0
            self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], //default: 0.5, delay 0.8
                animations: {
                    self.layer.opacity = 1.0
                    self.box.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        }
    }
    @objc func onMarkerClicked(gesture: UITapGestureRecognizer) {
        print("onmarkerclicked: \(self.frame.size.height)")
        self.delegate?.didClickPlaceA(marker: self, coord: self.coordinateLocation!)
    }
    @objc func onInfoWindowClicked(gesture: UITapGestureRecognizer) {
        print("onInfoWindowClicked: ")
//        self.delegate?.didClickPlace(coord: self.coordinateLocation!)
    }
    override func addLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }
    
    override func changeLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }
    
    override func changeOnScreen(withAnimation: Bool) {
        print("placeA changeOnScreen")
        isOnScreen = true
        popIn(withAnimation: withAnimation)
    }
    
    override func changeOffScreen(withAnimation: Bool) {
        isOnScreen = false
        fadeOut(withAnimation: withAnimation)
    }
    
    override func changeInitializeOn(withAnimation: Bool) {
        print("placeA changeInitializeOn")
        isInitialized = true
        popIn(withAnimation: withAnimation)
    }
    
    override func changeInitializeOff(withAnimation: Bool) {
        isInitialized = false
        popOut(withAnimation: withAnimation)
    }
    
    //test > set isonscreen = true to prevent entree animation when map first moves
    func setOnscreen(os : Bool) {
        isOnScreen = os
    }
    
    //test > marker fade out of map
    func fadeOut(withAnimation: Bool) {
        if(withAnimation) {
            UIView.animate(withDuration: 1.0, delay: 0.2, options: [],
                animations: {
                    self.layer.opacity = 0.0
                },
                completion: { _ in
    //                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                })
        } else {
            self.layer.opacity = 0.0
        }
    }
    
    func popOut(withAnimation: Bool) {
        if(withAnimation) {
            UIView.animate(withDuration: 0.6, delay: 0.2, options: [], //default 0.6, delay 0.2
                animations: {
                    self.layer.opacity = 0.0
    //                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)//test
                },
                completion: { _ in
                })
        } else {
            self.layer.opacity = 0.0
        }
    }
    
    func popIn(withAnimation: Bool) {
        
        if(withAnimation) {
            let randomInt = Int.random(in: 1..<5) //default: 1...4
            let randomDelay: Double = Double(randomInt)/Double(10)
            print("popIn: \(randomDelay)")
            
            self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test

            UIView.animate(withDuration: 0.5, delay: randomDelay, options: [], //default 0.3
                animations: {
                    self.layer.opacity = 1.0
                    self.box.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        } else {
            self.layer.opacity = 1.0
            self.box.transform = CGAffineTransform.identity //test
        }
    }
    
    override func changeSize(zoomLevel: CGFloat) {
        changeSize(zoomLevel: zoomLevel, duringInitialization: false)
    }
    
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        
        //test > using zoom level
        var newSize = 44.0
        var newGifGap = 8.0
        if(zoomLevel >= 8) {
            newSize = 44 + ((100 - 44)/(20 - 8) * (zoomLevel - 8))
            newGifGap = 8 + ((14 - 8)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = 44
            newGifGap = 8
        }
        
        print("changesize : \(zoomLevel), \(newGifGap)")
        
//        self.frame.size.height = newSize
//        self.frame.size.width = newSize
        markerHeightLayoutConstraint?.constant = newSize
        markerWidthLayoutConstraint?.constant = newSize
        markerRing.layer.cornerRadius = newSize/2
        
        gifHeightLayoutConstraint?.constant = newSize - newGifGap
        gifWidthLayoutConstraint?.constant = newSize - newGifGap
        gifImage.layer.cornerRadius = (newSize - newGifGap)/2
        
        //test triangle size
        var newTriHeight = 7.0
        var newTriWidth = 14.0
        if(zoomLevel >= 8) {
            newTriHeight = 7 + ((14 - 7)/(20 - 8) * (zoomLevel - 8))
            newTriWidth = 14 + ((28 - 14)/(20 - 8) * (zoomLevel - 8))
        } else {
            newTriHeight = 7
            newTriWidth = 14
        }
        triHeightLayoutConstraint?.constant = newTriHeight
        triWidthLayoutConstraint?.constant = newTriWidth
        
        self.frame.size.height = newSize + newTriHeight - 2
        self.frame.size.width = newSize
    }
    
    override func disappear() {
        UIView.animate(withDuration: 0.2,
            animations: {
//                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //default: 0.0
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
//                self.triangle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.layer.opacity = 0.0
            },
            completion: { _ in

            })
    }
    
    override func reappear() {
        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], //delay: 0.5
            animations: {
//                self.transform = CGAffineTransform.identity
//                self.markerRing.transform = CGAffineTransform.identity //test
//                self.triangle.transform = CGAffineTransform.identity //test
                self.box.transform = CGAffineTransform.identity //test
                self.layer.opacity = 1.0
            },
            completion: { _ in

            })
    }
    
    //test > marker animation when map padding change
    func shutter() {
        UIView.animate(withDuration: 0.2,
            animations: {
//                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
//                self.triangle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.layer.opacity = 0.0
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.5, options: [], //test 0.3 delay
                    animations: {
//                        self.transform = CGAffineTransform.identity
//                        self.markerRing.transform = CGAffineTransform.identity //test
//                        self.triangle.transform = CGAffineTransform.identity //test
                        self.box.transform = CGAffineTransform.identity //test
                        self.layer.opacity = 1.0
                    },
                    completion: { _ in
                    })
            })
    }
    
    //test > remove markers from map
    override func close() {
        self.removeFromSuperview()
    }
}

extension ViewController: PlaceADelegate{
    func didClickPlaceA(marker: PlaceAMarker, coord: CLLocationCoordinate2D) {
        print("placeAdelegate didclick:")
        
        //test > add info window below place marker for useful information
        // => useful info, e.g. distance, live streaming status, short(emoji) desc of place
//        let infoWindow = UIView()
//        infoWindow.backgroundColor = .white
//        self.view.addSubview(infoWindow)
//        infoWindow.translatesAutoresizingMaskIntoConstraints = false
//        infoWindow.heightAnchor.constraint(equalToConstant: 16).isActive = true //default: 7
//        infoWindow.widthAnchor.constraint(equalToConstant: 40).isActive = true //default: 14
//        infoWindow.centerXAnchor.constraint(equalTo: self.placeMarkerList[0].centerXAnchor).isActive = true
//        infoWindow.topAnchor.constraint(equalTo: self.placeMarkerList[0].bottomAnchor, constant: 8).isActive = true
        
    }
}
