//
//  APICaller.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation

//test > fake data generation to test async actions
class APICaller {
    
    public var isPaginating = false
    func fetchData(id: Int, pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
        
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+1.6, execute: {
            let originalData = [
                String(id)
            ]
            let newData = [
                "banana", "orange"
            ]
            completion(.success(pagination ? newData: originalData))
            
            if pagination {
                self.isPaginating = false
            }
        })
    }
}
