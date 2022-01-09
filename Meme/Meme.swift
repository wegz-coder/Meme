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
    
    init(topText: String , bottomText:String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

// MARK: - Meme (All Memes)

/**
* This extension adds static variable allVillains. An array of Villain objects
*/

extension Meme {

    // Generate an array full of all of the villains in
    static var allMemes: [Meme] {
        var memeArray = [Meme]()
        memeArray.append(Meme(topText: "String" , bottomText:"String", originalImage: UIImage(systemName: "heart.fill")! , memedImage: UIImage(systemName: "heart.fill")!))
        memeArray.append(Meme(topText: "String" , bottomText:"String", originalImage: UIImage(systemName: "heart.fill")! , memedImage: UIImage(systemName: "heart.fill")!))
//        for meme in memeArray.localMemeData() {
//            memeArray.append(meme.memeId)
//        }
        return memeArray
    }
    
//    static func localMemeData() -> [Meme] {
//        return [
//            Meme(memeId: 1, topText: "String" , bottomText:"String", originalImage: UIImage(systemName: "heart.fill") , memedImage: UIImage(systemName: "heart.fill")),
//            Meme(memeId: 2, topText: "String" , bottomText:"String", originalImage: UIImage(systemName: "heart.fill") , memedImage: UIImage(systemName: "heart.fill"))
//            [Villain.NameKey : "Mr. Big", Villain.EvilSchemeKey : "Smuggle herion.",  Villain.ImageNameKey : "Big"],
//            [Villain.NameKey : "Ernest Blofeld", Villain.EvilSchemeKey : "Many, many, schemes.",  Villain.ImageNameKey : "Blofeld"],
//            [Villain.NameKey : "Sir Hugo Drax", Villain.EvilSchemeKey : "Nerve gass Earth, from the Moon.",  Villain.ImageNameKey : "Drax"],
//            [Villain.NameKey : "Jaws", Villain.EvilSchemeKey : "Kill Bond with huge metal teeth.",  Villain.ImageNameKey : "Jaws"],
//            [Villain.NameKey : "Rosa Klebb", Villain.EvilSchemeKey : "Humiliate MI6",  Villain.ImageNameKey : "Klebb"],
//            [Villain.NameKey : "Emilio Largo", Villain.EvilSchemeKey : "Steal nuclear weapons", Villain.ImageNameKey : "EmilioLargo"],
//            [Villain.NameKey : "Le Chiffre", Villain.EvilSchemeKey : "Beat bond at poker.",  Villain.ImageNameKey : "Lechiffre"],
//            [Villain.NameKey : "Odd Job", Villain.EvilSchemeKey : "Kill Bond with razor hat.",  Villain.ImageNameKey : "OddJob"],
//            [Villain.NameKey : "Francisco Scaramanga", Villain.EvilSchemeKey : "Kill Bond after assembling a golden gun.",  Villain.ImageNameKey : "Scaramanga"],
//            [Villain.NameKey : "Raoul Silva", Villain.EvilSchemeKey : "Kill M.",  Villain.ImageNameKey : "Silva"],
//            [Villain.NameKey : "Alec Trevelyan", Villain.EvilSchemeKey : "Nuke London, after killing Bond.",  Villain.ImageNameKey : "Trevelyan"],
//            [Villain.NameKey : "Auric Goldfinger", Villain.EvilSchemeKey : "Nuke Fort Knox.",  Villain.ImageNameKey : "Goldfinger"],
////            [Villain.NameKey : "Max Zorin", Villain.EvilSchemeKey : "Destroy Silicon Valley with an earthquake and flood.",  Villain.ImageNameKey : "Zorin"]
//        ]
//    }
}

