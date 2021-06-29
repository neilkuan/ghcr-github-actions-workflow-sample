FROM public.ecr.aws/nginx/nginx:stable
LABEL Name 'Neil Kuan' 
LABEL Version 1.0.0
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]