//
//  RecorderViewController.swift
//  Pitch Perfect
//
//  Created by MoXiafang on 5/19/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var recorderButton: UIButton!
    @IBOutlet weak var pauseAndResumeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var paused: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Set up the UI elements.
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseAndResumeButton.hidden = true
        recorderButton.enabled = true
        instructionLabel.text = "Tap to Record"
    }
    
    //Record audio with AVAudioRecorder and set up the file path.
    @IBAction func audioRecord(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        stopButton.hidden = false
        pauseAndResumeButton.hidden = false
        recorderButton.enabled = false
        instructionLabel.text = "Recording..."
        paused = false
        
    }
    
    //Use variable "paused" to decide which button to show and what the button does.
    @IBAction func pauseOrResume(sender: AnyObject) {
        if paused == false {
            paused = true
            audioRecorder.pause()
            instructionLabel.text = "Paused"
            let image = UIImage(named: "resume.png") as UIImage!
            pauseAndResumeButton.setImage(image, forState: .Normal)
        } else {
            paused = false
            audioRecorder.record()
            instructionLabel.text = "Recording..."
            let image = UIImage(named: "pause.png") as UIImage!
            pauseAndResumeButton.setImage(image, forState: .Normal)
        }
    }

    //Call the class initializer to create a class instance and trigger the segue performance.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        } else {
            println("Recording not successful")
            stopButton.hidden = true
            pauseAndResumeButton.hidden = true
            recorderButton.enabled = true
        }
    }
    
    //Segue performance that will be called.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let targetVC: PlayBackViewController = segue.destinationViewController as! PlayBackViewController
            targetVC.receivedAudio = sender as! RecordedAudio
        }
    }
    
    //Stop the recorder and set up the session.
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}