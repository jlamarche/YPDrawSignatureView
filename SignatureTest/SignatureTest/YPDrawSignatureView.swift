//
//  YPDrawSignatureView.swift
//  Draw a signature into an UIView
//
//  Created by Geert-Jan Nilsen on 06/11/14.
//  Copyright (c) 2014 Yuppielabel.com All rights reserved.
//

import UIKit

public class YPDrawSignatureView: UIView {
	
	// MARK: - Public properties
	public var lineWidth: CGFloat = 2.0
	public var strokeColor: UIColor = UIColor.blackColor()
	public var signatureBackgroundColor: UIColor = UIColor.whiteColor()
	
	// MARK: - Private properties
	
	private var points = [CGPoint](count: 5, repeatedValue: CGPoint())
	private var pointCounter = 0
	
	private var signature = Signature()
	
	// MARK: - Init
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.backgroundColor = self.signatureBackgroundColor
	}
	
	// MARK: - Draw
	override public func drawRect(rect: CGRect) {
		
		for oneSegment in signature.pathsForViewOfSize(self.frame.size) {
			oneSegment.color.setStroke()
			oneSegment.path.stroke()
		}
	}
	
	
	// MARK: - Touch handling functions
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		signature.startNewSegment(self.strokeColor, lineWidth:self.lineWidth)
		signature.addPoint(touches.first!.locationInView(self), sourceViewSize: self.frame.size)
		self.setNeedsDisplay()
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		signature.addPoint(touches.first!.locationInView(self), sourceViewSize: self.frame.size)
		self.setNeedsDisplay()
	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		signature.addPoint(touches.first!.locationInView(self), sourceViewSize: self.frame.size)
		self.setNeedsDisplay()
	}
	
	// MARK: - Helpers
	
	// MARK: Clear the Signature View
	public func clearSignature() {
		self.signature.clearSignature()
		self.setNeedsDisplay()
	}
	
	// MARK: Save the Signature as an UIImage
	public func getSignature() ->UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width, self.bounds.size.height), false, 8.0)
		//UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height))
		self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let signature: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return signature
	}
	
	
}