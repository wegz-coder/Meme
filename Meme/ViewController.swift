//
//  ViewController.swift
//  Meme
//
//  Created by Waged Baioumy on 25.11.21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var myToolBar: UIToolbar!
    @IBOutlet weak var myImageViewer: UIImageView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    var shiftOnlyOnce: Bool = true // shift keyboard only once due to callback get called several times.
    var imagePicker = UIImagePickerController()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth:  -3.5
    ]
    
    @objc func shareMemeAll(sender: UIBarButtonItem) {
        let text = "check this meme 🤣"
        let  memedImage: UIImage  = generateMemedImage()
//        let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , memedImage] as [Any]
        let shareVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        shareVC.excludedActivityTypes = [
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
               UIActivity.ActivityType.assignToContact,
               UIActivity.ActivityType.addToReadingList,

           ]
        shareVC.popoverPresentationController?.sourceView = self.view
        shareVC.completionWithItemsHandler = {
            [weak self] (activity, completed, items, error)  in
            if completed {
                print("completed meme share!")
                guard let strongSelf = self else {
                    return
                }
                let date :NSDate = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd'_'HHmmss"
                dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
                let fileName = "meme_\(dateFormatter.string(from: date as Date))"
                strongSelf.saveImage(imgName: fileName, memedImage: memedImage)
                strongSelf.tabBarController?.tabBar.isHidden = false
                strongSelf.navigationController?.popToRootViewController(animated: true)
            }
        }
        shareVC.isModalInPresentation = true
        self.present(shareVC, animated: true, completion: nil)
       }
    
    @objc func goToTabView(sender: UIBarButtonItem){
        print("Cancel doing Meme!")
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }

    func configureNav(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up") , style: .done, target: self, action: #selector(shareMemeAll(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel" , style: .plain, target: self, action: #selector(goToTabView(sender:)))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad: ViewController!")
        title = ""
        configureNav()
        // Do any additional setup after loading the view.
        textField1.defaultTextAttributes = memeTextAttributes
        textField2.defaultTextAttributes = memeTextAttributes
        textField1.textAlignment = .center
        textField2.textAlignment = .center
        
    }
    
    // pick photo from gallery
    @IBAction func pickAnImg(_ sender: Any) {
        ImagePickerManager().presentPhotoFromCameraOrLibrary(self, .photoLibrary){ image in
            self.myImageViewer.image = image
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    // pick Camera photo
    @IBAction func pickCamera(_ sender: Any) {
        ImagePickerManager().presentPhotoFromCameraOrLibrary(self, .camera){ image in
            self.myImageViewer.image = image
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    @objc func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // show keyboard be used when editing text.
    @objc func keyboardWillShow(_ notification:Notification) {
        //        print("shifting KEYBOARD NOW : \(shiftOnlyOnce)\n")
        if(shiftOnlyOnce){
            if textField2.isFirstResponder{
                view.frame.origin.y = -getKeyboardHeight(notification)
                shiftOnlyOnce = false
            }
        }
        
    }
    // hide keyboard and return to original state
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y =  0 //getKeyboardHeight(notification)
        shiftOnlyOnce = true
    }
    
    // get keyboard height to be used when editing text.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMeme() -> UIImage {
        let memedImage:UIImage = generateMemedImage()
        return memedImage
    }
    
    
    // save meme image to be used afterwards
    func saveImage(imgName: String, memedImage: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(imgName)
        guard let data = memedImage.jpegData(compressionQuality: 1) else { return }
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        do {
            try data.write(to: fileURL)
            UIImageWriteToSavedPhotosAlbum(memedImage, self, nil, nil)
            print("saved the meme image to : \(fileURL)")
            let meme = Meme(topText: textField1.text! , bottomText: textField2.text!, originalImage: myImageViewer.image! , memedImage: memedImage)
            //add this meme to the memes array in the app delegate
            print("meme added with topText: \(textField1.text!), and bottomText: \(textField2.text!)")
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            print((UIApplication.shared.delegate as! AppDelegate).memes)
            
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    // load meme image from memory
    func loadImgURL(fileName: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            return URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        }
        
        return nil
    }
    
    
    // generate a picture with text on it.
    func generateMemedImage() -> UIImage {
        myToolBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        myToolBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        return memedImage
    }
    
    
}

