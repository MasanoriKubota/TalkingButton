//
//  FirstViewController.swift
//  TalkingButton
//
//  Created by MKubota on 2017/10/21.
//
//

import UIKit


class FirstViewController: UIViewController {
    
    //ビュー
    @IBOutlet weak var BackView: UIView!
    //表示ラベル
    @IBOutlet weak var FirstLabel: UILabel!
    //再生ボタン
    @IBOutlet weak var FirstButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ComenntOnOff()
        loadText()
        
        //再生停止の通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying), name: NSNotification.Name.AudioPlayerDidFinishPlayingAudioFile, object: nil)

        //BavkView設定
        BackView.layer.cornerRadius = 30
        BackView.clipsToBounds = true
        
        //Label設定
        FirstLabel.layer.borderWidth = 6
        FirstLabel.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 205/255, alpha: 1.0).cgColor
        FirstLabel.layer.masksToBounds = true
        FirstLabel.layer.cornerRadius = 20
        
        //Button設定
        FirstButton.adjustsImageWhenHighlighted = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadText()
        
    }
    
    //録音したサウンドの再生
    @IBAction func playSound(_ sender: Any) {
        
        //再生停止
        if AudioPlayerManager.shared.isPlaying{
            
            //停止
            AudioPlayerManager.shared.stop()

            //ボタンのアニメーション設定
            UIView.transition(with: sender as! UIView, duration: 0.6 ,options:.transitionCrossDissolve , animations: {
                (sender as AnyObject).setImage(#imageLiteral(resourceName: "FirstBtnOff"), for: .normal)
            }, completion: nil)
        
        //再生スタート
        } else {
            
            //再生するファイルのパスを取得
            let path = AudioPlayerManager.shared.audioFileInUserDocuments(fileName: "FirstFile" )
            //再生
            AudioPlayerManager.shared.play(path: path)

            //ボタンのアニメーション設定
            UIView.transition(with: sender as! UIView, duration: 0.6,options:.transitionCrossDissolve , animations: {
                (sender as AnyObject).setImage(#imageLiteral(resourceName: "FirstBtnOn"), for: .normal)
            }, completion: nil)
        }
    }
    
    
    //ラベルの表示のオンオフ設定
    func ComenntOnOff() {
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "FirstSwitchStatus") == nil {
            self.FirstLabel.isHidden = false
        } else {
            let LabelValue = defaults.bool(forKey: "FirstSwitchStatus")
            if LabelValue {
                self.FirstLabel.isHidden = false
            } else {
                self.FirstLabel.isHidden = true
            }
        }
    }
    
    //保存されたラベルの表示
    func loadText() {
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "FirstFieldStatus") != nil {
            let FisrtValue = defaults.object(forKey: "FirstFieldStatus") as? String
            self.FirstLabel.text = FisrtValue
        } else {
            self.FirstLabel.text = ""
        }
        
    }
    
    //録音停止通知が来たら、ボタンを元に戻す
    func audioPlayerDidFinishPlaying() {
        
        FirstButton.setImage(#imageLiteral(resourceName: "FirstBtnOff"), for: .normal)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
