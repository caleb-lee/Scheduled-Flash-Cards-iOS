//
//  Deck+Management.h
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "Deck.h"

@interface Deck (Management)

// creates/inserts a new deck with the given name and returns it
+ (Deck*)insertDeckWithName:(NSString*)name;

// grabs the deck with the given name out of the database and returns it
//  returns nil if deck with no such name exists
+ (Deck*)deckWithName:(NSString*)name;

@end
