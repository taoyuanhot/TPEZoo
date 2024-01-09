//
//  ViewControllerAnimalInfo.swift
//  TPEZoo
//
//  Created by 藍景鴻 on 2024/1/9.
//

import UIKit

class ViewControllerAnimalInfo: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewControllerAreaInfo:ViewControllerAreaInfo!
    let contentHeight: CGFloat = 600.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定 UIScrollView 的內容大小
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
        
        // 設定 UIStackView 的高度約束
        stackView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //設定Title
        if let selectedIndex = viewControllerAreaInfo.selectedIndexRow {
            let selectedAnimal = viewControllerAreaInfo.arrayFilterResults[selectedIndex]
            labelTitle.text = selectedAnimal.a_name_ch
        } else {
            print("Error: selectedIndexRow is nil")
        }
        
        // 設定Label & TextView
        addLabelsToStackView()
        
        // 下載並設定圖片
        if let selectedIndex = viewControllerAreaInfo.selectedIndexRow {
            let selectedAnimal = viewControllerAreaInfo.arrayFilterResults[selectedIndex]
            let imageUrlString = selectedAnimal.a_pic01_url
            if let imageUrl = URL(string: imageUrlString) {
                downloadImage(from: imageUrl) { (image) in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            } else {
                self.imageView.image = UIImage(named: "failed")
            }
        } else {
            print("Error: selectedIndexRow is nil")
        }
    }
    
    func setNewLabel(_ name:String,_ text:String){
        let name = UILabel()
        name.text = text
        stackView.addArrangedSubview(name)
    }
    
    func setNewTextView(_ name:String,_ text:String){
        let name = UITextView()
        name.text = text
        name.isEditable = false
        stackView.addArrangedSubview(name)
    }
    
    
    
    
    func addLabelsToStackView() {
        if let selectedIndex = viewControllerAreaInfo.selectedIndexRow {
            let selectedAnimal = viewControllerAreaInfo.arrayFilterResults[selectedIndex]
            
            setNewLabel("nameLabel", "名稱：\(selectedAnimal.a_name_ch)")
            
            setNewLabel("namelatinLabel", "學名：\(selectedAnimal.a_name_latin)")
            
            setNewLabel("alsoknownLabel", "別名：\(selectedAnimal.a_alsoknown)")
            
            setNewLabel("familyLabel", "分類：\(selectedAnimal.a_phylum)-\(selectedAnimal.a_class)-\(selectedAnimal.a_order)-\(selectedAnimal.a_family)")
            
            setNewLabel("conservationLabel", "分級：\(selectedAnimal.a_conservation)")
            
            setNewLabel("distributionLabel", "分佈：")
            setNewTextView("distributionTextField", selectedAnimal.a_distribution)
            
            setNewLabel("habitatLabel", "棲息地：")
            setNewTextView("habitatTextField", selectedAnimal.a_habitat)
            
            setNewLabel("featureLabel", "特徵：")
            setNewTextView("featureTextField", selectedAnimal.a_feature)
            
            setNewLabel("behaviorLabel", "行為：")
            setNewTextView("behaviorTextField", selectedAnimal.a_behavior)
            
            setNewLabel("dietLabel", "飲食：")
            setNewTextView("dietTextField", selectedAnimal.a_diet)
            
            setNewLabel("crisisLabel", "風險：")
            setNewTextView("crisisTextField", selectedAnimal.a_crisis)
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
    
    
    @IBAction func clickButtonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
