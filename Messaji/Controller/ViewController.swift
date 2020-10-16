//
//  ViewController.swift
//  Messaji
//
//  Created by 松尾大雅 on 2020/10/08.
//  Copyright © 2020 litech. All rights reserved.
//

import UIKit
import os

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

       @IBOutlet weak var AddImage: UIImageView!
       @IBOutlet weak var NameText: UITextField!
       @IBOutlet weak var DateLabel: UILabel!
       var saveData : UserDefaults = UserDefaults.standard
       var Userimage : UIImage!
       var request : UNNotificationRequest!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        UIset()
        Dayset()
        timerFiring()
        updateColor()
    }
    
    //UI設定諸々
    func UIset(){
         AddImage.layer.cornerRadius = 75
         AddImage.layer.shadowColor = UIColor.black.cgColor //影の色を決める
         AddImage.layer.shadowOpacity = 1 //影の色の透明度
         AddImage.layer.shadowRadius = 8 //影のぼかし
         AddImage.layer.shadowOffset = CGSize(width: 4, height: 4)
        
         if DateLabel.text != nil{
             judgeDate()
          }
        
         self.AddImage.isUserInteractionEnabled = true
         NameText.text  = saveData.object(forKey: "key_NameText") as? String
       
         if saveData.object(forKey: "key_AddImage") != nil {
            let ImageData = saveData.data(forKey: "key_AddImage")
            let Userimage2 = UIImage(data: ImageData!)
            Userimage = Userimage2
            AddImage.image = Userimage
         }
    }
    
    
    // 日付フォーマット
    func Dayset(){
           let date = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.timeStyle = .medium
           dateFormatter.dateStyle = .medium
           dateFormatter.locale = Locale(identifier: "ja_JP")
    
           // 現在時刻の1分後に設定
           let date2 = Date(timeInterval: 5, since: date)
           let targetDate = Calendar.current.dateComponents(
               [.year, .month, .day, .hour, .minute],
               from: date2)
    
           let dateString = dateFormatter.string(from: date2)
           print(dateString)
    
           // トリガーの作成
           let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
    
           // 通知コンテンツの作成
           let content = UNMutableNotificationContent()
           content.title = "Calendar Notification"
           content.body = dateString
           content.sound = UNNotificationSound.default
    
           // 通知リクエストの作成
           request = UNNotificationRequest.init(
                   identifier: "CalendarNotification",
                   content: content,
                   trigger: trigger)
    }
    
    func judgeDate(){
        
    //現在のカレンダ情報を設定
        let calender = Calendar.current
    //日本時間を設定
        let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
    //日付判定結果
        var judge = Bool()
    // 日時経過チェック
    if saveData.object(forKey: "today") != nil {
         let past_day = saveData.object(forKey: "today") as! Date
         let now = calender.component(.day, from: now_day)
         let past = calender.component(.day, from: past_day)
         let diff = calender.dateComponents([.day], from: past_day, to: now_day)
         print(diff.day!)
         DateLabel.text = String("\(diff.day!)日話していません")
    
        //日にちが変わっていた場合
                 if now != past {
                    judge = true
        
                 }
                 else {
                    judge = false
                   
                 }
             }
             //初回実行のみelse(nilならば、)
             else {
                 judge = true
                 /* 今の日時を保存 */
                 saveData.set(now_day, forKey: "today")
                 
             }

             /* 日付が変わった場合はtrueの処理 */
             if judge == true {
                  judge = false
                //日付が変わった時の処理
               
             }
             else {
              //日付が変わっていない時の処理をここに書く
                DateLabel.text = "初日です！"
             }
    }
         
    //背景色変化
    func timerFiring() {
               let timer = Timer(timeInterval: 0.2,
                                 target: self,
                                 selector: #selector(updateColor),
                                 userInfo: nil,
                                 repeats: true)
               RunLoop.main.add(timer, forMode: .default)
           }

    @objc func updateColor() {

               //グラデーションの開始色（上下）
               //タイマー処理でRGB値を少しずつ変化させてセット
        let topColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        let bottomColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1.0)

               //グラデーションの色を配列で管理
               let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]

               //グラデーションレイヤーを作成
        var gradientLayer = CAGradientLayer()
        gradientLayer.removeFromSuperlayer()
               gradientLayer = CAGradientLayer()
               //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
               //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
               //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, at: 0)
           }
    
    
    
    //登録ボタンで値をuserdefaultsへ保存する
        @IBAction func save(_ sender: Any) {
            os_log("setButton")
           // saveData.set(EmailText.text, forKey: "key_EmailText")
            saveData.set(NameText.text, forKey: "key_NameText")
           // saveData.set(TextView.text, forKey: "key_TextView")
            let data = Userimage.pngData()
            saveData.set(data, forKey: "key_AddImage")
            judgeDate()
            // 通知リクエストの登録
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("alertrequest!")
      
            
            let alert : UIAlertController = UIAlertController(title: "登録しました", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
            present(alert,animated: true, completion: nil)
    }
    
      // タップされたときの処理
        @IBAction func tapped(sender: UITapGestureRecognizer){
            print("押されました")
            //アラートを出す
            let alert : UIAlertController = UIAlertController(title: "プロフィール写真を選択", message: "", preferredStyle: .alert)
            
            //OKボタン
            alert.addAction(UIAlertAction(title:"OK",style: .default, handler: { action in
                //ボタンが押された時の動作
                print("OKが押されました")
                
                //フォトライブラリの画像を呼び出す
                let imagePickerController : UIImagePickerController = UIImagePickerController()
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePickerController.allowsEditing = true
                self.present(imagePickerController,animated: true , completion: nil)
                imagePickerController.delegate = self
                }
            ))
            alert.addAction(UIAlertAction(title:"Cancel",style: .default, handler: nil))
            present(alert,animated: true, completion: nil)
        }
    
    
}
    

        extension ViewController {
        
            
        func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            //選択された画像を取得
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage?
                else {return}
            
            Userimage = selectedImage
            //画像を変更
            self.AddImage.image = Userimage
            print("画像が選択されました")
            //imagepickerの削除
            self.dismiss(animated: true, completion: nil)
            }
        }
