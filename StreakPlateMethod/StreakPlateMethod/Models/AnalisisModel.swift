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

class IntersectedPoints {
    var points: [Point]
    
    init(points: [Point]) {
        self.points = points
    }
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
    
    //    for point in points {
    //        print("Location: \(point.location)")
    //    }
    
    return points
}

class Status {
    var point: Point
    let segments : [Segment]
    var activeSegments: [Segment] = []
    
    var bLeft: Segment?
    var bRight: Segment?
    var sLeft: Segment?
    var sRight: Segment?
    
    var events: [Point]
    
    
    init(segments: [Segment], events: [Point]) {
        self.point = Point(strokeIndex: 99999,
                           momentaryPointId: 99999,
                           segmentId: [UUID()],
                           location: CGPoint(x: 0, y: 0),
                           upperPoint: [],
                           lowerPoint: [],
                           centralPoint: [])
        self.segments = segments
        self.events = events
    }
    
    //function to Remove the Lower Active Segements that are the lowerPoint
    func removeLowerSegment() {
        for segmentId in point.lowerPoint {
            activeSegments.removeAll {
                $0.strokeIndex == segmentId.0 && $0.id == segmentId.1
            }
        }
    }
    
    //function to Add the Upper Segements of the Point toi the Active Segements
    func addUpperSegment() {
        for segmentId in point.upperPoint {
            if let index = segments.firstIndex(where: { ($0.strokeIndex == segmentId.0) && ($0.id == segmentId.1) }) {
                activeSegments.append(segments[index])
            }
        }
    }
    
    //funtion to obtain the value of the x in a 2 points lines at a y value
    func getX(atY y: CGFloat, from point1: CGPoint, to point2: CGPoint, ifSameYReturnCloserToRight: Bool = false) -> CGFloat {
        let (x1, y1) = (point1.x, point1.y)
        let (x2, y2) = (point2.x, point2.y)
        
        // Check if the line is horizontal (no unique x for given y)
        if y1 == y2 {
            //print("= two point in the same Y get(X). \(point1), \(point2).   Obtained X:\(ifSameYReturnCloserToRight ? max(x1, x2) : min(x1, x2))")
            return ifSameYReturnCloserToRight ? max(x1, x2) : min(x1, x2)
        }
        if abs(y2 - y1) < 0.0001 { // y1 == y2
            //print("abs two point in the same Y get(X). \(point1), \(point2).   Obtained X:\(ifSameYReturnCloserToRight ? max(x1, x2) : min(x1, x2))")
            return ifSameYReturnCloserToRight ? max(x1, x2) : min(x1, x2)
        }
        return x1 + ((y - y1) * (x2 - x1)) / (y2 - y1)
    }
    
    func rearrangeSegments() {
        activeSegments.sort { getX(atY: point.location.y, from: $0.points[0], to: $0.points[1]) < getX(atY: point.location.y, from: $1.points[0], to: $1.points[1]) }
    }
    
    func getBLeftAndBRight() { //LO PUDIERA SIMPLIFICAR CON SOLO EL LADO IZQUIERO
        bLeft = nil //Default value if there is no left
        bRight = nil //Default value if there is no right
        var momentaryActiveSegments = activeSegments
        momentaryActiveSegments.removeAll {point.segmentId.contains($0.id)} //remove the segment itself to not be considered in the left right
        
        
        var leftSegments: [Segment] = []
        var rightSegments: [Segment] = []
        for segment in momentaryActiveSegments {
            let x1_right = getX(atY: point.location.y, from: segment.points[0], to: segment.points[1], ifSameYReturnCloserToRight: true)
            let x1_left = getX(atY: point.location.y, from: segment.points[0], to: segment.points[1])
            let x1 = (x1_right + x1_left) / 2
            
            //print ("x1: \(x1), x1_right: \(x1_right), x1_left: \(x1_left)")
            //print (point.location.x)
            
            if x1 < point.location.x {
                leftSegments.append(segment)
            } else if x1 > point.location.x{
                rightSegments.append(segment)
            } else {
                print("WARNING: Point \(point.location) is inside a horizontal segment.")
            }
        }
        leftSegments.sort {
            let x1 = getX(atY: point.location.y, from: $0.points[0], to: $0.points[1], ifSameYReturnCloserToRight: true)
            let x2 = getX(atY: point.location.y, from: $1.points[0], to: $1.points[1], ifSameYReturnCloserToRight: true)
            return abs(x1 - point.location.x) < abs(x2 - point.location.x)
        }
        rightSegments.sort {
            let x1 = getX(atY: point.location.y, from: $0.points[0], to: $0.points[1])
            let x2 = getX(atY: point.location.y, from: $1.points[0], to: $1.points[1])
            return abs(x1 - point.location.x) < abs(x2 - point.location.x)
        }
        
        bLeft = leftSegments.first
        bRight = rightSegments.first
    }
    
    
    func findNewEvent(segment1: Segment, segment2: Segment, point: Point) {
            
            //Not considering when is the same segment with himself
            if segment1.strokeIndex == segment2.strokeIndex { return }
            

        if let intersectionPoint: CGPoint = getIntersection(segment1: segment1, segment2: segment2) {
                /// maybe check here
            print("new intersection at \(intersectionPoint)")
            if segment1.points[0].y == segment1.points[1].y { print("intersection-Horizontal line points: \(segment1.points), \(segment2.points)") }
            if segment1.points[0].y == segment1.points[1].y { print("intersection-Horizontal line points: \(segment1.points), \(segment2.points)") }
            
            print("intersectionPoint.y: \(intersectionPoint.y) > point.location.y: \(point.location.y)")
            print("intersectionPoint.x: \(intersectionPoint.y) == point.location.x: \(point.location.y) && (intersectionPoint.x:  \(intersectionPoint.x) < point.location.x: \(point.location.x)")
                if (intersectionPoint.y > point.location.y) || ((intersectionPoint.y == point.location.y) && (intersectionPoint.x > point.location.x)) {
                    print("corrected positioned")
                    let pointExist: Bool = events.contains(where: {$0.location == intersectionPoint})
                    
                    if !pointExist {
                        let point = Point(strokeIndex: max(segment1.strokeIndex, segment2.strokeIndex),
                                          momentaryPointId: 7777,
                                          segmentId: [segment1.id, segment2.id],
                                          location: intersectionPoint,
                                          upperPoint: [],
                                          lowerPoint: [],
                                          centralPoint: [(segment1.strokeIndex, segment1.id),(segment2.strokeIndex, segment2.id)])
                        events.append(point)
                        
                        events.sort {
                            if $0.location.y == $1.location.y {
                                return $0.location.x < $1.location.x // Sort by x if y is the same
                            }
                            return $0.location.y < $1.location.y // Default: Sort by y
                        }
                    }
                    
                }
            }
            
            func getIntersection(segment1: Segment, segment2: Segment) -> CGPoint? {
                
                let p1 = segment1.points[0]
                let p2 = segment1.points[1]
                let p3 = segment2.points[0]
                let p4 = segment2.points[1]
                
                let x1 = p1.x, y1 = p1.y
                let x2 = p2.x, y2 = p2.y
                let x3 = p3.x, y3 = p3.y
                let x4 = p4.x, y4 = p4.y
                
                
                let denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
                
                // If denominator is zero, lines are parallel or coincident
                if abs(denominator) < 1e-10 {
                    return nil
                }
                
                let t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
                let u = ((x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2)) / denominator
                
                // Check if intersection is within both segment bounds (0 ≤ t ≤ 1 and 0 ≤ u ≤ 1)
                if t >= 0, t <= 1, u >= 0, u <= 1 {
                    let intersectionX = x1 + t * (x2 - x1)
                    let intersectionY = y1 + t * (y2 - y1)
                    return CGPoint(x: intersectionX, y: intersectionY)
                }
                //print("result: no intersection found")
                return nil // No intersection within the segment bounds
            }
        }
    
    func getSLeftAndSRight() {
            sLeft = nil
            sRight = nil
            var momentaryActiveSegments = activeSegments
            momentaryActiveSegments.removeAll {!point.segmentId.contains($0.id)}
            momentaryActiveSegments.sort { segment1, segment2 in
                
                // Get the correctly ordered points
                let (p1s1, p2s1) = (segment1.points[0].y < segment1.points[1].y) ||
                (segment1.points[0].y == segment1.points[1].y && segment1.points[0].x < segment1.points[1].x)
                ? (segment1.points[0], segment1.points[1])
                : (segment1.points[1], segment1.points[0])
                
                let (p1s2, p2s2) = (segment2.points[0].y < segment2.points[1].y) ||
                (segment2.points[0].y == segment2.points[1].y && segment2.points[0].x < segment2.points[1].x)
                ? (segment2.points[0], segment2.points[1])
                : (segment2.points[1], segment2.points[0])
                
                // Calculate angles in radians
                let angle1 = atan2(p2s1.y - p1s1.y, p2s1.x - p1s1.x)
                let angle2 = atan2(p2s2.y - p1s2.y, p2s2.x - p1s2.x)
                
                return angle1 < angle2
                //IMPROVEMENT POINT, WHAT IF YOU HAVE A LOT OF HORIZONTAL LINES?
            }
            
            if momentaryActiveSegments.count > 0 {
                sLeft = momentaryActiveSegments.first
                sRight = momentaryActiveSegments.last
            }
        }
}


func handleEvent(point: Point, status: Status, intersectedPoints: IntersectedPoints) {
    
    if point.centralPoint.count > 0 {
        intersectedPoints.points.append(point)
    }
    
    status.point = point
    status.removeLowerSegment() //Puede que se este elominando active segments que sean central point (pero no creo que sea la causa?
    status.addUpperSegment()
    status.rearrangeSegments()

    //Find next event
    if point.upperPoint.count + point.centralPoint.count == 0 {
        status.getBLeftAndBRight()
        if let bLeft = status.bLeft, let bRight = status.bRight {
           status.findNewEvent(segment1: bLeft, segment2: bRight, point: point)
        }
    } else {
        status.getBLeftAndBRight()
        status.getSLeftAndSRight()
        if let bLeft = status.bLeft, let sLeft = status.sLeft {
            status.findNewEvent(segment1: bLeft, segment2: sLeft, point: point)
        }
        if let bRight = status.bRight, let sRight = status.sRight {
            status.findNewEvent(segment1: bRight, segment2: sRight, point: point)
        }
    }
}

