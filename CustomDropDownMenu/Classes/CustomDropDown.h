//
//  CustomDropDown.h
//
//  Created by Minhaz Panara on 22/05/17.
//  Copyright © 2017 iQTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomDropDownView;
@protocol CustomDropDownDelegate;

@interface CustomDropDown : UIButton

@property (nonatomic) id <CustomDropDownDelegate> delegate;
@property (nonatomic) UIColor *menuBackgroundColor;
@property (nonatomic) UIFont *fontForTitle;
@property (nonatomic) UIColor *colorForTitle;

- (void)setArrowButton:(UIButton *)button;
- (void)setupItems:(NSArray *)items itemGap:(CGFloat)itemGap titleGap:(CGFloat)titleGap;
- (void)collapsDropdownIfNeeded;

@end

@protocol CustomDropDownDelegate <NSObject>
@optional
- (void)dropdown:(CustomDropDown *)dropdown didSelectWithDropdownItemView:(CustomDropDownView *)dropdownItemview;

@end
