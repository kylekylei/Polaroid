//
//  ViewController.swift
//  Polaroid
//
//  Created by Kyle Lei on 2021/9/8.
//

import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    
    @IBOutlet var rationButton: UIButton!
    @IBOutlet var filmView: UIView!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var shotButton: UIButton!
    @IBOutlet var textField: UITextField!{
        didSet{
            textField.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet var textLable: UILabel! {
        didSet {
            textLable.frame = CGRect(x: photoMargin + 5 , y: 480, width: photoView.frame.width, height: 100)
        }
    }

    let filmYOrint: CGFloat = 120
    let filmOffset: CGFloat = 500
    
    let mainWidth = UIScreen.main.bounds.width
    let filmXMargin: CGFloat = 30
    let photoMargin: CGFloat = 20
    
    var ratio = ""
    var photoWidth: CGFloat = 0
    var photoHeight: CGFloat = 0
    
    func setPhotoWidth() {
        photoWidth = mainWidth - (filmXMargin + photoMargin) * 2
    }
        
    
    func photoRatio(x: Int, y: Int) {
        ratio = "\(x) : \(y)"
        photoHeight = photoWidth / CGFloat(x) * CGFloat(y)
    }
    
    @objc func filter() {
        let ciImage = CIImage(image: photoView.image!)
        let filter = CIFilter.colorMonochrome()
        filter.inputImage = ciImage
        filter.intensity = 0.6
        filter.color = CIColor.gray
        
        if let outputCIImage = filter.outputImage{
            let filterImage = UIImage(ciImage: outputCIImage)
            photoView.image = filterImage
        }
        
        let animator = UIViewPropertyAnimator(duration: 2, curve: .easeOut) { [self] in
            photoView.layer.opacity = 1
            textLable.layer.opacity = 1
        }
        animator.startAnimation()
    }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //filmView
        let filmWidth = mainWidth - filmXMargin * 2
        let filmHeight = (mainWidth - (filmXMargin + photoMargin) * 2) / 9 * 16 + photoMargin * 2
        print(filmHeight)
                 
        filmView.frame = CGRect(x: filmXMargin, y: filmYOrint - filmOffset, width: filmWidth, height: filmHeight)
        filmView.backgroundColor = UIColor.white
        filmView.layer.shadowColor = UIColor.darkGray.cgColor
        filmView.layer.shadowRadius = 8
        filmView.layer.shadowOffset = CGSize(width: 0, height: 16)
        filmView.layer.shadowOpacity = 0.38
        filmView.isHidden = true
        
        textLable.layer.opacity = 0
        filmView.addSubview(textLable)
             
         
        //photoView
        setPhotoWidth()
        //photoView.layer.zPosition = 1
        photoView.layer.borderColor = UIColor.darkGray.cgColor
        photoView.layer.borderWidth = 2
        
        photoRatio(x: 3, y: 4)
        photoView.frame = CGRect(x: filmXMargin + photoMargin, y: filmYOrint + photoMargin, width: photoWidth, height: photoHeight)
        
       
        
    }
    
    @IBAction func changeRatioText(_ sender: UIButton) {
        
        
        let title = sender.currentTitle
        
        switch title {
        case "1 : 1": photoRatio(x: 3, y: 4)
        case "9 : 16": photoRatio(x: 1, y: 1)
        default: photoRatio(x: 9, y: 16)
        }
        sender.setTitle(ratio, for: .normal)
               
        photoView.frame = CGRect(x: filmXMargin + photoMargin, y: filmYOrint + photoMargin, width: photoWidth, height: photoHeight)
    }
    
 
    @IBAction func shotButton(_ sender: Any) {
        filmView.isHidden = false
        photoView.layer.borderWidth = 0
        rationButton.isHidden = true
        photoView.frame.origin.y = filmYOrint + photoMargin
        shotButton.isHidden = true
        
        let photoBgView = UIView()
        photoBgView.frame = CGRect(x: photoMargin, y: photoMargin, width: photoView.bounds.width, height: photoView.bounds.height)
        photoBgView.backgroundColor = UIColor.black
        
        filmView.addSubview(photoBgView)
        
        textLable.text = textField.text
        textField.isHidden = true
        
        
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeOut) { [self] in
            self.filmView.frame = self.filmView.frame.offsetBy(dx: 0, dy: filmOffset)
        }
        animator.startAnimation()
        
        //
        photoView.layer.opacity = 0
        
        perform(#selector(filter), with: nil, afterDelay: 0.5)
        
        
    }
}

