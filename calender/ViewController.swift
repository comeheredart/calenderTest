//
//  ViewController.swift
//  calender
//
//  Created by JEN Lee on 2021/02/18.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var daysCountInMonth = 0 // 해당 월이 며칠까지 있는지
    var weekdayAdding = 0 // 시작일
    var daysArr: [daySchedule] = []
    
    @IBOutlet weak var calendarHead: UILabel!
    @IBOutlet weak var calendar: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        gestureInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if daysArr.count > 0 {
            print(daysArr[0].day)
            print(daysArr[0].title)
        }
        
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.calendar)
        let indexPath = self.calendar.indexPathForItem(at: p)
        
        if indexPath == nil {
            print("Long press on table view, not row.")
            
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "addSomething") as! AddillViewController
            controller.tempDaySchedule = daySchedule()
            controller.tempDaySchedule?.day = days[indexPath!.row] //여기서 yyyyMMdd 이렇게 줘야 그렇게 배열에 저장됨
            
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func gestureInit() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.calendar.addGestureRecognizer(longPressGesture)
    }
    
    private func initView() {
        self.initCollection()
        
        dateFormatter.dateFormat = "yyyy년 M월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        self.calculation()
    }
    
    
    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekDay = cal.component(.weekday, from: firstDayOfMonth!)
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        print(weekdayAdding, daysCountInMonth)
        
        weekdayAdding = 2 - firstWeekDay
        
        self.calendarHead.text = dateFormatter.string(from: firstDayOfMonth!)
        
        self.days.removeAll()
        
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 { // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    private func initCollection() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
    }

    @IBAction func didTapPreBtn(_ sender: UIButton) {
        components.month = components.month! - 1
        self.calculation()
        self.calendar.reloadData()
    }
    
    
    @IBAction func didTapNextBtn(_ sender: UIButton) {
        components.month = components.month! + 1
        self.calculation()
        self.calendar.reloadData()
        self.calendar.backgroundColor = .systemBackground
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7 //월화수목금토일
        default:
            return self.days.count // 월별일수
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier:
                                                    CalenderCollectionViewCell.identifier, for: indexPath) as! CalenderCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.dayLabel.text = weeks[indexPath.row]
        default:
            cell.dayLabel.text = days[indexPath.row]
        }
        
        if indexPath.row % 7 == 0 {
            cell.dayLabel.textColor = .red
        } else if indexPath.row % 7 == 6 {
            cell.dayLabel.textColor = .blue
        } else {
            cell.dayLabel.textColor = .black
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell: UICollectionViewCell = calendar.cellForItem(at: indexPath)!
        
        selectedCell.contentView.backgroundColor = .blue
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize = myBoundSize / 9
        return CGSize(width: cellSize, height: 80)
    }
    
}
