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
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        guard let imageUrl = imageUrl else {
//            return
//        }

        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = (viewSize - 8)/2
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.backgroundColor = .ddmDarkGreyColor //as background
        gifImage.backgroundColor = .ddmDarkColor
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
    
    override func configure(data: String) {
//        if(data == "a") {
//            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//            guard let imageUrl = imageUrl else {
//                return
//            }
//            self.gifImage.sd_setImage(with: imageUrl)
//        }
        
        asyncConfigure(data: "")
    }
    
    //*test > async fetch images/names/videos
    func asyncConfigure(data: String) {
        let id = "u" //u_
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                    guard let imageUrl = imageUrl else {
                        return
                    }
                    self.gifImage.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    let imageUrl = URL(string: "")
                    guard let imageUrl = imageUrl else {
                        return
                    }
                    self.gifImage.sd_setImage(with: imageUrl)
                }
                break
            }
        }
    }
    //*
    
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
    
    //test > varying initial size instead of fixed size
//    var minMarkerWidth: CGFloat = 44 //44
    var minMarkerWidth: CGFloat = 0 //44
    var maxMarkerWidth: CGFloat = 100
    var minGifGap: CGFloat = 8.0
    var maxGifGap: CGFloat = 14.0
    var minTriWidth: CGFloat = 14
    var maxTriWidth: CGFloat = 28
    var minTriHeight: CGFloat = 7
    var maxTriHeight: CGFloat = 14
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        //test > initialize random size if not already
        if(minMarkerWidth == 0) {
//            minMarkerWidth = CGFloat(generateRandomSize())
            minMarkerWidth = 44.0
        }
        
        //test > using zoom level
        var newSize = minMarkerWidth
        var newGifGap = minGifGap
        var newTriHeight = minTriHeight
        var newTriWidth = minTriWidth
        if(zoomLevel >= 8) {
            newSize = minMarkerWidth + ((maxMarkerWidth - minMarkerWidth)/(20 - 8) * (zoomLevel - 8))
            newGifGap = minGifGap + ((maxGifGap - minGifGap)/(20 - 8) * (zoomLevel - 8))
            newTriHeight = minTriHeight + ((maxTriHeight - minTriHeight)/(20 - 8) * (zoomLevel - 8))
            newTriWidth = minTriWidth + ((maxTriWidth - minTriWidth)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = minMarkerWidth
            newGifGap = minGifGap
            newTriHeight = minTriHeight
            newTriWidth = minTriWidth
        }
        
        print("changesize : \(zoomLevel), \(newGifGap)")
        
        markerHeightLayoutConstraint?.constant = newSize
        markerWidthLayoutConstraint?.constant = newSize
        markerRing.layer.cornerRadius = newSize/2
        
        gifHeightLayoutConstraint?.constant = newSize - newGifGap
        gifWidthLayoutConstraint?.constant = newSize - newGifGap
        gifImage.layer.cornerRadius = (newSize - newGifGap)/2

        triHeightLayoutConstraint?.constant = newTriHeight
        triWidthLayoutConstraint?.constant = newTriWidth
        
        self.frame.size.height = newSize + newTriHeight - 2
        self.frame.size.width = newSize
        self.widthOriginOffset = newSize //test => adjust origin for map projection
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
        
        //test > remove pulsewave when click on marker
        stopPulseWave()
        dequeueObject()
        
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

//protocol PlaceBDelegate : AnyObject {
protocol PlaceBDelegate : MarkerDelegate {
//    func didClickPlaceB(marker: PlaceBMarker, coord: CLLocationCoordinate2D)
}
class PlaceBMarker: PlaceMarker {
    var markerRing = UIView()
    var viewSize: CGFloat = 0
    var gifImage = SDAnimatedImageView()
    var photoImage = SDAnimatedImageView()
//    var coordinateLocation : CLLocationCoordinate2D?
    var gifWidthLayoutConstraint: NSLayoutConstraint?
    var gifHeightLayoutConstraint: NSLayoutConstraint?
    var photoWidthLayoutConstraint: NSLayoutConstraint?
    var photoHeightLayoutConstraint: NSLayoutConstraint?
    
    var roundBase = UIView()
    var roundTopAnchorLayoutConstraint: NSLayoutConstraint?
    var roundWidthLayoutConstraint: NSLayoutConstraint?
    var roundHeightLayoutConstraint: NSLayoutConstraint?
    
    var markerWidthLayoutConstraint: NSLayoutConstraint?
    var markerHeightLayoutConstraint: NSLayoutConstraint?
    
    var triangle = TriangleView()
    var triWidthLayoutConstraint: NSLayoutConstraint?
    var triHeightLayoutConstraint: NSLayoutConstraint?
    
    var ovalBase = OvalView()
    var ovalWidthLayoutConstraint: NSLayoutConstraint?
    var ovalHeightLayoutConstraint: NSLayoutConstraint?
    
    let box = UIView()
    
//    weak var delegate : PlaceBDelegate?
    
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
        
        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
//        self.addSubview(markerRing)
        box.addSubview(markerRing) //test
        markerRing.backgroundColor = .white
//        markerRing.backgroundColor = .black
        markerRing.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
//        markerRing.layer.cornerRadius = (viewSize)/2
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
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        guard let imageUrl = imageUrl else {
//            return
//        }

        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.backgroundColor = .ddmDarkGreyColor
        gifImage.backgroundColor = .ddmDarkColor
        markerRing.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        gifImage.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
//        gifImage.heightAnchor.constraint(equalToConstant: viewSize - 8).isActive = true
//        gifImage.widthAnchor.constraint(equalToConstant: viewSize - 8).isActive = true
        gifHeightLayoutConstraint = gifImage.heightAnchor.constraint(equalToConstant: viewSize - 4)
        gifHeightLayoutConstraint?.isActive = true
        gifWidthLayoutConstraint = gifImage.widthAnchor.constraint(equalToConstant: viewSize - 4)
        gifWidthLayoutConstraint?.isActive = true
//        gifImage.isUserInteractionEnabled = true
//        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onInfoWindowClicked)))
        
        box.addSubview(roundBase)//test
        roundBase.translatesAutoresizingMaskIntoConstraints = false
//        roundBase.topAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: -10).isActive = true
        roundTopAnchorLayoutConstraint = roundBase.topAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: -10)
        roundTopAnchorLayoutConstraint?.isActive = true
        roundBase.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        roundHeightLayoutConstraint = roundBase.heightAnchor.constraint(equalToConstant: 20)
        roundHeightLayoutConstraint?.isActive = true
        roundWidthLayoutConstraint = roundBase.widthAnchor.constraint(equalToConstant: 20)
        roundWidthLayoutConstraint?.isActive = true
        roundBase.backgroundColor = .white
//        roundBase.layer.opacity = 0
        
        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        guard let imageUrl2 = imageUrl2 else {
            return
        }
        photoImage.contentMode = .scaleAspectFill
        photoImage.layer.masksToBounds = true
//        gifImage.layer.cornerRadius = 8
//        gifImage.layer.cornerRadius = (viewSize - 8)/2
        photoImage.sd_setImage(with: imageUrl2)
        photoImage.backgroundColor = .ddmDarkGreyColor
        roundBase.addSubview(photoImage)
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.centerXAnchor.constraint(equalTo: roundBase.centerXAnchor).isActive = true
        photoImage.centerYAnchor.constraint(equalTo: roundBase.centerYAnchor).isActive = true
        photoHeightLayoutConstraint = photoImage.heightAnchor.constraint(equalToConstant: 20 - 4)
        photoHeightLayoutConstraint?.isActive = true
        photoWidthLayoutConstraint = photoImage.widthAnchor.constraint(equalToConstant: 20 - 4)
        photoWidthLayoutConstraint?.isActive = true
        
        box.addSubview(triangle)//test
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.topAnchor.constraint(equalTo: roundBase.bottomAnchor, constant: -2).isActive = true
        triangle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        triHeightLayoutConstraint = triangle.heightAnchor.constraint(equalToConstant: 7)
        triHeightLayoutConstraint?.isActive = true
        triWidthLayoutConstraint = triangle.widthAnchor.constraint(equalToConstant: 14)
        triWidthLayoutConstraint?.isActive = true
        
        //test > shadow
        box.insertSubview(ovalBase, belowSubview: roundBase)
        ovalBase.translatesAutoresizingMaskIntoConstraints = false
        ovalWidthLayoutConstraint = ovalBase.widthAnchor.constraint(equalToConstant: 26)
        ovalWidthLayoutConstraint?.isActive = true
        ovalHeightLayoutConstraint = ovalBase.heightAnchor.constraint(equalToConstant: 8)
        ovalHeightLayoutConstraint?.isActive = true
        ovalBase.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        ovalBase.topAnchor.constraint(equalTo: roundBase.bottomAnchor, constant: -2).isActive = true //default: -2
        ovalBase.layer.opacity = 0.6 //default: 0.2
        
        let infoBox = UIView()
        box.addSubview(infoBox) //test
//        adot.backgroundColor = .ddmAccentColor
        infoBox.backgroundColor = .white
        infoBox.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        infoBox.layer.cornerRadius = 5
        infoBox.translatesAutoresizingMaskIntoConstraints = false
        infoBox.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        infoBox.topAnchor.constraint(equalTo: triangle.bottomAnchor, constant: 5).isActive = true
        infoBox.heightAnchor.constraint(equalToConstant: 15).isActive = true
        infoBox.isHidden = true

        let aMiniText = UILabel()
        aMiniText.textAlignment = .center
        aMiniText.textColor = .ddmBlackOverlayColor
        aMiniText.font = .boldSystemFont(ofSize: 11)
        infoBox.addSubview(aMiniText)
        aMiniText.translatesAutoresizingMaskIntoConstraints = false
        aMiniText.centerYAnchor.constraint(equalTo: infoBox.centerYAnchor).isActive = true
        aMiniText.leadingAnchor.constraint(equalTo: infoBox.leadingAnchor, constant: 5).isActive = true
        aMiniText.trailingAnchor.constraint(equalTo: infoBox.trailingAnchor, constant: -5).isActive = true
//        aMiniText.text = "馬斯克"
        aMiniText.text = "Base"
        
        //test 1 > tap marker itself to trigger click event
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
    }
    override func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
//        changeSize(zoomLevel: changeSizeZoom)
        changeSize(zoomLevel: changeSizeZoom, duringInitialization: true)
        initialize(withAnimation: withAnimation)
    }
    func initialize(withAnimation: Bool) {
        print("placeBMarker init")
        //test 2 > fade in when initialized
        isInitialized = true
        
        if(withAnimation) {
            self.layer.opacity = 0.0
            self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], //default: 0.5, delay 0.8 //0.3
                animations: {
                    self.layer.opacity = 1.0
                    self.box.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        }
    }
    
    override func configure(data: String) {
//        if(data == "a") {
//            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//            guard let imageUrl = imageUrl else {
//                return
//            }
//            self.gifImage.sd_setImage(with: imageUrl)
//        }
        
        asyncConfigure(data: "")
    }
    
    //*test > async fetch images/names/videos
    func asyncConfigure(data: String) {
        let id = "u" //u_
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
                    guard let imageUrl = imageUrl else {
                        return
                    }
                    self.gifImage.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    let imageUrl = URL(string: "")
                    guard let imageUrl = imageUrl else {
                        return
                    }
                    self.gifImage.sd_setImage(with: imageUrl)
                }
                break
            }
        }
    }
    //*
    
    @objc func onMarkerClicked(gesture: UITapGestureRecognizer) {
        print("onmarkerclicked: \(self.frame.size.height)")
        self.delegate?.didClickPlaceB(marker: self, coord: self.coordinateLocation!)
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
        isOnScreen = true
        popIn(withAnimation: withAnimation)
    }
    
    override func changeOffScreen(withAnimation: Bool) {
        isOnScreen = false
        fadeOut(withAnimation: withAnimation)
    }
    
    override func changeInitializeOn(withAnimation: Bool) {
        isInitialized = true
        popIn(withAnimation: withAnimation)
    }
    
    override func changeInitializeOff(withAnimation: Bool) {
        isInitialized = false
        popOut(withAnimation: withAnimation)
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
    
    //test > varying initial size instead of fixed size
//    var minMarkerWidth: CGFloat = 44 //44
    var minMarkerWidth: CGFloat = 0 //44
    var maxMarkerWidth: CGFloat = 100
    var minGifGap: CGFloat = 4.0
    var maxGifGap: CGFloat = 8.0
    var minRoundHeight: CGFloat = 20.0
    var maxRoundHeight: CGFloat = 30.0
    var minRoundGap: CGFloat = 4.0
    var maxRoundGap: CGFloat = 8.0
    var minOvalWidth: CGFloat = 26
    var maxOvalWidth: CGFloat = 50
    var minOvalHeight: CGFloat = 8
    var maxOvalHeight: CGFloat = 16
    var minTriWidth: CGFloat = 7
    var maxTriWidth: CGFloat = 14
    var minTriHeight: CGFloat = 3.5
    var maxTriHeight: CGFloat = 7
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        //test > initialize random size if not already
        if(minMarkerWidth == 0) {
//            minMarkerWidth = CGFloat(generateRandomSize())
            minMarkerWidth = 44.0
        }
        //test > using zoom level
        var newSize = minMarkerWidth
        var newGifGap = minGifGap
        var newRoundHeight = minRoundHeight
        var newRoundGap = minRoundGap
        var newOvalWidthSize = minOvalWidth
        var newOvalHeightSize = minOvalHeight
        var newTriHeight = minTriHeight
        var newTriWidth = minTriWidth
        if(zoomLevel >= 8) {
            newSize = minMarkerWidth + ((maxMarkerWidth - minMarkerWidth)/(20 - 8) * (zoomLevel - 8))
            newGifGap = minGifGap + ((maxGifGap - minGifGap)/(20 - 8) * (zoomLevel - 8))
            newRoundHeight = minRoundHeight + ((maxRoundHeight - minRoundHeight)/(20 - 8) * (zoomLevel - 8))
            newRoundGap = minRoundGap + ((maxRoundGap - minRoundGap)/(20 - 8) * (zoomLevel - 8))
            newOvalWidthSize = minOvalWidth + ((maxOvalWidth - minOvalWidth)/(20 - 8) * (zoomLevel - 8))
            newOvalHeightSize = minOvalHeight + ((maxOvalHeight - minOvalHeight)/(20 - 8) * (zoomLevel - 8))
            newTriHeight = minTriHeight + ((maxTriHeight - minTriHeight)/(20 - 8) * (zoomLevel - 8))
            newTriWidth = minTriWidth + ((maxTriWidth - minTriWidth)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = minMarkerWidth
            newGifGap = minGifGap
            newRoundHeight = minRoundHeight
            newRoundGap = minRoundGap
            newOvalWidthSize = minOvalWidth
            newOvalHeightSize = minOvalHeight
            newTriHeight = minTriHeight
            newTriWidth = minTriWidth
        }
        
        print("changesize : \(zoomLevel), \(newGifGap)")
        markerHeightLayoutConstraint?.constant = newSize * 16 / 9
        markerWidthLayoutConstraint?.constant = newSize
        markerRing.layer.cornerRadius = newGifGap * 3
        
        gifHeightLayoutConstraint?.constant = newSize * 16 / 9 - newGifGap
        gifWidthLayoutConstraint?.constant = newSize - newGifGap
        gifImage.layer.cornerRadius = newGifGap * 3 - 2
        
        roundHeightLayoutConstraint?.constant = newRoundHeight
        roundWidthLayoutConstraint?.constant = newRoundHeight
        roundTopAnchorLayoutConstraint?.constant = -newRoundHeight/2
        roundBase.layer.cornerRadius = newRoundHeight / 2
        
        photoHeightLayoutConstraint?.constant = newRoundHeight - newRoundGap
        photoWidthLayoutConstraint?.constant = newRoundHeight - newRoundGap
        photoImage.layer.cornerRadius = (newRoundHeight - newRoundGap)/2
        
        ovalWidthLayoutConstraint?.constant = newOvalWidthSize
        ovalHeightLayoutConstraint?.constant = newOvalHeightSize
        
        triHeightLayoutConstraint?.constant = newTriHeight
        triWidthLayoutConstraint?.constant = newTriWidth
        
        self.frame.size.height = newSize * 16 / 9 + newRoundHeight / 2 + newTriHeight - 2
        self.frame.size.width = newSize
        self.widthOriginOffset = newSize //test => adjust origin for map projection
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

extension ViewController: PlaceBDelegate{
    func didClickPlaceB(marker: PlaceBMarker, coord: CLLocationCoordinate2D) {
        print("placeBdelegate didclick:")

        //test > show video when clicked
        stopPulseWave()
        
        dequeueObject()
        let qId = addQueueObject()
        if(qId != -1) {
            marker.setId(id: qId)
        }
        
        guard let mapView = self.mapView else {
            return
        }
        let point = mapView.projection.point(for: coord)
        let offsetX = point.x - self.view.frame.width/2
//        let offsetY = point.y - self.view.frame.height/2
        let offsetY = point.y - self.view.frame.height/2 - marker.frame.height/2 //*offset here is not important, will not be used by program
        
        print("async marker open video: ")
        //test > dequeue object
        if(!queueObjectList.isEmpty) {
            let d = queueObjectList[queueObjectList.count - 1].getIsToOpenPanel()
            let id = queueObjectList[queueObjectList.count - 1].getId()
            
            if(id == marker.getId()) {
                if(d) {
//                    self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: marker, originatorViewType: OriginatorTypes.PLACEMARKER, id: id)
                    
                    //test > marker id
                    self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: marker, originatorViewType: OriginatorTypes.PLACEMARKER, id: id, originatorViewId: marker.getMarkerId())
                }
            }
        }
    }
}
