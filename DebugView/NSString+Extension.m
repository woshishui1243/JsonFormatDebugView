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
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    return [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName:style} context:nil].size;
}
@end
