//
//  ViewController.swift
//  URLSessionTemplate
//
//  Created by Unal Celik on 21.05.2021.
//

import UIKit
import URLSessionAPI

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func requestButton() {
        NetworkManager.shared.requestData(from: .photoOfToday,
                                          type: AstroPhotoResponse.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.textView.text = response.explanation
                    self.titleLabel.text = response.title
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}

