//
//  VideoClip.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import AVFoundation

class VideoClip {

    let tBox = UIView()
    var tBoxWidthCons: NSLayoutConstraint?
    var tBoxLeadingCons: NSLayoutConstraint?
    let tcFrame = UIView()
    var pFrameLeadingCons: NSLayoutConstraint?
    var pFrameTrailingCons: NSLayoutConstraint?
    let pFrame = UIView()
    let pBase = UIView()
    var fImages = [CGImage]()
    let sAView = UIView()
    let sBView = UIView()
    var d = 0.0 //video duration
    var t_s = 0.0
    var t_e = 0.0
    var t0_s = 0.0
    var t0_e = 0.0
    var pFrameWidth = 0.0 //playable vidoe frame width to update scrollview content width for scrolling
    var p0FrameWidth = 0.0 //original playable video frame width
    var isVcSelected = false
    var currentPFrameLeadingCons = 0.0
    var currentPFrameTrailingCons = 0.0
    var currentTboxLeadingCons = 0.0
    var playerItem : AVPlayerItem?
    var strVUrl = ""
    
    func selectVideoClip() {
        pBase.isHidden = false
        sAView.isHidden = false
        sBView.isHidden = false
        
        isVcSelected = true
    }
    
    func unselectVideoClip() {
        pBase.isHidden = true
        sAView.isHidden = true
        sBView.isHidden = true
        
        isVcSelected = false
    }
}
