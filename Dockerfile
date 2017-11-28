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

#Setting Gradle folder
RUN mkdir -p /gradle/

#Download and prepare all the android SDK stuff
RUN wget --quiet --output-document=/gradle/gradle.zip https://services.gradle.org/distributions/gradle-4.3.1-bin.zip
RUN unzip /gradle/gradle.zip -d /gradle/
RUN rm -f /gradle/gradle.zip

#Setting gradle on path
ENV GRADLE_HOME=/gradle/gradle-4.3.1
ENV PATH="${PATH}:${HOME}/bin:${GRADLE_HOME}/bin"

#Running Required Updates
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1

#Download and prepare all the android SDK stuff
RUN wget --quiet --output-document=/android-sdk-linux/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
RUN unzip /android-sdk-linux/android-sdk.zip -d /android-sdk-linux/

#Install dependencies
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}"
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}"
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "extras;google;m2repository"
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "extras;google;google_play_services"
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "extras;android;m2repository"  

#Install Emulator Dependencies
ENV EMULATOR_HOME=/android-emulator
ENV PATH="${PATH}:${EMULATOR_HOME}"

RUN mkdir -p ${EMULATOR_HOME}/
RUN wget --quiet --output-document=${EMULATOR_HOME}/android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
RUN chmod +x ${EMULATOR_HOME}/android-wait-for-emulator
RUN echo y | ${ANDROID_HOME}/tools/android --silent update sdk --no-ui --all --filter sys-img-x86-google_apis-${ANDROID_COMPILE_SDK}
RUN echo no | ${ANDROID_HOME}/tools/android create avd -n test -t android-${ANDROID_COMPILE_SDK} --abi google_apis/x86

#Defining Home Folder
ENV APP_HOME /apphome
RUN mkdir $APP_HOME

WORKDIR $APP_HOME