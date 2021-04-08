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
        gnome-terminal \
        ttf-dejavu \
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

RUN curl -sSfL https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-${tigervnc_version}.x86_64.tar.gz | tar -zxf - -C /usr/local --strip=2

#################################################################
# Install the jupyter extensions
USER ${NB_USER}

RUN conda install jupyter-server-proxy numpy websockify -c conda-forge \
    && jupyter labextension install @jupyterlab/server-proxy \
    && conda clean -y --all 

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

COPY post-init.sh /post-init.sh

