//
//  ViewController.m
//  DebugView
//
//  Created by dayu on 16/11/22.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "ViewController.h"
#import "DebugModel.h"
#import "DebugNetViewCell.h"
#import "NSString+Extension.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *jsonString;

@end

@implementation ViewController

- (NSDictionary *)dict {
    if (!_dict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"plist"];
        _dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.dataList = [self configureData:self.dict degree:0];
}

- (void)configureListData:(NSArray *)list debugModel:(DebugModel *)debugModel {
    NSInteger count = list.count;
    for (NSInteger i = 0; i < count; i++) {
        id subModel = [list objectAtIndex:i];
        if ([subModel isKindOfClass:[NSString class]]) {
            DebugModel *model = [[DebugModel alloc] init];
            NSString *key = [NSString stringWithFormat:@"Item[%zd]", i];
            model.key = key;
            model.keyWidth = ceil([key sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width);
            NSLog(@"%@ subModel = %@ = %.0f", model.key, subModel, model.keyWidth);
            model.content = subModel;
            model.degree = debugModel.degree+1;
            CGFloat maxWidth = ceil(SCREEN_WIDTH - model.keyWidth - 28 - model.degree * 5 - 24);
            
            CGSize contentSize = [subModel sizeWithConstrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]];
            model.contentWidth = ceil(contentSize.width);
            model.cellHeight = ceil(contentSize.height)+4;
            model.canPackup = NO;
            model.nodeNo = 0;
            if (debugModel.subList) {
                NSMutableArray *subList = [debugModel.subList mutableCopy];
                [subList addObject:model];
                debugModel.subList = subList;
                debugModel.nodeNo = subList.count;
            }else {
                debugModel.subList = @[model];
                debugModel.nodeNo = 1;
            }
        }
        else if ([subModel isKindOfClass:[NSNumber class]]) {
            DebugModel *model = [[DebugModel alloc] init];
            NSString *key = [NSString stringWithFormat:@"Item[%zd]", i];
            model.key = key;
            model.keyWidth = [key sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;;
            model.content = [NSString stringWithFormat:@"%@", subModel];
            model.degree = debugModel.degree+1;
            CGSize contentSize = [subModel sizeWithConstrainedToSize:CGSizeMake(SCREEN_WIDTH - model.keyWidth - 28 - model.degree * 5 - 24, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]];
            model.contentWidth = contentSize.width;
            model.cellHeight = contentSize.height;
            model.canPackup = NO;
            model.nodeNo = 0;
            if (debugModel.subList) {
                NSMutableArray *subList = [debugModel.subList mutableCopy];
                [subList addObject:model];
                debugModel.subList = subList;
                debugModel.nodeNo = subList.count;
            }else {
                debugModel.subList = @[model];
                debugModel.nodeNo = 1;
            }
        }
        else if ([subModel isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subDict = (NSDictionary *)subModel;
            DebugModel *model = [[DebugModel alloc] init];
            NSString *key = [NSString stringWithFormat:@"Item[%zd]", i];
            model.key = key;
            model.keyWidth = [key sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
            NSString *content = [NSString stringWithFormat:@"Dictionary{%zd}", subDict.count];
            model.content = content;
            model.contentWidth = [content sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
            model.cellHeight = 14;
            model.canPackup = YES;
            model.degree = debugModel.degree+1;
            NSMutableArray *subList = [self configureData:subDict degree:model.degree+1];
            model.subList = subList;
            model.nodeNo = subList.count;
            if (debugModel.subList) {
                NSMutableArray *subList = [debugModel.subList mutableCopy];
                [subList addObject:model];
                debugModel.subList = subList;
                debugModel.nodeNo = subList.count;
            }else {
                debugModel.subList = @[model];
                debugModel.nodeNo = 1;
            }
        }
        else if ([subModel isKindOfClass:[NSArray class]]) {
            NSArray *subList = (NSArray *)subModel;
            DebugModel *model = [[DebugModel alloc] init];
            NSString *key = [NSString stringWithFormat:@"Item[%zd]", i];
            model.key = key;
            model.keyWidth = [key sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
            NSString *content = [NSString stringWithFormat:@"Array[%zd]", subList.count];
            model.content = content;
            model.contentWidth = [content sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
            model.cellHeight = 14;
            model.canPackup = YES;
            model.degree = debugModel.degree+1;
            [self configureListData:subModel debugModel:model];
            model.nodeNo = subList.count;
            if (debugModel.subList) {
                NSMutableArray *subList = [debugModel.subList mutableCopy];
                [subList addObject:model];
                debugModel.subList = subList;
                debugModel.nodeNo = subList.count;
            }else {
                debugModel.subList = @[model];
                debugModel.nodeNo = 1;
            }
        }
    }
}

- (NSMutableArray *)configureData:(NSDictionary *)dict degree:(NSInteger)degree {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:dict.count];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        DebugModel *model = [[DebugModel alloc] init];
        model.key = key;
        model.degree = degree;
        model.keyWidth = [key sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
        if ([obj isKindOfClass:[NSString class]]) {
            model.content = obj;
            CGSize contentSize = [obj sizeWithConstrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - model.keyWidth - 28 - model.degree * 5 - 24, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]];
            model.contentWidth = contentSize.width;
            model.cellHeight = contentSize.height + 4;

        }else if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)obj;
            NSString *noString = [NSString stringWithFormat:@"%@", number];
            model.content = noString;
            CGSize contentSize = [noString sizeWithConstrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - model.keyWidth - 28 - model.degree * 5 - 24, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]];
            model.contentWidth = contentSize.width;
            model.cellHeight = contentSize.height + 4;
        }
        else if ([obj isKindOfClass:[NSArray class]]){
            NSArray *subArray = (NSArray *)obj;
            model.canPackup = YES;
            [self configureListData:subArray debugModel:model];
            model.nodeNo = model.subList.count;
            model.cellHeight = 14;
            NSString *content = [NSString stringWithFormat:@"Array[%zd]", subArray.count];
            model.content = content;
            model.contentWidth = [content sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *subDict = (NSDictionary *)obj;
            model.canPackup = YES;
            model.nodeNo = subDict.count;
            NSString *content = [NSString stringWithFormat:@"Dictionary{%zd}", subDict.count];
            model.content = content;
            model.contentWidth = [content sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:10]].width;
            NSInteger newDegree = degree+1;
            NSMutableArray *subList = [self configureData:subDict degree:newDegree];
            model.subList = subList;
            model.cellHeight = 14;
        }
        [dataList addObject:model];
    }];
    return dataList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DebugNetViewCell *netViewCell = [DebugNetViewCell debugNetViewCellWithTableView:tableView];
    DebugModel *model = [self.dataList objectAtIndex:indexPath.row];
    netViewCell.model = model;
    return netViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugModel *model = [self.dataList objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DebugNetViewCell *netViewCell = [tableView cellForRowAtIndexPath:indexPath];
    DebugModel *model = [self.dataList objectAtIndex:indexPath.row];
    if (!model.canPackup) {
        return;
    }
    if (model.isOpen) {
        NSInteger count = [self countOfNode:model];
        [self.dataList removeObjectsInRange:NSMakeRange(indexPath.row+1, count)];

    }else {
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:self.dataList.count+model.nodeNo];
        NSArray *beforeList = [self.dataList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, indexPath.row+1)]];
        [dataList addObjectsFromArray:beforeList];
        [dataList addObjectsFromArray:model.subList];
        NSArray *afterList = [self.dataList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, self.dataList.count-(indexPath.row+1))]];
        [dataList addObjectsFromArray:afterList];
        self.dataList = dataList;
    }
    model.open = !model.isOpen;
    netViewCell.open = !netViewCell.open;
    [self.tableView reloadData];
}

- (NSInteger)countOfNode:(DebugModel *)model {
    NSInteger count = 0;
    if (model.nodeNo) {
        count += model.nodeNo;
        for (DebugModel *subModel in model.subList) {
            if (subModel.isOpen) {
                NSInteger countOfSubModel = [self countOfNode:subModel];
                count += countOfSubModel;
            }
        }
    }
    return count;
}

@end

