### iOS Instructions

#### 0. Untar the Avro-CPP sources into the dir
```
tar zxvf avro-cpp-1.7.7.tar
cd avro-cpp-1.7.7
```

#### 1. Apply the `update_file_writer` patch

`patch -p 1 < ../update_file_writer.patch`

#### 2. Generate XCode project using CMake

```
BOOST_LIBRARYDIR=/Users/jtomson/sandbox/babbage/3rdparty/boost-darwin-cook/prebuilt/lib/ios/ \
BOOST_INCLUDEDIR=/Users/jtomson/sandbox/babbage/3rdparty/boost-darwin-cook/prebuilt/include/ \
cmake -G Xcode
```

#### 3. Open XCode Project and ....
  - change `Base SDK` for the project to latest iOS
  - change  `Supported Platforms` to iOS
  - replace all `Valid Architectures` with `$(ARCHS_STANDARD)`
  - set `Build Active Architectures Only` to `NO`
  - set `Deployment Target` to the base iOS version to support
  - set `Inline Methods Hidden` and `Symbols Hidden by Default` to `YES`
  - click the '+' to add a `User-Defined Setting` with the name `BITCODE_GENERATION_MODE` and the value `bitcode`

#### 4. Build avrocpp_s for iOS simulator and Device targets
```
xcodebuild -target avrocpp_s -config RelWithDebInfo -sdk iphoneos
xcodebuild -target avrocpp_s -config RelWithDebInfo -sdk iphonesimulator
```

#### 5. Lipo those suckers

```
lipo -create \
RelWithDebInfo-iphoneos/libavrocpp_s.a \
RelWithDebInfo-iphonesimulator/libavrocpp_s.a \
-o libavrocpp.a 
```

#### 6. Stick it in the prebuilt lib

```
mv libavrocpp.a ../prebuilt/ios/libavrocpp.a

```

##### 7. Update the header files

```
rm -rf ../prebuilt/include/*
cp -R api/ ../prebuilt/include
```

### Android NDK Instructions

coming soon!
