//
//  AudioRecorderManager.swift
//  TalkingButton
//
//  Created by MKubota on 2017/10/21.
//
//

import UIKit
import AVFoundation

class AudioRecorderManager: NSObject {
    
    
    static let shared = AudioRecorderManager()
    
    var recordingSession: AVAudioSession!
    var recorder:AVAudioRecorder?
    
    
    //録音のセットアップ
    func setup(){
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            //録音と再生をアクティブにする
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker])
            try recordingSession.setActive(true)
            
            //録音の許可
            recordingSession.requestRecordPermission() {[weak self] (allowed: Bool) -> Void  in
                if allowed {
                    print("Recording Allowed")
                } else {
                    print("Recording Allowed Faild")
                }
            }
        } catch {
            print("Faild to setCategory",error.localizedDescription)
        }
        
        guard self.recordingSession != nil else {
            print("Error session is nil")
            return
        }
    }
    
    
    //パス取得
    func getUserDocumentsPath()->URL{
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    
    var meterTimer:Timer?
    var CountDownTimer: Timer?
    
    //録音の設定
    func recored(fileName:String,result:(_ isRecording:Bool)->Void) {
        
        //ファイルのフルパス
        let path = getUserDocumentsPath().appendingPathComponent(fileName+".m4a")
        //ファイルURLに変換
        let audioURL = NSURL(fileURLWithPath: path.path)
        //録音の詳細設定
        let recoredSt:[String:Any] = [
            AVFormatIDKey:NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey : 12000.0,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            //録音
            recorder = try AVAudioRecorder(url: audioURL as URL, settings: recoredSt)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            // 録音ファイルの準備、上書き
            recorder?.prepareToRecord()
            //録音時間
            recorder?.record(forDuration: 180)
            //録音タイマー時間
            self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                   target:self,
                                                   selector:#selector(AudioRecorderManager.updateAudioMeter(timer:)),
                                                   userInfo:nil,
                                                   repeats:true)
            result(true)
            print("Recording")
        } catch {
            result(false)
        }
    }
    
    var recorderTime: String?
    
    //録音タイマー時間の表示
    func updateAudioMeter(timer:Timer){
        
        if let recorder = recorder {
            
            //分、秒
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60.0))
            
            //録音時間
            recorderTime  = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
        }
    }
    
    //録音停止
    func finishRecording(){
        
        self.recorder?.stop()
        //タイマー無効化
        self.meterTimer?.invalidate()
    }
    
}


//録音が停止した際の通知
extension AudioRecorderManager:AVAudioRecorderDelegate{
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("Audio Recorder did finish",flag)
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        print("\(String(describing: error?.localizedDescription))")
    }
    
}

