import UIKit


func getIntersection() -> CGPoint? {
    print("hi")
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

