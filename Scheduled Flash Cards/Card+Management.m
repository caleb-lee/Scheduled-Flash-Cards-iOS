//
//  Card+Management.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "Card+Management.h"
#import "DatabaseManager.h"

@implementation Card (Management)

static NSString *entityName = @"Card";

+ (Card*)insertCardWithFront:(NSString *)front Back:(NSString *)back intoDeck:(Deck *)deck {
    Card *newCard = (Card*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:defaultManagedObjectContext()];
    
    [newCard setFront:front];
    [newCard setBack:back];
    [newCard setLastSeenDate:[NSDate dateWithTimeIntervalSince1970:0]];
    [newCard setNextSeeDate:[NSDate date]];
    [newCard setInterval:[NSNumber numberWithInt:0]];
    [newCard setDeck:deck];
    
    return newCard;
}

@end
