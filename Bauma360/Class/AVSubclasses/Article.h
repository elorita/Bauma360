//
//  Article.h
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Article : AVObject<AVSubclassing>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *source;
@property(nonatomic,copy) NSDate *date;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *body;
@property(nonatomic,retain) AVFile *listImageFile;
@property(nonatomic,retain) AVFile *mainImageFile;
@property(nonatomic,retain) AVRelation *clips;



@end
