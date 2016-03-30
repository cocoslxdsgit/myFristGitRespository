//
//  ViewController.m
//  MyTestForCAShapeLayer
//
//  Created by 酷酷的1xd on 16/2/15.
//  Copyright © 2016年 酷酷的1xd. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "ViewController.h"
#import "PickImageViewController.h"
#import "XdEditableView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) PickImageViewController *pickVC;

@end

@implementation ViewController{
    UIAlertController *alertVC;
    NSString *filePath;
    NSData *imgData;
    UIView *scrollViewHeader;
    CAShapeLayer *subLayer;
    CAShapeLayer *subLayer2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    XdEditableView *view = [[XdEditableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [self.view addSubview:view];
    
    //[self initTableView];
    // Do any additional setup after loading the view, typically from a nib.
    //[self initBtn];
    
}

- (void)initBtn{
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
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"打开相机");
                                                              [self takePhoto];
                                                          }];
    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"本地相册");
                                                              [self LocalPhoto];
                                                          }];
    [alertVC addAction:defaultAction];
    [alertVC addAction:defaultAction2];
}

- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.tableHeaderView.backgroundColor = [UIColor greenColor];
    //_tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH, 200)];
    //_tableHeaderView.backgroundColor = [UIColor greenColor];
    [_tableView addSubview:[self setScrollHeader]];
    [self.view addSubview:_tableView];
}

- (UIView *)setScrollHeader{
    scrollViewHeader = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, 80)];
        view.backgroundColor = [UIColor greenColor];
        subLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(view.frame), 0) controlPoint:CGPointMake(CGRectGetMidX(view.frame), CGRectGetHeight(view.frame))];
        subLayer.path = path.CGPath;
        subLayer.strokeColor = [UIColor blueColor].CGColor;
        subLayer.fillColor = [UIColor greenColor].CGColor;
        subLayer.lineWidth = 2;
        [view.layer addSublayer:subLayer];
        subLayer2 = [[CAShapeLayer alloc]init];
        subLayer2.strokeColor = [UIColor blueColor].CGColor;
        subLayer2.lineWidth = 2;
        subLayer2.strokeStart = 0.5;
        subLayer2.strokeEnd = 0.5;
        UIBezierPath *path2 = [[UIBezierPath alloc]init];
        [path2 moveToPoint:CGPointMake(0, 75)];
        [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH, 75)];
        subLayer2.path = path2.CGPath;
        [view.layer addSublayer:subLayer2];
        view;
    });
    return scrollViewHeader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}

- (void)selectImg{
    [self presentViewController:alertVC animated:YES completion:nil];
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSString *imgDataStr;
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        imgDataStr = [data base64EncodedStringWithOptions:0];
        NSLog(imgDataStr);
        NSString *imgDataStr2 = [imgDataStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(imgDataStr2);
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(50, 120, 40, 40)];
        
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
        
    }
    NSString *httpUrl = @"http://apis.baidu.com/idl_baidu/ocrbankcard/ocrbankcard";  //如果出现代理错误，尝试使用https：开头的url
    NSString *httpArg = [NSString stringWithFormat:@"fromdevice=pc&clientip=10.10.10.0&languagetype=CHN_ENG&image=%@",imgDataStr];
    //
    //!!! 具体代码可以参考 http://bbs.apistore.baidu.com/forum.php?mod=viewthread&tid=642&extra= 中的IOS代码
    //
    [self request: httpUrl withHttpArg: httpArg];
    
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSURL *url = [NSURL URLWithString: httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"POST"];
    [request addValue: @"您自己的apikey" forHTTPHeaderField: @"apikey"];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [HttpArg dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<0) {
        [subLayer removeFromSuperlayer];
        subLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *path = [[UIBezierPath alloc]init];
        scrollViewHeader.frame = CGRectMake(0, scrollView.contentOffset.y, SCREEN_WIDTH, -scrollView.contentOffset.y);
        [path moveToPoint:CGPointMake(0, 0)];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(scrollViewHeader.frame), 0) controlPoint:CGPointMake(CGRectGetMidX(scrollViewHeader.frame), CGRectGetHeight(scrollViewHeader.frame))];
        subLayer.path = path.CGPath;
        subLayer.strokeColor = [UIColor blueColor].CGColor;
        subLayer.fillColor = [UIColor greenColor].CGColor;
        subLayer.lineWidth = 2;
        [scrollViewHeader.layer addSublayer:subLayer];
        [subLayer2 removeFromSuperlayer];
        subLayer2 = [[CAShapeLayer alloc]init];
        subLayer2.strokeColor = [UIColor blueColor].CGColor;
        subLayer2.lineWidth = 2;
        UIBezierPath *path2 = [[UIBezierPath alloc]init];
        [path2 moveToPoint:CGPointMake(0, CGRectGetHeight(scrollViewHeader.frame)-2)];
        [path2 addLineToPoint:CGPointMake(SCREEN_WIDTH, CGRectGetHeight(scrollViewHeader.frame)-2)];
        subLayer2.path = path2.CGPath;
        [scrollViewHeader.layer addSublayer:subLayer2];
        if (scrollView.contentOffset.y==0) {
            subLayer2.strokeStart = 0.5;
            subLayer2.strokeEnd = 0.5;
        }
        else if (scrollView.contentOffset.y<= 0&&scrollView.contentOffset.y>-20) {
            subLayer2.strokeStart = 0.5-0.125;
            subLayer2.strokeEnd = 0.5+0.125;
        }else if (scrollView.contentOffset.y<=-20&&scrollView.contentOffset.y>-40) {
            subLayer2.strokeStart = 0.5-0.125*2;
            subLayer2.strokeEnd = 0.5+0.125*2;
        }else if (scrollView.contentOffset.y<=-40&&scrollView.contentOffset.y>-60) {
            subLayer2.strokeStart = 0.5-0.125*3;
            subLayer2.strokeEnd = 0.5+0.125*3;
        }else if (scrollView.contentOffset.y<=-60) {
            subLayer2.strokeStart = 0;
            subLayer2.strokeEnd = 1;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
@end
