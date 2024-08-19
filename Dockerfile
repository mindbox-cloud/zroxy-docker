FROM alpine:latest as builder

RUN apk add --update alpine-sdk git cmake make

WORKDIR /source

RUN git clone https://github.com/0x7a657573/zroxy.git . \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make 

FROM alpine:latest

ARG USER=app
ARG HOME=/app

ENV PATH=$PATH:/app

RUN adduser -h $HOME -D $USER

USER $USER
WORKDIR $HOME

COPY --from=builder /source/build/zroxy .
ADD --chown=app:app ./zroxy.conf .

CMD zroxy -c /app/zroxy.conf