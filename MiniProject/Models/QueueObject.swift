//
//  QueueObject.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation

//queue state to open video panel, photo panel etc
//aim to avoid fast multi click and open conflicting multiple panels
//only allow latest click to open panel and deactivate previous clicks
class QueueObject {
    var isToOpenPanel = false
    var isPanelActive = false //state to indicate active or inactive
    var queueId = -1
    
    func setIsToOpenPanel(isToOpen: Bool) {
        isToOpenPanel = isToOpen
    }
    
    func getIsToOpenPanel() -> Bool{
        return isToOpenPanel
    }
    
    func setIsPanelActive(isActive: Bool) {
        isPanelActive = isActive
    }
    
    func getIsPanelActive() -> Bool{
        return isPanelActive
    }
    
    func setId(id : Int) {
        queueId = id
    }
    
    func getId() -> Int {
        return queueId
    }
}
