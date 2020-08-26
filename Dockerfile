# ------------------- builder stage
FROM gentoo/stage3-amd64 as builder
ENV FEATURES="-mount-sandbox -ipc-sandbox -network-sandbox -pid-sandbox -usersandbox"

# ------------------- portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# ------------------- emerge
RUN emerge -C sandbox
RUN echo 'dev-lang/* ~amd64' >> /etc/portage/package.accept_keywords/zz-autounmask
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
