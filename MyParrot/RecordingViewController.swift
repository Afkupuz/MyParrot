//
//  ViewController.swift
//  MyParrot
//
//  Created by nicolas on 3/15/16.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordButton.hidden = true
        stopRecordButton.enabled = false
        recordButton.enabled = true
    }


    @IBAction func recordStart(sender: AnyObject) {
        recordingLabel.text = "Recording..."
        stopRecordButton.enabled = true
        stopRecordButton.hidden = false
        recordButton.enabled = false
        recordButton.hidden = true
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    
    @IBAction func recordStop(sender: AnyObject) {
        recordingLabel.text = "Touch to record!"
        stopRecordButton.enabled = false
        stopRecordButton.hidden = true
        recordButton.enabled = true
        recordButton.hidden = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(recorder.url, name: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopSeg", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            recordButton.hidden = false
            stopRecordButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopSeg"){
            let playSoundsVC:PlayingViewController = segue.destinationViewController as! PlayingViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    
    
}

