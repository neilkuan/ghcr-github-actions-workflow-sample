FROM public.ecr.aws/nginx/nginx:stable
LABEL Name 'Neil Kuan'
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf
ENV NGINX_PORT=3000
COPY --chmod=755 entrypoint.bash /entrypoint.bash
EXPOSE ${NGINX_PORT} 
ENTRYPOINT ["/entrypoint.bash"]