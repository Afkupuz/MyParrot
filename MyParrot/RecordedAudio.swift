//
//  RecordedAudio.swift
//  MyParrot
//
//  Created by nicolas on 3/15/16.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(_ url: NSURL, name: String) {
        filePathUrl = url
        title = name
    }
}