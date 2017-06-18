# iOS-Dropdown-Menu
> Customizable dropdown menu for iOS.

# Screenshot 
> ![ios-dropdown-menu](https://github.com/max6363/iso-custom-dropdown-menu/blob/master/dropdown-menu-ios.png)

# Video
> [![ios-dropdown-menu](https://img.youtube.com/vi/lNTI6v7qJPg/0.jpg)](https://www.youtube.com/watch?v=lNTI6v7qJPg)

## Usage
> 1.
> Get UIButton in UIStoryboard and inherit from CustomDropDown

> 2.
> Write code in ViewController to setup once.

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
> 3.
> implement protocols.
    - (void)dropdown:(CustomDropDown *)dropdown didSelectWithDropdownItemView:(CustomDropDownView *)dropdownItemview
    {
        NSLog(@"title : %@",dropdownItemview.title);
    }


## Author
> Minhaz Panara, minhaz.panara@gmail.com
