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
}

class PostData: BaseData {
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(rData: PostDataset) {
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        
        //populate data
        dataCode = rDataType
        dataTextString = rDataText
        
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
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        
        //populate data
        dataCode = rDataType
        dataTextString = rDataText
        
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
    
    func setData(rData: PhotoDataset) {
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        let rDataCover = rData.coverPhotoString
        
        //populate data
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataCover
        
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
    
    func setUIMode(mode: String) {
        uiMode = mode
    }
    
    func setData(rData: VideoDataset) {
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rDataCover = rData.coverPhotoString
        
        //populate data
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataCover
        
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

class CommentData: BaseData {
    
    func setData(rData: CommentDataset) {
        let rDataType = rData.dataCode
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataArray = rData.dataArray
        let rContentDataArray = rData.contentDataArray
        
        //populate data
        dataCode = rDataType
        dataTextString = rDataText
        
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
    
    func setData(rData: NotifyDataset) {
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataNotifyText = rData.notifyTextString
        
        dataCode = rDataType
        dataTextString = rDataText
        notifyTextString = rDataNotifyText
        
        for r in rDataArray {
            dataArray.append(r)
        }
    }
}

class PlaceData: BaseData {
    
    var coverPhotoString: String = ""
    
    func setData(rData: PlaceDataset) {
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataP = rData.coverPhotoString
        
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataP
        
        if let loveC = rDataC["bookmark"] {
            dataCount["bookmark"] = loveC
        }
        for r in rDataArray {
            dataArray.append(r)
        }
    }
}

class SoundData: BaseData {
    
    var coverPhotoString: String = ""
    
    func setData(rData: SoundDataset) {
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataC = rData.dataCount
        let rDataP = rData.coverPhotoString
        
        dataCode = rDataType
        dataTextString = rDataText
        coverPhotoString = rDataP
        
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
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        let rDataText = rData.dataTextString
        let rDataBio = rData.bioTextString
        let rDataC = rData.dataCount
        let rDataP = rData.coverPhotoString
        let rDataVerified = rData.isAccountVerified
        
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
//class ContentData {
class ContentData: BaseData {
//    var dataCode: String = ""
//    var dataArray = [String]()
//    var dataTextString: String = ""
//    
//    //test > t time for video paused timestamp, necessary for resume
//    var t_s = 0.0
//    //test > p for photo carousel
//    var p_s = 0
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(rData: ContentDataset) {
        let rDataType = rData.dataCode
        let rDataArray = rData.dataArray
        dataCode = rDataType
        for r in rDataArray {
            dataArray.append(r)
        }
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

//class Page {
//    
//}
//
//class SubTabDataModel {
//    var identifier: String = ""
//    var type: String = ""
//    var currentSection: String = ""
//    var variant: String = ""
////    var subTabDataMap = [String : [Post]]()
//    var subTabCurrentIndexMap = [String : Int]()
////    var subTabDataFetchStatusMap = [String : FetchPostStatusModel]()
//
//    var currentCommentSection: String = ""
////    var subTabCommentDataMap = [String : [Comment]]()
//    var subTabCurrentCommentReplyIdMap = [String : String]()
//    var subTabCommentCurrentIndexMap = [String : Int]()
////    var subTabCommentDataFetchStatusMap = [String : FetchCommentStatusModel]()
//    
//    var isStoryOpened = false, isViewGridOpened = false, isCommentOpened = false, isReplyOpened = false
//    var isSoundPlaying = false
//    
//    //test for types of subtabdata
////    var profileUserModel: User = User()
////    var placeItemModel: PlaceItem = PlaceItem()
////    var soundItemModel: MusicItem = MusicItem()
////    var trendItemModel: TrendItem = TrendItem()
////    var campaignItemModel: CampaignItem = CampaignItem()
//
//    
//    init() {
//
//    }
//    
//}
