FROM openjdk:8-jdk
LABEL maintainer="Paulo Gomes da Cruz Junior <paulushc@gmail.com>"

#Setting Android Compile SDK Version
ENV ANDROID_COMPILE_SDK="26"

#Setting Android Build Tools Version
ENV ANDROID_BUILD_TOOLS="26.0.1"

#Setting Android SDK Tools Version
ENV ANDROID_SDK_TOOLS="26.0.1"

#Setting SDK Tools Folder
RUN mkdir -p /android-sdk-linux/

#Setting Android Home Path
ENV ANDROID_HOME=/android-sdk-linux

#Setting Android Platform Tools on Path 
ENV PATH="${PATH}:${HOME}/bin:${ANDROID_HOME}/platform-tools"

#Running Required Updates
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1

#Download and prepare all the android SDK stuff
RUN wget --quiet --output-document=/android-sdk-linux/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
RUN unzip /android-sdk-linux/android-sdk.zip -d /android-sdk-linux/

#Install dependencies
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" "extras;google;m2repository"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" "extras;google;google_play_services"
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" "extras;android;m2repository"  

#Defining Home Folder
ENV APP_HOME /apphome
RUN mkdir $APP_HOME

WORKDIR $APP_HOME