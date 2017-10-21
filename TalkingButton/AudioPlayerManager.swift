//
//  AudioPlayerManager.swift
//  TalkingButton
//
//  Created by MKubota on 2017/10/21.
//
//

import UIKit
import AVFoundation


class AudioPlayerManager: NSObject {
    
    static let shared = AudioPlayerManager()
    
    override init() {
        super.init()
    }
    
    private var currentPlayer: AVAudioPlayer?
    
    var isPlaying = false
    var isFinished = false
    var lastPath: String?
    
    
    //録音したサウンドの再生設定
    func play(path: String) {
        
        let url = URL.init(string: path)
        
        do {
            self.currentPlayer = try AVAudioPlayer(contentsOf: url!)
            self.currentPlayer?.delegate = self
            self.currentPlayer?.play()
            isPlaying = true
        } catch {
            print("Error loading file", error.localizedDescription)
        }
    }
    
    
    //一時停止
    func pause()  {
        isPlaying = false
        self.currentPlayer?.pause()
    }
    
    
    //ストップ
    func stop() {
        isPlaying = false
        self.currentPlayer?.stop()
    }
    
    //パスの取得
    func audioFileInUserDocuments(fileName:String) -> String {
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent(fileName+".m4a").path
    }
    
    
}

//停止通知
extension Notification.Name {
    
    static let AudioPlayerDidFinishPlayingAudioFile = Notification.Name("AudioPlayerDidFinishPlayingAudioFile")
}

extension AudioPlayerManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       
        isFinished = true
        isPlaying = false
        NotificationCenter.default.post(name: Notification.Name.AudioPlayerDidFinishPlayingAudioFile, object: nil)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
