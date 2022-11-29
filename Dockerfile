### STAGE 1: Build ###
FROM node:lts-alpine AS build
WORKDIR /usr/src/app
COPY . .
RUN npm ci && npm run build


### STAGE 2: Deploy ###
FROM nginx:alpine
COPY --from=build /usr/src/app/dist/frontend /usr/share/nginx/html
COPY ./nginx.default.conf /etc/nginx/conf.d/default.conf
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]

# docker build -t demo-frontend-angular .
# docker run -d --name demo-frontend-angular -p 4200:80 --network microservicios demo-frontend-angular
