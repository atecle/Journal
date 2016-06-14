//
//  Journal.m
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "Journal.h"

@implementation Journal

- (void)addEntry:(Entry *)entry
{
    if (!self.entries)
    {
        _entries = @[entry];
    }
    else
    {
        NSMutableArray *temp = [self.entries mutableCopy];
        [temp addObject:entry];
        _entries = [temp copy];
    }
}

- (void)updateEntry: (Entry *)entry
{
    NSInteger foundIndex = NSNotFound;
    for (int index = 0; index < [self.entries count]; index++)
    {
        Entry *oldEntry = [self.entries objectAtIndex:index];
        if (oldEntry.entryID == entry.entryID)
        {
            foundIndex = index;
        }
    }
    
    if (foundIndex != NSNotFound)
    {
        NSMutableArray *temp = [self.entries mutableCopy];
        [temp replaceObjectAtIndex:foundIndex withObject:entry];
        _entries = [temp copy];
    }
}

@end
