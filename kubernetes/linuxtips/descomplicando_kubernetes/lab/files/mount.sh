#!/bin/sh
install -D -m 0755 /dev/stderr /etc/local.d/10-mount.start 2<<-EOF
#!/bin/sh
mount --make-rshared /
EOF