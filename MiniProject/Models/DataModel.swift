//
//  PostData.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import PhotosUI
import Photos
import GoogleMaps

//Data that can be merged by multiple fetch from server, e.g. check if a user has liked a post
class BaseData {
    var id: String = "" //docId
    var dataCode: String = ""
    var dataArray = [String]()
    var dataTextString: String = ""
//    var dataCount : [String: Int] = ["love": 0, "comment": 0, "bookmark": 0, "share": 0]
    var dataCount : [String: Int] = ["love": 0, "comment": 0, "bookmark": 0, "share": 0, "view": 0, "follow": 0, "follower": 0]
    
    //test > t time for video paused timestamp, necessary for resume
    var t_s = 0.0
    //test > p for photo carousel
    var p_s = 0
    
    var contentDataArray = [ContentData]()
    
    var titleTextString: String = ""
}

class BasePostData: BaseData {
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
}

//class PostData: BaseData {
class PostData: BasePostData {
//    var userId: String = "" //creator
//    var placeId: String = ""
//    var soundId: String = ""
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(rData: PostDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        let rDataSoundId = rData.soundId
        let rDataTitleText = rData.titleTextString
        
        //populate data
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        titleTextString = rDataTitleText
        userId = rDataUserId
        placeId = rDataPlaceId
        soundId = rDataSoundId
        
        if let loveC = rDataC["love"] {
            dataCount["love"] = loveC
        }
        if let commentC = rDataC["comment"] {
            dataCount["comment"] = commentC
        }
        if let bookmarkC = rDataC["bookmark"] {
            dataCount["bookmark"] = bookmarkC
        }
        if let shareC = rDataC["share"] {
            dataCount["share"] = shareC
        }
        
        for r in rDataArray {
            dataArray.append(r)
        }
        
        for cl in rContentDataArray {
//            let l = cl.dataCode
            let cData = ContentData()
//            cData.setDataCode(data: l)
            cData.setData(rData: cl)
            contentDataArray.append(cData)
        }
    }
    
    //map from comment dataset
    func setData(rData: CommentDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        let rDataSoundId = rData.soundId
        let rDataTitleText = rData.titleTextString
        
        //populate data
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        titleTextString = rDataTitleText
        userId = rDataUserId
        placeId = rDataPlaceId
        soundId = rDataSoundId
        
        if let loveC = rDataC["love"] {
            dataCount["love"] = loveC
        }
        if let commentC = rDataC["comment"] {
            dataCount["comment"] = commentC
        }
        if let bookmarkC = rDataC["bookmark"] {
            dataCount["bookmark"] = bookmarkC
        }
        if let shareC = rDataC["share"] {
            dataCount["share"] = shareC
        }
        
        for r in rDataArray {
            dataArray.append(r)
        }
        
        for cl in rContentDataArray {
//            let l = cl.dataCode
            let cData = ContentData()
//            cData.setDataCode(data: l)
            cData.setData(rData: cl)
            contentDataArray.append(cData)
        }
    }
}

class PhotoData: BaseData {
    
    var coverPhotoString: String = ""
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setData(rData: PhotoDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        let rDataCover = rData.coverPhotoString
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        let rDataSoundId = rData.soundId
        let rDataTitleText = rData.titleTextString
        
        //populate data
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataCover
        titleTextString = rDataTitleText
        userId = rDataUserId
        placeId = rDataPlaceId
        soundId = rDataSoundId
        
        if let loveC = rDataC["love"] {
            dataCount["love"] = loveC
        }
        if let commentC = rDataC["comment"] {
            dataCount["comment"] = commentC
        }
        if let bookmarkC = rDataC["bookmark"] {
            dataCount["bookmark"] = bookmarkC
        }
        if let shareC = rDataC["share"] {
            dataCount["share"] = shareC
        }
        
        for r in rDataArray {
            dataArray.append(r)
        }
        
        for cl in rContentDataArray {
//            let l = cl.dataCode
            let cData = ContentData()
//            cData.setDataCode(data: l)
            cData.setData(rData: cl)
            contentDataArray.append(cData)
        }
    }
}

//test > video data for loop panel
class VideoData: BaseData {
    //default UI mode
    var uiMode = VideoTypes.V_LOOP
    
    var coverPhotoString: String = ""
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setUIMode(mode: String) {
        uiMode = mode
    }
    
    func setData(rData: VideoDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rDataCover = rData.coverPhotoString
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        let rDataSoundId = rData.soundId
        let rDataTitleText = rData.titleTextString
        
        //populate data
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataCover
        titleTextString = rDataTitleText
        userId = rDataUserId
        placeId = rDataPlaceId
        soundId = rDataSoundId
        
        if let loveC = rDataC["love"] {
            dataCount["love"] = loveC
        }
        if let commentC = rDataC["comment"] {
            dataCount["comment"] = commentC
        }
        if let bookmarkC = rDataC["bookmark"] {
            dataCount["bookmark"] = bookmarkC
        }
        if let shareC = rDataC["share"] {
            dataCount["share"] = shareC
        }
        
        for r in rDataArray {
            dataArray.append(r)
        }
    }
    
    func setDataStatus(data: String) {
        dataCode = data
        dataArray.append(data)
    }
}

class SoundData: BaseData {
    
    var coverPhotoString: String = ""
    var isAccountVerified = false
    //default UI mode
    var uiMode = SoundTypes.S_VOICE
    
    var userId: String = "" //creator
    var placeId: String = ""
    
    func setUIMode(mode: String) {
        uiMode = mode
    }
    
    func setData(rData: SoundDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataP = rData.coverPhotoString
        let rDataVerified = rData.isAccountVerified
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataP
        isAccountVerified = rDataVerified
        userId = rDataUserId
        placeId = rDataPlaceId
        
        if let loveC = rDataC["love"] {
            dataCount["love"] = loveC
        }
        if let commentC = rDataC["comment"] {
            dataCount["comment"] = commentC
        }
        if let bookmarkC = rDataC["bookmark"] {
            dataCount["bookmark"] = bookmarkC
        }
        if let shareC = rDataC["share"] {
            dataCount["share"] = shareC
        }
        for r in rDataArray {
            dataArray.append(r)
        }
    }
    
    func setDataStatus(data: String) {
        dataCode = data
        dataArray.append(data)
    }
}

//class CommentData: BaseData {
class CommentData: BasePostData {
//    var userId: String = "" //creator
//    var placeId: String = ""
//    var soundId: String = ""
    
    func setData(rData: CommentDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        let rDataSoundId = rData.soundId
        let rDataTitleText = rData.titleTextString
        
        //populate data
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        titleTextString = rDataTitleText
        userId = rDataUserId
        placeId = rDataPlaceId
        soundId = rDataSoundId
        
        if let loveC = rDataC["love"] {
            dataCount["love"] = loveC
        }
        if let commentC = rDataC["comment"] {
            dataCount["comment"] = commentC
        }
        if let bookmarkC = rDataC["bookmark"] {
            dataCount["bookmark"] = bookmarkC
        }
        if let shareC = rDataC["share"] {
            dataCount["share"] = shareC
        }
        
        for r in rDataArray {
            dataArray.append(r)
        }
        
        for cl in rContentDataArray {
//            let l = cl.dataCode
            let cData = ContentData()
//            cData.setDataCode(data: l)
            cData.setData(rData: cl)
            contentDataArray.append(cData)
        }
    }
}

class NotifyData: BaseData {
    
    var notifyTextString: String = "" //temp solution
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setData(rData: NotifyDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataNotifyText = rData.notifyTextString
        let rDataUserId = rData.userId
        let rDataPlaceId = rData.placeId
        let rDataSoundId = rData.soundId
        let rDataTitleText = rData.titleTextString
        
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        titleTextString = rDataTitleText
        notifyTextString = rDataNotifyText
        userId = rDataUserId
        placeId = rDataPlaceId
        soundId = rDataSoundId
        
        for r in rDataArray {
            dataArray.append(r)
        }
    }
}

class PlaceData: BaseData {
    
    var coverPhotoString: String = ""
    var isAccountVerified = false
    
    func setData(rData: PlaceDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataP = rData.coverPhotoString
        let rDataVerified = rData.isAccountVerified
        
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataP
        isAccountVerified = rDataVerified
        
        if let loveC = rDataC["bookmark"] {
            dataCount["bookmark"] = loveC
        }
        for r in rDataArray {
            dataArray.append(r)
        }
    }
}

class UserData: BaseData {
    
    var bioTextString: String = ""
    var coverPhotoString: String = ""
    var isAccountVerified = false
    
    func setData(rData: UserDataset) {
        let rDataId = rData.id
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataBio = rData.bioTextString
        let rDataC = rData.dataCount
        let rDataP = rData.coverPhotoString
        let rDataVerified = rData.isAccountVerified
        
        id = rDataId
        dataCode = rDataType
        dataTextString = rDataText
        bioTextString = rDataBio
        coverPhotoString = rDataP
        isAccountVerified = rDataVerified
        
        if let loveC = rDataC["follow"] {
            dataCount["follow"] = loveC
        }
        if let commentC = rDataC["follower"] {
            dataCount["follower"] = commentC
        }
        
        for r in rDataArray {
            dataArray.append(r)
        }
    }
}

//*test => content data for storing various content cells in posts/videos
class ContentData: BaseData {
    
    var contentDataType = ""
    var contentDataCode = "" //test
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setContentDataCode(data: String) {
        contentDataCode = data
    }
    
    func setData(rData: ContentDataset) {
        let rDataId = rData.id
        let rDataCode = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rContentDataType = rData.contentDataType
        let rContentDataCode = rData.contentDataCode
        
        id = rDataId
        dataTextString = rDataText
        dataCode = rDataCode
        contentDataType = rContentDataType
        contentDataCode = rContentDataCode
        for r in rDataArray {
            dataArray.append(r)
        }
    }
    
    //test > for setting parameter individually -> especially for postclipcell in Post Creator
    func setContentDataType(dataType: String) {
        contentDataType = dataType
    }
    func setId(dataId: String) {
        id = dataId
    }
    func setDataArray(da: [String]) {
        for r in da {
            dataArray.append(r)
        }
    }
    func setDataTextString(dataText: String) {
        dataTextString = dataText
    }
}
//*

class GridAssetData {
    var model: PHAsset?
    var isSelected = false
    var selectedOrder = -1
    
    func setModel(data: PHAsset) {
        model = data
    }
    
    func setSelected(isS: Bool) {
        isSelected = isS
    }
    
    func setSelectedOrder(i: Int) {
        selectedOrder = i
    }
}

class GeoData {
    var geoCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var geoType = ""
    
    func setGeoCoord(coord: CLLocationCoordinate2D) {
        geoCoord = coord
    }
    
    func getGeoCoord() -> CLLocationCoordinate2D{
        return geoCoord
    }
    
    func setGeoType(type: String) {
        geoType = type
    }
    
    func getGeoType() -> String{
        return geoType
    }
}
