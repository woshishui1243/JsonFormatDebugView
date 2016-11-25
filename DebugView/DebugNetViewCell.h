//
//  DebugNetViewCell.h
//  DebugView
//
//  Created by dayu on 16/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DebugModel;
@interface DebugNetViewCell : UITableViewCell

@property (nonatomic, strong) DebugModel *model;

+ (instancetype)debugNetViewCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign, getter=isOpen) BOOL open;
@end
