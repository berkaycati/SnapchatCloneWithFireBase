//
//  SnapShowViewController.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 24.10.2022.
//

import UIKit
import ImageSlideshow
import Kingfisher



class SnapShowViewController: UIViewController {

    var selectedSnap : Snap?
    var slideImageArray = [KingfisherSource]()
    
    
    @IBOutlet weak var timeLeftTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let snap = selectedSnap {
            for image in snap.imageURLArray {
                slideImageArray.append(KingfisherSource(urlString: image)!)
            }
            timeLeftTextLabel.text = "Time Left: \(snap.timeLeft) hours"
        }
        
        let imageSlideSnow = ImageSlideshow(frame: CGRect(x: 15, y: 60, width: self.view.frame.width * 0.90, height: self.view.frame.height * 0.80))
        imageSlideSnow.backgroundColor = UIColor.darkGray
        
        let indicatorPage = UIPageControl()
        indicatorPage.currentPageIndicatorTintColor = UIColor.black
        indicatorPage.pageIndicatorTintColor = UIColor.white
        imageSlideSnow.pageIndicator = indicatorPage
        imageSlideSnow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlideSnow.setImageInputs(slideImageArray)
        self.view.bringSubviewToFront(timeLeftTextLabel)
        self.view.addSubview(imageSlideSnow)
        
        

        
    }
    

}
