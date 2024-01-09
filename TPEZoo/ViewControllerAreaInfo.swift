//
//  ViewControllerAreaInfo2.swift
//  TPEZoo
//
//  Created by 藍景鴻 on 2024/1/9.
//

import UIKit

class ViewControllerAreaInfo: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //用來紀錄點選哪一個Index.row
    var selectedIndexRow:Int!
    
    //接收從ViewControllerAreaCata來的資訊
    var viewControllerAreaCata:ViewControllerAreaCata!
    // 建立篩選過的 results: [MyAnimalData.Animal] 清單
    var arrayFilterResults: [MyAnimalData.Animal] = []
    
    
    // 將 MyJsonModule 實例作為屬性
    let jsonModuleAnimal = MyJsonModuleAnimal()
    
    @objc func handleRefresh() {
        // 設定下拉更新元件的文字說明
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
        
        // 使用 MyJsonModule 從 API 獲取數據，設定給 MyData
        jsonModuleAnimal.fetchDataFromAPI {
            // 資料已經獲取，重新刷新表格
            DispatchQueue.main.async {
                self.tableView.reloadData()
                // 結束下拉更新元件的動畫
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("開始viewDidLoad")
        // 使用 MyJsonModule 從 local取得數據
        jsonModuleAnimal.loadDataFromLocalFile()
        //初始化下拉更新元件
        let refreshControl = UIRefreshControl()
        //綁定對應的value changed事件到下拉更新元件
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //將製作完成的下拉更新元件設定給表格的對應屬性
        tableView.refreshControl = refreshControl
        
        //指定tableView的代理事件和資料來源事件都實作在此類別
        tableView.delegate = self
        tableView.dataSource = self
        print("結束viewDidLoad")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("開始viewWillAppear")
        tableView.reloadData()
        print(viewControllerAreaCata.selectedIndexRow!)
        
        //設定Title
        if let selectedIndex = viewControllerAreaCata.selectedIndexRow {
            let selectedExhibit = viewControllerAreaCata.jsonModuleZoo.myZooData?.result.results[selectedIndex]

            if let exhibit = selectedExhibit {
                labelTitle.text = exhibit.eName
            } else {
                print("Error: Selected exhibit is nil")
            }
        } else {
            print("Error: selectedIndexRow is nil")
        }
        print("結束viewWillAppear")
        
        //篩選arrayFilterResults: [MyAnimalData.Animal]
        filterResults()
        
    }
    
    func filterResults() {
        // 篩選目標
        let targetResults = jsonModuleAnimal.myAnimalData?.result.results ?? []
        //篩選規則
        if let selectedIndex = viewControllerAreaCata.selectedIndexRow {
            let selectedExhibit = viewControllerAreaCata.jsonModuleZoo.myZooData?.result.results[selectedIndex]

            if let exhibit = selectedExhibit {
                let filerName = exhibit.eName
                arrayFilterResults = targetResults.filter { animal in
                    return animal.a_location == filerName
                }
            } else {
                print("Error: Selected exhibit is nil")
            }
        } else {
            print("Error: selectedIndexRow is nil")
        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AreaInfoCell", for: indexPath)
            
            let imageView = cell.viewWithTag(21) as! UIImageView
            if let imageUrlString = viewControllerAreaCata.jsonModuleZoo.myZooData?.result.results[viewControllerAreaCata.selectedIndexRow!].ePicURL, let imageUrl = URL(string: imageUrlString) {
                downloadImage(from: imageUrl) { (image) in
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            } else {
                // 如果 ePicURL 為 nil，或者 URL 轉換失敗，設定一個預設圖片或者處理其他邏輯
                imageView.image = UIImage(named: "failed")
            }
            
            let cellContent = cell.viewWithTag(22) as! UITextView
            cellContent.text = viewControllerAreaCata.jsonModuleZoo.myZooData?.result.results[viewControllerAreaCata.selectedIndexRow!].eInfo
            
            let cellButton = cell.viewWithTag(23) as! UIButton
            cellButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCataCell", for: indexPath)
            
            let exhibit = arrayFilterResults[indexPath.row]
            
            // 建立 UIImageView 的物件
            let imageView = cell.viewWithTag(24) as! UIImageView
            
            // 設定 cellTitle 的文字為展示區名稱
            let cellTitle = cell.viewWithTag(25) as! UILabel
            cellTitle.text = exhibit.a_name_ch 
            
            // 設定 cellContent 的文字為展示區資訊
            let cellContent = cell.viewWithTag(26) as! UITextView
            cellContent.text = exhibit.a_alsoknown 
            
            // 下載並設定圖片
            let imageUrlString = (exhibit.a_pic01_url)
            if let imageUrl = URL(string: imageUrlString) {
                downloadImage(from: imageUrl) { (image) in
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            } else {
                // 如果 ePicURL 為 nil，或者 URL 轉換失敗，設定一個預設圖片或者處理其他邏輯
                imageView.image = UIImage(named: "failed")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return arrayFilterResults.count
        }
    }
    
    // 用於打開URL的方法
    @objc func openURL() {
        if let targetResults = viewControllerAreaCata.jsonModuleZoo.myZooData?.result.results[viewControllerAreaCata.selectedIndexRow!] {
            if let url = URL(string: targetResults.eURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

    }
    
    // 下載圖片的函數
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 0.1  // 設定超時時間
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(UIImage(named: "failed"))
            }
        })
        task.resume()
    }
    

    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else {
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(indexPath.section == 0) {
            selectedIndexRow = indexPath.row
            performSegue(withIdentifier: "segueToVCAnimalInfo", sender: nil)
        }
    }
    
    //MARK: - HeaderOfSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white // 設置 header 的背景顏色

            let titleLabel = UILabel()
            titleLabel.text = "動物資料" // 設置 header 的標題文字
            titleLabel.textColor = UIColor.black // 設置文字顏色
            titleLabel.frame = CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 30)

            headerView.addSubview(titleLabel)

            return headerView
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40.0
    }
    
    
    //MARK: - 傳送資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? ViewControllerAnimalInfo {
            destinationVC.viewControllerAreaInfo = self
        } else {
            print("Error: Failed to cast destinationVC as ViewControllerAreaInfo2")
        }
    }

    //MARK: - 返回頁面
    @IBAction func clickButtonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
