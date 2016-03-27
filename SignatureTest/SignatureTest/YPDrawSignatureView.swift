//
//  YPDrawSignatureView.swift
//  Draw a signature into an UIView
//
//  Created by Geert-Jan Nilsen on 06/11/14.
//  Copyright (c) 2014 Yuppielabel.com All rights reserved.
//

import UIKit

public struct StrokeSegment {
	public var path: UIBezierPath!
	public var color: UIColor!
	init(path: UIBezierPath, color: UIColor, lineWidth: CGFloat) {
		self.path = path
		self.color = color
		self.path.lineWidth = lineWidth
	}
}


public class YPDrawSignatureView: UIView {
	
	// MARK: - Public properties
	public var lineWidth: CGFloat = 2.0
	public var strokeColor: UIColor = UIColor.blackColor()
	public var signatureBackgroundColor: UIColor = UIColor.whiteColor()
	
	// MARK: - Private properties
	private var segments: [StrokeSegment] = []
	private var currentSegment: StrokeSegment?
	
	private var points = [CGPoint](count: 5, repeatedValue: CGPoint())
	private var pointCounter = 0
	
	// MARK: - Init
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.backgroundColor = self.signatureBackgroundColor
	}
	
	// MARK: - Draw
	override public func drawRect(rect: CGRect) {
		
		for oneSegment in segments {
			oneSegment.color.setStroke()
			oneSegment.path.stroke()
		}
	}
	
	// MARK: - Touch handling functions
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let firstTouch = touches.first{
			let touchPoint = firstTouch.locationInView(self)
			self.pointCounter = 0
			self.points[0] = touchPoint
			
			self.currentSegment = StrokeSegment(path: UIBezierPath(), color: self.strokeColor, lineWidth:self.lineWidth)
			segments.append(self.currentSegment!)
		}
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let firstTouch = touches.first{
			let touchPoint = firstTouch.locationInView(self)
	  self.pointCounter += 1
			self.points[self.pointCounter] = touchPoint
			if (self.pointCounter == 4) {
				self.points[3] = CGPointMake((self.points[2].x + self.points[4].x)/2.0, (self.points[2].y + self.points[4].y)/2.0)
				self.segments.last!.path.moveToPoint(self.points[0])
				self.segments.last!.path.addCurveToPoint(self.points[3], controlPoint1:self.points[1], controlPoint2:self.points[2])
				
				self.setNeedsDisplay()
				self.points[0] = self.points[3]
				self.points[1] = self.points[4]
				self.pointCounter = 1
			}
			
			self.setNeedsDisplay()
		}
	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if self.pointCounter == 0{
			let touchPoint = self.points[0]
			self.segments.last!.path.moveToPoint(CGPointMake(touchPoint.x-1.0,touchPoint.y))
			self.segments.last!.path.addLineToPoint(CGPointMake(touchPoint.x+1.0,touchPoint.y))
			self.setNeedsDisplay()
		} else {
			self.pointCounter = 0
		}
	}
	
	// MARK: - Helpers
	
	// MARK: Clear the Signature View
	public func clearSignature() {
		self.segments.removeAll()
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