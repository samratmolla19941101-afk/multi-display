FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# প্রয়োজনীয় সব টুলস এবং নোভিএনসি (noVNC) ইন্সটল করা
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    nginx \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Nginx-কে নোভিএনসি (noVNC) এর মূল ডিরেক্টরির সাথে সরাসরি ম্যাপ করা
RUN echo 'server {\n\
    listen 80;\n\
    root /usr/share/novnc;\n\
    index vnc.html;\n\
    location / {\n\
        try_files $uri $uri/ =404;\n\
    }\n\
    location /websockify {\n\
        proxy_pass http://127.0.0.1:6080;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "Upgrade";\n\
    }\n\
}' > /etc/nginx/sites-available/default

EXPOSE 80

# Xvfb ফ্রেমবাফার, ভিএনসি এবং নোভিএনসি সঠিকভাবে পোর্ট ৬০৮০ তে রান করা
CMD Xvfb :1 -screen 0 1280x720x16 & \
    sleep 2 && \
    fluxbox -display :1 & \
    sleep 2 && \
    x11vnc -display :1 -shared -forever -rfbport 5901 -nopw & \
    sleep 2 && \
    websockify --web /usr/share/novnc 6080 1280x720 --vnc localhost:5901 & \
    sleep 2 && \
    nginx -g "daemon off;"
