FROM openjdk:8-jdk
LABEL maintainer="Paulo Gomes da Cruz Junior <paulushc@gmail.com>"

#Setting Android Compile SDK Version
ENV ANDROID_COMPILE_SDK="24"

#Setting Android Build Tools Version
ENV ANDROID_BUILD_TOOLS="24.0.3"

#Setting Android SDK Tools Version
ENV ANDROID_SDK_TOOLS="24.0.3"

#Setting Android Home Path
ENV ANDROID_HOME=/android-sdk-linux

#Setting SDK Tools Folder
RUN mkdir -p ${ANDROID_HOME}/

#Setting Android Platform Tools on Path 
ENV PATH="${PATH}:${HOME}/bin:${ANDROID_HOME}/platform-tools/bin:${ANDROID_HOME}/tools/bin"

#Setting Gradle folder
RUN mkdir -p /gradle/

#Setting gradle on path
ENV GRADLE_HOME=/gradle/gradle-2.14.1
ENV PATH="${PATH}:${HOME}/bin:${GRADLE_HOME}/bin"

#Download and prepare all the android SDK stuff
RUN wget --quiet --output-document=/gradle/gradle.zip https://services.gradle.org/distributions/gradle-2.14.1-all.zip
RUN unzip /gradle/gradle.zip -d /gradle/
RUN rm -f /gradle/gradle.zip

##Running Required Updates
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1

#Download and prepare all the android SDK stuff
RUN wget --quiet --output-document=${ANDROID_HOME}/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
RUN unzip ${ANDROID_HOME}/android-sdk.zip -d ${ANDROID_HOME}/
RUN mkdir -p /root/.android/
RUN touch /root/.android/repositories.cfg

#Install dependencies
RUN yes | sdkmanager --licenses
RUN yes | sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}"
RUN yes | sdkmanager "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}"
RUN yes | sdkmanager "platform-tools" "extras;google;m2repository"
RUN yes | sdkmanager "platform-tools" "extras;google;google_play_services"
RUN yes | sdkmanager "platform-tools" "extras;android;m2repository"  

#Defining Home Folder
ENV APP_HOME /apphome
RUN mkdir $APP_HOME

WORKDIR $APP_HOME/
