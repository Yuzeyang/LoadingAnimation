//
//  ViewController.m
//  LoadingAnimation
//
//  Created by 宫城 on 15/12/16.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import "ViewController.h"
#import "LoadingView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingView.layer.cornerRadius = CGRectGetWidth(self.loadingView.frame)/2;
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:80/255.0 alpha:1].CGColor;
    [self.loadingView layoutIfNeeded];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
