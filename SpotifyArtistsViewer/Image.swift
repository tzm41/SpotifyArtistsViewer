//
//  Image.swift
//  SpotifyArtistsViewer
//
//  Created by Colin Tan on 6/16/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit

class Image {
    let width: CGFloat
    let height: CGFloat
    let url: NSURL
    
    init?(json: NSDictionary) {
        if let width = json["width"] as? CGFloat {
            self.width = width
        } else { return nil }
        
        if let height = json["height"] as? CGFloat {
            self.height = height
        } else { return nil }
        
        if let urlString = json["url"] as? String {
            url = NSURL(string: urlString)!
        } else { return nil }
    }
    
    var imageContent: UIImage? {
        if let imageData = NSData(contentsOfURL: url) {
            return UIImage(data: imageData)
        }
        return nil
    }
}