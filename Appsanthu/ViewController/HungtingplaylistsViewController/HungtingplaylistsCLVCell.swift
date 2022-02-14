//
//  HungtingplaylistsCLVCell.swift
//  Appsanthu
//
//  Created by devsenior on 09/07/2021.
//

import UIKit
import AVFoundation



class HungtingplaylistsCLVCell: UICollectionViewCell {
    var player: AVPlayer?
    var repeat1: AVAudioPlayer!
    var playerItem:AVPlayerItem?
    var isplay : Bool = true
    var isvolume : Bool = true
    
    @IBOutlet weak var Volume: UIButton!
    fileprivate let seekDuration: Float64 = 10
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelOverallDuration: UILabel!

    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Timelist: UILabel!
    var indexPath : IndexPath!
    

    var LinkPlay:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func statusplay(){
            
            initAudioPlayer()
            player!.play()
    }
    func statuspause(){
        player!.pause()
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        
        return String(format: "%02d:%02d",minutes, seconds)
    }
    
    @IBAction func volume(_ sender: Any) {
        if isvolume == true{
            Volume.setImage(UIImage(named: "volume-x.png"), for: .normal)
            player?.isMuted = true
            isvolume = false
            
        }
        else {
            Volume.setImage(UIImage(named: "volume-2.png"), for: .normal)
            player?.isMuted = false
            isvolume = true
        }
    }
    @IBAction func didSelectBtnPlay(_ sender: Any) {
        if isplay == true{
            play.setImage(UIImage(named: "pause_circle_filled.png"), for: .normal)
            statusplay()
            isplay = false
            
        }
        else {
            play.setImage(UIImage(named: "play_circle_outline.png"), for: .normal)
            statuspause()
            isplay = true
        }
        
    }
    //_______SONPIPI___
    //call this mehtod to init audio player
    func initAudioPlayer(){
        let url = URL(string: LinkPlay)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        playbackSlider.minimumValue = 0
        
        //To get overAll duration of the audio
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        labelCurrentTime.text = self.stringFromTimeInterval(interval: seconds)
        
        //To get the current duration of the audio
        let currentDuration : CMTime = playerItem.currentTime()
        let currentSeconds : Float64 = CMTimeGetSeconds(currentDuration)
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
                
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider.value = Float ( time );
                self.labelCurrentTime.text = self.stringFromTimeInterval(interval: time)
            }
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
//                self.play.isHidden = true
//                        self.loadingView.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
//                self.ButtonPlay.isHidden = false
                //        self.loadingView.isHidden = true
            }
        }

       
       //change the progress value
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        
        //check player has completed playing audio
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0 {
            player?.play()
        }
    }

    @objc func finishedPlaying( _ myNotification:NSNotification) {
        play.setImage(UIImage(named: "play_circle_outline.png"), for: .normal)
        //reset player when finish
        playbackSlider.value = 0
        let targetTime:CMTime = CMTimeMake(value: 0, timescale: 1)
        player!.seek(to: targetTime)
    }
}

