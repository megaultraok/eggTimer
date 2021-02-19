//
//  ViewController.swift
//  eggTimer
//
//  Created by Jada White on 2/11/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelOutput: UILabel!
    
    var eggTimes = ["Soft" : 3, "Medium" : 5, "Hard" : 15]
    
    var timer = Timer()
    var player: AVAudioPlayer?
    var startTime = 0
    var totalTime = 0
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        startTime = 0
        totalTime = 0
        progressView.progress = 0.0
        
        timer.invalidate()
        let hardness = sender.currentTitle!
        
        totalTime = eggTimes[hardness]!
        
        labelOutput.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

    }
    
    @objc func updateCounter() {
        if startTime < totalTime {
            startTime += 1
            progressView.progress = Float(startTime)/Float(totalTime)
        }
        else {
            labelOutput.text = "Done"
            playNoise()
            timer.invalidate()
        }
    }
    
    // TODO: Add warning alarm when done
    func playNoise() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

