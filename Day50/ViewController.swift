//
//  ViewController.swift
//  Day50
//
//  Created by Peter Salz on 29.03.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate
{
    var images = [Image]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                                            target: self,
                                                            action: #selector(takePhoto))
        
        if let archivedData = UserDefaults.standard.object(forKey: "images") as? Data
        {
            let jsonDecoder = JSONDecoder()
            
            if let unarchivedData = try? jsonDecoder.decode([Image].self, from: archivedData)
            {
                images = unarchivedData
                tableView.reloadData()
            }
        }
    }

    @objc func takePhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let image = images[indexPath.row]
        
        cell.textLabel?.text = image.caption
        
        let path = Helper.getDocumentsDirectory().appendingPathComponent(image.image)
        
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        {
            vc.image = images[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            // handle delete (by removing the data from your array and updating the tableview)
            try? FileManager.default.removeItem(at: Helper.getDocumentsDirectory().appendingPathComponent(images[indexPath.row].image))
            images.remove(at: indexPath.row)
            tableView.reloadData()
            
            saveDataToDefaults()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Helper.getDocumentsDirectory().appendingPathComponent(imageName)
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Enter",
                                   style: .default,
                                   handler:
                                   {    [weak self, weak ac] _ in
                                    
                                        if let jpegData = image.jpegData(compressionQuality: 0.8)
                                        {
                                            try? jpegData.write(to: imagePath)
                                        }
                                    
                                        if let caption = ac?.textFields?[0].text
                                        {
                                            let image = Image(caption: caption, image: imageName)
                                            self?.images.insert(image, at: 0)
                                            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                                       with: .automatic)
                                            
                                            self?.saveDataToDefaults()
                                        }
                                   }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
        present(ac, animated: true)
    }
    
    func saveDataToDefaults()
    {
        let jsonEncoder = JSONEncoder()
        
        if let archivedData = try? jsonEncoder.encode(images)
        {
            let defaults = UserDefaults.standard
            
            defaults.set(archivedData, forKey: "images")
        }
    }
}

