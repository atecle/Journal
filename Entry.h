//
//  Entry.h
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Entry : NSObject <NSCopying>
@property (nonatomic, readonly) NSInteger entryID;
@property (strong, nonatomic, readonly) NSString *title, *text;
@property (copy, nonatomic) NSArray *photos;

- (void)updateTitle:(NSString *)title;
- (void)updateText:(NSString *)text;
- (void)updatePhotos:(NSArray *)photos;
- (void)updateEntryID:(NSInteger) entryID;

- (instancetype)initWithTitle:(NSString *)title photos:(NSArray *)photos text:(NSString *) text entryID:(NSInteger) entryID;

@end
