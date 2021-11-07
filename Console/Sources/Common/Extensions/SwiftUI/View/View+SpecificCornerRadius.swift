//
//  View+SpecificCornerRadius.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI

extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            
            switch type {
            case .moveTo:
                path.move(to: points[0])
                
            case .lineTo:
                path.addLine(to: points[0])
                
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
                
            case .closePath:
                path.closeSubpath()
                
            @unknown default:
                break
            }
        }
        return path
    }
}

enum Corner: Int, CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: [Corner] = Corner.allCases
    
    func path(in rect: CGRect) -> Path {
        let path = NSBezierPath()
        if corners.contains(.topLeft) {
            path.appendArc(withCenter: NSPoint(x: rect.minX + radius, y: rect.minY + radius),
                           radius: radius,
                           startAngle: 180,
                           endAngle: 270)
        } else {
            path.move(to: rect.origin)
        }
        
        if corners.contains(.topRight) {
            path.line(to: NSPoint(x: rect.maxX - radius, y: rect.minY))
            path.appendArc(withCenter: NSPoint(x: rect.maxX - radius, y: rect.minY + radius),
                           radius: radius,
                           startAngle: 270, endAngle: 360)
        } else {
            path.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        }
        
        if corners.contains(.bottomRight) {
            path.line(to: NSPoint(x: rect.maxX, y: rect.maxY - radius))
            path.appendArc(withCenter: NSPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                           radius: radius,
                           startAngle: 0, endAngle: 90)
        } else {
            path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        }
        
        if corners.contains(.bottomLeft) {
            path.line(to: NSPoint(x: rect.minX + radius, y: rect.maxY))
            path.appendArc(withCenter: NSPoint(x: rect.minX + radius, y: rect.maxY - radius),
                           radius: radius,
                           startAngle: 90, endAngle: 180)
        } else {
            path.line(to: NSPoint(x: rect.minX, y: rect.maxY))
        }
        
        path.close()
        
        return Path(path.cgPath)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: [Corner]) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

