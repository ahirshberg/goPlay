FROM golang AS builder

WORKDIR /build

# Let's cache modules retrieval - those don't change so often
# Copy the code necessary to build the application
# You may want to change this to copy only what you actually need.
COPY . .

# Build the application
RUN CGO_ENABLED=0 go build -a -ldflags '-s' -o /program ./main.go

# Let's create a /dist folder containing just the files necessary for runtime.
# Create the minimal runtime image
FROM scratch

COPY --from=builder /program /program

CMD ["/program"]