//
//  CustomDropDownView.h
//
//  Created by Minhaz Panara on 22/05/17.
//  Copyright © 2017 iQTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDropDownViewDelegate;

@interface CustomDropDownView : UIView

@property (nonatomic) NSString *title, *imageName, *statType, *imageNameFirstSelected;
@property (nonatomic) CGRect frameOrigin, frameExpanding;
@property (nonatomic) id <CustomDropDownViewDelegate> delegate;
@property (nonatomic) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName imageSize:(CGSize)imageSize titleGap:(CGFloat)titleGap titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor imageOrigin:(CGPoint)imageOrigin;
- (void)expandViewAnimated:(BOOL)animated delay:(float)delay titleShouldAnimate:(BOOL)titleShouldAnimate;
- (void)collapsViewWithShouldHide:(BOOL)shouldHide animated:(BOOL)animated delay:(float)delay;

@end

@protocol CustomDropDownViewDelegate <NSObject>

@optional
- (void)didSelectDropdownView:(CustomDropDownView *)dropdownView;
- (void)didTapOnBaseView;

@end
