# The MIT License (MIT)
#
# Copyright (c) 2018 Vente-Privée
#
# Permission is hereby granted, free of  charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction,  including without limitation the rights
# to use,  copy, modify,  merge, publish,  distribute, sublicense,  and/or sell
# copies  of the  Software,  and to  permit  persons to  whom  the Software  is
# furnished to do so, subject to the following conditions:
#
# The above  copyright notice and this  permission notice shall be  included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE  IS PROVIDED "AS IS",  WITHOUT WARRANTY OF ANY  KIND, EXPRESS OR
# IMPLIED,  INCLUDING BUT  NOT LIMITED  TO THE  WARRANTIES OF  MERCHANTABILITY,
# FITNESS FOR A  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT SHALL THE
# AUTHORS  OR COPYRIGHT  HOLDERS  BE LIABLE  FOR ANY  CLAIM,  DAMAGES OR  OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM golang:alpine

ENV TZ="Europe/Amsterdam"

# Add missing git
RUN apk update && \
    apk upgrade && \
    apk add git

# Install
RUN mkdir -p /go/src/github.com/veepee-moc/ && cd /go/src/github.com/veepee-moc/ && \
    git clone https://github.com/nalsas/influxdb-relay && cd influxdb-relay && git checkout dev && \
    go get github.com/veepee-moc/influxdb-relay && \
    mv /go/bin/influxdb-relay /usr/bin/influxdb-relay && \
    chmod 755 /usr/bin/influxdb-relay && \
    mkdir /etc/influxdb-relay && \
    touch /etc/influxdb-relay/influxdb-relay.conf && \
    mkdir -p /var/log/influxdb-relay && \
    chmod 755 /usr/bin/influxdb-relay

# Clean
RUN rm -fr /go/src/github.com && \
    apk del git

ENTRYPOINT [ "/usr/bin/influxdb-relay" ]

CMD [ "-config", "/etc/influxdb-relay/influxdb-relay.conf", "2>/var/log/influxdb-relay/influxdb-relay.log"]
# EOF
