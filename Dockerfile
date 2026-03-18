FROM nginx:alpine

# Remove default nginx page
RUN rm /usr/share/nginx/html/*

# Copy our app
COPY app/index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]