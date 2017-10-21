//
//  SettingTableViewController.swift
//  TalkingButton
//
//  Created by MKubota on 2017/10/21.
//
//

import UIKit
import AVFoundation
import GoogleMobileAds

class SettingTableViewController: UITableViewController , UITextFieldDelegate{
    
    //First Button
    @IBOutlet weak var FirstPlayBtn: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    
    //FirstSwitch
    @IBOutlet weak var FirstSwitch: UISwitch!
    
    //FirstText
    @IBOutlet weak var FirstText: UITextField!
    
    //SecondText
    @IBOutlet weak var SecondText: UITextField!
    
    //Label
    //First
    @IBOutlet weak var FirstComment: UILabel!
    @IBOutlet weak var FirstDisplay: UILabel!
    
    //Admob広告
    @IBOutlet weak var BannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //再生停止通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying), name: NSNotification.Name.AudioPlayerDidFinishPlayingAudioFile, object: nil)
  
        //FirstText
        self.FirstText.delegate = self
        FirstText.returnKeyType = .done
        
        FirstSwitchLoad()
        TextMethod()
        
        //localization
        self.navigationItem.title = NSLocalizedString("BarTitle", comment: "")
        
        self.FirstComment.text = NSLocalizedString("Comment", comment: "")
        self.FirstDisplay.text = NSLocalizedString("Display", comment: "")
        
        
        //Admob広告
        let request = GADRequest()
        
        BannerView.adUnitID = "ca-app-pub-*******/************"
        BannerView.rootViewController = self
        BannerView.load(request)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // First Button
        TimeLoading()
   
        configureobserver()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObeserver()
    }
    
    
    //PageViewControllerに戻る（再生をストップする）
    @IBAction func BackHome(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "MainVC")
        present(nextView, animated: true, completion: nil)
        
        if AudioPlayerManager.shared.isPlaying {
            AudioPlayerManager.shared.stop()
        }
    }
    
    
    //バックグラウンドでも再生
    func BackgroundPlay() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
            //エラー処理
            fatalError("カテゴリ設定失敗")
        }
        //アクティブ化
        do {
            try session.setActive(true)
        } catch {
            //audio session有効化失敗時の処理
            //(ここではエラーとして停止している）
            fatalError("session有効化失敗")
        }
    }
    
    
    //First Button
    @IBAction func playSound(_ sender: Any) {
        
        //再生を停止
        if AudioPlayerManager.shared.isPlaying{
            AudioPlayerManager.shared.stop()
            
            //再生ボタンの画像にする
            self.FirstPlayBtn.setImage(#imageLiteral(resourceName: "AudioPlay"), for: .normal)
        } else  {
        //再生
            let path = AudioPlayerManager.shared.audioFileInUserDocuments(fileName: "FirstFile" )
            AudioPlayerManager.shared.play(path: path)

            //停止ボタンの画像にする
            self.FirstPlayBtn.setImage(#imageLiteral(resourceName: "AudioStop"), for: .normal)
            
        }
    }
    
    
    var nonObservablePropertiesUpdateTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    
    //マイクを使用して録音する
    @IBAction func StartRecording(_ sender: Any) {
        
        AudioRecorderManager.shared.recored(fileName: "FirstFile") { (status:Bool) in
            if status == true{
                print("Did Start recording")
            }else{
                print("Erro starting recorder")
            }
        }
        
        //録音時間を表示する
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.minute,.second]
        formatter.calendar = Calendar.current
        
        nonObservablePropertiesUpdateTimer.setEventHandler { [weak self] in
            self?.durationLabel.text = formatter.string(from: AudioRecorderManager.shared.recorder!.currentTime)
            
        }
        
        nonObservablePropertiesUpdateTimer.scheduleRepeating(deadline: DispatchTime.now(), interval:DispatchTimeInterval.milliseconds(100))
        nonObservablePropertiesUpdateTimer.resume()
        
    }
    
    
    //録音を停止する
    @IBAction func stopRecording(_ sender: Any) {
        
        AudioRecorderManager.shared.finishRecording()
        nonObservablePropertiesUpdateTimer.suspend()
        
        //録音時間を保存
        let defaults = UserDefaults.standard
        defaults.set(self.durationLabel.text, forKey: "durationTime")
        defaults.synchronize()
        
    }
    
    
    //再生停止の際の処理
    func audioPlayerDidFinishPlaying(){
        self.FirstPlayBtn.setImage(#imageLiteral(resourceName: "AudioPlay"), for: .normal)
        
    }
    
    //保存された録音時間の表示
    func TimeLoading() {
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "durationTime") != nil {
            
            let durationString = defaults.object(forKey: "durationTime") as? String
            self.durationLabel.text = durationString
        } else {
            self.durationLabel.text = "0:00"
        }
    }
    
    
    //Switchボタンのオンオフ
    @IBAction func FirstSwitchAction(_ sender: Any) {
       
        let defaults = UserDefaults.standard
        
        if FirstSwitch.isOn {
            defaults.set(true, forKey: "FirstSwitchStatus")
        } else {
            defaults.set(false, forKey: "FirstSwitchStatus")
        }
        defaults.synchronize()
    }
    
    //保存されたSwitchボタンのオンオフを表示
    func FirstSwitchLoad() {
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "FirstSwitchStatus") == nil {
        
            self.FirstSwitch.isOn = true
        } else {
            
            let FirstSwitchValue = defaults.bool(forKey: "FirstSwitchStatus")
           
            if FirstSwitchValue {
                self.FirstSwitch.isOn = true
            } else {
                self.FirstSwitch.isOn = false
            }
        }
    }
        
        
    //Textに文字列を保存
    @IBAction func FirstInput(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        
        //文字列を保存
        defaults.set(FirstText.text, forKey: "FirstFieldStatus")
        
        //値をすぐに更新
        defaults.synchronize()
    }
   
        
    //保存された文字列の表示
    func TextMethod() {
        
        let FirstDefaults = UserDefaults.standard
        
        if FirstDefaults.object(forKey: "FirstFieldStatus") != nil {
            
            let FirstValue = FirstDefaults.object(forKey: "FirstFieldStatus") as? String
            self.FirstText.text = FirstValue
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //Keyboardの設定(Keyboardで入力テキストが隠れてしまう為)
    func configureobserver() {
        
        let notificationKey = NotificationCenter.default
        notificationKey.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationKey.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObeserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
     
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        })
    }
    
    func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}
