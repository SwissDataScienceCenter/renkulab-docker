ARG BASE_IMAGE=renku/renkulab-py:3.8-0.7.5
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
        gnome-terminal \
        ttf-dejavu \
        git-gui \
        gitk \
        emacs \
    && apt-get autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && find /var/log -type f -exec cp /dev/null \{\} \;

#################################################################
# Install noVNC

ENV novnc_version=1.1.0

RUN cd /opt && \
    curl -sSfL https://github.com/novnc/noVNC/archive/v${novnc_version}.tar.gz | tar -zxf -

RUN sed -i -e "s,'websockify',window.location.pathname.slice(1),g" /opt/noVNC-${novnc_version}/app/ui.js \
    && chmod a+rX -R /opt/noVNC-${novnc_version}

COPY --chown=root:root vnc_renku.html /opt/noVNC-${novnc_version}

#################################################################
# Install TigerVNC

ENV tigervnc_version=1.9.0

RUN curl -sSfL https://github.com/accetto/tigervnc/releases/download/v${tigervnc_version}-mirror/tigervnc-${tigervnc_version}.x86_64.tar.gz | tar -zxf - -C /usr/local --strip=2

#################################################################
# Add desktop icons

COPY Git-GUI.desktop /home/jovyan/Desktop/
RUN chmod +x /home/jovyan/Desktop/Git-GUI.desktop

COPY gitk.desktop /home/jovyan/Desktop/
COPY .git_icon.png /home/jovyan/Desktop/
RUN chmod +x /home/jovyan/Desktop/gitk.desktop

#################################################################
# Add wallpaper and force the default to point to the renku one

RUN mkdir -p /usr/share/backgrounds/renku/
COPY renku_background_dots.png /usr/share/backgrounds/renku/
RUN ln -s -f /usr/share/backgrounds/renku/renku_background_dots.png /usr/share/backgrounds/xfce/xfce-stripes.png

#################################################################
# Install the jupyter extensions
USER ${NB_USER}

RUN conda install jupyter-server-proxy numpy websockify -c conda-forge \
    && jupyter labextension install @jupyterlab/server-proxy \
    && conda clean -y --all 

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

COPY post-init.sh /post-init.sh
