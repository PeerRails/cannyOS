#!/usr/bin/env just --justfile

_default:
  just --list -u

# Download MinCifri Certs to git
download_mc_certs:
    wget https://gu-st.ru/content/lending/russian_trusted_root_ca_pem.crt -O files/ssl/russian_trusted_root_ca_pem.crt
    wget https://gu-st.ru/content/lending/russian_trusted_sub_ca_pem.crt -O files/ssl/russian_trusted_sub_ca_pem.crt

# Runs ansible-lint against all roles in the playbook
lint:
    ansible-lint
