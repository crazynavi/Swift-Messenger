//
//  Message.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase

struct MessageSubtitle {
  static let video = "Attachment: Video"
  static let image = "Attachment: Image"
  static let audio = "Audio message"
  static let empty = "No messages here yet."
}

class Message: NSObject {
  
    var messageUID: String?
    var isInformationMessage: Bool?

    var fromId: String?
    var text: String?
    var toId: String?
    var timestamp: NSNumber?
    var convertedTimestamp: String?
  
    var status: String?
    var seen: Bool?
  
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
  
    var localImage: UIImage?
  
    var localVideoUrl: String?
  
    var voiceData: Data?
    var voiceDuration: String?
    var voiceStartTime: Int?
    var voiceEncodedString: String?

    var videoUrl: String?
  
    var estimatedFrameForText: CGRect?
  
    var landscapeEstimatedFrameForText: CGRect?
  
    var imageCellHeight: NSNumber?
  
    var isCrooked:Bool? // local only
  
    var senderName: String? //local only, group messages only
      
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
  
    init(dictionary: [String: AnyObject]) {
        super.init()
      
        messageUID = dictionary["messageUID"] as? String
        isInformationMessage = dictionary["isInformationMessage"] as? Bool
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
      
        convertedTimestamp = dictionary["convertedTimestamp"] as? String
      
        status = dictionary["status"] as? String
        seen = dictionary["seen"] as? Bool
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        
        videoUrl = dictionary["videoUrl"] as? String
      
        localImage = dictionary["localImage"] as? UIImage
        localVideoUrl = dictionary["localVideoUrl"] as? String
      
        voiceEncodedString = dictionary["voiceEncodedString"] as? String
        voiceData = dictionary["voiceData"] as? Data //unused
        voiceDuration = dictionary["voiceDuration"] as? String
        voiceStartTime = dictionary["voiceStartTime"] as? Int
      
        estimatedFrameForText = dictionary["estimatedFrameForText"] as? CGRect
        landscapeEstimatedFrameForText = dictionary["landscapeEstimatedFrameForText"] as? CGRect
        imageCellHeight = dictionary["imageCellHeight"] as? NSNumber
      
        senderName = dictionary["senderName"] as? String
      
        isCrooked = dictionary["isCrooked"] as? Bool
    }
  
  
 static func messages(_ groupedMessages: [String: [Message]]) -> [Message] {
    
   let messages = groupedMessages.flatMap { (arg0) -> [Message] in
      return arg0.value
    }
    
    return messages
  }
  
  func groupedByDate(messages: [Message]) -> [String: [Message]] {
    
    let datesArray = messages.compactMap { (message) -> String in
      if let timestamp = message.timestamp {
        let date = Date(timeIntervalSince1970: TimeInterval(truncating: timestamp)).getShortDateStringFromUTC()
        
        return date
      }
      return ""
    } // return array of date
    
    var timeGroupedMessages = [String: [Message]]() // Your required result
    
    datesArray.forEach {
      let dateKey = $0
      
      let filterArray = messages.filter({ (message) -> Bool in
        if let timestamp = message.timestamp {
          let date = Date(timeIntervalSince1970: TimeInterval(truncating: timestamp)).getShortDateStringFromUTC()
          return date == dateKey
        }
        return false
      })
      
      timeGroupedMessages[$0] = filterArray
    }
    
     print( timeGroupedMessages.keys,   timeGroupedMessages.keys.count, timeGroupedMessages)
    return timeGroupedMessages
  }
}
