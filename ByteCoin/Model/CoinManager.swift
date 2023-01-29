//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
     
     func didUpdatePrice(price : String, currency: String)
     
     func didFailWithError(error :Error)
}


struct CoinManager {
     
     let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC" //?apikey=YOUR-KEY
     let apiKey = "5DE079C2-4D1D-4747-A160-623B13ED91B4"
     
     let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
     
     var delegate : CoinManagerDelegate?
     
     func getCoinPrice(for currency : String){
          
          let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
          
          //1.Create a URL
          if let url = URL(string: urlString) {
               //2. Create a URLSession
               let session = URLSession(configuration: .default)
               //3. Give the session a Task
               let task = session.dataTask(with: url) { data, response, error in
                    if error != nil{
                         print(error!)
                         return//exit out of this function dont do anything
                    }
                    
                    if let safeData = data{
                         if let bitcoinPrice = self.parseJSON(safeData){
                              let priceString = String(format: "%.2f", bitcoinPrice)
                              
                              self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                         }
                    }
               }
               //4. Start the task
               task.resume()
          }
          
          
     }
     func parseJSON(_ data: Data) -> Double?{
          let decoder = JSONDecoder()
          do{
               let decodedData = try decoder.decode(CoinData.self, from: data )
               let lastPrice = decodedData.rate
               print(lastPrice)
               return lastPrice
               
          } catch{
               delegate?.didFailWithError(error: error)
               return nil
          }
     }
}







