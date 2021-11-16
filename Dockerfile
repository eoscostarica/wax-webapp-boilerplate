FROM node:12.16.2-alpine  as build-stage

ARG react_app_tag
ARG react_app_name
ARG react_app_title
ARG react_app_logo
ARG react_app_footer_links
ARG react_app_wax_app_name
ARG react_app_wax_api_protocol
ARG react_app_wax_api_host
ARG react_app_wax_api_port
ARG react_app_wax_chain_id
ARG react_app_hasura_url

ENV WORK_DIR /usr/src/app
ENV PATH $WORK_DIR/node_modules/.bin:$PATH
ENV NODE_ENV production
ENV NODE_PATH ./src
ENV REACT_APP_TAG $react_app_tag
ENV REACT_APP_NAME $react_app_name
ENV REACT_APP_TITLE $react_app_title
ENV REACT_APP_LOGO $react_app_logo
ENV REACT_APP_FOOTER_LINKS $react_app_footer_links
ENV REACT_APP_WAX_APP_NAME $react_app_wax_app_name
ENV REACT_APP_WAX_API_PROTOCOL $react_app_wax_api_protocol
ENV REACT_APP_WAX_API_HOST $react_app_wax_api_host
ENV REACT_APP_WAX_API_PORT $react_app_wax_api_port
ENV REACT_APP_WAX_CHAIN_ID $react_app_wax_chain_id
ENV REACT_APP_HASURA_URL $react_app_hasura_url
ENV TOOL_NODE_FLAGS --max_old_space_size=4096

RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

COPY ./ $WORK_DIR

RUN yarn install && yarn build

FROM nginx:1.17.10-alpine as run-stage

COPY --from=build-stage /usr/src/app/build /usr/share/nginx/html
COPY --from=build-stage /usr/src/app/compression.conf /etc/nginx/conf.d/compression.conf
COPY --from=build-stage /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

