//
//  PhotoZoomPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PhotoZoomPanelDelegate : AnyObject {
    func didStartOpenPhotoZoomPanel()
    func didFinishOpenPhotoZoomPanel()
    func didStartClosePhotoZoomPanel(ppv : PhotoZoomPanelView)
    func didFinishClosePhotoZoomPanel(ppv : PhotoZoomPanelView)

    //test > for marker animation after video closes
    func didStartPhotoZoomPanGesture(ppv : PhotoZoomPanelView)
    func didEndPhotoZoomPanGesture(ppv : PhotoZoomPanelView)
}
class PhotoZoomPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var panel = UIView()
//    var vcDataList = [String]()

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aStickyHeader = UIView()

    //test > circle mask
    var cView = UIView()

    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0
    
    var panelTopCons: NSLayoutConstraint?
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    var currentPanelLeadingCons : CGFloat = 0.0
    
    weak var delegate : PhotoZoomPanelDelegate?
    
    let gifImage1 = SDAnimatedImageView()
    var predeterminedDatasets = [String]()
    
    let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        viewWidth = frame.width
        viewHeight = frame.height
        setupViews()
        setupMaskLayer()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
        setupMaskLayer()
    }
    
    //test > masking into a circle like in snapmap
    let shapeLayer = CAShapeLayer()
    var isSubLayerSet = false
    func setupMaskLayer(){
//        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        panel.layer.addSublayer(shapeLayer)

        panel.layer.mask = shapeLayer
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        print("circle mask layout sublayer")

        //isSubLayerSet is to prevent repeated calling of layoutSublayers()
        if(!isSubLayerSet) {
            let width = viewWidth
            let height = viewHeight + 100
    //        let height = 200.0

            let oriX = width/2 - height/2 //default 200
    //        let oriY = height/2 - height/2
            let oriY = viewHeight/2 - height/2
            let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
            shapeLayer.path = circlePath.cgPath

            isSubLayerSet = true
        }
    }
    
    func setupViews() {

        cView.backgroundColor = .black
        self.addSubview(cView)
        cView.layer.opacity = 0.0
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true //default 0
        cView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.layer.masksToBounds = true
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        panelTopCons?.isActive = true
        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        panelLeadingCons?.isActive = true
        
//        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: panel.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true //0
//                scrollView.trailingAnchor.constraint(equalTo: aTest.trailingAnchor, constant: -20).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        scrollView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.alwaysBounceHorizontal = true
//        scrollView.contentSize = CGSize(width: 740, height: 280) //800, 280
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
//        let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
//        let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage1.contentMode = .scaleAspectFit
        gifImage1.clipsToBounds = true
//        gifImage1.sd_setImage(with: gifUrl)
        scrollView.addSubview(gifImage1)
        gifImage1.translatesAutoresizingMaskIntoConstraints = false
        gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
        gifImage1.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //280
        gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        
        let vPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
//        vPanelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        
        self.addGestureRecognizer(vPanelPanGesture)
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (gestureRecognizer is UIPanGestureRecognizer) {
//            return true
////            return false
//        } else {
//            return false
//        }
//    }
    
    var direction = "na"
    //test > another variable for threshold to shrink postpanel, instead of normal scroll
    var isToPostPan = false
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
                    
            //test
            currentPanelTopCons = panelTopCons!.constant
            currentPanelLeadingCons = panelLeadingCons!.constant

            //test
            self.delegate?.didStartPhotoZoomPanGesture(ppv: self)

        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)

            //test > determine direction of scroll
            if(direction == "na") {
                if(abs(x) > abs(y)) {
                    direction = "x"
                } else {
                    direction = "y"
                }
            }
            print("photozoom \(direction), \(x), \(y)")
            //test 1 > use x
//            if(direction == "x") {
//                if(abs(x) > 40) {
////                        if(x > 40) {
//                    print("postpanel vcv panning exit")
////                    if(!isCarouselScrolled) {
//                        isToPostPan = true
////                    }
//                } else {
//                    print("postpanel vcv panning no exit")
//                }
//            }
            
            //test 2 > use y
            if(direction == "y") {
                if(abs(y) > 40) {
//                        if(x > 40) {
                    print("postpanel vcv panning exit")
//                    if(!isCarouselScrolled) {
                        isToPostPan = true
//                    }
                } else {
                    print("postpanel vcv panning no exit")
                }
            }
            
            //test > panning panel exit once x-threshold reached
            if(isToPostPan) {
                let distLimit = 100.0
                let minScale = 0.5
                let maxCornerRadius = 200.0
                let x2 = pow(x, 2)
                let y2 = pow(y, 2)
                let dist = sqrt(x2 + y2)
                print("onPan change circle mask: \(dist), \(currentPanelTopCons), \(currentPanelLeadingCons)")

                let width = viewWidth
                let height = viewHeight
                var newMaskSize = height + ((100 - height)/distLimit * dist)
                if(newMaskSize < 100) {
                    newMaskSize = 100
                }

                print("onPan change mask: \(newMaskSize), \(viewHeight), \(viewWidth)")
                let oriX = width/2 - newMaskSize/2 //default 200
                let oriY = height/2 - newMaskSize/2
                let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: newMaskSize, height: newMaskSize))
                shapeLayer.path = circlePath.cgPath

                var newMaskBGOpacity = 1.0 + ((0.0 - 1.0)/distLimit * dist)
                cView.layer.opacity = Float(newMaskBGOpacity)

                if(newMaskSize <= viewWidth){
                    panelTopCons?.constant = currentPanelTopCons + y
                    panelLeadingCons?.constant = currentPanelLeadingCons + x
                } else {
                    //test > move back to 0, 0
                    panelTopCons?.constant = 0.0
                    panelLeadingCons?.constant = 0.0
                }
            }
            
        } else if(gesture.state == .ended){
            
            //test => if count == 1, onsoundpanelgesture will be triggered too, then conflict, video panel will pause
//            if(vcDataList.count > 1) {
//                if(currentIndex == 0 || currentIndex == vcDataList.count - 1) {
                    //test
                    let width = viewWidth
                    let height = viewHeight + 100

                    let distLimit = 100.0 //default : 50
                    let x2 = pow(panelLeadingCons!.constant, 2)
                    let y2 = pow(panelTopCons!.constant, 2)
                    let dist = sqrt(x2 + y2)

                    if(dist >= distLimit) {
                        self.delegate?.didStartClosePhotoZoomPanel(ppv: self)

                    } else {
                        let oriX = width/2 - height/2 //default 200
                        let oriY = viewHeight/2 - height/2
                        let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
                        shapeLayer.path = circlePath.cgPath

                        //test > move back to 0, 0
                        panelTopCons?.constant = 0.0
                        panelLeadingCons?.constant = 0.0

                        //test
                        self.delegate?.didEndPhotoZoomPanGesture(ppv: self)
                    }
//                }
                
                //test > determine direction of scroll
                direction = "na"
                
                //test
                isToPostPan = false
//            }
        }
    }

    @objc func onBackPhotoZoomPanelClicked(gesture: UITapGestureRecognizer) {

        //test
        self.delegate?.didStartClosePhotoZoomPanel(ppv: self)
    }

    func close(isAnimated: Bool) {
        //test > shrink video panel when touch
        if(isAnimated) {

            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.panel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    .concatenating(CGAffineTransform(translationX: self.offsetX, y: self.offsetY))
                self.panel.layer.cornerRadius = 200

            }, completion: { finished in
                
                self.removeFromSuperview()

                self.delegate?.didFinishClosePhotoZoomPanel(ppv : self)
            })
        } else {

            self.removeFromSuperview()

            self.delegate?.didFinishClosePhotoZoomPanel(ppv : self)
        }
    }

    func open(offX: CGFloat, offY: CGFloat, delay: CGFloat, isAnimated: Bool) {

        //test > make video panel return to original size
        self.panel.transform = CGAffineTransform.identity
        panelTopCons?.constant = 0
        panelLeadingCons?.constant = 0
        self.panel.layer.cornerRadius = 10

        if(isAnimated) {
//            self.delegate?.didStartOpenVideoPanel()

            offsetX = offX
            offsetY = offY

            self.panel.layer.cornerRadius = 200 //default: 10
            self.panel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001).concatenating(CGAffineTransform(translationX: offX, y: offY))
            UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseInOut], //default: 0.2
                animations: {
                self.panel.transform = CGAffineTransform.identity
                self.panel.layer.cornerRadius = 10
                
                self.asyncInitPredeterminedDatasets(dataset: self.predeterminedDatasets)
                
            }, completion: { finished in
                self.delegate?.didFinishOpenPhotoZoomPanel()

                //test
//                self.initialize()
            })
        }
    }
    
    var isInitialized = false
    func asyncInitPredeterminedDatasets(dataset: [String]) {
        //        let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        //        let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage1.sd_setImage(with: gifUrl)
        
        isInitialized = true
    }
    
    @objc func onDoubleTap(gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let center = gesture.location(in: gifImage1)
            let zoomRect = CGRect(x: center.x, y: center.y, width: 1, height: 1)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
}

extension PhotoZoomPanelView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gifImage1
    }
}

extension ViewController: PhotoZoomPanelDelegate{
    func didStartOpenPhotoZoomPanel() {
        
    }
    func didFinishOpenPhotoZoomPanel(){
        
    }
    func didStartClosePhotoZoomPanel(ppv : PhotoZoomPanelView){
        ppv.offsetX = ppv.offsetX - ppv.panelLeadingCons!.constant
        ppv.offsetY = ppv.offsetY - ppv.panelTopCons!.constant

        ppv.close(isAnimated: true)
    }
    func didFinishClosePhotoZoomPanel(ppv : PhotoZoomPanelView){
        backPage(isCurrentPageScrollable: false)
    }

    //test > for marker animation after video closes
    func didStartPhotoZoomPanGesture(ppv : PhotoZoomPanelView){
        
    }
    func didEndPhotoZoomPanGesture(ppv : PhotoZoomPanelView){
        
    }
}
