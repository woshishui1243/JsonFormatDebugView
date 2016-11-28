//
//  DebugModel.h
//  DebugView
//
//  Created by dayu on 16/11/23.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugModel : NSObject <NSCopying>


@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) id content;

@property (nonatomic, assign) BOOL canPackup;

@property (nonatomic, assign) NSInteger nodeNo;

@property (nonatomic, strong) NSArray *subList;

@property (nonatomic, assign) NSInteger degree;

@property (nonatomic, assign) CGFloat keyWidth;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign, getter=isOpen) BOOL open;


@end
