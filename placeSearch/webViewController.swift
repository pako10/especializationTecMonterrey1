//
//  webViewController.swift
//  proyectoFinalTec
//
//  Created by Francisco Humberto Andrade Gonzalez on 20/04/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
   
    @IBOutlet weak var urlSearch: UILabel!
    @IBOutlet weak var web: UIWebView!
    
    var urls : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Web Navegation"
        urlSearch?.text = urls!
        let url = NSURL(string: urls!)
        let peticion = NSURLRequest(URL: url!)
        web.loadRequest(peticion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     

}
