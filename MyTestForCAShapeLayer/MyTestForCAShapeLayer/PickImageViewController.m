//
//  PickImageViewController.m
//  MyTestForCAShapeLayer
//
//  Created by 酷酷的1xd on 16/2/17.
//  Copyright © 2016年 酷酷的1xd. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#import "PickImageViewController.h"

@interface PickImageViewController ()<UIImagePickerControllerDelegate>

@end

@implementation PickImageViewController{
    UIAlertController *alertVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    btn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [btn addTarget:self action:@selector(selectImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
    alertVC = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"This is an alert."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"take_photo" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"selec_photo" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertVC addAction:defaultAction];
    [alertVC addAction:defaultAction2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectImg{
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)takePhoto{
    UIImagePickerController *con = [[UIImagePickerController alloc]init];
    con.delegate = self;
    con.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)selectPhoto{
    UIImagePickerController *con = [[UIImagePickerController alloc]init];
    con.delegate = self;
    con.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
