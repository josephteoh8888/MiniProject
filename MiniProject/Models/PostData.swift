//
//  PostData.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation

class BaseData {
    var dataType: String = ""
    var dataArray = [String]()
    var dataTextString: String = ""
//    var dataCount = [String: Int]()
    var dataCount : [String: Int] = ["love": 0, "comment": 0, "bookmark": 0, "share": 0]
    
    var chainDataArray = [String]() //for comment chaining
    
    //test > to indicate hide/unhide in grid3x panels
    var isGridHidden = false
    func setGridHidden(toHide: Bool) {
        isGridHidden = toHide
    }
}

class PostData: BaseData {
//    var dataType: String = ""
//    var dataArray = [String]()
//    var dataTextString: String = ""
    
    //test > t time for video paused timestamp, necessary for resume
    var t_s = 0.0
    //test > p for photo carousel
    var p_s = 0
    
    func setDataType(data: String) {
        dataType = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("t") //text
//            dataArray.append("p") //photo
//            dataArray.append("t") //text
            dataArray.append("q") //text
//            dataArray.append("q") //photo
//            dataArray.append("q") //quote
            
//            dataArray.append("c") //comment
//            dataArray.append("c") //comment
            
//            dataArray.append("c") //comment
        }
        else if(data == "b") {
            dataArray.append("t") //text
//            dataArray.append("p") //photo
            dataArray.append("p_s") //video
            dataArray.append("t") //text
        }
        else if(data == "c") {
//            dataArray.append("t")
            dataArray.append("p") //photo
            dataArray.append("q") //quote
            
//            dataArray.append("c") //comment
        }
        else if(data == "d") {
            dataArray.append("t") //text
//            dataArray.append("v") //video
            dataArray.append("v_l") //loop
            dataArray.append("t") //text
        }
        
        //test > populate chaining comments
        setChainData(data: data)
        
        //test > populate data counts too
        setDataCount(data: data)
    }
    
    func setChainData(data: String){
        if(data == "a") {
            chainDataArray.append("c") //comment
            chainDataArray.append("c") //comment
            chainDataArray.append("c") //comment
//            chainDataArray.append("c") //comment
        }
        else if(data == "b") {
            
        }
        else if(data == "c") {
            chainDataArray.append("c") //comment
        }
    }
    
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "Nice food, nice environment! Worth a visit. \n\nSo Good.\n.\n..\n...\n....\n...\n..\n.\n.\n."
//            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "c") {
            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
        }
        else if(data == "d") {
            dataTextString = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
        }
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["love"] = 18312
            dataCount["comment"] = 1309
            dataCount["bookmark"] = 512
            dataCount["share"] = 478
        }
        else if(data == "b") {
            dataCount["love"] = 3796
            dataCount["comment"] = 209
            dataCount["bookmark"] = 45
            dataCount["share"] = 98
        }
        else if(data == "c") {
            dataCount["love"] = 675
            dataCount["comment"] = 2708
            dataCount["bookmark"] = 102
            dataCount["share"] = 719
        }
        else if(data == "d") {
            dataCount["love"] = 74
            dataCount["comment"] = 921
            dataCount["bookmark"] = 43
            dataCount["share"] = 32
        }
    }
}

class PhotoData: BaseData {
//    var dataType: String = ""
//    var dataArray = [String]()
//    var dataTextString: String = ""
    
    //test > p for which photo was user scrolled
    var p_s = 0
    
    func setDataType(data: String) {
        dataType = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("m") //text
//            dataArray.append("t") //text
//            dataArray.append("c") //comment
//            dataArray.append("c") //comment
        }
        else if(data == "b") {
            dataArray.append("p") //photo
//            dataArray.append("t") //text
        }
        else if(data == "c") {
            dataArray.append("m") //photo
//            dataArray.append("t") //text
//            dataArray.append("c") //comment
        }
        
        //test > populate data counts too
        setDataCount(data: data)
    }
    
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "Nice food, nice environment! Worth a visit."
//            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "c") {
            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
        }
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["love"] = 18312
            dataCount["comment"] = 1309
            dataCount["bookmark"] = 512
            dataCount["share"] = 478
        }
        else if(data == "b") {
            dataCount["love"] = 3796
            dataCount["comment"] = 209
            dataCount["bookmark"] = 45
            dataCount["share"] = 98
        }
        else if(data == "c") {
            dataCount["love"] = 675
            dataCount["comment"] = 2708
            dataCount["bookmark"] = 102
            dataCount["share"] = 719
        }
        else if(data == "d") {
            dataCount["love"] = 74
            dataCount["comment"] = 921
            dataCount["bookmark"] = 43
            dataCount["share"] = 32
        }
    }
}

//test > video data for loop panel
class VideoData: BaseData {
    
    var uiMode = VideoTypes.V_LOOP
    
    func setDataType(data: String) {
        dataType = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("a") //text
//            dataArray.append("t") //text
//            dataArray.append("c") //comment
//            dataArray.append("c") //comment
        }
        else if(data == "b") {
            dataArray.append("b") //photo
//            dataArray.append("t") //text
        }
        else if(data == "c") {
            dataArray.append("c") //photo
//            dataArray.append("t") //text
//            dataArray.append("c") //comment
        }
        else if(data == "d") {
            dataArray.append("d") //photo
        }
        else if(data == "e") {
            dataArray.append("e") //photo
        }
        
        //test > populate data counts too
        setDataCount(data: data)
    }
    
    func setTextString(data: String) {
        if(data == "a") {
//            dataTextString = "Nice food, nice environment! Worth a visit."
//            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
//            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "c") {
            dataTextString = "End"
        }
        else if(data == "d") {
            dataTextString = "No results"
        }
        else if(data == "e") {
            dataTextString = "Something went wrong. Try again."
        }
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["love"] = 18312
            dataCount["comment"] = 1309
            dataCount["bookmark"] = 512
            dataCount["share"] = 478
        }
        else if(data == "b") {
            dataCount["love"] = 3796
            dataCount["comment"] = 209
            dataCount["bookmark"] = 45
            dataCount["share"] = 98
        }
        else if(data == "c") {
            dataCount["love"] = 675
            dataCount["comment"] = 2708
            dataCount["bookmark"] = 102
            dataCount["share"] = 719
        }
        else if(data == "d") {
            dataCount["love"] = 74
            dataCount["comment"] = 921
            dataCount["bookmark"] = 43
            dataCount["share"] = 32
        }
    }
    
    func setUIMode(mode: String) {
        uiMode = mode
    }
}

class CommentData: BaseData {
    
    func setDataType(data: String) {
        dataType = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("t") //text
//            dataArray.append("p") //photo
//            dataArray.append("t") //text
//            dataArray.append("q") //text
//            dataArray.append("q") //photo
//            dataArray.append("q") //quote
            
//            dataArray.append("c") //comment
//            dataArray.append("c") //comment
            
//            dataArray.append("c") //comment
        }
        else if(data == "b") {
//            dataArray.append("p") //photo
            dataArray.append("t") //photo
        }
        else if(data == "c") {
            dataArray.append("t")
//            dataArray.append("p") //photo
//            dataArray.append("q") //quote
            
//            dataArray.append("c") //comment
        }
        
        //test > populate chaining comments
        setChainData(data: data)
        
        //test > populate data counts too
        setDataCount(data: data)
    }
    
    func setChainData(data: String){
        if(data == "a") {
            chainDataArray.append("c") //comment
            chainDataArray.append("c") //comment
            chainDataArray.append("c") //comment
            chainDataArray.append("c") //comment
        }
        else if(data == "b") {
            
        }
        else if(data == "c") {
            chainDataArray.append("c") //comment
        }
    }
    
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
//            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "c") {
            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
        }
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["love"] = 18312
            dataCount["comment"] = 1309
            dataCount["bookmark"] = 512
            dataCount["share"] = 478
        }
        else if(data == "b") {
            dataCount["love"] = 3796
            dataCount["comment"] = 209
            dataCount["bookmark"] = 45
            dataCount["share"] = 98
        }
        else if(data == "c") {
            dataCount["love"] = 675
            dataCount["comment"] = 2708
            dataCount["bookmark"] = 102
            dataCount["share"] = 719
        }
        else if(data == "d") {
            dataCount["love"] = 74
            dataCount["comment"] = 921
            dataCount["bookmark"] = 43
            dataCount["share"] = 32
        }
    }
}

class Page {
    
}

class SubTabDataModel {
    var identifier: String = ""
    var type: String = ""
    var currentSection: String = ""
    var variant: String = ""
//    var subTabDataMap = [String : [Post]]()
    var subTabCurrentIndexMap = [String : Int]()
//    var subTabDataFetchStatusMap = [String : FetchPostStatusModel]()

    var currentCommentSection: String = ""
//    var subTabCommentDataMap = [String : [Comment]]()
    var subTabCurrentCommentReplyIdMap = [String : String]()
    var subTabCommentCurrentIndexMap = [String : Int]()
//    var subTabCommentDataFetchStatusMap = [String : FetchCommentStatusModel]()
    
    var isStoryOpened = false, isViewGridOpened = false, isCommentOpened = false, isReplyOpened = false
    var isSoundPlaying = false
    
    //test for types of subtabdata
//    var profileUserModel: User = User()
//    var placeItemModel: PlaceItem = PlaceItem()
//    var soundItemModel: MusicItem = MusicItem()
//    var trendItemModel: TrendItem = TrendItem()
//    var campaignItemModel: CampaignItem = CampaignItem()

    
    init() {

    }
    
//    func setProfileUserModel(profileUserModel: User) {
//        self.profileUserModel = profileUserModel
//    }
//    func setPlaceItemModel(placeItemModel: PlaceItem) {
//        self.placeItemModel = placeItemModel
//    }
//    func setSoundItemModel(soundItemModel: MusicItem) {
//        self.soundItemModel = soundItemModel
//    }
//    func setTrendItemModel(trendItemModel: TrendItem) {
//        self.trendItemModel = trendItemModel
//    }
//    func setCampaignItemModel(campaignItemModel: CampaignItem) {
//        self.campaignItemModel = campaignItemModel
//    }
    
}
