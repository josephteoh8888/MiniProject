//
//  UserMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

//protocol UserMarkerDelegate : AnyObject {
protocol UserMarkerDelegate : MarkerDelegate {
//    func didClickUserMarker(marker: UserMarker, coord: CLLocationCoordinate2D)
}
class UserMarker: Marker {

    var markerRing = UIView()
    var viewSize: CGFloat = 0
    var gifImage = SDAnimatedImageView()
//    var coordinateLocation : CLLocationCoordinate2D?
    let box = UIView()

    var markerWidthLayoutConstraint: NSLayoutConstraint?
    var markerHeightLayoutConstraint: NSLayoutConstraint?

    var gifWidthLayoutConstraint: NSLayoutConstraint?
    var gifHeightLayoutConstraint: NSLayoutConstraint?

//    var isInitialized = false
//    var isOnScreen = false

    //test
    var triangle = RightCenterTriangleView()
    var triWidthLayoutConstraint: NSLayoutConstraint?
    var triHeightLayoutConstraint: NSLayoutConstraint?

    //test shadow
    var ovalBase = OvalView()
    var ovalWidthLayoutConstraint: NSLayoutConstraint?
    var ovalHeightLayoutConstraint: NSLayoutConstraint?

    let dot = UIView()
    let adot = UIView()
    var dotWidthLayoutConstraint: NSLayoutConstraint?
    var dotHeightLayoutConstraint: NSLayoutConstraint?
    var aDotWidthLayoutConstraint: NSLayoutConstraint?
    var aDotHeightLayoutConstraint: NSLayoutConstraint?

//    weak var delegate : UserMarkerDelegate?
    
    let infoBox = UIView()

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

        box.addSubview(markerRing) //test
        markerRing.backgroundColor = .white
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

//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        guard let imageUrl = imageUrl else {
//            return
//        }

        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = (viewSize - 8)/2
//        gifImage.backgroundColor = .ddmDarkGreyColor
        gifImage.backgroundColor = .ddmDarkColor
//        gifImage.sd_setImage(with: imageUrl)
        markerRing.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        gifImage.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
        gifHeightLayoutConstraint = gifImage.heightAnchor.constraint(equalToConstant: viewSize - 8)
        gifHeightLayoutConstraint?.isActive = true
        gifWidthLayoutConstraint = gifImage.widthAnchor.constraint(equalToConstant: viewSize - 8)
        gifWidthLayoutConstraint?.isActive = true
//        gifImage.isUserInteractionEnabled = true
//        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onInfoWindowClicked)))

        //test 1 > with nearme symbol => not very good
//        let aBtnBox = UIView()
////        aBtnBox.backgroundColor = .ddmBlackOverlayColor
//        aBtnBox.backgroundColor = .white
////        aBtnBox.backgroundColor = .ddmAccentColor
//        box.addSubview(aBtnBox)
//        aBtnBox.translatesAutoresizingMaskIntoConstraints = false
//        aBtnBox.topAnchor.constraint(equalTo: markerRing.topAnchor, constant: 0).isActive = true
////        aBtnBox.centerXAnchor.constraint(equalTo: aMini.centerXAnchor).isActive = true
//        aBtnBox.trailingAnchor.constraint(equalTo: markerRing.trailingAnchor).isActive = true
//        aBtnBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aBtnBox.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        aBtnBox.layer.cornerRadius = 10
//        aBtnBox.layer.shadowColor = UIColor.ddmDarkColor.cgColor
//        aBtnBox.layer.shadowRadius = 3.0  //ori 3
//        aBtnBox.layer.shadowOpacity = 1.0 //ori 1
//        aBtnBox.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
//        aBtnBox.layer.opacity = 0.3

//        let aBtn = UIImageView(image: UIImage(named:"icon_round_near_me")?.withRenderingMode(.alwaysTemplate))
////        aBtn.tintColor = .white
//        aBtn.tintColor = .ddmBlackOverlayColor
//        aBtnBox.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.centerXAnchor.constraint(equalTo: aBtnBox.centerXAnchor).isActive = true
//        aBtn.centerYAnchor.constraint(equalTo: aBtnBox.centerYAnchor).isActive = true
//        aBtn.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        aBtn.widthAnchor.constraint(equalToConstant: 10).isActive = true

        //test 2 > add rect
//        let rect = UIView()
//        box.insertSubview(rect, belowSubview: markerRing)
//        rect.translatesAutoresizingMaskIntoConstraints = false
//        rect.leadingAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        rect.topAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
//        rect.trailingAnchor.constraint(equalTo: markerRing.trailingAnchor).isActive = true
//        rect.bottomAnchor.constraint(equalTo: markerRing.bottomAnchor).isActive = true
//        rect.backgroundColor = .white

        //test 3 > waze design
//        var triangle = RightTriangleView()
////        box.addSubview(triangle)//test
//        box.insertSubview(triangle, belowSubview: markerRing)
//        triangle.translatesAutoresizingMaskIntoConstraints = false
//        triangle.bottomAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: 0).isActive = true
////        triangle.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor, constant: 0).isActive = true
//        triangle.leadingAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
////        triangle.leadingAnchor.constraint(equalTo: markerRing.trailingAnchor, constant: -3).isActive = true
//        triHeightLayoutConstraint = triangle.heightAnchor.constraint(equalToConstant: 44)
//        triHeightLayoutConstraint?.isActive = true
//        triWidthLayoutConstraint = triangle.widthAnchor.constraint(equalToConstant: 32)
//        triWidthLayoutConstraint?.isActive = true

        //test 4 > chat bubble design
//        var triangle = RightCenterTriangleView()
//        box.addSubview(triangle)//test
////        box.insertSubview(triangle, belowSubview: markerRing)
//        triangle.translatesAutoresizingMaskIntoConstraints = false
////        triangle.bottomAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: 0).isActive = true
//        triangle.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor, constant: 0).isActive = true
////        triangle.leadingAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        triangle.leadingAnchor.constraint(equalTo: markerRing.trailingAnchor, constant: -3).isActive = true
//        triHeightLayoutConstraint = triangle.heightAnchor.constraint(equalToConstant: 44)
//        triHeightLayoutConstraint?.isActive = true
//        triWidthLayoutConstraint = triangle.widthAnchor.constraint(equalToConstant: 32)
//        triWidthLayoutConstraint?.isActive = true

        //test 5 > add bottom dot design
//        let dot = UIView()
        box.addSubview(dot) //test
        dot.backgroundColor = .white
//        markerRing.backgroundColor = .black
        dot.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        dot.layer.cornerRadius = (16)/2
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        dot.topAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: -8).isActive = true
        dot.centerYAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: 0).isActive = true
//        dot.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        dot.widthAnchor.constraint(equalToConstant: 16).isActive = true
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
//        adot.layer.opacity = 0.5

        box.insertSubview(ovalBase, belowSubview: dot)
        ovalBase.translatesAutoresizingMaskIntoConstraints = false
        ovalWidthLayoutConstraint = ovalBase.widthAnchor.constraint(equalToConstant: 26)
        ovalWidthLayoutConstraint?.isActive = true
        ovalHeightLayoutConstraint = ovalBase.heightAnchor.constraint(equalToConstant: 8)
        ovalHeightLayoutConstraint?.isActive = true
        ovalBase.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        ovalBase.topAnchor.constraint(equalTo: dot.bottomAnchor, constant: -4).isActive = true //default: -2
        ovalBase.layer.opacity = 0.6 //default: 0.2

//        let infoBox = UIView()
        box.addSubview(infoBox) //test
//        adot.backgroundColor = .ddmAccentColor
        infoBox.backgroundColor = .white
        infoBox.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        infoBox.layer.cornerRadius = 5
        infoBox.translatesAutoresizingMaskIntoConstraints = false
        infoBox.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        infoBox.topAnchor.constraint(equalTo: dot.bottomAnchor, constant: 5).isActive = true
        infoBox.heightAnchor.constraint(equalToConstant: 15).isActive = true

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
        aMiniText.text = "Me"

        //test 1 > tap marker itself to trigger click event
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
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
        if(data == "a") {
            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            guard let imageUrl = imageUrl else {
                return
            }
            self.gifImage.sd_setImage(with: imageUrl)
        }
        
//        asyncConfigure(data: "")
    }
    
    //*test > async fetch images/names/videos
//    func asyncConfigure(data: String) {
//        let id = "a" //u_
//        DataFetchManager.shared.fetchDummyDataTimeDelay(id: id) { [weak self]result in
//            switch result {
//                case .success(let l):
//
//                //update UI on main thread
//                DispatchQueue.main.async {
//                    print("pdp api success \(id), \(l)")
//                    
//                    guard let self = self else {
//                        return
//                    }
//                    
//                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                    guard let imageUrl = imageUrl else {
//                        return
//                    }
//                    self.gifImage.sd_setImage(with: imageUrl)
//                }
//
//                case .failure(let error):
//                DispatchQueue.main.async {
//                    
//                    guard let self = self else {
//                        return
//                    }
//                    let imageUrl = URL(string: "")
//                    guard let imageUrl = imageUrl else {
//                        return
//                    }
//                    self.gifImage.sd_setImage(with: imageUrl)
//                }
//                break
//            }
//        }
//    }
    //*

    @objc func onMarkerClicked(gesture: UITapGestureRecognizer) {
        print("onmarkerclicked: \(self.frame.size.height)")
        self.delegate?.didClickUserMarker(marker: self, coord: self.coordinateLocation!)
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

    override func changeSize(zoomLevel: CGFloat) {
        changeSize(zoomLevel: zoomLevel, duringInitialization: false)
    }
    
    //test > varying initial size instead of fixed size
//    var minMarkerWidth: CGFloat = 44 //44
    var minMarkerWidth: CGFloat = 0 //44
    var maxMarkerWidth: CGFloat = 100
    var minGifGap: CGFloat = 6.0
    var maxGifGap: CGFloat = 14.0
    var minOvalWidth: CGFloat = 26
    var maxOvalWidth: CGFloat = 50
    var minOvalHeight: CGFloat = 8
    var maxOvalHeight: CGFloat = 16
    var minDotGap: CGFloat = 6.0
    var maxDotGap: CGFloat = 10.0
    var minDotSize: CGFloat = 16.0
    var maxDotSize: CGFloat = 26.0
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        //test > initialize random size if not already
        if(minMarkerWidth == 0) {
//            minMarkerWidth = CGFloat(generateRandomSize())
            minMarkerWidth = 44
        }
        //test > varying marker size
        var newSize = minMarkerWidth //default 40
        var newGifGap = minGifGap //default 8
        var newOvalWidthSize = minOvalWidth
        var newOvalHeightSize = minOvalHeight
        var newDotSize = minDotSize
        var newDotGap = minDotGap
//        var newCornerRadiusGap = 5.0
        if(zoomLevel >= 8) {
            newSize = minMarkerWidth + ((maxMarkerWidth - minMarkerWidth)/(20 - 8) * (zoomLevel - 8))
            newGifGap = minGifGap + ((maxGifGap - minGifGap)/(20 - 8) * (zoomLevel - 8))
            newOvalWidthSize = minOvalWidth + ((maxOvalWidth - minOvalWidth)/(20 - 8) * (zoomLevel - 8))
            newOvalHeightSize = minOvalHeight + ((maxOvalHeight - minOvalHeight)/(20 - 8) * (zoomLevel - 8))
//            newCornerRadiusGap = 5 + ((13 - 5)/(20 - 8) * (zoomLevel - 8))
            newDotSize = minDotSize + ((maxDotSize - minDotSize)/(20 - 8) * (zoomLevel - 8))
            newDotGap = minDotGap + ((maxDotGap - minDotGap)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = minMarkerWidth
            newGifGap = minGifGap
            newOvalWidthSize = minOvalWidth
            newOvalHeightSize = minOvalHeight
//            newCornerRadiusGap = 5
            newDotSize = minDotSize
            newDotGap = minDotGap
        }

        print("changesize user : \(isOnScreen), \(isInitialized), \(newDotSize), \(newDotGap)")

        //test > with condition of "isinitialized"
        if(duringInitialization) {
            markerHeightLayoutConstraint?.constant = newSize
            markerWidthLayoutConstraint?.constant = newSize
//            markerRing.layer.cornerRadius = newSize/2 - newCornerRadiusGap //ori
            markerRing.layer.cornerRadius = newSize/2 //test rounded shape
            
            gifHeightLayoutConstraint?.constant = newSize - newGifGap
            gifWidthLayoutConstraint?.constant = newSize - newGifGap
//            gifImage.layer.cornerRadius = (newSize - newGifGap)/2 - newCornerRadiusGap
            gifImage.layer.cornerRadius = (newSize - newGifGap)/2

            ovalWidthLayoutConstraint?.constant = newOvalWidthSize
            ovalHeightLayoutConstraint?.constant = newOvalHeightSize

            dotWidthLayoutConstraint?.constant = newDotSize
            dotHeightLayoutConstraint?.constant = newDotSize
            dot.layer.cornerRadius = newDotSize/2

            aDotWidthLayoutConstraint?.constant = newDotSize - newDotGap
            aDotHeightLayoutConstraint?.constant = newDotSize - newDotGap
            adot.layer.cornerRadius = (newDotSize - newDotGap)/2

            self.frame.size.height = newSize + newDotSize/2
            self.frame.size.width = newSize
            self.widthOriginOffset = newSize //test => adjust origin for map projection
        } else {
            if(isInitialized) {
                if(isOnScreen) {
                    markerHeightLayoutConstraint?.constant = newSize
                    markerWidthLayoutConstraint?.constant = newSize
//                    markerRing.layer.cornerRadius = newSize/2 - newCornerRadiusGap //ori
                    markerRing.layer.cornerRadius = newSize/2 //test rounded shape

                    gifHeightLayoutConstraint?.constant = newSize - newGifGap
                    gifWidthLayoutConstraint?.constant = newSize - newGifGap
//                    gifImage.layer.cornerRadius = (newSize - newGifGap)/2 - newCornerRadiusGap
                    gifImage.layer.cornerRadius = (newSize - newGifGap)/2
                    
                    ovalWidthLayoutConstraint?.constant = newOvalWidthSize
                    ovalHeightLayoutConstraint?.constant = newOvalHeightSize

                    dotWidthLayoutConstraint?.constant = newDotSize
                    dotHeightLayoutConstraint?.constant = newDotSize
                    dot.layer.cornerRadius = newDotSize/2

                    aDotWidthLayoutConstraint?.constant = newDotSize - newDotGap
                    aDotHeightLayoutConstraint?.constant = newDotSize - newDotGap
                    adot.layer.cornerRadius = (newDotSize - newDotGap)/2

                    self.frame.size.height = newSize + newDotSize/2
                    self.frame.size.width = newSize
                    self.widthOriginOffset = newSize //test => adjust origin for map projection
                }
            }
        }
    }

    override func close() {
        self.removeFromSuperview()
    }
    
    func hideInfoBox() {
        infoBox.isHidden = true
    }
    
    func showInfoBox() {
        infoBox.isHidden = false
    }
}

extension ViewController: UserMarkerDelegate{
    func didClickUserMarker(marker: UserMarker, coord: CLLocationCoordinate2D) {
        print("usermarkerdelegate didclick:")

        //test > remove pulsewave when click on marker
        stopPulseWave()
        dequeueObject()
        
        //TODO: test scrollable user panel


        //test > try focus on current user location(for "me" marker only)
        //For "ME" marker only which requires user's gps; other users profile do not apply
        //*TODO: change user's gps to user's base
        isUserGetLocationClicked = true

        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            print("location getL prompt 1")

            //test 2 > use optional latestuserlocation
            guard let autoUserLocation = self.autoUserLocation else { //for faster location detection
                locationManager.requestLocation() //request location once
                return
            }
            animateMapToUserLocation()
        case .authorizedWhenInUse:
            print("location getL prompt 2")

            //test 2 > use optional latestuserlocation
            guard let autoUserLocation = self.autoUserLocation else {
                locationManager.requestLocation() //request location once
                return
            }
            animateMapToUserLocation()
        case .denied:
            print("location getL prompt 3")
            //test > location error msg
            openLocationErrorPromptMsg()
        case .notDetermined:
            print("location getL prompt 4")
            //test > location error msg
            openLocationErrorPromptMsg()
        case .restricted:
            print("location getL prompt 5")
            //test > location error msg
            openLocationErrorPromptMsg()
        @unknown default:
            print("location getL prompt unknown")
            //test > location error msg
            openLocationErrorPromptMsg()
        }
    }
}
