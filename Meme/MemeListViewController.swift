//
//  MemeListViewController.swift
//  Meme
//
//  Created by Waged Baioumy on 05.01.22.
//

import Foundation
import UIKit

class MemeListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet var memeTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memesHere: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        print(appDelegate.memes)
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        print("tableView viewDidLoad")
        NotificationCenter.default.addObserver(self, selector:  #selector(self.reloadData(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        memeTableView.delegate = self
        memeTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tableView viewWillAppear")
        memeTableView.reloadData()
    }
    
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
    
    
    @objc func reloadData(_ notification: Notification?) {
        DispatchQueue.main.async {
            [weak self] in
            self?.memeTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memesHere.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("you tapped me table!")
        let meme = memesHere[indexPath.row]
        print(meme.topText)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        // let meme = self.allMemes[(indexPath as NSIndexPath).row]
        let meme = memesHere[indexPath.row]
        // Set the name and image
        cell.textLabel?.text =  "\(meme.topText)..\(meme.bottomText)"
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
