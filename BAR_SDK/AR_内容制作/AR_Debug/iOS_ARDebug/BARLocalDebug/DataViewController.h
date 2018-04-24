//
//  DataViewController.h
//  BARLocalDebug
//
//
//  Created by shangyang1027 on 2017/5/3.
//  Copyright © 2017年 ccytsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
- (IBAction)trackClicked:(id)sender;

- (void)showARView:(int)type arInfo:(id)info;
@end

