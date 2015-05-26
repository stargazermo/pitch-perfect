//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by MoXiafang on 5/22/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import Foundation

//Class and initializer for storing the file's path and title.
class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: NSString
    
    init (filePathUrl: NSURL, title: NSString) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
   
}
