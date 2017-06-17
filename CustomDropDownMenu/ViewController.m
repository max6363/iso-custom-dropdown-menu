//
//  ViewController.m
//  CustomDropDownMenu
//
//  Created by Minhaz on 18/06/17.
//  Copyright © 2017 iQTech. All rights reserved.
//

#import "ViewController.h"
#import "CustomDropDownHeader.h"

@interface ViewController () <CustomDropDownDelegate>
{
    __weak IBOutlet UIButton *btnDropDown;
    __weak IBOutlet CustomDropDown *theCustomDropdownButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CustomDropDownObject *item_A = [[CustomDropDownObject alloc] init];
    item_A.title = @"iOS";
    item_A.imageName = @"A.png";
    item_A.imageNameFirstSelected = @"A.png";
    
    CustomDropDownObject *item_B = [[CustomDropDownObject alloc] init];
    item_B.title = @"iPhone";
    item_B.imageName = @"B.png";
    item_B.imageNameFirstSelected = @"B.png";
    
    CustomDropDownObject *item_C = [[CustomDropDownObject alloc] init];
    item_C.title = @"iPad";
    item_C.imageName = @"C.png";
    item_C.imageNameFirstSelected = @"C.png";
    
    CustomDropDownObject *item_D = [[CustomDropDownObject alloc] init];
    item_D.title = @"iPod";
    item_D.imageName = @"D.png";
    item_D.imageNameFirstSelected = @"D.png";
    
    NSArray *items = @[
                       item_A,
                       item_B,
                       item_C,
                       item_D
                       ];
    
    theCustomDropdownButton.delegate = self;
    theCustomDropdownButton.menuBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    theCustomDropdownButton.colorForTitle = [UIColor whiteColor];
    theCustomDropdownButton.fontForTitle = [UIFont fontWithName:@"HelveticaNeue" size:28];
    [theCustomDropdownButton setupItems:items itemGap:10.0 titleGap:55.0];
    [theCustomDropdownButton setArrowButton:btnDropDown];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
