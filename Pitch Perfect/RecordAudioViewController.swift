//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Colin Easter on 5/5/15.
//  Copyright (c) 2015 Colin Easter. All rights reserved.
//

import UIKit
import AVFoundation

// extension for a transparent navigation bar
extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = UINavigationBar.appearance().translucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
}

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // stop button
    @IBOutlet weak var stopButton: UIButton!
    
    // label that has the recording text
    @IBOutlet weak var recordingTextLabel: UILabel!
    
    // record button
    @IBOutlet weak var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.hideTransparentNavigationBar()
        
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    @IBAction func recordButtonPressed(sender: UIButton) {
        
        recordButton.enabled = false
        
        // show recording text and stop button
        recordingTextLabel.hidden = false
        
        stopButton.hidden = false
        
            
    
        // start recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        do {
        try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        }
        catch _ {
            
        }
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
        // save recording
        recordedAudio = RecordedAudio()
        recordedAudio.filePathURL = audioRecorder.url
        recordedAudio.title = audioRecorder.url.lastPathComponent
        
        // TODO: Segue to next screen
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Didn't record successfully.")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        recordingTextLabel.hidden = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

