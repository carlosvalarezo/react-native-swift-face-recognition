//
//  CameraView.swift
//  reactSwiftCamera
//
//  Created by Carlos Valarezo Loaiza on 4/26/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {
  func capture(_ output: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
    print("saved to device...")
    if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
          }
  }
  
  
  //var captureSession = AVCaptureSession()
  var movieOutput = AVCaptureMovieFileOutput()
  var avPlayerController : AVPlayerViewController!
  var testFrame : CGRect!
  var testView : UIView!
  
  var delegate: VideoFeedDelegate? = nil
  
  var feedImageView = UIImageView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
  var faceLabel = UILabel(frame: CGRect(x: 100, y: 200, width: 200, height: 21))
  var instructionsLabel: UILabel!
  
  var videoPreviewLayer = AVCaptureVideoPreviewLayer()
  
  let outputQueue = DispatchQueue(label: "VideoDataOutputQueue", attributes: [])
  
  public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }
  
  let videoDataOutput = AVCaptureVideoDataOutput()
//  let videoDataOutput: AVCaptureVideoDataOutput = {
//    let output = AVCaptureVideoDataOutput()
//    output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA as UInt32) ]
//    output.alwaysDiscardsLateVideoFrames = true
//    return output
//  }()
  
  let captureSession2 = AVCaptureSession()
  
  let captureSession: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = AVCaptureSessionPresetHigh
    return session
  }()
  
  func start() throws {
    var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
    do {
      try callCamera()
      //captureSession.startRunning()
      return
    } catch let error1 as NSError {
      error = error1
    }
    throw error
  }
  
  func setupScreen(){
    testFrame = CGRect(x:0,y:0,width:screenWidth,height:screenHeight)
    testView = UIView(frame: testFrame)
    
    
    faceLabel.center = CGPoint(x: 160, y: 285)
    faceLabel.textAlignment = .center
    faceLabel.text = "I'am a test label"
    
    self.addSubview(testView)
    testView.addSubview(faceLabel)
    testView.addSubview(feedImageView)
  }
  
  func saveVideoToPhone(){
    let captureDevice = getDevice(position: .front)
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    do{
      let videoInput = try AVCaptureDeviceInput(device: captureDevice! )
      let audioInput = try AVCaptureDeviceInput(device: audioDevice! )
      
      if captureSession2.canAddInput(videoInput){
        captureSession2.addInput(videoInput)
        captureSession2.addInput(audioInput)
      }
      if captureSession2.canAddOutput(movieOutput){
        captureSession2.addOutput(movieOutput)
      }
      captureSession2.startRunning()
//      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession2)
//      videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
//      videoPreviewLayer.frame = testView.layer.bounds
//      testView.layer.addSublayer(videoPreviewLayer)
      
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let fileUrl = paths[0].appendingPathComponent("output"+NSUUID().uuidString+".mov")
      try? FileManager.default.removeItem(at: fileUrl)
      movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
        print("detenido...")
        self.movieOutput.stopRecording()
        //captureSession2.stopRunning()
      }
    }
    catch{}
  }
  
  func videoFeed(didUpdateWithSampleBuffer sampleBuffer: CMSampleBuffer!) {
    
    let detector = CIDetector(ofType: CIDetectorTypeFace, context:nil, options:[CIDetectorMinFeatureSize: 100])
    
     let image = CIImage(cvPixelBuffer: CMSampleBufferGetImageBuffer(sampleBuffer)!)
    let faceFeatures = detector?.features(in: image, options: [CIDetectorSmile: true])
    
    var instructions: String
    var smiley: String
    
    if let face = faceFeatures?.first as? CIFaceFeature {
      //captureSession.stopRunning()
      print("😍face detected...")
      saveVideoToPhone()
      if face.hasSmile {
        print("😀..happy...")
        
      } else {
        print("😐..flat...")
      }
    } else {
        print("❓..no face....")
    }
    
    DispatchQueue.main.async(execute: { () -> Void in
      //self.faceLabel.text = smiley
      //self.instructionsLabel.text = instructions
      self.feedImageView.image = UIImage(ciImage: image)
    })
  }
  
  func callCamera(){
    
    let captureDevice = getDevice(position: .front)
    let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    
    do {
      let videoInput = try AVCaptureDeviceInput(device: captureDevice! )
      let audioInput = try AVCaptureDeviceInput(device: audioDevice! )
      
      if captureSession.canAddInput(videoInput){
        captureSession.addInput(videoInput)
        //playVideo(url: "bubbles_i3")
        videoDataOutput.setSampleBufferDelegate(self, queue: outputQueue);
        captureSession.addInput(audioInput)
      }
      if captureSession.canAddOutput(videoDataOutput){
        captureSession.addOutput(videoDataOutput)
        //captureSession.addOutput(movieOutput)
        let connection = videoDataOutput.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoOrientation = AVCaptureVideoOrientation.portrait
      }
      //here add an observer to change the captureSession by captureSession2 or the other way around
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession2)
      videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
      videoPreviewLayer.frame = testView.layer.bounds
      testView.layer.addSublayer(videoPreviewLayer)
//      //detectFace()
      //CArgar el video
      //playVideo(url: "MacNCheeseStirring_Short")
      
      
      
      captureSession.startRunning()
      //let outputFileName = NSUUID().uuidString
      // let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
      
      /*guardar el archivo*/
//      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//      let fileUrl = paths[0].appendingPathComponent("output"+outputFileName+".mov")
//      try? FileManager.default.removeItem(at: fileUrl)
      /*fin guardar archivos*/
      //movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
      
      
//      DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
//        print("detenido...")
//        self.movieOutput.stopRecording()
//      }
      
      
      //movieFileOutput?.startRecording(toOutputFileURL: URL(fileURLWithPath: outputFilePath), recordingDelegate: self as! AVCaptureFileOutputRecordingDelegate)
    } catch {
      print(error)
    }
  }
  
  func showPermissionsDeniedScreen(){
    print("show permissions denied screen...")
  }
  
  func askForCameraPermissions(){
    do{
    try self.start()
    } catch {}
    
  }
  
  func checkCamera() {
    let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    switch authStatus {
    case .authorized: callCamera()
    case .denied: showPermissionsDeniedScreen()
    case .notDetermined: askForCameraPermissions()
    default: askForCameraPermissions()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupScreen()
    setupPlayerController()
    checkCamera()
    
  }
  
  func setupPlayerController(){
    avPlayerController = AVPlayerViewController()
    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    avPlayerController.videoGravity = AVLayerVideoGravityResizeAspectFill
    avPlayerController.showsPlaybackControls = false
    testView.addSubview(avPlayerController.view)
  }
  
  func playVideo(url: String){
    let filepath: String? = Bundle.main.path(forResource: url, ofType: ".mp4")
    let fileURL = URL.init(fileURLWithPath: filepath!)
    let avPlayer = AVPlayer(url: fileURL)
    //  hide show control
    avPlayerController.player = avPlayer
    // play video    
    avPlayerController.player?.play()
    
  }
  
  //func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
  func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    //print("guardado...")
    videoFeed(didUpdateWithSampleBuffer: sampleBuffer)
//    if error == nil {
//      UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
//    }
    if delegate != nil {
      delegate!.videoFeed(didUpdateWithSampleBuffer: sampleBuffer)
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

protocol VideoFeedDelegate {
  func videoFeed(didUpdateWithSampleBuffer sampleBuffer: CMSampleBuffer!)
}



