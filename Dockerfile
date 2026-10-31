FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# প্রয়োজনীয় সব টুলস ও Nginx ইন্সটল করা
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    nginx \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Nginx কনফিগারেশন সেটআপ (ডিফল্ট পেজ এড়াতে সরাসরি নোভিএনসি রুটে প্রক্সি করা)
RUN echo 'server {\n\
    listen 80;\n\
    location /screen1/ {\n\
        proxy_pass http://127.0.0;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "Upgrade";\n\
    }\n\
    location /screen2/ {\n\
        proxy_pass http://127.0.0;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "Upgrade";\n\
    }\n\
    location /screen3/ {\n\
        proxy_pass http://127.0.0;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "Upgrade";\n\
    }\n\
    location /screen4/ {\n\
        proxy_pass http://127.0.0;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "Upgrade";\n\
    }\n\
    location /screen5/ {\n\
        proxy_pass http://127.0.0;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "Upgrade";\n\
    }\n\
}' > /etc/nginx/sites-available/default

EXPOSE 80

# ১টি আল্ট্রা-ওয়াইড মনিটর চালু করে সরাসরি /usr/share/novnc/ থেকে সার্ভিস রান করা
CMD Xvfb :1 -screen 0 6400x720x16 & \
    sleep 2 && \
    fluxbox -display :1 & \
    sleep 2 && \
    x11vnc -display :1 -shared -forever -rfbport 5901 -nopw & \
    sleep 2 && \
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5901 --listen 6080 --web /usr/share/novnc & \
    sleep 2 && \
    nginx -g "daemon off;"
