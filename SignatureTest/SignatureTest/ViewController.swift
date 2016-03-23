//
//  ViewController.swift
//  SignatureTest
//
//  Created by Geert-Jan Korsbø Nilsen on 19/12/15.
//  Copyright © 2015 Yuppielabel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// Connect this Outlet to the Signature View
	@IBOutlet weak var drawSignatureView: YPDrawSignatureView!
	@IBOutlet weak var blackSwatch: UIButton!
	@IBOutlet weak var blueSwatch: UIButton!
	@IBOutlet weak var redSwatch: UIButton!
	@IBOutlet weak var greenSwatch: UIButton!
	@IBOutlet weak var widthOne: UIButton!
	@IBOutlet weak var widthTwo: UIButton!
	@IBOutlet weak var widthThree: UIButton!
	@IBOutlet weak var widthFour: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	@IBAction func clearSignature(sender: UIButton) {
		self.drawSignatureView.clearSignature()
	}
	
	@IBAction func saveSignature(sender: UIButton) {
		let signatureImage = self.drawSignatureView.getSignature()
		
		UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)

		self.drawSignatureView.clearSignature()
	}
	
	@IBAction func setPenColor(sender: UIButton) {
		if (sender == blueSwatch) {
			drawSignatureView.strokeColor = UIColor(red: 0.058823529, green: 0.02745098, blue: 0.509803922, alpha: 1.0)
		} else if (sender == redSwatch) {
			drawSignatureView.strokeColor = UIColor(red: 0.71372549, green: 0.0, blue: 0.0, alpha: 1.0)
		} else if (sender == greenSwatch) {
			drawSignatureView.strokeColor = UIColor(red: 0.015686275, green: 0.482352941, blue: 0.090196078, alpha: 1.0)
		} else {
			drawSignatureView.strokeColor = UIColor.blackColor()
		}
		drawSignatureView.setNeedsDisplay()
		
	}
	
	@IBAction func setLineWidth(sender: UIButton) {
		if (sender == widthOne) {
			drawSignatureView.lineWidth = 1.0
		} else if (sender == widthTwo) {
			drawSignatureView.lineWidth = 2.0
		} else if (sender == widthThree) {
			drawSignatureView.lineWidth = 3.0
		} else if (sender == widthFour) {
			drawSignatureView.lineWidth = 4.0
		}
	}
}

