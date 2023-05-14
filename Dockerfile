FROM mcr.microsoft.com/cbl-mariner/base/nodejs:18 AS BASE

WORKDIR /app

COPY src/* ./

# Install app dependencies
# which generates application artifacts needed to run the app
RUN npm install

# Install nodejs and its dependencies into a staging location
# Staging directory is copied into the final distroless image
RUN mkdir /staging \
    && tdnf install -y --releasever=2.0 --installroot /staging nodejs \
    && tdnf clean all \
    && rm -rf /staging/etc/dnf \
    && rm -rf /staging/run/* \
    && rm -rf /staging/var/cache/dnf \
    && find /staging/var/log -type f -size +0 -delete

FROM mcr.microsoft.com/cbl-mariner/distroless/minimal:2.0 AS FINAL

# Copy application build artifacts into the distroless container
COPY --from=BASE /app .

# Copy runtime dependencies into the distroless container
COPY --from=BASE /staging/ .

# Set the startup command for nodejs application
CMD [ "npm", "run", "start" ]
