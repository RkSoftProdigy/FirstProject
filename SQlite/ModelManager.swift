//
//  ModelManager.swift
//  SQLiteSample
//
//  Created by Amandeep Kaur on 7/31/17.
//  Copyright © 2017 Amandeep Kaur. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject
{
    var database: FMDatabase? = nil
    
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Utility.getPath(fileName: "DataTable.sqlite"))
        }
        return sharedInstance
    }
    
    func addStudentData(studentInfo: DataInfo) -> Bool
    {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO DataTable (Title, Body, ImageUrl) VALUES (?, ?, ?)", withArgumentsIn: [studentInfo.Title, studentInfo.Body,studentInfo.ImageUrl])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func getAllNotificationData() -> [DataInfo] {
        sharedInstance.database!.open()
        
        let resultSet: FMResultSet! = sharedInstance.database?.executeQuery("SELECT * FROM DataTable", withArgumentsIn: [""])
        var marrStudentInfo = [DataInfo]()
        if (resultSet != nil) {
            while resultSet.next() {
                let studentInfo : DataInfo = DataInfo()
                studentInfo.Title = resultSet.string(forColumn: "Title")!
                studentInfo.Body = resultSet.string(forColumn: "Body")!
                studentInfo.ImageUrl = resultSet.string(forColumn: "ImageUrl")!
                studentInfo.Id = NSInteger(resultSet.int(forColumn: "Id"))
               // print("Name --> ",studentInfo.Name)
                marrStudentInfo.append(studentInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }
    
    func updateStudentData(studentInfo: DataInfo) -> Bool
    {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE DataTable SET Title=?, Body=? WHERE ImageUrl=?", withArgumentsIn: [studentInfo.Title, studentInfo.Body, studentInfo.ImageUrl])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteStudentData(studentInfo: DataInfo) -> Bool
    {
        print(studentInfo.Id)
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM DataTable WHERE Id=?", withArgumentsIn: [studentInfo.Id])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func getParticularStudentData() -> NSMutableArray  {
        sharedInstance.database!.open()
        let name : FMResultSet! = sharedInstance.database?.executeQuery("SELECT * FROM DataTable where Title = \"95\"", withArgumentsIn: [])
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        if (name != nil) {
            while name.next() {
                let studentInfo : DataInfo = DataInfo()
                studentInfo.Title = name.string(forColumn: "Title")!
             //   print(studentInfo.Name)
                
                marrStudentInfo.add(studentInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }


}
