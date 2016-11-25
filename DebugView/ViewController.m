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
    tableView.rowHeight = 17;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.dataList = [self configureData:self.dict degree:0];
}

- (void)configureListData:(NSArray *)list debugModel:(DebugModel *)debugModel {
    NSInteger count = list.count;
    for (NSInteger i = 0; i < count; i++) {
        id subModel = [list objectAtIndex:i];
        if ([subModel isKindOfClass:[NSString class]]) {
            if (debugModel.content) {
                debugModel.content = [debugModel.content stringByAppendingFormat:@"\n%@", subModel];
            }else {
                debugModel.content = subModel;
            }
        }
        else if ([subModel isKindOfClass:[NSNumber class]]) {
            if (debugModel.content) {
                debugModel.content = [debugModel.content stringByAppendingFormat:@"\n%@", subModel];
            }else {
                debugModel.content = subModel;
            }
        }
        else if ([subModel isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *subList = [self configureData:subModel degree:debugModel.degree+1];
            debugModel.content = @"数组";
            debugModel.canPackup = YES;
            if (debugModel.subList) {
                NSMutableArray *contentList = [NSMutableArray arrayWithCapacity:(debugModel.subList.count + subList.count)];
                [contentList addObjectsFromArray:debugModel.subList];
                [contentList addObjectsFromArray:subList];
                debugModel.subList = contentList;
                debugModel.nodeNo = contentList.count;
            }else {
                debugModel.subList = subList;
                debugModel.nodeNo = subList.count;
            }
        }
        else if ([subModel isKindOfClass:[NSArray class]]) {
            [self configureListData:subModel debugModel:debugModel];
        }
    }
}

- (NSMutableArray *)configureData:(NSDictionary *)dict degree:(NSInteger)degree {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:dict.count];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        DebugModel *model = [[DebugModel alloc] init];
        model.key = key;
        model.degree = degree;
        model.keyWidth = [key boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil].size.width;
        if ([obj isKindOfClass:[NSString class]]) {
            model.content = obj;
            CGSize contentSize = [obj boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - model.keyWidth - 28 - model.degree * 5 - 24, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil].size;
            model.contentWidth = contentSize.width;
            model.cellHeight = contentSize.height + 4;

        }else if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)obj;
            NSString *noString = [NSString stringWithFormat:@"%@", number];
            model.content = noString;
            CGSize contentSize = [noString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - model.keyWidth - 28 - model.degree * 5 - 24, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil].size;
            model.contentWidth = contentSize.width;
            model.cellHeight = contentSize.height + 4;
        }
        else if ([obj isKindOfClass:[NSArray class]]){
            NSArray *subArray = (NSArray *)obj;
            [self configureListData:subArray debugModel:model];
            model.cellHeight = 17;
            model.content = @"[数组]";
//            model.content = [NSString stringWithFormat:@"[%@]", listStr];
//            CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - model.keyWidth - 28 - model.degree * 5  - 24, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil].size;
//            model.cellHeight = contentSize.height + 4;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *subDict = (NSDictionary *)obj;
            model.canPackup = YES;
            model.nodeNo = subDict.count;
            model.content = @"字典";
            NSInteger newDegree = degree+1;
            NSMutableArray *subList = [self configureData:subDict degree:newDegree];
            model.subList = subList;
            model.cellHeight = 17;
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
//        [self.dataList removeObjectsInRange:NSMakeRange(indexPath.row+1, model.nodeNo)];
        NSInteger count = [self countOfNode:model];
        [self.dataList removeObjectsInRange:NSMakeRange(indexPath.row+1, count)];

    }else {
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:self.dataList.count+model.nodeNo];
        [dataList addObjectsFromArray:[self.dataList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, indexPath.row+1)]]];
        [dataList addObjectsFromArray:model.subList];
        [dataList addObjectsFromArray:[self.dataList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, self.dataList.count-(indexPath.row+1))]]];
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

