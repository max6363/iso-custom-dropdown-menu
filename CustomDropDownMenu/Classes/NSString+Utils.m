//
//  NSString+Utils.m
//  CustomDropDownMenu
//
//  Created by Minhaz on 18/06/17.
//  Copyright © 2017 iQTech. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (CGSize)getSizeWithConstrainedHeight:(CGFloat)height font:(UIFont *)font
{
    if (self == nil || [self isKindOfClass:[NSNull class]] || height == 0 || font == nil || [font isKindOfClass:[NSNull class]]) {
        return CGSizeZero;
    }
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font
                                 };
    CGRect rect = [self boundingRectWithSize:CGSizeMake(INFINITY, height) options:NSStringDrawingUsesFontLeading attributes:attributes context:NULL];
    return rect.size;
}

@end
