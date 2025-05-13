//
//  APICaller.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    //single source of truth
    public var postDatasetList = [String : PostDataset]()
    public var photoDatasetList = [String : PhotoDataset]()
    public var videoDatasetList = [String : VideoDataset]()
    public var userDatasetList = [String : UserDataset]()
    public var placeDatasetList = [String : PlaceDataset]()
    public var soundDatasetList = [String : SoundDataset]()
    public var commentDatasetList = [String : CommentDataset]()
    public var notifyDatasetList = [String : NotifyDataset]()
//    public var postDataList = [String : PostData]()
    public var isDataInitialized = false
    
    func initData() {
        if(!isDataInitialized) {
            
            setupPostData()
            setupPhotoData()
            setupVideoData()
            setupCommentData()
            setupUserData()
            setupPlaceData()
            setupSoundData()
            setupNotifyData()
            
            isDataInitialized = true
        }
    }
    
    func setupPostData() {
        let newIdString = ["post1", "post2", "post3", "post4"]
        for r in newIdString {
            let vData = PostDataset()
            vData.setId(dataId: r)
            if(r == "post1") {
                vData.setDataCode(data: "a") //a
                vData.setData(data: "b")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "b") //b
            }
            else if(r == "post2") {
                vData.setDataCode(data: "na") //na
                vData.setData(data: "a")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "c")
            }
            else if(r == "post3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "c")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "post4") {
                vData.setDataCode(data: "a") //a
                vData.setData(data: "d")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "a")
            }
            
            if !postDatasetList.keys.contains(r) {
                postDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    //test > simulate entering comment
    func addPostData(text: String) -> PostDataset {
        let a = postDatasetList.count
        
        let newId = "post" + String(a + 1)
        let vData = PostDataset()
        vData.setId(dataId: newId)
        vData.setDataCode(data: "a")
        vData.setDataArray(data: text)
        vData.setTextString(text: text)
        
        if !postDatasetList.keys.contains(newId) {
            postDatasetList.updateValue(vData, forKey: newId)
        }
        
        print("adddata: \(postDatasetList)")
        
        return vData
    }
    
    func setupPhotoData() {
        let newIdString = ["photo1", "photo2", "photo3", "photo4"]
        for r in newIdString {
            let vData = PhotoDataset()
            vData.setId(dataId: r)
            if(r == "photo1") {
                vData.setDataCode(data: "a")
                vData.setData(data: "a")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "c")
            }
            else if(r == "photo2") {
                vData.setDataCode(data: "na") //na
                vData.setData(data: "c")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "a")
            }
            else if(r == "photo3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "photo4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "d")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "b")
            }
            
            if !photoDatasetList.keys.contains(r) {
                photoDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func setupVideoData() {
        let newIdString = ["video1", "video2", "video3", "video4"]
        for r in newIdString {
            let vData = VideoDataset()
            vData.setId(dataId: r)
            if(r == "video1") {
                vData.setDataCode(data: "a")
                vData.setData(data: "a")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "a")
            }
            else if(r == "video2") {
                vData.setDataCode(data: "na") //na
                vData.setData(data: "d")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "c")
            }
            else if(r == "video3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "video4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "c")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "b")
            }
            
            if !videoDatasetList.keys.contains(r) {
                videoDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func setupCommentData() {
        let newIdString = ["comment1", "comment2", "comment3", "comment4"]
        for r in newIdString {
            let vData = CommentDataset()
            vData.setId(dataId: r)
            if(r == "comment1") {
                vData.setDataCode(data: "a") //a
                vData.setData(data: "a")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "c")
            }
            else if(r == "comment2") {
                vData.setDataCode(data: "a") //na
                vData.setData(data: "d")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "a")
            }
            else if(r == "comment3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "comment4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "c")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "b")
            }
            
            if !commentDatasetList.keys.contains(r) {
                commentDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func setupUserData() {
        let newIdString = ["u1", "u2", "u3", "u4"]
        for r in newIdString {
            let vData = UserDataset()
            vData.setId(dataId: r)
            if(r == "u1") {
                vData.setDataCode(data: "a")
                vData.setData(data: "a")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "c")
            }
            else if(r == "u2") {
                vData.setDataCode(data: "a") //na
                vData.setData(data: "d")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "a")
            }
            else if(r == "u3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "u4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "c")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "b")
            }
            
            if !userDatasetList.keys.contains(r) {
                userDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func setupPlaceData() {
        let newIdString = ["p1", "p2", "p3", "p4"]
        for r in newIdString {
            let vData = PlaceDataset()
            vData.setId(dataId: r)
            if(r == "p1") {
                vData.setDataCode(data: "a")
                vData.setData(data: "a")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "c")
            }
            else if(r == "p2") {
                vData.setDataCode(data: "na") //na
                vData.setData(data: "d")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "a")
            }
            else if(r == "p3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "d")
            }
            else if(r == "p4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "c")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "b")
            }
            
            if !placeDatasetList.keys.contains(r) {
                placeDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func setupSoundData() {
        let newIdString = ["s1", "s2", "s3", "s4"]
        for r in newIdString {
            let vData = SoundDataset()
            vData.setId(dataId: r)
            if(r == "s1") {
                vData.setDataCode(data: "a")
                vData.setData(data: "a")
                vData.setDataCount(data: "b")
                vData.setTextString(data: "c")
            }
            else if(r == "s2") {
                vData.setDataCode(data: "na") //na
                vData.setData(data: "d")
                vData.setDataCount(data: "c")
                vData.setTextString(data: "a")
            }
            else if(r == "s3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "s4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "c")
                vData.setDataCount(data: "a")
                vData.setTextString(data: "b")
            }
            
            if !soundDatasetList.keys.contains(r) {
                soundDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func setupNotifyData() {
        let newIdString = ["notify1", "notify2", "notify3", "notify4"]
        for r in newIdString {
            let vData = NotifyDataset()
            vData.setId(dataId: r)
            if(r == "notify1") {
                vData.setDataCode(data: "a")
                vData.setData(data: "a")
//                vData.setDataCount(data: "b")
                vData.setTextString(data: "c")
            }
            else if(r == "notify2") {
                vData.setDataCode(data: "na") //na
                vData.setData(data: "d")
//                vData.setDataCount(data: "c")
                vData.setTextString(data: "a")
            }
            else if(r == "notify3") {
                vData.setDataCode(data: "us") //us
                vData.setData(data: "b")
//                vData.setDataCount(data: "d")
                vData.setTextString(data: "d")
            }
            else if(r == "notify4") {
                vData.setDataCode(data: "a")
                vData.setData(data: "c")
//                vData.setDataCount(data: "a")
                vData.setTextString(data: "b")
            }
            
            if !notifyDatasetList.keys.contains(r) {
                notifyDatasetList.updateValue(vData, forKey: r)
            }
        }
    }
    
    func getPostData(id: String) -> PostDataset? {
        if let existingValues = postDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getPhotoData(id: String) -> PhotoDataset? {
        if let existingValues = photoDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getVideoData(id: String) -> VideoDataset? {
        if let existingValues = videoDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getCommentData(id: String) -> CommentDataset? {
        if let existingValues = commentDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getUserData(id: String) -> UserDataset? {
        if let existingValues = userDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getPlaceData(id: String) -> PlaceDataset? {
        if let existingValues = placeDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getSoundData(id: String) -> SoundDataset? {
        if let existingValues = soundDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
    
    func getNotifyData(id: String) -> NotifyDataset? {
        if let existingValues = notifyDatasetList[id] {
            return existingValues
        } else {
            return nil
        }
    }
}
