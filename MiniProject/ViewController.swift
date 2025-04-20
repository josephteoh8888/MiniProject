//
//  ViewController.swift
//  MiniProject
//
//  Created by Joseph Teoh on 27/06/2024.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import SDWebImage
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    let MIN_MARKER_DIM: CGFloat = 44 //40
    let MAX_MARKER_DIM: CGFloat = 110
    
    var mapView: GMSMapView?
    var mapViewHeightCons: NSLayoutConstraint?
    var list = [GMUWeightedLatLng]()
    private var heatmapLayer: GMUHeatmapTileLayer = GMUHeatmapTileLayer()
//    var markerList = [ExploreMarker]()
    var markerList = [Marker]()
    var pulseWaveList = [PulseWave]()
    
    let mapZoom = MapZoomView()
    let MIN_MAP_ZOOM_WIDTH: CGFloat = 30
    var mapZoomWidthAnchor : NSLayoutConstraint?
    var isMapZooming = false
    
    //autofocus marker
    let redView = UIView()
    var isCollided = false
    var collidedCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var redViewTopCons: NSLayoutConstraint?
    
    //test video panel
//    let videoPanel = VideoPanelView()

    //test video panel uicollectionview
    var vcDataList = [String]()
    
    let aMini = UIView()
    let bMini = QueueableView()
    let cMini = UIView()
    
    let aSemiTransparentTextBox = UIView()
//    let semiGifImageOuter = QueueableView()
    let semiGifImageOuter = RingView()
    let semiGifImage = SDAnimatedImageView()
    
    //test place panel
    let bBox = UIView()
    let bBoxBtn = UIImageView()
    let pSemiTransparentTextBox = UIView()
    let uSemiTransparentTextBox = UIView()
    let lSemiTransparentTextBox = UIView()
    let cSemiTransparentTextBox = UIView() //c for creators
    let sSemiTransparentTextBox = UIView() //s for sound
    
    //test marker pop out animation
    let blueView = UIView()
    var geohashList = [String : [String]]()
//    var markerGeoList = [String : CLLocationCoordinate2D]()
    var markerGeoList = [String : GeoData]()
    var markerGeoMarkerIdList = [String : Marker]()
    var projectedScreenPointList = [CGPoint]()
    
    //test place point marker
//    var placeMarkerGeoList = [CLLocationCoordinate2D]()
    var placeMarkerIdList = [String]()
    
    //test page transition => try out userpanel first
    var pageList = [PanelView]()
    var stateMapTargetCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var stateMapTargetZoom : Float = 0.0
    
    //test > fake data for async ops, e.g. open video panel
//    let api = APICaller()
    var queueObjectList = [QueueObject]()
    
    //test > menu panel
    let menuPanelSafeArea = UIView()
    let stackView = UIStackView()
    
    //test > search panel
    //main page as a giant panelview => searchpanel is just a subview, whereas scrollable is a separate sub-panelview
    let searchPanel = SearchPanelView()
    let notifyPanel = NotifyPanelView()
//    let notifyPanel : NotifyPanelView
    let mePanel = MePanelView()
    var createSelectPanel: CreateSelectPanelView?
    var signoutProgressPanel: SignoutProgressView? //test > signout progress view
    
    //test > user current location
    let locationManager = CLLocationManager()
    let getLocationMini = UIView()
    let getLocationMiniError = UIView()
    
    //test > temp: do not show marker when clicked on "locations" mini app
    var vcScrollableId = -1 //test > view controller scrollable id
    var appScrollableId = -1 //check with scrollableId before rendering markers(prevent markers conflict)
    
    //test > portrait mode(for viewcontroller only; need infoplist for entire app)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //test > fix statusbar text color to light color, else the color will change wrt screen color
    //*but this method is for ViewC only, need infoplist for entire app
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test > black bg color for light mode
        self.view.backgroundColor = .black
        
        // Do any additional setup after loading the view.
        GMSServices.provideAPIKey("XXX")
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 2.0)
//        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 300), camera: camera)
        self.view.addSubview(mapView!)
        mapView?.mapType = .hybrid
        mapView?.delegate = self
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        mapView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        mapView?.layer.cornerRadius = 10 //10
        
        //test > keyboard listener
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //test > artificial map pan, pinch
//        turnOnArtificialMapPan()
//        turnOnArtificialMapPinch()
        disableMapRotateTilt()
    }
    
    func disableMapRotateTilt() {
        //test
        mapView?.settings.rotateGestures = false //test > turn off rotate for simplicity
        mapView?.settings.tiltGestures = false //test > turn off tilt for simplicity
    }
    
    //test > keyboard listener
    @objc func onKeyboardShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("lifecycle App onKeyboardShow! \(keyboardSize.height) ")
        }
    }
    @objc func onKeyboardHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("lifecycle App onKeyboardHide! \(keyboardSize.height) ")
        }
        print("lifecycle App onKeyboardHide!")
    }
    @objc func onKeyboardChange(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("lifecycle App onKeyboardChange! \(keyboardSize.height) ")
        }
    }
    @objc func onKeyboardWillChange(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("lifecycle App onKeyboardWillChange! \(keyboardSize.height) ")
            
            if(!pageList.isEmpty) {
                if let c = pageList[pageList.count - 1] as? PanelView {
                    c.keyboardUp(margin: keyboardSize.height)
                }
            }
        }
    }
    
    var topInset = 0.0
    var bottomInset = 0.0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topInset = self.view.safeAreaInsets.top
        bottomInset = self.view.safeAreaInsets.bottom
        
        let w = self.view.frame.width
        let h = self.view.frame.height
        print("viewc viewDidLayoutSubviews: \(bottomInset), \(topInset), \(w), \(h)")
    }
    
    let menuHomeBtn = UIImageView()
    let menuSearchBtn = UIImageView()
    let menuNotifyBtn = UIImageView()
    let menuProfileBtn = UIImageView()
    let aSearchRound = UIView()
    let stack1Btn = UIView()
    let stack2Btn = UIView()
    let stack4Btn = UIView()
    let stack5Btn = UIView()
    var appMenuMode = "home"
    
    let aSemiTransparentText = UILabel()
    let arrowBtn = UIImageView()
    let semiTransparentSpinner = SpinLoader()
    let aSemiTransparentSpinner = SpinLoader()
    let pSemiTransparentSpinner = SpinLoader()
    let pSemiTransparentText = UILabel()
    let uSemiTransparentSpinner = SpinLoader()
    let sSemiTransparentSpinner = SpinLoader()
    let uSemiTransparentText = UILabel()
    let pSemiGifImageOuter = UIView()
    let uSemiGifImageOuter = UIView()
    let sSemiGifImageOuter = UIView()
    let lSemiTransparentText = UILabel()
    let cSemiTransparentText = UILabel()
    let sSemiTransparentText = UILabel()
    let uSemiGifImage = SDAnimatedImageView()
    
//    let locationPinner = UIImageView()
//    let locationPinner = UIView()
    var lPinner : LocationPinMarker?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //add map-zoom
//        mapZoom.setMaxWidth(width: self.view.frame.size.width, orientation: 1)
        mapZoom.setConfiguration(minWidth: MIN_MAP_ZOOM_WIDTH, maxWidth: self.view.frame.size.width, orientation: 1)
        view.addSubview(mapZoom)
        mapZoom.translatesAutoresizingMaskIntoConstraints = false
        mapZoom.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapZoom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        mapZoom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapZoom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapZoom.mapZoomWidthAnchor = mapZoom.widthAnchor.constraint(equalToConstant: MIN_MAP_ZOOM_WIDTH)//test
        mapZoom.mapZoomWidthAnchor?.isActive = true//test
        mapZoom.delegate = self
        
        //add top map shadow
        let aShadow = ShadowView()
        aShadow.setupViews()
        self.view.addSubview(aShadow)
        aShadow.translatesAutoresizingMaskIntoConstraints = false
        aShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        aShadow.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        aShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        aShadow.heightAnchor.constraint(equalToConstant: 60).isActive = true //original 60 height
        aShadow.layer.opacity = 0.5 //6
        aShadow.isUserInteractionEnabled = false
        
        let bShadow = ShadowView()
        bShadow.setupInvertedViews()
        self.view.addSubview(bShadow)
        bShadow.translatesAutoresizingMaskIntoConstraints = false
        bShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bShadow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        bShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bShadow.heightAnchor.constraint(equalToConstant: 60).isActive = true //original 60 height
        bShadow.layer.opacity = 0.5 //6
        bShadow.isUserInteractionEnabled = false
        
        //test 1 > semi-transparent text box
//        let aSemiTransparentTextBox = UIView()
//        aSemiTransparentTextBox.backgroundColor = .ddmBlackOverlayColor
//        aSemiTransparentTextBox.backgroundColor = .white
        self.view.addSubview(aSemiTransparentTextBox)
        aSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
//        aSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        aSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        aSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        aSemiTransparentTextBox.layer.cornerRadius = 15
        aSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 45).isActive = true //42
//        aSemiTransparentTextBox.widthAnchor.constraint(equalToConstant: 100).isActive = true //test
        
        let aSemiTransparentTextBoxBG = UIView()
        aSemiTransparentTextBoxBG.backgroundColor = .ddmBlackOverlayColor
//        aSemiTransparentTextBoxBG.backgroundColor = .white
        aSemiTransparentTextBoxBG.layer.opacity = 0.4 //0.3
        aSemiTransparentTextBoxBG.layer.cornerRadius = 15
        aSemiTransparentTextBox.addSubview(aSemiTransparentTextBoxBG)
        aSemiTransparentTextBoxBG.translatesAutoresizingMaskIntoConstraints = false
        aSemiTransparentTextBoxBG.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor).isActive = true
        aSemiTransparentTextBoxBG.bottomAnchor.constraint(equalTo: aSemiTransparentTextBox.bottomAnchor).isActive = true
        aSemiTransparentTextBoxBG.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor).isActive = true
        aSemiTransparentTextBoxBG.trailingAnchor.constraint(equalTo: aSemiTransparentTextBox.trailingAnchor).isActive = true
        
        //test > semiGif => compilation of videos at "around you"
//        aSemiTransparentTextBox.addSubview(semiGifImageOuter)
//        semiGifImageOuter.translatesAutoresizingMaskIntoConstraints = false
//        semiGifImageOuter.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true
//        semiGifImageOuter.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor).isActive = true
//        semiGifImageOuter.heightAnchor.constraint(equalToConstant: 38).isActive = true //34
//        semiGifImageOuter.widthAnchor.constraint(equalToConstant: 38).isActive = true
//        semiGifImageOuter.changeLineWidth(width: 2)
//        semiGifImageOuter.changeStrokeColor(color: UIColor.yellow)
//        semiGifImageOuter.isHidden = true
//
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
////        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
////        var semiGifImage = SDAnimatedImageView()
//        semiGifImage.contentMode = .scaleAspectFill
//        semiGifImage.layer.masksToBounds = true
//        semiGifImage.layer.cornerRadius = 17
//        semiGifImage.sd_setImage(with: imageUrl)
//        semiGifImageOuter.addSubview(semiGifImage)
//        semiGifImage.translatesAutoresizingMaskIntoConstraints = false
//        semiGifImage.centerXAnchor.constraint(equalTo: semiGifImageOuter.centerXAnchor).isActive = true
//        semiGifImage.centerYAnchor.constraint(equalTo: semiGifImageOuter.centerYAnchor).isActive = true
//        semiGifImage.heightAnchor.constraint(equalToConstant: 34).isActive = true //34
//        semiGifImage.widthAnchor.constraint(equalToConstant: 34).isActive = true
//
////        aSemiTransparentTextBox.addSubview(semiTransparentSpinner)
//        semiGifImageOuter.addSubview(semiTransparentSpinner)
//        semiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
//        semiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
//        semiTransparentSpinner.centerYAnchor.constraint(equalTo: semiGifImageOuter.centerYAnchor).isActive = true
//        semiTransparentSpinner.centerXAnchor.constraint(equalTo: semiGifImageOuter.centerXAnchor).isActive = true
//        semiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        semiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true

        //test > fake aSemi container for better clicking => it IS better
//        let aSemi = UIView()
//        aSemiTransparentTextBox.addSubview(aSemi)
////        aSemiBG.addSubview(aSemi)
////        aSemi.backgroundColor = .red
////        aSemi.layer.opacity = 0.5
//        aSemi.translatesAutoresizingMaskIntoConstraints = false
//        aSemi.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aSemi.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        aSemi.centerYAnchor.constraint(equalTo: semiGifImageOuter.centerYAnchor).isActive = true
//        aSemi.centerXAnchor.constraint(equalTo: semiGifImageOuter.centerXAnchor).isActive = true
////        aSemi.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true
////        aSemi.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor).isActive = true
//        aSemi.isUserInteractionEnabled = true
//        aSemi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSemiGifClicked)))
        
//        let aSemiTransparentText = UILabel()
        aSemiTransparentText.textAlignment = .center
        aSemiTransparentText.textColor = .white
        aSemiTransparentText.font = .boldSystemFont(ofSize: 14)
//        self.view.addSubview(aSemiTransparentText)
        aSemiTransparentTextBox.addSubview(aSemiTransparentText)
        aSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
        aSemiTransparentText.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
        aSemiTransparentText.bottomAnchor.constraint(equalTo: aSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
//        aSemiTransparentText.leadingAnchor.constraint(equalTo: semiGifImageOuter.trailingAnchor, constant: 10).isActive = true
        aSemiTransparentText.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 20).isActive = true
//        aSemiTransparentText.text = "Around You" //default: Around You
        aSemiTransparentText.text = "" //default: Around You
        aSemiTransparentText.isUserInteractionEnabled = true
        aSemiTransparentText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSemiArrowClicked)))

//        let arrowBtn = UIImageView(image: UIImage(named:"icon_arrow_down")?.withRenderingMode(.alwaysTemplate))
//        arrowBtn.image = UIImage(named:"icon_arrow_down")?.withRenderingMode(.alwaysTemplate)
        arrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        arrowBtn.tintColor = .white
//        self.view.addSubview(arrowBtn)
        aSemiTransparentTextBox.addSubview(arrowBtn)
        arrowBtn.translatesAutoresizingMaskIntoConstraints = false
        arrowBtn.leadingAnchor.constraint(equalTo: aSemiTransparentText.trailingAnchor).isActive = true
        arrowBtn.trailingAnchor.constraint(equalTo: aSemiTransparentTextBox.trailingAnchor, constant: 0).isActive = true //-5, 0
        arrowBtn.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor).isActive = true
        arrowBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true //ori 36
        arrowBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        arrowBtn.isUserInteractionEnabled = true
        arrowBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSemiArrowClicked)))
        arrowBtn.isHidden = true
        
        //test > new spinner for "around you"
        aSemiTransparentTextBox.addSubview(aSemiTransparentSpinner)
        aSemiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSemiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSemiTransparentSpinner.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor).isActive = true
        aSemiTransparentSpinner.centerXAnchor.constraint(equalTo: aSemiTransparentTextBox.centerXAnchor).isActive = true
//        uSemiTransparentSpinner.leadingAnchor.constraint(equalTo: uSemiGifImageOuter.trailingAnchor, constant: 10).isActive = true
        aSemiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSemiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        aSemiTransparentSpinner.startAnimating()
        
        //test 2 > mini apps at bottom like snapmap
        addMiniApps()
        
        //test 4 > autofocus for marker => collision detection
//        redView.backgroundColor = .red
        self.view.addSubview(redView)
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        redView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        redViewTopCons = redView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        redViewTopCons?.isActive = true
        redView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        redView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        redView.layer.cornerRadius = 10
        redView.isUserInteractionEnabled = false
        
        //test 7 > entree animation into screen => collision detection
//        blueView.backgroundColor = .blue
        self.view.addSubview(blueView)
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blueView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blueView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        blueView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        blueView.layer.cornerRadius = 10
        blueView.isUserInteractionEnabled = false
        
        //test 10 > add search button on top LHS => ok...but not that great
//        let lBox = UIView()
//        lBox.backgroundColor = .ddmBlackOverlayColor
//        self.view.addSubview(lBox)
//        lBox.translatesAutoresizingMaskIntoConstraints = false
//        lBox.widthAnchor.constraint(equalToConstant: 44).isActive = true //ori: 40
//        lBox.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        lBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
//        lBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        lBox.layer.cornerRadius = 22
//        lBox.layer.opacity = 0.4 //default 0.3
//
//        let lBoxBtn = UIImageView()
//        lBoxBtn.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
//        lBoxBtn.tintColor = .white
//        self.view.addSubview(lBoxBtn)
//        lBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        lBoxBtn.centerXAnchor.constraint(equalTo: lBox.centerXAnchor).isActive = true
//        lBoxBtn.centerYAnchor.constraint(equalTo: lBox.centerYAnchor).isActive = true
//        lBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        lBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test 6 > location focus btn and refresh btn on top RHS
//        let getLocationMini = UIView()
//        getLocationMini.backgroundColor = .ddmBlackOverlayColor
////        getLocationMini.backgroundColor = .white
//        self.view.addSubview(getLocationMini)
//        getLocationMini.translatesAutoresizingMaskIntoConstraints = false
////        getLocationMini.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
//        getLocationMini.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default : 0
//        getLocationMini.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
//        getLocationMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        getLocationMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        getLocationMini.layer.cornerRadius = 20
//        getLocationMini.layer.opacity = 0.3
//
////        let aBtn = UIImageView(image: UIImage(named:"icon_gps_location")?.withRenderingMode(.alwaysTemplate))
//        let aBtn = UIImageView(image: UIImage(named:"icon_round_setting")?.withRenderingMode(.alwaysTemplate))
////        let aBtn = UIImageView(image: UIImage(named:"icon_round_filter")?.withRenderingMode(.alwaysTemplate))
//        aBtn.tintColor = .white
//        self.view.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.centerXAnchor.constraint(equalTo: getLocationMini.centerXAnchor).isActive = true
////        aBtn.topAnchor.constraint(equalTo: getLocationMini.topAnchor, constant: 10).isActive = true
//        aBtn.centerYAnchor.constraint(equalTo: getLocationMini.centerYAnchor).isActive = true
//        aBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
//        aBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGpsClicked)))
//
//        let aBtnRedView = UIView()
//        aBtnRedView.backgroundColor = .red
//        self.view.addSubview(aBtnRedView)
//        aBtnRedView.translatesAutoresizingMaskIntoConstraints = false
//        aBtnRedView.leadingAnchor.constraint(equalTo: aBtn.trailingAnchor, constant: -5).isActive = true
//        aBtnRedView.bottomAnchor.constraint(equalTo: aBtn.topAnchor, constant: 5).isActive = true //10
//        aBtnRedView.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        aBtnRedView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
//        aBtnRedView.layer.cornerRadius = 5 //10
////        aBtnRedView.isHidden = true

//        let bBtn = UIImageView(image: UIImage(named:"icon_refresh")?.withRenderingMode(.alwaysTemplate))
//        bBtn.tintColor = .white
//        self.view.addSubview(bBtn)
//        bBtn.translatesAutoresizingMaskIntoConstraints = false
//        bBtn.centerXAnchor.constraint(equalTo: getLocationMini.centerXAnchor).isActive = true
//        bBtn.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 10).isActive = true
////        bBtn.centerYAnchor.constraint(equalTo: getLocationMini.centerYAnchor).isActive = true
//        bBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
//        bBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bBtn.bottomAnchor.constraint(equalTo: getLocationMini.bottomAnchor, constant: -10).isActive = true
//        bBtn.isUserInteractionEnabled = true
//        bBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRefreshClicked)))
        
        //test > RHS settings and content type filter for map
        addContentTypeFilter()
        
        //test > search panel in main
        self.view.insertSubview(searchPanel, belowSubview: menuPanelSafeArea)
        searchPanel.translatesAutoresizingMaskIntoConstraints = false
        searchPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        searchPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        searchPanel.isHidden = true
        searchPanel.delegate = self
        
        self.view.insertSubview(notifyPanel, belowSubview: menuPanelSafeArea)
        notifyPanel.translatesAutoresizingMaskIntoConstraints = false
        notifyPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        notifyPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        notifyPanel.isHidden = true
        notifyPanel.delegate = self
        
        self.view.insertSubview(mePanel, belowSubview: menuPanelSafeArea)
        mePanel.translatesAutoresizingMaskIntoConstraints = false
        mePanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        mePanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        mePanel.isHidden = true
        mePanel.delegate = self
        
        //test > btn for closing place panel
        bBox.backgroundColor = .ddmBlackOverlayColor
        self.view.addSubview(bBox)
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        bBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        bBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        bBox.layer.cornerRadius = 20
        bBox.layer.opacity = 0.4 //default 0.3
        bBox.isUserInteractionEnabled = true
        bBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPlacePanelClicked)))

        bBoxBtn.image = UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate)
        bBoxBtn.tintColor = .white
        self.view.addSubview(bBoxBtn)
        bBoxBtn.translatesAutoresizingMaskIntoConstraints = false
        bBoxBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        bBoxBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        bBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        bBox.isHidden = true
        bBoxBtn.isHidden = true
        
        //test > semi-transparent for location panel
        self.view.addSubview(lSemiTransparentTextBox)
        lSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
        lSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        lSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lSemiTransparentTextBox.layer.cornerRadius = 15
        lSemiTransparentTextBox.isHidden = true
        lSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 45).isActive = true //42
        
        let lSemiTransparentTextBoxBG = UIView()
        lSemiTransparentTextBoxBG.backgroundColor = .ddmBlackOverlayColor
        lSemiTransparentTextBoxBG.layer.opacity = 0.4 //0.3
        lSemiTransparentTextBoxBG.layer.cornerRadius = 15
        lSemiTransparentTextBox.addSubview(lSemiTransparentTextBoxBG)
        lSemiTransparentTextBoxBG.translatesAutoresizingMaskIntoConstraints = false
        lSemiTransparentTextBoxBG.topAnchor.constraint(equalTo: lSemiTransparentTextBox.topAnchor).isActive = true
        lSemiTransparentTextBoxBG.bottomAnchor.constraint(equalTo: lSemiTransparentTextBox.bottomAnchor).isActive = true
        lSemiTransparentTextBoxBG.leadingAnchor.constraint(equalTo: lSemiTransparentTextBox.leadingAnchor).isActive = true
        lSemiTransparentTextBoxBG.trailingAnchor.constraint(equalTo: lSemiTransparentTextBox.trailingAnchor).isActive = true
        
        lSemiTransparentText.textAlignment = .center
        lSemiTransparentText.textColor = .white
        lSemiTransparentText.font = .boldSystemFont(ofSize: 14)
        lSemiTransparentTextBox.addSubview(lSemiTransparentText)
        lSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
        lSemiTransparentText.topAnchor.constraint(equalTo: lSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
        lSemiTransparentText.bottomAnchor.constraint(equalTo: lSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
        lSemiTransparentText.leadingAnchor.constraint(equalTo: lSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true //10
        lSemiTransparentText.trailingAnchor.constraint(equalTo: lSemiTransparentTextBox.trailingAnchor, constant: -10).isActive = true
//        lSemiTransparentText.text = "Petronas Twin Tower"
        lSemiTransparentText.text = "Locations"
        
        //test > semi-transparent for users/creators mini panel
        self.view.addSubview(cSemiTransparentTextBox)
        cSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
        cSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        cSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cSemiTransparentTextBox.layer.cornerRadius = 15
        cSemiTransparentTextBox.isHidden = true
        cSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 45).isActive = true //42
        
        let cSemiTransparentTextBoxBG = UIView()
        cSemiTransparentTextBoxBG.backgroundColor = .ddmBlackOverlayColor
        cSemiTransparentTextBoxBG.layer.opacity = 0.4 //0.3
        cSemiTransparentTextBoxBG.layer.cornerRadius = 15
        cSemiTransparentTextBox.addSubview(cSemiTransparentTextBoxBG)
        cSemiTransparentTextBoxBG.translatesAutoresizingMaskIntoConstraints = false
        cSemiTransparentTextBoxBG.topAnchor.constraint(equalTo: cSemiTransparentTextBox.topAnchor).isActive = true
        cSemiTransparentTextBoxBG.bottomAnchor.constraint(equalTo: cSemiTransparentTextBox.bottomAnchor).isActive = true
        cSemiTransparentTextBoxBG.leadingAnchor.constraint(equalTo: cSemiTransparentTextBox.leadingAnchor).isActive = true
        cSemiTransparentTextBoxBG.trailingAnchor.constraint(equalTo: cSemiTransparentTextBox.trailingAnchor).isActive = true
        
        cSemiTransparentText.textAlignment = .center
        cSemiTransparentText.textColor = .white
        cSemiTransparentText.font = .boldSystemFont(ofSize: 14)
        cSemiTransparentTextBox.addSubview(cSemiTransparentText)
        cSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
        cSemiTransparentText.topAnchor.constraint(equalTo: cSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
        cSemiTransparentText.bottomAnchor.constraint(equalTo: cSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
        cSemiTransparentText.leadingAnchor.constraint(equalTo: cSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true //10
        cSemiTransparentText.trailingAnchor.constraint(equalTo: cSemiTransparentTextBox.trailingAnchor, constant: -10).isActive = true
//        cSemiTransparentText.text = "Petronas Twin Tower"
        cSemiTransparentText.text = "Creators"
        
        //test > semi-transparent for sound panel
        self.view.addSubview(sSemiTransparentTextBox)
        sSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
        sSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        sSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sSemiTransparentTextBox.layer.cornerRadius = 15
        sSemiTransparentTextBox.isHidden = true
        sSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 45).isActive = true //42
        
        let sSemiTransparentTextBoxBG = UIView()
        sSemiTransparentTextBoxBG.backgroundColor = .ddmBlackOverlayColor
        sSemiTransparentTextBoxBG.layer.opacity = 0.4 //0.3
        sSemiTransparentTextBoxBG.layer.cornerRadius = 15
        sSemiTransparentTextBox.addSubview(sSemiTransparentTextBoxBG)
        sSemiTransparentTextBoxBG.translatesAutoresizingMaskIntoConstraints = false
        sSemiTransparentTextBoxBG.topAnchor.constraint(equalTo: sSemiTransparentTextBox.topAnchor).isActive = true
        sSemiTransparentTextBoxBG.bottomAnchor.constraint(equalTo: sSemiTransparentTextBox.bottomAnchor).isActive = true
        sSemiTransparentTextBoxBG.leadingAnchor.constraint(equalTo: sSemiTransparentTextBox.leadingAnchor).isActive = true
        sSemiTransparentTextBoxBG.trailingAnchor.constraint(equalTo: sSemiTransparentTextBox.trailingAnchor).isActive = true
        
        sSemiTransparentTextBox.addSubview(sSemiGifImageOuter)
//        self.view.addSubview(semiGifImageOuter)
        sSemiGifImageOuter.translatesAutoresizingMaskIntoConstraints = false
        sSemiGifImageOuter.leadingAnchor.constraint(equalTo: sSemiTransparentTextBox.leadingAnchor, constant: 0).isActive = true //10
        sSemiGifImageOuter.centerYAnchor.constraint(equalTo: sSemiTransparentTextBox.centerYAnchor).isActive = true
        sSemiGifImageOuter.heightAnchor.constraint(equalToConstant: 38).isActive = true //34
        sSemiGifImageOuter.widthAnchor.constraint(equalToConstant: 38).isActive = true
        sSemiGifImageOuter.layer.cornerRadius = 19 //17
//        sSemiGifImageOuter.layer.opacity = 0
        sSemiGifImageOuter.isHidden = true
        
        let sSemiTransparentBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        sSemiTransparentBtn.tintColor = .white //white
        sSemiGifImageOuter.addSubview(sSemiTransparentBtn)
        sSemiTransparentBtn.translatesAutoresizingMaskIntoConstraints = false
        sSemiTransparentBtn.centerXAnchor.constraint(equalTo: sSemiGifImageOuter.centerXAnchor).isActive = true
        sSemiTransparentBtn.centerYAnchor.constraint(equalTo: sSemiGifImageOuter.centerYAnchor).isActive = true
        sSemiTransparentBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sSemiTransparentBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        sSemiTransparentText.textAlignment = .center
        sSemiTransparentText.textColor = .white
        sSemiTransparentText.font = .boldSystemFont(ofSize: 14)
        sSemiTransparentTextBox.addSubview(sSemiTransparentText)
        sSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
        sSemiTransparentText.topAnchor.constraint(equalTo: sSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
        sSemiTransparentText.bottomAnchor.constraint(equalTo: sSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
        sSemiTransparentText.leadingAnchor.constraint(equalTo: sSemiGifImageOuter.trailingAnchor, constant: 0).isActive = true //10
        sSemiTransparentText.trailingAnchor.constraint(equalTo: sSemiTransparentTextBox.trailingAnchor, constant: -10).isActive = true
//        sSemiTransparentText.text = "Petronas Twin Tower"
        sSemiTransparentText.text = ""
        
        sSemiTransparentTextBox.addSubview(sSemiTransparentSpinner)
        sSemiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        sSemiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
        sSemiTransparentSpinner.centerYAnchor.constraint(equalTo: sSemiTransparentTextBox.centerYAnchor).isActive = true
        sSemiTransparentSpinner.centerXAnchor.constraint(equalTo: sSemiTransparentTextBox.centerXAnchor).isActive = true
//        sSemiTransparentSpinner.leadingAnchor.constraint(equalTo: pSemiTransparentBtn.trailingAnchor, constant: 10).isActive = true
        sSemiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sSemiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > semi-transparent for place panel
//        let pSemiTransparentTextBox = UIView()
//        pSemiTransparentTextBox.backgroundColor = .ddmBlackOverlayColor
        self.view.addSubview(pSemiTransparentTextBox)
        pSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
//        aSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        pSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        pSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pSemiTransparentTextBox.layer.cornerRadius = 15
        pSemiTransparentTextBox.isHidden = true
        pSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 45).isActive = true //42
//        pSemiTransparentTextBox.widthAnchor.constraint(equalToConstant: 100).isActive = true //test
        
        let pSemiTransparentTextBoxBG = UIView()
        pSemiTransparentTextBoxBG.backgroundColor = .ddmBlackOverlayColor
        pSemiTransparentTextBoxBG.layer.opacity = 0.4 //0.3
        pSemiTransparentTextBoxBG.layer.cornerRadius = 15
        pSemiTransparentTextBox.addSubview(pSemiTransparentTextBoxBG)
        pSemiTransparentTextBoxBG.translatesAutoresizingMaskIntoConstraints = false
        pSemiTransparentTextBoxBG.topAnchor.constraint(equalTo: pSemiTransparentTextBox.topAnchor).isActive = true
        pSemiTransparentTextBoxBG.bottomAnchor.constraint(equalTo: pSemiTransparentTextBox.bottomAnchor).isActive = true
        pSemiTransparentTextBoxBG.leadingAnchor.constraint(equalTo: pSemiTransparentTextBox.leadingAnchor).isActive = true
        pSemiTransparentTextBoxBG.trailingAnchor.constraint(equalTo: pSemiTransparentTextBox.trailingAnchor).isActive = true
        
//        let pSemiGifImageOuter = UIView()
//        pSemiGifImageOuter.backgroundColor = .white
//        semiGifImageOuter.backgroundColor = .ddmGoldenYellowColor
        pSemiTransparentTextBox.addSubview(pSemiGifImageOuter)
//        self.view.addSubview(semiGifImageOuter)
        pSemiGifImageOuter.translatesAutoresizingMaskIntoConstraints = false
        pSemiGifImageOuter.leadingAnchor.constraint(equalTo: pSemiTransparentTextBox.leadingAnchor, constant: 0).isActive = true //10
        pSemiGifImageOuter.centerYAnchor.constraint(equalTo: pSemiTransparentTextBox.centerYAnchor).isActive = true
        pSemiGifImageOuter.heightAnchor.constraint(equalToConstant: 38).isActive = true //34
        pSemiGifImageOuter.widthAnchor.constraint(equalToConstant: 38).isActive = true
        pSemiGifImageOuter.layer.cornerRadius = 19 //17
//        pSemiGifImageOuter.layer.opacity = 0
        pSemiGifImageOuter.isHidden = true
        
        let pSemiTransparentBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        pSemiTransparentBtn.tintColor = .white //white
        pSemiGifImageOuter.addSubview(pSemiTransparentBtn)
        pSemiTransparentBtn.translatesAutoresizingMaskIntoConstraints = false
        pSemiTransparentBtn.centerXAnchor.constraint(equalTo: pSemiGifImageOuter.centerXAnchor).isActive = true
        pSemiTransparentBtn.centerYAnchor.constraint(equalTo: pSemiGifImageOuter.centerYAnchor).isActive = true
        pSemiTransparentBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pSemiTransparentBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true

//        let pSemiTransparentText = UILabel()
        pSemiTransparentText.textAlignment = .center
        pSemiTransparentText.textColor = .white
        pSemiTransparentText.font = .boldSystemFont(ofSize: 14)
        pSemiTransparentTextBox.addSubview(pSemiTransparentText)
        pSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
        pSemiTransparentText.topAnchor.constraint(equalTo: pSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
        pSemiTransparentText.bottomAnchor.constraint(equalTo: pSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
        pSemiTransparentText.leadingAnchor.constraint(equalTo: pSemiGifImageOuter.trailingAnchor, constant: 0).isActive = true //10
        pSemiTransparentText.trailingAnchor.constraint(equalTo: pSemiTransparentTextBox.trailingAnchor, constant: -10).isActive = true
//        pSemiTransparentText.text = "Petronas Twin Tower"
        pSemiTransparentText.text = ""
        
//        let pSemiTransparentSpinner = SpinLoader()
//        self.view.addSubview(pSemiTransparentSpinner)
        pSemiTransparentTextBox.addSubview(pSemiTransparentSpinner)
        pSemiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        pSemiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
        pSemiTransparentSpinner.centerYAnchor.constraint(equalTo: pSemiTransparentTextBox.centerYAnchor).isActive = true
        pSemiTransparentSpinner.centerXAnchor.constraint(equalTo: pSemiTransparentTextBox.centerXAnchor).isActive = true
//        pSemiTransparentSpinner.leadingAnchor.constraint(equalTo: pSemiTransparentBtn.trailingAnchor, constant: 10).isActive = true
        pSemiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pSemiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        pSemiTransparentSpinner.startAnimating()
//        pSemiTransparentSpinner.isHidden = true
        
        //test > semi-transparent for user panel
//        let pSemiTransparentTextBox = UIView()
//        pSemiTransparentTextBox.backgroundColor = .ddmBlackOverlayColor
        self.view.addSubview(uSemiTransparentTextBox)
        uSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
//        aSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        uSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        uSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uSemiTransparentTextBox.layer.cornerRadius = 15
        uSemiTransparentTextBox.isHidden = true
        uSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 45).isActive = true //42
//        uSemiTransparentTextBox.widthAnchor.constraint(equalToConstant: 100).isActive = true //test
        
        let uSemiTransparentTextBoxBG = UIView()
        uSemiTransparentTextBoxBG.backgroundColor = .ddmBlackOverlayColor
        uSemiTransparentTextBoxBG.layer.opacity = 0.4 //0.3
        uSemiTransparentTextBoxBG.layer.cornerRadius = 15
        uSemiTransparentTextBox.addSubview(uSemiTransparentTextBoxBG)
        uSemiTransparentTextBoxBG.translatesAutoresizingMaskIntoConstraints = false
        uSemiTransparentTextBoxBG.topAnchor.constraint(equalTo: uSemiTransparentTextBox.topAnchor).isActive = true
        uSemiTransparentTextBoxBG.bottomAnchor.constraint(equalTo: uSemiTransparentTextBox.bottomAnchor).isActive = true
        uSemiTransparentTextBoxBG.leadingAnchor.constraint(equalTo: uSemiTransparentTextBox.leadingAnchor).isActive = true
        uSemiTransparentTextBoxBG.trailingAnchor.constraint(equalTo: uSemiTransparentTextBox.trailingAnchor).isActive = true
        
//        let uSemiGifImageOuter = UIView()
        uSemiGifImageOuter.backgroundColor = .white
//        semiGifImageOuter.backgroundColor = .ddmGoldenYellowColor
        uSemiTransparentTextBox.addSubview(uSemiGifImageOuter)
//        self.view.addSubview(semiGifImageOuter)
        uSemiGifImageOuter.translatesAutoresizingMaskIntoConstraints = false
        uSemiGifImageOuter.leadingAnchor.constraint(equalTo: uSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true
        uSemiGifImageOuter.centerYAnchor.constraint(equalTo: uSemiTransparentTextBox.centerYAnchor).isActive = true
        uSemiGifImageOuter.heightAnchor.constraint(equalToConstant: 38).isActive = true //ori 34
        uSemiGifImageOuter.widthAnchor.constraint(equalToConstant: 38).isActive = true
        uSemiGifImageOuter.layer.cornerRadius = 19 //17
//        uSemiGifImageOuter.layer.opacity = 0
        uSemiGifImageOuter.isHidden = true

//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        var uSemiGifImage = SDAnimatedImageView()
        uSemiGifImage.contentMode = .scaleAspectFill
        uSemiGifImage.layer.masksToBounds = true
        uSemiGifImage.layer.cornerRadius = 17
        uSemiGifImage.backgroundColor = .ddmDarkGreyColor
//        uSemiGifImage.sd_setImage(with: imageUrl)
//        self.view.addSubview(semiGifImage)
//        aSemiTransparentTextBox.addSubview(semiGifImage)
        uSemiGifImageOuter.addSubview(uSemiGifImage)
        uSemiGifImage.translatesAutoresizingMaskIntoConstraints = false
//        semiGifImage.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true
        uSemiGifImage.centerXAnchor.constraint(equalTo: uSemiGifImageOuter.centerXAnchor).isActive = true
        uSemiGifImage.centerYAnchor.constraint(equalTo: uSemiGifImageOuter.centerYAnchor).isActive = true
        uSemiGifImage.heightAnchor.constraint(equalToConstant: 34).isActive = true //30
        uSemiGifImage.widthAnchor.constraint(equalToConstant: 34).isActive = true
//        semiGifImage.isUserInteractionEnabled = true
//        semiGifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSemiGifClicked)))
//        semiGifImage.layer.opacity = 0
        
//        let uSemiTransparentText = UILabel()
        uSemiTransparentText.textAlignment = .center
        uSemiTransparentText.textColor = .white
        uSemiTransparentText.font = .boldSystemFont(ofSize: 14)
        uSemiTransparentTextBox.addSubview(uSemiTransparentText)
        uSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
        uSemiTransparentText.topAnchor.constraint(equalTo: uSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
        uSemiTransparentText.bottomAnchor.constraint(equalTo: uSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
        uSemiTransparentText.leadingAnchor.constraint(equalTo: uSemiGifImageOuter.trailingAnchor, constant: 10).isActive = true
        uSemiTransparentText.trailingAnchor.constraint(equalTo: uSemiTransparentTextBox.trailingAnchor, constant: -10).isActive = true
//        uSemiTransparentText.text = "Michelle"
        uSemiTransparentText.text = ""
        
//        let uSemiTransparentSpinner = SpinLoader()
//        self.view.addSubview(uSemiTransparentSpinner)
        uSemiTransparentTextBox.addSubview(uSemiTransparentSpinner)
        uSemiTransparentSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        uSemiTransparentSpinner.translatesAutoresizingMaskIntoConstraints = false
        uSemiTransparentSpinner.centerYAnchor.constraint(equalTo: uSemiTransparentTextBox.centerYAnchor).isActive = true
        uSemiTransparentSpinner.centerXAnchor.constraint(equalTo: uSemiTransparentTextBox.centerXAnchor).isActive = true
//        uSemiTransparentSpinner.leadingAnchor.constraint(equalTo: uSemiGifImageOuter.trailingAnchor, constant: 10).isActive = true
        uSemiTransparentSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        uSemiTransparentSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        uSemiTransparentSpinner.startAnimating()
//        uSemiTransparentSpinner.isHidden = true
        
        //test > confetti
//        createParticles()
        
        //test menu panel
//        let menuPanelSafeArea = UIView()
        menuPanelSafeArea.backgroundColor = .black
        self.view.addSubview(menuPanelSafeArea)
        menuPanelSafeArea.translatesAutoresizingMaskIntoConstraints = false
        menuPanelSafeArea.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuPanelSafeArea.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuPanelSafeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuPanelSafeArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        let stack1 = UIView()
        let stack2 = UIView()
        let stack3 = UIView()
        let stack4 = UIView()
        let stack5 = UIView()


//        let menuAddOuter = GradientView()
//        menuAddOuter.setupViews()
//        menuAddOuter.layer.masksToBounds = true
        let menuAddOuter = UIView()
        menuAddOuter.backgroundColor = .yellow
        menuAddOuter.layer.cornerRadius = 10
        stack3.addSubview(menuAddOuter)
        menuAddOuter.translatesAutoresizingMaskIntoConstraints = false
        menuAddOuter.centerXAnchor.constraint(equalTo: stack3.centerXAnchor).isActive = true
        menuAddOuter.centerYAnchor.constraint(equalTo: stack3.centerYAnchor).isActive = true
        menuAddOuter.heightAnchor.constraint(equalToConstant: 32).isActive = true //ori 30
        menuAddOuter.widthAnchor.constraint(equalToConstant: 40).isActive = true
        menuAddOuter.isUserInteractionEnabled = true
        menuAddOuter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMenuCreateClicked)))
//        menuAddOuter.layer.shadowColor = UIColor.yellow.cgColor
//        menuAddOuter.layer.shadowRadius = 6.0  //ori 3
//        menuAddOuter.layer.shadowOpacity = 1.0 //ori 1
//        menuAddOuter.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
        let menuAddRing = UIView()
        menuAddRing.backgroundColor = .black
//        menuPanel.addSubview(menuAddRing)
        menuAddOuter.addSubview(menuAddRing)
        menuAddRing.translatesAutoresizingMaskIntoConstraints = false
        menuAddRing.centerXAnchor.constraint(equalTo: menuAddOuter.centerXAnchor).isActive = true
        menuAddRing.centerYAnchor.constraint(equalTo: menuAddOuter.centerYAnchor).isActive = true
        menuAddRing.heightAnchor.constraint(equalToConstant: 28).isActive = true //ori 30
        menuAddRing.widthAnchor.constraint(equalToConstant: 36).isActive = true
        menuAddRing.layer.cornerRadius = 8
        
        let menuAddBtn = UIImageView(image: UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate))
        menuAddBtn.tintColor = .yellow
//        menuAddBtn.tintColor = .ddmGoldenYellowColor
//        menuPanel.addSubview(menuAddBtn)
        menuAddOuter.addSubview(menuAddBtn)
        menuAddBtn.translatesAutoresizingMaskIntoConstraints = false
        menuAddBtn.centerXAnchor.constraint(equalTo: menuAddRing.centerXAnchor).isActive = true
        menuAddBtn.centerYAnchor.constraint(equalTo: menuAddRing.centerYAnchor).isActive = true
        menuAddBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
        menuAddBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        menuAddBtn.isHidden = true
        
        //test > add notify icon on menu btns
        let menuAddNotifyView = UIView()
        menuAddNotifyView.backgroundColor = .red
        stack3.addSubview(menuAddNotifyView)
        menuAddNotifyView.translatesAutoresizingMaskIntoConstraints = false
        menuAddNotifyView.leadingAnchor.constraint(equalTo: menuAddOuter.trailingAnchor, constant: -5).isActive = true
        menuAddNotifyView.bottomAnchor.constraint(equalTo: menuAddOuter.topAnchor, constant: 5).isActive = true //10
        menuAddNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        menuAddNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        menuAddNotifyView.layer.cornerRadius = 5 //10
        menuAddNotifyView.isHidden = true
        
        let menuAddNotifyText = UILabel()
        menuAddNotifyText.textAlignment = .center
        menuAddNotifyText.textColor = .white
//        menuAddNotifyText.textColor = .black
        menuAddNotifyText.font = .boldSystemFont(ofSize: 12)
        menuAddNotifyView.addSubview(menuAddNotifyText)
        menuAddNotifyText.translatesAutoresizingMaskIntoConstraints = false
        menuAddNotifyText.centerYAnchor.constraint(equalTo: menuAddNotifyView.centerYAnchor, constant: 0).isActive = true
        menuAddNotifyText.centerXAnchor.constraint(equalTo: menuAddNotifyView.centerXAnchor, constant: 0).isActive = true //10
        menuAddNotifyText.text = "2"
        menuAddNotifyText.isHidden = true
        //
        
        stack1.addSubview(stack1Btn)
        stack1Btn.translatesAutoresizingMaskIntoConstraints = false
        stack1Btn.centerXAnchor.constraint(equalTo: stack1.centerXAnchor, constant: -5).isActive = true
        stack1Btn.centerYAnchor.constraint(equalTo: stack1.centerYAnchor).isActive = true
        stack1Btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack1Btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stack1Btn.isUserInteractionEnabled = true
        stack1Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMenuHomeClicked)))
        
        menuHomeBtn.tintColor = .white
        stack1Btn.addSubview(menuHomeBtn)
        menuHomeBtn.translatesAutoresizingMaskIntoConstraints = false
        menuHomeBtn.centerXAnchor.constraint(equalTo: stack1Btn.centerXAnchor).isActive = true
        menuHomeBtn.centerYAnchor.constraint(equalTo: stack1Btn.centerYAnchor).isActive = true
        menuHomeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //ori 30
        menuHomeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let menuHomeNotifyView = UIView()
        menuHomeNotifyView.backgroundColor = .red
        stack1Btn.addSubview(menuHomeNotifyView)
        menuHomeNotifyView.translatesAutoresizingMaskIntoConstraints = false
        menuHomeNotifyView.leadingAnchor.constraint(equalTo: menuHomeBtn.trailingAnchor, constant: -5).isActive = true
        menuHomeNotifyView.bottomAnchor.constraint(equalTo: menuHomeBtn.topAnchor, constant: 5).isActive = true
        menuHomeNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        menuHomeNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        menuHomeNotifyView.layer.cornerRadius = 5 //10
        menuHomeNotifyView.isHidden = true
        
        let menuHomeNotifyText = UILabel()
        menuHomeNotifyText.textAlignment = .center
        menuHomeNotifyText.textColor = .white
        menuHomeNotifyText.font = .boldSystemFont(ofSize: 12)
        menuHomeNotifyView.addSubview(menuHomeNotifyText)
        menuHomeNotifyText.translatesAutoresizingMaskIntoConstraints = false
        menuHomeNotifyText.centerYAnchor.constraint(equalTo: menuHomeNotifyView.centerYAnchor, constant: 0).isActive = true
        menuHomeNotifyText.centerXAnchor.constraint(equalTo: menuHomeNotifyView.centerXAnchor, constant: 0).isActive = true //10
        menuHomeNotifyText.text = "2"
        menuHomeNotifyText.isHidden = true
        
        stack2.addSubview(stack2Btn)
        stack2Btn.translatesAutoresizingMaskIntoConstraints = false
        stack2Btn.centerXAnchor.constraint(equalTo: stack2.centerXAnchor, constant: -5).isActive = true
        stack2Btn.centerYAnchor.constraint(equalTo: stack2.centerYAnchor).isActive = true
        stack2Btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack2Btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stack2Btn.isUserInteractionEnabled = true
        stack2Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMenuSearchClicked)))
        
//        menuSearchBtn.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        menuSearchBtn.tintColor = .white
        stack2Btn.addSubview(menuSearchBtn)
        menuSearchBtn.translatesAutoresizingMaskIntoConstraints = false
        menuSearchBtn.centerXAnchor.constraint(equalTo: stack2Btn.centerXAnchor).isActive = true
        menuSearchBtn.centerYAnchor.constraint(equalTo: stack2Btn.centerYAnchor).isActive = true
        menuSearchBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //ori 30
        menuSearchBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        aSearchRound.backgroundColor = .white
        menuSearchBtn.addSubview(aSearchRound)
        aSearchRound.translatesAutoresizingMaskIntoConstraints = false
        aSearchRound.topAnchor.constraint(equalTo: menuSearchBtn.topAnchor, constant: 4).isActive = true
        aSearchRound.leadingAnchor.constraint(equalTo: menuSearchBtn.leadingAnchor, constant: 4).isActive = true
        aSearchRound.heightAnchor.constraint(equalToConstant: 16).isActive = true //ori 30
        aSearchRound.widthAnchor.constraint(equalToConstant: 16).isActive = true
        aSearchRound.layer.cornerRadius = 8
        aSearchRound.isHidden = true
        
        //test > add notify icon on menu btns
        let menuSearchNotifyView = UIView()
        menuSearchNotifyView.backgroundColor = .red
        stack2Btn.addSubview(menuSearchNotifyView)
        menuSearchNotifyView.translatesAutoresizingMaskIntoConstraints = false
        menuSearchNotifyView.leadingAnchor.constraint(equalTo: menuSearchBtn.trailingAnchor, constant: -5).isActive = true
        menuSearchNotifyView.bottomAnchor.constraint(equalTo: menuSearchBtn.topAnchor, constant: 5).isActive = true //10
        menuSearchNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        menuSearchNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        menuSearchNotifyView.layer.cornerRadius = 5 //10
        menuSearchNotifyView.isHidden = true
        //
        
        stack4.addSubview(stack4Btn)
        stack4Btn.translatesAutoresizingMaskIntoConstraints = false
        stack4Btn.centerXAnchor.constraint(equalTo: stack4.centerXAnchor, constant: 5).isActive = true
        stack4Btn.centerYAnchor.constraint(equalTo: stack4.centerYAnchor).isActive = true
        stack4Btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack4Btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stack4Btn.isUserInteractionEnabled = true
        stack4Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMenuNotifyClicked)))
        
        menuNotifyBtn.tintColor = .white
        stack4Btn.addSubview(menuNotifyBtn)
        menuNotifyBtn.translatesAutoresizingMaskIntoConstraints = false
        menuNotifyBtn.centerXAnchor.constraint(equalTo: stack4Btn.centerXAnchor).isActive = true
        menuNotifyBtn.centerYAnchor.constraint(equalTo: stack4Btn.centerYAnchor).isActive = true
        menuNotifyBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //ori 30
        menuNotifyBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //test > add notify icon on menu btns
        let menuNotifyNotifyView = UIView()
        menuNotifyNotifyView.backgroundColor = .red
        stack4Btn.addSubview(menuNotifyNotifyView)
        menuNotifyNotifyView.translatesAutoresizingMaskIntoConstraints = false
        menuNotifyNotifyView.leadingAnchor.constraint(equalTo: menuNotifyBtn.trailingAnchor, constant: -5).isActive = true
        menuNotifyNotifyView.bottomAnchor.constraint(equalTo: menuNotifyBtn.topAnchor, constant: 5).isActive = true //10
        menuNotifyNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        menuNotifyNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        menuNotifyNotifyView.layer.cornerRadius = 5 //10
//        menuNotifyNotifyView.isHidden = true
        //
        
        stack5.addSubview(stack5Btn)
        stack5Btn.translatesAutoresizingMaskIntoConstraints = false
        stack5Btn.centerXAnchor.constraint(equalTo: stack5.centerXAnchor).isActive = true
        stack5Btn.centerYAnchor.constraint(equalTo: stack5.centerYAnchor).isActive = true
        stack5Btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack5Btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stack5Btn.isUserInteractionEnabled = true
        stack5Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMenuProfileClicked)))
        
        menuProfileBtn.tintColor = .white
        stack5Btn.addSubview(menuProfileBtn)
        menuProfileBtn.translatesAutoresizingMaskIntoConstraints = false
        menuProfileBtn.centerXAnchor.constraint(equalTo: stack5Btn.centerXAnchor).isActive = true
        menuProfileBtn.centerYAnchor.constraint(equalTo: stack5Btn.centerYAnchor).isActive = true
        menuProfileBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //ori 30
        menuProfileBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //test > add notify icon on menu btns
        let menuProfileNotifyView = UIView()
        menuProfileNotifyView.backgroundColor = .red
        stack5Btn.addSubview(menuProfileNotifyView)
        menuProfileNotifyView.translatesAutoresizingMaskIntoConstraints = false
        menuProfileNotifyView.leadingAnchor.constraint(equalTo: menuProfileBtn.trailingAnchor, constant: -5).isActive = true
        menuProfileNotifyView.bottomAnchor.constraint(equalTo: menuProfileBtn.topAnchor, constant: 5).isActive = true //10
        menuProfileNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        menuProfileNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        menuProfileNotifyView.layer.cornerRadius = 5 //10
        menuProfileNotifyView.isHidden = true
        //
        
//        let stackView = UIStackView(arrangedSubviews: [stack1, stack2, stack3, stack4, stack5])
        stackView.addArrangedSubview(stack1)
        stackView.addArrangedSubview(stack2)
        stackView.addArrangedSubview(stack3)
        stackView.addArrangedSubview(stack4)
        stackView.addArrangedSubview(stack5)
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black
//        stackView.backgroundColor = .blue
        self.view.addSubview(stackView)
//        menuPanelSafeArea.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true //ori 60
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //test > change UI for app menu mode
        changeAppMenuMode(mode: "home")
        
        //test > initialize app scrollable id => for rendering markers(prevent markers conflict between panels)
        vcScrollableId = generateRandomId()
        appScrollableId = vcScrollableId
        
        //test > fetch data
        //test 3 > heatmap
        getHeatmapPoints()
        
        //test > fetch place point
        getSinglePlacePoint()
    
        //test > blur effect
        //method 1: blur effect => not good
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        view.addSubview(blurEffectView)
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
////        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.layer.opacity = 0.9
        
        //method 2
//        let abView = UIView(frame: CGRect(x: 0 , y: 0, width: view.frame.width, height: view.frame.height))
//        view.addSubview(abView)
//        abView.translatesAutoresizingMaskIntoConstraints = false
//        abView.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        abView.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        abView.backgroundColor = .clear
//        let imageView = UIImageView()
//        view.addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        imageView.image = convertImageToBW(image: abView.createImage())
        
        //test > confetti
//        createParticles()
        
        //test > cache check folder
        CacheManager.shared.createDirectoryForVideoCache()
        
        let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_video_4.mp4?alt=media"
//        let videoURL = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
        CacheManager.shared.cacheVideoFile(stringUrl: videoURL) { result in

            switch result {
            case .success(let url):
                print("cachevideo succeed: \(url)")
                break
            case .failure:
                print("cachevideo fail: ")
                break
            }
        }
        
        //test > data manager to simulate data => to be removed in future
        DataManager.shared.initData()
        
        //test > location selection
        addLocationSelect()

        //test > yellow location select marker
        //yellow
        guard let mapView = mapView else {
            return
        }
        
//////        let locationSelectMarker = UIImageView()
////        locationPinner.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
//        locationPinner.image = UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate)
////        locationPinner.tintColor = .yellow
//        locationPinner.tintColor = .white
//        self.view.addSubview(locationPinner)
//        locationPinner.translatesAutoresizingMaskIntoConstraints = false
////        locationPinner.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -150/2).isActive = true//y-adjustment = paddingBottom/2
//        locationPinner.bottomAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -150/2).isActive = true//y-adjustment = paddingBottom/2
//        locationPinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        locationPinner.heightAnchor.constraint(equalToConstant: 30).isActive = true //70
//        locationPinner.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        locationPinner.layer.shadowColor = UIColor.ddmBlackOverlayColor.cgColor
//        locationPinner.layer.shadowRadius = 3.0  //ori 3
//        locationPinner.layer.shadowOpacity = 0.5 //ori 1
//        locationPinner.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
//        locationPinner.isHidden = true
        
        //test 1 > custom view for pinner**
//        pinner = LocationPinMarker(frame: CGRect(x: 0 , y: 0, width: 30, height: 30))
//        guard let pinner = pinner else {
//            return
//        }
//        self.view.addSubview(pinner)
//        pinner.translatesAutoresizingMaskIntoConstraints = false
//        pinner.bottomAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -150/2).isActive = true//y-adjustment = paddingBottom/2
//        pinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        pinner.isHidden = true
        
        //test > yellow arrow as pin
//        let selectedArrow = UIImageView()
//        selectedArrow.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
//        selectedArrow.tintColor = .yellow
//        self.view.addSubview(selectedArrow)
//        selectedArrow.translatesAutoresizingMaskIntoConstraints = false
//        selectedArrow.bottomAnchor.constraint(equalTo: lSelectMarker.topAnchor, constant: -10).isActive = true
//        selectedArrow.centerXAnchor.constraint(equalTo: lSelectMarker.centerXAnchor).isActive = true
//        selectedArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true //70
//        selectedArrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        selectedArrow.layer.shadowColor = UIColor.ddmBlackOverlayColor.cgColor
//        selectedArrow.layer.shadowRadius = 3.0  //ori 3
//        selectedArrow.layer.shadowOpacity = 0.5 //ori 1
//        selectedArrow.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
//        var selectedArrow = TriangleView()
//        locationPinner.addSubview(selectedArrow)//test
//        selectedArrow.translatesAutoresizingMaskIntoConstraints = false
//        selectedArrow.bottomAnchor.constraint(equalTo: lSelectMarker.topAnchor, constant: -10).isActive = true
//        selectedArrow.centerXAnchor.constraint(equalTo: lSelectMarker.centerXAnchor).isActive = true
//        selectedArrow.heightAnchor.constraint(equalToConstant: 7).isActive = true
//        selectedArrow.widthAnchor.constraint(equalToConstant: 14).isActive = true
//        selectedArrow.changeFillColor(color:UIColor.yellow)
//        selectedArrow.layer.shadowColor = UIColor.ddmBlackOverlayColor.cgColor
//        selectedArrow.layer.shadowRadius = 3.0  //ori 3
//        selectedArrow.layer.shadowOpacity = 0.5 //ori 1
//        selectedArrow.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
    }
    
    //*test > refactor semitransparent textbox
    func turnOnPlacesMiniSemiTransparent(type: String) {
        
        pSemiTransparentTextBox.isHidden = true //test
        aSemiTransparentTextBox.isHidden = true //test
        uSemiTransparentTextBox.isHidden = true //test
        lSemiTransparentTextBox.isHidden = true //test
        cSemiTransparentTextBox.isHidden = true //test
        sSemiTransparentTextBox.isHidden = true //test
        
        if(type == "") {
        } else if(type == "a") {
            aSemiTransparentTextBox.isHidden = false //test
        } else if(type == "p") {
            pSemiTransparentTextBox.isHidden = false //test
        } else if(type == "u") {
            uSemiTransparentTextBox.isHidden = false //test
        } else if(type == "l") {
            lSemiTransparentTextBox.isHidden = false //test
        } else if(type == "c") {
            cSemiTransparentTextBox.isHidden = false //test
        } else if(type == "s") {
            sSemiTransparentTextBox.isHidden = false //test
        }
    }
    //*

    //test > location selection box
    let aBoxUnder = UIView()
    let aBoxBG = UIView()
    let gBtn = UIView()
    var aBoxTopCons: NSLayoutConstraint?
    var gBoxTopCons: NSLayoutConstraint?
    func addLocationSelect() {
        //method 2 => slide up panel for more detail
        self.view.addSubview(aBoxUnder)
        aBoxUnder.backgroundColor = .ddmBlackOverlayColor
        aBoxUnder.translatesAutoresizingMaskIntoConstraints = false
        aBoxUnder.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        aBoxUnder.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        aBoxUnder.layer.opacity = 0.3
        aBoxUnder.isHidden = true
        
//        let aBoxBG = UIView()
        aBoxBG.backgroundColor = .ddmBlackOverlayColor
        aBoxBG.layer.cornerRadius = 10
        self.view.addSubview(aBoxBG)
        aBoxBG.translatesAutoresizingMaskIntoConstraints = false
//        aBoxBG.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300).isActive = true
        aBoxTopCons = aBoxBG.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        aBoxTopCons?.isActive = true
        aBoxBG.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        aBoxBG.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true

//        let gBtn = UIView()
        aBoxBG.addSubview(gBtn)
        gBtn.backgroundColor = .yellow
        gBtn.translatesAutoresizingMaskIntoConstraints = false
        gBtn.centerXAnchor.constraint(equalTo: aBoxBG.centerXAnchor, constant: 0).isActive = true
//        gBtn.leadingAnchor.constraint(equalTo: aBoxBG.leadingAnchor, constant: 30).isActive = true
        gBoxTopCons = gBtn.topAnchor.constraint(equalTo: aBoxBG.topAnchor, constant: 30)
        gBoxTopCons?.isActive = true
        gBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        gBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gBtn.layer.cornerRadius = 10
        gBtn.isUserInteractionEnabled = true
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLocationSelectExitClicked)))
    }
    @objc func onSemiArrowClicked(gesture: UITapGestureRecognizer) {
        //method 1 > slide up animation
//        UIView.animate(withDuration: 0.2, animations: {
//            self.aBoxTopCons?.constant = -self.view.frame.height + 200
//            self.aBoxBG.superview?.layoutIfNeeded()
//        }, completion: { _ in
//
//        })
//        aBoxUnder.isHidden = false
        
        stopPulseWave()
        dequeueObject()
        //test > dismiss RHS content filter btn
        hideRMapSettingBtn()
        
        //method 2 > slide up without animation
        openPlaceSelectPanel()
    }
    
    func openPlaceSelectPanel() {
        let panel = PlaceSelectPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize()
    }
    
    @objc func onLocationSelectExitClicked(gesture: UITapGestureRecognizer) {
        print("onLocationSelectExitClicked")
        UIView.animate(withDuration: 0.2, animations: {
            self.aBoxTopCons?.constant = 0
            self.aBoxBG.superview?.layoutIfNeeded()
        }, completion: { _ in

        })
        aBoxUnder.isHidden = true
    }
    
    //*test > start and stop particles confetti
    @objc func onRefreshClicked(gesture: UITapGestureRecognizer) {
        stopParticles()
    }
    @objc func onGpsClicked(gesture: UITapGestureRecognizer) {
        print("ongpsclick")
        startParticles()
    }
    //*
    
    @objc func onMenuHomeClicked(gesture: UITapGestureRecognizer) {
        changeAppMenuMode(mode: "home")
    }
    @objc func onMenuSearchClicked(gesture: UITapGestureRecognizer) {
        changeAppMenuMode(mode: "search")
    }
    @objc func onMenuNotifyClicked(gesture: UITapGestureRecognizer) {
        changeAppMenuMode(mode: "notify")
    }
    @objc func onMenuProfileClicked(gesture: UITapGestureRecognizer) {
        changeAppMenuMode(mode: "profile")
    }
    @objc func onMenuCreateClicked(gesture: UITapGestureRecognizer) {
        changeAppMenuMode(mode: "create")
    }
    
    func changeAppMenuMode(mode: String) {
        
//        let lastAppMenuMode = appMenuMode
        
        //test > dequeue before transition
        stopPulseWave()
        dequeueObject()
        //test > dismiss RHS content filter btn
        hideRMapSettingBtn()
        
        appMenuMode = mode
        
        menuHomeBtn.image = UIImage(named:"icon_outline_home")?.withRenderingMode(.alwaysTemplate)
        menuSearchBtn.image = UIImage(named:"icon_outline_explore")?.withRenderingMode(.alwaysTemplate)
        menuNotifyBtn.image = UIImage(named:"icon_outline_inbox")?.withRenderingMode(.alwaysTemplate)
        menuProfileBtn.image = UIImage(named:"icon_outline_account")?.withRenderingMode(.alwaysTemplate)
        menuProfileBtn.tintColor = .white
        
        searchPanel.isHidden = true
        notifyPanel.isHidden = true
        mePanel.isHidden = true
        
        if(mode == "home") {
            menuHomeBtn.image = UIImage(named:"icon_round_home")?.withRenderingMode(.alwaysTemplate)
        } else if(mode == "search") {
//            aSearchRound.isHidden = false
            menuSearchBtn.image = UIImage(named:"icon_round_explore")?.withRenderingMode(.alwaysTemplate)
            searchPanel.isHidden = false
//            searchPanel.activate()
            
            //test > fetch data when initialize()
//            searchPanel.initialize()
            searchPanel.initialize(width: self.view.frame.width, height: self.view.frame.height)
        } else if(mode == "create") {
            //test 1 > try video creator
//            openVideoCreatorPanel()
            
            //test 2 > create options
//            openCreateSelectPanel(lastMenuMode: lastAppMenuMode)
            openCreateSelectPanel(lastMenuMode: "home")//default to "home"
            
        } else if(mode == "notify") {
            menuNotifyBtn.image = UIImage(named:"icon_round_inbox")?.withRenderingMode(.alwaysTemplate)
            notifyPanel.isHidden = false
            
            //test > fetch data when initialize()
//            notifyPanel.initialize()
            notifyPanel.initialize(width: self.view.frame.width, height: self.view.frame.height)
            
        } else if(mode == "profile") {
            menuProfileBtn.image = UIImage(named:"icon_round_account_b")?.withRenderingMode(.alwaysTemplate)
            
            //test > me panel
            mePanel.isHidden = false
//            mePanel.initialize()
            mePanel.initialize(width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    func openCreateSelectPanel(lastMenuMode: String) {
        
        //test > try another way -> using optional
//        print("openCreateSelectPanel \(createSelectPanel)")
        createSelectPanel = CreateSelectPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        guard let createSelectPanel = self.createSelectPanel else {
            return
        }
        self.view.addSubview(createSelectPanel)
        createSelectPanel.translatesAutoresizingMaskIntoConstraints = false
        createSelectPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        createSelectPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        createSelectPanel.setLastAppMenuMode(mode: lastMenuMode)
        createSelectPanel.delegate = self
        createSelectPanel.initialize(width: view.frame.width, height: view.frame.height)
    }
    
    //test > signout progress view
    func openSignoutProgressPanel() {
        signoutProgressPanel = SignoutProgressView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        guard let signoutProgressPanel = self.signoutProgressPanel else {
            return
        }
        self.view.addSubview(signoutProgressPanel)
        signoutProgressPanel.translatesAutoresizingMaskIntoConstraints = false
        signoutProgressPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        signoutProgressPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("state map ready")

        mapRefreshObjectsProjectionPoints(withAnimation: true)
        mapCheckCollisionPoints(withAnimation: true)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
//        print("state map idle")
        
        //test > auto adjust to zero viewing angle and tilt angle
        //like in Apple Maps
        let bearing = mapView.camera.bearing
        let viewingAngle = mapView.camera.viewingAngle
        print("state map idle: \(mapView.camera.target.latitude), \(mapView.camera.zoom)")
//        print("bearing: \(bearing), \(viewingAngle)")
        if(bearing != 0 || viewingAngle != 0) {
            mapReorientMapAngles()
        }
        
        mapRefreshObjectsProjectionPoints(withAnimation: true)
//        mapCheckCollisionPoints(withAnimation: true) //just waste of compute power
        
        //test > pinner
        lPinner?.dehoverPin()
    }
    
    var currentMapZoom: Float = 0.0
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("state map change \(position.zoom), \(position), \(mapView.projection.visibleRegion())")
        
        if(!isMapZooming) {
            mapRefreshObjectsProjectionPoints(withAnimation: true)
            
            //for zoom-sensitive operations
            if(currentMapZoom != position.zoom) {

                //test 1 > change opacity while map-zooming
                //=> not implement coz problem when open half mode place panel, white screen appear
                for entry in markerList {
                    entry.changeSize(zoomLevel: CGFloat(position.zoom))
                }

                //test collision algo between markers
                print("map move check collision")
                mapCheckCollisionPoints(withAnimation: true)
            }
            
            currentMapZoom = position.zoom
            
            //test > pinner
            lPinner?.hoverPin()
        }
        
        //test > remove pulsewave if move map
        stopPulseWave()
        dequeueObject()
        
        //test > dismiss RHS content filter btn
        hideRMapSettingBtn()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate : CLLocationCoordinate2D ) {
        print("state map tap")
        print("Mapmap tap \(coordinate)")
        print("async pulsewave start: \(pulseWaveList)")

        //test > remove pulsewave without removing from array, but by pulsating
        stopPulseWave()
        
        //test > dismiss RHS content filter btn
        hideRMapSettingBtn()
        
        //test 2 > exclude LocationSelectPanel from pulsewave
        if(pageList.isEmpty) {
            //create new pulsewave
            let zoom = mapView.camera.zoom
            let point = mapView.projection.point(for: coordinate)
            let pulseWave = PulseWave(frame: CGRect(x: point.x - MAX_MARKER_DIM/2 , y: point.y - MAX_MARKER_DIM/2, width: MAX_MARKER_DIM, height: MAX_MARKER_DIM))
            pulseWave.addLocation(coordinate: coordinate)
            pulseWave.isUserInteractionEnabled = false
            self.view.insertSubview(pulseWave, aboveSubview: mapView) //put below markers
            pulseWaveList.append(pulseWave)
            pulseWave.delegate = self //test
            pulseWave.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
            pulseWave.frame.origin.x = point.x - pulseWave.frame.width/2 //update position after changesize()
            pulseWave.frame.origin.y = point.y - pulseWave.frame.height/2
            
            //test > add queue and fetch data
            dequeueObject()
            let qId = addQueueObject()
            if(qId != -1) {
                pulseWave.setId(id: qId)
                
                asyncFetchData(id: qId, coordinate: coordinate)
            }
        } else {
            if let c = pageList[pageList.count - 1] as? LocationSelectScrollablePanelView {
                
            } else {
                //create new pulsewave
                let zoom = mapView.camera.zoom
                let point = mapView.projection.point(for: coordinate)
                let pulseWave = PulseWave(frame: CGRect(x: point.x - MAX_MARKER_DIM/2 , y: point.y - MAX_MARKER_DIM/2, width: MAX_MARKER_DIM, height: MAX_MARKER_DIM))
                pulseWave.addLocation(coordinate: coordinate)
                pulseWave.isUserInteractionEnabled = false
                self.view.insertSubview(pulseWave, aboveSubview: mapView) //put below markers
                pulseWaveList.append(pulseWave)
                pulseWave.delegate = self //test
                pulseWave.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
                pulseWave.frame.origin.x = point.x - pulseWave.frame.width/2 //update position after changesize()
                pulseWave.frame.origin.y = point.y - pulseWave.frame.height/2
                
                //test > add queue and fetch data
                dequeueObject()
                let qId = addQueueObject()
                if(qId != -1) {
                    pulseWave.setId(id: qId)
                    
                    asyncFetchData(id: qId, coordinate: coordinate)
                }
            }
        }
    }
    
    func deactivateQueueState() {
        if(!queueObjectList.isEmpty) {
            queueObjectList[queueObjectList.count - 1].setIsPanelActive(isActive: false)
        }
    }
    func activateQueueState() {
        if(!queueObjectList.isEmpty) {
            queueObjectList[queueObjectList.count - 1].setIsPanelActive(isActive: true)
        }
    }
    //test > dequeue ops
    func dequeueObject() {
        if(!queueObjectList.isEmpty) {
            queueObjectList[queueObjectList.count - 1].setIsToOpenPanel(isToOpen: false)
        }
    }
    //test > generate random id to connect marker and resultant video panel
    func addQueueObject() -> Int {
        var isAllowedToAddNewQueue = false
        if(!queueObjectList.isEmpty) {       
            //only allow to add new queue if panel is not active
            if(!queueObjectList[queueObjectList.count - 1].getIsPanelActive()) {
                isAllowedToAddNewQueue = true
            }
        } else {
            isAllowedToAddNewQueue = true
        }
        
        if(isAllowedToAddNewQueue) {
            let q = QueueObject()
            q.setIsToOpenPanel(isToOpen: true)
            queueObjectList.append(q)
            
            let randomInt = generateRandomId()
            q.setId(id: randomInt)
            return randomInt
        } else {
            return -1
        }
    }
    //test > async fetch data for pulsewave
    func asyncFetchData(id: Int, coordinate : CLLocationCoordinate2D) {
        DataFetchManager.shared.fetchPulsewaveData(id: id) { [weak self]result in
//        api.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    
                    //test > queueobject
                    guard let z = self?.queueObjectList else {
                        return
                    }
                    guard let x = self?.pulseWaveList else {
                        return
                    }
                    guard let mapView = self?.mapView else {
                        return
                    }
                    guard let view = self?.view else {
                        return
                    }
                    
                    let bb = z.isEmpty
                    let aa = z.count

                    let b = x.isEmpty
                    let a = x.count
                    print("api success \(id), \(l), \(bb), \(b)")

                    if(!bb && !b) {
                        guard let cc = self?.queueObjectList[aa - 1] else {
                            return
                        }
                        guard let c = self?.pulseWaveList[a - 1] else {
                            return
                        }
                        
                        let point = mapView.projection.point(for: coordinate)
                        let midX = view.frame.width/2
                        let midY = view.frame.height/2
                        let offsetX = point.x - midX
                        let offsetY = point.y - midY
                        
                        let d = cc.getIsToOpenPanel()
                        let id = cc.getId()
                        print("api success post B \(id), \(l), \(id)")
                        let lId = Int(l[0]) //test
                        if(id == c.getId() && lId == id) {
                            if(d) {
                                print("async pulsewave start open video: ")
                                //test > open panel according to content type filter
                                if(self?.xContentDataType == "loop") {
                                    self?.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: c, originatorViewType: OriginatorTypes.PULSEWAVE, id: id)
                                } else if(self?.xContentDataType == "shot") {
                                    self?.openPhotoPanel(offX: offsetX, offY: offsetY, originatorView: c, originatorViewType: OriginatorTypes.PULSEWAVE, id: id)
                                } else {
                                    self?.openPostPanel(offX: offsetX, offY: offsetY, originatorView: c, originatorViewType: OriginatorTypes.PULSEWAVE, id: id)
                                }
                            } else {
                                //close pulsewave with animation => it works
    //                                c.stopPulsatingWithAnimation(delay: 0.0)
                                //implement taptic feedback if not video found
//                                let feedbackGenerator = UINotificationFeedbackGenerator()
//                                feedbackGenerator.prepare()
//                                feedbackGenerator.notificationOccurred(.error)
                            }
                        }
                    }
                    
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func stopPulseWave() {
        if(!pulseWaveList.isEmpty) {
            pulseWaveList[pulseWaveList.count - 1].stopPulsatingWithAnimation(duration: 0.1, delay: 0)
        }
    }
    
    //test > shutter semi image for when video panel closes
    func shutterSemiTransparentGifImage() {
        UIView.animate(withDuration: 0.1,
            animations: {
                self.semiGifImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.semiGifImage.layer.opacity = 0.0
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], //test 0.3 delay
                    animations: {
                        self.semiGifImage.transform = CGAffineTransform.identity
                        self.semiGifImage.layer.opacity = 1.0
                    },
                    completion: { _ in
                    })
            })
    }
    //test > hide semi image when video panel opens
    func hideSemiTransparentGifImage(){
        self.semiGifImage.layer.opacity = 0.0
    }
    func dehideSemiTransparentGifImage(){
        self.semiGifImage.layer.opacity = 1.0
    }
    
    @objc func onSemiGifClicked(gesture: UITapGestureRecognizer) {

        //test > get point on screen of tap action
        let x = semiGifImageOuter.frame.origin.x
        let y = semiGifImageOuter.frame.origin.y
        let width = semiGifImageOuter.frame.size.width
        let height = semiGifImageOuter.frame.size.height
        
        //test > offset
        let x1 = aSemiTransparentTextBox.frame.origin.x
        let y1 = aSemiTransparentTextBox.frame.origin.y
        
        print("origin semigif: \(x), \(y), \(x1), \(y1)")
        let offsetX = x + width/2 - self.view.frame.width/2 + x1
        let offsetY = y + height/2 - self.view.frame.height/2 + y1

        dequeueObject()
        let qId = addQueueObject()
        if(qId != -1) {
            semiGifImageOuter.setId(id: qId)
        }
        
        //result
        if(!queueObjectList.isEmpty) {
            let d = queueObjectList[queueObjectList.count - 1].getIsToOpenPanel()
            let id = queueObjectList[queueObjectList.count - 1].getId()
            if(id == semiGifImageOuter.getId()) {
                if(d) {
                    print("async pulsewave start open video: ")
                    self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: semiGifImage, originatorViewType: OriginatorTypes.MAP_TOP_UIVIEW, id: id)
                }
            }
        }
    }
    
    func changeMapPadding(padding: CGFloat) {
        let topInset = self.view.safeAreaInsets.top
        let bottomInset = self.view.safeAreaInsets.bottom
        let mapBottomPadding = bottomInset + padding
        print("changeMapPadding: \(bottomInset), \(padding), \(topInset)")

        mapView?.padding = UIEdgeInsets(
          top: 0,
          left: 0,
          bottom: padding,
          right: 0)
    }
    
    func mapDisappearMarkers() {
//        print("state mapDisappearMarkers \(markerList.count)")
        if(!markerList.isEmpty) {
            for entry in markerList {

                if(entry.isInitialized && entry.isOnScreen) {
                    entry.disappear()
                }
            }
        }
        if(!pulseWaveList.isEmpty) {
            for entry in pulseWaveList {
                entry.stopPulsatingWithAnimation(duration: 0.1, delay: 0)
            }
        }
    }
    
    func mapReappearMarkers() {
        print("state mapReappearMarkers \(markerList.count)")
        if(!markerList.isEmpty) {
            for entry in markerList {

                if(entry.isInitialized && entry.isOnScreen) {
                    entry.reappear()
                }
            }
        }
        if(!pulseWaveList.isEmpty) {
            for entry in pulseWaveList {
                entry.stopPulsatingWithAnimation(duration: 0.1, delay: 0)
            }
        }
    }
    
    //test > remove markers from map
    func mapRemoveMarkers() {
        print("state mapRemoveMarkers \(markerList.count)")
        if(!markerList.isEmpty) {
            for entry in markerList {
                entry.close()
            }
            markerList.removeAll()
        }

        if(!pulseWaveList.isEmpty) {
            for entry in pulseWaveList {
                entry.close()
            }
            pulseWaveList.removeAll()
        }
        
        //test
        if(!markerGeoMarkerIdList.isEmpty) {
            markerGeoMarkerIdList.removeAll()
        }
        
        //test
        isCollided = false
    }
    
    func mapReinstateMarkers(withAnimation: Bool) {
        print("state mapReinstateMarkers \(markerList.count)")
        for entry in self.geohashList{
            guard let mapView = self.mapView else {
                return
            }
            let markerId = entry.value[0]
//            if var geo = self.markerGeoList[markerId] {
            if var g = self.markerGeoList[markerId] {
                let zoom = mapView.camera.zoom
                let geo = g.getGeoCoord()
                let geoType = g.getGeoType()
                let point = mapView.projection.point(for: geo)
                print("refresh markers create x: \(point.x)")

                //tets 1 > explore marker only
//                let marker = ExploreMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                marker.addLocation(coordinate: geo)
//                self.view.insertSubview(marker, aboveSubview: mapView)
//                self.markerList.append(marker)
//                marker.delegate = self
////                marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
//                marker.initialize(withAnimation: false, changeSizeZoom: CGFloat(zoom))
//                marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
//                marker.frame.origin.y = point.y - marker.frame.height
                
                //test 2 > multi type markers
//                var marker : Marker?
//                if(geoType == GeoDataTypes.MARKER) {
//                    marker = ExploreMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                } else if (geoType == GeoDataTypes.USERMARKER) {
//                    marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                } else if (geoType == GeoDataTypes.PLACEMARKER) {
//                    marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                }
//                if let marker = marker {
//                    marker.addLocation(coordinate: geo)
//                    self.view.insertSubview(marker, aboveSubview: mapView)
//                    self.markerList.append(marker)
//                    marker.delegate = self
//                    marker.initialize(withAnimation: withAnimation, changeSizeZoom: CGFloat(zoom))
//                    marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
//                    marker.frame.origin.y = point.y - marker.frame.height
//
//                    //test > markerId map to marker list
//                    self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
//                    marker.setMarkerId(markerId: markerId)
//                }
                
                //test 3 > scrollable id
                print("show mapReinstateMarkers \(vcScrollableId), \(appScrollableId)")
                if(appScrollableId == vcScrollableId) {
                    var marker : Marker?
                    if(geoType == GeoDataTypes.MARKER) {
//                        marker = ExploreMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        //test > new rectangular marker
//                        marker = ExploreBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                        marker = ExploreAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                        marker = PhotoBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        //test
                        if(xContentDataType == "shot") {
                            marker = PhotoBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        } else if(xContentDataType == "loop") {
                            marker = ExploreBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        } else if(xContentDataType == "post") {
                            marker = PostMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        }
                    } else if (geoType == GeoDataTypes.USERMARKER) {
                        marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    } else if (geoType == GeoDataTypes.PLACEMARKER) {
                        marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    }
                    if let marker = marker {
                        marker.addLocation(coordinate: geo)
                        self.view.insertSubview(marker, aboveSubview: mapView)
                        self.markerList.append(marker)
                        marker.delegate = self
                        marker.setScreenSizeLimit(width: self.view.frame.width, height: self.view.frame.height)
                        //test
                        marker.configure(data: "a")
                        marker.initialize(withAnimation: withAnimation, changeSizeZoom: CGFloat(zoom))
                        
                        //test > width offset for irregular shaped marker
                        marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                        marker.frame.origin.y = point.y - marker.frame.height
                        
                        //test > markerId map to marker list
                        self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                        marker.setMarkerId(markerId: markerId)
                    }
                }
            }
        }
        
        //test 3 > use check whether latestuserlocation exist, if yes, reinstate marker
        guard let latestUserLocation = self.latestUserLocation else {
            return
        }
        guard let mapView = self.mapView else {
            return
        }
        let zoom = mapView.camera.zoom
        let point = mapView.projection.point(for: latestUserLocation)
        let marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
        marker.addLocation(coordinate: latestUserLocation)
        self.view.insertSubview(marker, aboveSubview: mapView)
        self.markerList.append(marker)
        marker.delegate = self
        //test
        marker.configure(data: "a")
        marker.initialize(withAnimation: false, changeSizeZoom: CGFloat(zoom))
        
        marker.frame.origin.x = point.x - marker.widthOriginOffset/2
        marker.frame.origin.y = point.y - marker.frame.height
        
        //test > markerId map to marker list
        self.markerGeoMarkerIdList.updateValue(marker, forKey: OriginatorId.USER_LOCATION_MARKER_ID)
        marker.setMarkerId(markerId: OriginatorId.USER_LOCATION_MARKER_ID)
    }
    
    func mapReinstateScrollableMarkers(c: ScrollablePanelView, withAnimation: Bool) {
        //test 1 => it works OK
//        guard let mapView = self.mapView else {
//            return
//        }
//        let point = mapView.projection.point(for: c.placeMarkerGeoList[0])
//        let zoom = mapView.camera.zoom
//        print("marker projection point \(point)")
//
//        //test > add place marker
////        let marker = PlaceAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//        let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//        marker.addLocation(coordinate: c.placeMarkerGeoList[0])
//        self.view.insertSubview(marker, aboveSubview: mapView)
//        self.markerList.append(marker) //test
//        marker.delegate = self
//        marker.initialize(withAnimation: withAnimation, changeSizeZoom: CGFloat(zoom))
//        marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
//        marker.frame.origin.y = point.y - marker.frame.height
        
        //test 2 > new method
        guard let mapView = self.mapView else {
            return
        }
//        let markerId = c.placeMarkerIdList[0]
        for entry in c.markerIdList{
            let markerId = entry
            if var g = self.markerGeoList[markerId] {
                let zoom = mapView.camera.zoom
                let geo = g.getGeoCoord()
                let geoType = g.getGeoType()
                let point = mapView.projection.point(for: geo)

//                let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                marker.addLocation(coordinate: geo)
//                self.view.insertSubview(marker, aboveSubview: mapView)
//                self.markerList.append(marker) //test
//                marker.delegate = self
//                marker.initialize(withAnimation: withAnimation, changeSizeZoom: CGFloat(zoom))
//                marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
//                marker.frame.origin.y = point.y - marker.frame.height
//
//                //test > markerId map to marker list
//                self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
//                marker.setMarkerId(markerId: markerId)
                
                //test 3 > scrollable id
                print("show mapReinstateScrollableMarkers \(c.getScrollableId()), \(appScrollableId), \(geoType), \(c)")
                if(appScrollableId == c.getScrollableId()) {
                    var marker : Marker?
                    if let d = c as? PlaceScrollablePanelView {
                        print("show mapReinstateScrollableMarkers 1")
                        marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    } else if let e = c as? UserScrollablePanelView {
                        print("show mapReinstateScrollableMarkers 2")
                        marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    } else if let f = c as? PlacesMiniScrollablePanelView {
                        print("show mapReinstateScrollableMarkers 3")
                        marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    } else if let g = c as? UsersMiniScrollablePanelView {
                        print("show mapReinstateScrollableMarkers 3")
                        marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    }
                    
//                    let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    if let marker = marker {
                        marker.addLocation(coordinate: geo)
                        self.view.insertSubview(marker, aboveSubview: mapView)
                        self.markerList.append(marker) //test
                        marker.delegate = self
                        //test
                        marker.configure(data: "a")
                        marker.initialize(withAnimation: withAnimation, changeSizeZoom: CGFloat(zoom))
                        
                        marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                        marker.frame.origin.y = point.y - marker.frame.height
        
                        //test > markerId map to marker list
                        self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                        marker.setMarkerId(markerId: markerId)
                    }
                }
            }
        }
    }
    
    //test > scrollable id to prevent markers conflict between scrollable panels
    func mapReinstateScrollableId() {
        appScrollableId = vcScrollableId
        print("show mapReinstateScrollableId: \(vcScrollableId), \(appScrollableId)")
    }
    
    func mapReinstateScrollableId(c: ScrollablePanelView) {
        appScrollableId = c.getScrollableId()
        print("show mapReinstateScrollableId c: \(c.getScrollableId()), \(appScrollableId)")
    }
    
    func mapRevertMarkerTransition(withAnimation: Bool) {
        mapRemoveMarkers()
        mapView?.moveCamera(GMSCameraUpdate.setTarget(getStateTarget(), zoom: getStateZoom()))
        mapReinstateScrollableId()//test > scrollableId
        mapReinstateMarkers(withAnimation: withAnimation)
        mapRefreshObjectsProjectionPoints(withAnimation: withAnimation)
        mapCheckCollisionPoints(withAnimation: withAnimation)
    }
    
    func mapRevertScrollableMarkerTransition(c: ScrollablePanelView, withAnimation: Bool) {
        print("mapRevertScrollable: \(c.getStateTarget()), \(c.getStateZoom())")
        mapRemoveMarkers()
        c.correctMapPadding() //change map padding back to half mode
        mapView?.moveCamera(GMSCameraUpdate.setTarget(c.getStateTarget(), zoom: c.getStateZoom()))
        mapReinstateScrollableId(c: c)//test > scrollableId
        mapReinstateScrollableMarkers(c: c, withAnimation: withAnimation)
        mapRefreshObjectsProjectionPoints(withAnimation: withAnimation)
        mapCheckCollisionPoints(withAnimation: withAnimation)
    }
    
    func mapReorientMapAngles(){
        guard let zoom = mapView?.camera.zoom else {
            return
        }
        guard let target = mapView?.camera.target else {
            return
        }

        let fancy = GMSCameraPosition(
            target: target,
            zoom: zoom,
            bearing: 0,
            viewingAngle: 0
        )
        let x = GMSCameraUpdate.setCamera(fancy)
        mapView?.animate(with: x)
    }
    //test > custom map zoom with margin adjustment
    func mapAdjustMargin(lat: CGFloat){
        guard let zoom = mapView?.camera.zoom else {
            return
        }
        guard let target = mapView?.camera.target else {
            return
        }
        let fancy = GMSCameraPosition(
            target: CLLocationCoordinate2D(latitude: lat, longitude: target.longitude),
            zoom: 2,
            bearing: 0,
            viewingAngle: 0
        )
        let x = GMSCameraUpdate.setCamera(fancy)
        mapView?.animate(with: x)
    }
    //test > map zoom animation with spring coefficient
    //for smooth and springy effect when zoom out
    func mapAnimate(withSpringEffect: Bool){
        var springCoefficient: Float = 0.0 //zoom out a little than original for spring effect
        if(withSpringEffect) {
            springCoefficient = 0.1
        }
        guard let zoom = mapView?.camera.zoom else {
            return
        }
        guard let target = mapView?.camera.target else {
            return
        }
        let fancy = GMSCameraPosition(
            target: target,
            zoom: zoom - springCoefficient,
            bearing: 0,
            viewingAngle: 0
        )
        let x = GMSCameraUpdate.setCamera(fancy)
        mapView?.animate(with: x)
    }
    
    //test remove and re-add heatmaps
    var mapZoomGeoList = [Int : [GMUWeightedLatLng]]()
    var mapZoomGeohashList = [Int : [String]]()
    var heatmapMapZoom = -1
    
    func refreshHeatmap(mapZoom: Int) {
        if var existingValues = self.mapZoomGeoList[mapZoom] {
            self.heatmapLayer.weightedData = existingValues
            self.heatmapLayer.radius = 100 //100
            
            //refresh heatmap only when mapzoomgeo exist
            self.heatmapLayer.clearTileCache()
            
            //a) 2-color gradient
            let gradientColors: [UIColor] = [.green, .red] // default: .green, .red
            let gradientStartPoints: [NSNumber] = [0.2, 1.0] // default 0.2, 1.0
            
            //b) 3-color gradient
//                    let gradientColors: [UIColor] = [.green, .yellow, .red]
//                    let gradientStartPoints: [NSNumber] = [0.1, 0.3, 1.0]
            
            self.heatmapLayer.gradient = GMUGradient(
              colors: gradientColors,
              startPoints: gradientStartPoints,
              colorMapSize: 256
            )
            
            self.heatmapLayer.map = self.mapView
            
            print("refresh heatmap done: \(mapZoom)")
        }
        
        print("refresh heatmap: \(mapZoom)")
        heatmapMapZoom = mapZoom
    }
    
    func getHeatmapPoints() {
        let id = "g"
        
        //*test > start spinner when start fetching data
        self.aSemiTransparentText.text = ""
        self.arrowBtn.isHidden = true
        self.aSemiTransparentSpinner.startAnimating()
        //*
        
        DataFetchManager.shared.fetchGeoData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("gg getHeatmapPoints api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }
                    
                    //*test > stop spinner when fetch data complete
                    self.aSemiTransparentText.text = "Around You"
                    self.arrowBtn.isHidden = false
                    self.aSemiTransparentSpinner.stopAnimating()
                    //*

                    for i in l {
                        let geoL3 = i.getGeohashL3()
                        let docId = i.getDocId()
                        let coord = i.getGeoCoord()
                        
                        //initialize geohash
                        if !self.geohashList.keys.contains(geoL3) {
                            self.geohashList.updateValue([String](), forKey: geoL3)
                        }
                        
                        //append docid into geohash
                        if var existingValues = self.geohashList[geoL3] {
                            existingValues.append(docId)
                            self.geohashList.updateValue(existingValues, forKey: geoL3)
                        }
                        
                        let geo = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                        let coords = GMUWeightedLatLng(
                            coordinate: geo,
                            intensity: 1.0
                        )
                        self.list.append(coords)
                        
                        //test > add geo to markergeolist
//                            self.markerGeoList.updateValue(geo, forKey: document.documentID)
                        //TODO
                        let g = GeoData()
                        g.setGeoType(type: GeoDataTypes.MARKER)
                        g.setGeoCoord(coord: geo)
                        self.markerGeoList.updateValue(g, forKey: docId)

                        
                        //test > mapzoomgeolist
                        if !self.mapZoomGeoList.keys.contains(2) {
                            self.mapZoomGeoList.updateValue([GMUWeightedLatLng](), forKey: 2)
                        }
                        if var existingValues = self.mapZoomGeoList[2] {
                            existingValues.append(coords)
                            self.mapZoomGeoList.updateValue(existingValues, forKey: 2)
                        }
                        
                        if !self.mapZoomGeoList.keys.contains(14) {
                            self.mapZoomGeoList.updateValue([GMUWeightedLatLng](), forKey: 14)
                        }
                        if var existingValues = self.mapZoomGeoList[14] {
                            existingValues.append(coords)
                            self.mapZoomGeoList.updateValue(existingValues, forKey: 14)
                        }
                    }
                    
                    //test > show heatmap first instead of markers
                    self.refreshHeatmap(mapZoom: 2)
                    
                    //test 0 > test geohash neighbors of clusters
                    var geos = [String]()
                    for entry in self.geohashList {
                        geos.append(entry.key)
                    }
                    for geo in geos {
                        let geoNeighbor = Geohash.neighbors(geo)!
                        for nEntry in geoNeighbor {
                            if(geos.contains(nEntry)) {
                                print("geoL3 n: \(geo), \(nEntry)")
                                //ws, we, wd
                                //wx, wy
                                //gc, u0
                            }
                        }
                    }
                    
                    //test > refactor showing markers in one line
                    self.showHeatmapPoints()
                    
                    //test > map collision test **originally not in firestore fetching code
//                    self.mapCheckCollisionPoints(withAnimation: true)
                    self.mapRefreshObjectsProjectionPoints(withAnimation: true)
                    self.mapCheckCollisionPoints(withAnimation: true)
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
        
        //old method > direct fetch from firestore
//        let db = Firestore.firestore()
//        let docRef = db.collection("post")
//        docRef
//            .whereField("type", isEqualTo: "story")
//            .whereField("is_public", isEqualTo: true)
//            .whereField("is_suspended", isEqualTo: false)
//            .whereField("is_deleted", isEqualTo: false)
//            .whereField("is_published", isEqualTo: true)
//            .order(by: "time_accelerated", descending: true)
//            .limit(to: 20).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("multifetch mainrepo data : \(document.documentID) => \(document.data())")
//                        
//                        //test > use geohash to solve marker overcrowding issue
//                        //geo L3 ~ 78km
//                        let geohashSets = document.get("geohash") as? [String:Any]
//                        if(geohashSets != nil) {
//                            let geoL3 = geohashSets!["L2"] as? String ?? ""
//                            print("geoL3: \(geoL3)")
//                            
//                            //initialize geohash
//                            if !self.geohashList.keys.contains(geoL3) {
//                                self.geohashList.updateValue([String](), forKey: geoL3)
//                            }
//                            
//                            //append docid into geohash
//                            if var existingValues = self.geohashList[geoL3] {
//                                existingValues.append(document.documentID)
//                                self.geohashList.updateValue(existingValues, forKey: geoL3)
//                            }
//                        }
//                        
//                        let geoPoint = document.get("geo") as? GeoPoint
//                        var geo : CLLocationCoordinate2D
//                        if(geoPoint != nil) {
//                            //add heatmap points
//                            geo = CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
//                            let coords = GMUWeightedLatLng(
//                                coordinate: geo,
//                                intensity: 1.0
//                            )
//                            self.list.append(coords)
//                            
//                            //test > add geo to markergeolist
////                            self.markerGeoList.updateValue(geo, forKey: document.documentID)
//                            //TODO
//                            let g = GeoData()
//                            g.setGeoType(type: GeoDataTypes.MARKER)
//                            g.setGeoCoord(coord: geo)
//                            self.markerGeoList.updateValue(g, forKey: document.documentID)
//
//                            
//                            //test > mapzoomgeolist
//                            if !self.mapZoomGeoList.keys.contains(2) {
//                                self.mapZoomGeoList.updateValue([GMUWeightedLatLng](), forKey: 2)
//                            }
//                            if var existingValues = self.mapZoomGeoList[2] {
//                                existingValues.append(coords)
//                                self.mapZoomGeoList.updateValue(existingValues, forKey: 2)
//                            }
//                            
//                            if !self.mapZoomGeoList.keys.contains(14) {
//                                self.mapZoomGeoList.updateValue([GMUWeightedLatLng](), forKey: 14)
//                            }
//                            if var existingValues = self.mapZoomGeoList[14] {
//                                existingValues.append(coords)
//                                self.mapZoomGeoList.updateValue(existingValues, forKey: 14)
//                            }
//                        }
//                    }
//                    
//                    //test > show heatmap first instead of markers
//                    self.refreshHeatmap(mapZoom: 2)
//                    
//                    //test 0 > test geohash neighbors of clusters
//                    var geos = [String]()
//                    for entry in self.geohashList {
//                        geos.append(entry.key)
//                    }
//                    for geo in geos {
//                        let geoNeighbor = Geohash.neighbors(geo)!
//                        for nEntry in geoNeighbor {
//                            if(geos.contains(nEntry)) {
//                                print("geoL3 n: \(geo), \(nEntry)")
//                                //ws, we, wd
//                                //wx, wy
//                                //gc, u0
//                            }
//                        }
//                    }
//                    
//                    //test > refactor showing markers in one line
//                    self.showHeatmapPoints()
//                }
//        }
    }
    
    //test > try show various forms of markers on main
    func generateRandomTypes() -> Int{
        return Int.random(in: 0..<3)
    }
    func showHeatmapPoints() {
        //test > remove markers first beforehand
        mapRemoveMarkers()
        
        //test 1 > algo #0 => show 1 marker from every geohash
//        print("state marker initialized \(generateRandomTypes())")
        for entry in self.geohashList{

            guard let mapView = self.mapView else {
                return
            }
            let markerId = entry.value[0]

            if var g = self.markerGeoList[markerId] {
                let zoom = mapView.camera.zoom
                let geo = g.getGeoCoord()
                let geoType = g.getGeoType()
                let point = mapView.projection.point(for: geo)
                print("refresh markers create x: \(point.x)")
                
                //test 2 check scrollable id
                print("show heatmap scrollableid \(vcScrollableId), \(appScrollableId)")
                if(appScrollableId == vcScrollableId) {
                    var marker : Marker?
//                    let marker = ExploreMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                    let marker = ExploreBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                    let marker = ExploreAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                    let marker = PhotoBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    if(xContentDataType == "shot") {
                        marker = PhotoBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    } else if(xContentDataType == "loop") {
                        marker = ExploreBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    } else if(xContentDataType == "post") {
                        marker = PostMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    }
                    if let marker = marker { //added for Marker?
                        marker.addLocation(coordinate: geo)
                        self.view.insertSubview(marker, aboveSubview: mapView)
                        self.markerList.append(marker)
                        marker.delegate = self
                        marker.setScreenSizeLimit(width: self.view.frame.width, height: self.view.frame.height)
                        //test
                        marker.configure(data: "a")
                        marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))

//                        marker.frame.origin.x = point.x - marker.frame.width/2 //ori
                        marker.frame.origin.y = point.y - marker.frame.height
                        marker.frame.origin.x = point.x - marker.widthOriginOffset/2

                        //test > markerId map to marker list
                        self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                        marker.setMarkerId(markerId: markerId) //test market id
                    }
                }
                
                //test 2 > multi type markers
//                let x = generateRandomTypes()
//                var marker : Marker?
//                if(x == 0) {
//                    marker = ExploreMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                } else if (x == 1) {
//                    marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                } else if (x == 2) {
//                    marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                }
//                if let marker = marker {
//                    marker.addLocation(coordinate: geo)
//                    self.view.insertSubview(marker, aboveSubview: mapView)
//                    self.markerList.append(marker)
//                    marker.delegate = self
//                    marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
//                    marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
//                    marker.frame.origin.y = point.y - marker.frame.height
//
//                    //test > markerId map to marker list
//                    self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
//                    marker.setMarkerId(markerId: markerId)
//                }
            }
        }
        
        //test 2 > algo #1, show marker in sparse geohash area
//                    for entry in self.geohashList {
//                        print("loop geohashList: \(entry.key), \(entry.value.count)")
//                        if(entry.value.count < 2) {
////                        if(entry.value.count > 2) {
//                            let markerId = entry.value[0]
////                            print("loop geohashList: \(entry.key), \(entry.value.count), \(markerId)")
//                            if var geo = self.markerGeoList[markerId] {
//                                guard let mapView = self.mapView else {
//                                    return
//                                }
//                                let point = mapView.projection.point(for: geo)
//                                print("refresh markers create x: \(point.x)")
//
//                                let cgRectMarkerFrame = CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM/2, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM)
//
//                                //test > check collision with projected points on screen
//                                var isBoundedCount = 0
//                                for pointEntry in self.projectedScreenPointList {
//                                    //test 1 > use frame contain point method
////                                    let isBounded = cgRectMarkerFrame.contains(pointEntry)
////                                    print("isBounded: \(isBounded), \(cgRectMarkerFrame)")
////                                    if(isBounded) {
////                                        isBoundedCount += 1
////                                    }
//
//                                    //test 2 > use point to point distance method
//                                    let distX = pointEntry.x - point.x
//                                    let distY = pointEntry.y - point.y
//                                    let powDist = pow(distX,2) + pow(distY,2)
//                                    let sqrtDist = sqrt(powDist)
//                                    var isBounded = false
//                                    print("dist: \(markerId), \(sqrtDist)")
//                                    if(sqrtDist < 44) {
//                                        isBounded = true
//                                    }
//                                    if(isBounded) {
//                                        isBoundedCount += 1
//                                    }
//                                }
//                                if(isBoundedCount == 0) {
//                                    print("geoL3 marker: \(markerId), \(geo)")
//                                    let marker = ExploreMarker(frame: cgRectMarkerFrame)
//                                    marker.addLocation(coordinate: geo)
//                                    self.view.insertSubview(marker, aboveSubview: mapView)
//                                    self.markerList.append(marker)
//                                    marker.delegate = self
//
//                                    self.projectedScreenPointList.append(point)
//                                }
////                                self.projectedScreenPointList.append(point)
//                            }
//                        }
//                    }
        
        //test 3 > algo #2, show only 1 marker in one geoL1 area
//                    for entry in self.geohashList {
//                        let randomInt = Int.random(in: 0..<2)
//                        if(entry.value.count > 1) {
//                            let markerId = entry.value[randomInt]
//                            if var geo = self.markerGeoList[markerId] {
//                                guard let mapView = self.mapView else {
//                                    return
//                                }
//                                let point = mapView.projection.point(for: geo)
//                                print("refresh markers create x: \(point.x)")
//
//                                let marker = ExploreMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM/2, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                                marker.addLocation(coordinate: geo)
//                                self.view.insertSubview(marker, aboveSubview: mapView)
//                                self.markerList.append(marker)
//                                marker.delegate = self
//                            }
//                        }
//                    }
        
        //test > test collision between markers
//                    self.isCollisionDetected(aView: self.markerList[0], bView: self.markerList[1])
        
//                    print("algo #1: \(self.markerList.count)")
        print("algo #1: \(self.mapZoomGeoList)")
    }
    
    func mapCheckCollisionPoints(withAnimation: Bool) {
        guard let mapView = mapView else {
            return
        }

        var indexCollisionCountList = [Int : Int]()
        for (index, element) in markerList.enumerated() {
            for eIndex in index+1..<markerList.count {
                if (
                    element.frame.origin.x < markerList[eIndex].frame.origin.x + markerList[eIndex].frame.width &&
                    element.frame.origin.x + element.frame.width > markerList[eIndex].frame.origin.x &&
                    element.frame.origin.y < markerList[eIndex].frame.origin.y + markerList[eIndex].frame.height &&
                    element.frame.height + element.frame.origin.y > markerList[eIndex].frame.origin.y
                ) {
                    // Collision detected!
                    print("item : true: \(index), \(eIndex)")
                    
                    if !indexCollisionCountList.keys.contains(index) {
                        indexCollisionCountList.updateValue(0, forKey: index)
                    }
                    if !indexCollisionCountList.keys.contains(eIndex) {
                        indexCollisionCountList.updateValue(0, forKey: eIndex)
                    }
                    
                    if var eInt = indexCollisionCountList[index] {
                        if(element.isInitialized) {
                            element.changeInitializeOff(withAnimation: withAnimation)
                        }
                        eInt += 1
                        indexCollisionCountList.updateValue(eInt, forKey: index)
                    }
                    if var eInt = indexCollisionCountList[eIndex] {
                        eInt += 1
                        indexCollisionCountList.updateValue(eInt, forKey: eIndex)
                    }
                } else {
                    // No collision
                    print("item : false: \(index), \(eIndex)")
                    
                    if !indexCollisionCountList.keys.contains(index) {
                        indexCollisionCountList.updateValue(0, forKey: index)
                    }
                    if !indexCollisionCountList.keys.contains(eIndex) {
                        indexCollisionCountList.updateValue(0, forKey: eIndex)
                    }
                }
            }
        }
        
        print("item overall: \(indexCollisionCountList)")
        for entry in indexCollisionCountList{
            let collisionCount = entry.value
            if(collisionCount == 0) {
                if(!markerList[entry.key].isInitialized) {
                    markerList[entry.key].changeInitializeOn(withAnimation: withAnimation)
                }
            }
        }
    }
    
    func mapRefreshObjectsProjectionPoints(withAnimation: Bool) {

        guard let mapView = mapView else {
            return
        }
        if(!markerList.isEmpty) {
            
            var countCollision = 0
            
            for entry in markerList {
                guard let radialLocation = entry.coordinateLocation else {
                    return
                }
                
                let point = mapView.projection.point(for: radialLocation)
//                entry.frame.origin.x = point.x - entry.frame.width/2
                entry.frame.origin.x = point.x - entry.widthOriginOffset/2 //test
                entry.frame.origin.y = point.y - entry.frame.height
                print("refresh markers x: \(point.x), \(entry.frame.origin.x)")
                
                //test > center focus marker collision algo
                if (
                    entry.frame.origin.x < redView.frame.origin.x + redView.frame.width &&
                    entry.frame.origin.x + entry.frame.width > redView.frame.origin.x &&
                    entry.frame.origin.y < redView.frame.origin.y + redView.frame.height &&
                    entry.frame.height + entry.frame.origin.y > redView.frame.origin.y
                ) {
                    // Collision detected!
                    countCollision += 1
                    collidedCoordinates = entry.coordinateLocation!
//                    print("state collided: \(collidedCoordinates)")
                } else {
                    // No collision
                }
                
                //test entree animation for markers
                if (
                    entry.frame.origin.x < blueView.frame.origin.x + blueView.frame.width &&
                    entry.frame.origin.x + entry.frame.width > blueView.frame.origin.x &&
                    entry.frame.origin.y < blueView.frame.origin.y + blueView.frame.height &&
                    entry.frame.height + entry.frame.origin.y > blueView.frame.origin.y
                ) {
                    // Collision detected!
//                    print("state blue collided: ")
                    if(entry.isInitialized && !entry.isOnScreen) {
                        entry.changeOnScreen(withAnimation: withAnimation)
                    }
                } else {
                    // No collision
                    if(entry.isInitialized && entry.isOnScreen) {
                        entry.changeOffScreen(withAnimation: withAnimation)
                    }
                }
            }
            
            print("collision: \(countCollision)")
            if(countCollision > 0) {
                // Collision detected!
                isCollided = true
            } else {
                // No collision
                isCollided = false
            }
        }
        if(!pulseWaveList.isEmpty) {
            for entry in pulseWaveList {
                guard let radialLocation = entry.coordinateLocation else {
                    return
                }
                
                let point = mapView.projection.point(for: radialLocation)
                entry.frame.origin.x = point.x - entry.frame.width/2
                entry.frame.origin.y = point.y - entry.frame.height/2
            }
        }
    }

    //test > content type filter btn => e.g. only show photos on map
    let rBtn = UIView()
    let rBtnSpinner = SpinLoader()
    let rInnerBtn = UIView()
    let aInnerRing = UIView()
    let bInnerRing = UIView()
    let cInnerRing = UIView()
    let rSettingBtn = UIImageView()
    let rBoxCloseBtn = UIImageView()
    let rABtn = UIView()
    let rAMiniBtn = UIView()
    let rBMiniBtn = UIView()
    let rCMiniBtn = UIView()
    let rAMiniOuterRing = RingView()
    let rBMiniOuterRing = RingView()
    let rCMiniOuterRing = RingView()
    var xContentDataType = "loop" //shot, post => to be reset to user's chosen setting
    func addContentTypeFilter() {
        //test > try top RHS dynamic buttons => map setting
//        let rBtn = UIView()
//        rBtn.backgroundColor = .ddmBlackOverlayColor
        self.view.addSubview(rBtn)
        rBtn.translatesAutoresizingMaskIntoConstraints = false
        rBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        rBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        rBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        rBtn.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor, constant: 0).isActive = true
        rBtn.layer.cornerRadius = 20
//        rBtn.layer.opacity = 0.4 //default 0.3
        rBtn.isUserInteractionEnabled = true
        rBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapSettingBtnClicked)))
//        rBtn.isHidden = true
        
        let rSemiTranparentBtn = UIView()
        rSemiTranparentBtn.backgroundColor = .ddmBlackOverlayColor
        rBtn.addSubview(rSemiTranparentBtn)
        rSemiTranparentBtn.translatesAutoresizingMaskIntoConstraints = false
        rSemiTranparentBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        rSemiTranparentBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rSemiTranparentBtn.centerXAnchor.constraint(equalTo: rBtn.centerXAnchor).isActive = true
        rSemiTranparentBtn.centerYAnchor.constraint(equalTo: rBtn.centerYAnchor).isActive = true
        rSemiTranparentBtn.layer.cornerRadius = 20
        rSemiTranparentBtn.layer.opacity = 0.4

//        let rBoxBtn = UIImageView()
        rSettingBtn.image = UIImage(named:"icon_round_setting")?.withRenderingMode(.alwaysTemplate)
//        rBoxBtn.image =  UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate)
//        rBoxBtn.image = UIImage(named:"icon_outline_filter")?.withRenderingMode(.alwaysTemplate)
//        rBoxBtn.image = UIImage(named:"icon_round_filter")?.withRenderingMode(.alwaysTemplate)
        rSettingBtn.tintColor = .white
        rBtn.addSubview(rSettingBtn)
        rSettingBtn.translatesAutoresizingMaskIntoConstraints = false
        rSettingBtn.centerXAnchor.constraint(equalTo: rBtn.centerXAnchor).isActive = true
        rSettingBtn.centerYAnchor.constraint(equalTo: rBtn.centerYAnchor).isActive = true
        rSettingBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //26, 22
        rSettingBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        rBoxBtn.isHidden = true
        
        rBoxCloseBtn.image =  UIImage(named:"icon_round_arrow_up_a")?.withRenderingMode(.alwaysTemplate)
        rBoxCloseBtn.tintColor = .white
        rBtn.addSubview(rBoxCloseBtn)
        rBoxCloseBtn.translatesAutoresizingMaskIntoConstraints = false
        rBoxCloseBtn.centerXAnchor.constraint(equalTo: rBtn.centerXAnchor).isActive = true
        rBoxCloseBtn.centerYAnchor.constraint(equalTo: rBtn.centerYAnchor).isActive = true
        rBoxCloseBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26, 22
        rBoxCloseBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rBoxCloseBtn.isHidden = true
        
//        rBtn.addSubview(rInnerBtn)
////        self.view.addSubview(rInnerBtn)
//        rInnerBtn.translatesAutoresizingMaskIntoConstraints = false
//        rInnerBtn.centerXAnchor.constraint(equalTo: rBtn.centerXAnchor).isActive = true
//        rInnerBtn.centerYAnchor.constraint(equalTo: rBtn.centerYAnchor).isActive = true
////        rInnerBtn.topAnchor.constraint(equalTo: rBtn.bottomAnchor, constant: 10).isActive = true
//        rInnerBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //32
//        rInnerBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        rInnerBtn.layer.cornerRadius = 20
////        rInnerBtn.isUserInteractionEnabled = true
////        rInnerBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRABtnClicked)))
//        rInnerBtn.isHidden = true
//        
//        let rInnerOuterRing = RingView()
//        rInnerBtn.addSubview(rInnerOuterRing)
//        rInnerOuterRing.translatesAutoresizingMaskIntoConstraints = false
//        rInnerOuterRing.centerXAnchor.constraint(equalTo: rInnerBtn.centerXAnchor).isActive = true
//        rInnerOuterRing.centerYAnchor.constraint(equalTo: rInnerBtn.centerYAnchor).isActive = true
//        rInnerOuterRing.heightAnchor.constraint(equalToConstant: 26).isActive = true //32
//        rInnerOuterRing.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rInnerOuterRing.changeLineWidth(width: 2)
////        rInnerOuterRing.changeStrokeColor(color: UIColor.ddmGoldenYellowColor)
//        rInnerOuterRing.changeStrokeColor(color: UIColor.yellow)
////        rInnerOuterRing.changeStrokeColor(color: UIColor.white)
////        rInnerOuterRing.isHidden = true
//        
////        let aInnerRing = UIView()
//        aInnerRing.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
//        rInnerBtn.addSubview(aInnerRing)
//        aInnerRing.translatesAutoresizingMaskIntoConstraints = false
//        aInnerRing.centerXAnchor.constraint(equalTo: rInnerBtn.centerXAnchor).isActive = true
//        aInnerRing.centerYAnchor.constraint(equalTo: rInnerBtn.centerYAnchor).isActive = true
//        aInnerRing.heightAnchor.constraint(equalToConstant: 22).isActive = true //28
//        aInnerRing.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        aInnerRing.layer.cornerRadius = 11
//        aInnerRing.isHidden = true
//        
////        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
//        let aInnerImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
////        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
////        aMiniImage.contentMode = .scaleAspectFill
////        aMiniImage.layer.masksToBounds = true
//        aInnerRing.addSubview(aInnerImage)
//        aInnerImage.translatesAutoresizingMaskIntoConstraints = false
//        aInnerImage.centerXAnchor.constraint(equalTo: aInnerRing.centerXAnchor).isActive = true
//        aInnerImage.centerYAnchor.constraint(equalTo: aInnerRing.centerYAnchor).isActive = true
//        aInnerImage.heightAnchor.constraint(equalToConstant: 16).isActive = true //20
//        aInnerImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        aInnerImage.layer.cornerRadius = 8
//        
////        let aInnerRing = UIView()
//        bInnerRing.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
//        rInnerBtn.addSubview(bInnerRing)
//        bInnerRing.translatesAutoresizingMaskIntoConstraints = false
//        bInnerRing.centerXAnchor.constraint(equalTo: rInnerBtn.centerXAnchor).isActive = true
//        bInnerRing.centerYAnchor.constraint(equalTo: rInnerBtn.centerYAnchor).isActive = true
//        bInnerRing.heightAnchor.constraint(equalToConstant: 22).isActive = true //28
//        bInnerRing.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        bInnerRing.layer.cornerRadius = 11
//        bInnerRing.isHidden = true
//        
//        let bInnerImageCircleBg = UIView()
//        bInnerImageCircleBg.backgroundColor = .systemYellow
////        aMiniImageCircleBg.backgroundColor = .white
//        bInnerRing.addSubview(bInnerImageCircleBg)
//        bInnerImageCircleBg.translatesAutoresizingMaskIntoConstraints = false
//        bInnerImageCircleBg.centerXAnchor.constraint(equalTo: bInnerRing.centerXAnchor).isActive = true
//        bInnerImageCircleBg.centerYAnchor.constraint(equalTo: bInnerRing.centerYAnchor).isActive = true
//        bInnerImageCircleBg.heightAnchor.constraint(equalToConstant: 16).isActive = true //20
//        bInnerImageCircleBg.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        bInnerImageCircleBg.layer.cornerRadius = 8
//        
//        let bInnerImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
////        let bInnerImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
////        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
////        aMiniImage.contentMode = .scaleAspectFill
////        aMiniImage.layer.masksToBounds = true
//        bInnerRing.addSubview(bInnerImage)
//        bInnerImage.translatesAutoresizingMaskIntoConstraints = false
//        bInnerImage.centerXAnchor.constraint(equalTo: bInnerRing.centerXAnchor).isActive = true
//        bInnerImage.centerYAnchor.constraint(equalTo: bInnerRing.centerYAnchor).isActive = true
//        bInnerImage.heightAnchor.constraint(equalToConstant: 16).isActive = true //20
//        bInnerImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        bInnerImage.layer.cornerRadius = 8
//        
////        let cInnerRing = UIView()
//        cInnerRing.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
//        rInnerBtn.addSubview(cInnerRing)
//        cInnerRing.translatesAutoresizingMaskIntoConstraints = false
//        cInnerRing.centerXAnchor.constraint(equalTo: rInnerBtn.centerXAnchor).isActive = true
//        cInnerRing.centerYAnchor.constraint(equalTo: rInnerBtn.centerYAnchor).isActive = true
//        cInnerRing.heightAnchor.constraint(equalToConstant: 22).isActive = true //28
//        cInnerRing.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        cInnerRing.layer.cornerRadius = 11
//        cInnerRing.isHidden = true
//        
////        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
////        let cInnerImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
//        let cInnerImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
////        aMiniImage.contentMode = .scaleAspectFill
////        aMiniImage.layer.masksToBounds = true
//        cInnerRing.addSubview(cInnerImage)
//        cInnerImage.translatesAutoresizingMaskIntoConstraints = false
//        cInnerImage.centerXAnchor.constraint(equalTo: cInnerRing.centerXAnchor).isActive = true
//        cInnerImage.centerYAnchor.constraint(equalTo: cInnerRing.centerYAnchor).isActive = true
//        cInnerImage.heightAnchor.constraint(equalToConstant: 14).isActive = true //16
//        cInnerImage.widthAnchor.constraint(equalToConstant: 14).isActive = true
//        cInnerImage.layer.cornerRadius = 7
        
        let rBoxNotifyView = UIView() //indicate not default map setting
        rBoxNotifyView.backgroundColor = .red
        rBtn.addSubview(rBoxNotifyView)
        rBoxNotifyView.translatesAutoresizingMaskIntoConstraints = false
        rBoxNotifyView.trailingAnchor.constraint(equalTo: rSemiTranparentBtn.trailingAnchor, constant: -5).isActive = true //-5
        rBoxNotifyView.topAnchor.constraint(equalTo: rSemiTranparentBtn.topAnchor, constant: 5).isActive = true //5
        rBoxNotifyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        rBoxNotifyView.widthAnchor.constraint(equalToConstant: 10).isActive = true //20
        rBoxNotifyView.layer.cornerRadius = 5 //10
        rBoxNotifyView.isHidden = true
        
        //content type filter btns
        self.view.addSubview(rABtn)
        rABtn.translatesAutoresizingMaskIntoConstraints = false
        rABtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        rABtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        rABtn.topAnchor.constraint(equalTo: rBtn.bottomAnchor, constant: 10).isActive = true
//        rABtn.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        rABtn.layer.cornerRadius = 20
        rABtn.isHidden = true
        
        let rASemiTranparentBtn = UIView()
        rASemiTranparentBtn.backgroundColor = .ddmBlackOverlayColor
        rABtn.addSubview(rASemiTranparentBtn)
        rASemiTranparentBtn.translatesAutoresizingMaskIntoConstraints = false
        rASemiTranparentBtn.topAnchor.constraint(equalTo: rABtn.topAnchor).isActive = true
        rASemiTranparentBtn.bottomAnchor.constraint(equalTo: rABtn.bottomAnchor).isActive = true
        rASemiTranparentBtn.leadingAnchor.constraint(equalTo: rABtn.leadingAnchor).isActive = true
        rASemiTranparentBtn.trailingAnchor.constraint(equalTo: rABtn.trailingAnchor).isActive = true
        rASemiTranparentBtn.layer.cornerRadius = 20
        rASemiTranparentBtn.layer.opacity = 0.4
        
//        let rAMiniBtn = UIView()
//        rAMiniBtn.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
        rABtn.addSubview(rAMiniBtn)
        rAMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        rAMiniBtn.centerXAnchor.constraint(equalTo: rASemiTranparentBtn.centerXAnchor).isActive = true
        rAMiniBtn.topAnchor.constraint(equalTo: rASemiTranparentBtn.topAnchor, constant: 2).isActive = true //6
        rAMiniBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //32
        rAMiniBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rAMiniBtn.layer.cornerRadius = 20
        rAMiniBtn.isUserInteractionEnabled = true
        rAMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRABtnClicked)))
        
//        let rAMiniOuterRing = RingView()
        rAMiniBtn.addSubview(rAMiniOuterRing)
        rAMiniOuterRing.translatesAutoresizingMaskIntoConstraints = false
        rAMiniOuterRing.centerXAnchor.constraint(equalTo: rAMiniBtn.centerXAnchor).isActive = true
        rAMiniOuterRing.centerYAnchor.constraint(equalTo: rAMiniBtn.centerYAnchor).isActive = true
        rAMiniOuterRing.heightAnchor.constraint(equalToConstant: 32).isActive = true //34
        rAMiniOuterRing.widthAnchor.constraint(equalToConstant: 32).isActive = true
        rAMiniOuterRing.changeLineWidth(width: 2)
//        rAMiniOuterRing.changeStrokeColor(color: UIColor.ddmGoldenYellowColor)
        rAMiniOuterRing.changeStrokeColor(color: UIColor.yellow)
//        rAMiniOuterRing.changeStrokeColor(color: UIColor.white)
        rAMiniOuterRing.isHidden = true
        
        let aMiniRing = UIView()
        aMiniRing.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
        rAMiniBtn.addSubview(aMiniRing)
        aMiniRing.translatesAutoresizingMaskIntoConstraints = false
        aMiniRing.centerXAnchor.constraint(equalTo: rAMiniBtn.centerXAnchor).isActive = true
        aMiniRing.centerYAnchor.constraint(equalTo: rAMiniBtn.centerYAnchor).isActive = true
        aMiniRing.heightAnchor.constraint(equalToConstant: 28).isActive = true //30
        aMiniRing.widthAnchor.constraint(equalToConstant: 28).isActive = true
        aMiniRing.layer.cornerRadius = 14
        
//        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
//        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
//        aMiniImage.contentMode = .scaleAspectFill
//        aMiniImage.layer.masksToBounds = true
        aMiniRing.addSubview(aMiniImage)
        aMiniImage.translatesAutoresizingMaskIntoConstraints = false
        aMiniImage.centerXAnchor.constraint(equalTo: aMiniRing.centerXAnchor).isActive = true
        aMiniImage.centerYAnchor.constraint(equalTo: aMiniRing.centerYAnchor).isActive = true
        aMiniImage.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
        aMiniImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aMiniImage.layer.cornerRadius = 10
        
//        let eAddRing = UIView()
//        eAddRing.backgroundColor = .ddmDarkColor
//        rABtn.addSubview(eAddRing)
//        eAddRing.translatesAutoresizingMaskIntoConstraints = false
////        eAddRing.centerXAnchor.constraint(equalTo: aMiniRing.centerXAnchor).isActive = true
//        eAddRing.trailingAnchor.constraint(equalTo: aMiniRing.trailingAnchor).isActive = true
//        eAddRing.topAnchor.constraint(equalTo: aMiniRing.bottomAnchor, constant: -10).isActive = true //-7
//        eAddRing.heightAnchor.constraint(equalToConstant: 16).isActive = true //14
//        eAddRing.widthAnchor.constraint(equalToConstant: 16).isActive = true //20
//        eAddRing.layer.cornerRadius = 8
////        eAddRing.isHidden = true
//
//        let eAddBtn = UIImageView(image: UIImage(named:"icon_round_done_circle")?.withRenderingMode(.alwaysTemplate))
////        eAddBtn.tintColor = .yellow
//        eAddBtn.tintColor = .white
//        eAddRing.addSubview(eAddBtn)
//        eAddBtn.translatesAutoresizingMaskIntoConstraints = false
//        eAddBtn.centerXAnchor.constraint(equalTo: eAddRing.centerXAnchor).isActive = true
//        eAddBtn.centerYAnchor.constraint(equalTo: eAddRing.centerYAnchor).isActive = true
//        eAddBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //10
//        eAddBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        rBMiniBtn.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
        rABtn.addSubview(rBMiniBtn)
        rBMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        rBMiniBtn.centerXAnchor.constraint(equalTo: rASemiTranparentBtn.centerXAnchor).isActive = true
        rBMiniBtn.topAnchor.constraint(equalTo: rAMiniBtn.bottomAnchor, constant: 0).isActive = true //10
        rBMiniBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        rBMiniBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rBMiniBtn.layer.cornerRadius = 20
        rBMiniBtn.isUserInteractionEnabled = true
        rBMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRBBtnClicked)))
        
//        let rBMiniOuterRing = RingView()
        rBMiniBtn.addSubview(rBMiniOuterRing)
        rBMiniOuterRing.translatesAutoresizingMaskIntoConstraints = false
        rBMiniOuterRing.centerXAnchor.constraint(equalTo: rBMiniBtn.centerXAnchor).isActive = true
        rBMiniOuterRing.centerYAnchor.constraint(equalTo: rBMiniBtn.centerYAnchor).isActive = true
        rBMiniOuterRing.heightAnchor.constraint(equalToConstant: 32).isActive = true //34
        rBMiniOuterRing.widthAnchor.constraint(equalToConstant: 32).isActive = true
        rBMiniOuterRing.changeLineWidth(width: 2)
//        rBMiniOuterRing.changeStrokeColor(color: UIColor.ddmGoldenYellowColor)
        rBMiniOuterRing.changeStrokeColor(color: UIColor.yellow)
        rBMiniOuterRing.isHidden = true
        
        let bMiniRing = UIView()
        bMiniRing.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
        rBMiniBtn.addSubview(bMiniRing)
        bMiniRing.translatesAutoresizingMaskIntoConstraints = false
        bMiniRing.centerXAnchor.constraint(equalTo: rBMiniBtn.centerXAnchor).isActive = true
        bMiniRing.centerYAnchor.constraint(equalTo: rBMiniBtn.centerYAnchor).isActive = true
        bMiniRing.heightAnchor.constraint(equalToConstant: 28).isActive = true //30
        bMiniRing.widthAnchor.constraint(equalToConstant: 28).isActive = true
        bMiniRing.layer.cornerRadius = 14
        
        let bMiniImageCircleBg = UIView()
        bMiniImageCircleBg.backgroundColor = .systemYellow
//        aMiniImageCircleBg.backgroundColor = .white
        bMiniRing.addSubview(bMiniImageCircleBg)
        bMiniImageCircleBg.translatesAutoresizingMaskIntoConstraints = false
        bMiniImageCircleBg.centerXAnchor.constraint(equalTo: bMiniRing.centerXAnchor).isActive = true
        bMiniImageCircleBg.centerYAnchor.constraint(equalTo: bMiniRing.centerYAnchor).isActive = true
        bMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 20).isActive = true //28, 32
        bMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bMiniImageCircleBg.layer.cornerRadius = 10
        
        let bMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
//        let bMiniImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
//        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
//        aMiniImage.contentMode = .scaleAspectFill
//        aMiniImage.layer.masksToBounds = true
        bMiniRing.addSubview(bMiniImage)
        bMiniImage.translatesAutoresizingMaskIntoConstraints = false
        bMiniImage.centerXAnchor.constraint(equalTo: bMiniRing.centerXAnchor).isActive = true
        bMiniImage.centerYAnchor.constraint(equalTo: bMiniRing.centerYAnchor).isActive = true
        bMiniImage.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
        bMiniImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bMiniImage.layer.cornerRadius = 10
        
//        rCMiniBtn.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
        rABtn.addSubview(rCMiniBtn)
        rCMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        rCMiniBtn.centerXAnchor.constraint(equalTo: rASemiTranparentBtn.centerXAnchor).isActive = true
        rCMiniBtn.topAnchor.constraint(equalTo: rBMiniBtn.bottomAnchor, constant: 0).isActive = true //10
        rCMiniBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        rCMiniBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rCMiniBtn.layer.cornerRadius = 20
        rCMiniBtn.isUserInteractionEnabled = true
        rCMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRCBtnClicked)))
        rCMiniBtn.bottomAnchor.constraint(equalTo: rASemiTranparentBtn.bottomAnchor, constant: -2).isActive = true
        
//        let rCMiniOuterRing = RingView()
        rCMiniBtn.addSubview(rCMiniOuterRing)
        rCMiniOuterRing.translatesAutoresizingMaskIntoConstraints = false
        rCMiniOuterRing.centerXAnchor.constraint(equalTo: rCMiniBtn.centerXAnchor).isActive = true
        rCMiniOuterRing.centerYAnchor.constraint(equalTo: rCMiniBtn.centerYAnchor).isActive = true
        rCMiniOuterRing.heightAnchor.constraint(equalToConstant: 32).isActive = true //34
        rCMiniOuterRing.widthAnchor.constraint(equalToConstant: 32).isActive = true
        rCMiniOuterRing.changeLineWidth(width: 2)
//        rCMiniOuterRing.changeStrokeColor(color: UIColor.ddmGoldenYellowColor)
        rCMiniOuterRing.changeStrokeColor(color: UIColor.yellow)
        rCMiniOuterRing.isHidden = true
        
        let cMiniRing = UIView()
        cMiniRing.backgroundColor = .ddmDarkGreyColor //ddmDarkColor
        rCMiniBtn.addSubview(cMiniRing)
        cMiniRing.translatesAutoresizingMaskIntoConstraints = false
        cMiniRing.centerXAnchor.constraint(equalTo: rCMiniBtn.centerXAnchor).isActive = true
        cMiniRing.centerYAnchor.constraint(equalTo: rCMiniBtn.centerYAnchor).isActive = true
        cMiniRing.heightAnchor.constraint(equalToConstant: 28).isActive = true //30
        cMiniRing.widthAnchor.constraint(equalToConstant: 28).isActive = true
        cMiniRing.layer.cornerRadius = 14
        
//        let bMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
//        let bMiniImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
        let cMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
//        aMiniImage.contentMode = .scaleAspectFill
//        aMiniImage.layer.masksToBounds = true
        cMiniRing.addSubview(cMiniImage)
        cMiniImage.translatesAutoresizingMaskIntoConstraints = false
        cMiniImage.centerXAnchor.constraint(equalTo: cMiniRing.centerXAnchor).isActive = true
        cMiniImage.centerYAnchor.constraint(equalTo: cMiniRing.centerYAnchor).isActive = true
        cMiniImage.heightAnchor.constraint(equalToConstant: 16).isActive = true //20
        cMiniImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        cMiniImage.layer.cornerRadius = 8
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
////        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .white
//        rABtn.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: rASemiTranparentBtn.centerXAnchor).isActive = true
//        bMiniBtn.topAnchor.constraint(equalTo: cMiniRing.bottomAnchor, constant: 6).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //20
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        bMiniBtn.bottomAnchor.constraint(equalTo: rASemiTranparentBtn.bottomAnchor, constant: -8).isActive = true //6
        
        reactToRContentTypeChange(type: xContentDataType)
    }
    
    //test > toggle to different content type on map
    @objc func onMapSettingBtnClicked(gesture: UITapGestureRecognizer) {
        //test > remove pulsewave when clicked
        stopPulseWave()
        dequeueObject()
        
        if(rABtn.isHidden) {
            rSettingBtn.isHidden = true
//            rInnerBtn.isHidden = true
            rBoxCloseBtn.isHidden = false
            rABtn.isHidden = false
        } else {
            rSettingBtn.isHidden = false
//            rInnerBtn.isHidden = false
            rBoxCloseBtn.isHidden = true
            rABtn.isHidden = true
        }
    }
    
    func hideRMapSettingBtn() {
        rSettingBtn.isHidden = false
        rBoxCloseBtn.isHidden = true
        rABtn.isHidden = true
    }
    
    @objc func onRABtnClicked(gesture: UITapGestureRecognizer) {
        stopPulseWave()
        dequeueObject()
        
        reactToRContentTypeChange(type: "shot")
        
        //*test 1 > remove markers and switch new content type
        if(xContentDataType != "shot") {
            xContentDataType = "shot"
            hideRMapSettingBtn()
            getHeatmapPoints()
        }
        //*
    }
    @objc func onRBBtnClicked(gesture: UITapGestureRecognizer) {
        stopPulseWave()
        dequeueObject()
        
        reactToRContentTypeChange(type: "loop")
        
        //*test 1 > remove markers and switch new content type
        if(xContentDataType != "loop") {
            xContentDataType = "loop"
            hideRMapSettingBtn()
            getHeatmapPoints()
        }
        //*
    }
    @objc func onRCBtnClicked(gesture: UITapGestureRecognizer) {
        stopPulseWave()
        dequeueObject()
        
        reactToRContentTypeChange(type: "post")
        
        //*test 1 > remove markers and switch new content type
        if(xContentDataType != "post") {
            xContentDataType = "post"
            hideRMapSettingBtn()
            getHeatmapPoints()
        }
    }
    func reactToRContentTypeChange(type: String) {
        
        rAMiniOuterRing.isHidden = true
        rBMiniOuterRing.isHidden = true
        rCMiniOuterRing.isHidden = true
        
        aInnerRing.isHidden = true
        bInnerRing.isHidden = true
        cInnerRing.isHidden = true
        
        if(type == "shot") {
            rAMiniOuterRing.isHidden = false
            aInnerRing.isHidden = false
        } else if(type == "loop") {
            rBMiniOuterRing.isHidden = false
            bInnerRing.isHidden = false
        } else {
            rCMiniOuterRing.isHidden = false
            cInnerRing.isHidden = false
        }
    }
    
    let llMini = UIView()
    let llMiniError = UIView()
    let miniAppContainer = UIView()
    let miniAppScrollView = UIScrollView()
    var miniAppDataList = [String]()
    var miniAppViewList = [MiniApp]()
    var selectedMiniAppIndex = -1
//    let miniAppScrollLHSBtn = UIView()
//    let miniAppScrollRHSBtn = UIView()
    let miniAppScrollLHSBtn = UIImageView()
    let miniAppScrollRHSBtn = UIImageView()
    var miniAppScrollGap = 0.0
    func addMiniApps() {
        
        //test > with scrollview for > 3 mini apps
        self.view.addSubview(miniAppContainer)
        miniAppContainer.backgroundColor = .clear
        miniAppContainer.translatesAutoresizingMaskIntoConstraints = false
        miniAppContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true //-95
        miniAppContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true //0
        miniAppContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        miniAppContainer.heightAnchor.constraint(equalToConstant: 105.0).isActive = true  //70
        
//        self.view.addSubview(miniAppScrollView)
        miniAppContainer.addSubview(miniAppScrollView)
        miniAppScrollView.backgroundColor = .clear
        miniAppScrollView.translatesAutoresizingMaskIntoConstraints = false
        miniAppScrollView.topAnchor.constraint(equalTo: miniAppContainer.topAnchor, constant: 0).isActive = true
//        miniAppScrollView.bottomAnchor.constraint(equalTo: miniAppContainer.bottomAnchor, constant: 0).isActive = true
        miniAppScrollView.leadingAnchor.constraint(equalTo: miniAppContainer.leadingAnchor, constant: 0).isActive = true
        miniAppScrollView.trailingAnchor.constraint(equalTo: miniAppContainer.trailingAnchor, constant: 0).isActive = true
        miniAppScrollView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true  //65
        miniAppScrollView.showsHorizontalScrollIndicator = false
        miniAppScrollView.alwaysBounceHorizontal = true
//        miniAppScrollView.layer.opacity = 0.4
        miniAppScrollView.delegate = self
        
        miniAppDataList.append("loop")
        miniAppDataList.append("location")
        miniAppDataList.append("post")
        miniAppDataList.append("photo")
        //test > other mini apps
        miniAppDataList.append("creator")
//        miniAppDataList.append("ride")
//        miniAppDataList.append("hotel")
        
        let width = (self.view.frame.width - 40.0) / 3
        
        for mA in miniAppDataList {
//            let app1 = UIView()
            let app1 = MiniApp()
            miniAppScrollView.addSubview(app1)
    //        app1.backgroundColor = .red
//            app1.backgroundColor = .clear
    //        app1.layer.opacity = 0.4
            app1.translatesAutoresizingMaskIntoConstraints = false
            app1.widthAnchor.constraint(equalToConstant: width).isActive = true //180
            app1.heightAnchor.constraint(equalToConstant: 70.0).isActive = true //280
            app1.topAnchor.constraint(equalTo: miniAppScrollView.topAnchor, constant: 0).isActive = true
            if(miniAppViewList.isEmpty) {
                app1.leadingAnchor.constraint(equalTo: miniAppScrollView.leadingAnchor, constant: 20).isActive = true //0
            } else {
                app1.leadingAnchor.constraint(equalTo: miniAppViewList[miniAppViewList.count - 1].trailingAnchor, constant: 0).isActive = true
            }
            app1.delegate = self
            
            if(mA == "loop") {
                app1.setText(code: mA, d: "Loops")
            } else if(mA == "location") {
                app1.setText(code: mA, d: "Locations")
            } else if(mA == "post") {
                app1.setText(code: mA, d: "Posts")
            } else if(mA == "photo") {
                app1.setText(code: mA, d: "Shots")
            }
            //test > other mini apps
            else if(mA == "creator") {
                app1.setText(code: mA, d: "Creators")
            } else if(mA == "ride") {
                app1.setText(code: mA, d: "Rides")
            } else if(mA == "hotel") {
                app1.setText(code: mA, d: "Hotels")
            }
            
            miniAppViewList.append(app1)
        }
        let contentWidth = width * CGFloat(miniAppViewList.count) + 40.0
        miniAppScrollView.contentSize = CGSize(width: contentWidth, height: 70.0) //800, 280
        miniAppScrollGap = contentWidth - self.view.frame.width
        if(miniAppScrollGap < 0) {
            miniAppScrollGap = 0.0
        }
        
//        miniAppScrollLHSBtn.backgroundColor = .ddmBlackOverlayColor
////        miniAppScrollLHSBtn.backgroundColor = .white
////        self.view.addSubview(miniAppScrollLHSBtn)
//        miniAppContainer.addSubview(miniAppScrollLHSBtn)
//        miniAppScrollLHSBtn.translatesAutoresizingMaskIntoConstraints = false
//        miniAppScrollLHSBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true //ori: 14
//        miniAppScrollLHSBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        miniAppScrollLHSBtn.leadingAnchor.constraint(equalTo: miniAppScrollView.leadingAnchor, constant: 20).isActive = true
//        miniAppScrollLHSBtn.centerYAnchor.constraint(equalTo: miniAppScrollView.centerYAnchor, constant: 0).isActive = true
//        miniAppScrollLHSBtn.layer.cornerRadius = 10
//        miniAppScrollLHSBtn.isHidden = true
////        miniAppScrollLHSBtn.layer.opacity = 0.5
//        miniAppScrollLHSBtn.layer.shadowColor = UIColor.ddmDarkColor.cgColor
//        miniAppScrollLHSBtn.layer.shadowRadius = 3.0  //ori 3
//        miniAppScrollLHSBtn.layer.shadowOpacity = 1.0 //ori 1
//        miniAppScrollLHSBtn.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
//
//        let miniAppLHSBoxBtn = UIImageView()
//        miniAppLHSBoxBtn.image = UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate)
////        miniAppLHSBoxBtn.tintColor = .ddmBlackOverlayColor
//        miniAppLHSBoxBtn.tintColor = .white
//        miniAppScrollLHSBtn.addSubview(miniAppLHSBoxBtn)
//        miniAppLHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        miniAppLHSBoxBtn.centerXAnchor.constraint(equalTo: miniAppScrollLHSBtn.centerXAnchor).isActive = true
//        miniAppLHSBoxBtn.centerYAnchor.constraint(equalTo: miniAppScrollLHSBtn.centerYAnchor).isActive = true
//        miniAppLHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //14
//        miniAppLHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
        miniAppScrollLHSBtn.image = UIImage(named:"icon_round_arrow_left_a")?.withRenderingMode(.alwaysTemplate)
        miniAppContainer.addSubview(miniAppScrollLHSBtn)
        miniAppScrollLHSBtn.tintColor = .white
//        miniAppScrollLHSBtn.tintColor = .yellow
        miniAppScrollLHSBtn.translatesAutoresizingMaskIntoConstraints = false
        miniAppScrollLHSBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true //ori: 20
        miniAppScrollLHSBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        miniAppScrollLHSBtn.leadingAnchor.constraint(equalTo: miniAppScrollView.leadingAnchor, constant: 10).isActive = true //20
        miniAppScrollLHSBtn.centerYAnchor.constraint(equalTo: miniAppScrollView.centerYAnchor, constant: 0).isActive = true
        miniAppScrollLHSBtn.isHidden = true
        miniAppScrollLHSBtn.layer.shadowColor = UIColor.ddmDarkColor.cgColor
        miniAppScrollLHSBtn.layer.shadowRadius = 3.0  //ori 3
        miniAppScrollLHSBtn.layer.shadowOpacity = 1.0 //ori 1
        miniAppScrollLHSBtn.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
////        let miniAppScrollRHSBtn = UIView()
//        miniAppScrollRHSBtn.backgroundColor = .ddmBlackOverlayColor
////        miniAppScrollRHSBtn.backgroundColor = .white
////        self.view.addSubview(miniAppScrollRHSBtn)
//        miniAppContainer.addSubview(miniAppScrollRHSBtn)
//        miniAppScrollRHSBtn.translatesAutoresizingMaskIntoConstraints = false
//        miniAppScrollRHSBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true //ori: 14
//        miniAppScrollRHSBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        miniAppScrollRHSBtn.trailingAnchor.constraint(equalTo: miniAppScrollView.trailingAnchor, constant: -20).isActive = true
//        miniAppScrollRHSBtn.centerYAnchor.constraint(equalTo: miniAppScrollView.centerYAnchor, constant: 0).isActive = true
//        miniAppScrollRHSBtn.layer.cornerRadius = 10
//        miniAppScrollRHSBtn.isHidden = true
////        miniAppScrollRHSBtn.layer.opacity = 0.5
//        miniAppScrollRHSBtn.layer.shadowColor = UIColor.ddmDarkColor.cgColor
//        miniAppScrollRHSBtn.layer.shadowRadius = 3.0  //ori 3
//        miniAppScrollRHSBtn.layer.shadowOpacity = 1.0 //ori 1
//        miniAppScrollRHSBtn.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
//
//        let miniAppRHSBoxBtn = UIImageView()
//        miniAppRHSBoxBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
////        miniAppRHSBoxBtn.tintColor = .ddmBlackOverlayColor
//        miniAppRHSBoxBtn.tintColor = .white
//        miniAppScrollRHSBtn.addSubview(miniAppRHSBoxBtn)
//        miniAppRHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        miniAppRHSBoxBtn.centerXAnchor.constraint(equalTo: miniAppScrollRHSBtn.centerXAnchor).isActive = true
//        miniAppRHSBoxBtn.centerYAnchor.constraint(equalTo: miniAppScrollRHSBtn.centerYAnchor).isActive = true
//        miniAppRHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //14
//        miniAppRHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
        miniAppScrollRHSBtn.image = UIImage(named:"icon_round_arrow_right_a")?.withRenderingMode(.alwaysTemplate)
        miniAppContainer.addSubview(miniAppScrollRHSBtn)
        miniAppScrollRHSBtn.tintColor = .white
//        miniAppScrollRHSBtn.tintColor = .yellow
        miniAppScrollRHSBtn.translatesAutoresizingMaskIntoConstraints = false
        miniAppScrollRHSBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true //ori: 20
        miniAppScrollRHSBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        miniAppScrollRHSBtn.trailingAnchor.constraint(equalTo: miniAppScrollView.trailingAnchor, constant: -10).isActive = true //-20
        miniAppScrollRHSBtn.centerYAnchor.constraint(equalTo: miniAppScrollView.centerYAnchor, constant: 0).isActive = true
        miniAppScrollRHSBtn.isHidden = true
        miniAppScrollRHSBtn.layer.shadowColor = UIColor.ddmDarkColor.cgColor
        miniAppScrollRHSBtn.layer.shadowRadius = 3.0  //ori 3
        miniAppScrollRHSBtn.layer.shadowOpacity = 1.0 //ori 1
        miniAppScrollRHSBtn.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        
        let xMiniAppOffset = miniAppScrollView.contentOffset.x
        arrowReactToMiniAppScroll(miniAppXOffset: xMiniAppOffset)
        
        //test > location refocus with GPS
//        let getLocationMini = UIView()
        getLocationMini.backgroundColor = .ddmBlackOverlayColor
        self.view.addSubview(getLocationMini)
        getLocationMini.translatesAutoresizingMaskIntoConstraints = false
//        getLocationMini.bottomAnchor.constraint(equalTo: aMini.topAnchor, constant: -10).isActive = true
        getLocationMini.bottomAnchor.constraint(equalTo: miniAppScrollView.topAnchor, constant: -10).isActive = true
        getLocationMini.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        getLocationMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        getLocationMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        getLocationMini.layer.cornerRadius = 15
        getLocationMini.layer.shadowColor = UIColor.ddmDarkColor.cgColor
        getLocationMini.layer.shadowRadius = 3.0  //ori 3
        getLocationMini.layer.shadowOpacity = 1.0 //ori 1
        getLocationMini.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
//        getLocationMini.layer.opacity = 0.3
        getLocationMini.isUserInteractionEnabled = true
        getLocationMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGetLocationClicked)))
        
        let aBtn = UIImageView(image: UIImage(named:"icon_round_near_me")?.withRenderingMode(.alwaysTemplate))
        aBtn.tintColor = .white
        getLocationMini.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.centerXAnchor.constraint(equalTo: getLocationMini.centerXAnchor).isActive = true
        aBtn.centerYAnchor.constraint(equalTo: getLocationMini.centerYAnchor).isActive = true
        aBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        aBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
//        let getLocationMiniError = UIView()
        getLocationMiniError.backgroundColor = .red
        getLocationMini.addSubview(getLocationMiniError)
//        self.view.addSubview(getLocationMiniError)
        getLocationMiniError.translatesAutoresizingMaskIntoConstraints = false
        getLocationMiniError.leadingAnchor.constraint(equalTo: getLocationMini.trailingAnchor, constant: -10).isActive = true
        getLocationMiniError.bottomAnchor.constraint(equalTo: getLocationMini.topAnchor, constant: 10).isActive = true
        getLocationMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        getLocationMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        getLocationMiniError.layer.cornerRadius = 10
        getLocationMiniError.isHidden = true
        
        let aBBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        aBBtn.tintColor = .white
        getLocationMiniError.addSubview(aBBtn)
        aBBtn.translatesAutoresizingMaskIntoConstraints = false
        aBBtn.centerXAnchor.constraint(equalTo: getLocationMiniError.centerXAnchor).isActive = true
        aBBtn.centerYAnchor.constraint(equalTo: getLocationMiniError.centerYAnchor).isActive = true
        aBBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        aBBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        //test > mini live gps location btn for location select
        llMini.backgroundColor = .ddmBlackOverlayColor
        self.view.addSubview(llMini)
        llMini.translatesAutoresizingMaskIntoConstraints = false
//        llMini.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -310).isActive = true
        llMini.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        llMini.heightAnchor.constraint(equalToConstant: 30).isActive = true
        llMini.widthAnchor.constraint(equalToConstant: 30).isActive = true
        llMini.layer.cornerRadius = 15
        llMini.layer.shadowColor = UIColor.ddmDarkColor.cgColor
        llMini.layer.shadowRadius = 3.0  //ori 3
        llMini.layer.shadowOpacity = 1.0 //ori 1
        llMini.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        //        llMini.layer.opacity = 0.3
        llMini.isUserInteractionEnabled = true
//        llMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGetLocationClicked)))
        llMini.isHidden = true
        
        let aLlBtn = UIImageView(image: UIImage(named:"icon_round_near_me")?.withRenderingMode(.alwaysTemplate))
        aLlBtn.tintColor = .white
        llMini.addSubview(aLlBtn)
        aLlBtn.translatesAutoresizingMaskIntoConstraints = false
        aLlBtn.centerXAnchor.constraint(equalTo: llMini.centerXAnchor).isActive = true
        aLlBtn.centerYAnchor.constraint(equalTo: llMini.centerYAnchor).isActive = true
        aLlBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        aLlBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        llMiniError.backgroundColor = .red
        llMini.addSubview(llMiniError)
        llMiniError.translatesAutoresizingMaskIntoConstraints = false
        llMiniError.leadingAnchor.constraint(equalTo: llMini.trailingAnchor, constant: -10).isActive = true
        llMiniError.bottomAnchor.constraint(equalTo: llMini.topAnchor, constant: 10).isActive = true
        llMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        llMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        llMiniError.layer.cornerRadius = 10
        llMiniError.isHidden = true
        
        let llABBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        llABBtn.tintColor = .white
        llMiniError.addSubview(llABBtn)
        llABBtn.translatesAutoresizingMaskIntoConstraints = false
        llABBtn.centerXAnchor.constraint(equalTo: llMiniError.centerXAnchor).isActive = true
        llABBtn.centerYAnchor.constraint(equalTo: llMiniError.centerYAnchor).isActive = true
        llABBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        llABBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        //test > semi-transparent text box at bottom
        //recommend videos nearby an area
//        let aSemiTransparentTextBox = UIView()
//        aSemiTransparentTextBox.backgroundColor = .ddmBlackOverlayColor
////        aSemiTransparentTextBox.backgroundColor = .white
//        self.view.addSubview(aSemiTransparentTextBox)
//        aSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
////        aSemiTransparentTextBox.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
//        aSemiTransparentTextBox.bottomAnchor.constraint(equalTo: cMini.topAnchor, constant: -20).isActive = true
//        aSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        aSemiTransparentTextBox.layer.cornerRadius = 15
//        aSemiTransparentTextBox.layer.opacity = 0.3
//
//        let semiGifImageOuter = UIView()
//        semiGifImageOuter.backgroundColor = .yellow
////        semiGifImageOuter.backgroundColor = .ddmGoldenYellowColor
//        self.view.addSubview(semiGifImageOuter)
//        semiGifImageOuter.translatesAutoresizingMaskIntoConstraints = false
//        semiGifImageOuter.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true
//        semiGifImageOuter.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor).isActive = true
//        semiGifImageOuter.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 34
//        semiGifImageOuter.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        semiGifImageOuter.layer.cornerRadius = 12 //17
//
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
////        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        var aSemiGifImage = SDAnimatedImageView()
//        aSemiGifImage.contentMode = .scaleAspectFill
//        aSemiGifImage.layer.masksToBounds = true
//        aSemiGifImage.layer.cornerRadius = 10
//        aSemiGifImage.sd_setImage(with: imageUrl)
//        self.view.addSubview(aSemiGifImage)
//        aSemiGifImage.translatesAutoresizingMaskIntoConstraints = false
//        aSemiGifImage.centerXAnchor.constraint(equalTo: semiGifImageOuter.centerXAnchor).isActive = true
//        aSemiGifImage.centerYAnchor.constraint(equalTo: semiGifImageOuter.centerYAnchor).isActive = true
//        aSemiGifImage.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
//        aSemiGifImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
////        aSemiGifImage.isUserInteractionEnabled = true
////        aSemiGifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSemiGifClicked)))
//
//        let aSemiTransparentText = UILabel()
//        aSemiTransparentText.textAlignment = .center
//        aSemiTransparentText.textColor = .white
//        aSemiTransparentText.font = .systemFont(ofSize: 13)
//        self.view.addSubview(aSemiTransparentText)
//        aSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
//        aSemiTransparentText.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 10).isActive = true
//        aSemiTransparentText.bottomAnchor.constraint(equalTo: aSemiTransparentTextBox.bottomAnchor, constant: -10).isActive = true
//        aSemiTransparentText.leadingAnchor.constraint(equalTo: semiGifImageOuter.trailingAnchor, constant: 10).isActive = true
//        aSemiTransparentText.trailingAnchor.constraint(equalTo: aSemiTransparentTextBox.trailingAnchor, constant: -10).isActive = true
//        aSemiTransparentText.text = "11 videos nearby"
        
        //test > user current location
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            print("location prompt 1")
            getLocationMiniError.isHidden = true
            llMiniError.isHidden = true
        case .authorizedWhenInUse:
            print("location prompt 2")
            getLocationMiniError.isHidden = true
            llMiniError.isHidden = true
        case .denied:
            print("location prompt 3")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        case .notDetermined:
            print("location prompt 4")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        case .restricted:
            print("location prompt 5")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        @unknown default:
            print("location prompt unknown")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        }
    }
    
    //test > func to hide and unhide mini apps and menu panel
    func hideMiniApps() {
        getLocationMini.isHidden = true
        miniAppContainer.isHidden = true
    }
    
    func unhideMiniApps() {
        getLocationMini.isHidden = false
        miniAppContainer.isHidden = false
    }
    
    func arrowReactToMiniAppScroll(miniAppXOffset: CGFloat) {
        if(miniAppScrollGap > 0) {
            if(miniAppXOffset > miniAppScrollGap - 26.0) {
                miniAppScrollRHSBtn.isHidden = true
            } else {
                miniAppScrollRHSBtn.isHidden = false
            }
            if(miniAppXOffset < 26.0) {
                miniAppScrollLHSBtn.isHidden = true
            } else {
                miniAppScrollLHSBtn.isHidden = false
            }
        }
    }
    
    func hideMenuPanel() {
        stackView.isHidden = true
    }
    func unhideMenuPanel() {
        stackView.isHidden = false
    }
    
    //test > user current location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("location change permission: \(status), \(CLAuthorizationStatus.authorizedWhenInUse)")
        switch status {
        case .authorizedAlways:
            print("location check 1")
            getLocationMiniError.isHidden = true
            llMiniError.isHidden = true
            locationManager.requestLocation() //request location once
        case .authorizedWhenInUse:
            print("location check 2")
            getLocationMiniError.isHidden = true
            llMiniError.isHidden = true
            locationManager.requestLocation() //request location once
        case .denied:
            print("location check 3")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        case .notDetermined:
            print("location check 4")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        case .restricted:
            print("location check 5")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        @unknown default:
            print("location check unknown")
            getLocationMiniError.isHidden = false
            llMiniError.isHidden = false
        }
    }
    
    var isUserGetLocationClicked = false
    var latestUserLocation : CLLocationCoordinate2D?
    var autoUserLocation : CLLocationCoordinate2D?
//    var latestUserLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
            print("location succeed: \(latitude), \(longitude)")
            
            let a = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            latestUserLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            autoUserLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            //test > map animation with Core Animation
            //2-part animation: move map to location at same zoom, then only zoom in
            animateMapToUserLocation()
        }
    }
    func animateMapToUserLocation() {
        if(isUserGetLocationClicked) {
            //test
            guard let autoUserLocation = self.autoUserLocation else {
                return
            }
            latestUserLocation = autoUserLocation
            
            //**
            guard let mapView = self.mapView else {
                return
            }
            guard let latestUserLocation = self.latestUserLocation else {
                return
            }
            let zoom = mapView.camera.zoom
            let coord = mapView.camera.target
            
            //test > animate map
            CATransaction.begin()
            CATransaction.setValue(0.6, forKey: kCATransactionAnimationDuration)
            mapView.animate(with: GMSCameraUpdate.setTarget(latestUserLocation, zoom: zoom))
            
            let gap = abs(10.0 - zoom)
            let bDuration = 0.6 + ((3.0 - 0.6)/10 * gap)
            CATransaction.setValue(bDuration, forKey: kCATransactionAnimationDuration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)) //test > curve
            mapView.animate(with: GMSCameraUpdate.setTarget(latestUserLocation, zoom: 10)) //default 10
            CATransaction.commit()
            
            //test 3 > user marker id marker map
            if var a = self.markerGeoMarkerIdList[OriginatorId.USER_LOCATION_MARKER_ID] {
//                let b = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                a.changeLocation(coordinate: latestUserLocation) //latestUserLocation
                let point = mapView.projection.point(for: latestUserLocation)
//                a.frame.origin.x = point.x - a.frame.width/2
                a.frame.origin.x = point.x - a.widthOriginOffset/2 //test
                a.frame.origin.y = point.y - a.frame.height
            } else {
                let point = mapView.projection.point(for: latestUserLocation)
                let marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                marker.addLocation(coordinate: latestUserLocation)
                self.view.insertSubview(marker, aboveSubview: mapView)
                self.markerList.append(marker)
                marker.delegate = self
                //test
                marker.configure(data: "a")
                marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
                
                marker.frame.origin.x = point.x - marker.widthOriginOffset/2 //test
                marker.frame.origin.y = point.y - marker.frame.height

                //test > markerId map to marker list
                self.markerGeoMarkerIdList.updateValue(marker, forKey: OriginatorId.USER_LOCATION_MARKER_ID)
                marker.setMarkerId(markerId: OriginatorId.USER_LOCATION_MARKER_ID) //test
            }
        }
        isUserGetLocationClicked = false
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
        print("location fail: \(error)")
    }
    //test > prompt msg for location permission
    @objc func onGetLocationClicked(gesture: UITapGestureRecognizer) {
        
        //test > remove pulsewave when clicked
        stopPulseWave()
        dequeueObject()
        
        //test > indicate whether user specifically clicked get location button
        isUserGetLocationClicked = true
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            print("location getL prompt 1")
//            locationManager.requestLocation() //request location once
            
            //test > use latest user location for fast retrieval
//            if(latestUserLocation.latitude != 0.0 && latestUserLocation.longitude != 0.0) {
//                animateMapToUserLocation()
//            } else {
//                locationManager.requestLocation() //request location once
//            }
            
            //test 2 > use optional latestuserlocation
//            guard let latestUserLocation = self.latestUserLocation else {
            guard let autoUserLocation = self.autoUserLocation else { //for faster location detection
                locationManager.requestLocation() //request location once
                return
            }
            animateMapToUserLocation()
        case .authorizedWhenInUse:
            print("location getL prompt 2")
//            locationManager.requestLocation() //request location once
            
            //test > use latest user location for fast retrieval
//            if(latestUserLocation.latitude != 0.0 && latestUserLocation.longitude != 0.0) {
//                animateMapToUserLocation()
//            } else {
//                locationManager.requestLocation() //request location once
//            }
            
            //test 2 > use optional latestuserlocation
//            guard let latestUserLocation = self.latestUserLocation else {
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
    func openLocationErrorPromptMsg() {
        let panel = GetLocationMsgView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
    }
    func openAppIOSPublicSetting() {
        //direct user off app to IOS public app setting
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    //
    
    //test > login panel
    func openLoginPanel() {
        
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = LoginPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize()
        
        pageList.append(panel)
    }
    
    func openMeListPanel(l : String) {
        
        //test > use reusable method
        if(l == "ep") {
            nextPage(isNextPageScrollable: false)
            
            let panel = UserCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.initializeEditMode()
            panel.delegate = self
            
            pageList.append(panel)
        }
        else if(l == "fr") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MeFollowListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "l") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MeLikeListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "s") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MeBookmarkListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "h") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MeHistoryListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "lo") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MeLocationListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "a") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MePhotoListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "b") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MeVideoListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
        else if(l == "c") {
            nextPage(isNextPageScrollable: false)

            //test > use reusable method
            let panel = MePostListPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.delegate = self
            panel.initialize()
            
            pageList.append(panel)
        }
    }
    
    func getSinglePlacePoint() {
        let id = "g"
        DataFetchManager.shared.fetchSingleGeoData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("gg getsinglepoint api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }

                    //test 2 > new method for id and geodata mapping
                    for i in l {
                        let docId = i.getDocId()
                        let coord = i.getGeoCoord()
                        
                        let geo = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                        let g = GeoData()
                        g.setGeoType(type: GeoDataTypes.PLACEMARKER)
                        g.setGeoCoord(coord: geo)
                        self.markerGeoList.updateValue(g, forKey: docId)
                        
                        self.placeMarkerIdList.append(docId)
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
        
        //old method > direct fetch from firestore
//        let db = Firestore.firestore()
//        let docRef = db.collection("post")
//        docRef
//            .whereField("type", isEqualTo: "story")
//            .whereField("is_public", isEqualTo: true)
//            .whereField("is_suspended", isEqualTo: false)
//            .whereField("is_deleted", isEqualTo: false)
//            .whereField("is_published", isEqualTo: true)
//            .order(by: "time_accelerated", descending: true)
//            .limit(to: 6).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("multifetch place mainrepo data : \(document.documentID) => \(document.data())")
//                        
//                        let geoPoint = document.get("geo") as? GeoPoint
//                        var geo : CLLocationCoordinate2D
//                        if(geoPoint != nil) {
//                            geo = CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
//                            
//                            //test 1
////                            self.placeMarkerGeoList.append(geo)
//                            
//                            //test 2 > new method for id and geodata mapping
//                            let g = GeoData()
//                            g.setGeoType(type: GeoDataTypes.PLACEMARKER)
//                            g.setGeoCoord(coord: geo)
//                            self.markerGeoList.updateValue(g, forKey: document.documentID)
//                            
//                            self.placeMarkerIdList.append(document.documentID)
//                        }
//                    }
//                    
//                    //test > add marker
////                    for entry in self.placeMarkerGeoList {
////                        guard let mapView = self.mapView else {
////                            return
////                        }
////                        let point = mapView.projection.point(for: entry)
////                        print("marker projection point \(point)")
////
////                        //test > add place marker
////                        let marker = PlaceMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
////                        marker.addLocation(coordinate: entry)
////                        self.view.insertSubview(marker, aboveSubview: mapView)
////                        self.placeMarkerList.append(marker)
////                        marker.delegate = self
////                    }
//                }
//        }
    }
    
    //test > temporary test
    var singleUserNumber = 0 //test for fake data
    func showSingleUserPoint(number: Int, pv: ScrollablePanelView) {
        
        //test 2 > new method
//        if let c = pageList[pageList.count - 1] as? PlaceScrollablePanelView {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let markerId = self.placeMarkerIdList[number]
            if var g = self.markerGeoList[markerId] {
                let zoom = mapView.camera.zoom
                let geo = g.getGeoCoord()
                let geoType = g.getGeoType()
                let point = mapView.projection.point(for: geo)
                
                let tZoom = 14.0 // assume to be 14, it will eventually vary accordingly to user situation
                mapView.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: Float(tZoom)))
                
//                c.placeMarkerIdList.append(markerId)
//                print("c panel list: \(c.placeMarkerIdList)")
                
                pv.markerIdList.append(markerId)
                print("pv panel list: \(pv.markerIdList)")
                
                //test 2 > check scrollable id to prevent markers conflict between scrollable panels
                print("show single scrollableid \(pv.getScrollableId()), \(appScrollableId)")
                if(appScrollableId == pv.getScrollableId()) {
        //            let marker = PlaceAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    let marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    marker.addLocation(coordinate: geo)
                    self.view.insertSubview(marker, aboveSubview: mapView)
                    self.markerList.append(marker) //test
                    marker.delegate = self
                    //test
                    marker.configure(data: "a")
                    marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(tZoom)) //try 14, default: zoom
                    
                    marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                    marker.frame.origin.y = point.y - marker.frame.height
                    
                    //test > markerId map to marker list
                    self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                    marker.setMarkerId(markerId: markerId)
                }
            }
        }
    }
    
    //test > temporary test
    var singleSoundNumber = 0 //test for fake data
    func showSingleSoundPoint(number: Int, pv: ScrollablePanelView) {
        
        //test 2 > new method
//        if let c = pageList[pageList.count - 1] as? PlaceScrollablePanelView {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let markerId = self.placeMarkerIdList[number]
            if var g = self.markerGeoList[markerId] {
                let zoom = mapView.camera.zoom
                let geo = g.getGeoCoord()
                let geoType = g.getGeoType()
                let point = mapView.projection.point(for: geo)
                
                let tZoom = 14.0 // assume to be 14, it will eventually vary accordingly to user situation
                mapView.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: Float(tZoom)))
                
//                c.placeMarkerIdList.append(markerId)
//                print("c panel list: \(c.placeMarkerIdList)")
                
                pv.markerIdList.append(markerId)
                print("pv panel list: \(pv.markerIdList)")
                
                //test 2 > check scrollable id to prevent markers conflict between scrollable panels
                print("show single scrollableid \(pv.getScrollableId()), \(appScrollableId)")
                if(appScrollableId == pv.getScrollableId()) {
        //            let marker = PlaceAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    let marker = SoundMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    marker.addLocation(coordinate: geo)
                    self.view.insertSubview(marker, aboveSubview: mapView)
                    self.markerList.append(marker) //test
                    marker.delegate = self
                    marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(tZoom)) //try 14, default: zoom
//                    marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
                    marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                    marker.frame.origin.y = point.y - marker.frame.height
                    
                    //test > markerId map to marker list
                    self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                    marker.setMarkerId(markerId: markerId)
                }
            }
        }
    }
    
    //test > temporary test
    var singleNumber = 0 //test for fake data
    func showSinglePlacePoint(number: Int, pv: ScrollablePanelView) {

        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let markerId = self.placeMarkerIdList[number]
            if var g = self.markerGeoList[markerId] {
                let zoom = mapView.camera.zoom
                let geo = g.getGeoCoord()
                let geoType = g.getGeoType()
                let point = mapView.projection.point(for: geo)
                
                let tZoom = 14.0 // assume to be 14, it will eventually vary accordingly to user situation
                mapView.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: Float(tZoom)))
                
//                c.placeMarkerIdList.append(markerId)
//                print("c panel list: \(c.placeMarkerIdList)")
                
                pv.markerIdList.append(markerId)
                print("pv panel list: \(pv.markerIdList)")
                
                //test 2 > check scrollable id to prevent markers conflict between scrollable panels
                print("show single scrollableid \(pv.getScrollableId()), \(appScrollableId)")
                if(appScrollableId == pv.getScrollableId()) {
        //            let marker = PlaceAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                    marker.addLocation(coordinate: geo)
                    self.view.insertSubview(marker, aboveSubview: mapView)
                    self.markerList.append(marker) //test
                    marker.delegate = self
    //                marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
                    //test
                    marker.configure(data: "a")
                    marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(tZoom)) //try 14, default: zoom

                    marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                    marker.frame.origin.y = point.y - marker.frame.height
                    
                    //test > markerId map to marker list
                    self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                    marker.setMarkerId(markerId: markerId)
                }
            }
        }
    }
    
    //test > show places mini app markers
    func showPlacesMiniPoints(pv: PlacesMiniScrollablePanelView) {
        
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            for entry in placeMarkerIdList {
                let markerId = entry
                if var g = self.markerGeoList[markerId] {
                    let zoom = mapView.camera.zoom
                    let geo = g.getGeoCoord()
                    let geoType = g.getGeoType()
                    let point = mapView.projection.point(for: geo)
                    
                    pv.markerIdList.append(markerId)
                    print("pv panel list: \(pv.markerIdList)")
                    
                    //test 2 check scrollable id
                    print("show placesmini scrollableid \(pv.getScrollableId()), \(appScrollableId)")
                    if(appScrollableId == pv.getScrollableId()) {
            //            let marker = PlaceAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        marker.addLocation(coordinate: geo)
                        self.view.insertSubview(marker, aboveSubview: mapView)
                        self.markerList.append(marker) //test
                        marker.delegate = self
                        //test
                        marker.configure(data: "a")
                        marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
                        
                        marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                        marker.frame.origin.y = point.y - marker.frame.height
                        
                        //test > markerId map to marker list
                        self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                        marker.setMarkerId(markerId: markerId)
                    }
                }
            }
            
            //test > check collision of markers created
            self.mapRefreshObjectsProjectionPoints(withAnimation: true)
            self.mapCheckCollisionPoints(withAnimation: true)
        }
    }
    
    //test > show users mini app markers
    func showUsersMiniPoints(pv: UsersMiniScrollablePanelView) {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            for entry in placeMarkerIdList {
                let markerId = entry
                if var g = self.markerGeoList[markerId] {
                    let zoom = mapView.camera.zoom
                    let geo = g.getGeoCoord()
                    let geoType = g.getGeoType()
                    let point = mapView.projection.point(for: geo)
                    
                    pv.markerIdList.append(markerId)
                    print("pv panel list: \(pv.markerIdList)")
                    
                    //test 2 check scrollable id
                    print("show usersmini scrollableid \(pv.getScrollableId()), \(appScrollableId)")
                    if(appScrollableId == pv.getScrollableId()) {
                        let marker = UserMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                        marker.addLocation(coordinate: geo)
                        self.view.insertSubview(marker, aboveSubview: mapView)
                        self.markerList.append(marker) //test
                        marker.delegate = self
                        marker.hideInfoBox() //test
                        //test
                        marker.configure(data: "a")
                        marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom))
                        
                        marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                        marker.frame.origin.y = point.y - marker.frame.height
                        
                        //test > markerId map to marker list
                        self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
                        marker.setMarkerId(markerId: markerId)
                    }
                }
            }
            
            //test > check collision of markers created
            self.mapRefreshObjectsProjectionPoints(withAnimation: true)
            self.mapCheckCollisionPoints(withAnimation: true)
        }
    }
    
    //test > show place marker for locationselectscrollable
    func showPinLSelectedPoint(pv: LocationSelectScrollablePanelView) {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let zoom = mapView.camera.zoom
            let geo = mapView.camera.target //test
//            let geo = CLLocationCoordinate2D(latitude: 0, longitude: 0) //dummy test
//            let geoType = g.getGeoType()
            let point = mapView.projection.point(for: geo)
            
            if(appScrollableId == pv.getScrollableId()) {
                let marker = LocationPinMarker(frame: CGRect(x: 0 , y: 0, width: 30, height: 30))
//                let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                marker.addLocation(coordinate: geo)
                self.view.insertSubview(marker, aboveSubview: mapView)
                
//                guard let lPinner = lPinner else {
//                    return
//                }
//                self.view.insertSubview(marker, belowSubview: lPinner)
                self.markerList.append(marker) //test
//                marker.delegate = self
                marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom)) //try 14, default: zoom
//                marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
                marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                marker.frame.origin.y = point.y - marker.frame.height
                
//                marker.setOnscreen(os: true) //test > to prevent oncreen animation when map moves
                
                //test > markerId map to marker list
//                self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
//                marker.setMarkerId(markerId: markerId)
            }
        }
    }
    
    func showPlaceLSelectedPoint(pv: LocationSelectScrollablePanelView) {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let zoom = mapView.camera.zoom
            let geo = mapView.camera.target //test
//            let geo = CLLocationCoordinate2D(latitude: 0, longitude: 0) //dummy test
//            let geoType = g.getGeoType()
            let point = mapView.projection.point(for: geo)
            
            if(appScrollableId == pv.getScrollableId()) {
                let marker = PlaceAMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
//                let marker = PlaceBMarker(frame: CGRect(x: point.x - self.MIN_MARKER_DIM/2 , y: point.y - self.MIN_MARKER_DIM, width: self.MIN_MARKER_DIM, height: self.MIN_MARKER_DIM))
                marker.addLocation(coordinate: geo)
                self.view.insertSubview(marker, aboveSubview: mapView)
                
//                guard let lPinner = lPinner else {
//                    return
//                }
//                self.view.insertSubview(marker, belowSubview: lPinner)
                self.markerList.append(marker) //test
                marker.delegate = self
                //test
                marker.configure(data: "a")
                marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom)) //try 14, default: zoom
                
//                marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
                marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                marker.frame.origin.y = point.y - marker.frame.height
                
                marker.setOnscreen(os: true) //test > to prevent oncreen animation when map moves
                
                //test > markerId map to marker list
//                self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
//                marker.setMarkerId(markerId: markerId)
            }
        }
    }
    
    func showPinLocation(pv: LocationSelectScrollablePanelView) {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let zoom = mapView.camera.zoom
            let geo = mapView.camera.target //test
//            let geo = CLLocationCoordinate2D(latitude: 0, longitude: 0) //dummy test
//            let geoType = g.getGeoType()
            let point = mapView.projection.point(for: geo)
            
            if(appScrollableId == pv.getScrollableId()) {
//                let marker = LocationPinMarker(frame: CGRect(x: 0 , y: 0, width: 30, height: 30))
//                self.view.insertSubview(marker, aboveSubview: mapView)
//                marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
//                marker.frame.origin.y = point.y - marker.frame.height
                
                lPinner = LocationPinMarker(frame: CGRect(x: 0 , y: 0, width: 30, height: 30))
                guard let lPinner = lPinner else {
                    return
                }
//                self.view.insertSubview(lPinner, aboveSubview: mapView)
                self.view.insertSubview(lPinner, belowSubview: pv)
//                self.view.addSubview(lPinner)
//                lPinner.frame.origin.x = point.x - lPinner.frame.width/2 //update position after changesize()
                lPinner.frame.origin.x = point.x - lPinner.widthOriginOffset/2
                lPinner.frame.origin.y = point.y - lPinner.frame.height
            }
            
            //test > live gps location btn for locationselect
            llMini.bottomAnchor.constraint(equalTo: pv.topAnchor, constant: -10).isActive = true
            llMini.isHidden = false
        }
    }
    
    func showLiveLLocationSelect(pv: LocationSelectScrollablePanelView) {
        if pageList[pageList.count - 1] == pv { //test > new checker

            guard let mapView = self.mapView else {
                return
            }
            
            let zoom = mapView.camera.zoom
//            let geo = mapView.camera.target //test
            let geo = CLLocationCoordinate2D(latitude: 0, longitude: 0) //dummy test
//            let geoType = g.getGeoType()
            let point = mapView.projection.point(for: geo)
            
            if(appScrollableId == pv.getScrollableId()) {
                let marker = LiveLMarker(frame: CGRect(x: 0 , y: 0, width: 16, height: 16))
                marker.addLocation(coordinate: geo)
                self.view.insertSubview(marker, aboveSubview: mapView)
                self.markerList.append(marker) //test
//                marker.delegate = self
                marker.initialize(withAnimation: true, changeSizeZoom: CGFloat(zoom)) //try 14, default: zoom
//                marker.frame.origin.x = point.x - marker.frame.width/2 //update position after changesize()
                marker.frame.origin.x = point.x - marker.widthOriginOffset/2
                marker.frame.origin.y = point.y - marker.frame.height
                
                //test > markerId map to marker list
//                self.markerGeoMarkerIdList.updateValue(marker, forKey: markerId)
//                marker.setMarkerId(markerId: markerId)
            }
        }
    }
    
    //test > remove only selected place and pin, leave live location aside
    func mapRemoveLSelectedPoints() {
        if(!markerList.isEmpty) {
            var rList = [Int]()
            var i = 0
            for entry in markerList {
                if let a = entry as? LiveLMarker {
                    
                } else {
                    rList.append(i)
                    entry.close()
                }
                
                i += 1
            }
            for e in rList {
                markerList.remove(at: e)
            }
        }
        
        //test
        isCollided = false
    }
    
    //test > open video panel with UIView
    func openVideoPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int) {
        openVideoPanel(offX: offX, offY: offY, originatorView: originatorView, originatorViewType: originatorViewType, id: id, originatorViewId: "", preterminedDatasets: [String](), mode: VideoTypes.V_LOOP)
    }
    
    func openVideoPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int, originatorViewId: String) {
        openVideoPanel(offX: offX, offY: offY, originatorView: originatorView, originatorViewType: originatorViewType, id: id, originatorViewId: originatorViewId, preterminedDatasets: [String](), mode: VideoTypes.V_LOOP)
    }
    
    func openVideoPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int, originatorViewId: String, preterminedDatasets: [String], mode: String) {
        
        nextPage(isNextPageScrollable: false)

        //add video panel
        let videoPanel = VideoPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(videoPanel)
        videoPanel.translatesAutoresizingMaskIntoConstraints = false
        videoPanel.heightAnchor.constraint(equalToConstant: self.view.frame.size.height).isActive = true
        videoPanel.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        videoPanel.layer.masksToBounds = true
        videoPanel.delegate = self
//        videoPanel.layer.opacity = 0.3

        pageList.append(videoPanel)

        //test > centralize open video process here
        videoPanel.setOriginatorViewType(type: originatorViewType)
        videoPanel.setId(id: id)
        //test > marker id
        videoPanel.setOriginatorId(originatorId: originatorViewId)
        
        //test > predetermined datasets > video enlarged from posts
        videoPanel.setPreterminedDatasets(datasets: preterminedDatasets)
        videoPanel.setUiMode(mode: mode)
        
        //test > to be removed soon
        if(originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW) {
            videoPanel.setDatasetUI(isMultiTab: true)
        } else {
            videoPanel.setDatasetUI(isMultiTab: false)
        }

        if(originatorViewType == OriginatorTypes.MARKER) {
            guard let a = originatorView as? ExploreMarker else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set markerhight adjustment
            let markerHeight = a.frame.size.height
            let adjustmentY = -markerHeight/2
            //*set coord
            videoPanel.setCoordinateLocation(coord: coord)
            videoPanel.setAdjustmentY(adY: adjustmentY)
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2 + adjustmentY //as marker is floating on top real coordinate, not right at center
            
            videoPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else if (originatorViewType == OriginatorTypes.PLACEMARKER) {
            guard let a = originatorView as? PlaceMarker else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set markerhight adjustment
            let markerHeight = a.frame.size.height
            let adjustmentY = -markerHeight/2
            //*set coord
            videoPanel.setCoordinateLocation(coord: coord)
            videoPanel.setAdjustmentY(adY: adjustmentY)
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2 + adjustmentY //as marker is floating on top real coordinate, not right at center
            
            videoPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else if(originatorViewType == OriginatorTypes.PULSEWAVE) {
            guard let a = originatorView as? PulseWave else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set coord
            videoPanel.setCoordinateLocation(coord: coord)
            //*set blackout
            videoPanel.setTypeBlackOut()
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2
            
            videoPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else {
            //includes uicollectionviews from sound panel, user panel
            videoPanel.open(offX: offX, offY: offY, delay: 0.0, isAnimated: true)
        }
    }
    
    //test 2 > extend open post panel to map markers
    func openPostPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int) {
        openPostPanel(offX: offX, offY: offY, originatorView: originatorView, originatorViewType: originatorViewType, id: id, originatorViewId: "")
    }
    func openPostPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int, originatorViewId: String) {
        
        nextPage(isNextPageScrollable: false)
        
        //test > use reusable method
        let postPanel = PostPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(postPanel)
        postPanel.translatesAutoresizingMaskIntoConstraints = false
        postPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        postPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        postPanel.delegate = self
        
        pageList.append(postPanel)
        
        //test > centralize open video process here
        postPanel.setOriginatorViewType(type: originatorViewType)
        postPanel.setId(id: id)
        //test > marker id
        postPanel.setOriginatorId(originatorId: originatorViewId)
        
        //test > to be removed soon
        if(originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW) {
            postPanel.setDatasetUI(isMultiTab: true)
        } else {
            postPanel.setDatasetUI(isMultiTab: false)
        }
        
        if(originatorViewType == OriginatorTypes.MARKER) {
            guard let a = originatorView as? ExploreMarker else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set markerhight adjustment
            let markerHeight = a.frame.size.height
            let adjustmentY = -markerHeight/2
            //*set coord
            postPanel.setCoordinateLocation(coord: coord)
            postPanel.setAdjustmentY(adY: adjustmentY)
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2 + adjustmentY //as marker is floating on top real coordinate, not right at center
            
            postPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else if (originatorViewType == OriginatorTypes.PLACEMARKER) {
            guard let a = originatorView as? PlaceMarker else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set markerhight adjustment
            let markerHeight = a.frame.size.height
            let adjustmentY = -markerHeight/2
            //*set coord
            postPanel.setCoordinateLocation(coord: coord)
            postPanel.setAdjustmentY(adY: adjustmentY)
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2 + adjustmentY //as marker is floating on top real coordinate, not right at center
            
            postPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else if(originatorViewType == OriginatorTypes.PULSEWAVE) {
            guard let a = originatorView as? PulseWave else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set coord
            postPanel.setCoordinateLocation(coord: coord)
            //*set blackout
            postPanel.setTypeBlackOut()
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2
            
            postPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else {
            //includes uicollectionviews from sound panel, user panel
            postPanel.open(offX: offX, offY: offY, delay: 0.0, isAnimated: true)
        }
    }

    //test 2 > extend open photo panel to map markers
    func openPhotoPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int) {
//        openPhotoPanel(offX: offX, offY: offY, originatorView: originatorView, originatorViewType: originatorViewType, id: id, originatorViewId: "")
        openPhotoPanel(offX: offX, offY: offY, originatorView: originatorView, originatorViewType: originatorViewType, id: id, originatorViewId: "", preterminedDatasets: [String]())
    }
    func openPhotoPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int, originatorViewId: String, preterminedDatasets: [String]) {
//    func openPhotoPanel(offX: CGFloat, offY: CGFloat, originatorView: UIView, originatorViewType: String, id: Int, originatorViewId: String) {
        
        nextPage(isNextPageScrollable: false)
        
        //test > use reusable method
        let photoPanel = PhotoPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(photoPanel)
        photoPanel.translatesAutoresizingMaskIntoConstraints = false
        photoPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        photoPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        photoPanel.delegate = self
        
        pageList.append(photoPanel)
        
        //test > centralize open video process here
        photoPanel.setOriginatorViewType(type: originatorViewType)
        photoPanel.setId(id: id)
        //test > marker id
        photoPanel.setOriginatorId(originatorId: originatorViewId)
        
        //test > predetermined datasets > video enlarged from posts
        photoPanel.setPreterminedDatasets(datasets: preterminedDatasets)
        
        //test > to be removed soon
        if(originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW) {
            photoPanel.setDatasetUI(isMultiTab: true)
        } else {
            photoPanel.setDatasetUI(isMultiTab: false)
        }
        
        if(originatorViewType == OriginatorTypes.MARKER) {
            guard let a = originatorView as? ExploreMarker else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set markerhight adjustment
            let markerHeight = a.frame.size.height
            let adjustmentY = -markerHeight/2
            //*set coord
            photoPanel.setCoordinateLocation(coord: coord)
            photoPanel.setAdjustmentY(adY: adjustmentY)
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2 + adjustmentY //as marker is floating on top real coordinate, not right at center
            
            photoPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else if (originatorViewType == OriginatorTypes.PLACEMARKER) {
            guard let a = originatorView as? PlaceMarker else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set markerhight adjustment
            let markerHeight = a.frame.size.height
            let adjustmentY = -markerHeight/2
            //*set coord
            photoPanel.setCoordinateLocation(coord: coord)
            photoPanel.setAdjustmentY(adY: adjustmentY)
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2 + adjustmentY //as marker is floating on top real coordinate, not right at center
            
            photoPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else if(originatorViewType == OriginatorTypes.PULSEWAVE) {
            guard let a = originatorView as? PulseWave else {
                return
            }
            guard let coord = a.coordinateLocation else {
                return
            }
            //*set coord
            photoPanel.setCoordinateLocation(coord: coord)
            //*set blackout
            photoPanel.setTypeBlackOut()
            //*open video panel
            guard let mapView = self.mapView else {
                return
            }
            let point = mapView.projection.point(for: coord)
            let offsetX = point.x - self.view.frame.width/2
            let offsetY = point.y - self.view.frame.height/2
            
            photoPanel.open(offX: offsetX, offY: offsetY, delay: 0.0, isAnimated: true)
        } else {
            //includes uicollectionviews from sound panel, user panel
            photoPanel.open(offX: offX, offY: offY, delay: 0.0, isAnimated: true)
        }
    }
    
    //test > places mini apps open
    func openPlacesMiniPanel() {
        //test > dequeue before transition
        stopPulseWave()
        dequeueObject()
        
        //test
        nextPage(isNextPageScrollable: true)
        
        bBox.isHidden = false
        bBoxBtn.isHidden = false

        turnOnPlacesMiniSemiTransparent(type: "l")
        
        let panel = PlacesMiniScrollablePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        
        pageList.append(panel)
        
        panel.panelTopCons = panel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        panel.panelTopCons?.isActive = true
        panel.initialize()
        
        //test > generate map scrollable id
        appScrollableId = generateRandomId()
        panel.setScrollableId(id: appScrollableId)
    }
    
    //test > users mini apps open
    func openUsersMiniPanel() {
        //test > dequeue before transition
        stopPulseWave()
        dequeueObject()
        
        //test
        nextPage(isNextPageScrollable: true)
        
        bBox.isHidden = false
        bBoxBtn.isHidden = false

        turnOnPlacesMiniSemiTransparent(type: "c")
        
        let panel = UsersMiniScrollablePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        
        pageList.append(panel)
        
        panel.panelTopCons = panel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        panel.panelTopCons?.isActive = true
        panel.initialize()
        
        //test > generate map scrollable id
        appScrollableId = generateRandomId()
        panel.setScrollableId(id: appScrollableId)
    }
    
    func openUserPanel() {
        openUserPanel(id: "") //default
    }
    func openUserPanel(id: String) {
        
        //test 2 > user scrollable
        stopPulseWave()
        dequeueObject()
        
        //test
        nextPage(isNextPageScrollable: true)
        
        bBox.isHidden = false
        bBoxBtn.isHidden = false

        turnOnPlacesMiniSemiTransparent(type: "u")
        
        let panel = UserScrollablePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        
        pageList.append(panel)
        
        //test > generate map scrollable id
        appScrollableId = generateRandomId()
        panel.setScrollableId(id: appScrollableId)
        
        //test > set objectid for fetching data
        panel.setObjectId(id: id) //"u"
        
        //test > initialize panel
        panel.panelTopCons = panel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        panel.panelTopCons?.isActive = true
        panel.initialize()
    }
    
    func openPlacePanel() {
        openPlacePanel(id: "") //default
    }
    func openPlacePanel(id: String) {
        //test > dequeue before transition
        stopPulseWave()
        dequeueObject()
        
        //test
        nextPage(isNextPageScrollable: true)
        
        bBox.isHidden = false
        bBoxBtn.isHidden = false

        turnOnPlacesMiniSemiTransparent(type: "p")
        
        let panel = PlaceScrollablePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        
        pageList.append(panel)
        
        //test > generate map scrollable id
        appScrollableId = generateRandomId()
        panel.setScrollableId(id: appScrollableId)
        
        //test > set objectid for fetching data
        panel.setObjectId(id: id) //"p"
        
        //test > initialize panel
        panel.panelTopCons = panel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        panel.panelTopCons?.isActive = true
        panel.initialize()
        
        //test > show place marker on upper half map
//        showSinglePlacePoint()
        
        //test
//        panel.layer.opacity = 0.3
        
        //test > move map up
//        showSinglePlacePoint(number: singleNumber)
//        singleNumber += 1
        ///
    }
    
    //close entire place panel
    @objc func onBackPlacePanelClicked(gesture: UITapGestureRecognizer) {
        
        //test > close panel from bbox btn
//        let a = pageList[pageList.count - 1] as? PlaceScrollablePanelView
        let a = pageList[pageList.count - 1] as? ScrollablePanelView
        
        //test > animation only needed if back to main page
        if(pageList.count <= 1) {
            a?.close(isAnimated: true)
        } else {
            a?.close(isAnimated: false)
        }
    }
    
//test > method 2 => non-scrollable
//    func openSoundPanel() {
//        //test > dequeue before transition
//        stopPulseWave()
//        dequeueVideo()
//
//        //test
//        nextPage(isNextPageScrollable: false)
//
//        //add sound panel
//        let soundPanel = SoundPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        self.view.addSubview(soundPanel)
//        soundPanel.translatesAutoresizingMaskIntoConstraints = false
//        soundPanel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
//        soundPanel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//        soundPanel.delegate = self
//
//        pageList.append(soundPanel)
//
//        //test > set objectid for fetching data
//        soundPanel.setObjectId(id: "s")
//
//        //test > initialize panel
//        soundPanel.initialize()
//    }
    
    //test > method 2 => try scrollable for sound panel
    func openSoundPanel() {
        openSoundPanel(id: "") //default
    }
    func openSoundPanel(id: String) {
        //test > dequeue before transition
        stopPulseWave()
        dequeueObject()

        //test
        nextPage(isNextPageScrollable: true)

        bBox.isHidden = false
        bBoxBtn.isHidden = false

        turnOnPlacesMiniSemiTransparent(type: "s")

        let panel = SoundScrollablePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self

        pageList.append(panel)

        //test > generate map scrollable id
        appScrollableId = generateRandomId()
        panel.setScrollableId(id: appScrollableId)

        //test > set objectid for fetching data
        panel.setObjectId(id: id) //"s"

        //test > initialize panel
        panel.panelTopCons = panel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        panel.panelTopCons?.isActive = true
        panel.initialize()
    }
    
    func openVideoCreatorPanel() {

        //test 2 > more specific method
        openVideoCreatorPanel(objectType: "", objectId: "", mode: "")
    }
    
    func openVideoCreatorPanel(objectType: String, objectId: String, mode: String) {
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = VideoCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        
        //test > try initialize
        panel.initialize(topInset: topInset, bottomInset: bottomInset)

        pageList.append(panel)
        
        if(objectType == "p") {
            if(mode == "tag") {
                panel.setPredesignatedPlace(p: "p")
            }
            else {
                panel.setPredesignatedPlace(p: "p")
            }
        }
        else if(objectType == "s") {
            if(mode == "tag") {
                panel.setPredesignatedSound(s: "s")
            }
            else {
                panel.setPredesignatedSound(s: "s")
            }
        }
    }
    
    func openPostCreatorPanel() {

        //test 2 > more specific method
        openPostCreatorPanel(objectType: "", objectId: "", mode: "")
    }
    
    func openPostCreatorPanel(objectType: String, objectId: String, mode: String) {
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = PostCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        
        //mode => tag or quote
        if(objectType == "p") {
            if(mode == "tag") {
                panel.setPredesignatedPlace(p: "p")
            }
            else {
                panel.setPredesignatedPlace(p: "p")
            }
        }
        else if(objectType == "s") {
            panel.setQuoteObject(type: "s", id: "#")
        }
        else if(objectType == "post") {
            panel.setQuoteObject(type: "quote", id: "#")
        }
        else if(objectType == "photo") {
            panel.setQuoteObject(type: "photo_s", id: "#")
        }
        else if(objectType == "video") {
            panel.setQuoteObject(type: "video_l", id: "#")
        }
        //*
        
        panel.initialize(topInset: topInset, bottomInset: bottomInset)
        
        pageList.append(panel)

    }
    
    func openPhotoCreatorPanel() {

        //test 2 > more specific method
        openPhotoCreatorPanel(objectType: "", objectId: "", mode: "")
    }
    
    func openPhotoCreatorPanel(objectType: String, objectId: String, mode: String) {
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = PhotoCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize(topInset: topInset, bottomInset: bottomInset)
        
        pageList.append(panel)
        
        if(objectType == "p") {
            if(mode == "tag") {
                panel.setPredesignatedPlace(p: "p")
            }
            else {
                panel.setPredesignatedPlace(p: "p")
            }
        }
        else if(objectType == "s") {
            if(mode == "tag") {
                panel.setPredesignatedSound(s: "s")
            }
            else {
                panel.setPredesignatedSound(s: "s")
            }
        }
    }
    
    func openPlaceCreatorPanel() {
        
        //test 2 > more specific method
        openPlaceCreatorPanel(objectType: "", objectId: "", mode: "")
    }
    
    func openPlaceCreatorPanel(objectType: String, objectId: String, mode: String) {
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = PlaceCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize(topInset: topInset, bottomInset: bottomInset)

        pageList.append(panel)
        
        if(objectType == "p") {
            if(mode == "tag") {
                panel.setPredesignatedPlace(p: "p")
            }
            else {
                panel.setPredesignatedPlace(p: "p")
            }
        }
    }
    
    //test > open location select scrollable panel
    func openLocationSelectScrollablePanel() {
        stopPulseWave()
        dequeueObject()
        
        nextPage(isNextPageScrollable: true)

        bBox.isHidden = false
        bBoxBtn.isHidden = false

        turnOnPlacesMiniSemiTransparent(type: "")

        let panel = LocationSelectScrollablePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self

        pageList.append(panel)

        panel.panelTopCons = panel.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        panel.panelTopCons?.isActive = true
        panel.initialize()

        //test > generate map scrollable id
        appScrollableId = generateRandomId()
        panel.setScrollableId(id: appScrollableId)
    }
    
//    func openUserCreatorPanel() {
//        //test > dequeue before transition => redundant but can be added if needed
////        stopPulseWave()
////        dequeueVideo()
//
//        //test
//        nextPage(isNextPageScrollable: false)
//
//        //test > use reusable method
//        let panel = UserCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        self.view.addSubview(panel)
//        panel.translatesAutoresizingMaskIntoConstraints = false
//        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
//        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//        panel.delegate = self
//
//        pageList.append(panel)
//    }
    
    //test > open draft panel
    func openPostDraftPanel() {
        let panel = PostDraftPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize()
    }
    
    func openPhotoDraftPanel() {
        let panel = PhotoDraftPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize()
    }
    
    func openPlaceDraftPanel() {
        let panel = PlaceDraftPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize()
    }
    
    func openVideoDraftPanel() {
        let panel = VideoDraftPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.initialize()
    }
    
    //test > shift post detail to viewcontroller and include in [page] array
    func openPostDetailPanel() {
        openPostDetailPanel(id: "") //default
    }
    //test > real id for fetching data
    func openPostDetailPanel(id: String) {
        
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = PostDetailPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.setId(id: id)
        panel.initialize()
        panel.delegate = self
        
        pageList.append(panel)
        
        print("pagelist : \(pageList)")
    }
    func openPhotoDetailPanel() {
        openPhotoDetailPanel(id: "") //default
    }
    func openPhotoDetailPanel(id: String) {
        
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = PhotoDetailPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.setId(id: id)
        panel.initialize()
        panel.delegate = self
        
        pageList.append(panel)
    }
    func openPhotoZoomPanel(offX: CGFloat, offY: CGFloat) {
        
        //test 1 > as not scrollable panel
        nextPage(isNextPageScrollable: false)

        //test > use reusable method
        let panel = PhotoZoomPanelView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.delegate = self
        panel.open(offX: offX, offY: offY, delay: 0.0, isAnimated: true)
        
        pageList.append(panel)
    }
    //test > share object panel for more actions on user, place etc
    func openShareObjectPanel(data: String) {
        
        //test 1 > as not scrollable panel
//        nextPage(isNextPageScrollable: false) //ori

        //test > use reusable method
        let panel = ShareObjectScrollableView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        panel.setObjectType(t: data)
        panel.delegate = self
        
//        pageList.append(panel)
        
        //test > try initialize
        panel.initialize()
    }
    
    //test > in-app msg for progress uploading post
    var inAppMsgList = [InAppMsgView]()
    func openInAppMsgView(data: String) {
        
        //test 2 > check for empty in-app msg first
        if(inAppMsgList.isEmpty) {
            let panel = InAppMsgView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.view.addSubview(panel)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            panel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            panel.panelTopCons = panel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
            panel.panelTopCons?.isActive = true
            panel.updateConfigUI(data: data, taskId: "a")
            panel.delegate = self
            
            inAppMsgList.append(panel)
        }
    }
    
    func generateRandomId() -> Int{
        //10 million as base to avoid duplicate
        return Int.random(in: 0..<10000000)
    }
    
    //test > page transition when removing a page, back to previous page
    func backPage(isCurrentPageScrollable: Bool) {
        
        //***test > refactor from scrollablepanelviews
        bBox.isHidden = true
        bBoxBtn.isHidden = true

        turnOnPlacesMiniSemiTransparent(type: "a")
        
//        locationPinner.isHidden = true //test > hide locationselectionmarker
        lPinner?.isHidden = true //test > hide locationselectionmarker
        llMini.isHidden = true //test
        unhideMiniApps()
        unhideMenuPanel()
        //***
        
        //test > dismiss RHS content filter btn
        hideRMapSettingBtn()
        
        //test > remove last page
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
        }

        print("page: \(pageList.count)")
        
        //test > check if current page is scrollable, if no, show the previous page
        if(!pageList.isEmpty) {
            
            let a = pageList[pageList.count - 1] as PanelView
            a.isHidden = false
            print("backpage 1")
            
            //test > video panel resume play video
            a.resumeActiveState()
            
            if let c = pageList[pageList.count - 1] as? ScrollablePanelView { //test scrollable type in general
                bBox.isHidden = false
                bBoxBtn.isHidden = false
                
                //test
                if let d = c as? PlaceScrollablePanelView {
                    print("state backpage 2.1: ")
                    turnOnPlacesMiniSemiTransparent(type: "p")
                } else if let e = c as? UserScrollablePanelView {
                    print("state backpage 2.2 ")
                    turnOnPlacesMiniSemiTransparent(type: "u")
                } else if let f = c as? PlacesMiniScrollablePanelView {
                    print("state backpage 2.2 ")
                    turnOnPlacesMiniSemiTransparent(type: "l")
                } else if let h = c as? UsersMiniScrollablePanelView {
                    print("state backpage 2.2 ")
                    turnOnPlacesMiniSemiTransparent(type: "c")
                } else if let i = c as? SoundScrollablePanelView {
                    print("state backpage 2.2 ")
                    turnOnPlacesMiniSemiTransparent(type: "s")
                }
                //test > add location
                else if let g = c as? LocationSelectScrollablePanelView {
                    print("state backpage 2.3 ")
                    turnOnPlacesMiniSemiTransparent(type: "")
//                    locationPinner.isHidden = false
                    lPinner?.isHidden = false
                    llMini.isHidden = false
                }
                
                hideMiniApps()//test
                hideMenuPanel()//test

                if(isCurrentPageScrollable) {
                    print("state backpage 2")
                    mapRevertScrollableMarkerTransition(c: c, withAnimation: true) // try with animation
                }
            
            } else {
                //if NOT scrollable panel
                if(pageList.count >= 2) {
                    let b = pageList[pageList.count - 2] as PanelView
                    b.isHidden = false
                    print("backpage 3")
                    
                    if let c = pageList[pageList.count - 2] as? ScrollablePanelView {
                        bBox.isHidden = false
                        bBoxBtn.isHidden = false
                        
                        //test > hide semitransparentbox differently
                        if let d = c as? PlaceScrollablePanelView {
                            print("state backpage 4.1: ")
                            turnOnPlacesMiniSemiTransparent(type: "p")
                        } else if let e = c as? UserScrollablePanelView {
                            print("state backpage 2.2 ")
                            turnOnPlacesMiniSemiTransparent(type: "u")
                        } else if let f = c as? PlacesMiniScrollablePanelView {
                            print("state backpage 4.2 ")
                            turnOnPlacesMiniSemiTransparent(type: "l")
                        } else if let h = c as? UsersMiniScrollablePanelView {
                            print("state backpage 4.2 ")
                            turnOnPlacesMiniSemiTransparent(type: "c")
                        } else if let i = c as? SoundScrollablePanelView {
                            print("state backpage 4.2 ")
                            turnOnPlacesMiniSemiTransparent(type: "s")
                        }
                        //test > add location
                        else if let g = c as? LocationSelectScrollablePanelView {
                            print("state backpage 4.3 ")
                            turnOnPlacesMiniSemiTransparent(type: "")
//                            locationPinner.isHidden = false
                            lPinner?.isHidden = false
                            llMini.isHidden = false
                        }
                        
                        hideMiniApps()//test
                        hideMenuPanel()//test
                        
                        mapRevertScrollableMarkerTransition(c: c, withAnimation: false)
                        print("state backpage 4")
                    }
                } else {
                    //left with 1 unscrollable panel
                    mapRevertMarkerTransition(withAnimation: false)
                    print("backpage 5 : =>\(pageList.count), \(appMenuMode)")
                    
                    //*new test > search panel, notify panel
                    revertAppMainPanel()
                    //*
                }
            }
        } else {
            //back to main page
            print("backpage 6")
            if(isCurrentPageScrollable) {
                mapRevertMarkerTransition(withAnimation: true) // try with animation
                
                //*new test > search panel, notify panel
//                revertAppMainPanel()
                revertAppMainPanel(isToRevertUIState: true)
                //*
            }
            //test > include unscrollable panel
            else {
//                revertAppMainPanel()
                revertAppMainPanel(isToRevertUIState: true)
            }
        }
    }
    
    func nextPage(isNextPageScrollable: Bool) {
        //test > ensure previous pages to be hidden
        if(pageList.count >= 2) {
            let a = pageList[pageList.count - 2] as PanelView
            a.isHidden = true
        }
        
        //test > hide current page when next page is of type: scrollable with map
        if(isNextPageScrollable) {
            if(!pageList.isEmpty) {
                let a1 = pageList[pageList.count - 1]
                a1.isHidden = true
            }
            
            //test > remove markers from map
            mapRemoveMarkers()
            
            //*new test > search panel, notify panel
            clearAppMainPanel()
            //*
            
            hideMiniApps()//test
            hideMenuPanel()//test
        }
        
        //test > dismiss RHS content filter btn
        hideRMapSettingBtn()
        
        print("page: \(pageList)")
        
        //test > memorize map zoom and position of current page
        guard let zoom = mapView?.camera.zoom else {
            return
        }
        guard let target = mapView?.camera.target else {
            return
        }
        print("nextpage map: \(zoom), \(target)")
        if(!pageList.isEmpty) {
            if let c = pageList[pageList.count - 1] as? ScrollablePanelView {
//            if let c = pageList[pageList.count - 1] as? PlaceScrollablePanelView {
//                print("nextpage map 1: \(zoom), \(target)")
                c.setStateTarget(target: target)
                c.setStateZoom(zoom: zoom)
                print("nextpage map 2: \(c.getStateTarget()), \(c.getStateZoom())")
            }
        } else {
            setStateTarget(target: target)
            setStateZoom(zoom: zoom)
        }
    
    }
    
    func setStateTarget(target: CLLocationCoordinate2D) {
        stateMapTargetCoordinates = target
    }
    func setStateZoom(zoom: Float) {
        stateMapTargetZoom = zoom
    }
    func getStateTarget() -> CLLocationCoordinate2D {
        return stateMapTargetCoordinates
    }
    func getStateZoom() -> Float {
        return stateMapTargetZoom
    }
    
    func clearAppMainPanel() {
        searchPanel.isHidden = true
        notifyPanel.isHidden = true
        mePanel.isHidden = true
    }
    
    func revertAppMainPanel() {
        print("revert resume active \(appMenuMode)")
        if(appMenuMode == "search") {
            searchPanel.isHidden = false
            searchPanel.resumeActiveState()
        } else if(appMenuMode == "notify") {
            notifyPanel.isHidden = false
            notifyPanel.resumeActiveState()
        } else if(appMenuMode == "profile") {
            mePanel.isHidden = false
            mePanel.resumeActiveState()
        } else if(appMenuMode == "create") {
            createSelectPanel?.resumeActiveState()
        }
    }
    
    func revertAppMainPanel(isToRevertUIState: Bool) {
        print("revert resume active 2 \(appMenuMode)")
        if(appMenuMode == "search") {
            searchPanel.isHidden = false
//            searchPanel.resumeActiveState()
//            if(isToRevertUIState) {
//                searchPanel.revertCellUIState()
//            }
            searchPanel.resumeActiveState(isToRevertUIState: isToRevertUIState) //uistate for video and photo
        } else if(appMenuMode == "notify") {
            notifyPanel.isHidden = false
            notifyPanel.resumeActiveState()
        } else if(appMenuMode == "profile") {
            mePanel.isHidden = false
            mePanel.resumeActiveState()
        } else if(appMenuMode == "create") {
            createSelectPanel?.resumeActiveState()
        }
    }
    
    //*test confetti
    //problem: it does not work with maskstobounds, does not obey to size of view
    let emitter = CAEmitterLayer()
    func createParticles() {
        
        //test > new method for snow
//        let emitter = CAEmitterLayer()
//        emitter.masksToBounds = true //problem**
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let near = makeEmmiterCell(color: UIColor(white: 1, alpha: 1), velocity: 100, scale: 0.3)
        let middle = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.66), velocity: 80, scale: 0.2)
        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 60, scale: 0.1)
        
        emitter.emitterCells = [near, middle, far]
        
        let uView = UIView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 100))
        view.addSubview(uView)
        uView.layer.cornerRadius = 10 //10
        uView.isUserInteractionEnabled = false
        uView.layer.addSublayer(emitter)
    }
    
    //test > new method for snow
    func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 20.0
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
    
    func stopParticles(){
        emitter.birthRate = 0
    }
    
    func startParticles(){
        emitter.birthRate = 1
    }
    //*confetti test ends
    
    //map foundation > artificial zoom by uipinchgesture & scroll by uipangesture
//    func turnOnArtificialMapPinch() {
//        //test
//        mapView?.settings.zoomGestures = false
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onMapPinch))
//        pinchGesture.delegate = self
//        mapView?.addGestureRecognizer(pinchGesture)
//    }
//
//    func turnOnArtificialMapPan() {
//        //test
//        mapView?.settings.scrollGestures = false
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onMapPan))
//        panGesture.delegate = self
//        mapView?.addGestureRecognizer(panGesture)
//    }
    
//    var initialMapZoomLevel: Float = 0
//    var mapPinchCenter = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//    var mapZoomLevel0: Float = 0
//    var mapTarget0 = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//    @objc func onMapPinch(gesture : UIPinchGestureRecognizer) {
//        let scale = gesture.scale
//        let velocity = gesture.velocity
//        let pinchCenter = CGPoint(x: gesture.location(in: view).x,
//                                  y: gesture.location(in: view).y)
//        if let view = gesture.view {
//            switch gesture.state {
//            case .began:
//
//                guard let zoom = mapView?.camera.zoom else {
//                    return
//                }
//                guard let target = mapView?.camera.target else {
//                    return
//                }
//
//                guard let pinchTarget = mapView?.projection.coordinate(for: pinchCenter) else {
//                    return
//                }
////                print("onMapPinch start \(pinchCenter), \(gesture.scale), \(target)")
//                print("onMapPinch start  \(scale), \(velocity), \(pinchCenter)")
//                mapPinchCenter = pinchTarget
//                initialMapZoomLevel = zoom
//                mapTarget0 = target
//                mapZoomLevel0 = zoom
//
//            case .changed:
//
//                guard let target = mapView?.camera.target else {
//                    return
//                }
//                var realZoomDelta = 0.0
//                var newZoom: Float = 0.0
//                if(scale < 1) {
//                    realZoomDelta = 1/scale - 1
//                    newZoom = initialMapZoomLevel - Float(realZoomDelta)
//                } else {
//                    realZoomDelta = scale - 1
//                    newZoom = initialMapZoomLevel + Float(realZoomDelta)
//                }
//
//                print("onMapPinch change \(scale), \(velocity), \(pinchCenter)")
////                gesture.scale = 1
//
//                //test
//                var newLat = 0.0
//                var newLng = 0.0
//                if(velocity < 0) {
//                    //shrink
//                    let dZoom = (newZoom - mapZoomLevel0)/(10.0 - mapZoomLevel0)
////                    let maxZoom = mapZoomLevel0 + 9.0
////                    let dZoom = (newZoom - mapZoomLevel0)/(maxZoom - mapZoomLevel0)
//                    newLat = mapTarget0.latitude + (Double(dZoom) * (mapPinchCenter.latitude - mapTarget0.latitude))
//                    newLng = mapTarget0.longitude + (Double(dZoom) * (mapPinchCenter.longitude - mapTarget0.longitude))
//                    let geo = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
//                    mapView?.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: newZoom))
//                    print("apinch change A \(dZoom), \(newZoom), \(newLat), \(newLng)")
//                } else if(velocity > 0) {
//                    //expand
//                    let dZoom = (newZoom - mapZoomLevel0)/(10.0 - mapZoomLevel0)
////                    let maxZoom = mapZoomLevel0 + 9.0
////                    let dZoom = (newZoom - mapZoomLevel0)/(maxZoom - mapZoomLevel0)
//                    newLat = mapTarget0.latitude + (Double(dZoom) * (mapPinchCenter.latitude - mapTarget0.latitude))
//                    newLng = mapTarget0.longitude + (Double(dZoom) * (mapPinchCenter.longitude - mapTarget0.longitude))
////                    if(newZoom >= 4.0) {
////                        newLat = mapPinchCenter.latitude
////                        newLng = mapPinchCenter.longitude
////                    }
//                    let geo = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
//                    mapView?.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: newZoom))
//                    print("apinch change B \(dZoom), \(newZoom), \(newLat), \(newLng)")
//                }
//
//            case .ended:
//                print("onMapPinch end \(scale), \(velocity), \(pinchCenter)")
//            default:
//                return
//            }
//        }
//    }
//
//    var initialCenter = CGPoint()
//    var lastTranslation = CGPoint()
//    var a = 0.0
//    var c = 0.0
//    @objc func onMapPan(gesture : UIPanGestureRecognizer) {
//        if let view = gesture.view {
//            let translation = gesture.translation(in: view)
//            let velocity = gesture.velocity(in: view)
//            switch gesture.state {
//            case .began:
//                guard let target = mapView?.camera.target else {
//                    return
//                }
//                guard let targetPoint = mapView?.projection.point(for: target) else {
//                    return
//                }
//                guard let visibleRegion = mapView?.projection.visibleRegion() else {
//                    return
//                }
//                guard let frame = mapView?.frame else {
//                    return
//                }
//                mapTarget0 = target
//                initialCenter = targetPoint
//                lastTranslation = translation
//                print("onMapPan start \(translation), \(mapView?.frame), \(mapView?.projection.visibleRegion())")
//
//                let upperLat = visibleRegion.farRight.latitude
//                let lowerLat = visibleRegion.nearRight.latitude
//                let height = frame.height
//                a = abs(upperLat - lowerLat)/height
//
//                let leftLng = visibleRegion.farLeft.longitude
//                let rightLng = visibleRegion.farRight.longitude
//                let width = frame.width
//                c = abs(rightLng - leftLng)/width
//            case .changed:
//                guard let frame = mapView?.frame else {
//                    return
//                }
//                //method 2: by degree/px interpolation
//                let b = a * translation.y
//                let d = c * translation.x
//
////                let newLat = mapTarget0.latitude + b
//                let newLat = 0.0 //test > like snapmap fixed boundary
//                let height = frame.height
//                let dd = a * height/2
////                let newLat = 80.0 - dd
//                let newLng = mapTarget0.longitude - d
//                let geo = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
//
//                guard let zoom = mapView?.camera.zoom else {
//                    return
//                }
//                mapView?.moveCamera(GMSCameraUpdate.setTarget(geo, zoom: zoom))
//                print("onMapPan change \(b), \(d), \(newLat), \(newLng)")
////                print("onMapPan change \(dd), \(a)")
//
//                //test > gradient slope
//                let lat0 :Float = 0.0
//                let dz: Float = Float((zoom - 2.0)/(4.0 - 2.0))
//                var thresholdLat: Float = dz*(80.0 - lat0) + lat0
//                print("visibleGradient \(thresholdLat), \(zoom), \(dz)")
//
//                //test > check visible region
//                guard let visibleRegion = mapView?.projection.visibleRegion() else {
//                    return
//                }
//                let upperLat = visibleRegion.farRight.latitude
//                let lowerLat = visibleRegion.nearRight.latitude
////                print("onMapPan change \(upperLat), \(lowerLat)")
//            case .ended:
////                print("onMapPan end \(c * translation.x), \(a * translation.y)")
//
//                guard let visibleRegion = mapView?.projection.visibleRegion() else {
//                    return
//                }
//                guard let zoom = mapView?.camera.zoom else {
//                    return
//                }
////                print("onMapPan end \(visibleRegion)")
//
//                let velocityX = velocity.x
//                let translationX = velocityX * 1.0 //assume 0.5s animation
//                let d = c * translationX
//                let newLng = mapTarget0.longitude - d
//                print("onMapPan end \(newLng), \(d), \(velocity.x), \(translationX)")
////                let geo = CLLocationCoordinate2D(latitude: 0.0, longitude: newLng)
////                mapView?.animate(with: GMSCameraUpdate.setTarget(geo, zoom: zoom))
//            default:
//                return
//            }
//        }
//    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPinchGestureRecognizer) {
//            return true
            return false
        } else if (gestureRecognizer is UIPanGestureRecognizer) {
//            return true
            return false
        } else {
            return false
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == miniAppScrollView) {
            print("upv did scroll \(miniAppScrollView.contentOffset.x), \(miniAppScrollGap)")
            let xOffset = scrollView.contentOffset.x
            self.arrowReactToMiniAppScroll(miniAppXOffset: xOffset)
        }
    }
}


