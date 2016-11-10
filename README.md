# nginx-consul Docker Image

An extenable docker image that runs Nginx with its configuration driven by
Consul via [Consul-Template][1].

This is meant to act as a base image, and therefore only manages settings for
the main (global) and http contexts.  Server/location contexts and deeper
configuration should be managed in derived images.

## Environment variables
Use `NGINX_CONF_KEY` to set the key prefix where the Nginx configuration will
be found in Consul. If not set, `nginx` will be used.

The `NGINX_CONF_COMMON_KEY` can be used in the same manner as `NGINX_CONF_KEY`
above. Settings found in the `NGINX_CONF_COMMON_KEY` will be rendered before
those found in `NGINX_CONF_KEY`, the idea being global/common settings can be
shared between multiple nginx instances, and overridden when necessary.

You must set `CONSUL_HTTP_ADDR` in order for consul-template to render
any templates when the container runs. Any supported consul-template environment
variables can be used, such as:

- CONSUL_HTTP_ADDR
- CONSUL_HTTP_TOKEN
- CONSUL_HTTP_AUTH
- CONSUL_HTTP_SSL
- CONSUL_HTTP_SSL_VERIFY

The following environment variables can be used to adjust consul-template:

- CONSUL_TEMPLATE_LOG_LEVEL - defaults to `err`
- CONSUL_TEMPLATE_EXEC_KILL_TIMEOUT - defaults to `30s`
- CONSUL_TEMPLATE_EXEC_SPLAY - defaults to `5s`

See the consul-template [documentation][1] for details about these settings.

## Supported Consul keys
- `<NGINX_CONF_KEY>/main/*` - any valid main context directives
- `<NGINX_CONF_KEY>/http/*` - any valid http context directives
- `<NGINX_CONF_KEY>/http/log_format/*` - log_format name/configuration
- `<NGINX_CONF_KEY>/http/add_header/*` - add headers in http block

## Adding Site Configuration(s)
Any file added to `/etc/nginx/templates` will be automatically registered
as a template for consul-template when the container runs.

Additional Nginx customizations can be made by adding .conf files to
`/etc/nginx/conf.d`. These files will not be rendered by consul-template.

For additional control over the configuration of consul-template, valid HCL
or JSON consul-template config(s) can be added to `/etc/consul-template.d`.


[1]: https://github.com/hashicorp/consul-template
