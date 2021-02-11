//
//  ViewController.swift
//  ScreenieApp
//
//  Created by Maksim on 04.02.2021.
//

import UIKit
import ReplayKit
//import AVFoundation

class ViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var imagePicker: UISegmentedControl!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var micToggle: UISwitch!
    @IBOutlet weak var recordBtn: UIButton!
    
    var recorder = RPScreenRecorder.shared()
    private var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func togglePicked(_ sender: Any) {
    }
    
    @IBAction func imagePicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedImageView.image = UIImage(named: "skate")
        case 1: selectedImageView.image = UIImage(named: "food")
        case 2: selectedImageView.image = UIImage(named: "cat")
        case 3: selectedImageView.image = UIImage(named: "nature")
        default: selectedImageView.image = UIImage(named: "skate")
        }
    }
    
    @IBAction func recordBtnWasPressed(_ sender: Any) {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    func startRecording(){
        guard recorder.isAvailable else {
            print("Recording is not available at this time!")
            return
        }
        if micToggle.isOn {
            recorder.isMicrophoneEnabled = true
        } else {
            recorder.isMicrophoneEnabled = false
        }
        recorder.startRecording { (error) in
            guard error == nil else {
                print("Error while starting recording!")
                return
            }
            print("Start recording - success!")
            
            DispatchQueue.main.async {
                self.micToggle.isEnabled = false
                self.recordBtn.setTitleColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), for: .normal)
                self.recordBtn.setTitle("Stop", for: .normal)
                self.statusLbl.text = "Recording..."
                self.statusLbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                self.isRecording = true
            }
            
        }
    }
    
    func stopRecording(){
        recorder.stopRecording { (preview, error) in
            guard preview != nil else {
                print("preview error")
                return
            }
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit ?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.recorder.discardRecording {
                    print("deleted!")
                }
            }
            let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            }
            alert.addAction(deleteAction)
            alert.addAction(editAction)
            self.present(alert, animated: true, completion: nil)
            self.isRecording = false
            self.viewReset()
        }
    }
    
    func viewReset(){
        micToggle.isEnabled = true
        statusLbl.text = "Ready to Record"
        statusLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        recordBtn.setTitle("Record", for: .normal)
        recordBtn.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

