# Use nginx to serve the Flutter web app
FROM nginx:alpine

# Copy the built web files to nginx html directory
COPY build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
