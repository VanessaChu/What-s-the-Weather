//
//  ViewController.swift
//  Whats the Weather
//
//  Created by Vanessa Chu on 2017-06-27.
//  Copyright © 2017 Vanessa Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityField: UITextField!
    @IBOutlet var weatherMsg: UILabel!
    
    @IBAction func getWeather(_ sender: Any) {
        var message: String = ""
        
        if let userEnteredCity = cityField.text{
            let newCity = userEnteredCity.replacingOccurrences(of: " ", with: "-")
            let myUrl = "http://weather-forecast.com/locations/" + newCity + "/forecasts/latest"
            if let url = URL(string: myUrl){
                let request = NSMutableURLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request as URLRequest){
                    data, response, error in
                    
                    if error != nil{
                        print(error)
                    }else{
                        if let unwrappedData = data{
                            let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                            
                            if let content = dataString?.components(separatedBy: stringSeparator){
                                //print(content[1])
                                if content.count > 1{
                                    stringSeparator = "</span>"
                                    let newContent = content[1].components(separatedBy: stringSeparator)
                                    if newContent.count > 0{
                                        message = newContent[0]
                                        message = message.replacingOccurrences(of: "&deg;", with: "°")
                                    }
                                }
                            }
                        }
                    }
                    
                    if message == ""{
                        message = "Weather cannot be found. Try again."
                    }
                    DispatchQueue.main.sync(execute: {
                        self.weatherMsg.text = message
                    })
                    
                }
                task.resume()
            }else{
                self.weatherMsg.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

