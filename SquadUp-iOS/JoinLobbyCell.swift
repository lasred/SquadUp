//
//  JoinLobbyCell.swift
//  SquadUp-iOS
//
//  Created by Shaheen Sharifian on 2/7/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class JoinLobbyCell: UITableViewCell {
    @IBOutlet weak var lobbyName: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var numPeople: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sponsoredImage: UIImageView!
    @IBOutlet weak var lobbyBgImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var gameLobby: LobbyGameModel!
    var request = Request?()
    var currentTotalPlayers: String!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureDate(dateString: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let convertedDate = dateFormatter.dateFromString(dateString)
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: convertedDate!)
        let weekDay = myComponents.weekday
        let daysOfWeek = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
        return daysOfWeek[weekDay - 1]
    }
    
    func configureCell(gameLobby: LobbyGameModel) {
        self.gameLobby = gameLobby
        self.lobbyName.text = gameLobby.lobbyName + " " + gameLobby.sport
        currentTotalPlayers = String(gameLobby.currentCapacity) + " /" + " " + String(gameLobby.maxCapacity)
        self.numPeople.text = currentTotalPlayers
        self.dateLabel.text = configureDate(gameLobby.date)
        self.dateLabel.textAlignment = .Right
        lobbyBgImage.contentMode = UIViewContentMode.ScaleAspectFill
        if gameLobby.registered == "yes" {
            lobbyBgImage.image = UIImage(named: "sponsorBox.png")
            sponsoredImage.image = UIImage(named: "sponsorIcon")
        } else if gameLobby.registered == "no" {
            lobbyBgImage.image = UIImage(named: "normalBox.png")
        }

    }
    
    // Add functgions for when somebody joins the lobby to increment the currentcapacity
    
}
