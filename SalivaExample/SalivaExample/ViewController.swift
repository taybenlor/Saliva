//
//  ViewController.swift
//  SalivaExample
//
//  Created by Ben Taylor on 24/12/2014.
//  Copyright (c) 2014 Ben Taylor. All rights reserved.
//

import UIKit
import Saliva

class ViewController: UIViewController {

	@IBOutlet weak var greenRectangle: UIView!
	
	var touchLocation: CGPoint = CGPoint(x: -200, y: -200)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		bind(from: { self.touchLocation }, to: { self.greenRectangle.center = $0 })
	}
	
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		if let touch: UITouch = touches.anyObject() as UITouch? {
			self.touchLocation = touch.locationInView(self.view)
		}
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		if let touch: UITouch = touches.anyObject() as UITouch? {
			self.touchLocation = touch.locationInView(self.view)
		}
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		self.touchLocation = CGPoint(x: -200, y: -200)
	}
	
	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
		self.touchLocation = CGPoint(x: -200, y: -200)
	}

}

