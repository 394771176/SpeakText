//
//  ReadTextController.swift
//  swiftTest
//
//  Created by cheng on 2018/10/13.
//  Copyright © 2018年 cheng. All rights reserved.
//

import UIKit
import AVFoundation

class ReadTextController: UIViewController , AVSpeechSynthesizerDelegate {

    var synthesizer:AVSpeechSynthesizer!
    var utterance:AVSpeechUtterance?
    var speechBtn:UIButton!
//    var textLabel:UILabel!
    
    var startIndex : Int = 0
    var endIndex : Int = 0
    var content : String!
    
    @IBOutlet weak var speakBtn: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateParam(_ sender: Any) {
        if (utterance != nil) {
            utterance?.rate = rateSlider.value;
            utterance?.volume = volumeSlider.value;
            utterance?.pitchMultiplier = pitchSlider.value;
            
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    @IBAction func speakBtnAction(_ sender: Any) {
        if synthesizer == nil {
            synthesizer = AVSpeechSynthesizer()
            synthesizer.delegate = self
        }
        
        //isPaused 需要先判断，因为暂停时 isSpeak 依然是yes
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        }else if synthesizer.isSpeaking{
            //            synthesizer!.stopSpeaking(at: AVSpeechBoundary.immediate)
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
        } else{
            utterance = AVSpeechUtterance(string: textLabel.text!)
            utterance!.voice = AVSpeechSynthesisVoice(language:"zh-CN")
            utterance!.rate = rateSlider.value//语速
            utterance!.volume = volumeSlider.value//音量
            utterance!.pitchMultiplier = pitchSlider.value//音高
            
            //                        utterance!.preUtteranceDelay = 0.1;
            utterance!.postUtteranceDelay = 2;
            synthesizer.speak(utterance!)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speakBtn.setTitle("暂停", for: UIControlState.normal)
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        speakBtn.setTitle("继续", for: UIControlState.normal)
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        speakBtn.setTitle("朗读", for: UIControlState.normal)
        endIndex = 0
        self.updateLabelText()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        speakBtn.setTitle("暂停", for: UIControlState.normal)
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let str = (utterance.speechString as NSString).substring(with: characterRange)
        
        print(characterRange, str)
        if characterRange.location == 0 {
            startIndex = 0;
        } else if characterRange.location == endIndex {
            
        } else {
            startIndex = characterRange.location
        }
        endIndex = characterRange.location + characterRange.length
        
        self.updateLabelText()
    }
    
    func updateLabelText() {
        if endIndex > 0 {
            let str = NSMutableAttributedString (string: content)
            str.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: NSMakeRange(startIndex, endIndex - startIndex))
            textLabel.attributedText = str
        } else {
            textLabel.attributedText = nil
            textLabel.text = content
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         var button = UIButton(type:UIButtonType.system)
         //var button = UIButton(type:UIButtonType.custom)
         //button.setImage(UIImage(named:"图片名"), for: UIControlState.init(rawValue: 0))
         button.frame=CGRect(x:Int(screen_width-70), y:100+80*3+60, width:50, height:30)
         button.setTitle("登录", for: UIControlState.init(rawValue: 0))
         button.setTitleColor(UIColor.init(red: 236/255.0, green: 145/255.0, blue: 24/255.0, alpha: 1.0), for: UIControlState.init(rawValue: 0))
         button.backgroundColor=UIColor.clear
         button.addTarget(self, action: #selector(self.pushToLogin), for: UIControlEvents.touchUpInside)
         //带参数的写法
         //button.addTarget(self, action:#selector(selectQuestion(_:)), for: UIControlEvents.touchUpInside)
         button.titleLabel?.font=UIFont.systemFont(ofSize: 12)
         self.view.addSubview(button)
         */
        
        self.view.backgroundColor = UIColor.white
        
        content = "静夜思\n\n" + "床前明月光，\n疑是地上霜；\n举头望明月，\n低头思故乡。"
        
        textLabel.textColor = UIColor.red
        textLabel.text = content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
