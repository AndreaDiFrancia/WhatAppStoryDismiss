//
//  Copyright © 2018 Andrea Di Francia. All rights reserved.
//

import UIKit

class Page2ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView? {
        willSet {
            let mask = CAShapeLayer()
            
            newValue?.layer.mask = mask
        }
    }
    
    private var initialCenter = CGPoint.zero
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update the mask for the image view for the size of the view (which was unknown at `viewDidLoad`, but is known here)
        updatePath(percent: 0.0)
    }
    
    deinit {
        print("deinit")
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else {
            return
        }
        
        let state = gestureRecognizer.state
        
        if state == .began {
            // Save the view's original position.
            initialCenter = gestureView.center
            
        } else if state == .changed {
            // Get the changes in the X and Y directions relative to
            // the superview's coordinate space.
            // Update the position for the .began, .changed, and .ended states
            let newCenterY = gestureRecognizer.translation(in: gestureView.superview).y + initialCenter.y
            
            updatePath(percent: newCenterY)
            
        } else if gestureRecognizer.state == .ended {
            dismiss(animated: true) {
                // NOP
            }
        }
    }
    
    private func updatePath(percent: CGFloat) {
        guard let image = image else {
            return
        }
        
        let center = image.center
        
        // stop radius is 40% of smallest dimension
        let endRadius = min(image.bounds.width, image.bounds.height) * 0.4
        
        // start radius is the distance from the center to the corner of the image view
        let startRadius = hypot(image.bounds.width, image.bounds.height) * 0.6
        
        // given percent done, what is the radius
        let radius = startRadius + (endRadius - startRadius) * (percent / 1000)
        
        let mask = image.layer.mask as? CAShapeLayer
        
        mask?.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0.0,
            endAngle: .pi * 2,
            clockwise: true
            ).cgPath
    }
}
