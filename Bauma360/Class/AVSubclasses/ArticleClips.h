//
//  ArticleClips.h
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface ArticleClips : AVObject<AVSubclassing>

@property (nonatomic, strong) AVFile *clip;

@end
