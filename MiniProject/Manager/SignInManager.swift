//
//  SignInManager.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation
import UIKit

enum SignInError: Error {
    case networkError
    case invalidResponse
}

class SignInManager {

    static let shared = SignInManager()
    public var isUserSignedIn = false
    
    func signIn(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1.0, execute: { //0.6s
            let originalData = [
                id
            ]
            
            var isSignedIn = false
            self.isUserSignedIn = true
            isSignedIn = true

            completion(.success(isSignedIn))
            
            //test > testing for error handling
//            completion(.failure(SignInError.invalidResponse))
        })
    }
    
    func signOut(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+1.0, execute: { //0.6s
            let originalData = [
                id
            ]
            
            var isSignedIn = false
            self.isUserSignedIn = false
            isSignedIn = false

            completion(.success(isSignedIn))

        })
    }
    
    func fetchStatus(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {

        DispatchQueue.global().asyncAfter(deadline: .now()+0.0, execute: { //0.6s
            let originalData = [
                id
            ]
            
            var isSignedIn = false
            if(self.isUserSignedIn) {
                isSignedIn = true
            } else {
                isSignedIn = false
            }

            completion(.success(isSignedIn))
        })
    }
}
