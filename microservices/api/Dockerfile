FROM swift:3.1.0

RUN apt-get update
RUN apt-get install -y openssl libssl-dev uuid-dev

WORKDIR /swift-perfect
ADD swift-perfect /swift-perfect
RUN swift build

CMD .build/debug/swift-perfect
