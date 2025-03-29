//
//  SignRecognizer.swift
//  SSC
//
//  Created by Doran on 2/12/25.
//

import UIKit
import Vision
import CoreML

actor SignRecognizer {
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private let mlmodel = MyHandPoseClassifier()
    
    private var _name: String = ""
    private var _text: String = ""
    private var _currentLetter: String = ""
    private var _confidence: Double = 0.0
    
    private var continuation: AsyncStream<(String, String, String, Double, CGRect)>.Continuation?
    let updates: AsyncStream<(String, String, String, Double, CGRect)>
    
    private var lastPrediction: String = ""
    private var predictionStartTime: Date?
    private let requiredHoldTime: TimeInterval = 1.0
    private var isProcessing: Bool = false
    
    init() {
        handPoseRequest.maximumHandCount = 1
        (updates, continuation) = AsyncStream.makeStream()
    }
    
    func processFrame(_ sampleBuffer: CMSampleBuffer) async {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let orientation = currentDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:])
        
        do {
            try imageRequestHandler.perform([handPoseRequest])
            
            guard let observation = handPoseRequest.results?.first,
                  let keypointsMultiArray = try? observation.keypointsMultiArray(),
                  let recognizedPoints = try? observation.recognizedPoints(forGroupKey: .all)
            else {
                resetPredictionTimer()
                return
            }
            
            let handPoints = recognizedPoints.values.map { point in
                CGPoint(x: point.location.x, y: 1 - point.location.y)
            }
            
            let boundingBox = calculateBoundingBox(for: handPoints)
            let prediction = try mlmodel.prediction(poses: keypointsMultiArray)
            let confidence = prediction.labelProbabilities[prediction.label] ?? 0
            
            _name = prediction.label
            _confidence = confidence
            
            if confidence > 0.8 {
                await handlePredictionWithTimer(label: prediction.label, confidence: confidence)
            } else {
                resetPredictionTimer()
            }
            
            continuation?.yield((_name, _text, _currentLetter, _confidence, boundingBox))
            
            
        } catch {
            print("Failed to perform hand pose detection: \(error)")
            resetPredictionTimer()
        }
    }
    
    func stopUpdates() {
        continuation?.finish()
        continuation = nil
    }
    
    func removeLastCharacter() {
        if !_text.isEmpty {
            _text.removeLast()
        }
    }
    
    func resetText() {
        _text = ""
    }
}

extension SignRecognizer {
    private func currentDeviceOrientation() -> CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait:
            return .up
        case .landscapeLeft:
            return .leftMirrored
        case .landscapeRight:
            return .rightMirrored
        case .portraitUpsideDown:
            return .upMirrored
        default:
            return .leftMirrored
        }
    }
    
    private func calculateBoundingBox(for points: [CGPoint]) -> CGRect{
        
        let minX = points.map { $0.x }.min() ?? 0
        let minY = points.map { $0.y }.min() ?? 0
        let maxX = points.map { $0.x }.max() ?? 0
        let maxY = points.map { $0.y }.max() ?? 0
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    private func handlePredictionWithTimer(label: String, confidence: Double) async {
        let now = Date()
        
        if label != lastPrediction {
            // 새로운 제스처가 감지되면 타이머 시작
            lastPrediction = label
            predictionStartTime = now
            return
        }
        
        // 같은 제스처가 계속되는 중
        guard let startTime = predictionStartTime,
              now.timeIntervalSince(startTime) >= requiredHoldTime,
              !isProcessing else {
            return
        }
        
        // 충분한 시간이 지났으면 입력 처리
        isProcessing = true
        await handlePrediction(label: label)
        _currentLetter = label
        resetPredictionTimer()
        isProcessing = false
    }
    
    private func resetPredictionTimer() {
        predictionStartTime = nil
        lastPrediction = ""
    }
    
    private func handlePrediction(label: String) async {
        switch label {
        case "del":
            if !_text.isEmpty {
                _text.removeLast()
            }
        case "space":
            _text.append(" ")
        case "nothing":
            break
        default:
            _text.append(label)
        }
    }
}


