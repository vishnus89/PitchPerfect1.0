//
//  ViewController.swift
//  PitchPerfect1.0
//
//  Created by Vishnu Deep Samikeri on 11/6/16.
//  Copyright © 2016 Vishnu Deep Samikeri. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stoprecordingButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var audioRecorder:AVAudioRecorder!
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("record button pressed")
        //        recordingLabel.text = "Recording in progress"
        //        stoprecordingButton.isEnabled = true
        //        recordButton.isEnabled = false
        configureUI(recording: true)
        
        let dirPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice1.wav"
        
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
    }
    @IBAction func stopRecording(_ sender: AnyObject) {
        print("Stop Recording pressed")
        configureUI(recording: false)
        //        recordButton.isEnabled = true
        //        stoprecordingButton.isEnabled = false
        //        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished saving")
        if (flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Saving Record failed")
        }
    }
    
    func configureUI(recording: Bool){
        // Set label
        recordingLabel.text =
            recording ? "Recording in progress" : "Tap to Record"
        
        // Set buttons
        recordButton.isEnabled = !recording
        stoprecordingButton.isEnabled = recording
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL as URL!
        }
    }
}

