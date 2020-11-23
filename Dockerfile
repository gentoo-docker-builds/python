# ------------------- builder stage
FROM ghcr.io/gentoo-docker-builds/gendev:latest as builder

# ------------------- emerge
RUN emerge -C sandbox
COPY portage/python.accept_keywords /etc/portage/package.accept_keywords/python
RUN ROOT=/python FEATURES='-usersandbox' emerge python

# ------------------- shrink
RUN ROOT=/python emerge --quiet -C \
      app-admin/*\
      sys-apps/* \
      sys-kernel/* \
      virtual/* \
      sys-libs/ncurses

# ------------------- empty image
FROM scratch
COPY --from=builder /python /
