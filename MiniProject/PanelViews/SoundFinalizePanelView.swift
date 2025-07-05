//
//  MePostListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 20/07/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol SoundFinalizePanelDelegate : AnyObject {
    func didInitializeSoundFinalize()
    func didClickFinishSoundFinalize()
    func didSoundFinalizeClickUpload(payload: String)
    //test
    func didSoundFinalizeClickLocationSelectScrollable()
}
class SoundFinalizePanelView: PanelView{
    
}
