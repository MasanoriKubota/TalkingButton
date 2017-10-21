//
//  ViewController.swift
//  TalkingButton
//
//  Created by MKubota on 2017/10/21.
//
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    ///ページ追加
    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name: "FirstVC"),
                self.VCInstance(name: "SecondVC"),
                self.VCInstance(name: "ThirdVC")]
    }()
    
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲート
        self.dataSource = self
        self.delegate = self
        
        //最初の画面設定
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    
    }
    
    
    //右にスワイプした時のページ移動
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return VCArr.last
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
        return VCArr[previousIndex]
    }
    
    //左にスワイプした時のページ移動
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            return VCArr.first
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
        
        return VCArr[nextIndex]
    }
    
    
    //現在のページ番号取得
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard  let firstViewController = viewControllers?.first, let firstViewControllerIndex = VCArr.index(of: firstViewController )
            else {
                return 0
        }
        return firstViewControllerIndex
    }
    
    
    //設定画面へ
    //設定画面へ移動時はサウンドストップ
    @IBAction func ToSetting(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "NavigationVC")
        present(nextView, animated: true, completion: nil)
        
        if AudioPlayerManager.shared.isPlaying {
            AudioPlayerManager.shared.stop()
        }
        
        if SecondAudioPlayerManager.shared.isPlaying {
            SecondAudioPlayerManager.shared.stop()
        }
        
        if ThirdAudioPlayerManager.shared.isPlaying {
            ThirdAudioPlayerManager.shared.stop()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


