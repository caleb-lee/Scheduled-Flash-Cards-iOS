//
//  DatabaseManager.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseManager.h"

// gets the NSManagedObjectContext
NSManagedObjectContext* defaultManagedObjectContext() {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    return [appDelegate managedObjectContext];
}

// save
void saveManagedObjectContext() {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

// deletes an object from the NSManagedObjectContext
void deleteObject(NSManagedObject *object) {
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    [moc deleteObject:object];
}

// fetches objects from the NSManagedObjectContext
//  returns an empty array if no objects are found
NSArray* fetchObjects(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors) {
    // get the managed object context
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    
    // get NSFetchRequest
    NSFetchRequest *request = fetchRequest(entityName, predicate, sortDescriptors);
    
    // get ready to store error (if needed)
    NSError *error;
    
    // fetch from the database
    NSArray *fetchResults = [moc executeFetchRequest:request error:&error];
    
    // handle error
    if (fetchResults == nil)
        NSLog(@"%@", [error localizedDescription]);
    
    // return
    return fetchResults;
}

// fetches an object from the NSManagedObjectContext
//  returns nil if no objects are found
NSManagedObject* fetchObject(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors) {
    NSArray *array = fetchObjects(entityName, predicate, sortDescriptors);
    
    NSManagedObject *object = nil;
    if ([array count] > 0)
        object = [array objectAtIndex:0];
    
    return object;
}

// makes an NSFetchRequest
NSFetchRequest* fetchRequest(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors) {
    // get the managed object context
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    
    // make request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // configure request
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:moc]];
    if (predicate != nil)
        [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    
    // return request
    return request;
}