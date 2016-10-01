# nginx-consul Docker Image

An extenable docker image that runs Nginx with its configuration driven by
Consul via Consul-Template.

## Environment variables
Use `NGINX_CONFIG_KEY` to set the key prefix where the Nginx configuration will
be found in Consul. If not set, `nginx` will be used.

Also, you must set `CONSUL_HTTP_ADDR` in order for consul-template to render
any templates when the container runs. Any supported consul-template environment
variables can be used, such as:

- CONSUL_HTTP_ADDR
- CONSUL_HTTP_TOKEN
- CONSUL_HTTP_AUTH
- CONSUL_HTTP_SSL
- CONSUL_HTTP_SSL_VERIFY

## Supported Consul keys
- `<config_key>/main/*` - any valid main context directives
- `<config_key>/http/*` - any valid http context directives
- `<config_key>/http/log_format/*` - log_format name/configuration

## Adding Site Configuration(s)
Any file added to `/etc/nginx/templates` will be automatically registered when
as a template for consul-template.

Additional Nginx customizations can be made by adding .conf files to
`/etc/nginx/conf.d`. These files will not be rendered by consul-template.

For additional control over the configuration of consul-template, valid HCL
or JSON consul-template config(s) can be added to `/etc/consul-template.d`.
