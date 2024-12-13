//
//  PhotoMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

class PhotoMarker: Marker {

}
//test > squarish rounded photo markers
class PhotoBMarker: ExploreMarker {
    
//    var markerRing = RingView()
    var markerRing = UIView()
    var viewSize: CGFloat = 0
    var gifImage = SDAnimatedImageView()
//    var coordinateLocation : CLLocationCoordinate2D?
    
    //test changing marker size while map-zooming
    var markerWidthLayoutConstraint: NSLayoutConstraint?
    var markerHeightLayoutConstraint: NSLayoutConstraint?
    var gifWidthLayoutConstraint: NSLayoutConstraint?
    var gifHeightLayoutConstraint: NSLayoutConstraint?
    
    var ovalWidthLayoutConstraint: NSLayoutConstraint?
    var ovalHeightLayoutConstraint: NSLayoutConstraint?
    
//    var isOnScreen = false
//    var isInitialized = false
    
    var ovalBase = OvalView()
    
//    weak var delegate : ExploreMarkerDelegate?
    
    
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
        self.addSubview(ovalBase)
        ovalBase.translatesAutoresizingMaskIntoConstraints = false
        ovalWidthLayoutConstraint = ovalBase.widthAnchor.constraint(equalToConstant: 26)
        ovalWidthLayoutConstraint?.isActive = true
        ovalHeightLayoutConstraint = ovalBase.heightAnchor.constraint(equalToConstant: 8)
        ovalHeightLayoutConstraint?.isActive = true
        ovalBase.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ovalBase.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true //default: -2
        ovalBase.layer.opacity = 0.6 //default: 0.2
        
        self.addSubview(markerRing)
        markerRing.backgroundColor = .white
        markerRing.layer.masksToBounds = true
        markerRing.translatesAutoresizingMaskIntoConstraints = false
        markerRing.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        markerRing.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        markerHeightLayoutConstraint = markerRing.heightAnchor.constraint(equalToConstant: viewSize)
        markerHeightLayoutConstraint?.isActive = true
        markerWidthLayoutConstraint = markerRing.widthAnchor.constraint(equalToConstant: viewSize)
        markerWidthLayoutConstraint?.isActive = true
        
        //test > ringview
//        self.addSubview(markerRing)
//        markerRing.translatesAutoresizingMaskIntoConstraints = false
//        markerRing.translatesAutoresizingMaskIntoConstraints = false
//        markerRing.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        markerRing.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        markerRing.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        markerRing.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        markerRing.changeLineWidth(width: 3)
        
        //add gif
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
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
        
        //test 1 > tap marker itself to trigger click event
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
    
        //test > confetti
//        createParticles()
    }
    
    override func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
        changeSize(zoomLevel: changeSizeZoom, duringInitialization: true)
        initialize(withAnimation: withAnimation)
    }
    func initialize(withAnimation: Bool) {
        //test 2 > fade in when initialized
        isInitialized = true
//        isOnScreen = true //test
        
        if(withAnimation) {
            self.layer.opacity = 0.0
            self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [], //default: 0.5, delay 0.5
                animations: {
                    self.layer.opacity = 1.0
    //                self.transform = CGAffineTransform.identity
                    self.markerRing.transform = CGAffineTransform.identity //test
                    self.ovalBase.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        }
    }
    
    override func addLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }
    
    override func changeLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }
    
    @objc func onMarkerClicked(gesture: UITapGestureRecognizer) {
        print("onmarkerclicked: \(self.frame.size.height)")

        UIView.animate(withDuration: 0.2, //default 0.2
            animations: {
//                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.markerRing.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) //test
                self.ovalBase.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) //test
            },
            completion: { _ in
            
            UIView.animate(withDuration: 0.2, //default 0.2
                    animations: {
//                        self.transform = CGAffineTransform.identity
                        self.markerRing.transform = CGAffineTransform.identity //test
                        self.ovalBase.transform = CGAffineTransform.identity //test
                    },
                    completion: { _ in
                        print("async marker start open video: ")
                        //test > dequeue object
                        self.delegate?.didClickExploreMarker(coord: self.coordinateLocation!, markerHeight: self.frame.size.height, marker: self)
                        
                    })
            })
        
        //test > async action
        self.delegate?.didStartClickExploreMarker(marker: self)
    }
    
    override func disappear() {
        
        //test
        UIView.animate(withDuration: 0.2,
            animations: {
                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.layer.opacity = 0.0
            
                //test
                self.superview?.layoutIfNeeded()
            },
            completion: { _ in

            })
    }
    
    override func reappear() {
        //test
        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], //default delay 0.5
            animations: {
                self.markerRing.transform = CGAffineTransform.identity
                self.ovalBase.transform = CGAffineTransform.identity
                self.layer.opacity = 1.0
            
                //test
                self.superview?.layoutIfNeeded()
            },
            completion: { _ in

            })
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
    
    override func animateFromVideoClose() {
        //test 1 > shutter method
        shutter()
        
        //test 2 > gif image change opacity
//        self.gifImage.layer.opacity = 1.0
        
        //test 3 > shutter gif image
//        shutterGifImage()
    }
    
    //test > hide marker
    override func hideForShutter() {
        //test 1 > shutter method
        self.layer.opacity = 0.0
        
        //test 2 > gif image change opacity
//        self.gifImage.layer.opacity = 0.2
    }
    override func dehideForShutter() {
        //test 1 > shutter method
        self.layer.opacity = 1.0
        
        //test 2 > gif image change opacity
//        self.gifImage.layer.opacity = 0.2
    }
    
//    //test > shutter gif image
//    func shutterGifImage() {
//        UIView.animate(withDuration: 0.1,
//            animations: {
//                self.gifImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//            },
//            completion: { _ in
//                UIView.animate(withDuration: 0.1, delay: 0.0, options: [], //test 0.3 delay
//                    animations: {
//                        self.gifImage.transform = CGAffineTransform.identity
//                    },
//                    completion: { _ in
//                    })
//            })
//    }
    //test > marker animation when map padding change
    func shutter() {
        UIView.animate(withDuration: 0.1,
            animations: {
                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.layer.opacity = 0.0
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], //test 0.3 delay
                    animations: {
                        self.markerRing.transform = CGAffineTransform.identity
                        self.ovalBase.transform = CGAffineTransform.identity
                        self.layer.opacity = 1.0
                    },
                    completion: { _ in
                    })
            })
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
            
    //        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test

            UIView.animate(withDuration: 0.5, delay: randomDelay, options: [], //default 0.3
                animations: {
                    self.layer.opacity = 1.0
    //                self.transform = CGAffineTransform.identity
                    self.markerRing.transform = CGAffineTransform.identity //test
                    self.ovalBase.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        } else {
            self.layer.opacity = 1.0
            self.markerRing.transform = CGAffineTransform.identity //test
            self.ovalBase.transform = CGAffineTransform.identity //test
        }
    }
    
    func changeOpacity(zoomLevel: CGFloat) {
        //test > using zoom level
        var newOpacity = 1.0
        if(zoomLevel >= 8) {
            newOpacity = 1 + ((0.0 - 1)/(20 - 8) * (zoomLevel - 8))
        } else {
            newOpacity = 1
        }
        self.layer.opacity = Float(newOpacity)
    }
    
    override func changeSize(zoomLevel: CGFloat) {
        changeSize(zoomLevel: zoomLevel, duringInitialization: false)
    }
    
    //test > generate random initial size for marker
    func generateRandomSize() -> Int{
        return Int.random(in: 24..<50)
    }
    
    //test > varying initial size instead of fixed size
    var minMarkerWidth: CGFloat = 0 //44
    var maxMarkerWidth: CGFloat = 100.0
    var minGifGap: CGFloat = 6.0 //4
    var maxGifGap: CGFloat = 13.0 //8
    var minOvalWidth: CGFloat = 26
    var maxOvalWidth: CGFloat = 50
    var minOvalHeight: CGFloat = 8
    var maxOvalHeight: CGFloat = 16
    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
        
        //test > using zoom level with fixed size
//        var newSize = 44.0 //default 40
//        var newGifGap = 6.0 //default 8
//        var newOvalWidthSize = 26.0
//        var newOvalHeightSize = 8.0
//        if(zoomLevel >= 8) {
//            newSize = 44 + ((110 - 44)/(20 - 8) * (zoomLevel - 8))
//            newGifGap = 6 + ((14 - 6)/(20 - 8) * (zoomLevel - 8))
//            newOvalWidthSize = 26 + ((50 - 26)/(20 - 8) * (zoomLevel - 8))
//            newOvalHeightSize = 8 + ((16 - 8)/(20 - 8) * (zoomLevel - 8))
//        } else {
//            newSize = 44
//            newGifGap = 6
//            newOvalWidthSize = 26
//            newOvalHeightSize = 8
//        }
        
        //test > initialize random size if not already
        if(minMarkerWidth == 0) {
//            minMarkerWidth = CGFloat(generateRandomSize())
            minMarkerWidth = 44.0
        }
        //test > varying marker size
        var newSize = minMarkerWidth //default 40
        var newGifGap = minGifGap //default 8
        var newOvalWidthSize = minOvalWidth
        var newOvalHeightSize = minOvalHeight
        if(zoomLevel >= 8) {
            newSize = minMarkerWidth + ((maxMarkerWidth - minMarkerWidth)/(20 - 8) * (zoomLevel - 8))
            newGifGap = minGifGap + ((maxGifGap - minGifGap)/(20 - 8) * (zoomLevel - 8))
            newOvalWidthSize = minOvalWidth + ((maxOvalWidth - minOvalWidth)/(20 - 8) * (zoomLevel - 8))
            newOvalHeightSize = minOvalHeight + ((maxOvalHeight - minOvalHeight)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = minMarkerWidth
            newGifGap = minGifGap
            newOvalWidthSize = minOvalWidth
            newOvalHeightSize = minOvalHeight
        }
        
        //test > with condition of "isinitialized"
        if(duringInitialization) {
            self.frame.size.height = newSize
            self.frame.size.width = newSize
            
            markerHeightLayoutConstraint?.constant = newSize
            markerWidthLayoutConstraint?.constant = newSize
            markerRing.layer.cornerRadius = newGifGap * 3

            gifHeightLayoutConstraint?.constant = newSize - newGifGap
            gifWidthLayoutConstraint?.constant = newSize - newGifGap
            gifImage.layer.cornerRadius = newGifGap * 3 - 2
            
            ovalWidthLayoutConstraint?.constant = newOvalWidthSize
            ovalHeightLayoutConstraint?.constant = newOvalHeightSize
        } else {
            if(isInitialized) {
                if(isOnScreen) {
                    self.frame.size.height = newSize
                    self.frame.size.width = newSize
                    
                    markerHeightLayoutConstraint?.constant = newSize
                    markerWidthLayoutConstraint?.constant = newSize
                    markerRing.layer.cornerRadius = newGifGap * 3

                    gifHeightLayoutConstraint?.constant = newSize - newGifGap
                    gifWidthLayoutConstraint?.constant = newSize - newGifGap
                    gifImage.layer.cornerRadius = newGifGap * 3 - 2
                    
                    ovalWidthLayoutConstraint?.constant = newOvalWidthSize
                    ovalHeightLayoutConstraint?.constant = newOvalHeightSize
                }
            }
        }
    }
    
    //test > remove markers from map
    override func close() {
        self.removeFromSuperview()
    }
    
    //test > emitter for confetti
    let emitter = CAEmitterLayer()
    func createParticles() {
        
        //test > new method for snow
//        let emitter = CAEmitterLayer()
//        emitter.masksToBounds = true //problem**
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: 22, y: 0)
        emitter.emitterSize = CGSize(width: 44, height: 1)
        
        let near = makeEmmiterCell(color: UIColor(white: 1, alpha: 1), velocity: 44, scale: 0.3) //100
        let middle = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.66), velocity: 44, scale: 0.2) //80
        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 44, scale: 0.1) //60
        
        emitter.emitterCells = [near, middle, far]
        
        let uView = UIView(frame: CGRect(x: 0 , y: 0, width: 44, height: 44))
        self.addSubview(uView)
//        uView.layer.cornerRadius = 10 //10
        uView.isUserInteractionEnabled = false
        uView.layer.addSublayer(emitter)
    }
    
    //test > new method for snow
    func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 1.0 //20
        cell.lifetimeRange = 0
        cell.velocity = velocity
        cell.velocityRange = velocity / 4
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 8
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.contents = UIImage(named: "emitter_snow")?.cgImage
        return cell
    }
}
