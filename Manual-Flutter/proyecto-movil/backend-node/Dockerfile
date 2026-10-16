FROM node:24-slim
WORKDIR /app
COPY package.json package-lock.json ./
RUN --mount=type=secret,id=windows_ca \
    if [ -f /run/secrets/windows_ca ]; then export NODE_EXTRA_CA_CERTS=/run/secrets/windows_ca; fi; \
    npm ci --omit=dev --no-audit
COPY src ./src
COPY openapi.json ./openapi.json
USER node
EXPOSE 8000
CMD ["node", "src/server.js"]
