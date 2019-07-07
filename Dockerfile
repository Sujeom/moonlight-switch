FROM sujeom/devkitpro:base AS environment-setup

COPY ./dependencies /home/builder/moonlight-switch/dependencies

RUN useradd -p $(openssl passwd -1 foobar) builder && \
source /etc/environment && \
echo | pacman -S --noconfirm switch-dev && \
chown -R builder:builder /home/builder/ && \
pacman -S fakeroot grep patch make \
switch-pkg-config devkitpro-pkgbuild-helpers \
switch-sdl2 switch-sdl2_gfx switch-sdl2_ttf switch-sdl2_image \
switch-libexpat switch-bzip2 switch-zlib \
switch-libopus switch-ffmpeg --noconfirm

USER builder

WORKDIR /home/builder/moonlight-switch

RUN cd dependencies && ./dependencies.sh

FROM environment-setup AS builder

USER root

COPY ./ /home/builder/moonlight-switch/
