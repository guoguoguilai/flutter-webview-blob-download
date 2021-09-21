# Download Blob Link in Flutter WebView 
[English](./README.md)   [中文简体](./README_zh.md)

## 前言

根据业务逻辑，需要在Flutter中使用WebView下载Blob视频，在网上找了好久，都没有找到合适的方案能够同时适应Android和iOS，所以干脆自己写一个。用了不同的思路，基本思想是：

1. 在Flutter中开启一个简单的后端服务，我这里选用的是Jaguar
2. 下载Blob并将其转换为File，然后作为formData Post出去

## 环境

Doctor summary (to see all details, run flutter doctor -v):
[√] Flutter (Channel stable, 2.2.2, on Microsoft Windows [Version 10.0.16299.1087], locale zh-CN)
[√] Android toolchain - develop for Android devices (Android SDK version 30.0.3)
[√] Chrome - develop for the web
[√] Android Studio (version 3.5)
[√] IntelliJ IDEA Ultimate Edition (version 2021.1)
[√] Connected device (2 available)



pubspec.yaml

```
jaguar: ^3.0.4
jaguar_cors: any
permission_handler: ^7.1.0
gallery_saver: ^2.1.2
```





## 使用方法

1. 构建Flutter APP，点击加号开启后端服务
2. 修改blob.html中的blob地址和后端地址，然后点击SAVE TEST FILE



## 注意事项

- 未使用null safety
- 注意CORS，具体请参照[Jaguar CORS](https://pub.dev/packages/jaguar_cors)





## 参考

- [Jaguar](https://pub.dartlang.org/packages/jaguar) 
- [Jaguar CORS](https://pub.dev/packages/jaguar_cors)

- https://blog.csdn.net/timebeign/article/details/106690947

