//
//  Entry.m
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "Entry.h"

@implementation Entry

- (instancetype)initWithTitle:(NSString *)title photos:(NSArray *)photos text:(NSString *) text entryID:(NSInteger) entryID
{
    if (self = [super init])
    {
        _title = title;
        _photos = photos;
        _text = text;
        _entryID = entryID;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    Entry *copy = [[Entry alloc] initWithTitle:self.title photos:self.photos text:self.text entryID:self.entryID];
    return copy;
}

- (void)updateTitle:(NSString *)title
{
    _title = title;
}

- (void)updateText:(NSString *)text
{
    _text = text;
}

- (void)updatePhotos:(NSArray *)photos
{
    _photos = photos;
}

- (void)updateEntryID:(NSInteger)entryID
{
    _entryID = entryID;
}

@end
