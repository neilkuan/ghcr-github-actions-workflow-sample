FROM public.ecr.aws/nginx/nginx:stable
LABEL Name 'Neil Kuan'
LABEL org.opencontainers.image.source "https://github.com/neilkuan/ghcr-github-actions-workflow-sample"
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf
ENV NGINX_PORT=3000
ENV ENV=staging
COPY --chmod=755 entrypoint.bash /entrypoint.bash
EXPOSE ${NGINX_PORT} 
ENTRYPOINT ["/entrypoint.bash"]
