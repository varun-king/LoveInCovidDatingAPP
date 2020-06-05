//
//  RandomPersonViewController.swift
//  LoveInCovid
//
//  Created by Parrot on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class RandomPersonViewController: UIViewController, AVAudioPlayerDelegate {
    
    // ----------
    // MARK: Outlets
    // ----------
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var greenOutlet: UIView!
    var defaults:UserDefaults!
    var gender = ""
    var url = ""
    var count = 0
    var timer:Timer?
    var interest = ""
   
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    // MARK: IOS Lifecycle functions
    // ----------"
    func loadAudioFile(){
        let path = Bundle.main.url(forResource: "swipe2", withExtension: "mp3")
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: path!)
            self.audioPlayer.delegate = self as! AVAudioPlayerDelegate
            print("Successfully open file")
        }catch{
            print("Eroor opning audio audio")
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudioFile()
        self.defaults = UserDefaults.standard
        gender = self.defaults.string(forKey:"gender") ?? "Male"
        print("Gender is \(gender)")
        showPerson()
       url = "https://randomuser.me/api/?noinfo&gender=\(gender)"
        
        self.defaults.set("", forKey:"gender")
        var alo = alomafireFunc(url: url)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
     
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        greenOutlet.addGestureRecognizer(swipeRight)
        greenOutlet.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.right:
                //write your logic for right swipe
                print("Swiped right")
                 audioPlayer.play()
                
                 var alo = alomafireFunc(url: url)
                
                
                func randomNumber(probabilities: [Double]) -> Int {
                    
                    // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
                    let sum = probabilities.reduce(0, +)
                    // Random number in the range 0.0 <= rnd < sum :
                    let rnd = Double.random(in: 0.0 ..< sum)
                    // Find the first interval of accumulated probabilities into which `rnd` falls:
                    var accum = 0.0
                    for (i, p) in probabilities.enumerated() {
                        accum += p
                        if rnd < accum {
                            return i
                        }
                    }
                    // This point might be reached due to floating point inaccuracies:
                    return (probabilities.count - 1)
                }
                
                let x = randomNumber(probabilities: [0.33, 0.33, 0.33])
                if(x == 1){
                    interest = "like"
                    performSegue(withIdentifier: "chatControler", sender: self)
                }else if(x == 2){
                    interest = "dislike"
                    alomafireFunc(url: url)
                }else{
                   interest = "notSure"
                    performSegue(withIdentifier: "SendImageViewController", sender: self)
                }
               
                print(url)
                
                
            case UISwipeGestureRecognizer.Direction.left:
                //write your logic for left swipe
                print("Swiped left")
                 audioPlayer.play()
                count = count + 1
                print(count)
                var timerTic = 10
                if(count == 3){
                    
                    let box = UIAlertController(
                        title: "Wait for some time",
                        message: "You have to wait for 10 sec",
                        preferredStyle: .alert
                    )
                    
                    box.addAction(
                        UIAlertAction(title: "OK", style: .default, handler: {action in
                            
                        })
                    )
                    self.present(box, animated: true)
                    
                    DispatchQueue.global().sync {
                   
                        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                          //  timerTic = timerTic + 1
                            print(timer)
                            timerTic = timerTic - 1
                            self.resultsLabel.text = "\(timerTic)"
                            
                            if(timerTic == 0){
                                self.alomafireFunc(url: self.url)
                                self.count = 0
                                timerTic = 0
                                self.timer?.invalidate()
                            }
                            
                        }
                    }
                }
                 var alo = alomafireFunc(url: url)
                print(url)
            default:
                break
            }
        }
    }
   
    
    
    // ----------
    // MARK: Actions
    // ----------
   /* @IBAction func chatDebugButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
    */
    // ----------
    // MARK: Helper Functions
    // ----------
    func showPerson() {
        
        nameLabel.text = "Jane Smith"
        ageLabel.text = "25"
        photoImageView.image = UIImage(named:"41")
    }

    func alomafireFunc(url:String){
        Alamofire.request(url).responseJSON{
            (response) in
            //  debugPrint(response)
            let data = response.data!
            
         //   print(String(data: data, encoding: String.Encoding.utf8)!)
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                   // print(json)
                    let result = json["results"] as! [[String:Any]]
                    let dob = result[0]["dob"]! as![String:Any]
                    
                    let imagePth = result[0]["picture"]! as![String:String]
                    let fullURL = imagePth["large"]!
                    let name = result[0]["name"]! as![String:String]
                    let fullname = "\(name["title"]!) \(name["first"]!) \( name["last"]! )"
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = "\(fullname)"
                        self.ageLabel.text = "\(dob["age"]!)"
                        guard let imageURL = URL(string: fullURL) else { return }
                        
                        // just not to cause a deadlock in UI!
                        DispatchQueue.global().async {
                            guard let imageData = try? Data(contentsOf: imageURL) else { return }
                            
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.photoImageView.image = image
                            }
                        }
                        
                    }
                    
                    
                    
                }
            }
            catch{
                print(error)
            }
            
        }
    }
    



}
