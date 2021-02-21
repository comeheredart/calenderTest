//
//  AddillViewController.swift
//  calender
//
//  Created by JEN Lee on 2021/02/20.
//

import UIKit

class AddillViewController: UIViewController {

    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var titleTextview: UITextView!
    @IBOutlet weak var selectTypeSegment: UISegmentedControl!
    var tempDaySchedule: daySchedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextSetting()
    }
    
    func titleTextSetting() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.date(from: tempDaySchedule!.day)
        print(tempDaySchedule!.day)
        
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "yyyy년 MM월 dd일"
    
        dayTitle.text = printDateFormatter.string(from: date!)
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        if let inputText = titleTextview.text {
            tempDaySchedule?.title = inputText
        } else {
            print("값 입력 안함")
        }
        
        switch selectTypeSegment.selectedSegmentIndex {
        case 0:
            tempDaySchedule?.type = .hospital
        case 1:
            tempDaySchedule?.type = .bob
        case 2:
            tempDaySchedule?.type = .med
        case 3:
            tempDaySchedule?.type = .snack
        default:
            tempDaySchedule?.type = .none
        }
        
        let preVC = self.presentingViewController
        guard let pre = preVC as? ViewController else {
            return
        }
        pre.daysArr.append(tempDaySchedule!)
        pre.dismiss(animated: true)
        
    }
    
    

}
