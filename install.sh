yum install epel-release -y
yum update
yum install ocserv gnutls-utils
mkdir /etc/ocserv/cert
cd /etc/ocserv/cert/

cat <<EOT >> ca.tmpl
cn = "VPN CA"
organization = "Big Corp"
serial = 1
expiration_days = -1
ca
signing_key
cert_signing_key
crl_signing_key
EOT

certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem

cat <<EOT >> /etc/ocserv/server.tmpl
cn = "My server"
dns_name = "www.example.com"
organization = "MyCompany"
expiration_days = -1
signing_key
encryption_key
tls_www_server
EOT

certtool --generate-privkey --outfile server-key.pem
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template /etc/ocserv/server.tmpl --outfile server-cert.pem

mkdir /etc/ocserv/ssl/
cp ca-cert.pem server-key.pem server-cert.pem /etc/ocserv/ssl/
