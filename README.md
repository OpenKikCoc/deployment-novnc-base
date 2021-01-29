# deployment-novnc-base
Docker deployment for noVNC-base.

## 0. Prepare

1.  Docker env.

2.  Config the Dockerfile such as:

    ```Dockerfile
    FROM binacslee/novnc-base

    # The env you can modify
    ENV HOME=/root \
        DEBIAN_FRONTEND=noninteractive \
        DISPLAY=:0.0 \
        DISPLAY_WIDTH=1024 \
        DISPLAY_HEIGHT=768 \
        HOMEPAGE=/usr/share/novnc

    # The application you need
    RUN \
        apk add APPNAME && \
        echo \
        "\
        [program:APPNAME]                               \
        command=APPNAME $ARGS \"%(ENV_VALUENAME)s\"     \
        autorestart=true" | sed 's/   */\n/g' >> "/etc/supervisord.conf"

    CMD ["foo-bar", "$ARGS"]
    ```

3.  Build images:

    ```sh
    build -t foo/bar:tag .
    ```

4.  Use:

    Visit: http://localhost:10000
    

