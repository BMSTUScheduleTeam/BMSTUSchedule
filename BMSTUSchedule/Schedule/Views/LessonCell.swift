//
//  LessonCell.swift
//  BMSTUSchedule
//
//  Created by Artem Belkov on 26/10/2016.
//  Copyright © 2016 BMSTU Team. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {
    
    // MARK: Storyboard
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var breakLabel: UILabel!
    
    var kind: Lesson.Kind? {

        didSet {
            self.setKind(kind: kind)
        }
    }
    
    // MARK: - Constants
    
    let kindColors = [
        "lecture": AppTheme.current.greenColor,
        "seminar": AppTheme.current.blueColor,
        "lab"    : AppTheme.current.yellowColor,
        "default": UIColor.gray
    ]
    
    let kindRectLeadingOffset: CGFloat = 52
    let kindRectTopOffset: CGFloat = 3.0
    let kindRectThickness: CGFloat = 3.0
    
    // MARK: - Selection
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted {
            
            var key = "default"
            if let kind = kind {
                switch kind {
                case .lecture:
                    key = "lecture"
                case .seminar:
                    key = "seminar"
                case .lab:
                    key = "lab"
                case .undefined:
                    key = "default"
                }
            }
            self.backgroundColor = kindColors[key]?.withAlphaComponent(0.15)
            
        } else {
            self.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - Kind
    
    func setKind(kind: Lesson.Kind?) {
        
        self.setKindTitle(kind: kind)
        self.setKindColor(kind: kind)
        self.drawKindRect(kind: kind)
    }
    
    func setKindColor(kind: Lesson.Kind?) {
        
        if let kind = kind {
            switch kind {
            case .lecture:
                self.kindLabel.textColor = kindColors["lecture"]
            case .seminar:
                self.kindLabel.textColor = kindColors["seminar"]
            case .lab:
                self.kindLabel.textColor = kindColors["lab"]
            case .undefined:
                self.kindLabel.textColor = kindColors["default"]
            }
        }
    }
    
    func setKindTitle(kind: Lesson.Kind?) {
        
        if kind != nil {
            self.kindLabel.text = kind?.rawValue
        } else {
            self.kindLabel.text = ""
        }
    }
    
    func drawKindRect(kind: Lesson.Kind?) {
        
        let origin = CGPoint(x:kindRectLeadingOffset, y:kindRectTopOffset)
        let size = CGSize(width:kindRectThickness, height:self.contentView.frame.height - 2 * kindRectTopOffset)
        
        let kindRect = UIView(frame: CGRect(origin: origin, size: size))
        
        kindRect.layer.cornerRadius = kindRectThickness / 2
        kindRect.layer.masksToBounds = true
        
        if let kind = kind {
            switch kind {
            case .lecture:
                kindRect.backgroundColor = kindColors["lecture"]
            case .seminar:
                kindRect.backgroundColor = kindColors["seminar"]
            case .lab:
                kindRect.backgroundColor = kindColors["lab"]
            case .undefined:
                kindRect.backgroundColor = kindColors["default"]
            }
        } else {
            kindRect.backgroundColor = kindColors["default"]
        }
        
        self.contentView.addSubview(kindRect)
    }
}
