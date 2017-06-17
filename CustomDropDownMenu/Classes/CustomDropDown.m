//
//  CustomDropDown.m
//
//  Created by Minhaz Panara on 22/05/17.
//  Copyright © 2017 iQTech. All rights reserved.
//

#import "CustomDropDown.h"
#import "CustomDropDownObject.h"
#import "CustomDropDownView.h"

@interface CustomDropDown () <CustomDropDownViewDelegate>
{
    NSMutableArray *allItems;
    UIView *viewBackground;
    BOOL isExpand;
    CGFloat item_gap;
    NSInteger selectedIndex;
    CGPoint point_origin;
    UIButton *btnArrow;
    CGPoint arrow_origin;
}
@end

@implementation CustomDropDown

- (void)awakeFromNib
{
    [super awakeFromNib];
    selectedIndex = 0;
    isExpand = NO;
    allItems = [NSMutableArray array];
    self.menuBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [self removeTarget:self action:@selector(dropdonwBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(dropdonwBtClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Drop down selection
- (void)dropdonwBtClicked:(CustomDropDown *)btn
{
    [self toggleDropDown];
}

- (void)toggleDropDown
{
    isExpand = !isExpand;
    if (isExpand) {
        [self expandDropdown];
    } else {
        [self collapsDropdown];
    }
}

- (void)expandDropdown
{
    isExpand = YES;
    if (allItems.count > 0) {
        [self addBackground];
        [self addArrow];
    }
    
    float delay_diff = 0.05f;
    float delay = 0.0;
    
    for (NSInteger i = 0; i < allItems.count; i++) {
        CustomDropDownView *view = allItems[i];
        [view.superview bringSubviewToFront:view];
        BOOL animated = (i == 0 ? NO : YES);
        [view expandViewAnimated:animated delay:delay titleShouldAnimate:YES];
        delay += delay_diff;
    }
}

- (void)collapsDropdown
{
    isExpand = NO;
    
    float delay_diff = 0.05f;
    float delay = 0.0;
    
    for (NSInteger i = allItems.count - 1; i > 0; i--) {
        CustomDropDownView *view = allItems[i];
        BOOL shouldHide = (i == 0 ? NO : YES);
        [view collapsViewWithShouldHide:shouldHide animated:YES delay:delay];
        delay += delay_diff;
    }
    [self performSelector:@selector(hideFirstDropDownContentViewAndThenBackground) withObject:nil afterDelay:0.15];
}

- (void)collapsDropdownIfNeeded
{
    [self collapsDropdown];
}

- (void)hideFirstDropDownContentViewAndThenBackground
{
    [self removeArrow];
    [self hideFirstDropDownContentView];
    [self removeBackgroundAnimated:NO];
    [self resetItemsWithLastIndex:selectedIndex];
    selectedIndex = 0;
}

- (void)hideFirstDropDownContentView
{
    CustomDropDownView *view = allItems.firstObject;
    [view collapsViewWithShouldHide:YES animated:NO delay:0.0];
}

- (void)setArrowButton:(UIButton *)button
{
    if (!btnArrow) {
        btnArrow = [self copyButton:button];
        btnArrow.translatesAutoresizingMaskIntoConstraints = YES;
        
        // Convert the co-ordinates of the view into the window co-ordinate space
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        arrow_origin = [button.superview convertPoint:button.frame.origin toView:window];
        
        CGRect f = btnArrow.frame;
        f.origin = arrow_origin;
        btnArrow.frame = f;
        
        [window addSubview:btnArrow];
    }
    btnArrow.hidden = YES;
}

- (UIButton *)copyButton:(UIButton *)button
{
    NSData *buffer;
    buffer = [NSKeyedArchiver archivedDataWithRootObject:button];
    UIButton *copy = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
    return copy;
}

#pragma mark - Setup Items
- (void)setupItems:(NSArray *)items itemGap:(CGFloat)itemGap titleGap:(CGFloat)titleGap
{
    CustomDropDownView *firstItem = items.firstObject;
    if (firstItem.imageNameFirstSelected != nil) {
        [self setImage:[UIImage imageNamed:firstItem.imageNameFirstSelected] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:firstItem.imageName] forState:UIControlStateNormal];
    }

    [allItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [allItems removeAllObjects];
    
    // Convert the co-ordinates of the view into the window co-ordinate space
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    point_origin = [self.superview convertPoint:self.frame.origin toView:window];
    
    item_gap = itemGap;
    
    CGFloat x = 0;
    CGFloat y = point_origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGRect frameOrigin = CGRectMake(0, y, 300.0, height);
    
    UIFont *font = (self.fontForTitle != nil ? self.fontForTitle : [UIFont systemFontOfSize:25]);
    UIColor *titleColor =  (self.colorForTitle != nil ? self.colorForTitle : [UIColor blackColor]);
    
    NSInteger index = 0;
    for (CustomDropDownObject *object in items)
    {
        CGRect f = CGRectMake(x, y, 300.0, height);
        CGSize size = CGSizeMake(width, height);
        CustomDropDownView *view = [[CustomDropDownView alloc] initWithFrame:frameOrigin
                                                                       title:object.title
                                                                   imageName:object.imageName
                                                                   imageSize:size
                                                                    titleGap:titleGap
                                                                   titleFont:font
                                                                  titleColor:titleColor imageOrigin:point_origin];
        view.frameExpanding = f;
        view.frameOrigin = frameOrigin;
        view.delegate = self;
        view.index = index;
        view.statType = object.statType;
        view.imageNameFirstSelected = object.imageNameFirstSelected;
        [window addSubview:view];
        
        // update components
        y = y + height + itemGap;
        index += 1;
        
        [allItems addObject:view];
        view.hidden = YES;
    }
}

- (void)resetItems
{
    [allItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    CGFloat height = self.frame.size.height;
    CGFloat x = 0;
    CGFloat y = point_origin.y;
    CGRect frameOrigin = CGRectMake(0, y, 300.0, height);
    
    NSInteger index = 0;
    
    for (CustomDropDownView *view in allItems)
    {
        view.frame = frameOrigin;
        
        CGRect f = CGRectMake(x, y, 300.0, height);
        view.frameExpanding = f;
        view.index = index;
        [window addSubview:view];
        
        // update components
        y = y + height + item_gap;
        index += 1;
        
        view.hidden = YES;
    }
}

- (void)addArrow
{
    btnArrow.hidden = NO;
    [btnArrow.superview bringSubviewToFront:btnArrow];
//    [btnArrow setBorderWithRedColor];
}

- (void)removeArrow
{
    btnArrow.hidden = YES;
}

- (void)addBackground
{
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    [viewBackground removeFromSuperview];
    
    if (!viewBackground) {
        viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTapOnBackgroundViewWithRecognizer:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        [viewBackground addGestureRecognizer:tapGes];
    }
    viewBackground.alpha = 0.0;
    viewBackground.backgroundColor = self.menuBackgroundColor;
    [window addSubview:viewBackground];
    
    [UIView animateWithDuration:0.1 animations:^{
        viewBackground.alpha = 1.0;
    }];
}

- (void)removeBackgroundAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
            viewBackground.alpha = 0.0;
        } completion:^(BOOL finished) {
            [viewBackground removeFromSuperview];
        }];
    }
    else
    {
        [viewBackground removeFromSuperview];
    }
}

#pragma mark - Handle Tap Gesture
- (void)handTapOnBackgroundViewWithRecognizer:(UITapGestureRecognizer *)recognizer
{
    [self collapsDropdown];
}

#pragma mark - CustomDropDownViewDelegate
- (void)didSelectDropdownView:(CustomDropDownView *)dropdownView
{
    if (dropdownView.imageNameFirstSelected != nil) {
        [self setImage:[UIImage imageNamed:dropdownView.imageNameFirstSelected] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:dropdownView.imageName] forState:UIControlStateNormal];
    }
    
    [self collapsDropdown];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropdown:didSelectWithDropdownItemView:)]) {
        [self.delegate dropdown:self didSelectWithDropdownItemView:dropdownView];
    }
    selectedIndex = dropdownView.index;
}

- (void)resetItemsWithLastIndex:(NSInteger)index
{
    if (index != 0) {
        self.userInteractionEnabled = NO;
        
        // exchange objects
        [allItems exchangeObjectAtIndex:0 withObjectAtIndex:index];
        // reset items
        [self resetItems];
        
        self.userInteractionEnabled = YES;
    }
}

- (void)didTapOnBaseView
{
    [self collapsDropdown];
}

@end
