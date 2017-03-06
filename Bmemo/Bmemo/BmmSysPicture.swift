//
//  BmmSysPicture.swift
//  Bmemo
//
//  Created by Ama on 06/03/2017.
//  Copyright © 2017 Ama. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias imageCB = ((_ image: UIImage) -> ())

class BmmSysPicture: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var vctrol: UIViewController?
    var imagecb: imageCB?
    
    
    func syspicture(ctrol: UIViewController, cb: @escaping imageCB) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        imagecb = cb
        
        let sysPic = UIImagePickerController()
        
        sysPic.mediaTypes = [kUTTypeImage as String]
        sysPic.sourceType = .photoLibrary
        sysPic.delegate = self
        sysPic.allowsEditing = true
        
        vctrol = ctrol
        ctrol.present(sysPic, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imagecb!(image)
        vctrol?.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vctrol?.dismiss(animated: true, completion: nil)
    }
}
