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
//    var memedImage: UIImage
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth:  -3.5
    ]
    
    @objc func shareMeme(sender: UIBarButtonItem){
        print("| MEME | SAVED & SHARED !")
        let  memedImage: UIImage  = save()
        let myShare = "My meme photo!"
        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [(memedImage), myShare], applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
        
        
        //        let imageURLs: [URL] = loadImgURL(fileName: "meme")
        //        let activityViewController = UIActivityViewController(activityItems: imageURLs, applicationActivities: nil)
        //        self.present(activityViewController, animated: true, completion: nil)
    }
    func configureNav(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up") , style: .done, target: self, action: #selector(shareMeme(sender:)))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        configureNav()
        // Do any additional setup after loading the view.
        textField1.defaultTextAttributes = memeTextAttributes
        textField2.defaultTextAttributes = memeTextAttributes
        textField1.textAlignment = .center
        textField2.textAlignment = .center
        
    }
    
    @IBAction func pickAnImg(_ sender: Any) {
        ImagePickerManager().pickImg2(self){ image in
            self.myImageViewer.image = image
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
    }
    
    @IBAction func pickCamera(_ sender: Any) {
        ImagePickerManager().pickCamera2(self){ image in
            //here is the image
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
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //        print("shifting KEYBOARD NOW : \(shiftOnlyOnce)\n")
        if(shiftOnlyOnce){
            view.frame.origin.y -= getKeyboardHeight(notification)
            shiftOnlyOnce = false
        }
        
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y =  0 //getKeyboardHeight(notification)
        shiftOnlyOnce = true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
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
    
    func save() -> UIImage {
        let memedImage:UIImage = generateMemedImage()
        saveImage(imgName: "meme", uiimage: memedImage)
        return memedImage
    }
    
    func saveImage(imgName: String, uiimage: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imgName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = uiimage.jpegData(compressionQuality: 1) else { return }
        
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
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    
    //    func loadImageFromDiskWith(fileName: String) -> UIImage? {
    //
    //      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    //
    //        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    //        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    //
    //        if let dirPath = paths.first {
    //            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
    //            let image = UIImage(contentsOfFile: imageUrl.path)
    //            return image
    //
    //        }
    //
    //        return nil
    //    }
    
    func loadImgURL(fileName: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            return URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        }
        
        return nil
    }
    
    
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

