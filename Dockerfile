FROM ubuntu:xenial
MAINTAINER Felix Seidel <felix@seidel.me>

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TZ "Europe/Berlin"
ENV SELENIUM_MAJOR_VERSION 3.0
ENV SELENIUM_COMPLETE_VERSION 3.0.1
ENV CHROMEDRIVER_VERSION 2.27
ENV SCREEN_GEOMETRY "1440x900x24"
ENV SELENIUM_PORT 4444
ENV DISPLAY :0.0

RUN apt-get update && \
    apt-get -y --no-install-recommends install language-pack-en ca-certificates curl dnsutils man openssl unzip wget xvfb fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic fluxbox x11vnc supervisor openjdk-8-jre-headless net-tools xterm git chromium-browser libgconf-2-4 ffmpeg && \
    locale-gen en_US.UTF-8 && \
    echo 'Europe/Berlin' > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive locales tzdata && \
    mkdir -p ~/.vnc /var/log/supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/selenium && \
    wget --no-verbose -O /opt/selenium/selenium-server-standalone-${SELENIUM_COMPLETE_VERSION}.jar http://selenium-release.storage.googleapis.com/${SELENIUM_MAJOR_VERSION}/selenium-server-standalone-${SELENIUM_COMPLETE_VERSION}.jar && \
    ln -fs /opt/selenium/selenium-server-standalone-${SELENIUM_COMPLETE_VERSION}.jar /opt/selenium/selenium-server-standalone.jar

RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip && \
    mkdir -p /opt/chromedriver-${CHROMEDRIVER_VERSION} && \
    unzip /tmp/chromedriver_linux64.zip -d /opt/chromedriver-${CHROMEDRIVER_VERSION} && \
    chmod +x /opt/chromedriver-${CHROMEDRIVER_VERSION}/chromedriver && \
    rm /tmp/chromedriver_linux64.zip && \
    ln -fs /opt/chromedriver-${CHROMEDRIVER_VERSION}/chromedriver /usr/local/bin/chromedriver

RUN x11vnc -storepasswd selenium ~/.vnc/passwd && \
    useradd selenium --shell /bin/bash --create-home && \
    echo "#!/bin/bash\nexec /usr/bin/chromium-browser --no-sandbox \"\$@\"" > /usr/bin/google-chrome && \
    chmod 755 /usr/bin/google-chrome

RUN temp="$(mktemp -d)" && \
    cd "$temp" && \
    wget https://github.com/kanaka/noVNC/archive/v0.6.1.zip && \
    unzip v0.6.1.zip && \
    mv noVNC-0.6.1 /usr/local/share/novnc && \
    sed -i "s/'password', ''/'password', 'selenium'/i" /usr/local/share/novnc/vnc_auto.html && \
    cp /usr/local/share/novnc/vnc_auto.html /usr/local/share/novnc/index.html && \
    chown -R selenium:selenium /usr/local/share/novnc && \
    cd / && \
    rm -rf "$temp"

ADD ./etc/supervisor/conf.d /etc/supervisor/conf.d

EXPOSE 4444 5900 6080
VOLUME ["/logs"]

CMD ["/docker-entrypoint.sh"]
