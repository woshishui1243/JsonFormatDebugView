//
//  DebugNetViewCell.m
//  DebugView
//
//  Created by dayu on 16/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "DebugNetViewCell.h"
#import "DebugModel.h"

static NSString *const identifier = @"DebugViewCell";

@interface DebugNetViewCell ()

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *arrowBtn;

@end

@implementation DebugNetViewCell

+ (instancetype)debugNetViewCellWithTableView:(UITableView *)tableView {
    DebugNetViewCell *netViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!netViewCell) {
        netViewCell = [[DebugNetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return netViewCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 10, 80, 15)];
        keyLabel.font = [UIFont systemFontOfSize:10];
        keyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:keyLabel];
        self.keyLabel = keyLabel;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 15)];
        contentLabel.font = [UIFont systemFontOfSize:10];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        UIButton *arrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, 12, 12)];
        [arrowBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        arrowBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:arrowBtn];
        self.arrowBtn = arrowBtn;
    }
    return self;
}

- (void)setModel:(DebugModel *)model {
    _model = model;
    
    self.selectionStyle = model.canPackup ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
    self.arrowBtn.hidden = !model.canPackup;
    self.keyLabel.text = model.key;
    self.keyLabel.hidden = !model.key;
    self.contentLabel.hidden = !model.content;
    self.contentLabel.text = model.content;
    self.keyLabel.frame = CGRectMake(28+model.degree*5, 2, model.keyWidth, 13);
    self.arrowBtn.frame = CGRectMake(8+model.degree*5, 2, 12, 12);
    self.contentLabel.frame = CGRectMake(28+model.keyWidth+12+model.degree*5, 2, model.contentWidth, model.cellHeight-4);
    self.open = model.isOpen;
}

- (void)setOpen:(BOOL)open {
    _open = open;
    
    if (_open) {
        [self.arrowBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    }else {
        [self.arrowBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
}

@end
