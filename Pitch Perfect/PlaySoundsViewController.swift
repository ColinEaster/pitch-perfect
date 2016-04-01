//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Colin Easter on 5/10/15.
//  Copyright (c) 2015 Colin Easter. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.presentTransparentNavigationBar()
        //stopButton.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathURL)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowButtonPressed(sender: UIButton) {
        // TODO: play audio slowly
        audioPlayer.stop()
        
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func fastButtonPressed(sender: UIButton) {
        
        audioPlayer.stop()
        
        audioPlayer.rate = 2.0
        audioPlayer.play()
        
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        audioPlayer.stop()
        
    }
    
    @IBAction func chipmunkButtonPressed(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func vaderButtonPressed(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let pitchPlayer = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        pitchPlayer.play()

    }
    

}
