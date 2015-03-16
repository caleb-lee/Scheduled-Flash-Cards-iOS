//
//  ScheduleController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "ScheduleController.h"

@implementation ScheduleController

- (void)scheduleCard:(Card*)card withDifficulty:(NSInteger)difficulty {
    if (difficulty < 0 || difficulty > 3) {
        NSLog(@"Schedule Controller Error: difficulty is out of range");
        exit(1);
    }
    
    if ([card.interval integerValue] == 0)
        [self scheduleNewCard:card withDifficulty:difficulty];
    else
        [self scheduleOldCard:card withDifficulty:difficulty];
}

- (void)scheduleNewCard:(Card*)card withDifficulty:(NSInteger)difficulty {
    NSInteger newInterval = [card.interval integerValue];
    switch (difficulty) {
        case 0:
            newInterval = 0;
            break;
        case 1:
            newInterval = 1;
            break;
        case 2:
            newInterval = 3;
            break;
        case 3:
            newInterval = 4;
            break;
        default:
            break;
    }
    
    [self scheduleCard:card withNewInterval:newInterval];
}

- (void)scheduleOldCard:(Card*)card withDifficulty:(NSInteger)difficulty {
    NSInteger newInterval = [card.interval integerValue];
    switch (difficulty) {
        case 0:
            newInterval = 0;
            break;
        case 1:
            newInterval = (int)(newInterval * 1.5);
            break;
        case 2:
            newInterval = (int)(newInterval * 2.5);
            break;
        case 3:
            newInterval = (int)(newInterval * 3.5);
            break;
        default:
            break;
    }
    
    [self scheduleCard:card withNewInterval:newInterval];
}

- (void)scheduleCard:(Card *)card withNewInterval:(NSInteger)interval {
    static NSInteger numberOfSecondsInDay = 60 * 60 * 24;
    
    card.lastSeenDate = [NSDate date];
    card.nextSeeDate = [NSDate dateWithTimeIntervalSinceNow:(interval * numberOfSecondsInDay)];
    card.interval = [NSNumber numberWithInteger:interval];
}

@end
