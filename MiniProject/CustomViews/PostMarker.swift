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

//protocol UserMarkerDelegate : AnyObject {
protocol PostMarkerDelegate : MarkerDelegate {
//    func didClickUserMarker(marker: UserMarker, coord: CLLocationCoordinate2D)
}
class PostMarker: ExploreMarker {
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
    
    var infoBox = UIView()
    let aMiniText = UILabel()
    var infoBoxWidthLayoutConstraint: NSLayoutConstraint?
    var infoBoxHeightLayoutConstraint: NSLayoutConstraint?
    var aMiniTextLeadingLayoutConstraint: NSLayoutConstraint?
    var aMiniTextTrailingLayoutConstraint: NSLayoutConstraint?
    var aMiniTextTopLayoutConstraint: NSLayoutConstraint?
    var aMiniTextBottomLayoutConstraint: NSLayoutConstraint?
//    weak var delegate : ExploreMarkerDelegate?
    
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
//        self.backgroundColor = .blue
        
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
        
        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
//        self.addSubview(markerRing)
        box.addSubview(markerRing)
        markerRing.backgroundColor = .white
        markerRing.layer.masksToBounds = true
        markerRing.layer.cornerRadius = (viewSize)/2
        markerRing.translatesAutoresizingMaskIntoConstraints = false
        markerRing.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        markerRing.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        markerRing.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        markerRing.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        markerHeightLayoutConstraint = markerRing.heightAnchor.constraint(equalToConstant: viewSize)
        markerHeightLayoutConstraint?.isActive = true
        markerWidthLayoutConstraint = markerRing.widthAnchor.constraint(equalToConstant: viewSize)
        markerWidthLayoutConstraint?.isActive = true
        //test > shadow
        markerRing.layer.shadowColor = UIColor.ddmDarkColor.cgColor
        markerRing.layer.shadowRadius = 3.0  //ori 3
        markerRing.layer.shadowOpacity = 1.0 //ori 1
        markerRing.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
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
//        guard let imageUrl = imageUrl else {
//            return
//        }
        let newGifImageSize = viewSize - 6
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
//        gifImage.layer.cornerRadius = (viewSize - 8 - 20)/2 //default: (viewSize - 4 - 20)/2
        gifImage.layer.cornerRadius = newGifImageSize/2 //test without -20
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.backgroundColor = .ddmDarkGreyColor
        gifImage.backgroundColor = .ddmDarkColor
//        self.addSubview(gifImage)
        markerRing.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        gifImage.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor).isActive = true
        gifImage.isUserInteractionEnabled = true
//        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
//        gifImage.heightAnchor.constraint(equalToConstant: viewSize - 8 - 20).isActive = true
//        gifImage.widthAnchor.constraint(equalToConstant: viewSize - 8 - 20).isActive = true
//        gifHeightLayoutConstraint = gifImage.heightAnchor.constraint(equalToConstant: viewSize - 8 - 20)
        gifHeightLayoutConstraint = gifImage.heightAnchor.constraint(equalToConstant: newGifImageSize)
        gifHeightLayoutConstraint?.isActive = true
//        gifWidthLayoutConstraint = gifImage.widthAnchor.constraint(equalToConstant: viewSize - 8 - 20)
        gifWidthLayoutConstraint = gifImage.widthAnchor.constraint(equalToConstant: newGifImageSize)
        gifWidthLayoutConstraint?.isActive = true
        
//        self.insertSubview(infoBox, belowSubview: markerRing)
        box.insertSubview(infoBox, belowSubview: markerRing)
        infoBox.backgroundColor = .white
        infoBox.layer.masksToBounds = true
//        markerRing.layer.cornerRadius = 10 // for squarish place marker
        infoBox.layer.cornerRadius = 5
        infoBox.translatesAutoresizingMaskIntoConstraints = false
        infoBox.leadingAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        infoBox.centerYAnchor.constraint(equalTo: markerRing.centerYAnchor, constant: 0).isActive = true
        //test > width and height
        let infoWidth = viewSize * 2 //-10, max
//        let infoHeight = (viewSize - 10)/2 //max
        let infoHeight = viewSize - minInfoHeightGap
//        infoBox.widthAnchor.constraint(equalToConstant: infoWidth).isActive = true
//        infoBox.heightAnchor.constraint(equalToConstant: infoHeight).isActive = true //15
        infoBoxWidthLayoutConstraint = infoBox.widthAnchor.constraint(equalToConstant: infoWidth)
        infoBoxWidthLayoutConstraint?.isActive = true
        infoBoxHeightLayoutConstraint = infoBox.heightAnchor.constraint(equalToConstant: infoHeight)
        infoBoxHeightLayoutConstraint?.isActive = true
        infoBox.layer.opacity = 0.9
        
        let textLeadingMargin = viewSize/2 + minInfoTextGap
//        let aMiniText = UILabel()
        aMiniText.textAlignment = .left //center
        aMiniText.textColor = .ddmBlackOverlayColor
        aMiniText.font = .boldSystemFont(ofSize: 10) //11
        infoBox.addSubview(aMiniText)
        aMiniText.translatesAutoresizingMaskIntoConstraints = false
//        aMiniText.centerYAnchor.constraint(equalTo: infoBox.centerYAnchor).isActive = true
//        aMiniText.leadingAnchor.constraint(equalTo: infoBox.leadingAnchor, constant: textLeadingMargin).isActive = true //5
        aMiniTextLeadingLayoutConstraint = aMiniText.leadingAnchor.constraint(equalTo: infoBox.leadingAnchor, constant: textLeadingMargin)
        aMiniTextLeadingLayoutConstraint?.isActive = true
//        aMiniText.trailingAnchor.constraint(equalTo: infoBox.trailingAnchor, constant: -2).isActive = true //-5
        aMiniTextTrailingLayoutConstraint = aMiniText.trailingAnchor.constraint(equalTo: infoBox.trailingAnchor, constant: -2)
        aMiniTextTrailingLayoutConstraint?.isActive = true
        aMiniText.numberOfLines = 0
//        aMiniText.topAnchor.constraint(equalTo: infoBox.topAnchor, constant: 2).isActive = true
        aMiniTextTopLayoutConstraint = aMiniText.topAnchor.constraint(equalTo: infoBox.topAnchor, constant: 2)
        aMiniTextTopLayoutConstraint?.isActive = true
//        aMiniText.bottomAnchor.constraint(equalTo: infoBox.bottomAnchor, constant: -2).isActive = true
        aMiniTextBottomLayoutConstraint = aMiniText.bottomAnchor.constraint(equalTo: infoBox.bottomAnchor, constant: -2)
        aMiniTextBottomLayoutConstraint?.isActive = true
        
//        let ovalBase = OvalView()
//        self.addSubview(ovalBase)
        self.insertSubview(ovalBase, belowSubview: box)
        ovalBase.translatesAutoresizingMaskIntoConstraints = false
        ovalWidthLayoutConstraint = ovalBase.widthAnchor.constraint(equalToConstant: 26)
        ovalWidthLayoutConstraint?.isActive = true
        ovalHeightLayoutConstraint = ovalBase.heightAnchor.constraint(equalToConstant: 8)
        ovalHeightLayoutConstraint?.isActive = true
        ovalBase.centerXAnchor.constraint(equalTo: markerRing.centerXAnchor).isActive = true
        ovalBase.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true //default: -2
        ovalBase.layer.opacity = 0.6 //default: 0.2
        
        //test 1 > tap marker itself to trigger click event
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarkerClicked)))
    
        //test > confetti
//        createParticles()
    }
    
    var screenWidth = 0.0
    override func setScreenSizeLimit(width: CGFloat, height: CGFloat) {
        screenWidth = width
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
//            self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [], //default: 0.5, delay 0.5
                animations: {
                    self.layer.opacity = 1.0
    //                self.transform = CGAffineTransform.identity
//                    self.markerRing.transform = CGAffineTransform.identity //test
                    self.box.transform = CGAffineTransform.identity //test
                    self.ovalBase.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        }
    }
    
    var infoText = ""
    override func configure(data: String) {
        if(data == "a") {
            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
            guard let imageUrl = imageUrl else {
                return
            }
            self.gifImage.sd_setImage(with: imageUrl)
        }
        
//    let infoText = "馬斯克"
//    let infoText = "Good"
//    let infoText = "Nice food, nice environment! Worth a visit"
//    let infoText = "往年的这个时候，iPhone 虽然也是位列销量榜榜首"
        infoText = "馬斯克"
        aMiniText.text = infoText
        
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
//                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
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
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) //test
                self.box.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) //test
                self.ovalBase.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) //test
            },
            completion: { _ in
            
            UIView.animate(withDuration: 0.2, //default 0.2
                    animations: {
//                        self.transform = CGAffineTransform.identity
//                        self.markerRing.transform = CGAffineTransform.identity //test
                        self.box.transform = CGAffineTransform.identity //test
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
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
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
//                self.markerRing.transform = CGAffineTransform.identity
                self.box.transform = CGAffineTransform.identity
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
//                self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.layer.opacity = 0.0
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], //test 0.3 delay
                    animations: {
//                        self.markerRing.transform = CGAffineTransform.identity
                        self.box.transform = CGAffineTransform.identity
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
            
//            self.markerRing.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
            self.ovalBase.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test

            UIView.animate(withDuration: 0.5, delay: randomDelay, options: [], //default 0.3
                animations: {
                    self.layer.opacity = 1.0
//                    self.markerRing.transform = CGAffineTransform.identity //test
                    self.box.transform = CGAffineTransform.identity //test
                    self.ovalBase.transform = CGAffineTransform.identity //test
                },
                completion: { _ in

                })
        } else {
            self.layer.opacity = 1.0
//            self.markerRing.transform = CGAffineTransform.identity //test
            self.box.transform = CGAffineTransform.identity //test
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
    
    private func estimateSize(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGRect {
        if(text == "") {
//            return 0
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        } else {
            let size = CGSize(width: textWidth, height: 1000)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            print("postmarker text size: \(estimatedFrame)")
//            return estimatedFrame.height
            return estimatedFrame
        }
    }
    
    //test > varying initial size instead of fixed size
//    var minMarkerWidth: CGFloat = 44 //44
    var minMarkerWidth: CGFloat = 0 //44
    var maxMarkerWidth: CGFloat = 110
    var minGifGap: CGFloat = 6.0
    var maxGifGap: CGFloat = 14.0
    var minOvalWidth: CGFloat = 26
    var maxOvalWidth: CGFloat = 50
    var minOvalHeight: CGFloat = 8
    var maxOvalHeight: CGFloat = 16
    var minInfoHeightGap: CGFloat = 10.0 //1:2 ratio
    var maxInfoHeightGap: CGFloat = 20.0
    var minInfoTextGap: CGFloat = 2.0
    var maxInfoTextGap: CGFloat = 4.0
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
        //test > new info box size
        var newInfoHeightGap = minInfoHeightGap
        var newInfoWidth = newSize * 2 //max width
        var newInfoHeight = newSize - minInfoHeightGap //max height
        var newInfoTextGap = minInfoHeightGap
        var newTextLeadingMargin = newSize/2 + minInfoTextGap
        let maxInfoWidthLimit = screenWidth/2 - minMarkerWidth
        if(zoomLevel >= 8) {
            newSize = minMarkerWidth + ((maxMarkerWidth - minMarkerWidth)/(20 - 8) * (zoomLevel - 8))
            newGifGap = minGifGap + ((maxGifGap - minGifGap)/(20 - 8) * (zoomLevel - 8))
            newOvalWidthSize = minOvalWidth + ((maxOvalWidth - minOvalWidth)/(20 - 8) * (zoomLevel - 8))
            newOvalHeightSize = minOvalHeight + ((maxOvalHeight - minOvalHeight)/(20 - 8) * (zoomLevel - 8))
            newInfoHeightGap = minInfoHeightGap + ((maxInfoHeightGap - minInfoHeightGap)/(20 - 8) * (zoomLevel - 8))
            newInfoHeight = newSize - newInfoHeightGap
            newInfoWidth = newSize * 2 //standard
            if(newInfoWidth >= maxInfoWidthLimit) {
                newInfoWidth = maxInfoWidthLimit
            }
            newInfoTextGap = minInfoTextGap + ((maxInfoTextGap - minInfoTextGap)/(20 - 8) * (zoomLevel - 8))
            newTextLeadingMargin = newSize/2 + newInfoTextGap
            
            //test > check text size
            let newInfoTextAvailWidth = newInfoWidth - newTextLeadingMargin - newInfoTextGap
            let textSize = estimateSize(text: infoText, textWidth: newInfoTextAvailWidth, fontSize: 11)
            if(textSize.height > 0 && textSize.width > 0) {
                let occupiedTextInfoH = textSize.height + newInfoTextGap * 2 //top and bottom margin
                let occupiedTextInfoW = textSize.width + newTextLeadingMargin + newInfoTextGap
                newInfoWidth = occupiedTextInfoW
                if(occupiedTextInfoH <= newInfoHeight) {
                    newInfoHeight = occupiedTextInfoH
                }
            } else {
                newInfoWidth = 0.0
                newInfoHeight = 0.0
            }
        } else {
            newSize = minMarkerWidth
            newGifGap = minGifGap
            newOvalWidthSize = minOvalWidth
            newOvalHeightSize = minOvalHeight
            newInfoHeight = newSize - minInfoHeightGap
            newInfoWidth = newSize * 2
            if(newInfoWidth >= maxInfoWidthLimit) {
                newInfoWidth = maxInfoWidthLimit
            }
            newInfoTextGap = minInfoTextGap
            newTextLeadingMargin = newSize/2 + newInfoTextGap
            
            //test > check text size
            let newInfoTextAvailWidth = newInfoWidth - newTextLeadingMargin - newInfoTextGap
            let textSize = estimateSize(text: infoText, textWidth: newInfoTextAvailWidth, fontSize: 11)
            if(textSize.height > 0 && textSize.width > 0) {
                let occupiedTextInfoH = textSize.height + newInfoTextGap * 2 //top and bottom margin
                let occupiedTextInfoW = textSize.width + newTextLeadingMargin + newInfoTextGap
                newInfoWidth = occupiedTextInfoW
                if(occupiedTextInfoH <= newInfoHeight) {
                    newInfoHeight = occupiedTextInfoH
                }
            } else {
                newInfoWidth = 0.0
                newInfoHeight = 0.0
            }
        }
        
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
            
            //test
            infoBoxWidthLayoutConstraint?.constant = newInfoWidth
            infoBoxHeightLayoutConstraint?.constant = newInfoHeight
            aMiniTextLeadingLayoutConstraint?.constant = newTextLeadingMargin
            aMiniTextTrailingLayoutConstraint?.constant = -newInfoTextGap //test
            aMiniTextTopLayoutConstraint?.constant = newInfoTextGap //test
            aMiniTextBottomLayoutConstraint?.constant = -newInfoTextGap //test
            
            self.frame.size.height = newSize
            if(newInfoWidth > 0) {
                self.frame.size.width = newSize/2 + newInfoWidth
            } else {
                self.frame.size.width = newSize
            }
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
                    
                    //test
                    infoBoxWidthLayoutConstraint?.constant = newInfoWidth
                    infoBoxHeightLayoutConstraint?.constant = newInfoHeight
                    aMiniTextLeadingLayoutConstraint?.constant = newTextLeadingMargin
                    aMiniTextTrailingLayoutConstraint?.constant = -newInfoTextGap //test
                    aMiniTextTopLayoutConstraint?.constant = newInfoTextGap //test
                    aMiniTextBottomLayoutConstraint?.constant = -newInfoTextGap //test
                    
                    self.frame.size.height = newSize
                    if(newInfoWidth > 0) {
                        self.frame.size.width = newSize/2 + newInfoWidth
                    } else {
                        self.frame.size.width = newSize
                    }
                    self.widthOriginOffset = newSize //test => adjust origin for map projection
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

