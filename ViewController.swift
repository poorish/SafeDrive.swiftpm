//
//  ViewController.swift
//  Untitled
//
//  Created by Poorish Charoenkul on 23/2/2567 BE.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI
import Vision


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject{
    private let captureSession = AVCaptureSession() //camera
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) //camera
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var faceLayers:[CAShapeLayer] = []
    
    private var runCount = 5
    
    //camera
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCameraInput()
        self.showCameraFeed()
        self.captureSession.startRunning()
    }
    
    //camera
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.frame
    }
    
    //camera
    private func addCameraInput(){
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else{
            return
        }
        if let cameraInput = try? AVCaptureDeviceInput(device: device){
            if captureSession.canAddInput(cameraInput){
                captureSession.addInput(cameraInput)
            }
        }
    }
    
    //camera
    private func showCameraFeed(){
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.frame
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String:Any]
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        let videoConnection = self.videoDataOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
    }
    
    internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                self.faceLayers.forEach({ drawing in drawing.removeFromSuperlayer() })
                
                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations: observations)
                }
            }
        })
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .leftMirrored, options: [:])
        
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        for observation in observations {
            let faceRectConverted = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox)
            let faceRectanglePath = CGPath(rect: faceRectConverted, transform: nil)
            
            let faceLayer = CAShapeLayer()
            faceLayer.path = faceRectanglePath
            faceLayer.fillColor = UIColor.clear.cgColor
            
            self.faceLayers.append(faceLayer)
            self.view.layer.addSublayer(faceLayer)
            
            //FACE LANDMARKS
            if let landmarks = observation.landmarks {
                if let leftEye = landmarks.leftEye {
                    self.handleLandmark(leftEye, faceBoundingBox: faceRectConverted)
                }
                if let rightEye = landmarks.rightEye {
                    self.handleLandmark(rightEye, faceBoundingBox: faceRectConverted)
                }
            }
        }
    }
    
    @objc private func fireTimer(){
        runCount-=1
        
        if runCount == 0{
            AudioServicesPlayAlertSound(1005)
            let dialogMessage = UIAlertController(title: "Alert", message: "If you see this alert that's mean you're closed your eye for 5-15 seconds?", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "Yes", style: .default){_ in
                self.captureSession.stopRunning()
                self.dismiss(animated: true)
//                AudioServicesDisposeSystemSoundID(1005)
            }
            let cancelButton = UIAlertAction(title: "No, I'm just blinking.", style: .cancel)
            
            dialogMessage.addAction(okButton)
            dialogMessage.addAction(cancelButton)
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
            self.runCount = 5
        }
        
    }
    
    private func handleLandmark(_ eye: VNFaceLandmarkRegion2D, faceBoundingBox: CGRect) {
        _ = CGMutablePath()
        let landmarkPathPoints = eye.normalizedPoints
            .map({ eyePoint in
                CGPoint(
                    x: eyePoint.y * faceBoundingBox.height + faceBoundingBox.origin.x,
                    y: eyePoint.x * faceBoundingBox.width + faceBoundingBox.origin.y)
            })
        
        let p1 = landmarkPathPoints[0]
        let p2 = landmarkPathPoints[1]
        let p3 = landmarkPathPoints[2]
        let p4 = landmarkPathPoints[3]
        let p5 = landmarkPathPoints[4]
        let p6 = landmarkPathPoints[5]
        
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: false)
        
        //Blinking
        let result = (abs(p2.y - p6.y) + abs(p3.y - p5.y)) / 2*(abs(p1.y - p4.y))
        //        print(result)
        if result > 0.75 {
            timer.invalidate()
        }
    }
    
    
}//last bracket for ViewController


//For make it view on ContentView
struct HostedViewController: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> UIViewController {
        
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
