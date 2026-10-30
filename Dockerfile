FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# প্রয়োজনীয় সব টুলস ও Nginx ইন্সটল করা
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    nginx \
    fluxbox \
    &> /dev/null

# NoVNC এর জন্য লিঙ্ক ফাইল ঠিক করা
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Nginx কনফিগারেশন সেটআপ (পোর্ট ৮০ তে)
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

# ব্যাকগ্রাউন্ডে ৫টি সম্পূর্ণ আলাদা ডিসপ্লে ও নোভিএনসি রান করা
CMD Xvfb :1 -screen 0 1920x1080x16 & \
    Xvfb :2 -screen 0 1920x1080x16 & \
    Xvfb :3 -screen 0 1920x1080x16 & \
    Xvfb :4 -screen 0 1920x1080x16 & \
    Xvfb :5 -screen 0 1920x1080x16 & \
    sleep 2 && \
    x11vnc -display :1 -shared -forever -rfbport 5901 & \
    x11vnc -display :2 -shared -forever -rfbport 5902 & \
    x11vnc -display :3 -shared -forever -rfbport 5903 & \
    x11vnc -display :4 -shared -forever -rfbport 5904 & \
    x11vnc -display :5 -shared -forever -rfbport 5905 & \
    sleep 2 && \
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5901 --listen 6080 & \
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5902 --listen 6081 & \
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5903 --listen 6082 & \
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5904 --listen 6083 & \
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5905 --listen 6084 & \
    service nginx start && tail -f /dev/null
