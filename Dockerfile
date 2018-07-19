FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y xvfb build-essential gnome-common valac libglib2.0-dev libgtk-3-dev \
    libgee-0.8-dev libjson-glib-dev libsoup2.4-dev libvte-2.91-dev

RUN apt-get install -y libxext-dev libxrender-dev libxtst-dev

RUN mkdir /dockery

WORKDIR /dockery

ENV NO_AT_BRIDGE=1
ENV TRAVIS=true