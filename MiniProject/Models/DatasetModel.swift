//
//  GeoData.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import GoogleMaps

//simulate data
class BaseDataset {
    var id: String = "" //docId
    var dataCode: String = ""
    var dataArray = [String]()
    var dataTextString: String = ""
//    var dataCount : [String: Int] = ["love": 0, "comment": 0, "bookmark": 0, "share": 0]
    var dataCount : [String: Int] = ["love": 0, "comment": 0, "bookmark": 0, "share": 0, "view": 0, "follow": 0, "follower": 0]
    
    var contentDataArray = [ContentDataset]()
    
    var titleTextString: String = ""
}

class ContentDataset : BaseDataset {
    var contentDataType = ""
    var contentDataCode = "" //test
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setContentDataType(dataType: String) {
        contentDataType = dataType
    }
}

class VideoDataset: BaseDataset {
    
    var coverPhotoString: String = ""
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setupData(data: String) {
        dataCode = data
        dataArray.append(data)
        setDataCount(data: data)
        setTextString(data: data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("a") //text
        }
        else if(data == "b") {
            dataArray.append("b") //photo
        }
        else if(data == "c") {
            dataArray.append("c") //photo
        }
        else if(data == "d") {
            dataArray.append("d") //photo
        }
        else if(data == "e") {
            dataArray.append("e") //photo
        }
        
        //test > populate data counts too
//        setDataCount(data: data)
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
    
    func setTextString(data: String) {
        if(data == "a") {
//            dataTextString = "Nice food, nice environment! Worth a visit."
//            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
            dataTextString = "What a wonderful day in Tokyo"
//            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        //test > varied text strings
        else if(data == "c") {
            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
        }
        else if(data == "d") {
//            dataTextString = ""
            dataTextString = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
        }
        
        //cover photo
        if(data == "a") {
            coverPhotoString = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
        }
        else if(data == "b") {
            coverPhotoString = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
        }
        else if(data == "c") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media"
        }
        else if(data == "d") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media"
        }
        
        //creator id, sound and place id
        if(data == "a") {
            userId = "u2"
            placeId = "p3"
            soundId = "s4"
        }
        else if(data == "b") {
            userId = "u1"
            placeId = "p4"
            soundId = "s1"
        }
        else if(data == "c") {
            userId = "u4"
            placeId = "p1"
            soundId = "s2"
        }
        else if(data == "d") {
            userId = "u3"
            placeId = "p2"
            soundId = "s3"
        }
    }
}

class PhotoDataset: BaseDataset {
    
    var coverPhotoString: String = ""
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setupData(data: String) {
        dataCode = data
        setData(data: data)
        setDataCount(data: data)
        setTextString(data: data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("p") //photo
//            dataArray.append("m") //text
            dataArray.append("t") //photo
        }
        else if(data == "b") {
            dataArray.append("p") //photo
        }
        else if(data == "c") {
            dataArray.append("p") //photo
//            dataArray.append("m") //photo
            dataArray.append("t") //photo
        }
        else if(data == "d") {
            dataArray.append("p") //photo
            dataArray.append("t") //photo
        }
        
        //set content data
        for i in dataArray {
            let cData = PhotoContentDataset()
            cData.setDataCode(data: i)
            cData.setData(data: data) //test
            contentDataArray.append(cData)
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
    
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "Nice food, nice environment! Worth a visit."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "c") {
            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
        }
        else if(data == "d") {
//            dataTextString = ""
            dataTextString = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
        }
        
        //cover photo
        if(data == "a") {
            coverPhotoString = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
        }
        else if(data == "b") {
            coverPhotoString = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
        }
        else if(data == "c") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media"
        }
        else if(data == "d") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media"
        }
        
        if(data == "a") {
            titleTextString = ""
        }
        else if(data == "b") {
            titleTextString = "What's going on HERE?!"
        }
        else if(data == "c") {
            titleTextString = ""
        }
        else if(data == "d") {
            titleTextString = "What's happening?"
        }
        
        //creator id, sound and place id
        if(data == "a") {
            userId = "u1"
            placeId = "p2"
            soundId = "s3"
        }
        else if(data == "b") {
            userId = "u2"
            placeId = "p3"
            soundId = "s4"
        }
        else if(data == "c") {
            userId = "u3"
            placeId = "p4"
            soundId = "s1"
        }
        else if(data == "d") {
            userId = "u4"
            placeId = "p1"
            soundId = "s2"
        }
    }
}

class PostDataset: BaseDataset {
    
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setupData(data: String) {
        dataCode = data
        setData(data: data)
        setDataCount(data: data)
        setTextString(data: data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("text") //text
            dataArray.append("photo") //photo
            dataArray.append("photo_s") //video
//            dataArray.append("t") //text
//            dataArray.append("q") //text
//            dataArray.append("q") //photo
            dataArray.append("quote") //quote
            dataArray.append("video") //loop
//            dataArray.append("v") //video
            dataArray.append("video_l") //loop
        }
        else if(data == "b") {
            dataArray.append("text") //text
//            dataArray.append("p") //photo
            dataArray.append("photo_s") //video
            dataArray.append("text") //text
            
//            //test > error handling
//            dataArray.append("us")
            
            dataArray.append("quote") //quote
        }
        else if(data == "c") {
//            dataArray.append("t")
            dataArray.append("photo") //photo
            dataArray.append("quote") //quote
            
            dataArray.append("video") //loop
            dataArray.append("video") //video
        }
        else if(data == "d") {
            dataArray.append("text") //text
            dataArray.append("video") //video
            dataArray.append("video_l") //loop
            dataArray.append("text") //text
            
            dataArray.append("photo")
            dataArray.append("photo_s")
//            dataArray.append("photo")
            dataArray.append("quote") //quote
            
//            //test > error handling
//            dataArray.append("us")
        }
        
        //set content data
        for i in dataArray {
//            let cData = ContentDataset()
//            cData.setDataCode(data: i)
//            contentDataArray.append(cData)
            
            //test 2 > try various types of content cells
            if(i == "photo") {
                let cData = PhotoContentDataset()
                cData.setDataCode(data: i)
                cData.setData(data: data) //test
                contentDataArray.append(cData)
            } else if(i == "quote"){
                let cData = QuoteContentDataset()
                cData.setDataCode(data: i)
                cData.setContentDataType(dataType: "comment")
                cData.setData(data: data) //test
                contentDataArray.append(cData)
            } else if(i == "text"){
                let cData = TextContentDataset()
                cData.setDataCode(data: i)
                cData.setTextString(data: data) //test
                contentDataArray.append(cData)
            } else {
                let cData = ContentDataset()
                cData.setDataCode(data: i)
                contentDataArray.append(cData)
            }
        }
    }
    
    //test > simulate post new comment
    func setDataArray(data: String) {
        dataArray.append("text") //post new comment text
        
        //set content data
        for i in dataArray {
            let cData = ContentDataset()
            cData.setDataCode(data: i)
            contentDataArray.append(cData)
        }
    }
    
    func setTextString(data: String) {
        
        //creator id, sound and place id
        if(data == "a") {
            userId = "u2"
            placeId = "p3"
            soundId = "s4"
        }
        else if(data == "b") {
            userId = "u1"
            placeId = "p2"
            soundId = "s3"
        }
        else if(data == "c") {
            userId = "u4"
            placeId = "p1"
            soundId = "s2"
        }
        else if(data == "d") {
            userId = "u3"
            placeId = "p4"
            soundId = "s1"
        }
    }
    
    //test > simulate entering comment
    func setTextString(text: String) {
        dataTextString = text
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

class CommentDataset: BaseDataset {
    
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setupData(data: String) {
        dataCode = data
        setData(data: data)
        setDataCount(data: data)
        setTextString(data: data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("text") //text
//            dataArray.append("p") //photo
//            dataArray.append("t") //text
            dataArray.append("quote") 
//            dataArray.append("q") //photo
//            dataArray.append("q") //quote
            dataArray.append("video_l")
        }
        else if(data == "b") {
////            dataArray.append("p") //photo
//            dataArray.append("v") //video
            dataArray.append("photo_s") //photo
//            dataArray.append("v_l") //video
            
            //test > error handling
//            dataArray.append("us")
        }
        else if(data == "c") {
            dataArray.append("text")
            dataArray.append("photo") //photo
//            dataArray.append("q") //quote
            dataArray.append("text")
//            dataArray.append("c") //comment
            dataArray.append("video")
//            dataArray.append("p") //photo
//            dataArray.append("p") //photo
        }
        else if(data == "d") {
            dataArray.append("text")
        }
        
        //set content data
        for i in dataArray {
//            let cData = ContentDataset()
//            cData.setDataCode(data: i)
//            contentDataArray.append(cData)
            
            //test 2 > try various types of content cells
            if(i == "photo") {
                let cData = PhotoContentDataset()
                cData.setDataCode(data: i)
                cData.setData(data: data) //test
                contentDataArray.append(cData)
            } else if(i == "quote"){
                let cData = QuoteContentDataset()
                cData.setDataCode(data: i)
                cData.setContentDataType(dataType: "post")
                cData.setData(data: data) //test
                contentDataArray.append(cData)
            } else if(i == "text"){
                let cData = TextContentDataset()
                cData.setDataCode(data: i)
//                cData.setTextString(data: data) //ori
                cData.setTextStringB(data: data) //test
                contentDataArray.append(cData)
            } else {
                let cData = ContentDataset()
                cData.setDataCode(data: i)
                contentDataArray.append(cData)
            }
        }
    }
    
    func setTextString(data: String) {
//        if(data == "a") {
//            dataTextString = "Nice food, nice environment! Worth a visit. \n\nSo Good.\n.\n..\n...\n....\n...\n..\n.\n.\n."
////            dataTextString = "Nice food, nice environment! Worth a visit. \nSo Good."
//        }
//        else if(data == "b") {
//            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
//        }
//        else if(data == "c") {
//            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
//        }
//        //test
//        else if(data == "d") {
//            dataTextString = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
//        }
        
        //creator id, sound and place id
        if(data == "a") {
            userId = "u2"
            placeId = "p3"
            soundId = "s4"
        }
        else if(data == "b") {
            userId = "u1"
            placeId = "p2"
            soundId = "s3"
        }
        else if(data == "c") {
            userId = "u4"
            placeId = "p1"
            soundId = "s2"
        }
        else if(data == "d") {
            userId = "u3"
            placeId = "p4"
            soundId = "s1"
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

//for general feed fetch => to be replaced in future
//class FeedDataset: BaseDataset {
//    
//    var feedBaseData: BaseDataset?
//    var dataTypeCode: String = ""
//    func setupData(data: String, dataTCode: String, base: BaseDataset) {
//        dataCode = data
////        dataArray.append(data)
//        feedBaseData = base
//        dataTypeCode = dataTCode
//    }
//}

class NotifyDataset: BaseDataset {
    
    var notifyTextString: String = "" //temp solution
    var userId: String = "" //creator
    var placeId: String = ""
    var soundId: String = ""
    
    func setupData(data: String) {
        dataCode = data
        dataArray.append(data)
    }
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setData(data: String) {
        dataArray.append(data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "Happy Birthday!!"
        }
        else if(data == "b") {
            dataTextString = "okok...thanks for the info"
        }
        else if(data == "c") {
            dataTextString = "Can i call u?"
        }
        else if(data == "d") {
            dataTextString = "Listen this song, so good.. Die With a Smile"
        }
        
        if(data == "a") {
            notifyTextString = "shared a loop 5s ago."
        }
        else if(data == "b") {
            notifyTextString = "just commented on your post."
        }
        else if(data == "c") {
            notifyTextString = "started following you."
        }
        else if(data == "d") {
            notifyTextString = "liked your shot."
        }
        
        //creator id, sound and place id
        if(data == "a") {
            userId = "u2"
            placeId = "p3"
            soundId = "s4"
        }
        else if(data == "b") {
            userId = "u1"
            placeId = "p2"
            soundId = "s3"
        }
        else if(data == "c") {
            userId = "u4"
            placeId = "p1"
            soundId = "s2"
        }
        else if(data == "d") {
            userId = "u3"
            placeId = "p4"
            soundId = "s1"
        }
    }
}

class PlaceDataset: BaseDataset {
    
    var coverPhotoString: String = ""
    var isAccountVerified = false
    
    func setupData(data: String) {
        dataCode = data
        dataArray.append(data)
    }
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setData(data: String) {
        dataArray.append(data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["bookmark"] = 7902
        }
        else if(data == "b") {
            dataCount["bookmark"] = 87053
        }
        else if(data == "c") {
            dataCount["bookmark"] = 12
        }
        else if(data == "d") {
            dataCount["bookmark"] = 654
        }
    }
    
    func setTextString(data: String) {
        if(data == "a") {
//            dataTextString = "Dominican Convent School 奥本大学"
            dataTextString = "Iphone Factory A1"
        }
        else if(data == "b") {
            dataTextString = "Petronas Twin Tower"
        }
        else if(data == "c") {
            dataTextString = "Doja HQ"
        }
        else if(data == "d") {
//            dataTextString = "悉尼"
            dataTextString = "Nvidia GPU Lab"
        }
        
        //profile photo
        if(data == "a") {
            coverPhotoString = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
        }
        else if(data == "b") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media"
        }
        else if(data == "c") {
            coverPhotoString = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
        }
        else if(data == "d") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media"
        }
        
        //account verified
        if(data == "a") {
            isAccountVerified = false
        }
        else if(data == "b") {
            isAccountVerified = true
        }
        else if(data == "c") {
            isAccountVerified = false
        }
        else if(data == "d") {
            isAccountVerified = true
        }
    }
}

class SoundDataset: BaseDataset {
    
    var coverPhotoString: String = ""
    var isAccountVerified = false
    
    var userId: String = "" //creator
    var placeId: String = ""
    
    func setupData(data: String) {
        dataCode = data
        dataArray.append(data)
        setDataCount(data: data)
        setTextString(data: data)
    }
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setData(data: String) {
        dataArray.append(data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["love"] = 3796
            dataCount["comment"] = 209
            dataCount["share"] = 98
            dataCount["bookmark"] = 890
        }
        else if(data == "b") {
            dataCount["love"] = 675
            dataCount["comment"] = 2708
            dataCount["share"] = 719
            dataCount["bookmark"] = 604
        }
        else if(data == "c") {
            dataCount["love"] = 74
            dataCount["comment"] = 921
            dataCount["share"] = 32
            dataCount["bookmark"] = 34
        }
        else if(data == "d") {
            dataCount["love"] = 18312
            dataCount["comment"] = 1309
            dataCount["share"] = 478
            dataCount["bookmark"] = 57
        }
    }
    
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "偶像 Behind The Light - 麋先生 MIXER feat. 五月天 阿信 Mayday Ashin"
        }
        else if(data == "b") {
            dataTextString = "YOU DON'T NEED TO KNOW 你不用懂 - J.Sheon"
        }
        else if(data == "c") {
            dataTextString = "APT. - ROSÉ & Bruno Mars"
        }
        //test
        else if(data == "d") {
            dataTextString = "Die With a Smile - Lady Gaga, Bruno Mars"
        }
        
        //profile photo
        if(data == "a") {
            coverPhotoString = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
        }
        else if(data == "b") {
            coverPhotoString =
            "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media"
        }
        else if(data == "c") {
            coverPhotoString = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
        }
        else if(data == "d") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media"
        }
        
        //account verified
        if(data == "a") {
            isAccountVerified = false
        }
        else if(data == "b") {
            isAccountVerified = true
        }
        else if(data == "c") {
            isAccountVerified = false
        }
        else if(data == "d") {
            isAccountVerified = true
        }
        
        //creator id, sound and place id
        if(data == "a") {
            userId = "u2"
            placeId = "p3"
        }
        else if(data == "b") {
            userId = "u1"
            placeId = "p4"
        }
        else if(data == "c") {
            userId = "u4"
            placeId = "p1"
        }
        else if(data == "d") {
            userId = "u3"
            placeId = "p2"
        }
    }
}

class UserDataset: BaseDataset {
    
    var bioTextString: String = ""
    var coverPhotoString: String = ""
    var isAccountVerified = false
    
    func setupData(data: String) {
        dataCode = data
        dataArray.append(data)
    }
    
    func setId(dataId: String) {
        id = dataId
    }
    
    func setData(data: String) {
        dataArray.append(data)
    }
    
    func setDataCode(data: String) {
        dataCode = data
    }
    
    func setDataCount(data: String) {
        if(data == "a") {
            dataCount["follow"] = 13
            dataCount["follower"] = 1330000
        }
        else if(data == "b") {
            dataCount["follow"] = 0
            dataCount["follower"] = 291
        }
        else if(data == "c") {
            dataCount["follow"] = 453
            dataCount["follower"] = 27000
        }
        else if(data == "d") {
            dataCount["follow"] = 5
            dataCount["follower"] = 91900
        }
    }
    
    func setTextString(data: String) {
        //name
        if(data == "a") {
            dataTextString = "姬絲蒂"
        }
        else if(data == "b") {
            dataTextString = "Paul 欽戈卡"
        }
        else if(data == "c") {
            dataTextString = "Doja"
        }
        else if(data == "d") {
            dataTextString = "LALISA"
        }
        
        //bio
        if(data == "a") {
            bioTextString = "cars/tech/content creator"
        }
        else if(data == "b") {
            bioTextString = "U know who I am"
        }
        else if(data == "c") {
            bioTextString = ".....SIU....."
        }
        //test
        else if(data == "d") {
            bioTextString = "音乐博主"
        }
        
        //profile photo
        if(data == "a") {
//            profilePhotoString = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media"
            coverPhotoString = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
        }
        else if(data == "b") {
//            profilePhotoString = "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg"
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media"
        }
        else if(data == "c") {
            coverPhotoString = "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg"
        }
        //test
        else if(data == "d") {
            coverPhotoString = "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media"
        }
        
        //account verified
        if(data == "a") {
            isAccountVerified = true
        }
        else if(data == "b") {
            isAccountVerified = true
        }
        else if(data == "c") {
            isAccountVerified = false
        }
        else if(data == "d") {
            isAccountVerified = true
        }
    }
}

class PhotoContentDataset : ContentDataset {
    //setup data array for photos in shot
    func setData(data: String) {
        if(data == "a") {
            dataArray.append("https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
            dataArray.append("https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
            dataArray.append("https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        }
        else if(data == "b") {
            dataArray.append("https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        }
        else if(data == "c") {
            dataArray.append("https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        }
        else if(data == "d") {
            dataArray.append("https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            dataArray.append("https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        }
    }
}

class QuoteContentDataset : ContentDataset {
    
    //test > quote comment for a start
    func setData(data: String) {
        if(contentDataType == "comment") {
            if(data == "a") {
                //comment4
                setId(dataId: "comment4")
                
                dataArray.append("text")
                dataArray.append("photo") //photo
                dataArray.append("text")
                dataArray.append("video")

                //store corresponding text from comment
                dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
            }
            else if(data == "b") {
                //comment2
                setId(dataId: "comment2")
                
                dataArray.append("text")

                //store corresponding text from comment
//                dataTextString = "A defiant Vladimir Putin"
                dataTextString = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
            }
            else if(data == "c") {
                //comment3
                setId(dataId: "comment3")
                
                dataArray.append("photo_s")

                //store corresponding text from comment
                dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
            }
            else if(data == "d") {
                //comment1
                setId(dataId: "comment1")
                
                dataArray.append("text")
                dataArray.append("quote") //quote
                dataArray.append("video_l")

                //store corresponding text from comment
                dataTextString = "Nice food, nice environment! Worth a visit. \n\nSo Good.\n.\n..\n...\n....\n...\n..\n.\n.\n."
            }
        }
        else if(contentDataType == "post"){
            if(data == "a") {
                //post4
                setId(dataId: "post4")
                
                dataArray.append("text") //text
                dataArray.append("video") //video
                dataArray.append("video_l") //loop
                dataArray.append("text") //text
                dataArray.append("photo")
                dataArray.append("photo_s")
                dataArray.append("quote") //quote

                //store corresponding text from comment
//                dataTextString = "China to be a “greedy country”"
                dataTextString = "China to be a “greedy country” that would take what it wanted"
            }
            else if(data == "b") {
                //post2
                setId(dataId: "post2")
                
                dataArray.append("text") //text
                dataArray.append("photo") //photo
                dataArray.append("photo_s") //video
                dataArray.append("quote") //quote
                dataArray.append("video") //loop
                dataArray.append("video_l") //loop

                //store corresponding text from comment
                dataTextString = "韩国前总统尹锡悦涉嫌带头发动内乱刑事案件将于当地时间14日正式启动审理."
            }
            else if(data == "c") {
                //post3
                setId(dataId: "post3")
                
                dataArray.append("photo") //photo
                dataArray.append("quote") //quote
                dataArray.append("video") //loop
                dataArray.append("video") //video

                //store corresponding text from comment
                dataTextString = "接收来自宇宙诗人@刘宇Yu_ 的仪式感约定吧"
            }
            else if(data == "d") {
                //post1
                setId(dataId: "post1")
                
                dataArray.append("text") //text
                dataArray.append("photo_s") //video
                dataArray.append("text") //text
                dataArray.append("quote") //quote

                //store corresponding text from comment
                dataTextString = "The growth outlook of economies in the region will be negatively affected by a fall in external demand partly due to the tariffs’ wider impact on global trade and growth."
            }
        }
    }
}

class TextContentDataset : ContentDataset {
    func setTextString(data: String) {
        if(data == "a") {
            dataTextString = "韩国前总统尹锡悦涉嫌带头发动内乱刑事案件将于当地时间14日正式启动审理."
        }
        else if(data == "b") {
            dataTextString = "The growth outlook of economies in the region will be negatively affected by a fall in external demand partly due to the tariffs’ wider impact on global trade and growth."
        }
        else if(data == "c") {
            dataTextString = "接收来自宇宙诗人@刘宇Yu_ 的仪式感约定吧"
        }
        else if(data == "d") {
//            dataTextString = "The 52-year-old Malaysian, who works in a mosque in Malaysia’s Johor state, admitted that many of his friends and family perceived China to be a “greedy country” that would take what it wanted with little regard to the sovereignty of others."
//            dataTextString = "China to be a “greedy country”"
            dataTextString = "China to be a “greedy country” that would take what it wanted"
        }
    }
    
    func setTextStringB(data: String) {
        if(data == "a") {
            dataTextString = "Nice food, nice environment! Worth a visit. \n\nSo Good.\n.\n..\n...\n....\n...\n..\n.\n.\n."
        }
        else if(data == "b") {
            dataTextString = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
        }
        else if(data == "c") {
            dataTextString = "Vấn đề đã rõ, đã chín, được thực tiễn chứng minh là đúng, thực hiện hiệu quả, đa số đồng tình thì tiếp tục thực hiện"
        }
        else if(data == "d") {
//            dataTextString = "A defiant Vladimir Putin."
            dataTextString = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
        }
    }
}

//for simulating firestore fetch geopoints
class GeoDataset {
    var geoCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var geohashL3 = ""
    var docId = ""
    
    func setGeoCoord(coord: CLLocationCoordinate2D) {
        geoCoord = coord
    }
    
    func getGeoCoord() -> CLLocationCoordinate2D{
        return geoCoord
    }
    
    func setGeohashL3(L3: String) {
        geohashL3 = L3
    }
    
    func getGeohashL3() -> String{
        return geohashL3
    }
    
    func setDocId(id: String) {
        docId = id
    }
    
    func getDocId() -> String{
        return docId
    }
}
