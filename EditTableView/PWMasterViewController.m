//
//  PWMasterViewController.m
//  EditTableView
//
//  Created by Paul Wood on 9/16/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import "PWMasterViewController.h"

#import "PWDetailViewController.h"

@interface PWMasterViewController () {
    NSMutableArray *_objects;
    UIBarButtonItem *_addButton;
    UITextField *_currentTextField;
}
@end

@implementation PWMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = _addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    NSString *aString = [[NSDate date] description];
    [_objects insertObject:aString atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    UITextField *textView = (UITextField *)[cell.contentView viewWithTag:1];
    textView.delegate = self;
    textView.text = [object description];
    if (self.editing) {
        textView.enabled = YES;
    }
    else{
        textView.enabled = NO;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return self.editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (UITableViewCell *)superCellView:(UIView *)view{
    UIView *superView = view;
    while (![superView isKindOfClass:[UITableViewCell class]] && ![superView isKindOfClass:[UIWindow class]] ) {
        if ([[superView superview] isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)[superView superview];
        }
        else{
            superView = [superView superview];
        }
    }
    return nil;
}

- (void)updateTextField:(UITextField *)textField{
    UITableViewCell *cell = [self superCellView:textField];
    if (cell != nil) {
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        [_objects replaceObjectAtIndex:path.row withObject:textField.text];
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (_currentTextField) {
        [self updateTextField:_currentTextField];
    }
    [self.tableView reloadData];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _currentTextField = nil;
    [self updateTextField:textField];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//}


@end
