# Download Blob Link in Flutter WebView 

[English](./README.md)   [中文简体](./README_zh.md)

## Introduction

According to the business logic, I need to use WebView to download blob videos in Flutter. After looking online for a long time, I haven't found a suitable solution that can adapt to Android and iOS at the same time, so I had to just write it by myself. Different ideas are used. The basic idea is:

1. Start a simple back-end service in Flutter. I choose Jaguar here
2. Download the Blob and convert it to File, then post it as FormData

## Environment

```

```

Doctor summary (to see all details, run flutter doctor -v):
[√] Flutter (Channel stable, 2.2.2, on Microsoft Windows [Version 10.0.16299.1087], locale zh-CN)
[√] Android toolchain - develop for Android devices (Android SDK version 30.0.3)
[√] Chrome - develop for the web
[√] Android Studio (version 3.5)
[√] IntelliJ IDEA Ultimate Edition (version 2021.1)
[√] Connected device (2 available)

```

```

pubspec.yaml

```
jaguar: ^3.0.4
jaguar_cors: any
permission_handler: ^7.1.0
gallery_saver: ^2.1.2
```





## Usage

1. Build Flutter APP，and click the button at the right bottom.
2. Change the blob url and the backend address in blob.html，then clicke SAVE TEST FILE



## Note

- null safety is not using.
- Notice about CORS，referring to [Jaguar CORS](https://pub.dev/packages/jaguar_cors)





## Reference

- [Jaguar](https://pub.dartlang.org/packages/jaguar) 
- [Jaguar CORS](https://pub.dev/packages/jaguar_cors)

- https://blog.csdn.net/timebeign/article/details/106690947

