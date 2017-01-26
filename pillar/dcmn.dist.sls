# If running on VirtialBox -> assume vagrant
{% if grains['virtual'] == 'VirtualBox' %}
  {%- set user = "vagrant" %}
{% else %}
  {%- set user = grains['os'].lower() %}
{% endif %}

dcmn:
  user:  {{ user }}
  group: {{ user }}
  alert:
    email: sys-alert@dcmn.com
  ssh:
    deploy:
      public: |
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCs1QvF7DteXf1ru42dsfSgCSH0A1wS5RfDeFHirPMxAu0bsw6MvfaOlA/woCKF7987E/wSi+4J5qC061SQCrIZE/E+cwH8qlcpT6bribp32SuWZLrCMCrmczayFXei0oRjThp5Z22pDKWTfOxNEs16toBmUW6bKzHJDFVyU2cC+5P/3pUEsrFRwTx/4EQjGEcWDBNR0g6t3IYNGZgNRZXaQJ8eza6M4F7STGVQKZ+h3rLTf20dlI3G3r/zCoHngzgor/G76SkGrWeo/bpzO56yrhoTyTFt1Z/K6w1YQ5+KOBkA0vQ6+ipu2Z5CxbVFKQvft7h4YXI91PhrKArwldjVdTlMohh2H+nHATPaLL+llbLMaF8XilIze7KCULLh6KIXwHAeEP793/c+SvGerAPPF65Z/GsLJNTIGNNh0jNOclEC6LVA9RLYCdmDxxbyo30mlMTy7ceKBJfYSSfg4YS+OKzTuvbv21dBuAaAJOaWkBKre70JnJf+9hKkFkgCy4V/STB5cGBKGIIzD9tTFFukuw/vED4BtW3QSZTpBSmxBv4qWVvDz1o8MeCOwdgvWoFkQBDK0QaYkobBYnLeRLQScxwbUMXvuFXVfRuiMj5TpG2qjMsM/zMxir2/B3c/asbCXlXHo74gW2QibK8FKAx6A0/ql5N7UyE8zfYZEFw7kQ== it-ci@dcmn.com
      private: |
        -----BEGIN RSA PRIVATE KEY-----
        PRIVATE DEPLOY KEY HERE
        -----END RSA PRIVATE KEY-----
