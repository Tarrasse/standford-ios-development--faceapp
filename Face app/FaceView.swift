//
//  FaceView.swift
//  Face app
//
//  Created by Mahmoud El-Tarrasse on 7/31/17.
//  Copyright © 2017 Mahmoud El-Tarrasse. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var mouthCurve:Double = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scale: CGFloat = 0.90{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var eyesAreOpen:Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var color: UIColor = UIColor.blue{
        didSet{
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var lineWidth: CGFloat = 5.0{
        didSet{
            setNeedsDisplay()
        }
    }

    
    func changeScale(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var skullRadius:CGFloat {
        return min(bounds.size.width,bounds.size.height)/2 * scale
    }
    
    private var skullCenter:CGPoint {
        return CGPoint(x: bounds.midX, y:bounds.midY)
    }
    
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye{
        case left
        case right
    }
    
    private func getEyeCenter(eye: Eye)->CGPoint{
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .left:
            eyeCenter.x -= eyeOffset
        case .right:
            eyeCenter.x += eyeOffset
            
        }
        return eyeCenter
    }
    
    private func pathForCircleCenteredAtPoint(midPodint: CGPoint,withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPodint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0 * Double.pi),
            clockwise: false)
        
        path.lineWidth = lineWidth
        return path
    }
    
    
    private func 	pathForEye(eye: Eye) -> UIBezierPath{
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        if eyesAreOpen{
            return pathForCircleCenteredAtPoint(midPodint: eyeCenter, withRadius: eyeRadius)
        }else{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForMouth()->UIBezierPath{
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2,
                               y: skullCenter.y + mouthOffset,
                               width: mouthWidth,
                               height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurve, 1)))  * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)

        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path

    }
    
    override func draw(_ rect: CGRect){
        color.set()
        pathForCircleCenteredAtPoint(midPodint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .left).stroke()
        pathForEye(eye: .right).stroke()
        pathForMouth().stroke()

    }
    


}














