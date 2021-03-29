ARG BASE_IMAGE=renku/renkulab-py:latest
FROM ${BASE_IMAGE}

LABEL maintainer="Swiss Data Science Center <info@datascience.ch>"

USER root

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        dbus-x11 \
        firefox \
        net-tools \
        less \
        xfce4 \
        xfce4-panel \
        xfce4-session \
        xfce4-settings \
        xorg \
        xubuntu-icon-theme \
        xterm \
    && apt-get autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && find /var/log -type f -exec cp /dev/null \{\} \;

# Get noVNC
RUN cd /opt & \
    curl -sSfL https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -zxf -

# Patch novnc to use correct path to websockify (defaults to /)
# Note if you use vnc.html you will need to patch ui.js to use the correct path
# and also to override localstorage which may store an incorrect path from a
# different session. Also resize server instead of scaling client
RUN sed -i.bak \
    -e "s%\('path', 'websockify'\)%'path', window.location.pathname.replace(/[^/]*$/, '').substring(1) + 'websockify'); console.log('websockify path:' + path%" \
    -re "s%rfb.scaleViewport = .+%rfb.resizeSession = readQueryVariable('resize', true);%" \
    /opt/noVNC-1.1.0/vnc_lite.html

# Install tigervnc to /usr/local
RUN curl -sSfL 'https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.9.0.x86_64.tar.gz' | tar -zxf - -C /usr/local --strip=2

# Install the jupyter extensions
USER ${NB_USER}

RUN conda install jupyter-server-proxy numpy websockify -c conda-forge \
    && jupyter labextension install @jupyterlab/server-proxy \
    && conda clean -y --all 

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

