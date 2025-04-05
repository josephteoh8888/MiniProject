//
//  SoundMarker.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol SoundMarkerDelegate : MarkerDelegate {

}

class SoundMarker: Marker {

    var markerRing = UIView()
    var viewSize: CGFloat = 0
    var gifImage = SDAnimatedImageView()
    let box = UIView()

    var markerWidthLayoutConstraint: NSLayoutConstraint?
    var markerHeightLayoutConstraint: NSLayoutConstraint?

    var gifWidthLayoutConstraint: NSLayoutConstraint?
    var gifHeightLayoutConstraint: NSLayoutConstraint?

    //test shadow
    var ovalBase = OvalView()
    var ovalWidthLayoutConstraint: NSLayoutConstraint?
    var ovalHeightLayoutConstraint: NSLayoutConstraint?

    let dot = UIView()
//    let adot = UIView()
    let adot = UIImageView()
    var dotWidthLayoutConstraint: NSLayoutConstraint?
    var dotHeightLayoutConstraint: NSLayoutConstraint?
    var aDotWidthLayoutConstraint: NSLayoutConstraint?
    var aDotHeightLayoutConstraint: NSLayoutConstraint?
    
    var rotationAnimation: CABasicAnimation?

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
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
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
//        box.addSubview(adot) //test
        dot.addSubview(adot) //test
//        adot.backgroundColor = .ddmAccentColor
//        adot.backgroundColor = .lightBlueColor
        adot.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
        adot.tintColor = .ddmDarkColor
        adot.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        adot.layer.cornerRadius = (14)/2
        adot.translatesAutoresizingMaskIntoConstraints = false
        adot.centerXAnchor.constraint(equalTo: dot.centerXAnchor).isActive = true
        adot.centerYAnchor.constraint(equalTo: dot.centerYAnchor).isActive = true
//        adot.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        adot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        aDotWidthLayoutConstraint = adot.widthAnchor.constraint(equalToConstant: 14)
        aDotWidthLayoutConstraint?.isActive = true
        aDotHeightLayoutConstraint = adot.heightAnchor.constraint(equalToConstant: 14)
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

        //test 1 > tap marker itself to trigger click event
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
        
        //test
        createParticles()
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
//            let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
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
                    
                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
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
        self.delegate?.didClickSoundMarker(marker: self, coord: self.coordinateLocation!)
        
        //test > rotate
        if(isRotating) {
            stopRotation()
            
            stopEmitter()
        } else{
            rotateView()
            
            resumeEmitter()
        }
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
            markerRing.layer.cornerRadius = newSize/2

            gifHeightLayoutConstraint?.constant = newSize - newGifGap
            gifWidthLayoutConstraint?.constant = newSize - newGifGap
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
                    markerRing.layer.cornerRadius = newSize/2

                    gifHeightLayoutConstraint?.constant = newSize - newGifGap
                    gifWidthLayoutConstraint?.constant = newSize - newGifGap
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
    
    var isRotating = false
    func rotateView() {
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation?.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation?.duration = 4.0
        rotationAnimation?.repeatCount = .infinity
        rotationAnimation?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        if let rotationAnimation = rotationAnimation {
            gifImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
            isRotating = true
//            dot.isHidden = true
        }
    }
    
    func stopRotation() {
        if let rotationAnimation = rotationAnimation {
            gifImage.layer.removeAnimation(forKey: "rotationAnimation")
            self.rotationAnimation = nil
            isRotating = false
//            dot.isHidden = false
        }
    }

    override func close() {
        self.removeFromSuperview()
    }
    
//    test > emitter for confetti
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
//        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 44, scale: 0.1) //60
        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: -20, scale: 0.2) //test -ve speed 44

//        emitter.emitterCells = [near, middle, far]
        emitter.emitterCells = [far]

        let uView = UIView(frame: CGRect(x: 0 , y: 0, width: 44, height: 44))
        self.addSubview(uView)
//        uView.layer.cornerRadius = 10 //10
        uView.isUserInteractionEnabled = false
//        uView.backgroundColor = .red
        uView.layer.addSublayer(emitter)
        
        emitter.birthRate = 0
    }
    
    func stopEmitter() {
        emitter.birthRate = 0
    }
    
    func resumeEmitter() {
        emitter.birthRate = 1
    }

    //test > new method for snow
    func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 2 //10
        cell.lifetime = 2.0 //1
        cell.lifetimeRange = 0
        cell.velocity = velocity
        cell.velocityRange = velocity / 4
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 8
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.alphaRange = 0.5 // Variation in particle opacity
        cell.alphaSpeed = -0.5 // Opacity decreasing speed over time
//        cell.contents = UIImage(named: "emitter_snow")?.cgImage
        cell.contents = UIImage(named: "icon_round_music")?.cgImage
        return cell
    }

//    func hideInfoBox() {
//        infoBox.isHidden = true
//    }
//
//    func showInfoBox() {
//        infoBox.isHidden = false
//    }
}

extension ViewController: SoundMarkerDelegate{
    
    func didClickSoundMarker(marker: SoundMarker, coord: CLLocationCoordinate2D){
        //test > remove pulsewave when click on marker
        stopPulseWave()
        dequeueObject()
    }
}

//class SoundMarker: Marker {
//
//    var markerRing = UIView()
//    var viewSize: CGFloat = 0
//    var gifImage = SDAnimatedImageView()
////    var coordinateLocation : CLLocationCoordinate2D?
//    let box = UIView()
//
//    //test changing marker size while map-zooming
//    var markerWidthLayoutConstraint: NSLayoutConstraint?
//    var markerHeightLayoutConstraint: NSLayoutConstraint?
//    var gifWidthLayoutConstraint: NSLayoutConstraint?
//    var gifHeightLayoutConstraint: NSLayoutConstraint?
//
//    var ovalWidthLayoutConstraint: NSLayoutConstraint?
//    var ovalHeightLayoutConstraint: NSLayoutConstraint?
//
////    var isOnScreen = false
////    var isInitialized = false
//
//    var ovalBase = OvalView()
//
////    weak var delegate : ExploreMarkerDelegate?
//
//    let dot = UIView()
////    let adot = UIView()
//    let adot = UIImageView()
//    var dotWidthLayoutConstraint: NSLayoutConstraint?
//    var dotHeightLayoutConstraint: NSLayoutConstraint?
//    var aDotWidthLayoutConstraint: NSLayoutConstraint?
//    var aDotHeightLayoutConstraint: NSLayoutConstraint?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        viewSize = frame.width
//        setupViews()
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setupViews()
//    }
//
//    func setupViews() {
////        self.backgroundColor = .blue
//
////        self.addSubview(box)
////        box.translatesAutoresizingMaskIntoConstraints = false
////        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
////        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
////        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
////        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//
////        let ovalBase = OvalView()
//        self.addSubview(ovalBase)
//        ovalBase.translatesAutoresizingMaskIntoConstraints = false
//        ovalWidthLayoutConstraint = ovalBase.widthAnchor.constraint(equalToConstant: 26)
//        ovalWidthLayoutConstraint?.isActive = true
//        ovalHeightLayoutConstraint = ovalBase.heightAnchor.constraint(equalToConstant: 8)
//        ovalHeightLayoutConstraint?.isActive = true
//        ovalBase.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        ovalBase.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true //default: -2
//        ovalBase.layer.opacity = 0.6 //default: 0.2
//
//        self.addSubview(markerRing)
//        markerRing.backgroundColor = .white
//        markerRing.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = (viewSize)/2
//        markerRing.translatesAutoresizingMaskIntoConstraints = false
//        markerRing.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        markerRing.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        markerRing.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        markerRing.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//        //add gif
////        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        guard let imageUrl = imageUrl else {
//            return
//        }
//        let newGifImageSize = viewSize - 6
//        gifImage.contentMode = .scaleAspectFill
//        gifImage.layer.masksToBounds = true
////        gifImage.layer.cornerRadius = (viewSize - 8 - 20)/2 //default: (viewSize - 4 - 20)/2
//        gifImage.layer.cornerRadius = newGifImageSize/2 //test without -20
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.backgroundColor = .ddmDarkGreyColor
////        self.addSubview(gifImage)
//        markerRing.addSubview(gifImage)
//        gifImage.translatesAutoresizingMaskIntoConstraints = false
//        gifImage.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
//        gifImage.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
//        gifImage.isUserInteractionEnabled = true
//        gifHeightLayoutConstraint = gifImage.heightAnchor.constraint(equalToConstant: newGifImageSize)
//        gifHeightLayoutConstraint?.isActive = true
//        gifWidthLayoutConstraint = gifImage.widthAnchor.constraint(equalToConstant: newGifImageSize)
//        gifWidthLayoutConstraint?.isActive = true
//
//        self.addSubview(dot) //test
//        dot.backgroundColor = .white
////        markerRing.backgroundColor = .black
//        dot.layer.masksToBounds = true
////        markerRing.layer.cornerRadius = 10 // for squarish place marker
//        dot.layer.cornerRadius = (16)/2
//        dot.translatesAutoresizingMaskIntoConstraints = false
//        dot.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
////        dot.topAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: -8).isActive = true
//        dot.centerYAnchor.constraint(equalTo: markerRing.bottomAnchor, constant: 0).isActive = true
////        dot.heightAnchor.constraint(equalToConstant: 16).isActive = true
////        dot.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        dotWidthLayoutConstraint = dot.widthAnchor.constraint(equalToConstant: 16)
//        dotWidthLayoutConstraint?.isActive = true
//        dotHeightLayoutConstraint = dot.heightAnchor.constraint(equalToConstant: 16)
//        dotHeightLayoutConstraint?.isActive = true
//
////        let adot = UIView()
//        self.addSubview(adot) //test
////        adot.backgroundColor = .ddmAccentColor
////        adot.backgroundColor = .lightBlueColor
//        adot.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
//        adot.tintColor = .ddmDarkColor
//        adot.layer.masksToBounds = true
////        markerRing.layer.cornerRadius = 10 // for squarish place marker
//        adot.layer.cornerRadius = (14)/2 //10
//        adot.translatesAutoresizingMaskIntoConstraints = false
//        adot.centerXAnchor.constraint(equalTo: dot.centerXAnchor).isActive = true
//        adot.centerYAnchor.constraint(equalTo: dot.centerYAnchor).isActive = true
////        adot.heightAnchor.constraint(equalToConstant: 10).isActive = true
////        adot.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        aDotWidthLayoutConstraint = adot.widthAnchor.constraint(equalToConstant: 14) //10
//        aDotWidthLayoutConstraint?.isActive = true
//        aDotHeightLayoutConstraint = adot.heightAnchor.constraint(equalToConstant: 14)
//        aDotHeightLayoutConstraint?.isActive = true
//
//        //test 1 > tap marker itself to trigger click event
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
//
//        //test > confetti
////        createParticles()
//    }
//
//    override func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
//        changeSize(zoomLevel: changeSizeZoom, duringInitialization: true)
//        initialize(withAnimation: withAnimation)
//    }
//    func initialize(withAnimation: Bool) {
//        //test 2 > fade in when initialized
//        isInitialized = true
////        isOnScreen = true //test
//
//        if(withAnimation) {
//            self.layer.opacity = 0.0
//            self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
//            self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
//            UIView.animate(withDuration: 0.5, delay: 0.2, options: [], //default: 0.5, delay 0.5
//                animations: {
//                    self.layer.opacity = 1.0
//    //                self.transform = CGAffineTransform.identity
//                    self.markerRing.transform = CGAffineTransform.identity //test
//                    self.ovalBase.transform = CGAffineTransform.identity //test
//                },
//                completion: { _ in
//
//                })
//        }
//
//        //test > rotate image
////        rotateView()
//    }
//
//    override func addLocation(coordinate : CLLocationCoordinate2D ) {
//        coordinateLocation = coordinate
//    }
//
//    override func changeLocation(coordinate : CLLocationCoordinate2D ) {
//        coordinateLocation = coordinate
//    }
//
//    @objc func onMarkerClicked(gesture: UITapGestureRecognizer) {
//        print("onmarkerclicked: \(self.frame.size.height)")
//
//        //test > async action
////        self.delegate?.didStartClickExploreMarker(marker: self)
//        self.delegate?.didClickSoundMarker(marker: self, coord: self.coordinateLocation!)
//
//        //test > rotate image indefinitely
//        rotateView()
//    }
//
//    override func disappear() {
//
//        //test
//        UIView.animate(withDuration: 0.2,
//            animations: {
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.layer.opacity = 0.0
//
//                //test
//                self.superview?.layoutIfNeeded()
//            },
//            completion: { _ in
//
//            })
//    }
//
//    override func reappear() {
//        //test
//        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], //default delay 0.5
//            animations: {
//                self.markerRing.transform = CGAffineTransform.identity
//                self.ovalBase.transform = CGAffineTransform.identity
//                self.layer.opacity = 1.0
//
//                //test
//                self.superview?.layoutIfNeeded()
//            },
//            completion: { _ in
//
//            })
//    }
//
//
//    override func changeOnScreen(withAnimation: Bool) {
//        isOnScreen = true
//        popIn(withAnimation: withAnimation)
//    }
//
//    override func changeOffScreen(withAnimation: Bool) {
//        isOnScreen = false
//        fadeOut(withAnimation: withAnimation)
//    }
//
//    override func changeInitializeOn(withAnimation: Bool) {
//        isInitialized = true
//        popIn(withAnimation: withAnimation)
//    }
//
//    override func changeInitializeOff(withAnimation: Bool) {
//        isInitialized = false
//        popOut(withAnimation: withAnimation)
//    }
//
//    override func animateFromVideoClose() {
//        //test 1 > shutter method
//        shutter()
//
//        //test 2 > gif image change opacity
////        self.gifImage.layer.opacity = 1.0
//
//        //test 3 > shutter gif image
////        shutterGifImage()
//    }
//
//    //test > hide marker
//    override func hideForShutter() {
//        //test 1 > shutter method
//        self.layer.opacity = 0.0
//
//        //test 2 > gif image change opacity
////        self.gifImage.layer.opacity = 0.2
//    }
//    override func dehideForShutter() {
//        //test 1 > shutter method
//        self.layer.opacity = 1.0
//
//        //test 2 > gif image change opacity
////        self.gifImage.layer.opacity = 0.2
//    }
//
//    //test > marker animation when map padding change
//    func shutter() {
//        UIView.animate(withDuration: 0.1,
//            animations: {
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.layer.opacity = 0.0
//            },
//            completion: { _ in
//                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], //test 0.3 delay
//                    animations: {
//                        self.markerRing.transform = CGAffineTransform.identity
//                        self.ovalBase.transform = CGAffineTransform.identity
//                        self.layer.opacity = 1.0
//                    },
//                    completion: { _ in
//                    })
//            })
//    }
//
//    //test > marker fade out of map
//    func fadeOut(withAnimation: Bool) {
//        if(withAnimation) {
//            UIView.animate(withDuration: 1.0, delay: 0.2, options: [],
//                animations: {
//                    self.layer.opacity = 0.0
//                },
//                completion: { _ in
//    //                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//                })
//        } else {
//            self.layer.opacity = 0.0
//        }
//    }
//
//    func popOut(withAnimation: Bool) {
//        if(withAnimation) {
//            UIView.animate(withDuration: 0.6, delay: 0.2, options: [], //default 0.6, delay 0.2
//                animations: {
//                    self.layer.opacity = 0.0
//    //                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)//test
//                },
//                completion: { _ in
//                })
//        } else {
//            self.layer.opacity = 0.0
//        }
//    }
//
//    func popIn(withAnimation: Bool) {
//
//        if(withAnimation) {
//            let randomInt = Int.random(in: 1..<5) //default: 1...4
//            let randomDelay: Double = Double(randomInt)/Double(10)
//            print("popIn: \(randomDelay)")
//
//    //        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//            self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
//            self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
//
//            UIView.animate(withDuration: 0.5, delay: randomDelay, options: [], //default 0.3
//                animations: {
//                    self.layer.opacity = 1.0
//    //                self.transform = CGAffineTransform.identity
//                    self.markerRing.transform = CGAffineTransform.identity //test
//                    self.ovalBase.transform = CGAffineTransform.identity //test
//                },
//                completion: { _ in
//
//                })
//        } else {
//            self.layer.opacity = 1.0
//            self.markerRing.transform = CGAffineTransform.identity //test
//            self.ovalBase.transform = CGAffineTransform.identity //test
//        }
//    }
//
//    func changeOpacity(zoomLevel: CGFloat) {
//        //test > using zoom level
//        var newOpacity = 1.0
//        if(zoomLevel >= 8) {
//            newOpacity = 1 + ((0.0 - 1)/(20 - 8) * (zoomLevel - 8))
//        } else {
//            newOpacity = 1
//        }
//        self.layer.opacity = Float(newOpacity)
//    }
//
//    override func changeSize(zoomLevel: CGFloat) {
//        changeSize(zoomLevel: zoomLevel, duringInitialization: false)
//    }
//
//    //test > generate random initial size for marker
//    func generateRandomSize() -> Int{
//        return Int.random(in: 24..<50)
//    }
//
//    //test > varying initial size instead of fixed size
////    var minMarkerWidth: CGFloat = 44 //44
//    var minMarkerWidth: CGFloat = 0 //44
//    var maxMarkerWidth: CGFloat = 110
//    var minGifGap: CGFloat = 6.0
//    var maxGifGap: CGFloat = 14.0
//    var minOvalWidth: CGFloat = 26
//    var maxOvalWidth: CGFloat = 50
//    var minOvalHeight: CGFloat = 8
//    var maxOvalHeight: CGFloat = 16
//    func changeSize(zoomLevel: CGFloat, duringInitialization: Bool) {
//
//        //test > initialize random size if not already
//        if(minMarkerWidth == 0) {
////            minMarkerWidth = CGFloat(generateRandomSize())
//            minMarkerWidth = 44
//        }
//        //test > varying marker size
//        var newSize = minMarkerWidth //default 40
//        var newGifGap = minGifGap //default 8
//        var newOvalWidthSize = minOvalWidth
//        var newOvalHeightSize = minOvalHeight
//        if(zoomLevel >= 8) {
//            newSize = minMarkerWidth + ((maxMarkerWidth - minMarkerWidth)/(20 - 8) * (zoomLevel - 8))
//            newGifGap = minGifGap + ((maxGifGap - minGifGap)/(20 - 8) * (zoomLevel - 8))
//            newOvalWidthSize = minOvalWidth + ((maxOvalWidth - minOvalWidth)/(20 - 8) * (zoomLevel - 8))
//            newOvalHeightSize = minOvalHeight + ((maxOvalHeight - minOvalHeight)/(20 - 8) * (zoomLevel - 8))
//        } else {
//            newSize = minMarkerWidth
//            newGifGap = minGifGap
//            newOvalWidthSize = minOvalWidth
//            newOvalHeightSize = minOvalHeight
//        }
//
//        //test > with condition of "isinitialized"
//        if(duringInitialization) {
//            self.frame.size.height = newSize
//            self.frame.size.width = newSize
//            markerRing.layer.cornerRadius = newSize/2
//
//            gifHeightLayoutConstraint?.constant = newSize - newGifGap
//            gifWidthLayoutConstraint?.constant = newSize - newGifGap
//            gifImage.layer.cornerRadius = (newSize - newGifGap)/2
//
//            ovalWidthLayoutConstraint?.constant = newOvalWidthSize
//            ovalHeightLayoutConstraint?.constant = newOvalHeightSize
//        } else {
//            if(isInitialized) {
//                if(isOnScreen) {
//                    self.frame.size.height = newSize
//                    self.frame.size.width = newSize
//                    markerRing.layer.cornerRadius = newSize/2
//
//                    gifHeightLayoutConstraint?.constant = newSize - newGifGap
//                    gifWidthLayoutConstraint?.constant = newSize - newGifGap
//                    gifImage.layer.cornerRadius = (newSize - newGifGap)/2
//
//                    ovalWidthLayoutConstraint?.constant = newOvalWidthSize
//                    ovalHeightLayoutConstraint?.constant = newOvalHeightSize
//                }
//            }
//        }
//    }
//
//    //test > remove markers from map
//    override func close() {
//        self.removeFromSuperview()
//    }
//
//    func rotateView() {
//        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation.toValue = NSNumber(value: Double.pi * 2.0)
//        animation.duration = 4.0
//        animation.repeatCount = .infinity
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//
//        gifImage.layer.add(animation, forKey: "rotationAnimation")
//    }
//
//    //test > emitter for confetti
////    let emitter = CAEmitterLayer()
////    func createParticles() {
////
////        //test > new method for snow
//////        let emitter = CAEmitterLayer()
//////        emitter.masksToBounds = true //problem**
////        emitter.emitterShape = .line
////        emitter.emitterPosition = CGPoint(x: 22, y: 0)
////        emitter.emitterSize = CGSize(width: 44, height: 1)
////
////        let near = makeEmmiterCell(color: UIColor(white: 1, alpha: 1), velocity: 44, scale: 0.3) //100
////        let middle = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.66), velocity: 44, scale: 0.2) //80
////        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 44, scale: 0.1) //60
////
////        emitter.emitterCells = [near, middle, far]
////
////        let uView = UIView(frame: CGRect(x: 0 , y: 0, width: 44, height: 44))
////        self.addSubview(uView)
//////        uView.layer.cornerRadius = 10 //10
////        uView.isUserInteractionEnabled = false
////        uView.layer.addSublayer(emitter)
////    }
////
////    //test > new method for snow
////    func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
////        let cell = CAEmitterCell()
////        cell.birthRate = 10
////        cell.lifetime = 1.0 //20
////        cell.lifetimeRange = 0
////        cell.velocity = velocity
////        cell.velocityRange = velocity / 4
////        cell.emissionLongitude = .pi
////        cell.emissionRange = .pi / 8
////        cell.scale = scale
////        cell.scaleRange = scale / 3
////        cell.contents = UIImage(named: "emitter_snow")?.cgImage
////        return cell
////    }
//}
