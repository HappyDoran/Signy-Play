//
//  HandPosOverlayView.swift
//  SSC
//
//  Created by Doran on 2/16/25.
//

import SwiftUI

struct HandPoseOverlayView: View {
    private let boundingBox: CGRect?
    private let screenSize: CGSize
    private let borderColor: Color
    
    init(boundingBox: CGRect?, screenSize: CGSize, borderColor: Color) {
        self.boundingBox = boundingBox
        self.screenSize = screenSize
        self.borderColor = borderColor
    }
    
    var body: some View {
        ZStack {
            if let boundingBox = boundingBox {
                let convertedBoundingBox = convertToScreenCoordinates(boundingBox, screenSize: screenSize)
                
                Rectangle()
                    .stroke(borderColor, lineWidth: 5)
                    .frame(width: convertedBoundingBox.width, height: convertedBoundingBox.height)
                    .position(x: convertedBoundingBox.midX, y: convertedBoundingBox.midY)
            }
        }
    }
    
    private func convertToScreenCoordinates(_ rect: CGRect, screenSize: CGSize) -> CGRect {
        let x = (rect.origin.x - rect.width / 2) * screenSize.width*(2/3)
        let y = rect.origin.y * screenSize.height
        let width = rect.width * screenSize.width
        let height = rect.height * screenSize.height
    
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
