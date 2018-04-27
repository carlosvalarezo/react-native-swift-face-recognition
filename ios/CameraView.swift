//
//  CameraView.swift
//  reactSwiftCamera
//
//  Created by Carlos Valarezo Loaiza on 4/26/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView, AVCaptureFileOutputRecordingDelegate {
  
  var captureSession = AVCaptureSession()
  var movieOutput = AVCaptureMovieFileOutput()
  
  var videoPreviewLayer = AVCaptureVideoPreviewLayer()
  
  
  public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let testFrame : CGRect = CGRect(x:0,y:0,width:screenWidth,height:screenHeight)
    
    
    let testView : UIView = UIView(frame: testFrame)
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100,
                                      height: 50))
    label.text = "This is Swift"
    self.addSubview(label)
    self.addSubview(testView)
    
    print("grabando...")
    
    let captureDevice = getDevice(position: .front)
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    
    do {
      let videoInput = try AVCaptureDeviceInput(device: captureDevice! )
      let audioInput = try AVCaptureDeviceInput(device: audioDevice! )
      
      if captureSession.canAddInput(videoInput){
        captureSession.addInput(videoInput)
        captureSession.addInput(audioInput)
      }
      if captureSession.canAddOutput(movieOutput){
        captureSession.addOutput(movieOutput)
      }
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
      videoPreviewLayer.frame = testView.layer.bounds
      testView.layer.addSublayer(videoPreviewLayer)
      captureSession.startRunning()
      let outputFileName = NSUUID().uuidString
      // let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
      
      /*guardar el archivo*/
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let fileUrl = paths[0].appendingPathComponent("output"+outputFileName+".mov")
      try? FileManager.default.removeItem(at: fileUrl)
      /*fin guardar archivos*/
      movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // change 2 to desired number of seconds
        print("detenido...")
        self.movieOutput.stopRecording()
      }
      
      
      //movieFileOutput?.startRecording(toOutputFileURL: URL(fileURLWithPath: outputFilePath), recordingDelegate: self as! AVCaptureFileOutputRecordingDelegate)
    } catch {
      print(error)
    }
  }
  
  func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
    print("guardado...")
    if error == nil {
      UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("error...")
  }
  
  func getDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
    let devices: NSArray = AVCaptureDevice.devices() as! NSArray;
    for de in devices {
      let deviceConverted = de as! AVCaptureDevice
      if(deviceConverted.position == position){
        return deviceConverted
      }
    }
    return nil
  }
}



