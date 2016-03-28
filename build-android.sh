
# Avro-specific vars
AVRO_VERSION=1.7.7
AVRO_FULL=avro-cpp-$AVRO_VERSION

# Useful directories
TOPDIR=$(pwd)
PREBUILT_DIR=$TOPDIR/prebuilt
NDK_TOOLS_DIR=$NDK_HOME/build/tools
CMOSS_DIR=$TOPDIR/../cmoss/prebuilts

# List of architectures for which to build Avro
declare -a ARCHITECTURES=("armv7" "x86")

# Build Avro for each architecture  
for ARCHI in "${ARCHITECTURES[@]}"
do

  # Remove old folder and untar the file
  cd $TOPDIR
  rm -rf $AVRO_FULL
  tar xvf $AVRO_FULL.tar

  # Copy make files into the dir
  cp *.cmake $AVRO_FULL/

  # For each architecture
  pushd $AVRO_FULL  

  # Apply the necessary patch
  patch -p 1 < ../update_file_writer.patch

  # Set toolchain to create based on selected architecture
  if [ $ARCHI == "armv7" ] 
  then
    TOOLCHAIN="arm-linux-androideabi-4.9"
  else
    TOOLCHAIN="x86-4.9"
  fi

  # Create standalone toolchain
  $NDK_TOOLS_DIR/make-standalone-toolchain.sh \
    --platform=android-19 \
    --install-dir=android-toolchain \
    --ndk-dir=$NDK_HOME \
    --system=darwin-x86_64 \
    --toolchain=$TOOLCHAIN

  # Cmake the project
  cmake \
    -DCMAKE_TOOLCHAIN_FILE=android.toolchain.cmake \
    -DBoost_INCLUDE_DIR=$CMOSS_DIR/include \
    -DBoost_LIBRARY_DIR=$CMOSS_DIR/lib/$ARCHI \
    -DANDROID_STANDALONE_TOOLCHAIN=android-toolchain

  # Make the project (make avrocpp_s)
  make clean
  make avrocpp_s

  # Copy the file into the prebuilts directory
  mkdir -p $PREBUILT_DIR/android/
  mkdir -p $PREBUILT_DIR/android/$ARCHI/
  cp libavrocpp_s.a $PREBUILT_DIR/android/$ARCHI/libavro.a

done
