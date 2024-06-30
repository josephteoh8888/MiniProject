//
//  PlaceBMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

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
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        guard let imageUrl = imageUrl else {
            return
        }

        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
//        gifImage.layer.cornerRadius = 8
//        gifImage.layer.cornerRadius = (viewSize - 8)/2
        gifImage.sd_setImage(with: imageUrl)
        gifImage.backgroundColor = .ddmDarkGreyColor
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
    
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        
        //test > using zoom level
        var newSize = 44.0
        var newGifGap = 4.0
        var newRoundHeight = 20.0
        var newRoundGap = 4.0
        var newOvalWidthSize = 26.0
        var newOvalHeightSize = 8.0
        var newTriHeight = 3.5
        var newTriWidth = 7.0
        if(zoomLevel >= 8) {
            newSize = 44 + ((100 - 44)/(20 - 8) * (zoomLevel - 8))
            newGifGap = 4 + ((8 - 4)/(20 - 8) * (zoomLevel - 8))
            newRoundHeight = 20 + ((30 - 20)/(20 - 8) * (zoomLevel - 8))
            newRoundGap = 4 + ((8 - 4)/(20 - 8) * (zoomLevel - 8))
            newOvalWidthSize = 26 + ((50 - 26)/(20 - 8) * (zoomLevel - 8))
            newOvalHeightSize = 8 + ((16 - 8)/(20 - 8) * (zoomLevel - 8))
            newTriHeight = 3.5 + ((7 - 3.5)/(20 - 8) * (zoomLevel - 8))
            newTriWidth = 7 + ((14 - 7)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = 44
            newGifGap = 4
            newRoundHeight = 20
            newRoundGap = 4
            newOvalWidthSize = 26
            newOvalHeightSize = 8
            newTriHeight = 3.5
            newTriWidth = 7.0
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
        let offsetY = point.y - self.view.frame.height/2 - self.view.frame.height/2 //offset here is not important, will not be used by program
        
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
