FROM golang:1.13.0-stretch AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=1

WORKDIR /build

# Let's cache modules retrieval - those don't change so often

# Copy the code necessary to build the application
# You may want to change this to copy only what you actually need.
COPY . .

# Build the application
RUN go build ./main.go
# Let's create a /dist folder containing just the files necessary for runtime.
# Later, it will be copied as the / (root) of the output image.
WORKDIR /dist
RUN cp /build/main ./main

# Create the minimal runtime image
FROM scratch

COPY --chown=0:0 --from=builder /dist /

USER 65534
WORKDIR /

ENTRYPOINT ["/main"]