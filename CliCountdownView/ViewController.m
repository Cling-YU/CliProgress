//
//  ViewController.m
//  CliCountdownView
//
//  Created by yhq on 16/6/7.
//  Copyright © 2016年 YU. All rights reserved.
//

#import "ViewController.h"
#import "CliLabel.h"
#import "CliCountdownProgress.h"
#import "CliPopView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [CliCountdownProgress showProgressWithFrame:CGRectMake(40, 300, 375 - 80, 5) sliderHeight:20 sections:10 inView:self.view finish:^{
        NSLog(@"完成");
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
