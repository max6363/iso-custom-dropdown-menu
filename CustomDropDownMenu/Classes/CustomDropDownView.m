//
//  CustomDropDownView.m
//
//  Created by Minhaz Panara on 22/05/17.
//  Copyright © 2017 iQTech. All rights reserved.
//

#import "CustomDropDownView.h"
#import "NSString+Utils.h"

@interface CustomDropDownView ()
{
    UIButton *btImage, *btTitle;
    CGFloat title_gap;
    CGSize __imageSize;
    UIFont *title_font;
    UIColor *title_color;
    CGPoint image_origin;
    
    CGRect frameImageCollapse, frameImageExpand, frameImageExpandBounce;
    CGRect frameTitleCollapse, frameTitleExpand;
}
@end

@implementation CustomDropDownView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName imageSize:(CGSize)imageSize titleGap:(CGFloat)titleGap titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor imageOrigin:(CGPoint)imageOrigin
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _title = title;
        _imageName = imageName;
        __imageSize = imageSize;
        title_gap = titleGap;
        title_font = titleFont;
        title_color = titleColor;
        image_origin = imageOrigin;
        
        // setup views
        [self setupViews];
        
//        [self setBorderWithCyanColor];
    }
    return self;
}

- (void)setupViews
{
    CGFloat yPos = self.frame.size.height/2.0 - __imageSize.height/2.0;
    btImage = [UIButton buttonWithType:UIButtonTypeCustom];
    
    frameImageExpand = CGRectMake(image_origin.x, yPos, __imageSize.width, __imageSize.height);
    
    CGFloat bounce = 15;
    frameImageExpandBounce = CGRectMake(frameImageExpand.origin.x - bounce, frameImageExpand.origin.y - bounce, frameImageExpand.size.width + bounce * 2.0, frameImageExpand.size.height + bounce * 2.0);
    
    CGFloat collpas_image_width = 5;
    CGFloat x_center = CGRectGetMidX(frameImageExpand);
    CGFloat y_center = CGRectGetMidY(frameImageExpand);
    frameImageCollapse = CGRectMake(x_center - collpas_image_width/2.0, y_center - collpas_image_width/2.0, collpas_image_width, collpas_image_width);
    
    btImage.frame = frameImageCollapse;
    [self addSubview:btImage];
    [btImage setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    [btImage addTarget:self action:@selector(onImageBtClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btImage setBorderWithRedColor];

    
    CGFloat xPos_title = btImage.center.x + btImage.frame.size.width/2.0 + title_gap;
    CGFloat titleHeight = 30.0;
    CGFloat titleWidth = [_title getSizeWithConstrainedHeight:titleHeight font:title_font].width;//self.frame.size.width - xPos_title;
    CGFloat yPos_title = self.frame.size.height/2.0 - titleHeight/2.0;
    
    frameTitleCollapse = CGRectMake(btImage.center.x, yPos_title, titleWidth, titleHeight);
    frameTitleExpand = CGRectMake(xPos_title, yPos_title, titleWidth, titleHeight);
    
    btTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btTitle.frame = frameTitleCollapse;
//    [self addSubview:btTitle];
    [self insertSubview:btTitle belowSubview:btImage];
    btTitle.titleLabel.font = title_font;
    [btTitle setTitle:_title forState:UIControlStateNormal];
    [btTitle setTitleColor:title_color forState:UIControlStateNormal];
    btTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btTitle addTarget:self action:@selector(onTitleBtClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btTitle setBorderWithGreenColor];
    btTitle.alpha = 0.0;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes];
}

#pragma mark - Handle Tap
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnBaseView)]) {
        [self.delegate didTapOnBaseView];
    }
}

#pragma mark - Expand View
- (void)expandViewAnimated:(BOOL)animated delay:(float)delay titleShouldAnimate:(BOOL)titleShouldAnimate
{
    if (self.index == 0) {
        if (self.imageNameFirstSelected != nil) {
            [btImage setImage:[UIImage imageNamed:self.imageNameFirstSelected] forState:UIControlStateNormal];
        } else {
            [btImage setImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
        }
    } else {
        [btImage setImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
    }
    
    if (animated) {
        self.hidden = NO;
        btImage.alpha = 0.0;
        btTitle.alpha = 0.0;
        
        [UIView animateWithDuration:0.00 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.frame = self.frameExpanding;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                btImage.frame = frameImageExpand;
                btImage.alpha = 1.0;
                btImage.transform=CGAffineTransformMakeScale(1.1, 1.1);
                
                btTitle.frame = frameTitleExpand;
                btTitle.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    btImage.transform=CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
        }];
    }
    else
    {
        self.hidden = NO;
        btImage.alpha = 0.0;
        
        self.frame = self.frameExpanding;
        
        btImage.frame = frameImageExpand;
        btImage.alpha = 1.0;
        
        if (titleShouldAnimate)
        {
            [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                btTitle.frame = frameTitleExpand;
                btTitle.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            btTitle.frame = frameTitleExpand;
            btTitle.alpha = 1.0;
        }
    }
}

- (void)collapsViewWithShouldHide:(BOOL)shouldHide animated:(BOOL)animated delay:(float)delay
{
    if (animated) {
        [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            if (shouldHide) {
                btImage.alpha = 0.0;
                btImage.frame = frameImageCollapse;
                btTitle.alpha = 0.0;
                btTitle.frame = frameTitleCollapse;
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.20 animations:^{
                if (shouldHide) {
                    btImage.alpha = 0.0;
                }
                self.frame = self.frameOrigin;
            } completion:^(BOOL finished) {
                if (shouldHide) {
                    self.hidden = YES;
                }
            }];
        }];
    }
    else
    {
        if (shouldHide) {
            btImage.alpha = 0.0;
            btImage.frame = frameImageCollapse;
            btTitle.alpha = 0.0;
            btTitle.frame = frameTitleCollapse;
        }
        if (shouldHide) {
            btImage.alpha = 0.0;
        }
        self.frame = self.frameOrigin;
        if (shouldHide) {
            self.hidden = YES;
        }
    }
}

/*- (void)tapAnimation
{
    [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        btImage.frame = frameImageExpand;
        btImage.alpha = 1.0;
        btImage.transform=CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            btImage.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}*/

#pragma mark - Actions
- (void)onImageBtClicked:(UIButton *)button
{
    [self notifyToDelegate];
}

- (void)onTitleBtClicked:(UIButton *)button
{
    [self notifyToDelegate];
}

- (void)notifyToDelegate
{
//    [self tapAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDropdownView:)]) {
        [self.delegate didSelectDropdownView:self];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@; frame = %@; hidden = %d; title = %@>",NSStringFromClass([self class]),NSStringFromCGRect(self.frame),self.isHidden,self.title];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@; frame = %@; hidden = %d; title = %@>",NSStringFromClass([self class]),NSStringFromCGRect(self.frame),self.isHidden,self.title];
}

@end
