//
//  SGFocusImageItem.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title = _title;
@synthesize imageFile = _imageFile;
@synthesize tag = _tag;

- (void)dealloc
{
    self.title = nil;
    self.imageFile = nil;
}
- (id)initWithTitle:(NSString *)title image:(AVFile *)imageFile tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageFile = imageFile;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            self.title = [dict objectForKey:@"title"];
            self.imageFile = [dict objectForKey:@"image"];
            self.tag = tag;
        }
    }
    return self;
}
@end
