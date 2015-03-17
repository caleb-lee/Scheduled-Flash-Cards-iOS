//
//  DatabaseManager.h
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import <CoreData/CoreData.h>

// gets the NSManagedObjectContext
NSManagedObjectContext* defaultManagedObjectContext();

// save
void saveManagedObjectContext();

// deletes an object from the NSManagedObjectContext
void deleteObject(NSManagedObject *object);

// fetches objects from the NSManagedObjectContext
NSArray* fetchObjects(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors);

// fetches an object from the NSManagedObjectContext
NSManagedObject* fetchObject(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors);

// makes an NSFetchRequest
NSFetchRequest* fetchRequest(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors);