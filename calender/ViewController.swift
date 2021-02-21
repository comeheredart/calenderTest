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
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        gestureInit()
    }
    
    @IBAction func didTapTypeSegment(_ sender: UISegmentedControl) {
        calendar.reloadData()
    }
    
    func showTypeSchedule(type: Int, index: Int, cell: UICollectionViewCell) {
        switch type {
        case 0:
            showSchedule(type: .none, index: index, cell: cell, color: .systemYellow)
        case 1:
            showSchedule(type: .hospital, index: index, cell: cell, color: .orange)
        case 2:
            showSchedule(type: .bob, index: index, cell: cell, color: .magenta)
        case 3:
            showSchedule(type: .med, index: index, cell: cell, color: .systemPink)
        default:
            showSchedule(type: .snack, index: index, cell: cell, color: .green)
        }
    }
    
    //보여주는 함수
    func showSchedule(type: careType, index: Int, cell: UICollectionViewCell, color: UIColor) {
        for dayData in daysArr {
            let date = dayData.day
            let endIdx: String.Index = date.index(date.startIndex, offsetBy: 5)
            let startIdx: String.Index = date.index(date.startIndex, offsetBy: 6)
            
            let ym = String(date[...endIdx]) //202102
            let d = String(date[startIdx...]) //12
            
            if formatterDateFunc() == ym {
                if Int(d) == Int(days[index]) {
                    if type == .none {
                        cell.backgroundColor = color
                    }
                    else if type == dayData.type {
                        cell.backgroundColor = color
                    }
                    
                }
                
            }
            
        }
    }
    
    //내 생각은 day 배열에 있는 스케줄들의 day 스트링이랑 지금 달이 같으면 ? 뒤에 있는 day 날들이 cell 에 칠해주기
    override func viewWillAppear(_ animated: Bool) {
        
        self.calendar.reloadData()
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
            
            let selectedDay = formatterDateFunc() +  formatterDayFunc(input: indexPath!.row)//yyyyMMdd
            controller.tempDaySchedule?.day = selectedDay
            //여기서 yyyyMMdd 이렇게 줘야 그렇게 배열에 저장됨
            
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //yyyyMM 형식 만들어주는 함수
    func formatterDateFunc() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        let currentYM = cal.date(from: components)!
        return formatter.string(from: currentYM)
    }
    
    func formatterDayFunc(input: Int) -> String {
        if input < 10 {
            return String(0) + String(input)
        }
        return String(input)
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
        print(components.month!)
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
        cell.backgroundColor = .systemBackground
        
    
        showTypeSchedule(type: typeSegment.selectedSegmentIndex, index: indexPath.row, cell: cell)
        
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

        switch indexPath.section {
        case 0:
            return CGSize(width: cellSize, height: 20)
        default:
            return CGSize(width: cellSize, height: 80)
        }
        
    }
    
}
