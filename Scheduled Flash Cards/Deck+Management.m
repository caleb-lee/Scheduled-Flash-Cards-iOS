//
//  Deck+Management.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "Deck+Management.h"
#import "DatabaseManager.h"

@implementation Deck (Management)
static NSString *entityName = @"Deck";

// creates/inserts a new deck with the given name and returns it
+ (Deck*)insertDeckWithName:(NSString*)name {
    Deck *newDeck = (Deck*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:defaultManagedObjectContext()];
    
    return newDeck;
}

// grabs the deck with the given name out of the database and returns it
//  returns nil if deck with no such name exists
+ (Deck*)deckWithName:(NSString*)name {
    // set up predicate and sort descriptors
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    // fetch the deck with name
    Deck *deck = (Deck*)fetchObject(entityName, predicate, sortDescriptors);
    
    return deck;
}

@end
