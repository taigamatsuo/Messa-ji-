//
//  FourthViewController.swift
//  Messaji
//
//  Created by 松尾大雅 on 2020/10/08.
//  Copyright © 2020 litech. All rights reserved.
//

import UIKit
import os

class FourthViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

       @IBOutlet weak var AddImage: UIImageView!
       @IBOutlet weak var NameText: UITextField!
       @IBOutlet weak var DateLabel: UILabel!
       @IBOutlet var button : UIButton!
       @IBOutlet var backView : UIView!
       @IBOutlet var TextView : UITextView!
       @IBOutlet var iconImage : UIImageView!
       var saveData : UserDefaults = UserDefaults.standard
       var Userimage : UIImage!
       var request : UNNotificationRequest!
       let color = UIColor.colorLerp4(from: .white, to: .red, progress: 0.5)
      
    override func viewDidLoad() {
        super.viewDidLoad()
        UIset()
        Dayset()
        timerFiring()
        updateColor()
       
    }
    
    //UI設定諸々
    func UIset(){
         AddImage.layer.cornerRadius = 70
         AddImage.layer.borderColor = UIColor.gray.cgColor
         AddImage.layer.borderWidth = 1
        
         button.layer.shadowOffset = CGSize(width: 1, height: 1 )
         button.layer.shadowColor = UIColor.gray.cgColor
         button.layer.shadowRadius = 5
         button.layer.shadowOpacity = 1.0
        
         if saveData.object(forKey: "key_NameText4") != nil{
                 NameText.backgroundColor = UIColor.colorLerp(from: .white, to: .red, progress: 0.5)
                }
                
                 if saveData.object(forKey: "today4") != nil{
                     judgeDate()
                     DateLabel.backgroundColor = UIColor.colorLerp(from: .white, to: .red, progress: 0.5)
                  }
        
         self.AddImage.isUserInteractionEnabled = true
         NameText.text  = saveData.object(forKey: "key_NameText4") as? String
         TextView.text  = saveData.object(forKey: "key_TextView4") as? String
         if saveData.object(forKey: "key_AddImage4") != nil {
            let ImageData = saveData.data(forKey: "key_AddImage4")
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
    
           // 現在時刻の30日後に設定
           let date2 = Date(timeInterval: 2320000, since: date)
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
    if saveData.object(forKey: "today4") != nil {
         let past_day = saveData.object(forKey: "today4") as! Date
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
                 saveData.set(now_day, forKey: "today4")
                 DateLabel.text = "今日が初日です"
                 
             }

             /* 日付が変わった場合はtrueの処理 */
             if judge == true {
                  judge = false
                //日付が変わった時の処理
               
             }
             else {
              //日付が変わっていない時の処理をここに書く
                DateLabel.text = "今日が初日です"
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
        let topColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let bottomColor = UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)

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
    
    
    
    //登録ボタンを押した時の処理
    func touchStartAnimation() {
        print("登録ボタンが押されました")
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {() -> Void in
            self.button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95);
            self.button.alpha = 0.9
        },completion: nil)
    
      
    }
   
    
    //登録ボタンで値をuserdefaultsへ保存する
    @IBAction func save(_ sender: Any) {
        
        if saveData.object(forKey: "key_AddImage4") == nil {
            
            let alert : UIAlertController = UIAlertController(title: "写真を設定してください", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
            present(alert,animated: true, completion: nil)
            
        }else{
            
            touchStartAnimation()
            DateLabel.backgroundColor = color
            saveData.set(NameText.text, forKey: "key_NameText4")
            saveData.set(TextView.text, forKey: "key_TextView4")
            judgeDate()
            // 通知リクエストの登録
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("alertrequest!")
      
            let alert : UIAlertController = UIAlertController(title: "登録しました", message: "30日ごとにリマインドを送ります", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
            present(alert,animated: true, completion: nil)
    }
    }
   
    
    //delete
    @IBAction func delete(){
           
            if saveData.object(forKey: "today4") != nil {
            let alert: UIAlertController = UIAlertController(title: "メッセージを送りましたか？", message:  "日付をリセットします", preferredStyle:  UIAlertController.Style.alert)
   
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
        
                UserDefaults.standard.removeObject(forKey: "today4")
                self.DateLabel.text = ""
                self.DateLabel.backgroundColor = .white
        
    })
    // キャンセルボタンの処理
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
        // キャンセルボタンが押された時の処理をクロージャ実装する
        (action: UIAlertAction!) -> Void in
        //実際の処理
        print("キャンセル")
    })

    //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
    alert.addAction(cancelAction)
    alert.addAction(confirmAction)

    //実際にAlertを表示する
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func tapAction(_ sender: Any) {
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



    extension UIColor {

        static func colorLerp4(from: UIColor, to: UIColor, progress: CGFloat) -> UIColor {
            
            let t = max(0, min(1, progress))
            
            var redA: CGFloat = 0
            var greenA: CGFloat = 0
            var blueA: CGFloat = 0
            var alphaA: CGFloat = 0
            from.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA)
            
            var redB: CGFloat = 0
            var greenB: CGFloat = 0
            var blueB: CGFloat = 0
            var alphaB: CGFloat = 0
            to.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB)
            
            let lerp = { (a: CGFloat, b: CGFloat, t: CGFloat) -> CGFloat in
                return a + (b - a) * t
            }
            
            let r = lerp(redA, redB, t)
            let g = lerp(greenA, greenB, t)
            let b = lerp(blueA, blueB, t)
            let a = lerp(alphaA, alphaB, t)
            
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
    }
    

        extension FourthViewController {
        
            
        func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            //選択された画像を取得
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage?
                else {return}
            
            Userimage = selectedImage
            //画像を変更
            self.AddImage.image = Userimage
            print("画像が選択されました")
            let data = self.Userimage.pngData()
            self.saveData.set(data, forKey: "key_AddImage4")
            //imagepickerの削除
            self.dismiss(animated: true, completion: nil)
            }
        }
