//
//  ViewController.swift
//  Face app
//
//  Created by Mahmoud El-Tarrasse on 7/31/17.
//  Copyright © 2017 Mahmoud El-Tarrasse. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var exepression = FacialExpression(eyes: .Open, mouth: .Frown){
        didSet{
            updateUi()
        }
    }
    
    @IBOutlet var faceView: FaceView!{
        didSet{
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale)))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHapiness))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            let sadderSwipeGestureRecongizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHapiness))
            sadderSwipeGestureRecongizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecongizer)
            updateUi()
        }
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.Frown : -1.0,
    .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0 ]
    
    private func updateUi(){
        switch exepression.eyes {
        case .Open: faceView.eyesAreOpen = true
        case .Closed : faceView.eyesAreOpen = false
        default:
            faceView.eyesAreOpen = false
        }
        faceView.mouthCurve = mouthCurvatures[exepression.mouth] ?? 0.0
    }
    @IBAction func toggleEye(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended{
            switch exepression.eyes {
            case .Open:
                exepression.eyes = .Closed
            case .Closed:
                exepression.eyes = .Open
            default:
                break
            }
        }
    }
    func increaseHapiness() {
        exepression.mouth = exepression.mouth.happierMouth()
    }
    func decreaseHapiness() {
        exepression.mouth = exepression.mouth.sadderMouth()
    }
}

