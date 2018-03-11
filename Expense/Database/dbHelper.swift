//
//  dbHelper.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/3/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class manageObjcontext {
    
   class func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}


class dbHeloper : manageObjcontext {

    class func savedata (title : String, date : Date, amount : Float, bywhome : String, remarks : String, place : String, imagename:String, time:Int64) -> NSManagedObject {
        let context = getContext()
        // amount,  bywhome,  date, remarks, title
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "User", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        //set the entity values
        transc.setValue(amount, forKey: "amount")
        transc.setValue(bywhome, forKey: "bywhome")
        transc.setValue(date, forKey: "date")
        transc.setValue(remarks, forKey: "remarks")
        transc.setValue(title, forKey: "title")
        transc.setValue(place, forKey: "place")
        transc.setValue(imagename, forKey: "imagename")
        transc.setValue(time, forKey: "time")
        
        //save the object
        do {
            try context.save()
            print("saved!")
            return transc
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch { }
        return NSManagedObject()
    }
    
    class func  retriveAllData() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let context = getContext()
        do {
            let managedObjects = try context.fetch(fetchRequest)
            return managedObjects as! [NSManagedObject]
        } catch {
            print("Error with request: \(error)")
        }
        return [NSManagedObject()]
    }
    
    class func retriveDataWithTo_FromDate (startDate : Date, endDate : Date) -> [NSManagedObject] {
        //create a fetch request, telling it about the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
        print("Fetch request -> \(fetchRequest.predicate)")
        return self.callRequest(request: fetchRequest)
    }
    
    class func retriveDataWithDate(date : Date) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        return self.callRequest(request: fetchRequest)
    }
    
    class func retriveTodayData(date : Date) -> Float {
        
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["amount"]
        let sumExpression = NSExpression(format: "@sum.amount")
        let sumOfAmount = NSExpressionDescription()
        sumOfAmount.expression = sumExpression
        sumOfAmount.name = "total_sum"
        sumOfAmount.expressionResultType = .floatAttributeType
        fetchRequest.propertiesToGroupBy = ["amount"]
        fetchRequest.propertiesToFetch = ["amount", sumOfAmount]
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            if searchResults.count > 0 {
                let sumOfAmount = (searchResults[0] as! NSDictionary)["total_sum"] as! Float
                return sumOfAmount
            }
        } catch {
            print("Error with request: \(error)")
        }
        return 0
    }
    
  
    class func callRequest(request : NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject] {
        
        let context = getContext()
        do {
            //go get the results
            let searchResults = try context.fetch(request)
            return searchResults as! [NSManagedObject]
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    class func deleteRow(managedObject : NSManagedObject) -> Bool {
        
        let context = getContext()
        context.delete(managedObject)
        do {
            try context.save()
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            } catch {
        }
        return true
    }
    
    class func deleteAllData() -> Bool {
         let context = getContext()
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let manageObjes =  self.callRequest(request: fetchRequest)
        for obj in manageObjes {
            context.delete(obj)
        }
        do {
            try context.save()
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
        }
        return false
    }
    
    
    class func updateData (title : String, date : Date, amount : Float, bywhome : String, remarks : String, place : String, managedObj : NSManagedObject) -> NSManagedObject {
        
        let context = getContext()
        managedObj.setValue(amount, forKey: "amount")
        managedObj.setValue(bywhome, forKey: "bywhome")
        managedObj.setValue(date, forKey: "date")
        managedObj.setValue(remarks, forKey: "remarks")
        managedObj.setValue(title, forKey: "title")
        managedObj.setValue(place, forKey: "place")
        
        do {
            try context.save()
            print("Update!")
            return managedObj
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
        }
        return NSManagedObject()
    }
}
