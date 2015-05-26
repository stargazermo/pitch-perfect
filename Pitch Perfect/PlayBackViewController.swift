//
//  PlayBackViewController.swift
//  Pitch Perfect
//
//  Created by MoXiafang on 5/22/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit
import AVFoundation

class PlayBackViewController: UIViewController {
    
    var receivedAudio: RecordedAudio!
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    //Set up the player, the engine and the file.
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopAllAudio()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableRate(2.0)

    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    //Stop and reset the player and the engine.
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //Play audio from the top with different rates.
    func playAudioWithVariableRate(rate: Float) {
        stopAllAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    //Play audio from the top with different pitches.
    func playAudioWithVariablePitch(pitch: Float){
        var unitTimePitch = AVAudioUnitTimePitch()
        unitTimePitch.pitch = pitch
        
        playAudioWithEffect(unitTimePitch)

    }
    
    
    @IBAction func reverbAudio(sender: UIButton) {
        var unitReverb = AVAudioUnitReverb()
        unitReverb.wetDryMix = 90
        
        playAudioWithEffect(unitReverb)
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        var unitDelay = AVAudioUnitDelay()
        unitDelay.delayTime = 0.5
        
        playAudioWithEffect(unitDelay)

    }

    //Connecting node to the engine, to be called to create various sound effects.
    func playAudioWithEffect(effect: AVAudioNode) {
        stopAllAudio()
        var audioPlayerNode: AVAudioPlayerNode!
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
}