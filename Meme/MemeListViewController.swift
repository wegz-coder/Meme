//
//  MemeListViewController.swift
//  Meme
//
//  Created by Waged Baioumy on 05.01.22.
//

import Foundation
import UIKit

class MemeListViewController : UIViewController {
    
    @objc func createMeme(sender: UIBarButtonItem){
        print("open meme editor!")
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController else{
            print("failed to initiate VC!")
            return
        }
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
  
    func configureNav(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus") , style: .done, target: self, action: #selector(createMeme(sender:)))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
    }
    
}
