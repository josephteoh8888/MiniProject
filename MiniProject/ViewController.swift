//
//  ViewController.swift
//  MiniProject
//
//  Created by Joseph Teoh on 27/06/2024.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GMSServices.provideAPIKey("AIzaSyBOD7PnDnBW5PlensQ_pwa2bEjh8iNZ0oQ") //replace with real API key
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        options.frame = self.view.bounds

        let mapView = GMSMapView(options: options)
        mapView.mapType = .hybrid
        self.view.addSubview(mapView)

    }


}

