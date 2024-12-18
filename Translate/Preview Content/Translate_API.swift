import Foundation

struct YandexTranslateAPI {
    let apiKey = "dict.1.1.20241211T095844Z.e92af53b4d795aa9.97aa415ef1fae5f71c9e68572db548a7e47b6483" // Replace with your valid API key
    
    // Detect Language Function
    func detectLanguage(for text: String, completion: @escaping (String?) -> Void) {
        var components = URLComponents(string: "https://translate.yandex.net/api/v1.5/tr.json/detect")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "text", value: text)
        ]
        
        guard let detectURL = components?.url else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: detectURL) { data, _, error in
            if let error = error {
                print("Error detecting language: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let detectedLanguage = response?["lang"] as? String
                completion(detectedLanguage)
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    // Translate Function
    func translate(text: String, to targetLang: String, from sourceLang: String? = nil, completion: @escaping (String?) -> Void) {
        var components = URLComponents(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")
        var langParameter = targetLang
        if let sourceLang = sourceLang {
            langParameter = "\(sourceLang)-\(targetLang)"
        }
        
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "lang", value: langParameter)
        ]
        
        guard let translateURL = components?.url else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: translateURL) { data, _, error in
            if let error = error {
                print("Error translating text: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let translations = response?["text"] as? [String] {
                    completion(translations.first)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
