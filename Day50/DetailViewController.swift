//
//  DetailViewController.swift
//  Day50
//
//  Created by Peter Salz on 29.03.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet var imageView: UIImageView!
    
    var image: Image!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = image.caption
        
        let path = Helper.getDocumentsDirectory().appendingPathComponent(image.image)
        
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
