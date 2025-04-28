//
//  DrawingModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 26/04/25.
//

import Foundation
import SwiftUI
import PencilKit


struct InterpolatedPointIntersected {
    let strokeIndex: Int
    let parametricValue: Int
    var touchedStrokesIndex: [Int] = []
}


func creationOfPathsInfoCut(intersectedPoints: IntersectedPoints, segments: [Segment], pathsInfo: [PathInfo]) -> [PathInfoCut] {
    
    var interpolatedPointsIntersected: [InterpolatedPointIntersected] = []
    
    
    for point in intersectedPoints.points {
        for segmentId in point.segmentId {
            
            let segmentIDActive = segmentId
            let segmentIDTouching = point.segmentId.filter { $0 != segmentIDActive }
            
            
            let indexActive = segments.firstIndex(where: { $0.id == segmentIDActive })
            let strokeIndexActive = segments[indexActive!].strokeIndex //carefull (note for me, not for the chat)
            let segmentPointActive = segments[indexActive!].points.last
            
            
            var strokesIndexTouched: [Int] = []
            for touchingSegmentId in segmentIDTouching {
                if let indexTouching = segments.firstIndex(where: { $0.id == touchingSegmentId }) {
                    let strokeIndexTouching = segments[indexTouching].strokeIndex
                    strokesIndexTouched.append(strokeIndexTouching)
                }
            }
            
            for pathInfo in pathsInfo {
                for parametricValue in 0..<(pathInfo.path.count-1) {
                    if pathInfo.path.interpolatedPoint(at: CGFloat(parametricValue)).location == segmentPointActive {
                        
                        interpolatedPointsIntersected.append(InterpolatedPointIntersected(strokeIndex: strokeIndexActive, parametricValue: parametricValue, touchedStrokesIndex: strokesIndexTouched))
                    }
                }
            }
        }
    }
    
    interpolatedPointsIntersected.sort {
        if $0.strokeIndex != $1.strokeIndex {
            return $0.strokeIndex < $1.strokeIndex
        } else {
            return $0.parametricValue < $1.parametricValue
        }
    }
    
    
    
    var pathsInfoCut: [PathInfoCut] = []
    
    for pathInfo in pathsInfo {
        let intersections = interpolatedPointsIntersected.filter { $0.strokeIndex == pathInfo.strokeIndex }
        
        if intersections.isEmpty {
            // No intersections: Add the whole path
            let fullSegment = PathInfoCut(
                path: pathInfo.path,
                strokeIndex: pathInfo.strokeIndex,
                pathCutIndex: 0,
                touchedStrokeIndex: [],
                isSampled: pathInfo.isSampled,
                //microorganism: pathInfo.microorganism,
                isFlamed: pathInfo.isFlamed,
                probabilityOfGrowth: nil,
                nextTouchedStrokeIndex: nil
            )
            pathsInfoCut.append(fullSegment)
            continue
        }
        
        var lastParametricValue = 0
        
        for (index, point) in intersections.enumerated() {
            let startParam = lastParametricValue
            let endParam = point.parametricValue
            
            if startParam < endParam {
                let cuttedPath = extractSubpath(from: pathInfo.path, start: CGFloat(startParam), end: CGFloat(endParam + 1))
                let touchedStrokes = interpolatedPointsIntersected
                    .filter { $0.strokeIndex == pathInfo.strokeIndex && $0.parametricValue >= startParam && $0.parametricValue <= endParam }
                    .flatMap { $0.touchedStrokesIndex }
                let cutSegment = PathInfoCut(
                    path: cuttedPath,
                    strokeIndex: pathInfo.strokeIndex,
                    pathCutIndex: index,
                    touchedStrokeIndex: touchedStrokes,
                    isSampled: pathInfo.isSampled,
                    //microorganism: pathInfo.microorganism,
                    isFlamed: pathInfo.isFlamed,
                    probabilityOfGrowth: nil,
                    nextTouchedStrokeIndex: nil
                )
                pathsInfoCut.append(cutSegment)
            }
            lastParametricValue = endParam
        }
        
        // Capture the last remaining part of the path
        if lastParametricValue < pathInfo.path.count - 1 {
            let cuttedPath = extractSubpath(from: pathInfo.path, start: CGFloat(lastParametricValue), end: CGFloat(pathInfo.path.count - 1))
            let touchedStrokes = interpolatedPointsIntersected
                .filter { $0.strokeIndex == pathInfo.strokeIndex && $0.parametricValue >= lastParametricValue && $0.parametricValue <= pathInfo.path.count - 1 }
                .flatMap { $0.touchedStrokesIndex }
            
            let cutSegment = PathInfoCut(
                path: cuttedPath,
                strokeIndex: pathInfo.strokeIndex,
                pathCutIndex: intersections.count,
                touchedStrokeIndex: touchedStrokes,
                isSampled: pathInfo.isSampled,
                //microorganism: pathInfo.microorganism,
                isFlamed: pathInfo.isFlamed,
                probabilityOfGrowth: nil,
                nextTouchedStrokeIndex: nil
            )
            pathsInfoCut.append(cutSegment)
        }
    }
    
    pathsInfoCut.sort {
        if $0.strokeIndex != $1.strokeIndex {
            return $0.strokeIndex < $1.strokeIndex
        } else {
            return $0.pathCutIndex < $1.pathCutIndex
        }
    }
    
    
    
    return pathsInfoCut
}

/// Extracts a subpath from a PKStrokePath between two parametric values.
func extractSubpath(from path: PKStrokePath, start: CGFloat, end: CGFloat) -> PKStrokePath {
    let sampledPoints = stride(from: start, to: end, by: 1).map { path.interpolatedPoint(at: $0) }
    return PKStrokePath(controlPoints: sampledPoints, creationDate: Date()) // Adjust as needed
}



func addDots(from path: PKStrokePath, interval: CGFloat, probabilityOfGrowth: Double, color: UIColor) -> [PKStroke] {
    var dotStrokes: [PKStroke] = []
    let interpolatedPoints = path.interpolatedPoints(by: .distance(interval))
    
    for point in interpolatedPoints {
        
        if Double.random(in: 0...1) > probabilityOfGrowth { continue }
        
        let strokePoint = PKStrokePoint(
            location: point.location,
            timeOffset: 0,
            size: CGSize(width: Int.random(in: 7...10), height: Int.random(in: 7...10)),
            opacity: 1,
            force: 1,
            azimuth: 0,
            altitude: 1
        )
        // Create a dot stroke
        let strokePath = PKStrokePath(controlPoints: [strokePoint], creationDate: Date())
        let stroke = PKStroke(ink: PKInk(.pen, color: color), path: strokePath)
        
        dotStrokes.append(stroke)
    }
    
    return dotStrokes
}


