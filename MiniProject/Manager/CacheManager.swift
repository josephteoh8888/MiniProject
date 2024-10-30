//
//  CacheManager.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation
import UIKit

public enum CResult<T> {
    case success(T)
    case failure
}

class CacheManager {

    static let shared = CacheManager()
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsUrl
        //cachesDirectory is only for short term storage
    }()
    
    let CACHE_VIDEO_FILES_FOLDER_NAME = "DdmAppCache"
    let USER_DEFAULT_VID_CACHE_URLS = "VidUrlCacheArray" //simple LRU (Least Recently Used)

    func cacheVideoFile(stringUrl: String, completionHandler: @escaping (CResult<URL>) -> Void ) {
        let file = getCacheUrlFor(videoUrl: stringUrl)
        
        //check capacity before downloading
        self.checkVideoCacheCapacity()

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            print("cacheManager already exist")
            
            self.updateUserDefaultVideoCache(cacheFileStringName: self.getFileNameBySeparateString(videoUrl: stringUrl))
            
            completionHandler(CResult.success(file))
            return
        }

        DispatchQueue.global().async {

            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                //check capacity after downloaded file
                self.checkVideoCacheCapacity()
                
                DispatchQueue.main.async {
                    print("cacheManager download complete")
                    
                    self.updateUserDefaultVideoCache(cacheFileStringName: self.getFileNameBySeparateString(videoUrl: stringUrl))
                    
                    completionHandler(CResult.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    print("cacheManager download fail")
                    completionHandler(CResult.failure)
                }
            }
        }
    }
    
    func checkVideoCacheCapacity() {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(CACHE_VIDEO_FILES_FOLDER_NAME)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            let count = fileURLs.count
            print("cache files total: \(count)")
            
            //test > delete least used files
//            if(count > 10) {
//                purgeLeastUsedVideoCacheFiles()
//            }

        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    //test to delete 1 file first
    func purgeLeastUsedVideoCacheFiles() {
        let defaults = UserDefaults.standard
        var myarray = defaults.stringArray(forKey: USER_DEFAULT_VID_CACHE_URLS) ?? [String]()
        
        let file1 = myarray[0]
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: getFileUrlFor(cacheFileStringName: file1).path)  else {
            print("cacheManager deleteLeastUsedFiles already exist")
            
            let documentsURL = mainDirectoryUrl.appendingPathComponent(CACHE_VIDEO_FILES_FOLDER_NAME)
            do {
                try fileManager.removeItem(at: getFileUrlFor(cacheFileStringName: file1))
                print("cache delete deleteLeastUsedFiles files: ")
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                // process files
                print("cache delete deleteLeastUsedFiles files remain: \(fileURLs)")
                
                myarray.remove(at: 0)
                defaults.set(myarray, forKey: USER_DEFAULT_VID_CACHE_URLS)
                
                print("cache delete deleteLeastUsedFiles new array: \(myarray)")
            } catch {
                print("cache Error deleteLeastUsedFiles while deleting files")
            }
            return
        }

    }
    
    func getFileUrlFor(cacheFileStringName: String) -> URL {
        let documentsURL = self.mainDirectoryUrl.appendingPathComponent(CACHE_VIDEO_FILES_FOLDER_NAME)
        let file = documentsURL.appendingPathComponent(cacheFileStringName)
        
        return file
    }
    

    func getCacheUrlFor(videoUrl: String) -> URL {
        
        let fileURL = getFileNameBySeparateString(videoUrl: videoUrl)
        
        let documentsURL = self.mainDirectoryUrl.appendingPathComponent(CACHE_VIDEO_FILES_FOLDER_NAME)
        let file = documentsURL.appendingPathComponent(fileURL)
        
        return file
    }
    
    func getFileNameBySeparateString(videoUrl: String) -> String{
        let fullNameArr = videoUrl.components(separatedBy: "/")

        let name = fullNameArr[fullNameArr.count - 1]
        let halfNameArr = name.components(separatedBy: "?")
        let fileName = halfNameArr[0]
        print("separateString members: \(fileName)")
        
        return fileName
    }
    
    //start with inserting one url
    func updateUserDefaultVideoCache(cacheFileStringName: String) {
        let defaults = UserDefaults.standard
        var myarray = defaults.stringArray(forKey: USER_DEFAULT_VID_CACHE_URLS) ?? [String]()
        
        //remove existing value
        if let index = myarray.firstIndex(of: cacheFileStringName) {
            myarray.remove(at: index)
        }
        
        myarray.append(cacheFileStringName)
        defaults.set(myarray, forKey: USER_DEFAULT_VID_CACHE_URLS)
        
        print("insertCacheArray members: \(myarray)")
    }
    
    func deleteUserDefaultVideoCache() {
        let defaults = UserDefaults.standard
        defaults.set([], forKey: USER_DEFAULT_VID_CACHE_URLS)
    }
    
    func createDirectoryForVideoCache() {
        let dataPath = mainDirectoryUrl.appendingPathComponent(CACHE_VIDEO_FILES_FOLDER_NAME)
    
        if !fileManager.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                print("cache createDirectoryInCache ")
            } catch {
                print("cache createDirectoryInCache error \(error.localizedDescription)")
            }
        } else {
            print("cache createDirectoryInCache already exist")
        }
    }
    
    func showFilesVideoCacheDirectory() {
        //proved that NSUUID().uuidString produced unique strings everytime
        //print("checkFilesInDirectory remain: \(NSUUID().uuidString), \(NSUUID().uuidString), \(URLs)")
        
        let documentsURL = mainDirectoryUrl.appendingPathComponent(CACHE_VIDEO_FILES_FOLDER_NAME)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [.creationDateKey])
            
            for url in fileURLs {
                let resources = try url.resourceValues(forKeys: [.creationDateKey, .isRegularFileKey, .totalFileAllocatedSizeKey, .fileAllocatedSizeKey, .totalFileSizeKey])
                let creationDate = resources.creationDate!
                let isRegularFile = resources.isRegularFile!
                let totalFileAllocatedSize = resources.totalFileAllocatedSize!
                let fileAllocatedSize = resources.fileAllocatedSize!
                let totalFileSize = resources.totalFileSize!
                print("cache files creation date: \(url), \(creationDate), \(Date())")
                print("cache files file size: \(url), \(isRegularFile), \(totalFileAllocatedSize), \(fileAllocatedSize), \(totalFileSize)")
            }
            let count = fileURLs.count
            print("cache files total: \(count)")

        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        //get available disk space
//        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try documentsURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            if let capacity = values.volumeAvailableCapacity {
                print("cache capacity for important usage: \(capacity/1024/1024)")
            } else {
                print("cache capacity is unavailable")
            }
        } catch {
            print("cache error retrieving capacity: \(error.localizedDescription)")
        }
        do {
            let values = try documentsURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            if let capacity = values.volumeAvailableCapacityForImportantUsage {
                print("cache capacity for important usage: \(capacity/1024/1024)")
            } else {
                print("cache capacity is unavailable")
            }
        } catch {
            print("cache error retrieving capacity: \(error.localizedDescription)")
        }
        do {
            let values = try documentsURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            if let capacity = values.volumeAvailableCapacityForOpportunisticUsage {
                print("cache capacity for important usage: \(capacity/1024/1024)")
            } else {
                print("cache capacity is unavailable")
            }
        } catch {
            print("cache error retrieving capacity: \(error.localizedDescription)")
        }
        do {
            let values = try documentsURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            if let capacity = values.volumeTotalCapacity {
                print("cache capacity for important usage: \(capacity/1024/1024)")
            } else {
                print("cache capacity is unavailable")
            }
        } catch {
            print("cache error retrieving capacity: \(error.localizedDescription)")
        }
    }
    
}


//    func saveArray() {
//        let array = ["horse", "cow", "camel", "sheep", "goat"]
//
//        let defaults = UserDefaults.standard
//        defaults.set(array, forKey: "SavedStringArray")
//        print("save array: \(array)")
//    }
//
//    func getArray() {
//        let defaults = UserDefaults.standard
//        let myarray = defaults.stringArray(forKey: USER_DEFAULT_VID_CACHE_URLS) ?? [String]()
//        print("get cache array: \(myarray)")
//
////        let indexOfPerson1 = myarray.firstIndex{$0 == "sheep"}
////        guard let indexOfPerson1 = indexOfPerson1 else {
////            return
////        }
////        print("get find array: \(indexOfPerson1)")
//    }

//For caching video etc
//func cacheVideo(urls: [String]) {
//    for videoUrl in urls {
//        CacheManager.shared.getFileWith(stringUrl: videoUrl) { result in
//
//            switch result {
//            case .success(let url):
////                self.player = AVPlayer(url: url)
////                self.player?.play()
//                print("cachevideo succeed: \(url)")
//                break
//            case .failure:
////                self.showError.toggle()
//                break
//            }
//        }
//    }
//}
////delete ALL caches
//func deleteAllCache() {
//    let docURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let documentsUrl = docURL.appendingPathComponent(CACHE_FOLDER_NAME)
//    do {
//        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
//        for fileURL in fileURLs {
//            try FileManager.default.removeItem(at: fileURL)
//        }
//
//        let URLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
//        // process files
//        print("cache deleteAllCache remain: \(URLs)")
//
//        CacheManager.shared.deleteUserDefault()
//    } catch  { print(error) }
//}
//
////delete SOME caches
//func deleteCachedVideo2() {
//    let urls = ["https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/users%2FU904aNawESRXG0TUgckxwgL6hok2%2Fpost%2F3TSybtANZVj2TnMEqDUH%2Fvideo%2F0%2Fvid_0_SShqrlaZihTbyIw9ztq6W.mp4?alt=media",
//                "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/users%2FU904aNawESRXG0TUgckxwgL6hok2%2Fpost%2FtjCppqulc3ntIAVQOb8k%2Fvideo%2F0%2Fvid_0_wuYueeHaG9Ypzwx7cehwg.mp4?alt=media",
//                "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/users%2FIFCogkI6OIUlNifAIFz5Zj6Btuk1%2Fpost%2Fvg1A23fA4gdy8LSWNkxr%2Fvideo%2F0%2Fvid_0_KAdQ6hg68zsbnHq8OpHB1.mp4?alt=media",
//                "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/users%2FU904aNawESRXG0TUgckxwgL6hok2%2Fpost%2FpL7drrAD2MicYKZWP8Ie%2Fvideo%2F0%2Fvid_0_IjJzWTCaIDifP0aRM5mwI.mp4?alt=media"]
//
//    for url1 in urls {
//        let url = CacheManager.shared.directoryFor(stringUrl: url1)
//        let fileManager = FileManager.default
//        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let documentsURL = docURL.appendingPathComponent(CACHE_FOLDER_NAME)
//        do {
//            try fileManager.removeItem(at: url)
//            print("cache delete files: ")
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            // process files
//            print("cache delete files remain: \(fileURLs)")
//        } catch {
//            print("cache Error while deleting files")
//        }
//    }
//}
//
////delete some files
//func deleteIncompleteFiles() {
//    let docURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let fileUrl = docURL.appendingPathComponent("output_gif.gif.sb-7fc4a04c-gP5IsL")
//
//    try? FileManager.default.removeItem(at: fileUrl)
//
//    do {
//        let URLs = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: nil)
//        print("deleteIncompleteFiles remain: \(URLs)")
//    } catch  { print(error) }
//}
//
////get all files in TEMP dir
//func checkTempFilesInTempDirectory() {
////        let docURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    var fileUrl: URL = URL(fileURLWithPath: NSTemporaryDirectory())
//    do {
//        let URLs = try FileManager.default.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
//        // process files
//        print("checkTempFilesInTempDirectory remain: \(URLs)")
//    } catch  { print(error) }
//
//}

