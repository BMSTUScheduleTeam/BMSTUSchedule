//
//  ScheduleController.swift
//  BMSTUSchedule
//
//  Created by Artem Belkov on 25/10/2016.
//  Copyright © 2016 techpark-iOS. All rights reserved.
//

import UIKit
import Firebase

class ScheduleController: UITableViewController {
    
    var schedule = Schedule()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Menu button
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
        // Remove empty cells
        tableView.tableFooterView = UIView()
        
        // Load schedule
        ScheduleManager.sharedManager.getSchedule(group: Group(name: "ИУ5-33"), success: { schedule in
            self.schedule = schedule
            self.tableView.reloadData()
        })
        
        // Set random schedule
        //self.setRandomSchedule()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedule.numeratorWeek.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return schedule.numeratorWeek[section].title.rawValue.capitalized
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.numeratorWeek[section].lessons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as! LessonCell
        
        let lesson = schedule.numeratorWeek[indexPath.section].lessons[indexPath.row]
        
        cell.titleLabel.text = lesson.title
        
        cell.teacherLabel.text = lesson.teacher
        cell.roomLabel.text = lesson.room
        cell.setType(type: lesson.type)
        
        cell.startTimeLabel.text = lesson.startTime
        cell.endTimeLabel.text = lesson.endTime
        
        return cell
    }
    
    
    // MARK: - Schedule
    
    func setRandomSchedule() {
     
        var daysTitles = [Day.Title.monday, Day.Title.thuesday, Day.Title.wednesday, Day.Title.thursday, Day.Title.friday, Day.Title.saturday]
        
        for i in 0...daysTitles.count-1 {
            
            let dayLessonsCount = arc4random_uniform(5) + 1
            var dayLessons: [Lesson] = []
            
            for _ in 0...dayLessonsCount {
                
                let lessonIndex = arc4random_uniform(3) + 1
                var lesson: Lesson?
                switch lessonIndex {
                case 1:
                    lesson = Lesson(title: "Теория вероятности",
                                    teacher: "Безверхний Н.В.",
                                    room: "230л",
                                    type: .lecture,
                                    startTime: "12:00",
                                    endTime: "13:35")
                case 2:
                    lesson = Lesson(title: "Электротехника",
                                    teacher: "Белодедов М.В.",
                                    room: "700",
                                    type: .lab,
                                    startTime: "13:50",
                                    endTime: "15:25")
                case 3:
                    lesson = Lesson(title: "Архитектура автоматизированных систем обработки информации и управления",
                                    teacher: "Шук В. П.",
                                    room: "501ю",
                                    type: .seminar,
                                    startTime: "10:15",
                                    endTime: "11:50")
                default:
                    break
                }
                dayLessons.append(lesson!)
                
                // Add to firebase
                ScheduleManager.sharedManager.addLesson(lesson: lesson!, group: Group(name: "ИУ5-33"), isNumerator: false, day: daysTitles[i])
                
            }
            
            let day = Day(title:daysTitles[i], lessons:dayLessons)
            self.schedule.numeratorWeek.append(day)
        }
        
    }
    
    // MARK: - Memory
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
