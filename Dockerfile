FROM ezci/multi-display:latest

USER root

# Nginx ইন্সটল করা
RUN apt-get update && apt-get install -y nginx

# Nginx কনফিগারেশন (Render-এর জন্য পোর্ট ৮০ তে সেট করা)
RUN echo 'server {\n\
    listen 80;\n\
    location /screen1/ {\n\
        proxy_pass http://127.0.0;\n\
    }\n\
    location /screen2/ {\n\
        proxy_pass http://127.0.0;\n\
    }\n\
    location /screen3/ {\n\
        proxy_pass http://127.0.0;\n\
    }\n\
    location /screen4/ {\n\
        proxy_pass http://127.0.0;\n\
    }\n\
    location /screen5/ {\n\
        proxy_pass http://127.0.0;\n\
    }\n\
}' > /etc/nginx/sites-available/default

# ব্যাকগ্রাউন্ডে ডিসপ্লে এবং Nginx একসাথে চালু করা
CMD Xvfb :99 -screen 0 9600x1080x16 & \n\
    x11vnc -shared -forever -desktop "Display 1" -clip 1920x1080+0+0 -rfbport 5900 & \n\
    x11vnc -shared -forever -desktop "Display 2" -clip 1920x1080+1920+0 -rfbport 5901 & \n\
    x11vnc -shared -forever -desktop "Display 3" -clip 1920x1080+3840+0 -rfbport 5902 & \n\
    x11vnc -shared -forever -desktop "Display 4" -clip 1920x1080+5760+0 -rfbport 5903 & \n\
    x11vnc -shared -forever -desktop "Display 5" -clip 1920x1080+7680+0 -rfbport 5904 & \n\
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5900 --listen 6080 & \n\
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5901 --listen 6081 & \n\
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5902 --listen 6082 & \n\
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5903 --listen 6083 & \n\
    /usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5904 --listen 6084 & \n\
    service nginx start && tail -f /dev/null
