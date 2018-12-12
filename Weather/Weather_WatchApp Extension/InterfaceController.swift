//
//  InterfaceController.swift
//  Weather_WatchApp Extension
//
//  Created by Mayuko Inoue on 2/20/17.
//  Copyright © 2017 mayuko. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

  @IBOutlet var locationLabel: WKInterfaceLabel!
  @IBOutlet var forecastLabel: WKInterfaceLabel!
  @IBOutlet var tempLabel: WKInterfaceLabel!
  @IBOutlet var forecastImage: WKInterfaceImage!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Orlando,us&units=imperial&appid=f31bcc217a20fabdd80f0a391bb4ad4e")
    
    let task = session.dataTask(with: url!) { (data, response, error) -> Void in
        do {
          if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
            //Set the location label
            let dataDict = json as! [String : Any]
            self.locationLabel.setText(dataDict["name"] as? String)

            //Set the forecast image
            let weatherDict = dataDict["weather"] as? [[String: Any]]
            let weatherID = weatherDict?[0]["id"] as! Double
            if(weatherID == 800) { //clear
              self.forecastImage.setImage(UIImage(named: "sunny"))
            } else if(weatherID / 100 == 5) { //rain
              self.forecastImage.setImage(UIImage(named: "rainy"))
            } else if(weatherID / 100 == 8) { //clouds
              self.forecastImage.setImage(UIImage(named: "cloudy"))
            }
            
            //Set the forecast label
            self.forecastLabel.setText(weatherDict?[0]["description"] as! String?)

            //Set the temperature label
            let mainDict = dataDict["main"] as? [String: Any]
            let temperature = mainDict?["temp"] as! Double
            self.tempLabel.setText("\(temperature) °F")
            //Set the label color based on the temperature
            if(temperature > 50) {
              self.tempLabel.setTextColor(UIColor.orange)
            } else {
              self.tempLabel.setTextColor(UIColor.cyan)
            }
            
          }
        } catch let error as NSError {
          print(error.localizedDescription)
        }
    }
    task.resume()
  }
}
