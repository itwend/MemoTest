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

    let cellId = "RecordsCell"
    var modelController: ModelController!
    var player: Player!
    var recorder: Recorder!
    var fileSteer: FileSteer!
    var microphone: Microphone!
    var tempIndexPath: IndexPath?
    var _fetchedResultsController: NSFetchedResultsController<Sound>? = nil
    var fetchedResultsController: NSFetchedResultsController<Sound> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<Sound> = Sound.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = StorageDataSource.shared.persistentContainer.viewContext
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: context,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memos"
        recordView.layer.cornerRadius = 10
        setupTableViewStyle()
        setupObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        microphone.checkMicrophonePermission(completion: nil)
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
    
    //MARK:- Objects
    
    func setupObjects() {
        recorder = modelController.recorder
        player = modelController.player
        fileSteer = modelController.fileSteer
        microphone = modelController.microphone
        microphone.delegate = self
    }
    
    //MARK:- Recorder
    
    func startRecord() {
        let uuid = UUID().uuidString + ".m4a"
        recorder.recordId = uuid
        recorder.delegate = self
        do {
            try self.recorder.record(to: uuid)
            showRecordImage(true)
            tableView.isUserInteractionEnabled = false
        } catch {
            print(error)
        }
    }
    
    func stopRecord() {
        recorder.stop()
        showRecordImage(false)
        tableView.isUserInteractionEnabled = true
    }
    
    //MARk:- Player
    
    func startPlay(_ sender: UIButton) {
        let sound = selectedSound(sender)
        if let soundId = sound.id {
            let filePath = fileSteer.documentsDirectory() + soundId
            if let url = URL.init(string: filePath) {
                player.startPlay(filePath: url)
                player.delegate = self
                recordView.isUserInteractionEnabled = false
            }
        }
    }
    
    func stopPlay() {
        player.stopPlay()
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
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecordsCell
        cell.selectionStyle = .none
        cell.delegateCell = self
        let sound = fetchedResultsController.object(at: indexPath)
        cell.configureCell(sound: sound)
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
                self.fileSteer.removeFileFromDirectory(id, completion: {
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
            let newRecord = Record()
            newRecord.id = self.recorder.recordId!
            newRecord.name = text!
            newRecord.duration = String(format: "%.0fs",AudioManager.audioDuration(for: self.recorder.recordUrl!))
            newRecord.date = Date()
            StorageDataSource.shared.saveSound(record: newRecord)
        }) {
            self.fileSteer.removeFileFromDirectory(self.recorder.recordId!, completion: nil)
        }
    }
}

extension RecordsViewController: PlayerDelegate {
    
    func didFinishPlaying() {
        tempIndexPath = nil
        tableView.reloadData()
        recordView.isUserInteractionEnabled = true
    }
}

extension RecordsViewController: MicrophoneDelegate {
    
    func showPermissionAlert() {
        UIAlertController.showSimple(self, title: "Microphone Access", message: "Memos cannot record your voice without Microphone Permission. Go to your device Settings and then Privacy to grant permission.") {
            let settingUrl = URL(string:String(format:"%@BundleID",UIApplication.openSettingsURLString))
            if UIApplication.shared.canOpenURL(settingUrl!) {
                UIApplication.shared.open(settingUrl!, completionHandler: nil)
            }
        }
    }
}
