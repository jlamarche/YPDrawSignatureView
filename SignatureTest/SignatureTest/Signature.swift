//
//  Signature.swift
//  SignatureTest
//
//  Created by Jeff LaMarche on 3/27/16.
//  Copyright © 2016 Jeff LaMarche. All rights reserved.

/** This class stores a signature captured in a draw signature view, but it stores the signature independent of the size or aspect ratio of the view it was drawn into

*/
import CoreGraphics
	import UIKit

public extension CGPoint {
	static func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
		return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
	}
	static func controlPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
		var controlPoint = midPointForPoints(p1, p2: p2)
		let diffY = abs(p2.y - controlPoint.y)
		if (p1.y < p2.y) {
			controlPoint.y += diffY
		} else if (p1.y > p2.y) {
			controlPoint.y -= diffY
		}
		return controlPoint
	}
}

public struct StrokeSegment {
	public var path: UIBezierPath!
	public var color: UIColor!
	init(path: UIBezierPath, color: UIColor, lineWidth: CGFloat) {
		self.path = path
		self.color = color
		self.path.lineWidth = lineWidth
	}
}



public struct SignatureSegment {
	public var points = [CGPoint]()
	public var lineWidth:CGFloat = 0.0
	private var minX: CGFloat = 0.5
	private var minY: CGFloat = 0.5
	private var maxX: CGFloat = 0.5
	private var maxY: CGFloat = 0.5
	
	public var color: UIColor!
	init(color: UIColor, lineWidth: CGFloat) {
		self.points = [CGPoint]()
		self.color = color
		self.lineWidth = lineWidth
	}

	/** Returns the signature's data converted for a new view size
	@param viewSize The size of the view the signature is to be drawn in
	@return array of array of CGPoints representing each of the pen strokes making up this signature, converted to the specified size
	*/
	func pointsForViewSized(viewSize: CGSize) -> [CGPoint]{
		let viewAspectRatio = viewSize.width / viewSize.height
		//let signatureAspectRatio = (maxX - minX) / (maxY - minY)
		
		// TODO: Check signature aspect ratio and make sure that it can be fully drawn in the specified view without loss
		var convertedPoints = [CGPoint]()
		
		for point in self.points {
			
			if (viewAspectRatio > 1.0) { // landscape
				let padding = (1.0 - ((viewSize.height / viewSize.width))) / 2.0
				
				let convertedPoint = CGPointMake(point.x * viewSize.width, (point.y - padding) * viewSize.height )
				convertedPoints.append(convertedPoint)
				
			} else if (viewAspectRatio < 1.0) { // portrait
				let padding = (1.0 - ((viewSize.width / viewSize.height))) / 2.0
				let convertedPoint = CGPointMake((point.x - padding) * viewSize.width, point.y * viewSize.height )
				convertedPoints.append(convertedPoint)
				
			} else { //square, no conversion necessary, just multiply clamp value by size
				convertedPoints.append(CGPointMake(point.x * viewSize.width, point.y * viewSize.height))
			}
		}
		
		return convertedPoints
	}
	
	
}

public class Signature {
	
	private var segments = [SignatureSegment]()
	private var currentSegment: SignatureSegment?
	
	init() {
	}
	
	
	func startNewSegment(color: UIColor, lineWidth: CGFloat) {
		segments.append(SignatureSegment(color: color, lineWidth: lineWidth))
		currentSegment = segments.last
	}
	
	func updateMinMax(point:CGPoint) {
		if (point.x > currentSegment!.maxX) {
			currentSegment!.maxX = point.x
		} else if (point.x < currentSegment!.minX) {
			currentSegment!.minX = point.x
		}
		if (point.y > currentSegment!.maxY) {
			currentSegment!.maxY = point.y
		} else if (point.y < currentSegment!.minY) {
			currentSegment!.minY = point.y
		}
		
		// Even though view can capture outside its bounds, we'll clamp to what was drawn inside the view
		currentSegment!.maxX = min(currentSegment!.maxX, 1.0)
		currentSegment!.maxY = min(currentSegment!.maxY, 1.0)
		currentSegment!.minX = max(currentSegment!.minX, 0.0)
		currentSegment!.minY = max(currentSegment!.minY, 0.0)
		
	}
	/** returns UIBezierPaths to draw the signature in a view of a given size. Optionally, it will smooth the stroke based on a smooth step, or draw the signature line. 
		@param size	The size of the view in paths will be drawn in
		@param smoothed Whether to smooth the signature
		@param smoothStep How aggressively to smooth the signature. The higher the number, the smoother the signature will appear, but with increasing loss lof fidelty
		@param includeLine Whether to draw a horizontal black line below the signature
	
		@returns Array of SignatureSegments desribing the signature
	*/
	func pathsForViewOfSize(size:CGSize, smoothed:Bool = true, smoothStep: Int = 1, includeLine:Bool = true, linePosition:CGFloat = 0.75) -> [StrokeSegment] {
		var ret = [StrokeSegment]()
		
		if (includeLine) {
			
			let path = UIBezierPath()
			var padding:CGFloat = 0.0
			let aspectRatio = size.width / size.height
			
			if (aspectRatio > 1.0) {
				padding = (1.0 - ((size.height / size.width))) / 2.0
			}

			path.moveToPoint(CGPointMake(0.05 * size.width, (linePosition - padding) * size.height))
			path.addLineToPoint(CGPointMake(0.95 * size.width, (linePosition - padding) * size.height))
			ret.append(StrokeSegment(path: path, color: UIColor.blackColor(), lineWidth: 1.5))
		}
		
		for oneSegment in segments {
	
			let points = oneSegment.pointsForViewSized(size)
			
			if (points.count == 0) {
				continue
			}
			
			let path = UIBezierPath()
			path.moveToPoint(points[0])
			
			// less than 4 points, smoothing is impossible
			if (points.count < 4 || !smoothed) { // also use this conditional if you don't want smoothing
				for point in points {
					path.addLineToPoint(point)
				}
			} else {
				var p1 = points[0]
				
				for i in 1.stride(to: (points.count - 1), by: smoothStep) {
					let p2 = points[i]
					let midPoint = CGPoint.midPointForPoints(p1, p2: p2)
					if (i == 1) {
						path.addLineToPoint(midPoint)
					} else {
						path.addQuadCurveToPoint(midPoint, controlPoint: p1)
					}
					
					p1 = p2
				}
				
				
			}
			ret.append(StrokeSegment(path: path, color: oneSegment.color, lineWidth: oneSegment.lineWidth))
		}

		
		return ret
	}
	func addPoint(point:CGPoint, sourceViewSize:CGSize) {
		
		
		if (sourceViewSize.width == 0 || sourceViewSize.height == 0) {
			return
		}
		// If caller forgot to start a segment, we'll do it
		if (segments.count == 0) {
			startNewSegment(UIColor.blackColor(), lineWidth:2.0)
		}
		
		let aspectRatio = sourceViewSize.width / sourceViewSize.height
		
		// If aspect ratio is not 1.0 (square), then we need to pad the signature into our square 0.0 - 1.0 coordinate space
		if (aspectRatio > 1.0) { // Landscape
			let padding = (1.0 - ((sourceViewSize.height / sourceViewSize.width))) / 2.0
			let convertedPoint = CGPointMake(point.x / sourceViewSize.width, (point.y / sourceViewSize.height) + padding)
			
			updateMinMax(convertedPoint)
			currentSegment!.points.append(convertedPoint)
		} else if (aspectRatio < 1.0) { // portrait
			let padding = (1.0 - ((sourceViewSize.width / sourceViewSize.height))) / 2.0
			let convertedPoint = CGPointMake((point.x / sourceViewSize.width) + padding, point.y / sourceViewSize.height)
			updateMinMax(convertedPoint)
			currentSegment!.points.append(convertedPoint)
		} else { // square
			currentSegment!.points.append(CGPointMake(point.x / sourceViewSize.width, point.y / sourceViewSize.height))
		}
		
		segments.removeLast()
		segments.append(currentSegment!)
	}
	
	func clearSignature() {
		segments.removeAll()
	}
	
	
}
