//
//  Meme.swift
//  Meme
//
//  Created by Waged Baioumy on 31.12.21.
//

import Foundation
import UIKit

// meme structure.
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init( topText: String , bottomText:String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
