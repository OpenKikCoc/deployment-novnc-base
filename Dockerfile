FROM alpine:latest

ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    HOMEPAGE=/usr/share/novnc

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" \
    >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community/" \
    >> /etc/apk/repositories && \
    # Deps
    apk update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
        bash \
        xterm \
        fluxbox \
        supervisor \
        xvfb \
        x11vnc \
        novnc && \
    ln -s /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html && \
    echo \
        "\
        [supervisord]                                                                       \
        nodaemon=true                                                                       \
        logfile=/var/log/supervisord.log                                                    \
                                                                                            \
        [program:X11]                                                                       \
        command=Xvfb :0 -screen 0 \"%(ENV_DISPLAY_WIDTH)s\"x\"%(ENV_DISPLAY_HEIGHT)s\"x24   \
        autorestart=true                                                                    \
                                                                                            \
        [program:x11vnc]                                                                    \
        command=/usr/bin/x11vnc                                                             \
        autorestart=true                                                                    \
                                                                                            \
        [program:websockify]                                                                \
        command=websockify --web=\"%(ENV_HOMEPAGE)s\" 10000 localhost:5900                  \
        autorestart=true                                                                    \
                                                                                            \
        [program:fluxbox]                                                                   \
        command=fluxbox                                                                     \
        autorestart=true" | sed 's/   */\n/g' > "/etc/supervisord.conf"

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]    