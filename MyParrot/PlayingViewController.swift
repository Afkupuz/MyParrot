//
//  PlayingViewController.swift
//  MyParrot
//
//  Created by nicolas on 3/15/16.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit
import AVFoundation

class PlayingViewController: UIViewController {
    

    @IBOutlet weak var echoLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var echoSlider: UISlider!
    
    enum ButtonType: Int { case Chip = 0, Vader, Fast, Slow, Echo }
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl)
        try! audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
        audioPlayer.enableRate = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultButtons(sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            print("1")
        case .Fast:
            print("2")
        case .Vader:
            print("3")
        case .Chip:
            print("4")
        case .Echo:
            print("5")
        }
    }
    
    @IBAction func slideSpeed(sender: AnyObject) {
        speedLabel.text = "Value: \(speedSlider.value)"
    }
    
    @IBAction func slidePitch(sender: AnyObject) {
        pitchLabel.text = "Value: \(pitchSlider.value)"
    }
    
    @IBAction func slideEcho(sender: AnyObject) {
        echoLabel.text = "Value: \(echoSlider.value)"
    }
    
    
    func clearAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio() {
        clearAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitchSlider.value
        changePitchEffect.rate = speedSlider.value
        audioEngine.attachNode(changePitchEffect)
        
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(.Cathedral)
        changeReverbEffect.wetDryMix = echoSlider.value
        audioEngine.attachNode(changeReverbEffect)
        
        let changeDistortionEffect = AVAudioUnitDistortion()
        changeDistortionEffect.loadFactoryPreset(.MultiEcho1)
        audioEngine.attachNode(changeDistortionEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: changeDistortionEffect, format: nil)
        audioEngine.connect(changeDistortionEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func playSound(sender: AnyObject) {
        clearAudio()
        playAudio()
        
    }
    
    @IBAction func stopSound(sender: AnyObject) {
        clearAudio()
    }
    
    

}

