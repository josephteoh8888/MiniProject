//
//  DataFetchManager.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation
import UIKit
//import SQLite

class DataFetchManager {

    static let shared = DataFetchManager()
    
    public var isPaginating = false
//    func fetchData(id: String, pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
    func fetchData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
//        if pagination {
//            isPaginating = true
//        }
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            let originalData = [
                id
            ]
//            let newData = ["Michael", "orange"]
            
            var newData = [String]()
            if(id == "u") {
                newData.append("Michael")
            } else if(id == "p") {
                newData.append("Petronas Twin Tower")
            } else if(id == "s") {
                newData.append("明知故犯 - Hubert Wu") //明知故犯 - Hubert Wu
            } else if(id == "post_feed") {
//                newData.append("d") //a
                newData.append("a")
                newData.append("b") //a
                newData.append("d") //a
                newData.append("c") //a
                
//                newData.append("d")
//                newData.append("d")
//                newData.append("d")
            } else if(id == "post_feed_end") {
//                newData.append("a")
//                newData.append("d") //a
//                newData.append("c") //a
                
//                newData.append("d")
//                newData.append("d")
//                newData.append("d")
            } else if(id == "photo_feed") {
                newData.append("a")
                newData.append("b") //a
                newData.append("c") //a
//                newData.append("a")
//                newData.append("a")
//                newData.append("a")
            } else if(id == "photo_feed_end") {

            } else if(id == "post") {
                newData.append("a")
            } else if(id == "video_feed") {
//                newData.append("a")
//                newData.append("b") //a
//                newData.append("c") //a
                newData.append("a")
                newData.append("a")
                newData.append("a")
//                newData.append("a")
//                newData.append("a")
//                newData.append("a")
//                newData.append("a")
//                newData.append("a")
//                newData.append("a")
            } else if(id == "video_feed_end") {

            } else if(id == "comment_feed") {
                newData.append("a")
                newData.append("b") //a
                newData.append("c") //a
            } else if(id == "comment_feed_end") {
                
            } else if(id == "search_term") {
                newData.append("a")
            } else if(id == "search_feed") {
                newData.append("a")
                newData.append("b") //a
                newData.append("d") //a
                newData.append("c") //a
                newData.append("a")
                newData.append("b") //a
                newData.append("d") //a
                newData.append("c") //a
            } else if(id == "search_feed_end") {
//                newData.append("a")
//                newData.append("d") //a
//                newData.append("c") //a
            } else if(id == "notify_feed") {
                newData.append("a")
                newData.append("b") //a
                newData.append("b") //a
                newData.append("b") //a
                newData.append("b") //a
                newData.append("b") //a
                newData.append("b") //a
                newData.append("b") //a
            } else if(id == "notify_feed_end") {
//                newData.append("a")
//                newData.append("d") //a
//                newData.append("c") //a
            }
//            completion(.success(pagination ? newData: originalData))
            completion(.success(newData))
            
//            if pagination {
//                self.isPaginating = false
//            }
        })
    }
    
    //test > send data for uploading posts
    func sendData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1.0, execute: { //0.6s
            let originalData = [
                id
            ]
            
            var newData = [String]()
            if(id == "u") {
                newData.append("Michael")
            } else if(id == "p") {
                newData.append("Petronas Twin Tower")
            } else if(id == "s") {
                newData.append("Miss You")
            }

            completion(.success(newData))

        })
    }
    
    //test > save data for drafts
    func saveData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1.0, execute: { //0.6s
            let originalData = [
                id
            ]
            
            var newData = [String]()
            if(id == "u") {
                newData.append("Michael")
            } else if(id == "p") {
                newData.append("Petronas Twin Tower")
            } else if(id == "s") {
                newData.append("Miss You")
            }

            completion(.success(newData))

        })
    }
}

