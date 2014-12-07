//
//  NewsTableViewDND.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "NewsTableViewDND.h"
#import "NewsViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Article.h"

#define COUNT_PER_LOADING 20

@implementation NewsTableViewDND
{
    NSInteger articleLoadedCount;
    SGFocusImageFrame *_bannerView;
}

#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(CustomTableView *)aTableContent{
    int length = 4;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"title%d",i],@"title" ,
                              [NSString stringWithFormat:@"ad%d",(i + 1)],@"image",
                              nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    [_bannerView changeImageViewsContent:itemArray];
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"newsCell";
    NewsViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil] lastObject];
    }
    
    Article *article = (Article *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    NSData *thumb = [article.listImageFile getData];
    vCell.headerImageView.image = [UIImage imageWithData:thumb];
    vCell.titleLabel.text = article.title;
    vCell.summaryLabel.text = article.summary;
    return vCell;
}

#pragma mark CustomTableViewDelegate
-(UIView *)loadHeaderView{
    return _bannerView;
}

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    NewsViewCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil] lastObject];
    return vCell.frame.size.height;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    Article *article = (Article *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    if ([_delegate respondsToSelector:@selector(showArticle:)]) {
        [_delegate showArticle:article];
    }
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    AVQuery *query = [Article query];
    [query whereKey:@"tag" containsAllObjectsInArray:@[@"news"]];
    [query orderByAscending:@"date"];
    query.limit = COUNT_PER_LOADING;
    query.skip = self->articleLoadedCount;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (Article *article in objects) {
                [aView.tableInfoArray addObject:article];
            }
            self->articleLoadedCount += objects.count;
            
            if (complete) {
                complete(objects.count);
            }
        }
    }];
}

-(void)refreshData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    if (_bannerView == NULL)//初次刷新数据时，初始化UITableView.tableHeaderView
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": [NSString stringWithFormat:@"ad%d",1]} tag:-1];
        _bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 185) delegate:self imageItems:@[item] isAuto:YES];
    }
    
    AVQuery *query = [Article query];
    [query whereKey:@"tag" containsAllObjectsInArray:@[@"news"]];
    [query orderByAscending:@"date"];
    query.limit = COUNT_PER_LOADING;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [aView.tableInfoArray removeAllObjects];
            for (Article *article in objects) {
                [aView.tableInfoArray addObject:article];
            }
            self->articleLoadedCount = objects.count;
        }
        [self changeHeaderContentWithCustomTable:aView];
        if (complete) {
            complete(objects.count);
        }
    }];
}

- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView{
    return  aView.reloading;
}

#pragma mark SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}
@end
