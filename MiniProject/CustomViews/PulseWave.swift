//
//  PulseWave.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import GoogleMaps
import UIKit
import SDWebImage

protocol PulseWaveDelegate : AnyObject {
    func didOneCycle(coord: CLLocationCoordinate2D)
}
class PulseWave: QueueableView {

    let mDuration: CGFloat = 0.8 //1.5 original, then 0.8
    var coordinateLocation : CLLocationCoordinate2D?
    let numberOfPulse = 2 //ori 4
    
    var viewSize: CGFloat = 0
    var pulseWaveViews = [UIView]()
    
    let box = UIView()
    
    weak var delegate : PulseWaveDelegate?
    
    //test > fake view for animation time delay before starting next pulsewave cycle
    let fakeDelayBox = UIView()
    var isNoResult = false
    var bCount = 0 // number of pulsewave cycles
    var isStopPulse = false
    
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
        self.addSubview(fakeDelayBox)
//        fakeDelayBox.backgroundColor = .red
        fakeDelayBox.translatesAutoresizingMaskIntoConstraints = false
        fakeDelayBox.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        fakeDelayBox.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        fakeDelayBox.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        fakeDelayBox.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        fakeDelayBox.layer.opacity = 0
        
        self.addSubview(box)
//        box.backgroundColor = .blue
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        for number in 0...numberOfPulse {

            let rippleView = UIView()
            box.addSubview(rippleView)
            rippleView.translatesAutoresizingMaskIntoConstraints = false
            rippleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            rippleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            rippleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            rippleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//            rippleView.layer.cornerRadius = rippleView.frame.size.width / 2
            rippleView.layer.cornerRadius = self.frame.size.width / 2
            rippleView.clipsToBounds = true
            rippleView.backgroundColor = .white
//            rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) //default: 0.08, 0.08
//            rippleView.layer.opacity = 0.3 //default: 0.4

            pulseWaveViews.append(rippleView)

        }
    }
    func initialize(withAnimation: Bool, changeSizeZoom: CGFloat) {
        changeSize(zoomLevel: changeSizeZoom)
        startPulsating()
    }
    

    func startPulsating() {
        var count = 0

        for number in 0...numberOfPulse {
            let delay: CGFloat = CGFloat(number) * mDuration / CGFloat(numberOfPulse + 4)//test

//            self.pulseWaveViews[number].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)//0.5
//            self.pulseWaveViews[number].layer.opacity = 0.3 //default: 0.4
            //new scale > more like snapmap
            self.pulseWaveViews[number].transform = CGAffineTransform(scaleX: 0.01, y: 0.01)//0.5
            self.pulseWaveViews[number].layer.opacity = 0.6 //default: 0.4
            
            UIView.animate(withDuration: mDuration, delay: delay, options: [.curveEaseOut],animations: {

                //test
                self.pulseWaveViews[number].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.pulseWaveViews[number].layer.opacity = 0.0

            }, completion:{ finished in
                count += 1
                
                if(count == self.numberOfPulse + 1) {
                    //test
                    self.fakeDelayBox.layer.opacity = 1
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: [],
                        animations: {
                            self.fakeDelayBox.layer.opacity = 0
                        },
                        completion: { _ in
                            self.bCount += 1
                            if(!self.isStopPulse) {
                                if(self.bCount < 2) { //max 3 repeat cycles for timeout
                                    self.startPulsating()
                                } else if(self.bCount == 2) {
                                    self.startPulsating()
                                    self.stopPulsatingWithAnimation(duration: 0.2, delay: 0.6)//to be randomized delay
                                } else {
                                    //test > self shrinking when timeout
                                    self.stopPulsatingWithAnimation(duration: 0.2, delay: 0.2)//to be randomized delay
                                }
                            }
                        })
                }

                print("pulse no. count \(count)")

            })
        }
    }
    
    func addLocation(coordinate : CLLocationCoordinate2D ) {
        coordinateLocation = coordinate
    }

    func close() {
        //test 1 > remove animations
        isStopPulse = true
        
        for number in 0...numberOfPulse {
            self.pulseWaveViews[number].layer.removeAllAnimations()
        }
        self.layer.removeAllAnimations()
        self.layoutIfNeeded()

        self.removeFromSuperview()
    }
    
    func stopPulsatingWithAnimation(duration:CGFloat, delay: CGFloat) {
        //test 1 > remove animations
        isStopPulse = true
        
        //test 2 > animate shrinking/disappearing pulsewave
        if(!isNoResult) { //isNoResult is to prevent trigger animation continuously
            let randomInt = Int.random(in: 2..<7)
            let aScale : CGFloat =  CGFloat(randomInt)/CGFloat(10)
            UIView.animate(withDuration:duration, delay: delay, options: [],
                animations: {
                    self.transform = CGAffineTransform(scaleX: aScale, y: aScale)
                },
                completion: { _ in
                    self.removeFromSuperview()
                })
        }
        isNoResult = true
    }
    
    func changeSize(zoomLevel: CGFloat) {
        
        //test > using zoom level
        var newSize = 110.0
        if(zoomLevel >= 8) {
            newSize = 110 + ((170 - 110)/(20 - 8) * (zoomLevel - 8))
        } else {
            newSize = 110
        }
        
        print("changesize : \(zoomLevel)")
        
        self.frame.size.height = newSize
        self.frame.size.width = newSize
//        self.widthOriginOffset = newSize //will not be executed as map remove pulsewave when moved
        
        for entry in pulseWaveViews {
            entry.layer.cornerRadius = newSize/2
        }
        
    }
    
    func disappear() {
        UIView.animate(withDuration: 0.2,
            animations: {
//                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //default: 0.0
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.layer.opacity = 0.0
            },
            completion: { _ in

            })
    }
    
    func reappear() {
        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], //default delay 0.5
            animations: {
//                self.transform = CGAffineTransform.identity
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
                self.box.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) //test
                self.layer.opacity = 0.0
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.5, options: [], //test 0.3 delay
                    animations: {
//                        self.transform = CGAffineTransform.identity
                        self.box.transform = CGAffineTransform.identity //test
                        self.layer.opacity = 1.0
                    },
                    completion: { _ in
                    })
            })
    }
}


//test > pulsewave to initiate videopanel
extension ViewController: PulseWaveDelegate{
    func didOneCycle(coord: CLLocationCoordinate2D) {
        print("pulsewavedelegate didclick:")
    }
}

//conventional pulsewave
//class PulseWave: UIView {
//
//    let mDuration: CGFloat = 1.5 //1.5 original
//    var coordinateLocation : CLLocationCoordinate2D?
//    let numberOfPulse = 4 //ori 4
//
//    var viewSize: CGFloat = 0
//    var pulseWaveViews = [UIView]()
//
//    let box = UIView()
//
//    weak var delegate : PulseWaveDelegate?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        viewSize = frame.width
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setupViews()
//    }
//
//    func setupViews() {
//        self.addSubview(box)
//        box.translatesAutoresizingMaskIntoConstraints = false
//        box.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        box.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//
//        for number in 0...numberOfPulse {
//
//            let rippleView = UIView()
//            box.addSubview(rippleView)
//            rippleView.translatesAutoresizingMaskIntoConstraints = false
//            rippleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//            rippleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//            rippleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//            rippleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
////            rippleView.layer.cornerRadius = rippleView.frame.size.width / 2
//            rippleView.layer.cornerRadius = self.frame.size.width / 2
//            rippleView.clipsToBounds = true
//            rippleView.backgroundColor = .white
//            rippleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1) //default: 0.08, 0.08
//            rippleView.layer.opacity = 0.4 //default: 0.4
//
//            pulseWaveViews.append(rippleView)
//
//        }
//    }
//
//    func startPulsating() {
//        var count = 0
//        for number in 0...numberOfPulse {
//            let delay: CGFloat = CGFloat(number) * mDuration / CGFloat(numberOfPulse)
//
//            UIView.animate(withDuration: mDuration, delay: delay, options: [.repeat],animations: {
////                rippleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
////                rippleView.layer.opacity = 0.0
//                //test
//                self.pulseWaveViews[number].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                self.pulseWaveViews[number].layer.opacity = 0.0
//
//            }, completion:{ finished in
//                count += 1
//
//                if(count == self.numberOfPulse) {
//                    self.delegate?.didOneCycle(coord: self.coordinateLocation!)
//                }
//            })
//        }
//    }
//}
