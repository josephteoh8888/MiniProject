//
//  MeLikeListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 20/07/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation
import PhotosUI
import Photos

protocol SoundCreatorPanelDelegate : AnyObject {
    func didInitializeSoundCreator()
    func didClickFinishSoundCreator()
    
    //test
    func didSoundCreatorClickLocationSelectScrollable()
    
    func didSoundCreatorClickSignIn()
    func didSoundCreatorClickUpload(payload: String)
}

//test
class SoundCreatorConsolePanelView: CreatorPanelView{
    
}
