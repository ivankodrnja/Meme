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
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName: -3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // define default values for the text fields
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.delegate = self
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.delegate = self
        
        // disable share button by default.
        shareButton.enabled = false
        
        
        // disable cancel button by default. It will be enabled in saveMeme() and viewWillAppear
        cancelButton.enabled = false
    }

    
    override func viewWillAppear(animated: Bool) {
        // share button will be enabled only if an image exists
        if((imageView.image) != nil){
            shareButton.enabled = true
        }
        
        // enable camera button if camera exists
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardWillShowNotifications()
        self.subscribeToKeyboardWillHideNotifications()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // enable cancel button if there is at least one meme
        if(memes.count > 0){
            cancelButton.enabled = true
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        // self.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardWillShowNotificitaions()
        self.unsubscribeToKeyboardWillHideNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        if bottomTextField.isFirstResponder(){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardWillShowNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardWillShowNotificitaions(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    func keyboardWillHide(notification: NSNotification){
        
        if bottomTextField.isFirstResponder(){
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardWillHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardWillHideNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func shareAction(sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            if (!success) {return} // return if the user taps cancel
            
            self.saveMeme()
            
            // present SentMemes View
            //self.performSegueWithIdentifier("showSentMemes", sender: self)
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        bottomToolbar.hidden = true
        topToolbar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        bottomToolbar.hidden = false
        topToolbar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(){
        // create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        // add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        // enable cancel button since there is now at least one saved meme. When ran for the first time, the it couldn't have been enabled in the viewWillAppear
        if (appDelegate.memes.count > 0 && cancelButton.enabled == false){
            cancelButton.enabled = true
        }
    }
    
}

