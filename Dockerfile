# Use NodeJS base image
FROM node:13 as build

# Create app directory
WORKDIR /app

# Install app dependencies by copying
# package.json and package-lock.json
COPY package*.json /app/

# Install dependencies
RUN npm install -g ionic
RUN npm install

# Copy app source
COPY ./ /app/
RUN ionic build --prod

FROM nginx:alpine
ARG mode
RUN echo "Running nginx $mode"
RUN rm -rf /usr/share/nginx/html/*
COPY "$mode.conf" /etc/nginx/conf.d/default.conf
COPY --from=build /app/www/ /usr/share/nginx/html/
