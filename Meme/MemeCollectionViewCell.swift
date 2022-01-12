//
//  MemeCollectionViewCell.swift
//  Meme
//
//  Created by Waged Baioumy on 12.01.22.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "MemeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        imageView.image = image
    }
    static func nib() -> UINib{
        return UINib(nibName: "MemeCollectionViewCell", bundle: nil)
    }

}
