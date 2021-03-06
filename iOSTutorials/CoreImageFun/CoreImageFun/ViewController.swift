//
//  ViewController.swift
//  CoreImageFun
//
//  Created by 葛佳佳 on 2017/2/22.
//  Copyright © 2017年 葛佳佳. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountSlider: UISlider!
    
    var context: CIContext!
    var filter: CIFilter!
    var beginImage: CIImage!
    var orientation: UIImageOrientation = .up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.logAllFilters()
        
        let fileURL = Bundle.main.url(forResource: "image", withExtension: "png")
        
        beginImage = CIImage.init(contentsOf: fileURL!)
        
        filter = CIFilter.init(name: "CISepiaTone")
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        let outputImage = filter.outputImage
//        let newImage = UIImage.init(ciImage: (filter?.outputImage)!)
//        self.imageView.image = newImage
        
        context = CIContext.init(options: nil)
        
        let cgimg = context.createCGImage(outputImage!, from: (outputImage?.extent)!)
        
        let newImage = UIImage.init(cgImage: cgimg!)
        self.imageView.image = newImage
        
    }

    func logAllFilters() {
        let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        print(properties)
        
        for filterName in properties {
            let fltr = CIFilter(name:filterName as String)
            print(fltr!.attributes)
        }
    }
    
    func oldPhoto(img: CIImage, withAmount intensity: Float) -> CIImage {
        // 1
        let sepia = CIFilter(name:"CISepiaTone")
        sepia?.setValue(img, forKey:kCIInputImageKey)
        sepia?.setValue(intensity, forKey:"inputIntensity")
        
        // 2
        let random = CIFilter(name:"CIRandomGenerator")
        
        // 3
        let lighten = CIFilter(name:"CIColorControls")
        lighten?.setValue(random?.outputImage, forKey:kCIInputImageKey)
        lighten?.setValue(1 - intensity, forKey:"inputBrightness")
        lighten?.setValue(0, forKey:"inputSaturation")
        
        // 4
        let croppedImage = lighten?.outputImage?.cropping(to: beginImage.extent)
        
        // 5
        let composite = CIFilter(name:"CIHardLightBlendMode")
        composite?.setValue(sepia?.outputImage, forKey:kCIInputImageKey)
        composite?.setValue(croppedImage, forKey:kCIInputBackgroundImageKey)
        
        // 6
        let vignette = CIFilter(name:"CIVignette")
        vignette?.setValue(composite?.outputImage, forKey:kCIInputImageKey)
        vignette?.setValue(intensity * 2, forKey:"inputIntensity")
        vignette?.setValue(intensity * 30, forKey:"inputRadius")
        
        // 7
        return vignette!.outputImage!
    }
    
    @IBAction func amountSliderValueChanged(_ sender: UISlider) {
        let sliderValue = sender.value
        filter.setValue(sliderValue, forKey: kCIInputIntensityKey)
        let outputImage = self.oldPhoto(img: beginImage, withAmount: sliderValue)
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        
        let newImage = UIImage(cgImage: cgimg!, scale:1, orientation:orientation)
        self.imageView.image = newImage
        
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        // 1
        let imageToSave = filter.outputImage
        
        // 2
        let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])
        
        // 3
        let cgimg = softwareContext.createCGImage(imageToSave!, from:imageToSave!.extent)
        
        // 4
        let library = ALAssetsLibrary()
        library.writeImage(toSavedPhotosAlbum: cgimg,
                                             metadata:imageToSave!.properties,
                                             completionBlock:nil)
    }
    
    @IBAction func loadPhoto(_ sender: UIButton) {
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.present(pickerC, animated: true) { 
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        print(info)
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        orientation = gotImage.imageOrientation
        
        beginImage = CIImage(image:gotImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        self.amountSliderValueChanged(amountSlider)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

