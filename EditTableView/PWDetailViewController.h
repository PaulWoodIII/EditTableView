//
//  PWDetailViewController.h
//  EditTableView
//
//  Created by Paul Wood on 9/16/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
