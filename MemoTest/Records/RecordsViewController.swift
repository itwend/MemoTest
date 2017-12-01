//
//  ViewController.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var managedObjectContext: NSManagedObjectContext? = AppDelegate.instance.persistentContainer.viewContext
    let fileManager = FileManager.default
    var audioPlayer: AVAudioPlayer?
    var recorder: Recorder!
    var tempIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memos"
        recordView.layer.cornerRadius = 10
        setupTableViewStyle()
        recorder = Recorder(to: "")
        recorder.state = .stop
        
        AppDelegate.instance.microphonePermssonCallBack = { [unowned self] allowed in
            UIAlertController.showSimple(self, title: "Enable Microphone Access", message: "Memos cannot record your voice without Microphone Permission. Go to your device Settings and then Privacy to grant permission.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.instance.checkMicrophonePermission(completion: nil)
    }
    
    //MARK:- Actions
    
    @IBAction func recordButtonTouchUp(_ sender: Any) {
        switch recorder.state {
        case .record:
            stopRecord()
        case .stop:
            startRecord()
        }
    }
    
    //MARK:- Recorder
    
    func startRecord() {
        tableView.isUserInteractionEnabled = false
        createRecorder()
        do {
            try recorder.record()
            showRecordImage(true)
        } catch {
            print(error)
        }
    }
    
    func stopRecord() {
        tableView.isUserInteractionEnabled = true
        recorder.stop()
        showRecordImage(false)
    }
    
    func createRecorder() {
        let uuid = UUID().uuidString + ".m4a"
        print("generate = \(uuid)")
        recorder = Recorder(to: uuid)
        recorder.recordId = uuid
        recorder.delegate = self
        DispatchQueue.global().async {
            do {
                try self.recorder.prepareRecorder()
            } catch {
                print(error)
            }
        }
    }
    
    //MARK:- UI
    
    func showRecordImage(_ show: Bool) {
        if show {
            recordButton.setImage(#imageLiteral(resourceName: "stopRecord"), for: .normal)
        } else {
            recordButton.setImage(#imageLiteral(resourceName: "record"), for: .normal)
        }
    }
    
    func setupTableViewStyle() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
    
    //MARK:- Documents
    
    func documentsDirectory() -> String {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return ""
        }
        return "\(dirPath)/"
    }
    
    func removeFileFromDirectory(_ id: String ,completion: (() -> Void)?) {
        let filePath = documentsDirectory() + id
        do {
            try fileManager.removeItem(atPath: filePath)
            completion?()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    //MARk:- Player
    
    func startPlay(_ sender: UIButton) {
        let sound = selectedSound(sender)
        if let soundId = sound.id {
            let filePath = documentsDirectory() + soundId
            if let url = URL.init(string: filePath) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.delegate = self
                    audioPlayer?.play()
                    recordView.isUserInteractionEnabled = false
                } catch {
                    print("couldn't load file")
                }
            }
        }
    }
    
    func stopPlay() {
        audioPlayer?.stop()
        tempIndexPath = nil
        tableView.reloadData()
        recordView.isUserInteractionEnabled = true
    }
    
    func selectedSound(_ sender: UIButton) -> Sound {
        let indexPath = selectedIndexPath(sender)
        let sound = fetchedResultsController.object(at: indexPath)
        return sound
    }
    
    func selectedIndexPath(_ sender: UIButton) -> IndexPath {
        let buttonPosition: CGPoint = sender.convert(.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        return indexPath!
    }
    
    func selectedCell(indexPath: IndexPath) -> RecordsCell {
        let cell = self.tableView.cellForRow(at: indexPath) as! RecordsCell
        return cell
    }

}

extension RecordsViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsCell", for: indexPath) as! RecordsCell
        cell.selectionStyle = .none
        cell.delegateCell = self
        let sound = fetchedResultsController.object(at: indexPath)
        cell.dateLabel.text? = Date.dateWithDayMonthYear(date: sound.date!)
        cell.durationLabel.text? = Date.dateWithTime24(date: sound.duration!)
        cell.nameLabel.text = sound.name
        if tempIndexPath == indexPath {
            cell.isPlaying = true
        } else {
            cell.isPlaying = false
        }
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
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension RecordsViewController: RecordsCellDelegate {
    
    func playSound(sender: UIButton) {
        let indexPath = selectedIndexPath(sender)
        let cell = selectedCell(indexPath: indexPath)
        if (cell.isPlaying) {
            stopPlay()
            cell.isPlaying = false
        } else {
            startPlay(sender)
            cell.isPlaying = true
            tempIndexPath = selectedIndexPath(sender)
            tableView.reloadData()
        }
    }
    
    func removeSound(sender: UIButton) {
        UIAlertController.showSimple(self, title: "Delete Recording", message: "Are you sure you want to this record?", firstButtonTitle: "Cancel", firstButtonAction: {
            
        }, secondButtonTitle: "Delete") {
            let sound = self.selectedSound(sender)
            if let id = sound.id {
                self.removeFileFromDirectory(id, completion: {
                    StorageDataSource.shared.removeSound(sound)
                    if self.tempIndexPath != nil {
                        self.stopPlay()
                    }
                })
            }
        }
    }
}

extension RecordsViewController: RecorderDelegate {
    
    func didFinishRecording() {
        UIAlertController.showWithTextField("", placeholder: "Enter record name", keyboardType: .default, target: self, title: "Save audio record", submitButtonTitle: "Save", submitButtonAction: { (text) in
            StorageDataSource.shared.saveSound(date: Date(), name: text! , duration: Date(), id: self.recorder.recordId!)
        }) {
            self.removeFileFromDirectory(self.recorder.recordId!, completion: nil)
        }
    }
}

extension RecordsViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        tempIndexPath = nil
        tableView.reloadData()
        recordView.isUserInteractionEnabled = true
    }
}
