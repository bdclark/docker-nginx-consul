exec {
  command = "/usr/sbin/nginx"
  splay = "5s"
  reload_signal = "SIGHUP"
  kill_signal = "SIGQUIT"
  kill_timeout = "30s"
}

log_level = "error"
