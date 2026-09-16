"""gunicorn, bound to this machine only. Caddy is the only thing that reaches it."""

bind = "127.0.0.1:8000"
workers = 3
threads = 2
timeout = 30
graceful_timeout = 30
keepalive = 5

# Caddy writes the access log, and it writes no addresses. gunicorn writes
# errors only, so nothing about a visitor is recorded twice or at all.
accesslog = None
errorlog = "-"
loglevel = "info"

proc_name = "legislativedata"
