FROM ubuntu:latest

LABEL maintainer="sk8geri@gmail.com"

# change repository for performance and enable other packages
RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup \
  && sed \
  -e 's#deb http://archive.ubuntu.com/ubuntu/ bionic universe#deb http://archive.ubuntu.com/ubuntu/ bionic universe#g' \
  -e 's#deb http://archive.ubuntu.com/ubuntu/ bionic-updates universe#deb http://archive.ubuntu.com/ubuntu/ bionic-updates universe#g' \
  -e 's#deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates universe#deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates universe#g' \
  -e 's#deb-src http://archive.ubuntu.com/ubuntu/ bionic universe#deb-src http://archive.ubuntu.com/ubuntu/ bionic universe#g' \
  -e 's#\# deb http://archive.ubuntu.com/ubuntu/ bionic-security multiverse#deb http://archive.ubuntu.com/ubuntu/ bionic-security#g' \
  -e 's#\# deb-src http://archive.ubuntu.com/ubuntu/ bionic-security multiverse#deb-src http://archive.ubuntu.com/ubuntu/ bionic-security#g' \
  -e 's#archive.ubuntu.com#br.archive.ubuntu.com#g' /etc/apt/sources.list.backup > /etc/apt/sources.list

# install PHP extensions that are needed
RUN apt-get update && apt-get install -y software-properties-common imagemagick build-essential \
  subversion git-core checkinstall texi2html libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev \
  libtheora-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev zlib1g-dev libavcodec-dev nasm yasm libfaac0 wget apt-utils \
  dcraw ufraw gpac unzip\
  && apt-get update -y \
  && apt-get clean

# install OpenJDK version 8
RUN apt-get install -y openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

# install x264 codec
RUN cd /opt && git clone --depth=1 git://git.videolan.org/x264.git && cd x264 \
  && ./configure --enable-static --disable-opencl --disable-asm && make \
  && checkinstall --pkgname=x264 --default --backup=no --deldoc=yes --fstrans=no --pkgversion=3.4.5 \
  && cd ../ && rm -rf x264

# install lame
RUN cd /opt && wget -nv http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz \
  && tar xzvf lame-3.98.4.tar.gz && cd lame-3.98.4 \
  && ./configure --enable-nasm --disable-shared \
  && make \
  && checkinstall --pkgname=lame-ffmpeg --pkgversion="3.98.4" --backup=no --default --deldoc=yes \
  && cd ../ && rm -rf lame-3.98.4

# install libvpx
RUN cd /opt && git clone --depth=1 https://chromium.googlesource.com/webm/libvpx.git \
  && cd libvpx \
  && ./configure \
  && make \
  && checkinstall --pkgname=libvpx --pkgversion="`date +%Y%m%d%H%M`-git" --backup=no \
  --default --deldoc=yes \
  && cd ../ && rm -rf libvpx

# install ffmpeg
RUN cd /opt && git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git && cd ffmpeg \
  && ./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc \
  --enable-libopencore-amrnb --enable-libopencore-amrwb \
  --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid \
  --enable-libvpx --enable-libmp3lame \
  && make \
  && checkinstall --pkgname=ffmpeg --pkgversion=`./version.sh | sed -e "s#git-##g"` --backup=no --deldoc=yes --default \
  && cd ../ && rm -rf ffmpeg

# install Exiftool
RUN cd /opt && git clone --depth=1 https://github.com/exiftool/exiftool.git \
  && cd exiftool \
  && perl Makefile.PL && make install \
  && cd ../ && rm -rf exiftool

#configure Java home variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# install razuna
RUN cd /opt && wget -nv http://cloud.razuna.com/installers/1.9.6/razuna_tomcat_1_9_6.zip \
  && unzip -q razuna_tomcat_1_9_6.zip && mv razuna_tomcat_1_9_6 razuna \
  && rm razuna_tomcat_1_9_6.zip

EXPOSE 8080

WORKDIR /opt/razuna/tomcat/bin
CMD ["./catalina.sh", "run"]
