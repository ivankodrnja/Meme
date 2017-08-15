//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Ivan Kodrnja on 03/05/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit

// UIImagePickerControllerDelegate won't work without UINavigationControllerDelegate
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memes: [Meme]!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName: -3
    ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // define default values for the text fields
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.delegate = self
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
        
        // disable share button by default.
        shareButton.isEnabled = false
        
        
        // disable cancel button by default. It will be enabled in saveMeme() and viewWillAppear
        cancelButton.isEnabled = false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        // share button will be enabled only if an image exists
        if((imageView.image) != nil){
            shareButton.isEnabled = true
        }
        
        // enable camera button if camera exists
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)

        self.subscribeToKeyboardWillShowNotifications()
        self.subscribeToKeyboardWillHideNotifications()

        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // enable cancel button if there is at least one meme
        if(memes.count > 0){
            cancelButton.isEnabled = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // self.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardWillShowNotificitaions()
        self.unsubscribeToKeyboardWillHideNotifications()

    }
    
    

    func keyboardWillShow(_ notification: Notification){
        
        if bottomTextField.isFirstResponder{
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardWillShowNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func unsubscribeFromKeyboardWillShowNotificitaions(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    
    func keyboardWillHide(_ notification: Notification){
        
        if bottomTextField.isFirstResponder{
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardWillHideNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardWillHideNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func shareAction(_ sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            if (!success) {return} // return if the user taps cancel
            
            self.saveMeme()
            
            // present SentMemes View
            //self.performSegueWithIdentifier("showSentMemes", sender: self)
            
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        bottomToolbar.isHidden = true
        topToolbar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        bottomToolbar.isHidden = false
        topToolbar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme(){
        // create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        // add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        // enable cancel button since there is now at least one saved meme. When ran for the first time, the it couldn't have been enabled in the viewWillAppear
        if (appDelegate.memes.count > 0 && cancelButton.isEnabled == false){
            cancelButton.isEnabled = true
        }
    }
    
}

