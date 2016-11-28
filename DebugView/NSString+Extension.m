//
//  NSString+Extension.m
//  DebugView
//
//  Created by dayu on 16/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithConstrainedToSize:(CGSize)size font:(UIFont *)font {
    return [self boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: font} context:nil].size;
}
@end
