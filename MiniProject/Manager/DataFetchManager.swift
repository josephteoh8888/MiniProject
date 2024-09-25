//
//  DataFetchManager.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation
import UIKit
import GoogleMaps

enum FetchDataError: Error {
    case dataNotFound
    case networkError
    case invalidResponse
}

class DataFetchManager {

    static let shared = DataFetchManager()
    
    public var isPaginating = false

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
    
    func fetchUserData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            if(id == "u") { // "u" - success, "u_" - error
                newData.append("a") //a - data available, b - suspended, c - deleted
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    
    func fetchPlaceData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            if(id == "p") {
                newData.append("a")
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    
    func fetchSoundData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            if(id == "s") {
                newData.append("a")
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    
    func fetchPostData(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            if(id == "post_") {
                newData.append("a")
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    
    func fetchFeedData(id: String, isPaginate: Bool, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            
            if(id == "post") {
                if(isPaginate == false) {
        
                    newData.append("a")
                    newData.append("b") //a
                    newData.append("d") //a
                    newData.append("c") //a
                } else  {
                    //post_feed_end
                }
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    func fetchCommentFeedData(id: String, isPaginate: Bool, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            
            if(id == "comment") {
                if(isPaginate == false) {
        
                    newData.append("a")
                    newData.append("b") //a
                    newData.append("c") //a
                    
//                    newData.append("a")
//                    newData.append("b") //a
//                    newData.append("c") //a
                } else  {
                    //post_feed_end
                }
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
        })
    }
    func fetchVideoData(id: String, isPaginate: Bool, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            var newData = [String]()
            
            if(id == "video") {
                if(isPaginate == false) {
        
                    newData.append("a")
                    newData.append("a") //a
                    newData.append("a") //a
                    newData.append("a") //a
                } else  {
                    //video_feed_end
//                    newData.append("a") 
                }
                completion(.success(newData))
            }
            else {
                completion(.failure(FetchDataError.invalidResponse))
            }
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
    
    //test > replicate firestore fetch data for getHeatmapPoints()
    func fetchGeoData(id: String, completion: @escaping (Result<[GeoDataset], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            
            //new geodataset consists of docId, geohashL3, CLLocationCoordinate2D
            //20 datasets
            var newData = [GeoDataset]()
            if(id == "g") {//g for geo
                let g1 = GeoDataset()
                g1.setDocId(id: "7av7nOI5skqzeVBdu2ft")
                g1.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 33.902757434542714, longitude: 35.517696775496006))
                g1.setGeohashL3(L3: "sy1")
                newData.append(g1)
                
                let g2 = GeoDataset()
                g2.setDocId(id: "7VWJDcnxcOnwyHL1WmnH")
                g2.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 30.657945863406443, longitude: 104.07866064459084))
                g2.setGeohashL3(L3: "wm6")
                newData.append(g2)
                
                let g3 = GeoDataset()
                g3.setDocId(id: "7aSgtvq2XxwdeEE1Q92X")
                g3.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 1.287793443945, longitude: 103.86655524373055))
                g3.setGeohashL3(L3: "w21")
                newData.append(g3)
                
                let g4 = GeoDataset()
                g4.setDocId(id: "85MgX76HYqzSrF38VzrJ")
                g4.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 37.540045518458, longitude: 126.99210170656443))
                g4.setGeohashL3(L3: "wyd")
                newData.append(g4)
                
                let g5 = GeoDataset()
                g5.setDocId(id: "4jc05r9NtCjYOIU02tFZ")
                g5.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 3.237884480860792, longitude: 101.68403841555117))
                g5.setGeohashL3(L3: "w28")
                newData.append(g5)
                
                let g6 = GeoDataset()
                g6.setDocId(id: "5ww5gi0zEcSCC4COdpID")
                g6.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 4.558963399717284, longitude: 101.12940385937691))
                g6.setGeohashL3(L3: "w0z")
                newData.append(g6)
                
                let g7 = GeoDataset()
                g7.setDocId(id: "5rE9wVrnZi6WrvRZdMUA")
                g7.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 24.962307935870314, longitude: 55.17170637845993))
                g7.setGeohashL3(L3: "thr")
                newData.append(g7)
                
                let g8 = GeoDataset()
                g8.setDocId(id: "NTpRD43TJi7KPGhgH5F")
                g8.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 42.358777297524966, longitude: -71.06381021440029))
                g8.setGeohashL3(L3: "drt")
                newData.append(g8)
                
                let g9 = GeoDataset()
                g9.setDocId(id: "DKvaBSxTeeBF3NCjENE3")
                g9.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 37.7749282526632, longitude: -122.41941545158625))
                g9.setGeohashL3(L3: "9q8")
                newData.append(g9)
                
                let g10 = GeoDataset()
                g10.setDocId(id: "EwUCKdBDqak8Uba2O2Gi")
                g10.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 28.338447928324257, longitude: 120.87541490793228))
                g10.setGeohashL3(L3: "wtj")
                newData.append(g10)
                
                let g11 = GeoDataset()
                g11.setDocId(id: "CSXQ3C6SNGDVUjJhkgmL")
                g11.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 39.13541402203981, longitude: 117.18012616038322))
                g11.setGeohashL3(L3: "wwg")
                newData.append(g11)
                
                let g12 = GeoDataset()
                g12.setDocId(id: "Ake5vPkSoU9KkG7PWOVL")
                g12.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 52.38976834714428, longitude: 13.790811002254486))
                g12.setGeohashL3(L3: "u33")
                newData.append(g12)
                
                let g13 = GeoDataset()
                g13.setDocId(id: "B81NmKgD9SInNMN7CsIq")
                g13.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 39.81074299608123, longitude: 116.28744006156923))
                g13.setGeohashL3(L3: "wx4")
                newData.append(g13)
                
                let g14 = GeoDataset()
                g14.setDocId(id: "Gauk6oV45CdGbcKvB8R4")
                g14.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 40.70687688282425, longitude: -74.01126556098461))
                g14.setGeohashL3(L3: "dr5")
                newData.append(g14)
                
                let g15 = GeoDataset()
                g15.setDocId(id: "PEZKml0dq4QnqKPBcOLW")
                g15.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 33.94158899989779, longitude: -118.4085299447179))
                g15.setGeohashL3(L3: "9q5")
                newData.append(g15)
                
                let g16 = GeoDataset()
                g16.setDocId(id: "Q5Pu6IZXoHst0PLYrEXn")
                g16.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 35.44981810452331, longitude: 139.6649408340454))
                g16.setGeohashL3(L3: "xn7")
                newData.append(g16)
                
                let g17 = GeoDataset()
                g17.setDocId(id: "PsT5iO9JSjJieo1V6Uc7")
                g17.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 23.106119666763647, longitude: 113.32411509007214))
                g17.setGeohashL3(L3: "ws0")
                newData.append(g17)
                
                let g18 = GeoDataset()
                g18.setDocId(id: "TxH5CW7rK2wworkIzJtY")
                g18.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 35.65870136759362, longitude: 139.70166765153408))
                g18.setGeohashL3(L3: "xn7")
                newData.append(g18)
                
                let g19 = GeoDataset()
                g19.setDocId(id: "XK4jYKIYL7buoiT8j4Zc")
                g19.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 52.36757273141493, longitude: 4.904138892889023))
                g19.setGeohashL3(L3: "u17")
                newData.append(g19)
                
                let g20 = GeoDataset()
                g20.setDocId(id: "ad7pycprhQGKY9jvsTuu")
                g20.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 51.554888456761816, longitude: -0.10843802243471146))
                g20.setGeohashL3(L3: "gcp")
                newData.append(g20)
            }

            completion(.success(newData))

        })
    }
    
    //test > replicate fetch data from firestore for getSinglePoint
    func fetchSingleGeoData(id: String, completion: @escaping (Result<[GeoDataset], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.6, execute: { //0.6s
            
            //new geodataset consists of docId, geohashL3, CLLocationCoordinate2D
            //6 datasets
            var newData = [GeoDataset]()
            if(id == "g") {//g for geo
                let g1 = GeoDataset()
                g1.setDocId(id: "bvrYBdlWvplb4bN2vSfy")
                g1.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 13.746630434334975, longitude: 100.53933497518301))
                g1.setGeohashL3(L3: "w4r")
                newData.append(g1)
                
                let g2 = GeoDataset()
                g2.setDocId(id: "dH1YrMKD8ZB65ULW78Un")
                g2.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 59.0346707669393, longitude: 6.577522158622743))
                g2.setGeohashL3(L3: "u4k")
                newData.append(g2)
                
                let g3 = GeoDataset()
                g3.setDocId(id: "dUY3T2IsdJMfDj9gLLHf")
                g3.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 2.9998520634047185, longitude: 101.39282997697592))
                g3.setGeohashL3(L3: "w28")
                newData.append(g3)
                
                let g4 = GeoDataset()
                g4.setDocId(id: "csFZyJ0lJbx5mUr3INoh")
                g4.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 29.345799901995086, longitude: 110.47253999859095))
                g4.setGeohashL3(L3: "wmn")
                newData.append(g4)
                
                let g5 = GeoDataset()
                g5.setDocId(id: "isM8mq4DQXsRvrgkG0Pb")
                g5.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 35.53635070363098, longitude: 129.31647017598152))
                g5.setGeohashL3(L3: "wy7")
                newData.append(g5)
                
                let g6 = GeoDataset()
                g6.setDocId(id: "hGd3wY6dRt4Db3HUjGN1")
                g6.setGeoCoord(coord: CLLocationCoordinate2D(latitude: 23.11268985322856, longitude: 113.26698403805494))
                g6.setGeohashL3(L3: "ws0")
                newData.append(g6)
            }

            completion(.success(newData))

        })
    }
}

