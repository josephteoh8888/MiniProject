//
//  VideoPreviewPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

enum UploadDataError: Error {
    case networkError
    case invalidResponse
}

class DataUploadManager {
    
    static let shared = DataUploadManager()
    var uploadTaskList = [String : String]() //postId : status

    //test > send data for uploading posts
    func sendData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        
        uploadTaskList.updateValue("progress", forKey: id)
        
        DispatchQueue.global().asyncAfter(deadline: .now()+3.0, execute: { //1.0s
            
            var newData = [String]()
            
            if(id == "a") {
                newData.append("a")
                self.uploadTaskList.updateValue("success", forKey: id)
                
                completion(.success(newData))
            }
            else {
                
                self.uploadTaskList.updateValue("fail", forKey: id)
                completion(.failure(UploadDataError.networkError))
            }

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
    
    //test > upload new comment
    func sendCommentData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1.0, execute: { //0.6s
            
            var newData = [String]()

            if(id == "c") {
                newData.append("a")

                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    
    //test > simple getter/setter for status retrieval
    func getStatus(id: String) -> String? {
        let status = uploadTaskList[id]
        return status
    }
}
