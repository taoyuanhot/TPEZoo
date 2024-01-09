//
//  ViewController.swift
//  TPEZoo
//
//  Created by 藍景鴻 on 2024/1/8.
//

import UIKit

class ViewControllerAreaCata: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndexRow:Int?
    
    // 將 MyJsonModule 實例作為屬性
    let jsonModuleZoo = MyJsonModuleZoo()
    
    @objc func handleRefresh() {
        // 設定下拉更新元件的文字說明
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
        
        // 使用 MyJsonModule 從 API 獲取數據，設定給 MyData
        jsonModuleZoo.fetchDataFromAPI {
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
        jsonModuleZoo.loadDataFromLocalFile()
        
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
        print("結束viewWillAppear")
        
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCataCell", for: indexPath)
        
        let exhibit = jsonModuleZoo.myZooData?.result.results[indexPath.row]
        
        // 建立 UIImageView 的物件
        let imageView = cell.viewWithTag(11) as! UIImageView
        
        // 設定 cellTitle 的文字為展示區名稱
        let cellTitle = cell.viewWithTag(12) as! UILabel
        cellTitle.text = exhibit?.eName ?? "N/A"
        
        // 設定 cellContent 的文字為展示區資訊
        let cellContent = cell.viewWithTag(13) as! UITextView
        cellContent.text = exhibit?.eInfo ?? "N/A"
        
        // 下載並設定圖片
        if let imageUrlString = exhibit?.ePicURL, let imageUrl = URL(string: imageUrlString) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let myData = jsonModuleZoo.myZooData {
            return myData.result.results.count
        } else {
            return 0
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
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedIndexRow = indexPath.row
        print(selectedIndexRow!)
        performSegue(withIdentifier: "segueToVCAreaInfo", sender: indexPath.row)
    }
    
    
    //MARK: - 傳送資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? ViewControllerAreaInfo {
            destinationVC.viewControllerAreaCata = self
        } else {
            print("Error: Failed to cast destinationVC as ViewControllerAreaInfo2")
        }
    }
}

