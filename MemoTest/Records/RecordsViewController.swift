//
//  ViewController.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit
import CoreData

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var startRecordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var managedObjectContext: NSManagedObjectContext? = AppDelegate.instance.persistentContainer.viewContext

    var recorder: Recorder!
    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memos"
        recordView.layer.cornerRadius = 10
        createRecorder()
        setupTableViewStyle()
        
        print("url = \(recorder.url)")
        
    }
    
    func setupTableViewStyle() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func createRecorder() {
        recorder = Recorder()
        DispatchQueue.global().async {
            do {
                try self.recorder.prepareRecorder()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func startRecordButtonTouchUp(_ sender: Any) {
        do {
            try recorder.record()
        } catch {
            print(error)
        }
    }
    
    @IBAction func stopRecordButtonTouchUp(_ sender: Any) {
        recorder.stop()
    }

    @IBAction func playAudioButtonTouchUp(_ sender: Any) {
        
        player = Player.init(url: recorder.url)
        print("url = \(recorder.url)")

        player.play()
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Sound> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<Sound> = Sound.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: self.managedObjectContext!,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Sound>? = nil
    
}

extension RecordsViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsCell", for: indexPath) as! RecordsCell
//        cell.delegate = self
//        cell.delegateCell = self
//        cell.selectionStyle = .none
//        cell.indexPath = indexPath
        cell.selectionStyle = .none
        let sound = fetchedResultsController.object(at: indexPath)
        cell.dateLabel.text? = "\(String(describing: sound.date))"
        cell.durationLabel.text? = "\(String(describing: sound.duration))"
        cell.nameLabel.text = sound.name
        
//        cell.mergeButton.addTarget(self, action: #selector(showMergeView(sender:)), for: .touchUpInside)
//        //cell.mergeButton.isHidden = route.merge
//        if route.merge {
//            cell.mergeButton.isHidden = false
//        } else {
//            cell.mergeButton.isHidden = true
//        }
//
//        DrivesHelper.configureCell(cell, indexPath: indexPath, tableView: self.tableView, withRoute: route)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

extension RecordsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .top)

        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .bottom)

        case .update:
            print("update")
//            guard let cell: DrivesCell = tableView.cellForRow(at: indexPath!) as? DrivesCell else { return }
//            DrivesHelper.configureCell(cell, indexPath: indexPath!, tableView: self.tableView, withRoute: anObject as! Route)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
