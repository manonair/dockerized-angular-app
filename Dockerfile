FROM node:12.12.0-alpine as node

# maintainer email Config
MAINTAINER My Name  "manonair20@gmail.com"

# stage 1 build step
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

RUN npm run build 

# Stage 2 - Prod set up
FROM nginx:1.17.4-alpine
COPY --from=node /app/dist/dockerized-angular-app /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# health check Config

#HEALTHCHECK --interval=5s \
 #           --timeout=5s \
 #           CMD curl -f http://127.0.0.1:80|| exit 1
