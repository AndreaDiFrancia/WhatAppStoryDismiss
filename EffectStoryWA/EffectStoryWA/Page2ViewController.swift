//
//  Copyright © 2018 Andrea Di Francia. All rights reserved.
//

import UIKit

class Page2ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView?
   
    weak var mask: CAShapeLayer?
    var initialCenter = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mask = CAShapeLayer()
        mask.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        mask.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        image?.layer.mask = mask
        self.mask = mask
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update the mask for the image view for the size of the view (which was unknown at `viewDidLoad`, but is known here)
        
        if mask != nil {
            updatePath(percent: 0)
        }
    }

    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        var translation = gestureRecognizer.translation(in: piece.superview)
        
        if gestureRecognizer.state == .began {
            // Save the view's original position.
            
             self.initialCenter = piece.center
        }
        
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state == .changed {
            
            translation = gestureRecognizer.translation(in: piece.superview)
            
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            
            updatePath(percent: newCenter.y)
            print(newCenter.y)
        }
        
        if gestureRecognizer.state == .ended {
            dismiss(animated: true) {
                self.image?.layer.mask = nil
            }
        }
    }

    private func updatePath(percent: CGFloat) {
        let center = CGPoint(x: (image?.bounds.midX)!, y: image!.bounds.midY)
        let endRadius = min((image?.bounds.width)!, (image?.bounds.height)!) * 0.4  // stop radius is 40% of smallest dimension
        let startRadius = hypot((image?.bounds.width)!, (image?.bounds.height)!) * 0.6  // start radius is the distance from the center to the corner of the image view
        let radius = startRadius + (endRadius - startRadius) * percent/1000                // given percent done, what is the radius
        
        mask?.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
    }
}
