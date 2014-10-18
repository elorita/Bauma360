//
//  NewsTableViewDND.h
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableView.h"
#import "TableCellProtocols.h"

@interface NewsTableViewDND : NSObject<CustomTableViewDataSource,CustomTableViewDelegate>

@property (nonatomic,assign) id<CustomTableCellDelegate>  delegate;

@end
