FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
ENV PORT=4000 NODE_ENV=production
COPY --from=build /app/dist/cl-client /app/dist/cl-client
EXPOSE 4000
USER node
CMD ["node", "dist/cl-client/server/server.mjs"]
