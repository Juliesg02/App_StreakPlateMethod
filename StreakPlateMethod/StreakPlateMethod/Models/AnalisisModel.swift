//
//  AnalisisModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 25/04/25.
//

import Foundation

struct Segment: Identifiable {
    let strokeIndex : Int
    let id: UUID
    let idNumber: Int
    let points : [CGPoint]
}

struct Point {
    let strokeIndex : Int
    let momentaryPointId : Int?
    var segmentId: [UUID]
    let location : CGPoint
    var upperPoint : [(Int, UUID)] //segment strokeindex segment id
    var lowerPoint : [(Int, UUID)]
    var centralPoint : [(Int, UUID)]
    var isSameYAxis : Bool = false
}

func creationOfEvents(segments: [Segment]) -> [Point] {
    var points: [Point] = []
    
    for segment in segments {
        
        //Creation of events
        for point in segment.points {
            let pointExist: Bool = points.contains { $0.location == point }
            if !pointExist {
                points.append(Point(strokeIndex: segment.strokeIndex,
                                    momentaryPointId: points.count,
                                    segmentId: [segment.id],
                                    location: point,
                                    upperPoint: [],
                                    lowerPoint: [],
                                    centralPoint: []))
            }
            else {
                if let index = points.firstIndex(where: { $0.location == point }) {
                    points[index].segmentId.append(segment.id)
                }
            }
        }
        
        // Assign point to the correct category (upper/lower)
        
        let firstPoint = segment.points[0]
        let secondPoint = segment.points[1]
        
        // Assign Point: first in segment
        if let firstIndex = points.firstIndex(where: { $0.location == firstPoint }) {
            if firstPoint.y < secondPoint.y {
                points[firstIndex].upperPoint.append((segment.strokeIndex, segment.id))
            }
            if firstPoint.y > secondPoint.y {
                points[firstIndex].lowerPoint.append((segment.strokeIndex, segment.id))
            }
            if firstPoint.y == secondPoint.y {
                if firstPoint.x < secondPoint.x {
                    points[firstIndex].upperPoint.append((segment.strokeIndex, segment.id))
                } else {
                    points[firstIndex].lowerPoint.append((segment.strokeIndex, segment.id))
                }
            }
        }
        // Assign Point: second in segment
        if let secondIndex = points.firstIndex(where: { $0.location == secondPoint }) {
            if secondPoint.y < firstPoint.y {
                points[secondIndex].upperPoint.append((segment.strokeIndex, segment.id))
            }
            if secondPoint.y > firstPoint.y {
                points[secondIndex].lowerPoint.append((segment.strokeIndex, segment.id))
            }
            if secondPoint.y == firstPoint.y {
                if secondPoint.x < firstPoint.x {
                    points[secondIndex].upperPoint.append((segment.strokeIndex, segment.id))
                } else {
                    points[secondIndex].lowerPoint.append((segment.strokeIndex, segment.id))
                }
            }
        }
    }
    points.sort {
        if $0.location.y == $1.location.y {
            print("same at \($0.location.y)")
            return $0.location.x < $1.location.x // Sort by x if y is the same
        }
        return $0.location.y < $1.location.y // Default: Sort by y
    }
    
    for point in points {
        print("Location: \(point.location)")
    }
    
    return points
}
