import Foundation

struct MyZooData: Codable {
    
    let result: Result
    
    struct ImportDate: Codable {
        let date: String
        let timezone_type: Int
        let timezone: String
    }

    struct Exhibit: Codable {
        let id: Int
        let importDate: ImportDate
        let eNo: String
        let eCategory: String
        let eName: String
        let ePicURL: String
        let eInfo: String
        let eMemo: String
        let eGeo: String
        let eURL: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case importDate = "_importdate"
            case eNo = "e_no"
            case eCategory = "e_category"
            case eName = "e_name"
            case ePicURL = "e_pic_url"
            case eInfo = "e_info"
            case eMemo = "e_memo"
            case eGeo = "e_geo"
            case eURL = "e_url"
        }
    }

    struct Result: Codable {
        let limit: Int
        let offset: Int
        let count: Int
        let sort: String
        let results: [Exhibit]
    }
    
}



class MyJsonModuleZoo {
    
    var myZooData: MyZooData?
    
    init() {
        fetchDataFromAPI {
            print("完成fetchDataFromAPI")
        }
    }
    
    // 從 API 取得資料
    func fetchDataFromAPI(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://data.taipei/api/v1/dataset/5a0e5fbb-72f8-41c6-908e-2fb25eff9b8a?scope=resourceAquire") else {
            return
        }
        
        // 進行 API 請求
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                // 處理錯誤
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(MyZooData.self, from: data)
                // 賦值給 myData 屬性
                self.myZooData = decodedData
                print("jsonModuleZoo.fetchDataFromAPI Done")
                // 完成後呼叫閉包
                completion()
            } catch {
                // 處理解碼錯誤
                print("JSON 解碼錯誤：\(error)")
            }
        }.resume()
    }

    // FileManager 類別將解碼後的資料寫入本地檔案
    func saveDataLocally(_ data: MyZooData?) {
        guard let data = data else {
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let archiveURL = documentsDirectory.appendingPathComponent("myZooData.json")
            
            try encodedData.write(to: archiveURL, options: .noFileProtection)
            print("資料已儲存在本地：\(archiveURL)")
        } catch {
            print("資料儲存錯誤：\(error)")
        }
    }

    // 讀取本地資料
    func loadDataFromLocalFile(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("myZooData.json")

        do {
            let data = try Data(contentsOf: archiveURL)
            let decodedData = try JSONDecoder().decode(MyZooData.self, from: data)
            self.myZooData = decodedData
            print("jsonModuleZoo.loadDataFromLocalFile Done")
        } catch {
            print("讀取本地資料錯誤：\(error)")
        }
    }
    
    
}






//{
//  "result": {
//    "limit": 20,
//    "offset": 0,
//    "count": 16,
//    "sort": "",
//    "results": [
//      {
//        "_id": 1,
//        "_importdate": {
//          "date": "2022-05-09 14:47:38.971190",
//          "timezone_type": 3,
//          "timezone": "Asia/Taipei"
//        },
//        "e_no": "1",
//        "e_category": "戶外區",
//        "e_name": "臺灣動物區",
//        "e_pic_url": "http://www.zoo.gov.tw/iTAP/05_Exhibit/01_FormosanAnimal.jpg",
//        "e_info": "臺灣位於北半球，北迴歸線橫越南部，造成亞熱帶溫和多雨的氣候。又因高山急流、起伏多樣的地形，因而在這蕞爾小島上，形成了多樣性的生態系，孕育了多種不同生態習性的動、植物，豐富的生物物種共存共榮於此，也使臺灣博得美麗之島「福爾摩沙」的美名。臺灣動物區以臺灣原生動物與棲息環境為展示重點，佈置模擬動物原生棲地之生態環境，讓動物表現如野外般自然的生活習性，引導民眾更正確地認識本土野生動物，為園區環境教育的重要據點。藉由提供動物寬廣且具隱蔽的生態環境，讓動物避開人為過度的干擾，並展現如野外般自然的生活習性和行為。展示區以多種臺灣的保育類野生動物貫連成保育廊道，包括臺灣黑熊、穿山甲、歐亞水獺、白鼻心、石虎、山羌等。唯有認識、瞭解本土野生動物，才能愛護、保育牠們，並進而珍惜我們共同生存的這塊土地！",
//        "e_memo": "",
//        "e_geo": "MULTIPOINT ((121.5805931 24.9985962))",
//        "e_url": "https://youtu.be/QIUbzZ-jX_Y"
//      },
//      {
//        "_id": 2,
//        "_importdate": {
//          "date": "2022-05-09 14:47:38.973108",
//          "timezone_type": 3,
//          "timezone": "Asia/Taipei"
//        },
//        "e_no": "2",
//        "e_category": "戶外區",
//        "e_name": "兒童動物區",
//        "e_pic_url": "http://www.zoo.gov.tw/iTAP/05_Exhibit/02_ChildrenZoo.jpg",
//        "e_info": "自有人類文明發展以來，動物以及自然與人類的關係便開始有著多樣動態的平衡，有的時候是動物傷害人類，有的時候是大自然對人類濫用資源的反撲，但多半時候都是人類因不同的目的而使用動物。兒童區的展示邏輯希望能讓遊客在與動物最近的距離重新檢視人與動物的關係。\n兒童動物區的設計以「學習園地」為主軸，內有可愛動物、農村動物、農村生態等展示區，其中包含了農村常見的家禽如鴨、雞；家畜如羊駝、迷你馬等，這些動物都是早經人類馴服及利用，對人類文明的發展貢獻很大。簡單來說，將「生態教育」融入農村風景中是兒童動物區展示的特色。\n兒童區的多樣物種展示，包括作物生態展示、農莊動物展示區、小型食肉目動物展示區、靈長類區、外來種區以及動物行為學院，就是依循著人類與動物關係的演變而規劃的展示。其中農莊相關展示除了不定期的稻作及水車展現臺灣先民以農立國的精神外，也讓都市人可以體驗實際鄉村的生活情懷。家禽區的開放展示讓遊客在兒童區漫步時，得以有不定期與雞鴨鵝群相遇的驚喜。走入式有蹄動物配合定時餵食讓遊客可以更近距離觀察奇蹄與偶蹄目的外觀差異。靈長類區則有著非洲舊世界猴與冠鶴的混種展示。\n為了加深民眾對於野生動物的瞭解，原來的兒童劇場改造後落成的「動物行為學院」，搭配「動物空中走道」銜接戶外活動場，動物可由此處自行進入學院內，未來民眾將有更多的機會近距離觀察與認識動物。除此之外，在廊道的中途設置了精巧可愛的樹屋，吸引動物在此停留，記得?起頭看看上方的廊道，或許剛好有狐猴經過，就能以不同的角度，欣賞牠們身手矯健的身影唷！",
//        "e_memo": "",
//        "e_geo": "MULTIPOINT ((121.5819383 24.9989718))",
//        "e_url": "https://youtu.be/CC4dlmRIVls"
//      }
//    ]
//  }
//}



