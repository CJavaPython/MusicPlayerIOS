//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 김웅수 on 2021/06/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    // MARK :- Properties
    var player: AVAudioPlayer!
    var timer: Timer!

    // MARK : IBOutlets
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSliderOne: UISlider!
    
    // MARK : -Methods
    // MARK : Custom Method
    
    func initializePlayer(){
        
        guard let soundAsset: NSDataAsset = NSDataAsset(name:"sound") else{print("음원 파일 에셋을 가져올 수 없습니다.")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code),  메세지:\(error.localizedDescription)")
        }
        self.progressSliderOne.maximumValue = Float(self.player.duration)
        self.progressSliderOne.minimumValue = 0
        self.progressSliderOne.value = Float(self.player.currentTime)
    }
    
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60);
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60));
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.timeLabel.text = timeText
    }
    
    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[unowned self](timer:Timer) in
            
            if self.progressSliderOne.isTracking {return }
            self.updateTimeLabelText(time:self.player.currentTime)
            self.progressSliderOne.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    
    override func updateViewConstraints() {
    //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializePlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
    @IBAction func touchUpPlayPauseButton(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
        } else {
            self.player?.pause()
        }
        
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print("slider value changed")
    }
}

