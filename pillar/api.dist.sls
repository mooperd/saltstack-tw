api:
  display_not_found_reason: 0    # 0 for production & staging else 1
  display_exceptions:       0    # 0 for production & staging else 1
  mysql:
    rw:
      host:     XXXXXXX.eu-west-1.rds.amazonaws.com
      port:     3306
      username: "???"
      password: "???"
      dbname:   piwik
    ro:
      host:     XXXXXXX.eu-west-1.rds.amazonaws.com
      port:     3306
      username: "???"
      password: "???"
      dbname:   piwik
