//
//  MyImagePickerViewController.m
//  cameratestapp
//
//  Created by pavan krishnamurthy on 6/24/14.
//  Copyright (c) 2014 pavan krishnamurthy. All rights reserved.
//

#import "CaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Palette.h"
#import "ColorFactory.h"

@interface CaptureViewController ()<PaletteDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic,strong) AVCaptureDevice *captureDevice;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic,assign) BOOL isCapturingImage;
@property(nonatomic,strong) UIImageView *capturedImageView;
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,strong) UIView *imageSelectedView;
@property(nonatomic,strong) UIImage *selectedImage;
@property(nonatomic,strong) UIImageView  *pickedColorImageView;

@end

@implementation CaptureViewController{
    Palette *palette;
    
    CGSize _boundSize;
    UIButton *_cancelSelectPhotoButton ;
    UIButton *_selectPhotoButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _boundSize = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captureSession = [[AVCaptureSession alloc]init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    self.capturedImageView = [[UIImageView alloc]init];
    self.capturedImageView.frame = self.view.frame; // just to even it out
    self.capturedImageView.backgroundColor = [UIColor clearColor];
    self.capturedImageView.userInteractionEnabled = YES;
    self.capturedImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > 0) {
        self.captureDevice = devices[0];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        
        [self.captureSession addInput:input];
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.captureSession addOutput:self.stillImageOutput];
        
        
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        }
        else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }
        
        UIButton *camerabutton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2-50, CGRectGetHeight(self.view.bounds)-100, 100, 100)];
        [camerabutton setImage:[UIImage imageNamed:@"take-snap"] forState:UIControlStateNormal];
        [camerabutton addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [camerabutton setTintColor:[UIColor blueColor]];
        [camerabutton.layer setCornerRadius:20.0];
        [self.view addSubview:camerabutton];
        
        UIButton *flashbutton = [[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetHeight(self.view.frame)-40, 32, 32)];
        [flashbutton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        [flashbutton setImage:[UIImage imageNamed:@"flashselected"] forState:UIControlStateSelected];
        [flashbutton addTarget:self action:@selector(flash:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:flashbutton];
        
        UIButton *frontcamera = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-35, CGRectGetHeight(self.view.frame)-40, 27, 27)];
        [frontcamera setImage:[UIImage imageNamed:@"front-camera"] forState:UIControlStateNormal];
        [frontcamera addTarget:self action:@selector(showFrontCamera:) forControlEvents:UIControlEventTouchUpInside];
        [frontcamera setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.2]];
        [self.view addSubview:frontcamera];
    }
    
    UIButton *album = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-50, 5, 47, 25)];
    [album setImage:[UIImage imageNamed:@"library"] forState:UIControlStateNormal];
    [album addTarget:self action:@selector(showalbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:album];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 31)];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    
    self.imageSelectedView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.imageSelectedView setBackgroundColor:[UIColor clearColor]];
    [self.imageSelectedView addSubview:self.capturedImageView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.captureSession startRunning];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.captureSession stopRunning];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//将控制按钮前置
-(void)setFontControllerView{
    CGRect  overlayFrame  = CGRectMake(0,self.view.frame.size.height-60, self.view.frame.size.width, 60);
    
    if (_selectPhotoButton==nil) {
        _selectPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(overlayFrame.size.width-40, 20, 32, 32)];
        [_selectPhotoButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [_selectPhotoButton addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectPhotoButton];
    }else{
        [self.view bringSubviewToFront:_selectPhotoButton];
    }
   
    if (_cancelSelectPhotoButton==nil) {
        _cancelSelectPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 32, 32)];
        [_cancelSelectPhotoButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelSelectPhotoButton addTarget:self action:@selector(cancelSelectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelSelectPhotoButton];

    }else{
        [self.view bringSubviewToFront:_cancelSelectPhotoButton];
    }
}

-(void)capturePhoto:(id)sender
{
    self.isCapturingImage = YES;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *capturedImage = [[UIImage alloc]initWithData:imageData scale:8];
            NSLog(@"capturedImage:%f,%f",capturedImage.size.width,capturedImage.size.height);
            
            [self.imageSelectedView setFrame:CGRectMake(0,0,capturedImage.size.width,capturedImage.size.height)];
            [self.capturedImageView setFrame:CGRectMake(0,0,capturedImage.size.width,capturedImage.size.height)];
            
          
            capturedImage = [self scaleToSize:capturedImage size:CGSizeMake(_boundSize.width*2, _boundSize.height*2)];
            
            palette = [[Palette alloc]initWithFrame:CGRectMake(0,0,capturedImage.size.width/2,capturedImage.size.height/2)];
            palette.image =capturedImage;
            [palette setImageView];
            palette.paletteDelegate =self;
            [self.view addSubview:palette];
            
            [self setFontControllerView];
        }
    }];
}



- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


-(void)flash:(UIButton*)sender
{
    if ([self.captureDevice isFlashAvailable]) {
        if (self.captureDevice.flashActive) {
            if([self.captureDevice lockForConfiguration:nil]) {
                self.captureDevice.flashMode = AVCaptureFlashModeOff;
                [sender setTintColor:[UIColor grayColor]];
                [sender setSelected:NO];
            }
        }
        else {
            if([self.captureDevice lockForConfiguration:nil]) {
                self.captureDevice.flashMode = AVCaptureFlashModeOn;
                [sender setTintColor:[UIColor blueColor]];
                [sender setSelected:YES];
            }
        }
        [self.captureDevice unlockForConfiguration];
    }
}

-(void)showFrontCamera:(id)sender
{
    if (self.isCapturingImage != YES) {
        if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
            // rear active, switch to front
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1];
            
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            for (AVCaptureInput * oldInput in self.captureSession.inputs) {
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:newInput];
            [self.captureSession commitConfiguration];
        }
        else if (self.captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
            // front active, switch to rear
            self.captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
            for (AVCaptureInput * oldInput in self.captureSession.inputs) {
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:newInput];
            [self.captureSession commitConfiguration];
        }
        // Need to reset flash btn
    }
}

-(void)showalbum:(id)sender
{
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)photoSelected:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [palette removeFromSuperview];
    }];
}

-(void)cancelSelectedPhoto:(id)sender
{
    if (palette !=nil) {
        [palette removeFromSuperview];
    }
    if (_selectPhotoButton !=nil) {
        [_selectPhotoButton removeFromSuperview];
        _selectPhotoButton = nil;
    }
    if (_cancelSelectPhotoButton !=nil) {
        [_cancelSelectPhotoButton removeFromSuperview];
        _cancelSelectPhotoButton  = nil;
    }
    if ( self.pickedColorImageView !=nil) {
        [self.pickedColorImageView removeFromSuperview];
        self.pickedColorImageView = nil;
    }
    
    UIView *aView =[self.view viewWithTag:99999];
    if (aView !=nil) {
        [aView removeFromSuperview];
        aView  = nil;
    }
   
}

-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self scaleToSize:image size:CGSizeMake(_boundSize.width*2, _boundSize.height*2)];
    if (palette==nil) {
        palette = [[Palette alloc]initWithFrame:CGRectMake(0,0,image.size.width/2,image.size.height/2)];
        palette.image = image;
    }
    palette.paletteDelegate =self;
    [self dismissViewControllerAnimated:YES completion:^{
        [palette setImageView];
        [self.view addSubview:palette];
        [self setFontControllerView];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeColor:(UIColor *)_colorDic Location:(CGPoint)point{
    if (self.pickedColorImageView==nil) {
        self.pickedColorImageView  =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,100,100)];
        self.pickedColorImageView.image =[UIImage imageNamed:@"roundMask.png"];
        [self.view addSubview:self.pickedColorImageView];
    }
    self.pickedColorImageView.center = CGPointMake(point.x/2, point.y/2);
    [self.view bringSubviewToFront:self.pickedColorImageView];
    [self changColorOfImage:[UIImage imageNamed:@"roundMask.png"] withColor:_colorDic];
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alph;
    [_colorDic getRed:&red green:&green blue:&blue alpha:&alph];
    
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alp;
    [_colorDic getHue:&hue saturation:&saturation brightness:&brightness alpha:&alp];
    
    UIView *aView =[self.view viewWithTag:99999];
    if (aView==nil) {
        aView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-60, self.view.frame.size.width,60)];
        aView.tag = 99999;
        //        aView.alpha = 0.3;
        [self.view addSubview:aView];
    }
    aView.backgroundColor = _colorDic;
    UIButton *dataBtn = (UIButton *)[aView viewWithTag:99998];
    if (dataBtn ==nil) {
        dataBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        dataBtn.tag = 99998;
        dataBtn.backgroundColor = [UIColor clearColor];
        dataBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        dataBtn.titleLabel.numberOfLines =3;
        [aView addSubview:dataBtn];
    }
        [dataBtn setTitle:[NSString stringWithFormat:@"RGB  R:%.2f,G:%.2f,B:%.2f\nHSB  H:%.2f,S:%.2f,B:%.2f\nHex16  %@",red,green,blue,hue,saturation,brightness,[ColorFactory turnRGBToHex16:red*255 G:green*255 B:blue*255]] forState:UIControlStateNormal];
         dataBtn.frame = CGRectMake(0,0,aView.frame.size.width,aView.frame.size.height);
}



- (void)changColorOfImage:(UIImage*)inImage withColor:(UIColor *)color{
    CGImageRef inImageRef = [inImage CGImage];
    float w = CGImageGetWidth(inImageRef);
    float h = CGImageGetHeight(inImageRef);
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h), inImageRef);
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSourceIn);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    self.pickedColorImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


@end
