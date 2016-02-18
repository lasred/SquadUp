//
//  GameLobbyViewController.swift
//  SquadUp-iOS
//
//  Created by Shaheen Sharifian on 2/8/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit
import Firebase

class GameLobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lobbyNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var team1ContainerView: UIView!
    @IBOutlet weak var team1TableView: UITableView!
    @IBOutlet weak var teamSegmentedControl: UISegmentedControl!
    
    var lobbyModelObject: LobbyGameModel!
    var teamOneArray = [UserModel]()
    var teamTwoArray = [UserModel]()
    var playersInLobby = [UserModel]()
    var playerIdList = [String]()
    var team1: Bool!
    var currentUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team1TableView.dataSource = self
        team1TableView.delegate = self
        getUsers()
    }
    
    func divideTeams() {
        teamOneArray = []
        teamTwoArray = []
        var shit: Bool = true
        for player in self.playersInLobby {
            if (shit) {
                teamOneArray.append(player)
            } else {
                teamTwoArray.append(player)
            }
            shit = !shit
        }
        print("Team 1")
        print(teamOneArray)
        print("Team 2")
        print(teamTwoArray)
    }
    
    func getUsers() {
        var asdf = [UserModel]()
        print(self.lobbyModelObject.currentPlayers)
        DataService.ds.REF_USERS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            // Parse Firebase Data
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print("FUCK A " + snap.key)
                        if (self.lobbyModelObject.currentPlayers.contains(snap.key)) {
                            print("found")
                            let user = UserModel(userKey: key, dictionary: userDict)
                            asdf.append(user)
                        } else {
                            print("not found")
                        }
                    }
                }
            }
            self.playersInLobby = asdf
            self.divideTeams()
            self.team1TableView.reloadData()
            print(self.playersInLobby)
        })
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch(teamSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = teamOneArray.count
            team1 = true
            break
        case 1:
            returnValue = teamTwoArray.count
            team1 = false
            break
        default:
            break
        }
        return returnValue
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
        switch(teamSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            cell.textLabel?.text = teamOneArray[indexPath.row].firstName + " " + teamOneArray[indexPath.row].lastName
            break
        case 1:
            cell.textLabel?.text = teamTwoArray[indexPath.row].firstName + " " + teamTwoArray[indexPath.row].lastName
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func controlChanged(sender: AnyObject) {
        team1TableView.reloadData()
    }
    @IBAction func joinTeam(sender: AnyObject) {
        let user = NSUserDefaults.standardUserDefaults().dataForKey("userModelKey")!
        let userUnarchived = NSKeyedUnarchiver.unarchiveObjectWithData(user) as! UserModel
        let post = DataService.ds.REF_LOBBYGAMES.childByAppendingPath(lobbyModelObject.lobbyKey).childByAppendingPath("currentPlayers").childByAutoId()
        post.setValue("Shaheen")
        playersInLobby.append(userUnarchived)
        print(userUnarchived.firstName)
        self.divideTeams()
        self.team1TableView.reloadData()
    }
}


