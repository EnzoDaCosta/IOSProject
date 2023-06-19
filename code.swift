import Foundation

class MeteoGlobal: Decodable {

    let hourly: [HourlyWeather]
    let daily: [DailyWeather]

}

class MeteoHoraire: Decodable {

    let time: Date
    let temperature: Double    

}

class MeteoQuotidienne: Decodable {

    let time: Date
    let weatherCode: string

}

func dataMeteo(for city: string, completion: @escaping (WeatherData?) -> void) {
    guard let encodedCity = city.addingPercentEncoding(withAllowedChracters: .urlQueryAllowed),
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=48.80&longitude=2.13&hourly=temperature_2m,relativehumidity_2m,dewpoint_2m,apparent_temperature,precipitation_probability,rain,weathercode,surface_pressure,visibility,windspeed_10m,winddirection_10m&daily=weathercode&timezone=Europe%2FLondon")
    
    else {
       completion(nil)
       return 
    }

    URLSession.shared.dataTask(with: url) {(data, responce, error) in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .secondSince1970

        do{
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            completion(weatherData)
        }catch{
            print("Erreur de decodage : \(error)")
            completion(nil)
        }
    }.resume()
}
dataMeteo(for: "paris") { weatherData in 
    if let weatherData = weatherData {
        print(weatherData.hourly)
        print(weatherData.daily)
    } else {
        print("Nous n'avons pas reussi a recupere la météo")
        
    }
}